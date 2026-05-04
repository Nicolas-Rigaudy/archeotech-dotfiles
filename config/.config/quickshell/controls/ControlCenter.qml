import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Root
import "../services" as Services
import "components"

Item {
    id: root
    anchors.fill: parent

    property real panelHeight: panel.height

    // Services — all data comes from singletons, no inline pollers
    property var audio:   Services.Audio
    property var battery: Services.Battery
    property var network: Services.Network
    property var bt:      Services.Bluetooth

    // Local state (not reflected by a service)
    property string nightLightMode: "off"
    property string powerProfile:   "balanced"
    property string displayLayout:  "extend"

    Component.onCompleted: {
        profileReader.running    = true
        nightLightReader.running = true
        dndReader.running        = true
        idleConfigReader.running = true
    }

    // ── One-time readers for state not tracked by services ─────────────────────

    Process {
        id: profileReader
        command: ["bash", "-c", "powerprofilesctl get"]
        running: false
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
        command: ["bash", "-c",
            "[ -f $HOME/.cache/wlsunset.pid ] && kill -0 $(cat $HOME/.cache/wlsunset.pid) 2>/dev/null " +
            "&& grep -oP '(?<=-t )\\d+' /proc/$(cat $HOME/.cache/wlsunset.pid)/cmdline 2>/dev/null " +
            "|| echo off"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var t = data.trim()
                root.nightLightMode = (t === "4500" || t === "3500" || t === "2700") ? t : "off"
            }
        }
    }

    property bool dndEnabled: false
    Process {
        id: dndReader
        command: ["bash", "-c", "swaync-client --get-dnd 2>/dev/null || echo false"]
        running: false
        stdout: SplitParser { onRead: data => root.dndEnabled = data.trim() === "true" }
    }

    // ── Idle config state ──────────────────────────────────────────────────────
    property bool   dimEnabled:   true
    property int    dimTimeout:   600
    property bool   lockEnabled:  true
    property int    lockTimeout:  1200
    property bool   sleepEnabled: true
    property int    sleepTimeout: 1800

    Process {
        id: idleConfigReader
        command: ["bash", "-c",
            "f=$HOME/.cache/swayidle.conf; " +
            "[ -f \"$f\" ] && cat \"$f\" || " +
            "echo 'DIM_ENABLED=true\nDIM_TIMEOUT=600\nLOCK_ENABLED=true\nLOCK_TIMEOUT=1200\nSLEEP_ENABLED=true\nSLEEP_TIMEOUT=1800'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var m
                if ((m = data.match(/^DIM_ENABLED=(true|false)/)))   root.dimEnabled   = m[1] === "true"
                if ((m = data.match(/^DIM_TIMEOUT=(\d+)/)))           root.dimTimeout   = parseInt(m[1])
                if ((m = data.match(/^LOCK_ENABLED=(true|false)/)))  root.lockEnabled  = m[1] === "true"
                if ((m = data.match(/^LOCK_TIMEOUT=(\d+)/)))          root.lockTimeout  = parseInt(m[1])
                if ((m = data.match(/^SLEEP_ENABLED=(true|false)/))) root.sleepEnabled = m[1] === "true"
                if ((m = data.match(/^SLEEP_TIMEOUT=(\d+)/)))         root.sleepTimeout = parseInt(m[1])
            }
        }
    }

    function applyIdleConfig() {
        var lines = [
            "DIM_ENABLED="   + root.dimEnabled,
            "DIM_TIMEOUT="   + root.dimTimeout,
            "LOCK_ENABLED="  + root.lockEnabled,
            "LOCK_TIMEOUT="  + root.lockTimeout,
            "SLEEP_ENABLED=" + root.sleepEnabled,
            "SLEEP_TIMEOUT=" + root.sleepTimeout,
        ]
        run("printf '%s\\n' " + lines.map(l => "'" + l + "'").join(" ") +
            " > $HOME/.cache/swayidle.conf && ~/.config/swayidle/config.sh &")
    }

    // ── Fire-and-forget command runner ─────────────────────────────────────────

    Process {
        id: cmdRunner
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
    }

    function run(cmd) { cmdRunner.cmd = cmd; cmdRunner.running = true }

    // ── Panel ──────────────────────────────────────────────────────────────────

    Rectangle {
        id: panel
        width: 320
        anchors.top:        parent.top
        anchors.right:      parent.right
        anchors.topMargin:  50
        anchors.rightMargin: Root.Appearance.spacing.base

        // Clamp height so panel never overflows the screen
        property real maxHeight: parent.height - 60
        height: Math.min(contentColumn.implicitHeight + 24, maxHeight)
        radius: Root.Appearance.radius.lg
        color:  Root.Appearance.colors.glassBg
        border.color: Root.Appearance.colors.accentBorder
        border.width: 1
        clip: true

        Flickable {
            id: flick
            anchors.fill: parent
            anchors.margins: 0
            contentWidth: width
            contentHeight: contentColumn.implicitHeight + 24
            clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: contentColumn
                anchors {
                    top: parent.top; left: parent.left; right: parent.right
                    margins: Root.Appearance.spacing.xl
                    topMargin: 14
                }
                width: flick.width - Root.Appearance.spacing.xl * 2
                spacing: Root.Appearance.spacing.lg

            // ── Header ────────────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "󰒓  Settings"
                    color: Root.Appearance.colors.text
                    font.pixelSize: Root.Appearance.font.sizeLg
                    font.family: Root.Appearance.font.family
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 28; height: 28
                    radius: Root.Appearance.radius.base
                    color: closeArea.containsMouse ? Root.Appearance.colors.surface0 : "transparent"
                    Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: closeArea.containsMouse ? Root.Appearance.colors.text : Root.Appearance.colors.overlay0
                        font.pixelSize: 14
                        font.family: Root.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                    }

                    MouseArea {
                        id: closeArea
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
                radius: Root.Appearance.radius.base
                color: Root.Appearance.colors.base

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12; anchors.rightMargin: 12
                    spacing: 0

                    // Battery
                    RowLayout {
                        spacing: 4; Layout.fillWidth: true
                        Text {
                            text: battery.icon()
                            color: battery.percent <= 20 ? Root.Appearance.colors.red : Root.Appearance.colors.green
                            font.pixelSize: Root.Appearance.font.sizeIcon
                            font.family: Root.Appearance.font.family
                        }
                        Text {
                            text: battery.percent + "%"
                            color: Root.Appearance.colors.text
                            font.pixelSize: Root.Appearance.font.sizeSm
                            font.family: Root.Appearance.font.family
                        }
                    }

                    // Network
                    RowLayout {
                        spacing: 4; Layout.fillWidth: true
                        Text {
                            text: network.icon()
                            color: network.connected ? Root.Appearance.colors.blue : Root.Appearance.colors.overlay0
                            font.pixelSize: Root.Appearance.font.sizeIcon
                            font.family: Root.Appearance.font.family
                        }
                        Text {
                            text: network.connected ? network.ssid : "No network"
                            color: network.connected ? Root.Appearance.colors.text : Root.Appearance.colors.overlay0
                            font.pixelSize: Root.Appearance.font.sizeSm
                            font.family: Root.Appearance.font.family
                            elide: Text.ElideRight
                            Layout.maximumWidth: 80
                        }
                    }

                    // Bluetooth
                    RowLayout {
                        spacing: 4; Layout.fillWidth: true
                        Text {
                            text: bt.icon()
                            color: bt.connected ? Root.Appearance.colors.mauve
                                 : bt.enabled   ? Root.Appearance.colors.text
                                 :                Root.Appearance.colors.overlay0
                            font.pixelSize: Root.Appearance.font.sizeIcon
                            font.family: Root.Appearance.font.family
                        }
                        Text {
                            text: bt.connected ? bt.device : (bt.enabled ? "On" : "Off")
                            color: bt.connected ? Root.Appearance.colors.text : Root.Appearance.colors.overlay0
                            font.pixelSize: Root.Appearance.font.sizeSm
                            font.family: Root.Appearance.font.family
                            elide: Text.ElideRight
                            Layout.maximumWidth: 60
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Root.Appearance.colors.surface0 }

            // ── AUDIO ─────────────────────────────────────────────────────────
            SectionHeader { label: "AUDIO" }

            // Volume slider
            Item {
                Layout.fillWidth: true; height: 24

                Text {
                    id: volIcon
                    anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                    text: audio.muted ? "󰖁" : (audio.volume > 66 ? "󰕾" : audio.volume > 33 ? "󰖀" : "󰕿")
                    color: audio.muted ? Root.Appearance.colors.overlay0 : Root.Appearance.colors.text
                    font.pixelSize: Root.Appearance.font.sizeXl
                    font.family: Root.Appearance.font.family
                    MouseArea { anchors.fill: parent; onClicked: audio.toggleMute() }
                }

                Text {
                    id: volPct
                    anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                    text: audio.volume + "%"
                    color: Root.Appearance.colors.overlay0
                    font.pixelSize: Root.Appearance.font.sizeSm
                    font.family: Root.Appearance.font.family
                    width: 32; horizontalAlignment: Text.AlignRight
                }

                Slider {
                    anchors.left: volIcon.right; anchors.right: volPct.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8; anchors.rightMargin: 6
                    from: 0; to: 100
                    value: audio.volume
                    enabled: !audio.muted
                    onMoved: audio.setVolume(Math.round(value))

                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth; height: 4; radius: 2
                        color: Root.Appearance.colors.surface0
                        Rectangle {
                            width: parent.parent.visualPosition * parent.width
                            height: parent.height; radius: 2
                            color: audio.muted ? Root.Appearance.colors.overlay0 : Root.Appearance.colors.accent
                        }
                    }
                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 14; height: 14; radius: 7
                        color: audio.muted ? Root.Appearance.colors.overlay0 : Root.Appearance.colors.accent
                    }
                }
            }

            // Brightness slider
            Item {
                Layout.fillWidth: true; height: 24

                Text {
                    id: brightIcon
                    anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                    text: Services.Brightness.percent >= 75 ? "󰃠"
                        : Services.Brightness.percent >= 40 ? "󰃟"
                        :                                      "󰃞"
                    color: Root.Appearance.colors.yellow
                    font.pixelSize: Root.Appearance.font.sizeXl
                    font.family: Root.Appearance.font.family
                }

                Text {
                    id: brightPct
                    anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                    text: Services.Brightness.percent + "%"
                    color: Root.Appearance.colors.overlay0
                    font.pixelSize: Root.Appearance.font.sizeSm
                    font.family: Root.Appearance.font.family
                    width: 32; horizontalAlignment: Text.AlignRight
                }

                Slider {
                    anchors.left: brightIcon.right; anchors.right: brightPct.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8; anchors.rightMargin: 6
                    from: 1; to: 100
                    value: Services.Brightness.percent
                    onMoved: Services.Brightness.setBrightness(Math.round(value))

                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth; height: 4; radius: 2
                        color: Root.Appearance.colors.surface0
                        Rectangle {
                            width: parent.parent.visualPosition * parent.width
                            height: parent.height; radius: 2
                            color: Root.Appearance.colors.yellow
                        }
                    }
                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 14; height: 14; radius: 7
                        color: Root.Appearance.colors.yellow
                    }
                }
            }

            // Microphone toggle
            RowLayout {
                Layout.fillWidth: true; spacing: 8
                Text {
                    text: audio.micMuted ? "󰍭" : "󰍬"
                    color: audio.micMuted ? Root.Appearance.colors.red : Root.Appearance.colors.text
                    font.pixelSize: Root.Appearance.font.sizeXl
                    font.family: Root.Appearance.font.family
                    MouseArea { anchors.fill: parent; onClicked: audio.toggleMicMute() }
                }
                Text {
                    text: "Microphone"; color: Root.Appearance.colors.subtext0
                    font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
                    Layout.fillWidth: true
                }
                ToggleSwitch {
                    checked: !audio.micMuted
                    onToggled: state => audio.toggleMicMute()
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Root.Appearance.colors.surface0 }

            // ── DISPLAY ───────────────────────────────────────────────────────
            SectionHeader { label: "DISPLAY" }

            Flow {
                Layout.fillWidth: true; spacing: 6
                PillButton {
                    label: "Extend"; active: root.displayLayout === "extend"
                    onClicked: {
                        root.displayLayout = "extend"
                        run("wlr-randr --output eDP-1 --on --pos 0,0; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 1920,0; done")
                    }
                }
                PillButton {
                    label: "Mirror"; active: root.displayLayout === "mirror"
                    onClicked: {
                        root.displayLayout = "mirror"
                        run("wlr-randr --output eDP-1 --on --mode 1920x1200 --pos 0,0; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 0,0; done")
                    }
                }
                PillButton {
                    label: "Laptop"; active: root.displayLayout === "laptop"
                    onClicked: {
                        root.displayLayout = "laptop"
                        run("wlr-randr --output eDP-1 --on; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --off; done")
                    }
                }
                PillButton {
                    label: "External"; active: root.displayLayout === "external"
                    onClicked: {
                        root.displayLayout = "external"
                        run("wlr-randr --output eDP-1 --off; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 0,0; done")
                    }
                }
                PillButton {
                    label: "Adjust…"; active: false
                    onClicked: { run("wdisplays &"); controlCenterVisible = false }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Root.Appearance.colors.surface0 }

            // ── SYSTEM ────────────────────────────────────────────────────────
            SectionHeader { label: "SYSTEM" }

            // Night Light
            Column {
                Layout.fillWidth: true; spacing: 6
                Text {
                    text: "󰛨  Night Light"; color: Root.Appearance.colors.text
                    font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
                }
                Flow {
                    width: parent.width; spacing: 4
                    PillButton {
                        label: "Off"; active: root.nightLightMode === "off"
                        onClicked: {
                            root.nightLightMode = "off"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid || true")
                        }
                    }
                    PillButton {
                        label: "4500K"; active: root.nightLightMode === "4500"
                        onClicked: {
                            root.nightLightMode = "4500"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 6500 -t 4500 & echo $! > $HOME/.cache/wlsunset.pid")
                        }
                    }
                    PillButton {
                        label: "3500K"; active: root.nightLightMode === "3500"
                        onClicked: {
                            root.nightLightMode = "3500"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 6500 -t 3500 & echo $! > $HOME/.cache/wlsunset.pid")
                        }
                    }
                    PillButton {
                        label: "2700K"; active: root.nightLightMode === "2700"
                        onClicked: {
                            root.nightLightMode = "2700"
                            run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 6500 -t 2700 & echo $! > $HOME/.cache/wlsunset.pid")
                        }
                    }
                }
            }

            // Power Profile
            Column {
                Layout.fillWidth: true; spacing: 6
                Text {
                    text: "󱐋  Power Profile"; color: Root.Appearance.colors.text
                    font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
                }
                Flow {
                    width: parent.width; spacing: 4
                    PillButton {
                        label: "Balanced"; active: root.powerProfile === "balanced"
                        onClicked: { root.powerProfile = "balanced"; run("powerprofilesctl set balanced") }
                    }
                    PillButton {
                        label: "Performance"; active: root.powerProfile === "performance"
                        onClicked: { root.powerProfile = "performance"; run("powerprofilesctl set performance") }
                    }
                    PillButton {
                        label: "Power Saver"; active: root.powerProfile === "power-saver"
                        onClicked: { root.powerProfile = "power-saver"; run("powerprofilesctl set power-saver") }
                    }
                }
            }

            // Do Not Disturb
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "󰂛  Do Not Disturb"; color: Root.Appearance.colors.text
                    font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
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

            Rectangle { Layout.fillWidth: true; height: 1; color: Root.Appearance.colors.surface0 }

            // ── IDLE ──────────────────────────────────────────────────────────
            SectionHeader { label: "IDLE" }

            // Dim
            Column {
                Layout.fillWidth: true; spacing: 6
                RowLayout {
                    width: parent.width
                    Text {
                        text: "󰃞  Dim screen"; color: Root.Appearance.colors.text
                        font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
                        Layout.fillWidth: true
                    }
                    ToggleSwitch {
                        checked: root.dimEnabled
                        onToggled: state => { root.dimEnabled = state; root.applyIdleConfig() }
                    }
                }
                Flow {
                    width: parent.width; spacing: 4
                    visible: root.dimEnabled
                    PillButton { label: "5 min";  active: root.dimTimeout === 300;  onClicked: { root.dimTimeout = 300;  root.applyIdleConfig() } }
                    PillButton { label: "10 min"; active: root.dimTimeout === 600;  onClicked: { root.dimTimeout = 600;  root.applyIdleConfig() } }
                    PillButton { label: "15 min"; active: root.dimTimeout === 900;  onClicked: { root.dimTimeout = 900;  root.applyIdleConfig() } }
                    PillButton { label: "30 min"; active: root.dimTimeout === 1800; onClicked: { root.dimTimeout = 1800; root.applyIdleConfig() } }
                }
            }

            // Lock
            Column {
                Layout.fillWidth: true; spacing: 6
                RowLayout {
                    width: parent.width
                    Text {
                        text: "󰌾  Lock screen"; color: Root.Appearance.colors.text
                        font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
                        Layout.fillWidth: true
                    }
                    ToggleSwitch {
                        checked: root.lockEnabled
                        onToggled: state => { root.lockEnabled = state; root.applyIdleConfig() }
                    }
                }
                Flow {
                    width: parent.width; spacing: 4
                    visible: root.lockEnabled
                    PillButton { label: "10 min"; active: root.lockTimeout === 600;  onClicked: { root.lockTimeout = 600;  root.applyIdleConfig() } }
                    PillButton { label: "20 min"; active: root.lockTimeout === 1200; onClicked: { root.lockTimeout = 1200; root.applyIdleConfig() } }
                    PillButton { label: "30 min"; active: root.lockTimeout === 1800; onClicked: { root.lockTimeout = 1800; root.applyIdleConfig() } }
                    PillButton { label: "1 hr";   active: root.lockTimeout === 3600; onClicked: { root.lockTimeout = 3600; root.applyIdleConfig() } }
                }
            }

            // Sleep
            Column {
                Layout.fillWidth: true; spacing: 6
                RowLayout {
                    width: parent.width
                    Text {
                        text: "󰒲  Sleep displays"; color: Root.Appearance.colors.text
                        font.pixelSize: Root.Appearance.font.sizeBase; font.family: Root.Appearance.font.family
                        Layout.fillWidth: true
                    }
                    ToggleSwitch {
                        checked: root.sleepEnabled
                        onToggled: state => { root.sleepEnabled = state; root.applyIdleConfig() }
                    }
                }
                Flow {
                    width: parent.width; spacing: 4
                    visible: root.sleepEnabled
                    PillButton { label: "20 min"; active: root.sleepTimeout === 1200; onClicked: { root.sleepTimeout = 1200; root.applyIdleConfig() } }
                    PillButton { label: "30 min"; active: root.sleepTimeout === 1800; onClicked: { root.sleepTimeout = 1800; root.applyIdleConfig() } }
                    PillButton { label: "1 hr";   active: root.sleepTimeout === 3600; onClicked: { root.sleepTimeout = 3600; root.applyIdleConfig() } }
                    PillButton { label: "2 hr";   active: root.sleepTimeout === 7200; onClicked: { root.sleepTimeout = 7200; root.applyIdleConfig() } }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Root.Appearance.colors.surface0 }

            // ── TOOLS ─────────────────────────────────────────────────────────
            SectionHeader { label: "TOOLS" }

            Flow {
                Layout.fillWidth: true; spacing: 8
                ActionButton { iconName: "󰕾"; label: "Audio";     onClicked: { run("pavucontrol &");          controlCenterVisible = false } }
                ActionButton { iconName: "󰤨"; label: "Network";   onClicked: { run("nm-connection-editor &"); controlCenterVisible = false } }
                ActionButton { iconName: "󰂯"; label: "Bluetooth"; onClicked: { run("blueman-manager &");       controlCenterVisible = false } }
                ActionButton { iconName: "󰸉"; label: "Wallpaper"; onClicked: { run("wallpaper-picker.sh &");   controlCenterVisible = false } }
                ActionButton { iconName: "󱛟"; label: "Disk";      onClicked: { run("kitty --title 'Disk Usage' -e duf &"); controlCenterVisible = false } }
                ActionButton { iconName: "󰐥"; label: "Power";     onClicked: { run("wlogout-launch.sh &");    controlCenterVisible = false } }
                ActionButton { iconName: "󰌾"; label: "Lock";      onClicked: { run("swaylock-launch.sh &");   controlCenterVisible = false } }
            }

            Item { height: 2 }
        }  // end ColumnLayout
        }  // end Flickable
    }
}
