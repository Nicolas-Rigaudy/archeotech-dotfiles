import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "components"

Item {
    id: root
    anchors.fill: parent

    property real panelHeight: panel.height

    // ── State ──────────────────────────────────────────────────────────────────

    property string nightLightMode: "off"
    property string powerProfile: "balanced"
    property string displayLayout: "extend"
    property bool dndEnabled: false

    // Live status
    property int batteryPercent: 0
    property bool batteryCharging: false
    property string networkSsid: ""
    property bool networkConnected: false
    property int volumePercent: 0
    property bool volumeMuted: false
    property int micPercent: 0
    property bool micMuted: false
    property string bluetoothDevice: ""
    property bool bluetoothConnected: false
    property bool bluetoothEnabled: false

    // ── Shell runner ───────────────────────────────────────────────────────────

    Process {
        id: proc
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
    }

    function run(cmd) {
        proc.cmd = cmd
        proc.running = true
    }

    // ── Pollers ────────────────────────────────────────────────────────────────

    // Battery
    Process {
        id: batteryPoller
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0"]
        running: true
        stdout: SplitParser { onRead: data => root.batteryPercent = parseInt(data.trim()) || 0 }
    }
    Process {
        id: batteryStatusPoller
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Discharging"]
        running: true
        stdout: SplitParser { onRead: data => root.batteryCharging = data.trim() === "Charging" || data.trim() === "Full" }
    }
    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: { batteryPoller.running = true; batteryStatusPoller.running = true }
    }

    // Volume
    Process {
        id: volumePoller
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -1"]
        running: true
        stdout: SplitParser { onRead: data => root.volumePercent = parseInt(data.trim()) || 0 }
    }
    Process {
        id: volumeMutePoller
        command: ["bash", "-c", "pactl get-sink-mute @DEFAULT_SINK@ | grep -c 'yes' || echo 0"]
        running: true
        stdout: SplitParser { onRead: data => root.volumeMuted = data.trim() === "1" }
    }
    Process {
        id: micMutePoller
        command: ["bash", "-c", "pactl get-source-mute @DEFAULT_SOURCE@ | grep -c 'yes' || echo 0"]
        running: true
        stdout: SplitParser { onRead: data => root.micMuted = data.trim() === "1" }
    }
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: { volumePoller.running = true; volumeMutePoller.running = true; micMutePoller.running = true }
    }

    // Network
    Process {
        id: networkPoller
        command: ["bash", "-c", "nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var s = data.trim()
                root.networkSsid = s
                root.networkConnected = s.length > 0
            }
        }
    }
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: networkPoller.running = true
    }

    // Bluetooth
    Process {
        id: bluetoothPoller
        command: ["bash", "-c", "bluetoothctl info 2>/dev/null | grep -m1 'Alias:' | awk '{print $2}' || echo ''"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var d = data.trim()
                root.bluetoothDevice = d
                root.bluetoothConnected = d.length > 0
            }
        }
    }
    Process {
        id: bluetoothEnabledPoller
        command: ["bash", "-c", "bluetoothctl show 2>/dev/null | grep -c 'Powered: yes' || echo 0"]
        running: true
        stdout: SplitParser { onRead: data => root.bluetoothEnabled = data.trim() === "1" }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: { bluetoothPoller.running = true; bluetoothEnabledPoller.running = true }
    }

    // Initial state reads
    Process {
        id: profileReader
        command: ["bash", "-c", "powerprofilesctl get"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim()
                if (p === "performance" || p === "balanced" || p === "power-saver")
                    root.powerProfile = p
            }
        }
    }
    Process {
        id: nightLightReader
        command: ["bash", "-c", "[ -f $HOME/.cache/wlsunset.pid ] && kill -0 $(cat $HOME/.cache/wlsunset.pid) 2>/dev/null && grep -oP '(?<=-T )\\d+' /proc/$(cat $HOME/.cache/wlsunset.pid)/cmdline 2>/dev/null || echo off"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var t = data.trim()
                root.nightLightMode = (t === "4500" || t === "3500" || t === "2700") ? t : "off"
            }
        }
    }
    Process {
        id: dndReader
        command: ["bash", "-c", "swaync-client --get-dnd 2>/dev/null || echo false"]
        running: true
        stdout: SplitParser { onRead: data => root.dndEnabled = data.trim() === "true" }
    }

    // ── Panel ─────────────────────────────────────────────────────────────────

    Rectangle {
        id: panel
        width: 320
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 50
        anchors.rightMargin: 8
        height: contentColumn.implicitHeight + 24
        radius: 14
        color: "#1e2030"
        border.color: "#363a4f"
        border.width: 1

        ColumnLayout {
            id: contentColumn
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 16
                topMargin: 14
            }
            spacing: 10

            // ── Header ────────────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "󰒓  Settings"
                    color: "#cad3f5"
                    font.pixelSize: 14
                    font.family: "FiraCode Nerd Font"
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 36; height: 36
                    radius: 8
                    color: closeHover.containsMouse ? "#363a4f" : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: closeHover.containsMouse ? "#cad3f5" : "#6e738d"
                        font.pixelSize: 26
                        font.family: "FiraCode Nerd Font"
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }

                    MouseArea {
                        id: closeHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: controlCenterVisible = false
                    }
                }
            }

            // ── Status strip ──────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 8
                color: "#24273a"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 0

                    // Battery
                    RowLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Text {
                            text: root.batteryCharging ? "󰂄" : (root.batteryPercent > 80 ? "󰂂" : root.batteryPercent > 50 ? "󰁿" : root.batteryPercent > 20 ? "󰁼" : "󰁺")
                            color: root.batteryPercent <= 20 ? "#ed8796" : "#a6da95"
                            font.pixelSize: 14
                            font.family: "FiraCode Nerd Font"
                        }
                        Text {
                            text: root.batteryPercent + "%"
                            color: "#cad3f5"
                            font.pixelSize: 11
                            font.family: "FiraCode Nerd Font"
                        }
                    }

                    // Network
                    RowLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Text {
                            text: root.networkConnected ? "󰖩" : "󰖪"
                            color: root.networkConnected ? "#8aadf4" : "#6e738d"
                            font.pixelSize: 14
                            font.family: "FiraCode Nerd Font"
                        }
                        Text {
                            text: root.networkConnected ? root.networkSsid : "No network"
                            color: root.networkConnected ? "#cad3f5" : "#6e738d"
                            font.pixelSize: 11
                            font.family: "FiraCode Nerd Font"
                            elide: Text.ElideRight
                            Layout.maximumWidth: 80
                        }
                    }

                    // Bluetooth
                    RowLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Text {
                            text: root.bluetoothConnected ? "󰂱" : (root.bluetoothEnabled ? "󰂯" : "󰂲")
                            color: root.bluetoothConnected ? "#c6a0f6" : (root.bluetoothEnabled ? "#cad3f5" : "#6e738d")
                            font.pixelSize: 14
                            font.family: "FiraCode Nerd Font"
                        }
                        Text {
                            text: root.bluetoothConnected ? root.bluetoothDevice : (root.bluetoothEnabled ? "On" : "Off")
                            color: root.bluetoothConnected ? "#cad3f5" : "#6e738d"
                            font.pixelSize: 11
                            font.family: "FiraCode Nerd Font"
                            elide: Text.ElideRight
                            Layout.maximumWidth: 60
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#363a4f" }

            // ── AUDIO ─────────────────────────────────────────────────────────
            SectionHeader { label: "AUDIO" }

            // Volume
            Item {
                Layout.fillWidth: true
                height: 24

                Text {
                    id: volIcon
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.volumeMuted ? "󰖁" : (root.volumePercent > 66 ? "󰕾" : root.volumePercent > 33 ? "󰖀" : "󰕿")
                    color: root.volumeMuted ? "#6e738d" : "#cad3f5"
                    font.pixelSize: 16
                    font.family: "FiraCode Nerd Font"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            run("pactl set-sink-mute @DEFAULT_SINK@ toggle")
                            volumeMutePoller.running = true
                        }
                    }
                }

                Text {
                    id: volPct
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.volumePercent + "%"
                    color: "#6e738d"
                    font.pixelSize: 11
                    font.family: "FiraCode Nerd Font"
                    width: 32
                    horizontalAlignment: Text.AlignRight
                }

                Slider {
                    id: volumeSlider
                    anchors.left: volIcon.right
                    anchors.right: volPct.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8
                    anchors.rightMargin: 6
                    from: 0; to: 100
                    enabled: !root.volumeMuted

                    value: root.volumePercent

                    onMoved: run("pactl set-sink-volume @DEFAULT_SINK@ " + Math.round(value) + "%")

                    background: Rectangle {
                        x: volumeSlider.leftPadding
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: volumeSlider.availableWidth
                        height: 4
                        radius: 2
                        color: "#363a4f"

                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            radius: 2
                            color: root.volumeMuted ? "#6e738d" : "#c6a0f6"
                        }
                    }

                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: 14; height: 14
                        radius: 7
                        color: root.volumeMuted ? "#6e738d" : "#c6a0f6"
                    }
                }
            }

            // Microphone
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: root.micMuted ? "󰍭" : "󰍬"
                    color: root.micMuted ? "#ed8796" : "#cad3f5"
                    font.pixelSize: 16
                    font.family: "FiraCode Nerd Font"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            run("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
                            micMutePoller.running = true
                        }
                    }
                }

                Text {
                    text: "Microphone"
                    color: "#a5adcb"
                    font.pixelSize: 12
                    font.family: "FiraCode Nerd Font"
                    Layout.fillWidth: true
                }

                ToggleSwitch {
                    checked: !root.micMuted
                    onToggled: state => {
                        root.micMuted = !state
                        run(state ? "pactl set-source-mute @DEFAULT_SOURCE@ false" : "pactl set-source-mute @DEFAULT_SOURCE@ true")
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#363a4f" }

            // ── DISPLAY ───────────────────────────────────────────────────────
            SectionHeader { label: "DISPLAY" }

            Flow {
                Layout.fillWidth: true
                spacing: 6

                PillButton {
                    label: "Extend"
                    active: root.displayLayout === "extend"
                    onClicked: {
                        root.displayLayout = "extend"
                        run("wlr-randr --output eDP-1 --on --pos 0,0; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 1920,0; done")
                    }
                }
                PillButton {
                    label: "Mirror"
                    active: root.displayLayout === "mirror"
                    onClicked: {
                        root.displayLayout = "mirror"
                        run("wlr-randr --output eDP-1 --on --mode 1920x1200 --pos 0,0; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 0,0; done")
                    }
                }
                PillButton {
                    label: "Laptop"
                    active: root.displayLayout === "laptop"
                    onClicked: {
                        root.displayLayout = "laptop"
                        run("wlr-randr --output eDP-1 --on; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --off; done")
                    }
                }
                PillButton {
                    label: "External"
                    active: root.displayLayout === "external"
                    onClicked: {
                        root.displayLayout = "external"
                        run("wlr-randr --output eDP-1 --off; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 0,0; done")
                    }
                }
                PillButton {
                    label: "Adjust…"
                    active: false
                    onClicked: { run("wdisplays &"); controlCenterVisible = false }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#363a4f" }

            // ── SYSTEM ────────────────────────────────────────────────────────
            SectionHeader { label: "SYSTEM" }

            // Night Light
            Column {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "󰛨  Night Light"
                    color: "#cad3f5"
                    font.pixelSize: 12
                    font.family: "FiraCode Nerd Font"
                }

                Flow {
                    width: parent.width
                    spacing: 4
                    PillButton {
                        label: "Off"
                        active: root.nightLightMode === "off"
                        onClicked: {
                            root.nightLightMode = "off"
                            run("[ -f $HOME/.cache/wlsunset.pid ] && kill $(cat $HOME/.cache/wlsunset.pid) 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; pkill -x wlsunset 2>/dev/null || true")
                        }
                    }
                    PillButton {
                        label: "4500K"
                        active: root.nightLightMode === "4500"
                        onClicked: {
                            root.nightLightMode = "4500"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 4500 -t 4500 & echo $! > $HOME/.cache/wlsunset.pid")
                        }
                    }
                    PillButton {
                        label: "3500K"
                        active: root.nightLightMode === "3500"
                        onClicked: {
                            root.nightLightMode = "3500"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 3500 -t 3500 & echo $! > $HOME/.cache/wlsunset.pid")
                        }
                    }
                    PillButton {
                        label: "2700K"
                        active: root.nightLightMode === "2700"
                        onClicked: {
                            root.nightLightMode = "2700"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 2700 -t 2700 & echo $! > $HOME/.cache/wlsunset.pid")
                        }
                    }
                }
            }

            // Power Profile
            Column {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "󱐋  Power Profile"
                    color: "#cad3f5"
                    font.pixelSize: 12
                    font.family: "FiraCode Nerd Font"
                }

                Flow {
                    width: parent.width
                    spacing: 4
                    PillButton {
                        label: "Balanced"
                        active: root.powerProfile === "balanced"
                        onClicked: {
                            root.powerProfile = "balanced"
                            run("powerprofilesctl set balanced")
                        }
                    }
                    PillButton {
                        label: "Performance"
                        active: root.powerProfile === "performance"
                        onClicked: {
                            root.powerProfile = "performance"
                            run("powerprofilesctl set performance")
                        }
                    }
                    PillButton {
                        label: "Power Saver"
                        active: root.powerProfile === "power-saver"
                        onClicked: {
                            root.powerProfile = "power-saver"
                            run("powerprofilesctl set power-saver")
                        }
                    }
                }
            }

            // Do Not Disturb
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "󰂛  Do Not Disturb"
                    color: "#cad3f5"
                    font.pixelSize: 12
                    font.family: "FiraCode Nerd Font"
                    Layout.fillWidth: true
                }

                ToggleSwitch {
                    checked: root.dndEnabled
                    onToggled: state => {
                        root.dndEnabled = state
                        run(state ? "swaync-client --dnd-on" : "swaync-client --dnd-off")
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#363a4f" }

            // ── TOOLS ─────────────────────────────────────────────────────────
            SectionHeader { label: "TOOLS" }

            Flow {
                Layout.fillWidth: true
                spacing: 8

                ActionButton {
                    iconName: "󰕾"
                    label: "Audio"
                    onClicked: { run("pavucontrol &"); controlCenterVisible = false }
                }
                ActionButton {
                    iconName: "󰤨"
                    label: "Network"
                    onClicked: { run("nm-connection-editor &"); controlCenterVisible = false }
                }
                ActionButton {
                    iconName: "󰂯"
                    label: "Bluetooth"
                    onClicked: { run("blueman-manager &"); controlCenterVisible = false }
                }
                ActionButton {
                    iconName: "󰸉"
                    label: "Wallpaper"
                    onClicked: { run("wallpaper-picker.sh &"); controlCenterVisible = false }
                }
                ActionButton {
                    iconName: "󱛟"
                    label: "Disk"
                    onClicked: { run("kitty --title 'Disk Usage' -e duf &"); controlCenterVisible = false }
                }
                ActionButton {
                    iconName: "󰐥"
                    label: "Power"
                    onClicked: { run("wlogout-launch.sh &"); controlCenterVisible = false }
                }
                ActionButton {
                    iconName: "󰌾"
                    label: "Lock"
                    onClicked: { run("swaylock-launch.sh &"); controlCenterVisible = false }
                }
            }

            Item { height: 2 }
        }
    }
}
