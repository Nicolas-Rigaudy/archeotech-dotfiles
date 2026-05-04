import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import ".." as Root
import "../services" as Services

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

        exclusiveZone: Root.Appearance.bar.height + Root.Appearance.bar.marginTop
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell:bar"

        anchors { top: true; left: true; right: true }
        implicitHeight: Root.Appearance.bar.height + Root.Appearance.bar.marginTop
        color: "transparent"

        // ── Pill ──────────────────────────────────────────────────────────────
        Rectangle {
            id: pill
            anchors {
                top: parent.top; left: parent.left; right: parent.right
                topMargin:   Root.Appearance.bar.marginTop
                leftMargin:  Root.Appearance.bar.marginSide
                rightMargin: Root.Appearance.bar.marginSide
            }
            height: Root.Appearance.bar.height
            radius: Root.Appearance.radius.xl
            color: Root.Appearance.colors.glassBgLight

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin:  Root.Appearance.bar.innerPadding
                anchors.rightMargin: Root.Appearance.bar.innerPadding
                spacing: 0

                // ── LEFT: Tags + window title ──────────────────────────────────
                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0

                    Row {
                        spacing: 4
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: Services.MangoWC.tagsFor(barWindow.screen ? barWindow.screen.name : "")
                            delegate: Rectangle {
                                required property var modelData
                                property bool sel: modelData.selected
                                property bool occ: modelData.occupied
                                property bool urg: modelData.urgent
                                width: sel ? 22 : (occ ? 8 : 6)
                                height: 8; radius: Root.Appearance.radius.pill
                                anchors.verticalCenter: parent.verticalCenter
                                color: urg ? Root.Appearance.colors.red
                                     : sel ? Root.Appearance.colors.accent
                                     : occ ? Root.Appearance.colors.surface1
                                     :       Root.Appearance.colors.surface0
                                Behavior on width { NumberAnimation { duration: Root.Appearance.anim.base; easing.type: Easing.OutCubic } }
                                Behavior on color { ColorAnimation  { duration: Root.Appearance.anim.fast } }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Services.MangoWC.switchTag(
                                        barWindow.screen ? barWindow.screen.name : "", modelData.num)
                                }
                            }
                        }
                    }

                    Item { width: 14 }

                    Text {
                        property string raw: Services.MangoWC.titleFor(barWindow.screen ? barWindow.screen.name : "")
                        text: {
                            if (raw.includes("Visual Studio Code")) return "󰨞  " + raw.replace(/ - Visual Studio Code$/, "").replace(/^.*\//, "").trim()
                            if (raw.includes("Zen Browser"))        return "󰈹  " + raw.replace(/ — Zen Browser$/, "").replace(/^\(\d+\) /, "")
                            if (raw.includes("kitty"))              return "  " + raw.replace(/ - kitty$/, "")
                            if (raw.includes("fish"))               return "  " + raw.replace(/ - fish$/, "")
                            return raw
                        }
                        visible: raw.length > 0
                        color: Root.Appearance.colors.subtext0
                        font.pixelSize: Root.Appearance.font.sizeSm
                        font.family: Root.Appearance.font.family
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
                        text: "<span style='color:" + Root.Appearance.colors.text + ";font-weight:600'>"
                            + Qt.formatDateTime(new Date(), "HH:mm")
                            + "</span>"
                            + "<span style='color:" + Root.Appearance.colors.surface1 + "'> &nbsp;·&nbsp; </span>"
                            + "<span style='color:" + Root.Appearance.colors.subtext0 + "'>"
                            + Qt.formatDateTime(new Date(), "ddd d MMM")
                            + "</span>"
                        font.pixelSize: Root.Appearance.font.sizeMd
                        font.family: Root.Appearance.font.family
                        Timer {
                            interval: 10000; running: true; repeat: true
                            onTriggered: centerClock.text =
                                "<span style='color:" + Root.Appearance.colors.text + ";font-weight:600'>"
                                + Qt.formatDateTime(new Date(), "HH:mm")
                                + "</span>"
                                + "<span style='color:" + Root.Appearance.colors.surface1 + "'> &nbsp;·&nbsp; </span>"
                                + "<span style='color:" + Root.Appearance.colors.subtext0 + "'>"
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
                        text: Services.Audio.micMuted ? "󰍭" : "󰍬"
                        color: Services.Audio.micMuted ? Root.Appearance.colors.red : Root.Appearance.colors.overlay1
                        font.pixelSize: 18; font.family: Root.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: Services.Audio.toggleMicMute()
                            onEntered: {
                                parent.color = Root.Appearance.colors.accent
                                barGroup.showPopup(parent, "MICROPHONE",
                                    Services.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active",
                                    "", "Click to toggle")
                            }
                            onExited: {
                                parent.color = Services.Audio.micMuted ? Root.Appearance.colors.red : Root.Appearance.colors.overlay1
                                barGroup.hidePopup()
                            }
                        }
                    }

                    // Volume
                    Row {
                        spacing: 4; anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: volIcon
                            text: Services.Audio.muted ? "󰖁" : Services.Audio.volume > 66 ? "󰕾" : Services.Audio.volume > 33 ? "󰖀" : "󰕿"
                            color: Services.Audio.muted ? Root.Appearance.colors.overlay0 : Root.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Root.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true
                                onClicked: Services.Audio.toggleMute()
                                onEntered: {
                                    parent.color = Root.Appearance.colors.accent
                                    barGroup.showPopup(parent, "VOLUME",
                                        Services.Audio.muted ? "󰖁  Muted" : "󰕾  " + Services.Audio.volume + "%",
                                        "",
                                        "Scroll to adjust · Click to mute")
                                }
                                onExited: {
                                    parent.color = Services.Audio.muted ? Root.Appearance.colors.overlay0 : Root.Appearance.colors.subtext1
                                    barGroup.hidePopup()
                                }
                                onWheel: wheel => {
                                    var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                    Services.Audio.setVolume(Math.max(0, Math.min(100, Services.Audio.volume + delta)))
                                }
                            }
                        }
                        Text {
                            text: Services.Audio.volume + "%"
                            color: Root.Appearance.colors.overlay1
                            font.pixelSize: Root.Appearance.font.sizeSm; font.family: Root.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Brightness
                    Row {
                        spacing: 4; anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: brightIcon
                            text: Services.Brightness.percent >= 75 ? "󰃠"
                                : Services.Brightness.percent >= 40 ? "󰃟"
                                :                                      "󰃞"
                            color: Root.Appearance.colors.yellow
                            font.pixelSize: 18; font.family: Root.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true
                                onEntered: {
                                    parent.color = Root.Appearance.colors.accent
                                    barGroup.showPopup(parent, "BRIGHTNESS",
                                        "󰃠  " + Services.Brightness.percent + "%",
                                        "", "Scroll to adjust")
                                }
                                onExited: {
                                    parent.color = Root.Appearance.colors.yellow
                                    barGroup.hidePopup()
                                }
                                onWheel: wheel => {
                                    var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                    Services.Brightness.adjust(delta)
                                }
                            }
                        }
                        Text {
                            text: Services.Brightness.percent + "%"
                            color: Root.Appearance.colors.overlay1
                            font.pixelSize: Root.Appearance.font.sizeSm; font.family: Root.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Network
                    Text {
                        id: netIcon
                        text: Services.Network.icon()
                        color: Services.Network.connected ? Root.Appearance.colors.blue : Root.Appearance.colors.overlay0
                        font.pixelSize: 18; font.family: Root.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: networkCmd.running = true
                            onEntered: {
                                parent.color = Root.Appearance.colors.accent
                                barGroup.showPopup(parent, "NETWORK",
                                    Services.Network.connected ? "󰖩  " + Services.Network.ssid : "󰖪  Disconnected",
                                    Services.Network.connected ? "  " + Services.Network.signal + "%  ·  " + Services.Network.band : "",
                                    "Click to open network settings")
                            }
                            onExited: {
                                parent.color = Services.Network.connected ? Root.Appearance.colors.blue : Root.Appearance.colors.overlay0
                                barGroup.hidePopup()
                            }
                        }
                    }

                    // Bluetooth
                    Text {
                        id: btIcon
                        text: Services.Bluetooth.icon()
                        color: Services.Bluetooth.connected ? Root.Appearance.colors.mauve
                             : Services.Bluetooth.enabled   ? Root.Appearance.colors.subtext1
                             :                                Root.Appearance.colors.overlay0
                        font.pixelSize: 18; font.family: Root.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: bluetoothCmd.running = true
                            onEntered: {
                                parent.color = Root.Appearance.colors.accent
                                barGroup.showPopup(parent, "BLUETOOTH",
                                    Services.Bluetooth.connected ? "󰂱  " + Services.Bluetooth.device
                                        : Services.Bluetooth.enabled ? "󰂯  On — no device" : "󰂲  Off",
                                    "", "Click to open bluetooth settings")
                            }
                            onExited: {
                                parent.color = Services.Bluetooth.connected ? Root.Appearance.colors.mauve
                                    : Services.Bluetooth.enabled ? Root.Appearance.colors.subtext1 : Root.Appearance.colors.overlay0
                                barGroup.hidePopup()
                            }
                        }
                    }

                    // Battery
                    Row {
                        visible: Services.Battery.present
                        spacing: 4; anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: batIcon
                            text: Services.Battery.icon()
                            color: Services.Battery.percent <= 20 ? Root.Appearance.colors.red : Root.Appearance.colors.green
                            font.pixelSize: 18; font.family: Root.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent; hoverEnabled: true
                                onEntered: barGroup.showPopup(parent, "BATTERY",
                                    Services.Battery.icon() + "  " + Services.Battery.percent + "%",
                                    Services.Battery.charging ? "󰂄  Charging" : "󱉞  On battery",
                                    "")
                                onExited: barGroup.hidePopup()
                            }
                        }
                        Text {
                            text: Services.Battery.percent + "%"
                            color: Services.Battery.percent <= 20 ? Root.Appearance.colors.red : Root.Appearance.colors.overlay1
                            font.pixelSize: Root.Appearance.font.sizeSm; font.family: Root.Appearance.font.family
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Notification bell
                    Text {
                        text: "󰂜"
                        color: Root.Appearance.colors.subtext1
                        font.pixelSize: 18; font.family: Root.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: notifCmd.running = true
                            onEntered: parent.color = Root.Appearance.colors.accent
                            onExited:  parent.color = Root.Appearance.colors.subtext1
                        }
                    }

                    // Settings gear
                    Text {
                        text: "󰒓"
                        color: Root.Appearance.colors.subtext1
                        font.pixelSize: 18; font.family: Root.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: controlCenterVisible = !controlCenterVisible
                            onEntered: parent.color = Root.Appearance.colors.accent
                            onExited:  parent.color = Root.Appearance.colors.subtext1
                        }
                    }

                    // Power
                    Text {
                        text: "󰐥"
                        color: Root.Appearance.colors.subtext1
                        font.pixelSize: 18; font.family: Root.Appearance.font.family
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                        MouseArea {
                            anchors { fill: parent; margins: -6 }
                            hoverEnabled: true
                            onClicked: powerCmd.running = true
                            onEntered: parent.color = Root.Appearance.colors.red
                            onExited:  parent.color = Root.Appearance.colors.subtext1
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
                       Math.max(barGroup._popupAnchorX - width / 2, Root.Appearance.bar.marginSide),
                       parent.width - width - Root.Appearance.bar.marginSide
                   )
                width:  cardCol.implicitWidth  + 24
                height: cardCol.implicitHeight + 20
                radius: Root.Appearance.radius.md
                antialiasing: true
                color: Root.Appearance.colors.mantle

                Column {
                    id: cardCol
                    anchors { left: parent.left; top: parent.top; margins: 12 }
                    spacing: 5

                    Text {
                        visible: barGroup._popupLabel.length > 0
                        text: barGroup._popupLabel
                        color: Root.Appearance.colors.overlay0
                        font.pixelSize: Root.Appearance.font.sizeSm - 1
                        font.family: Root.Appearance.font.family
                        font.letterSpacing: 0.8
                    }
                    Text {
                        text: barGroup._popupPrimary
                        color: Root.Appearance.colors.text
                        font.pixelSize: Root.Appearance.font.sizeMd
                        font.family: Root.Appearance.font.family
                        font.weight: Font.Medium
                    }
                    Text {
                        visible: barGroup._popupSecondary.length > 0
                        text: barGroup._popupSecondary
                        color: Root.Appearance.colors.subtext0
                        font.pixelSize: Root.Appearance.font.sizeSm
                        font.family: Root.Appearance.font.family
                    }
                    Text {
                        visible: barGroup._popupHint.length > 0
                        text: barGroup._popupHint
                        color: Root.Appearance.colors.overlay0
                        font.pixelSize: Root.Appearance.font.sizeSm - 1
                        font.family: Root.Appearance.font.family
                    }
                }
            }
        }
    }
}
