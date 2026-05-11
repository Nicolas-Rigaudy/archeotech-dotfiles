import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
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
    property real    _lastShowTime:   0
    property var     _popupOwner:     null

    function showPopup(item, label, primary, secondary, hint) {
        _hideTimer.stop()
        _lastShowTime = Date.now()
        _popupOwner   = item
        var pt = item.mapToItem(null, item.width / 2, 0)
        _popupAnchorX   = pt.x
        _popupLabel     = label
        _popupPrimary   = primary
        _popupSecondary = secondary || ""
        _popupHint      = hint || ""
        _popupVisible   = true
    }
    // caller === undefined means the popup card itself is hiding (always allowed).
    // caller !== _popupOwner means a stale onExited from the previous icon — ignore it.
    function hidePopup(caller) {
        if (caller === undefined || caller === _popupOwner) _hideTimer.restart()
    }

    // Grace period matching the hide animation so crossing a gap between two
    // icons keeps the popup alive and lets x slide rather than destroy+recreate.
    Timer {
        id: _hideTimer
        interval: 250
        onTriggered: barGroup._popupVisible = false
    }

    // ── Bar window ─────────────────────────────────────────────────────────────
    PanelWindow {
        id: barWindow
        screen: barGroup.modelData

        exclusiveZone: Commons.Appearance.bar.height + Commons.Appearance.bar.marginTop
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell:bar"

        anchors { top: true; left: true; right: true }
        // Taller than the bar so popup can render below — mask controls input area
        implicitHeight: Commons.Appearance.bar.height + Commons.Appearance.bar.marginTop + 220
        color: "transparent"
        // Input mask: only bar strip (+ popup footprint when open) receives events
        mask: Region { item: _inputMask }

        Rectangle {
            id: pill
            z: 1  // renders on top of popup so pill covers the popup's flat top edge
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

                Item { Layout.fillWidth: true }

                // ── RIGHT: System tray ─────────────────────────────────────────
                Row {
                    spacing: 0
                    Layout.alignment: Qt.AlignVCenter

                    // Mic
                    Item {
                        id: micItem
                        height: Commons.Appearance.bar.height
                        width: micIcon.implicitWidth + 10
                        property bool _hovered: false

                        Text {
                            id: micIcon
                            anchors.centerIn: parent
                            text: MediaServices.Audio.micMuted ? "󰍭" : "󰍬"
                            color: MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: MediaServices.Audio.toggleMicMute()
                            onEntered: {
                                micItem._hovered = true
                                micIcon.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "MICROPHONE",
                                    MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active",
                                    "", "Click to toggle")
                            }
                            onExited: {
                                micItem._hovered = false
                                micIcon.color = MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                                barGroup.hidePopup(parent)
                            }
                        }
                        Connections {
                            target: MediaServices.Audio
                            function onMicMutedChanged() {
                                if (micItem._hovered && barGroup._popupVisible)
                                    barGroup._popupPrimary = MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active"
                            }
                        }
                    }

                    // Volume
                    Item {
                        id: volItem
                        height: Commons.Appearance.bar.height
                        width: volRow.implicitWidth + 10
                        property bool _hovered: false

                        Row {
                            id: volRow
                            spacing: 4
                            anchors.centerIn: parent
                            Text {
                                id: volIcon
                                text: MediaServices.Audio.muted ? "󰖁" : MediaServices.Audio.volume > 66 ? "󰕾" : MediaServices.Audio.volume > 33 ? "󰖀" : "󰕿"
                                color: MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
                                font.pixelSize: 18; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            }
                            Text {
                                text: MediaServices.Audio.volume + "%"
                                color: Commons.Appearance.colors.overlay1
                                font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: MediaServices.Audio.toggleMute()
                            onEntered: {
                                volItem._hovered = true
                                volIcon.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "VOLUME",
                                    MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%",
                                    "", "Scroll to adjust · Click to mute")
                            }
                            onExited: {
                                volItem._hovered = false
                                volIcon.color = MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
                                barGroup.hidePopup(parent)
                            }
                            onWheel: wheel => {
                                var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                MediaServices.Audio.setVolume(Math.max(0, Math.min(100, MediaServices.Audio.volume + delta)))
                            }
                        }
                        Connections {
                            target: MediaServices.Audio
                            function onVolumeChanged() {
                                if (volItem._hovered && barGroup._popupVisible)
                                    barGroup._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
                            }
                            function onMutedChanged() {
                                if (volItem._hovered && barGroup._popupVisible)
                                    barGroup._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
                            }
                        }
                    }

                    // Brightness
                    Item {
                        id: brightItem
                        height: Commons.Appearance.bar.height
                        width: brightRow.implicitWidth + 10
                        property bool _hovered: false

                        Row {
                            id: brightRow
                            spacing: 4
                            anchors.centerIn: parent
                            Text {
                                id: brightIcon
                                text: HardwareServices.Brightness.percent >= 75 ? "󰃠"
                                    : HardwareServices.Brightness.percent >= 40 ? "󰃟"
                                    :                                              "󰃞"
                                color: Commons.Appearance.colors.yellow
                                font.pixelSize: 18; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: HardwareServices.Brightness.percent + "%"
                                color: Commons.Appearance.colors.overlay1
                                font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onEntered: {
                                brightItem._hovered = true
                                brightIcon.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "BRIGHTNESS",
                                    "󰃠  " + HardwareServices.Brightness.percent + "%",
                                    "", "Scroll to adjust")
                            }
                            onExited: {
                                brightItem._hovered = false
                                brightIcon.color = Commons.Appearance.colors.yellow
                                barGroup.hidePopup(parent)
                            }
                            onWheel: wheel => {
                                var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                HardwareServices.Brightness.adjust(delta)
                            }
                        }
                        Connections {
                            target: HardwareServices.Brightness
                            function onPercentChanged() {
                                if (brightItem._hovered && barGroup._popupVisible)
                                    barGroup._popupPrimary = "󰃠  " + HardwareServices.Brightness.percent + "%"
                            }
                        }
                    }

                    // Network
                    Item {
                        height: Commons.Appearance.bar.height
                        width: netIcon.implicitWidth + 10

                        Text {
                            id: netIcon
                            anchors.centerIn: parent
                            text: NetworkServices.Network.icon()
                            color: NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: networkCmd.running = true
                            onEntered: {
                                netIcon.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "NETWORK",
                                    NetworkServices.Network.connected
                                        ? "󰖩  " + NetworkServices.Network.ssid + "   ·   " + NetworkServices.Network.signal + "%  ·  " + NetworkServices.Network.band
                                        : "󰖪  Disconnected",
                                    "", "Click to open network settings")
                            }
                            onExited: {
                                netIcon.color = NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
                                barGroup.hidePopup(parent)
                            }
                        }
                    }

                    // Bluetooth
                    Item {
                        height: Commons.Appearance.bar.height
                        width: btIcon.implicitWidth + 10

                        Text {
                            id: btIcon
                            anchors.centerIn: parent
                            text: NetworkServices.Bluetooth.icon()
                            color: NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                                 : NetworkServices.Bluetooth.enabled   ? Commons.Appearance.colors.subtext1
                                 :                                        Commons.Appearance.colors.overlay0
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: bluetoothCmd.running = true
                            onEntered: {
                                btIcon.color = Commons.Appearance.colors.accent
                                barGroup.showPopup(parent, "BLUETOOTH",
                                    NetworkServices.Bluetooth.connected ? "󰂱  " + NetworkServices.Bluetooth.device
                                        : NetworkServices.Bluetooth.enabled ? "󰂯  On — no device" : "󰂲  Off",
                                    "", "Click to open bluetooth settings")
                            }
                            onExited: {
                                btIcon.color = NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                                    : NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.subtext1 : Commons.Appearance.colors.overlay0
                                barGroup.hidePopup(parent)
                            }
                        }
                    }

                    // Battery
                    Item {
                        visible: HardwareServices.Battery.present
                        height: Commons.Appearance.bar.height
                        width: batRow.implicitWidth + 10

                        Row {
                            id: batRow
                            spacing: 4
                            anchors.centerIn: parent
                            Text {
                                id: batIcon
                                text: HardwareServices.Battery.icon()
                                color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.green
                                font.pixelSize: 18; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: HardwareServices.Battery.percent + "%"
                                color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                                font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onEntered: barGroup.showPopup(parent, "BATTERY",
                                HardwareServices.Battery.icon() + "  " + HardwareServices.Battery.percent + "%",
                                HardwareServices.Battery.charging ? "󰂄  Charging" : "󱉞  On battery", "")
                            onExited: barGroup.hidePopup(parent)
                        }
                    }

                    // Notification bell + unread badge
                    Item {
                        height: Commons.Appearance.bar.height
                        width: bellIcon.implicitWidth + 10

                        Text {
                            id: bellIcon
                            anchors.centerIn: parent
                            text: "󰂚"
                            color: Commons.State.notificationCenterVisible
                                ? Commons.Appearance.colors.accent
                                : SystemServices.Notifications.unreadCount > 0
                                ? Commons.Appearance.colors.red
                                : Commons.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }

                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: Commons.State.notificationCenterVisible = !Commons.State.notificationCenterVisible
                            onEntered: if (!Commons.State.notificationCenterVisible) bellIcon.color = Commons.Appearance.colors.accent
                            onExited:  if (!Commons.State.notificationCenterVisible)
                                bellIcon.color = SystemServices.Notifications.unreadCount > 0
                                    ? Commons.Appearance.colors.red : Commons.Appearance.colors.subtext1
                        }
                    }

                    // Settings gear
                    Item {
                        height: Commons.Appearance.bar.height
                        width: settingsIcon.implicitWidth + 10

                        Text {
                            id: settingsIcon
                            anchors.centerIn: parent
                            text: "󰒓"
                            color: Commons.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: Commons.State.controlCenterVisible = !Commons.State.controlCenterVisible
                            onEntered: settingsIcon.color = Commons.Appearance.colors.accent
                            onExited:  settingsIcon.color = Commons.Appearance.colors.subtext1
                        }
                    }

                    // Power
                    Item {
                        height: Commons.Appearance.bar.height
                        width: powerIcon.implicitWidth + 10

                        Text {
                            id: powerIcon
                            anchors.centerIn: parent
                            text: "󰐥"
                            color: Commons.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: powerCmd.running = true
                            onEntered: powerIcon.color = Commons.Appearance.colors.red
                            onExited:  powerIcon.color = Commons.Appearance.colors.subtext1
                        }
                    }
                }
            }

            // Clock absolutely centered in the pill — unaffected by left/right section widths
            Text {
                id: centerClock
                anchors.centerIn: parent
                z: 1
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

        // ── Input mask ─────────────────────────────────────────────────────────
        Item {
            id: _inputMask
            x: 0; y: 0
            width: barWindow.width
            height: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
                  + (_popupCard.visible ? 220 : 0)
        }

        // ── Popup card — persistent, never destroyed ────────────────────────
        // Top edge wider than body; CCW arcs curve inward to body width; rounded bottom corners.
        Shape {
            id: _popupCard

            property real _r:  Commons.Appearance.radius.xl
            property real _rb: Commons.Appearance.radius.md
            property real _bw: _popupCol.implicitWidth + 28  // body width, ears add _r on each side

            x: Math.min(
                   Math.max(barGroup._popupAnchorX - width / 2,
                            Commons.Appearance.bar.marginSide + 4),
                   barWindow.width - width - Commons.Appearance.bar.marginSide - 4
               )
            y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
            width:  _bw + _r * 2
            height: _popupCol.implicitHeight + Commons.Appearance.spacing.md * 2

            layer.enabled: true
            layer.samples: 8

            transformOrigin: Item.Top
            scale:   barGroup._popupVisible ? 1.0 : 0.85
            opacity: barGroup._popupVisible ? 1.0 : 0.0
            visible: opacity > 0.01

            Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic }}

            ShapePath {
                fillColor:   Commons.Appearance.colors.glassBgLight
                strokeWidth: 0
                strokeColor: "transparent"

                startX: 0; startY: 0
                PathLine { x: _popupCard._bw + _popupCard._r * 2; y: 0 }
                PathArc  { x: _popupCard._bw + _popupCard._r; y: _popupCard._r
                           radiusX: _popupCard._r; radiusY: _popupCard._r
                           direction: PathArc.Counterclockwise }
                PathLine { x: _popupCard._bw + _popupCard._r; y: _popupCard.height - _popupCard._rb }
                PathArc  { x: _popupCard._bw + _popupCard._r - _popupCard._rb; y: _popupCard.height
                           radiusX: _popupCard._rb; radiusY: _popupCard._rb
                           direction: PathArc.Clockwise }
                PathLine { x: _popupCard._r + _popupCard._rb; y: _popupCard.height }
                PathArc  { x: _popupCard._r; y: _popupCard.height - _popupCard._rb
                           radiusX: _popupCard._rb; radiusY: _popupCard._rb
                           direction: PathArc.Clockwise }
                PathLine { x: _popupCard._r; y: _popupCard._r }
                PathArc  { x: 0; y: 0
                           radiusX: _popupCard._r; radiusY: _popupCard._r
                           direction: PathArc.Counterclockwise }
                PathLine { x: 0; y: 0 }
            }

            // Keep popup alive when cursor drifts onto it
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: _hideTimer.stop()
                onExited:  if (Date.now() - barGroup._lastShowTime > 200) barGroup.hidePopup()
            }

            Column {
                id: _popupCol
                x: _popupCard._r + 14; y: Commons.Appearance.spacing.md
                spacing: 3

                Text {
                    visible: barGroup._popupLabel.length > 0
                    text: barGroup._popupLabel
                    color: Commons.Appearance.colors.accent
                    font.pixelSize: Commons.Appearance.font.sizeSm - 1
                    font.family: Commons.Appearance.font.family
                    font.letterSpacing: 1.2
                    font.weight: Font.DemiBold
                }
                Text {
                    text: barGroup._popupPrimary
                    color: Commons.Appearance.colors.text
                    font.pixelSize: Commons.Appearance.font.sizeLg
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

        Process { id: powerCmd;     command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }
        Process { id: networkCmd;   command: ["bash", "-c", "nm-connection-editor &"]; running: false }
        Process { id: bluetoothCmd; command: ["bash", "-c", "blueman-manager &"]; running: false }
    }
}
