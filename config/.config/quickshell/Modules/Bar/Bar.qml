import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../Commons" as Commons
import "../../Services/Media" as MediaServices
import "../../Services/Hardware" as HardwareServices
import "../../Services/Networking" as NetworkServices
import "../../Services/Compositor" as CompositorServices

// Scope holds two PanelWindows per screen: the bar pill and the hover-popup overlay.
// Using Item as root so both windows are siblings and the popup doesn't clip inside the bar.
Item {
    id: barGroup

    required property var modelData

    // ── Popup state (shared between both windows) ──────────────────────────────
    property var    _popupAnchorX:   0
    property string _popupLabel:     ""
    property string _popupPrimary:   ""
    property string _popupSecondary: ""
    property string _popupHint:      ""
    property bool   _popupVisible:   false

    function showPopup(item, label, primary, secondary, hint) {
        var pt = item.mapToItem(null, item.width / 2, 0)
        _popupAnchorX   = pt.x
        _popupLabel     = label
        _popupPrimary   = primary
        _popupSecondary = secondary || ""
        _popupHint      = hint || ""
        _popupVisible   = true
    }

    function hidePopup() { _popupVisible = false }

    // ── Bar window ─────────────────────────────────────────────────────────────
    PanelWindow {
        id: barWindow
        screen: barGroup.modelData

        exclusiveZone: Commons.Appearance.bar.height + Commons.Appearance.bar.marginTop
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell:bar"

        anchors { top: true; left: true; right: true }
        implicitHeight: Commons.Appearance.bar.height + Commons.Appearance.bar.marginTop
        color: "transparent"

        // ── Pill ──────────────────────────────────────────────────────────────
        Rectangle {
            id: pill
            anchors {
                top: parent.top; left: parent.left; right: parent.right
                topMargin:   Commons.Appearance.bar.marginTop
                leftMargin:  Commons.Appearance.bar.marginSide
                rightMargin: Commons.Appearance.bar.marginSide
            }
            height: Commons.Appearance.bar.height
            radius: Commons.Appearance.radius.xl
            color: Commons.Appearance.colors.glassBgLight

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin:  Commons.Appearance.bar.innerPadding
                anchors.rightMargin: Commons.Appearance.bar.innerPadding
                spacing: 0

                // ── LEFT: Tags + window title ──────────────────────────────────
                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0

                    Row {
                        spacing: 4
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: CompositorServices.MangoWC.tagsFor(barWindow.screen ? barWindow.screen.name : "")
                            delegate: Rectangle {
                                required property var modelData
                                property bool sel: modelData.selected
                                property bool occ: modelData.occupied
                                property bool urg: modelData.urgent
                                width: sel ? 22 : (occ ? 8 : 6)
                                height: 8; radius: Commons.Appearance.radius.pill
                                anchors.verticalCenter: parent.verticalCenter
                                color: urg ? Commons.Appearance.colors.red
                                     : sel ? Commons.Appearance.colors.accent
                                     : occ ? Commons.Appearance.colors.surface1
                                     :       Commons.Appearance.colors.surface0
                                Behavior on width { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }
                                Behavior on color { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: CompositorServices.MangoWC.switchTag(
                                        barWindow.screen ? barWindow.screen.name : "", modelData.num)
                                }
                            }
                        }
                    }

                    Item { width: 14 }

                    Text {
                        property string raw: CompositorServices.MangoWC.titleFor(barWindow.screen ? barWindow.screen.name : "")
                        text: {
                            if (raw.includes("Visual Studio Code")) return "󰨞  " + raw.replace(/ - Visual Studio Code$/, "").replace(/^.*\//, "").trim()
                            if (raw.includes("Zen Browser"))        return "󰈹  " + raw.replace(/ — Zen Browser$/, "").replace(/^\(\d+\) /, "")
                            if (raw.includes("kitty"))              return "  " + raw.replace(/ - kitty$/, "")
                            if (raw.includes("fish"))               return "  " + raw.replace(/ - fish$/, "")
                            return raw
                        }
                        visible: raw.length > 0
                        color: Commons.Appearance.colors.subtext0
                        font.pixelSize: Commons.Appearance.font.sizeSm
                        font.family: Commons.Appearance.font.family
                        elide: Text.ElideRight
                        Layout.maximumWidth: 240
                        Layout.alignment: Qt.AlignVCenter
                    }
                }

                // ── CENTER: Clock ──────────────────────────────────────────────
                Item {
                    Layout.fillWidth: true
                    Text {
                        id: centerClock
                        anchors.centerIn: parent
                        textFormat: Text.RichText
                        text: "<span style='color:" + Commons.Appearance.colors.text + ";font-weight:600'>"
                            + Qt.formatDateTime(new Date(), "HH:mm")
                            + "</span>"
                            + "<span style='color:" + Commons.Appearance.colors.surface1 + "'> &nbsp;·&nbsp; </span>"
                            + "<span style='color:" + Commons.Appearance.colors.subtext0 + "'>"
                            + Qt.formatDateTime(new Date(), "ddd d MMM")
                            + "</span>"
                        font.pixelSize: Commons.Appearance.font.sizeMd
                        font.family: Commons.Appearance.font.family
                        Timer {
                            interval: 1000; running: true; repeat: true
                            onTriggered: centerClock.text =
                                "<span style='color:" + Commons.Appearance.colors.text + ";font-weight:600'>"
                                + Qt.formatDateTime(new Date(), "HH:mm")
                                + "</span>"
                                + "<span style='color:" + Commons.Appearance.colors.surface1 + "'> &nbsp;·&nbsp; </span>"
                                + "<span style='color:" + Commons.Appearance.colors.subtext0 + "'>"
                                + Qt.formatDateTime(new Date(), "ddd d MMM")
                                + "</span>"
                        }
                    }
                }

                // ── RIGHT: System tray ─────────────────────────────────────────
                Row {
                    spacing: 10
                    Layout.alignment: Qt.AlignVCenter

                    // Mic
                    Text {
                        id: micIcon
                        text: MediaServices.Audio.micMuted ? "󰍭" : "󰍬"
                        color: MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                        font.pixelSize: 18; font.family: Commons.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: MediaServices.Audio.toggleMicMute()
                            onEntered: {
                                parent.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "MICROPHONE",
                                    MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active",
                                    "", "Click to toggle")
                            }
                            onExited: {
                                parent.color = MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                                barGroup.hidePopup()
                            }
                        }
                    }

                    // Volume
                    Row {
                        spacing: 4; anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: volIcon
                            text: MediaServices.Audio.muted ? "󰖁" : MediaServices.Audio.volume > 66 ? "󰕾" : MediaServices.Audio.volume > 33 ? "󰖀" : "󰕿"
                            color: MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true
                                onClicked: MediaServices.Audio.toggleMute()
                                onEntered: {
                                    parent.color = Commons.Appearance.colors.accent
                                    barGroup.showPopup(parent, "VOLUME",
                                        MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%",
                                        "",
                                        "Scroll to adjust · Click to mute")
                                }
                                onExited: {
                                    parent.color = MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
                                    barGroup.hidePopup()
                                }
                                onWheel: wheel => {
                                    var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                    MediaServices.Audio.setVolume(Math.max(0, Math.min(100, MediaServices.Audio.volume + delta)))
                                }
                            }
                        }
                        Text {
                            text: MediaServices.Audio.volume + "%"
                            color: Commons.Appearance.colors.overlay1
                            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Brightness
                    Row {
                        spacing: 4; anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: brightIcon
                            text: HardwareServices.Brightness.percent >= 75 ? "󰃠"
                                : HardwareServices.Brightness.percent >= 40 ? "󰃟"
                                :                                              "󰃞"
                            color: Commons.Appearance.colors.yellow
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true
                                onEntered: {
                                    parent.color = Commons.Appearance.colors.accent
                                    barGroup.showPopup(parent, "BRIGHTNESS",
                                        "󰃠  " + HardwareServices.Brightness.percent + "%",
                                        "", "Scroll to adjust")
                                }
                                onExited: {
                                    parent.color = Commons.Appearance.colors.yellow
                                    barGroup.hidePopup()
                                }
                                onWheel: wheel => {
                                    var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                    HardwareServices.Brightness.adjust(delta)
                                }
                            }
                        }
                        Text {
                            text: HardwareServices.Brightness.percent + "%"
                            color: Commons.Appearance.colors.overlay1
                            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Network
                    Text {
                        id: netIcon
                        text: NetworkServices.Network.icon()
                        color: NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
                        font.pixelSize: 18; font.family: Commons.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: networkCmd.running = true
                            onEntered: {
                                parent.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "NETWORK",
                                    NetworkServices.Network.connected ? "󰖩  " + NetworkServices.Network.ssid : "󰖪  Disconnected",
                                    NetworkServices.Network.connected ? "  " + NetworkServices.Network.signal + "%  ·  " + NetworkServices.Network.band : "",
                                    "Click to open network settings")
                            }
                            onExited: {
                                parent.color = NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
                                barGroup.hidePopup()
                            }
                        }
                    }

                    // Bluetooth
                    Text {
                        id: btIcon
                        text: NetworkServices.Bluetooth.icon()
                        color: NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                             : NetworkServices.Bluetooth.enabled   ? Commons.Appearance.colors.subtext1
                             :                                        Commons.Appearance.colors.overlay0
                        font.pixelSize: 18; font.family: Commons.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: bluetoothCmd.running = true
                            onEntered: {
                                parent.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "BLUETOOTH",
                                    NetworkServices.Bluetooth.connected ? "󰂱  " + NetworkServices.Bluetooth.device
                                        : NetworkServices.Bluetooth.enabled ? "󰂯  On — no device" : "󰂲  Off",
                                    "", "Click to open bluetooth settings")
                            }
                            onExited: {
                                parent.color = NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                                    : NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.subtext1 : Commons.Appearance.colors.overlay0
                                barGroup.hidePopup()
                            }
                        }
                    }

                    // Battery
                    Row {
                        visible: HardwareServices.Battery.present
                        spacing: 4; anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: batIcon
                            text: HardwareServices.Battery.icon()
                            color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.green
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true
                                onEntered: barGroup.showPopup(parent, "BATTERY",
                                    HardwareServices.Battery.icon() + "  " + HardwareServices.Battery.percent + "%",
                                    HardwareServices.Battery.charging ? "󰂄  Charging" : "󱉞  On battery",
                                    "")
                                onExited: barGroup.hidePopup()
                            }
                        }
                        Text {
                            text: HardwareServices.Battery.percent + "%"
                            color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Notification bell
                    Text {
                        text: "󰂜"
                        color: Commons.Appearance.colors.subtext1
                        font.pixelSize: 18; font.family: Commons.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: notifCmd.running = true
                            onEntered: parent.color = Commons.Appearance.colors.accent
                            onExited:  parent.color = Commons.Appearance.colors.subtext1
                        }
                    }

                    // Settings gear
                    Text {
                        text: "󰒓"
                        color: Commons.Appearance.colors.subtext1
                        font.pixelSize: 18; font.family: Commons.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: Commons.State.controlCenterVisible = !Commons.State.controlCenterVisible
                            onEntered: parent.color = Commons.Appearance.colors.accent
                            onExited:  parent.color = Commons.Appearance.colors.subtext1
                        }
                    }

                    // Power
                    Text {
                        text: "󰐥"
                        color: Commons.Appearance.colors.subtext1
                        font.pixelSize: 18; font.family: Commons.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea {
                            anchors { fill: parent; margins: -6 }
                            hoverEnabled: true
                            onClicked: powerCmd.running = true
                            onEntered: parent.color = Commons.Appearance.colors.red
                            onExited:  parent.color = Commons.Appearance.colors.subtext1
                        }
                    }
                }
            }
        }

        Process { id: notifCmd;     command: ["swaync-client", "--toggle-panel"]; running: false }
        Process { id: powerCmd;     command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }
        Process { id: networkCmd;   command: ["bash", "-c", "nm-connection-editor &"]; running: false }
        Process { id: bluetoothCmd; command: ["bash", "-c", "blueman-manager &"]; running: false }
    }

    // ── Popup overlay — Loader destroys the Wayland surface when hidden,
    //    preventing the grey-block artifact on secondary/portrait screens.
    Loader {
        active: barGroup._popupVisible
        sourceComponent: PanelWindow {
            screen: barGroup.modelData

            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell:bar-popup"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.exclusiveZone: 0

            anchors { top: true; left: true; right: true }
            implicitHeight: 120
            color: "transparent"

            Rectangle {
                y: 6
                x: Math.min(
                       Math.max(barGroup._popupAnchorX - width / 2, Commons.Appearance.bar.marginSide),
                       parent.width - width - Commons.Appearance.bar.marginSide
                   )
                width:  cardCol.implicitWidth  + 24
                height: cardCol.implicitHeight + 20
                radius: Commons.Appearance.radius.md
                antialiasing: true
                color: Commons.Appearance.colors.glassBgLight

                Column {
                    id: cardCol
                    anchors { left: parent.left; top: parent.top; margins: 12 }
                    spacing: 5

                    Text {
                        visible: barGroup._popupLabel.length > 0
                        text: barGroup._popupLabel
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm - 1
                        font.family: Commons.Appearance.font.family
                        font.letterSpacing: 0.8
                    }
                    Text {
                        text: barGroup._popupPrimary
                        color: Commons.Appearance.colors.text
                        font.pixelSize: Commons.Appearance.font.sizeMd
                        font.family: Commons.Appearance.font.family
                        font.weight: Font.Medium
                    }
                    Text {
                        visible: barGroup._popupSecondary.length > 0
                        text: barGroup._popupSecondary
                        color: Commons.Appearance.colors.subtext0
                        font.pixelSize: Commons.Appearance.font.sizeSm
                        font.family: Commons.Appearance.font.family
                    }
                    Text {
                        visible: barGroup._popupHint.length > 0
                        text: barGroup._popupHint
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm - 1
                        font.family: Commons.Appearance.font.family
                    }
                }
            }
        }
    }
}
