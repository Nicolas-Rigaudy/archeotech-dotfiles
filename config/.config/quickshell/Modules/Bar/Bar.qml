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
import "../../Services/System" as SystemServices

// One Bar instance per screen: bar pill + popup overlay as siblings.
Item {
    id: barGroup

    required property var modelData

    // ── Shared popup state ─────────────────────────────────────────────────────
    property real    _popupAnchorX:   0
    property string  _popupLabel:     ""
    property string  _popupPrimary:   ""
    property string  _popupSecondary: ""
    property string  _popupHint:      ""
    property bool    _popupVisible:   false

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

                // ── LEFT: Tags · title · MPRIS ─────────────────────────────────
                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0

                    // Tag dots
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
                                width:  sel ? 22 : (occ ? 8 : 6)
                                height: 8
                                radius: Commons.Appearance.radius.pill
                                anchors.verticalCenter: parent.verticalCenter
                                color: (urg && !sel) ? Commons.Appearance.colors.red
                                     : sel ? Commons.Appearance.colors.accent
                                     : occ ? Commons.Appearance.colors.surface1
                                     :       Commons.Appearance.colors.surface0
                                // OutBack: slight mechanical overshoot on size change
                                Behavior on width {
                                    NumberAnimation {
                                        duration: Commons.Appearance.anim.base
                                        easing.type: Easing.OutBack
                                        easing.overshoot: 1.2
                                    }
                                }
                                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: CompositorServices.MangoWC.switchTag(
                                        barWindow.screen ? barWindow.screen.name : "", modelData.num)
                                }
                            }
                        }
                    }

                    Item { width: 14 }

                    // Window title
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
                        Layout.maximumWidth: 200
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // MPRIS marquee — appears when something is playing
                    Item {
                        id: mprisBarItem
                        Layout.alignment: Qt.AlignVCenter

                        property bool active: MediaServices.MprisService.available === true
                        property string displayText: {
                            if (!MediaServices.MprisService) return ""
                            var t = MediaServices.MprisService.title  || ""
                            var a = MediaServices.MprisService.artist || ""
                            if (t.length > 0 && a.length > 0) return t + "  ·  " + a
                            if (t.length > 0) return t
                            return a
                        }

                        // Animate width 0 ↔ content so the bar never jumps
                        Layout.maximumWidth: active ? 200 : 0
                        opacity: active ? 1 : 0
                        Behavior on Layout.maximumWidth { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }
                        Behavior on opacity             { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                        width: 200
                        height: Commons.Appearance.bar.height
                        clip: true

                        // Separator dot
                        Text {
                            id: mprisSep
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            text: "·"
                            color: Commons.Appearance.colors.surface1
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                        }

                        // Play state icon
                        Text {
                            id: mprisIcon
                            anchors.left: mprisSep.right
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: MediaServices.MprisService.playing ? "󰝚" : "󰏤"
                            color: Commons.Appearance.colors.accent
                            font.pixelSize: 12
                            font.family: Commons.Appearance.font.family
                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -4
                                onClicked: MediaServices.MprisService.togglePlay()
                            }
                        }

                        // Scrolling marquee container
                        Item {
                            id: marqueeContainer
                            anchors.left: mprisIcon.right
                            anchors.leftMargin: 6
                            anchors.right: parent.right
                            anchors.rightMargin: 4
                            anchors.verticalCenter: parent.verticalCenter
                            height: Commons.Appearance.font.sizeSm + 4
                            clip: true

                            property real textWidth: marqueeText1.implicitWidth
                            property bool needsScroll: textWidth > marqueeContainer.width
                            property real scrollPos: 0

                            property string displayText: mprisBarItem.displayText

                            // Defer start so Text has rendered and implicitWidth is valid
                            Timer {
                                id: marqueeStartTimer
                                interval: 80; repeat: false
                                onTriggered: {
                                    marqueeAnim.stop()
                                    marqueeContainer.scrollPos = 0
                                    if (marqueeContainer.needsScroll && mprisBarItem.active)
                                        marqueeAnim.start()
                                }
                            }

                            onDisplayTextChanged: marqueeStartTimer.restart()
                            onNeedsScrollChanged: {
                                if (needsScroll) marqueeStartTimer.restart()
                                else { marqueeAnim.stop(); scrollPos = 0 }
                            }

                            // Also trigger when the item first becomes active
                            Connections {
                                target: mprisBarItem
                                function onActiveChanged() {
                                    if (mprisBarItem.active) marqueeStartTimer.restart()
                                    else { marqueeAnim.stop(); marqueeContainer.scrollPos = 0 }
                                }
                            }

                            SequentialAnimation {
                                id: marqueeAnim
                                loops: Animation.Infinite

                                NumberAnimation {
                                    target: marqueeContainer; property: "scrollPos"
                                    from: 0
                                    to: marqueeContainer.textWidth + 40
                                    duration: Math.max(5000, (marqueeContainer.textWidth + 40) * 20)
                                    easing.type: Easing.Linear
                                }
                                PauseAnimation { duration: 600 }
                                ScriptAction { script: marqueeContainer.scrollPos = 0 }
                                PauseAnimation { duration: 300 }
                            }

                            // Primary text (leading)
                            Text {
                                id: marqueeText1
                                x: marqueeContainer.needsScroll ? -marqueeContainer.scrollPos : 0
                                anchors.verticalCenter: parent.verticalCenter
                                text: mprisBarItem.displayText
                                color: Commons.Appearance.colors.subtext1
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                                elide: marqueeContainer.needsScroll ? Text.ElideNone : Text.ElideRight
                                width: marqueeContainer.needsScroll ? implicitWidth : marqueeContainer.width
                            }

                            // Ghost copy for seamless loop
                            Text {
                                x: marqueeText1.x + marqueeContainer.textWidth + 40
                                anchors.verticalCenter: parent.verticalCenter
                                visible: marqueeContainer.needsScroll
                                text: mprisBarItem.displayText
                                color: Commons.Appearance.colors.subtext1
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                            }
                        }
                    }
                }

                // ── CENTER: Clock ──────────────────────────────────────────────
                Item {
                    Layout.fillWidth: true
                    Text {
                        id: centerClock
                        anchors.centerIn: parent
                        textFormat: Text.RichText
                        text: clockText()
                        font.pixelSize: Commons.Appearance.font.sizeMd
                        font.family: Commons.Appearance.font.family
                        function clockText() {
                            return "<span style='color:" + Commons.Appearance.colors.text + ";font-weight:600'>"
                                + Qt.formatDateTime(new Date(), "HH:mm")
                                + "</span>"
                                + "<span style='color:" + Commons.Appearance.colors.surface1 + "'> &nbsp;·&nbsp; </span>"
                                + "<span style='color:" + Commons.Appearance.colors.subtext0 + "'>"
                                + Qt.formatDateTime(new Date(), "ddd d MMM")
                                + "</span>"
                        }
                        Timer {
                            interval: 1000; running: true; repeat: true
                            onTriggered: centerClock.text = centerClock.clockText()
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
                                        "", "Scroll to adjust · Click to mute")
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
                                    HardwareServices.Battery.charging ? "󰂄  Charging" : "󱉞  On battery", "")
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

                    // Notification bell + unread badge
                    Item {
                        width: bellIcon.implicitWidth + 4
                        height: 24
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: bellIcon
                            anchors.centerIn: parent
                            text: "󰂚"
                            color: Commons.State.notificationCenterVisible
                                ? Commons.Appearance.colors.accent
                                : SystemServices.Notifications.unreadCount > 0
                                ? Commons.Appearance.colors.text
                                : Commons.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            MouseArea {
                                anchors.fill: parent; anchors.margins: -4; hoverEnabled: true
                                onClicked: Commons.State.notificationCenterVisible = !Commons.State.notificationCenterVisible
                                onEntered: if (!Commons.State.notificationCenterVisible) bellIcon.color = Commons.Appearance.colors.accent
                                onExited:  if (!Commons.State.notificationCenterVisible)
                                    bellIcon.color = SystemServices.Notifications.unreadCount > 0
                                        ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                            }
                        }

                        Rectangle {
                            visible: SystemServices.Notifications.unreadCount > 0 && !Commons.State.notificationCenterVisible
                            anchors.top:   parent.top
                            anchors.right: parent.right
                            width:  badgeText.implicitWidth + 4; height: 12
                            radius: 6
                            color:  Commons.Appearance.colors.red

                            Text {
                                id: badgeText
                                anchors.centerIn: parent
                                text: SystemServices.Notifications.unreadCount > 9 ? "9+" : SystemServices.Notifications.unreadCount
                                color: Commons.Appearance.colors.crust
                                font.pixelSize: 8; font.family: Commons.Appearance.font.family
                                font.weight: Font.Bold
                            }
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

        Process { id: powerCmd;     command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }
        Process { id: networkCmd;   command: ["bash", "-c", "nm-connection-editor &"]; running: false }
        Process { id: bluetoothCmd; command: ["bash", "-c", "blueman-manager &"]; running: false }
    }

    // ── Popup overlay ──────────────────────────────────────────────────────────
    // Loader destroys the surface when hidden (prevents grey-block artifact).
    // Popup appears BELOW the bar pill, top edge flush — cockpit HUD callout style.
    Loader {
        active: barGroup._popupVisible
        sourceComponent: PanelWindow {
            id: popupWindow
            screen: barGroup.modelData

            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell:bar-popup"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.exclusiveZone: 0

            anchors { top: true; left: true; right: true }
            // tall enough to hold max popup content + bar height offset
            implicitHeight: Commons.Appearance.bar.height + Commons.Appearance.bar.marginTop + 100
            color: "transparent"

            // Card unfolds downward from bar bottom edge
            Rectangle {
                id: popupCard

                // Horizontal: centred on trigger icon, clamped to screen edges
                x: Math.min(
                       Math.max(barGroup._popupAnchorX - width / 2, Commons.Appearance.bar.marginSide + 4),
                       popupWindow.width - width - Commons.Appearance.bar.marginSide - 4
                   )

                // Flush against bar bottom edge
                y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height + 3

                width:  cardCol.implicitWidth  + 24
                // Animate height from 0 (unfold downward)
                height: cardCol.implicitHeight + 20
                clip: true
                radius: Commons.Appearance.radius.md
                antialiasing: true
                color: Commons.Appearance.colors.glassBg
                border.color: Commons.Appearance.colors.accentBorder
                border.width: 1

                // Slide-down unfold: clip height 0 → full, opacity 0 → 1
                property real revealHeight: 0
                Behavior on revealHeight { NumberAnimation { duration: Commons.Appearance.anim.fast; easing.type: Easing.OutQuart } }
                Component.onCompleted: revealHeight = 1

                layer.enabled: true
                // Use revealHeight as a clip multiplier via transform
                transform: Scale {
                    origin.x: popupCard.width / 2
                    origin.y: 0
                    yScale: popupCard.revealHeight
                }
                opacity: popupCard.revealHeight
                Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast; easing.type: Easing.OutQuart } }

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
