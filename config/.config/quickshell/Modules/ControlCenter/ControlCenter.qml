import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../Commons" as Commons
import "../../Services/Media" as MediaServices
import "../../Services/Hardware" as HardwareServices
import "../../Services/Networking" as NetworkServices
import "../../Widgets"
import "../../Services/System" as SystemServices

Item {
    id: root
    anchors.fill: parent
    Keys.onEscapePressed: Commons.State.controlCenterVisible = false

    property real panelHeight: panel.height

    property var audio:   MediaServices.Audio
    property var battery: HardwareServices.Battery
    property var network: NetworkServices.Network
    property var bt:      NetworkServices.Bluetooth
    property string nightLightMode: "off"
    property string powerProfile:   "balanced"
    property string displayLayout:  "extend"

    property bool displayExpanded:    false
    property bool nightLightExpanded: false
    property bool idleExpanded:       false

    Component.onCompleted: _syncState()

    Connections {
        target: Commons.State
        function onControlCenterVisibleChanged() {
            if (Commons.State.controlCenterVisible) root._syncState()
        }
    }

    function _syncState() {
        profileReader.running    = true
        nightLightReader.running = true
        idleConfigReader.running = true
    }

    // ── State readers ──────────────────────────────────────────────────────────

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
        // No anchors.right — x is animated; anchors would override x and break the slide
        anchors.top:       parent.top
        anchors.topMargin: 50

        height: Math.min(contentColumn.implicitHeight + 24, root.height - 60)
        radius: Commons.Appearance.radius.lg
        color:  Commons.Appearance.colors.glassBg
        border.color: Commons.Appearance.colors.accentBorder
        border.width: 1
        clip: true

        property real restX:   root.width - width - Commons.Appearance.spacing.base
        property real hiddenX: root.width + 8

        x: 9999
        opacity: 0

        Timer {
            id: slideInTimer
            interval: 50; repeat: false
            onTriggered: {
                panel.x = panel.hiddenX
                panel.opacity = 1
                slideAnim.from = panel.hiddenX
                slideAnim.to   = panel.restX
                slideAnim.start()
            }
        }

        Connections {
            target: root
            function onVisibleChanged() {
                if (root.visible) {
                    panel.opacity = 0
                    if (root.width > 0) slideInTimer.restart()
                } else {
                    slideInTimer.stop()
                }
            }
            function onWidthChanged() {
                if (root.visible && root.width > 0 && panel.opacity === 0
                        && !slideInTimer.running && !slideAnim.running)
                    slideInTimer.restart()
            }
        }

        NumberAnimation {
            id: slideAnim
            target: panel; property: "x"
            duration: Commons.Appearance.anim.base; easing.type: Easing.OutQuart
        }

        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: width
            contentHeight: contentColumn.implicitHeight + 24
            clip: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: contentColumn
                anchors {
                    top: parent.top; left: parent.left; right: parent.right
                    margins: Commons.Appearance.spacing.xl
                    topMargin: 14
                }
                width: flick.width - Commons.Appearance.spacing.xl * 2
                spacing: Commons.Appearance.spacing.lg

                // ── Header ────────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "󰒓  Settings"
                        color: Commons.Appearance.colors.text
                        font.pixelSize: Commons.Appearance.font.sizeLg
                        font.family: Commons.Appearance.font.family
                        font.weight: Font.Medium
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        width: 28; height: 28
                        radius: Commons.Appearance.radius.base
                        color: closeArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent"
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: closeArea.containsMouse ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                            font.pixelSize: 14; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            id: closeArea; anchors.fill: parent; hoverEnabled: true
                            onClicked: Commons.State.controlCenterVisible = false
                        }
                    }
                }

                // ── Status strip ──────────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true; height: 36
                    radius: Commons.Appearance.radius.base
                    color: Commons.Appearance.colors.base
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12; anchors.rightMargin: 12
                        spacing: 0
                        RowLayout {
                            spacing: 4; Layout.fillWidth: true
                            Text { text: battery.icon(); color: battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.green; font.pixelSize: Commons.Appearance.font.sizeIcon; font.family: Commons.Appearance.font.family }
                            Text { text: battery.percent + "%"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family }
                        }
                        RowLayout {
                            spacing: 4; Layout.fillWidth: true
                            Text { text: network.icon(); color: network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeIcon; font.family: Commons.Appearance.font.family }
                            Text { text: network.connected ? network.ssid : "No network"; color: network.connected ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family; elide: Text.ElideRight; Layout.maximumWidth: 80 }
                        }
                        RowLayout {
                            spacing: 4; Layout.fillWidth: true
                            Text { text: bt.icon(); color: bt.connected ? Commons.Appearance.colors.mauve : bt.enabled ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeIcon; font.family: Commons.Appearance.font.family }
                            Text { text: bt.connected ? bt.device : (bt.enabled ? "On" : "Off"); color: bt.connected ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family; elide: Text.ElideRight; Layout.maximumWidth: 60 }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── MEDIA ─────────────────────────────────────────────────────
                SectionHeader { label: "MEDIA" }

                // Collapsed: nothing playing — launch shortcut
                Item {
                    Layout.fillWidth: true
                    // Animate height between collapsed (40px) and expanded (album card ~90px)
                    height: MediaServices.MprisService.available ? expandedCard.implicitHeight : collapsedRow.implicitHeight
                    clip: true
                    Behavior on height { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

                    // Collapsed row — shown when no player available
                    RowLayout {
                        id: collapsedRow
                        width: parent.width
                        opacity: MediaServices.MprisService.available ? 0 : 1
                        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }
                        spacing: 10

                        Text {
                            text: "󰝚  Nothing playing"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            width: 90; height: 28
                            radius: Commons.Appearance.radius.base
                            color: spotifyArea.containsMouse ? Commons.Appearance.colors.surface0 : Commons.Appearance.colors.base
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            Text {
                                anchors.centerIn: parent
                                text: "󰓇  Spotify"
                                color: Commons.Appearance.colors.subtext1
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                            }
                            MouseArea {
                                id: spotifyArea; anchors.fill: parent; hoverEnabled: true
                                onClicked: { root.run("spotify-launcher &"); Commons.State.controlCenterVisible = false }
                            }
                        }
                    }

                    // Expanded card — shown when player available
                    RowLayout {
                        id: expandedCard
                        width: parent.width
                        opacity: MediaServices.MprisService.available ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.base } }
                        spacing: 12

                        // Album art / app icon square
                        Rectangle {
                            width: 56; height: 56
                            radius: Commons.Appearance.radius.base
                            color: Commons.Appearance.colors.base
                            Layout.alignment: Qt.AlignTop

                            // Album art when available
                            Image {
                                id: albumArt
                                anchors.fill: parent
                                anchors.margins: 0
                                source: MediaServices.MprisService.artUrl || ""
                                fillMode: Image.PreserveAspectCrop
                                visible: status === Image.Ready
                                layer.enabled: true
                                layer.effect: null
                                // Rounded clip via Rectangle mask
                                Rectangle {
                                    anchors.fill: parent
                                    radius: Commons.Appearance.radius.base
                                    color: "transparent"
                                    border.color: Commons.Appearance.colors.accentBorder
                                    border.width: 1
                                }
                            }

                            // Fallback icon when no art
                            Text {
                                anchors.centerIn: parent
                                visible: albumArt.status !== Image.Ready
                                text: MediaServices.MprisService.appIcon || "󰝚"
                                color: Commons.Appearance.colors.accent
                                font.pixelSize: 28
                                font.family: Commons.Appearance.font.family
                            }
                        }

                        // Track info + controls
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            // Title
                            Text {
                                Layout.fillWidth: true
                                text: MediaServices.MprisService.title || "Unknown track"
                                color: Commons.Appearance.colors.text
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                            }

                            // Artist
                            Text {
                                Layout.fillWidth: true
                                text: MediaServices.MprisService.artist || MediaServices.MprisService.identity || ""
                                color: Commons.Appearance.colors.subtext0
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                                elide: Text.ElideRight
                            }

                            // Progress bar (seekable)
                            Item {
                                Layout.fillWidth: true
                                height: 28
                                visible: MediaServices.MprisService.length > 0

                                Rectangle {
                                    anchors.left: parent.left; anchors.right: parent.right
                                    anchors.top: parent.top; anchors.topMargin: 4
                                    height: 3; radius: 2
                                    color: Commons.Appearance.colors.surface0

                                    Rectangle {
                                        width: MediaServices.MprisService.length > 0 ? parent.width * Math.min(MediaServices.MprisService.position / MediaServices.MprisService.length, 1) : 0
                                        height: parent.height; radius: 2
                                        color: Commons.Appearance.colors.accent
                                        Behavior on width { NumberAnimation { duration: 950 } }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -4
                                        onClicked: mouse => MediaServices.MprisService.seekTo(MediaServices.MprisService.length * (mouse.x / width))
                                    }
                                }

                                Text {
                                    anchors.left: parent.left; anchors.bottom: parent.bottom
                                    text: formatTime(MediaServices.MprisService.position)
                                    color: Commons.Appearance.colors.overlay0
                                    font.pixelSize: 9; font.family: Commons.Appearance.font.family
                                }
                                Text {
                                    anchors.right: parent.right; anchors.bottom: parent.bottom
                                    text: formatTime(MediaServices.MprisService.length)
                                    color: Commons.Appearance.colors.overlay0
                                    font.pixelSize: 9; font.family: Commons.Appearance.font.family
                                }
                            }

                            // Playback controls
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Item { Layout.fillWidth: true }

                                // Previous
                                Text {
                                    text: "󰒮"
                                    color: prevArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                                    font.pixelSize: 18; font.family: Commons.Appearance.font.family
                                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                    MouseArea { id: prevArea; anchors.fill: parent; anchors.margins: -4; hoverEnabled: true; onClicked: MediaServices.MprisService.previous() }
                                }

                                Item { width: 20 }

                                // Play / Pause
                                Text {
                                    text: MediaServices.MprisService.playing ? "󰏤" : "󰐊"
                                    color: playArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.text
                                    font.pixelSize: 22; font.family: Commons.Appearance.font.family
                                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                    MouseArea { id: playArea; anchors.fill: parent; anchors.margins: -4; hoverEnabled: true; onClicked: MediaServices.MprisService.togglePlay() }
                                }

                                Item { width: 20 }

                                // Next
                                Text {
                                    text: "󰒭"
                                    color: nextArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                                    font.pixelSize: 18; font.family: Commons.Appearance.font.family
                                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                    MouseArea { id: nextArea; anchors.fill: parent; anchors.margins: -4; hoverEnabled: true; onClicked: MediaServices.MprisService.next() }
                                }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── AUDIO ─────────────────────────────────────────────────────
                SectionHeader { label: "AUDIO" }

                Item {
                    Layout.fillWidth: true; height: 32
                    Text {
                        id: volIcon
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                        text: audio.muted ? "󰖁" : (audio.volume > 66 ? "󰕾" : audio.volume > 33 ? "󰖀" : "󰕿")
                        color: audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.text
                        font.pixelSize: Commons.Appearance.font.sizeXl; font.family: Commons.Appearance.font.family
                        MouseArea { anchors.fill: parent; onClicked: audio.toggleMute() }
                    }
                    Text {
                        id: volPct
                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                        text: audio.volume + "%"
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                        width: 32; horizontalAlignment: Text.AlignRight
                    }
                    Slider {
                        anchors.left: volIcon.right; anchors.right: volPct.left
                        anchors.top: parent.top; anchors.bottom: parent.bottom
                        topPadding: 0; bottomPadding: 0
                        anchors.leftMargin: 8; anchors.rightMargin: 6
                        from: 0; to: 100; value: audio.volume; enabled: !audio.muted
                        onPressedChanged: flick.interactive = !pressed
                        onMoved: audio.setVolume(Math.round(value))
                        background: Rectangle {
                            x: parent.leftPadding; y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: parent.availableWidth; height: 4; radius: 2
                            color: Commons.Appearance.colors.surface0
                            Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; radius: 2; color: audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.accent }
                        }
                        handle: Rectangle {
                            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: 14; height: 14; radius: 7
                            color: audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.accent
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true; height: 32
                    Text {
                        id: brightIcon
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                        text: HardwareServices.Brightness.percent >= 75 ? "󰃠" : HardwareServices.Brightness.percent >= 40 ? "󰃟" : "󰃞"
                        color: Commons.Appearance.colors.yellow
                        font.pixelSize: Commons.Appearance.font.sizeXl; font.family: Commons.Appearance.font.family
                    }
                    Text {
                        id: brightPct
                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                        text: HardwareServices.Brightness.percent + "%"
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                        width: 32; horizontalAlignment: Text.AlignRight
                    }
                    Slider {
                        anchors.left: brightIcon.right; anchors.right: brightPct.left
                        anchors.top: parent.top; anchors.bottom: parent.bottom
                        topPadding: 0; bottomPadding: 0
                        anchors.leftMargin: 8; anchors.rightMargin: 6
                        from: 1; to: 100; value: HardwareServices.Brightness.percent
                        onPressedChanged: flick.interactive = !pressed
                        onMoved: HardwareServices.Brightness.setBrightness(Math.round(value))
                        background: Rectangle {
                            x: parent.leftPadding; y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: parent.availableWidth; height: 4; radius: 2
                            color: Commons.Appearance.colors.surface0
                            Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; radius: 2; color: Commons.Appearance.colors.yellow }
                        }
                        handle: Rectangle {
                            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: 14; height: 14; radius: 7; color: Commons.Appearance.colors.yellow
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true; spacing: 8
                    Text {
                        text: audio.micMuted ? "󰍭" : "󰍬"
                        color: audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.text
                        font.pixelSize: Commons.Appearance.font.sizeXl; font.family: Commons.Appearance.font.family
                        MouseArea { anchors.fill: parent; onClicked: audio.toggleMicMute() }
                    }
                    Text { text: "Microphone"; color: Commons.Appearance.colors.subtext0; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                    ToggleSwitch { checked: !audio.micMuted; onToggled: state => audio.toggleMicMute() }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── DISPLAY ───────────────────────────────────────────────────
                Item {
                    Layout.fillWidth: true; height: 32
                    Rectangle {
                        anchors.fill: parent; radius: Commons.Appearance.radius.sm
                        color: _dspHdrArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent"
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    }
                    RowLayout {
                        anchors { fill: parent; leftMargin: 2; rightMargin: 4 }
                        Text { text: "󱄅  Display Layout"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                        Text { text: root.displayExpanded ? "󰅃" : "󰅀"; color: Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeIcon; font.family: Commons.Appearance.font.family }
                    }
                    MouseArea { id: _dspHdrArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.displayExpanded = !root.displayExpanded }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.displayExpanded ? _dspBody.implicitHeight : 0
                    clip: true
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }
                    Flow {
                        id: _dspBody
                        width: parent.width; spacing: 6
                        PillButton { label: "Extend";   active: root.displayLayout === "extend";   onClicked: { root.displayLayout = "extend";   run("wlr-randr --output eDP-1 --on --pos 0,0; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 1920,0; done") } }
                        PillButton { label: "Mirror";   active: root.displayLayout === "mirror";   onClicked: { root.displayLayout = "mirror";   run("wlr-randr --output eDP-1 --on --mode 1920x1200 --pos 0,0; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 0,0; done") } }
                        PillButton { label: "Laptop";   active: root.displayLayout === "laptop";   onClicked: { root.displayLayout = "laptop";   run("wlr-randr --output eDP-1 --on; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --off; done") } }
                        PillButton { label: "External"; active: root.displayLayout === "external"; onClicked: { root.displayLayout = "external"; run("wlr-randr --output eDP-1 --off; for ext in $(wlr-randr 2>/dev/null | grep '^[^ ]' | grep -v '^eDP-1' | awk '{print $1}'); do wlr-randr --output $ext --on --pos 0,0; done") } }
                        PillButton { label: "Adjust…";  active: false; onClicked: { run("wdisplays &"); Commons.State.controlCenterVisible = false } }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── SYSTEM ────────────────────────────────────────────────────
                SectionHeader { label: "SYSTEM" }

                Column {
                    Layout.fillWidth: true; spacing: 6
                    Item {
                        width: parent.width; height: 32
                        Rectangle {
                            anchors.fill: parent; radius: Commons.Appearance.radius.sm
                            color: _nlHdrArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent"
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        RowLayout {
                            anchors { fill: parent; leftMargin: 2; rightMargin: 4 }
                            Text { text: "󰛨  Night Light"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                            Text { text: root.nightLightExpanded ? "󰅃" : "󰅀"; color: Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeIcon; font.family: Commons.Appearance.font.family }
                        }
                        MouseArea { id: _nlHdrArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.nightLightExpanded = !root.nightLightExpanded }
                    }
                    Item {
                        width: parent.width
                        height: root.nightLightExpanded ? _nlBody.implicitHeight : 0
                        clip: true
                        Behavior on height { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }
                        Flow {
                            id: _nlBody
                            width: parent.width; spacing: 4
                            PillButton { label: "Off";   active: root.nightLightMode === "off";  onClicked: { root.nightLightMode = "off";  run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid || true") } }
                            PillButton { label: "4500K"; active: root.nightLightMode === "4500"; onClicked: { root.nightLightMode = "4500"; run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 6500 -t 4500 & echo $! > $HOME/.cache/wlsunset.pid") } }
                            PillButton { label: "3500K"; active: root.nightLightMode === "3500"; onClicked: { root.nightLightMode = "3500"; run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 6500 -t 3500 & echo $! > $HOME/.cache/wlsunset.pid") } }
                            PillButton { label: "2700K"; active: root.nightLightMode === "2700"; onClicked: { root.nightLightMode = "2700"; run("pkill -x wlsunset 2>/dev/null; rm -f $HOME/.cache/wlsunset.pid; wlsunset -T 6500 -t 2700 & echo $! > $HOME/.cache/wlsunset.pid") } }
                        }
                    }
                }

                Column {
                    Layout.fillWidth: true; spacing: 6
                    Text { text: "󱐋  Power Profile"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family }
                    Flow {
                        width: parent.width; spacing: 4
                        PillButton { label: "Balanced";    active: root.powerProfile === "balanced";    onClicked: { root.powerProfile = "balanced";    run("powerprofilesctl set balanced") } }
                        PillButton { label: "Performance"; active: root.powerProfile === "performance"; onClicked: { root.powerProfile = "performance"; run("powerprofilesctl set performance") } }
                        PillButton { label: "Power Saver"; active: root.powerProfile === "power-saver"; onClicked: { root.powerProfile = "power-saver"; run("powerprofilesctl set power-saver") } }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "󰂛  Do Not Disturb"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                    ToggleSwitch {
                        checked: SystemServices.Notifications.dndEnabled
                        onToggled: state => SystemServices.Notifications.dndEnabled = state
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── IDLE ──────────────────────────────────────────────────────
                Item {
                    Layout.fillWidth: true; height: 32
                    Rectangle {
                        anchors.fill: parent; radius: Commons.Appearance.radius.sm
                        color: _idleHdrArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent"
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    }
                    RowLayout {
                        anchors { fill: parent; leftMargin: 2; rightMargin: 4 }
                        Text { text: "󰒲  Idle & Sleep"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                        Text { text: root.idleExpanded ? "󰅃" : "󰅀"; color: Commons.Appearance.colors.overlay0; font.pixelSize: Commons.Appearance.font.sizeIcon; font.family: Commons.Appearance.font.family }
                    }
                    MouseArea { id: _idleHdrArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.idleExpanded = !root.idleExpanded }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.idleExpanded ? _idleBody.implicitHeight : 0
                    clip: true
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

                    Column {
                        id: _idleBody
                        width: parent.width
                        spacing: Commons.Appearance.spacing.lg

                        Column {
                            width: parent.width; spacing: 6
                            RowLayout {
                                width: parent.width
                                Text { text: "󰃞  Dim screen"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                                ToggleSwitch { checked: root.dimEnabled; onToggled: state => { root.dimEnabled = state; root.applyIdleConfig() } }
                            }
                            Flow {
                                width: parent.width; spacing: 4; visible: root.dimEnabled
                                PillButton { label: "5 min";  active: root.dimTimeout === 300;  onClicked: { root.dimTimeout = 300;  root.applyIdleConfig() } }
                                PillButton { label: "10 min"; active: root.dimTimeout === 600;  onClicked: { root.dimTimeout = 600;  root.applyIdleConfig() } }
                                PillButton { label: "15 min"; active: root.dimTimeout === 900;  onClicked: { root.dimTimeout = 900;  root.applyIdleConfig() } }
                                PillButton { label: "30 min"; active: root.dimTimeout === 1800; onClicked: { root.dimTimeout = 1800; root.applyIdleConfig() } }
                            }
                        }

                        Column {
                            width: parent.width; spacing: 6
                            RowLayout {
                                width: parent.width
                                Text { text: "󰌾  Lock screen"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                                ToggleSwitch { checked: root.lockEnabled; onToggled: state => { root.lockEnabled = state; root.applyIdleConfig() } }
                            }
                            Flow {
                                width: parent.width; spacing: 4; visible: root.lockEnabled
                                PillButton { label: "10 min"; active: root.lockTimeout === 600;  onClicked: { root.lockTimeout = 600;  root.applyIdleConfig() } }
                                PillButton { label: "20 min"; active: root.lockTimeout === 1200; onClicked: { root.lockTimeout = 1200; root.applyIdleConfig() } }
                                PillButton { label: "30 min"; active: root.lockTimeout === 1800; onClicked: { root.lockTimeout = 1800; root.applyIdleConfig() } }
                                PillButton { label: "1 hr";   active: root.lockTimeout === 3600; onClicked: { root.lockTimeout = 3600; root.applyIdleConfig() } }
                            }
                        }

                        Column {
                            width: parent.width; spacing: 6
                            RowLayout {
                                width: parent.width
                                Text { text: "󰒲  Sleep displays"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                                ToggleSwitch { checked: root.sleepEnabled; onToggled: state => { root.sleepEnabled = state; root.applyIdleConfig() } }
                            }
                            Flow {
                                width: parent.width; spacing: 4; visible: root.sleepEnabled
                                PillButton { label: "20 min"; active: root.sleepTimeout === 1200; onClicked: { root.sleepTimeout = 1200; root.applyIdleConfig() } }
                                PillButton { label: "30 min"; active: root.sleepTimeout === 1800; onClicked: { root.sleepTimeout = 1800; root.applyIdleConfig() } }
                                PillButton { label: "1 hr";   active: root.sleepTimeout === 3600; onClicked: { root.sleepTimeout = 3600; root.applyIdleConfig() } }
                                PillButton { label: "2 hr";   active: root.sleepTimeout === 7200; onClicked: { root.sleepTimeout = 7200; root.applyIdleConfig() } }
                            }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── TOOLS ─────────────────────────────────────────────────────
                SectionHeader { label: "TOOLS" }

                Flow {
                    Layout.fillWidth: true; spacing: 8
                    ActionButton { iconName: "󰕾"; label: "Audio";     onClicked: { run("pavucontrol &");          Commons.State.controlCenterVisible = false } }
                    ActionButton { iconName: "󰤨"; label: "Network";   onClicked: { run("nm-connection-editor &"); Commons.State.controlCenterVisible = false } }
                    ActionButton { iconName: "󰂯"; label: "Bluetooth"; onClicked: { run("blueman-manager &");       Commons.State.controlCenterVisible = false } }
                    ActionButton { iconName: "󰸉"; label: "Wallpaper"; onClicked: { run("wallpaper-picker.sh &");   Commons.State.controlCenterVisible = false } }
                    ActionButton { iconName: "󱛟"; label: "Disk";      onClicked: { run("kitty --title 'Disk Usage' -e duf &"); Commons.State.controlCenterVisible = false } }
                    ActionButton { iconName: "󰐥"; label: "Power";     onClicked: { run("wlogout-launch.sh &");    Commons.State.controlCenterVisible = false } }
                    ActionButton { iconName: "󰌾"; label: "Lock";      onClicked: { run("swaylock-launch.sh &");   Commons.State.controlCenterVisible = false } }
                }

                Item { height: 2 }
            }
        }
    }

    // ── Helpers ────────────────────────────────────────────────────────────────

    function formatTime(secs) {
        var s = Math.floor(secs)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
}
