import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../../../Commons" as Commons
import "../../../../Services/Media" as MediaServices
import "../../../../Services/Hardware" as HardwareServices
import "../../../../Services/Networking" as NetworkServices
import "../../../../Commons/Primitives"
import "../../../../Services/System" as SystemServices

// ControlCenter UI. Panel.qml provides chrome (glass, slide anim, focus, Esc,
// click-outside-to-close); this file is the inner content only. `panelRoot` is
// injected by Panel.qml's Loader.onLoaded — call `panelRoot.close()` to dismiss.
// State sync runs on `panelRoot.panelOpen` → true transitions.
Item {
    id: root
    anchors.fill: parent

    property var panelRoot

    property var audio:   MediaServices.Audio
    property var battery: HardwareServices.Battery
    property var network: NetworkServices.Network
    property var bt:      NetworkServices.Bluetooth
    property var vpn:     NetworkServices.VPN

    property bool wifiExpanded:   false
    property bool btExpanded:     false
    property string wifiAskPwFor: ""

    onWifiAskPwForChanged: {
        if (wifiAskPwFor !== "") network.freezeList()
        else network.unfreezeList()
    }

    readonly property var _wifiConnected:  network.displayNetworks.filter(function(n) { return n.active })
    readonly property var _wifiSaved:      network.displayNetworks.filter(function(n) { return n.saved && !n.active })
    readonly property var _wifiAvailable:  network.displayNetworks.filter(function(n) { return !n.saved && !n.active })

    Connections {
        target: root.panelRoot
        enabled: root.panelRoot !== null
        function onPanelOpenChanged() {
            if (root.panelRoot && root.panelRoot.panelOpen) {
                if (Commons.State.controlCenterOpenSection === "wifi") {
                    root.wifiExpanded = true
                    Commons.State.controlCenterOpenSection = ""
                } else if (Commons.State.controlCenterOpenSection === "bt") {
                    root.btExpanded = true
                    Commons.State.controlCenterOpenSection = ""
                }
            }
        }
    }

    Process {
        id: cmdRunner
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
    }
    function run(cmd) { cmdRunner.cmd = cmd; cmdRunner.running = true }

    // ── Content container — fills Panel's Loader bounds. Panel.qml owns the
    //    chrome (color, border, radius) and the slide-from-edge animation;
    //    this Item just clips the Flickable.
    Item {
        id: panel
        anchors.fill: parent
        clip: true

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
                        color: settingsLaunchArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent"
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            anchors.centerIn: parent
                            text: "󰖷"
                            color: settingsLaunchArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                            font.pixelSize: 14; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            id: settingsLaunchArea; anchors.fill: parent; hoverEnabled: true
                            onClicked: Commons.State.settingsVisible = true
                        }
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
                            onClicked: if (root.panelRoot) root.panelRoot.close()
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
                                onClicked: { root.run("spotify-launcher &"); if (root.panelRoot) root.panelRoot.close() }
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

                // Sink selector — only when >1 output device present
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: audio.sinks.length > 1 ? _sinkFlow.implicitHeight + 4 : 0
                    clip: true
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

                    Flow {
                        id: _sinkFlow
                        width: parent.width; spacing: 4; topPadding: 4
                        Repeater {
                            model: audio.sinks
                            delegate: PillButton {
                                required property var modelData
                                label: modelData.shortName || modelData.description
                                active: audio.defaultSink === modelData.name
                                onClicked: audio.setDefaultSink(modelData.name)
                            }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── CONNECTIVITY ───────────────────────────────────────────────
                SectionHeader { label: "CONNECTIVITY" }

                // WiFi CompoundPill
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    // Left tile — toggle adapter
                    Rectangle {
                        width: 48; height: 40
                        radius: Commons.Appearance.radius.base
                        color: network.wifiEnabled ? Commons.Appearance.colors.accent : Commons.Appearance.colors.surface0
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            anchors.centerIn: parent
                            text: network.icon()
                            color: network.wifiEnabled ? Commons.Appearance.colors.base : Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeXl
                            font.family: Commons.Appearance.font.family
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: network.toggleWifi() }
                    }

                    // Right body — expand
                    Rectangle {
                        Layout.fillWidth: true; height: 40
                        radius: Commons.Appearance.radius.base
                        color: root.wifiExpanded ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        RowLayout {
                            anchors { fill: parent; leftMargin: 12; rightMargin: 8 }
                            Text {
                                text: !network.wifiEnabled ? "Off"
                                    : network.connected ? network.ssid
                                    : "Not connected"
                                color: network.wifiEnabled ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                            Text {
                                text: root.wifiExpanded ? "󰅃" : "󰅀"
                                color: Commons.Appearance.colors.overlay0
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                            }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.wifiExpanded = !root.wifiExpanded }
                    }
                }

                // WiFi expansion body
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.wifiExpanded ? _wifiBody.implicitHeight : 0
                    clip: true
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

                    ColumnLayout {
                        id: _wifiBody
                        width: parent.width
                        spacing: 2
                        opacity: root.wifiExpanded ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                        // Not enabled placeholder
                        Text {
                            visible: !network.wifiEnabled
                            text: "Enable WiFi to see networks"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                            leftPadding: 2; topPadding: 2
                            Layout.fillWidth: true
                        }

                        // ── Connected ──────────────────────────────────────────
                        Repeater {
                            model: network.wifiEnabled ? root._wifiConnected : []
                            delegate: WifiNetworkRow {}
                        }

                        // ── Saved section ──────────────────────────────────────
                        Text {
                            visible: network.wifiEnabled && root._wifiSaved.length > 0
                            text: "SAVED"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: 9; font.family: Commons.Appearance.font.family
                            font.weight: Font.Medium
                            Layout.fillWidth: true; topPadding: 4; leftPadding: 2
                        }
                        Repeater {
                            model: network.wifiEnabled ? root._wifiSaved : []
                            delegate: WifiNetworkRow {}
                        }

                        // ── Available section ──────────────────────────────────
                        Text {
                            visible: network.wifiEnabled && root._wifiAvailable.length > 0
                            text: "AVAILABLE"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: 9; font.family: Commons.Appearance.font.family
                            font.weight: Font.Medium
                            Layout.fillWidth: true; topPadding: 4; leftPadding: 2
                        }
                        Repeater {
                            model: network.wifiEnabled ? root._wifiAvailable : []
                            delegate: WifiNetworkRow {}
                        }

                        // ── Rescan ─────────────────────────────────────────────
                        Item {
                            visible: network.wifiEnabled
                            Layout.fillWidth: true; height: 28
                            Text {
                                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                                text: network.scanning ? "Scanning…" : "󰑙  Rescan"
                                color: network.scanning ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.mauve
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                                MouseArea {
                                    anchors.fill: parent; anchors.margins: -4
                                    enabled: !network.scanning; cursorShape: Qt.PointingHandCursor
                                    onClicked: network.scan()
                                }
                            }
                        }
                    }
                }

                // BT CompoundPill
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    // Left tile — toggle adapter
                    Rectangle {
                        width: 48; height: 40
                        radius: Commons.Appearance.radius.base
                        color: bt.enabled ? Commons.Appearance.colors.mauve : Commons.Appearance.colors.surface0
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            anchors.centerIn: parent
                            text: bt.icon()
                            color: bt.enabled ? Commons.Appearance.colors.base : Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeXl
                            font.family: Commons.Appearance.font.family
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: bt.toggle() }
                    }

                    // Right body — expand
                    Rectangle {
                        Layout.fillWidth: true; height: 40
                        radius: Commons.Appearance.radius.base
                        color: root.btExpanded ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        RowLayout {
                            anchors { fill: parent; leftMargin: 12; rightMargin: 8 }
                            Text {
                                text: bt.connected ? bt.device : bt.enabled ? "On" : "Off"
                                color: bt.enabled ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                            Text {
                                text: root.btExpanded ? "󰅃" : "󰅀"
                                color: Commons.Appearance.colors.overlay0
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                            }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.btExpanded = !root.btExpanded }
                    }
                }

                // BT expansion body
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.btExpanded ? _btBody.implicitHeight : 0
                    clip: true
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

                    Column {
                        id: _btBody
                        width: parent.width
                        spacing: 4
                        topPadding: 4
                        opacity: root.btExpanded ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                        Text {
                            width: parent.width
                            visible: bt.devices.length === 0
                            text: "No paired devices"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                            leftPadding: 2
                        }

                        Repeater {
                            model: bt.devices
                            delegate: RowLayout {
                                required property var modelData
                                width: _btBody.width
                                spacing: 8
                                Text {
                                    text: modelData.connected ? "󰂱" : "󰂯"
                                    color: modelData.connected ? Commons.Appearance.colors.mauve : Commons.Appearance.colors.overlay0
                                    font.pixelSize: Commons.Appearance.font.sizeBase
                                    font.family: Commons.Appearance.font.family
                                }
                                Text {
                                    text: modelData.name
                                    color: modelData.connected ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                                    font.pixelSize: Commons.Appearance.font.sizeSm
                                    font.family: Commons.Appearance.font.family
                                    Layout.fillWidth: true; elide: Text.ElideRight
                                }
                                Rectangle {
                                    width: _btBtnLbl.implicitWidth + 16; height: 24
                                    radius: Commons.Appearance.radius.base
                                    color: _btBtnMa.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                    Text {
                                        id: _btBtnLbl
                                        anchors.centerIn: parent
                                        text: modelData.connected ? "Disconnect" : "Connect"
                                        color: modelData.connected ? Commons.Appearance.colors.red : Commons.Appearance.colors.mauve
                                        font.pixelSize: Commons.Appearance.font.sizeSm - 1
                                        font.family: Commons.Appearance.font.family
                                    }
                                    MouseArea {
                                        id: _btBtnMa; anchors.fill: parent; hoverEnabled: true
                                        onClicked: modelData.connected
                                            ? bt.disconnectDevice(modelData.address)
                                            : bt.connectDevice(modelData.address)
                                    }
                                }
                            }
                        }
                    }
                }

                // VPN CompoundPill (simple toggle — no expand)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    // Left tile — toggle active VPN
                    Rectangle {
                        width: 48; height: 40
                        radius: Commons.Appearance.radius.base
                        color: vpn.active ? Commons.Appearance.colors.green : Commons.Appearance.colors.surface0
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            anchors.centerIn: parent
                            text: "󰒄"
                            color: vpn.active ? Commons.Appearance.colors.base : Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeXl
                            font.family: Commons.Appearance.font.family
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: vpn.toggle(vpn.activeConnection || "")
                        }
                    }

                    // Right body — active connection name or Off
                    Rectangle {
                        Layout.fillWidth: true; height: 40
                        radius: Commons.Appearance.radius.base
                        color: Commons.Appearance.colors.surface0
                        RowLayout {
                            anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                            Text {
                                text: vpn.connections.length === 0 ? "No VPN configured"
                                    : vpn.active ? vpn.activeConnection
                                    : "Off"
                                color: vpn.active ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            enabled: vpn.connections.length > 0
                            onClicked: vpn.toggle(vpn.activeConnection || "")
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // WiFi network row component (used in all three sections above)
                component WifiNetworkRow: Item {
                    required property var modelData
                    Layout.fillWidth: true

                    property bool _showPw: root.wifiAskPwFor === modelData.ssid
                    property bool _busyConnect: network.connectingTo === modelData.ssid
                    property bool _busyDisconn: modelData.active && network.disconnectingFrom === modelData.ssid
                    property bool _busy: _busyConnect || _busyDisconn
                    property bool _needsPw: !modelData.saved
                        && modelData.security !== "" && modelData.security !== "--"

                    Layout.preferredHeight: _showPw ? 82 : 34
                    clip: true
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                    // ── Main row ───────────────────────────────────────────────
                    RowLayout {
                        id: _netRow
                        anchors { left: parent.left; right: parent.right; top: parent.top }
                        height: 34
                        spacing: 6

                        // Signal icon (+ lock indicator)
                        Row {
                            spacing: 1
                            Text {
                                text: network.signalIcon(modelData.signal, modelData.security !== "" && modelData.security !== "--")
                                color: modelData.active ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                font.pixelSize: 14; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        // SSID
                        Text {
                            text: modelData.ssid
                            color: modelData.active ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                            Layout.fillWidth: true; elide: Text.ElideRight
                        }

                        // Spinner or action button
                        Item {
                            width: _busy ? 20 : _netBtnTxt.implicitWidth + 16
                            height: 24
                            Behavior on width { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                            // Spinner
                            Text {
                                id: _netSpinner
                                visible: _busy
                                anchors.centerIn: parent
                                text: "󰑙"
                                color: Commons.Appearance.colors.accent
                                font.pixelSize: 14; font.family: Commons.Appearance.font.family
                                RotationAnimator {
                                    target: _netSpinner
                                    running: _busy
                                    loops: Animation.Infinite
                                    from: 0; to: 360; duration: 900
                                }
                            }

                            // Action button
                            Rectangle {
                                id: _netBtn
                                visible: !_busy
                                anchors.fill: parent
                                radius: Commons.Appearance.radius.sm
                                color: _netBtnMa.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                Text {
                                    id: _netBtnTxt
                                    anchors.centerIn: parent
                                    text: modelData.active ? "Disconnect" : "Connect"
                                    color: modelData.active ? Commons.Appearance.colors.red : Commons.Appearance.colors.mauve
                                    font.pixelSize: Commons.Appearance.font.sizeSm - 1
                                    font.family: Commons.Appearance.font.family
                                }
                                MouseArea {
                                    id: _netBtnMa; anchors.fill: parent; hoverEnabled: true
                                    onClicked: {
                                        if (modelData.active) {
                                            network.disconnect()
                                        } else if (_needsPw) {
                                            root.wifiAskPwFor = modelData.ssid
                                        } else {
                                            network.connect(modelData.ssid)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ── Inline password field ──────────────────────────────────
                    RowLayout {
                        id: _pwRow
                        anchors { top: _netRow.bottom; topMargin: 4; left: parent.left; right: parent.right }
                        spacing: 6
                        opacity: _showPw ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 100 } }

                        Rectangle {
                            Layout.fillWidth: true; height: 28
                            radius: Commons.Appearance.radius.sm
                            color: Commons.Appearance.colors.base
                            border.color: _pwInput.activeFocus
                                ? Commons.Appearance.colors.accent
                                : Commons.Appearance.colors.surface1
                            border.width: 1
                            Behavior on border.color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                            Text {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 8 }
                                text: "Password"
                                color: Commons.Appearance.colors.overlay0
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                                visible: _pwInput.text.length === 0
                            }
                            TextInput {
                                id: _pwInput
                                anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                                echoMode: TextInput.Password
                                color: Commons.Appearance.colors.text
                                font.pixelSize: Commons.Appearance.font.sizeBase
                                font.family: Commons.Appearance.font.family
                                Keys.onReturnPressed: event => {
                                    if (text.length > 0) {
                                        network.connectWithPassword(modelData.ssid, text)
                                        text = ""
                                        root.wifiAskPwFor = ""
                                    }
                                }
                                Keys.onEscapePressed: event => {
                                    text = ""
                                    root.wifiAskPwFor = ""
                                    event.accepted = true
                                }
                            }
                        }

                        // Connect button
                        Rectangle {
                            width: 60; height: 28
                            radius: Commons.Appearance.radius.sm
                            color: _pwConnMa.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.surface0
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            Text {
                                anchors.centerIn: parent
                                text: "Connect"
                                color: _pwConnMa.containsMouse ? Commons.Appearance.colors.base : Commons.Appearance.colors.mauve
                                font.pixelSize: Commons.Appearance.font.sizeSm - 1
                                font.family: Commons.Appearance.font.family
                                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            }
                            MouseArea {
                                id: _pwConnMa; anchors.fill: parent; hoverEnabled: true
                                onClicked: {
                                    if (_pwInput.text.length > 0) {
                                        network.connectWithPassword(modelData.ssid, _pwInput.text)
                                        _pwInput.text = ""
                                        root.wifiAskPwFor = ""
                                    }
                                }
                            }
                        }

                        // Cancel button
                        Rectangle {
                            width: 52; height: 28
                            radius: Commons.Appearance.radius.sm
                            color: _pwCancelMa.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                                color: Commons.Appearance.colors.subtext0
                                font.pixelSize: Commons.Appearance.font.sizeSm - 1
                                font.family: Commons.Appearance.font.family
                            }
                            MouseArea {
                                id: _pwCancelMa; anchors.fill: parent; hoverEnabled: true
                                onClicked: { _pwInput.text = ""; root.wifiAskPwFor = "" }
                            }
                        }
                    }
                }

                // Sprint 20: display layout, night light, power profile,
                // idle & sleep moved out — they belong in Settings panes
                // (Sprint 23 absorbs them). CC stays quick-access only.

                // ── QUICK TOGGLES ─────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "󰂛  Do Not Disturb"; color: Commons.Appearance.colors.text; font.pixelSize: Commons.Appearance.font.sizeBase; font.family: Commons.Appearance.font.family; Layout.fillWidth: true }
                    ToggleSwitch {
                        checked: SystemServices.Notifications.dndEnabled
                        onToggled: state => SystemServices.Notifications.dndEnabled = state
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── POWER ─────────────────────────────────────────────────────
                SectionHeader { label: "POWER" }

                Flow {
                    Layout.fillWidth: true; spacing: 8
                    ActionButton { iconName: "󰐥"; label: "Power"; onClicked: { run("wlogout-launch.sh &");  if (root.panelRoot) root.panelRoot.close() } }
                    ActionButton { iconName: "󰌾"; label: "Lock";  onClicked: { run("swaylock-launch.sh &"); if (root.panelRoot) root.panelRoot.close() } }
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
