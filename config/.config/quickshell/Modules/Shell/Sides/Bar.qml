import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import "../../../Commons" as Commons
import "../../../Services/Media" as MediaServices
import "../../../Services/Hardware" as HardwareServices
import "../../../Services/Networking" as NetworkServices
import "../../../Services/Compositor" as CompositorServices
import "../../../Services/System" as SystemServices
import "../../../Services/Persistence" as Persistence
import "../../../Services/Shell" as ShellServices
import "../../Drawer" as Drawer

// Sprint 17 Stage 2b — Bar as a plain Item hosted inside ShellSurface (Stage 4).
// No PanelWindow / mask / exclusiveZone — those live on ShellSurface.
// Horizontal (top/bottom): full pill content + popups.
// Vertical (left/right): simplified icon Column; popups deferred to S18 widget extraction.
Item {
    id: bar

    required property string side
    required property var screen

    readonly property bool _horizontal: side === "top" || side === "bottom"
    readonly property bool _isTop:      side === "top"
    readonly property bool _isBottom:   side === "bottom"
    readonly property bool _isLeft:     side === "left"
    readonly property bool _isRight:    side === "right"
    readonly property int  thickness:   Commons.Appearance.bar.height

    implicitWidth:  _horizontal ? 0 : thickness
    implicitHeight: _horizontal ? thickness : 0

    // ── Shared popup state ─────────────────────────────────────────────────────
    property real    _popupAnchorX:   0
    property string  _popupLabel:     ""
    property string  _popupPrimary:   ""
    property string  _popupSecondary: ""
    property string  _popupHint:      ""
    property bool    _popupVisible:   false
    property real    _lastShowTime:   0
    property var     _popupOwner:     null

    property bool _calendarVisible:  false
    property int  _calendarYear:     new Date().getFullYear()
    property int  _calendarMonth:    new Date().getMonth() + 1

    property bool _wifiPopupVisible: false
    property bool _btPopupVisible:   false
    property real _wifiAnchorX:      0
    property real _btAnchorX:        0

    function calendarDays(year, month) {
        var days = []
        var first = (new Date(year, month - 1, 1).getDay() + 6) % 7
        var total = new Date(year, month, 0).getDate()
        for (var i = 0; i < first; i++) days.push(0)
        for (var j = 1; j <= total; j++) days.push(j)
        return days
    }
    function monthName(m) {
        return ["January","February","March","April","May","June",
                "July","August","September","October","November","December"][m - 1]
    }

    function showPopup(item, label, primary, secondary, hint) {
        _hideTimer.stop()
        _calHideTimer.stop()
        _calendarVisible = false
        _lastShowTime = Date.now()
        _popupOwner   = item
        var pt = item.mapToItem(bar, item.width / 2, 0)
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
        onTriggered: bar._popupVisible = false
    }
    Timer {
        id: _calHideTimer
        interval: 250
        onTriggered: bar._calendarVisible = false
    }

    // ── Pill — anchored to bar's edge based on orientation ───────────────────
    Rectangle {
        id: pill
        z: 1  // renders on top of popup so pill covers the popup's flat top edge
        radius: 0
        color: Commons.Appearance.colors.glassBgLight

        // Anchor 3 sides — all except the one opposite to `bar.side`.
        // Long axis is auto-derived from paired anchors; cross axis comes
        // from width/height below (anchored axes ignore explicit size).
        anchors.top:    bar._isBottom ? undefined : parent.top
        anchors.bottom: bar._isTop    ? undefined : parent.bottom
        anchors.left:   bar._isRight  ? undefined : parent.left
        anchors.right:  bar._isLeft   ? undefined : parent.right

        anchors.topMargin:    Commons.Appearance.bar.marginTop
        anchors.bottomMargin: Commons.Appearance.bar.marginTop
        anchors.leftMargin:   Commons.Appearance.bar.marginSide
        anchors.rightMargin:  Commons.Appearance.bar.marginSide

        // Cross-axis size — overridden by anchors on the long axis.
        width:  bar.thickness
        height: bar.thickness

            // ── Horizontal layout (top/bottom) ─────────────────────────────
            RowLayout {
                visible: bar._horizontal
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
                            model: CompositorServices.MangoWC.tagsFor(bar.screen ? bar.screen.name : "")
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
                                        bar.screen ? bar.screen.name : "", modelData.num)
                                }
                            }
                        }
                    }

                    Item { width: 14 }

                    // Window title
                    Text {
                        property string raw: CompositorServices.MangoWC.titleFor(bar.screen ? bar.screen.name : "")
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
                        visible: Persistence.Config.get("bar.modules.music", true)

                        property bool active: MediaServices.MprisService.playing === true
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

                        // Hover-only MA — no buttons consumed, so mprisIcon click still works
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                            onEntered: bar.showPopup(parent, "NOW PLAYING",
                                MediaServices.MprisService.title  || "—",
                                MediaServices.MprisService.artist || "",
                                "Click icon to play / pause")
                            onExited: bar.hidePopup(parent)
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
                                bar.showPopup(parent, "MICROPHONE",
                                    MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active",
                                    "", "Click to toggle")
                            }
                            onExited: {
                                micItem._hovered = false
                                micIcon.color = MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                                bar.hidePopup(parent)
                            }
                        }
                        Connections {
                            target: MediaServices.Audio
                            function onMicMutedChanged() {
                                if (micItem._hovered && bar._popupVisible)
                                    bar._popupPrimary = MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active"
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
                                bar.showPopup(parent, "VOLUME",
                                    MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%",
                                    "", "Scroll to adjust · Click to mute")
                            }
                            onExited: {
                                volItem._hovered = false
                                volIcon.color = MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
                                bar.hidePopup(parent)
                            }
                            onWheel: wheel => {
                                var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                MediaServices.Audio.setVolume(Math.max(0, Math.min(100, MediaServices.Audio.volume + delta)))
                            }
                        }
                        Connections {
                            target: MediaServices.Audio
                            function onVolumeChanged() {
                                if (volItem._hovered && bar._popupVisible)
                                    bar._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
                            }
                            function onMutedChanged() {
                                if (volItem._hovered && bar._popupVisible)
                                    bar._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
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
                                bar.showPopup(parent, "BRIGHTNESS",
                                    "󰃠  " + HardwareServices.Brightness.percent + "%",
                                    "", "Scroll to adjust")
                            }
                            onExited: {
                                brightItem._hovered = false
                                brightIcon.color = Commons.Appearance.colors.yellow
                                bar.hidePopup(parent)
                            }
                            onWheel: wheel => {
                                var delta = wheel.angleDelta.y > 0 ? 5 : -5
                                HardwareServices.Brightness.adjust(delta)
                            }
                        }
                        Connections {
                            target: HardwareServices.Brightness
                            function onPercentChanged() {
                                if (brightItem._hovered && bar._popupVisible)
                                    bar._popupPrimary = "󰃠  " + HardwareServices.Brightness.percent + "%"
                            }
                        }
                    }

                    // Network
                    Item {
                        visible: Persistence.Config.get("bar.modules.wifi", true)
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
                            onClicked: {
                                if (bar._wifiPopupVisible) {
                                    bar._wifiPopupVisible = false
                                } else {
                                    var pt = parent.mapToItem(bar, parent.width / 2, 0)
                                    bar._wifiAnchorX      = pt.x
                                    bar._wifiPopupVisible = true
                                    bar._btPopupVisible   = false
                                    bar._calendarVisible  = false
                                    bar._popupVisible     = false
                                }
                            }
                            onEntered: {
                                netIcon.color = Commons.Appearance.colors.accent
                                if (!bar._wifiPopupVisible)
                                    bar.showPopup(parent, "NETWORK",
                                        NetworkServices.Network.connected
                                            ? "󰖩  " + NetworkServices.Network.ssid + "   ·   " + NetworkServices.Network.signal + "%  ·  " + NetworkServices.Network.band
                                            : "󰖪  Disconnected",
                                        "", "Click to manage WiFi")
                            }
                            onExited: {
                                netIcon.color = NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
                                bar.hidePopup(parent)
                            }
                        }
                    }

                    // Bluetooth
                    Item {
                        visible: Persistence.Config.get("bar.modules.bluetooth", true)
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
                            onClicked: {
                                if (bar._btPopupVisible) {
                                    bar._btPopupVisible = false
                                } else {
                                    var pt = parent.mapToItem(bar, parent.width / 2, 0)
                                    bar._btAnchorX        = pt.x
                                    bar._btPopupVisible   = true
                                    bar._wifiPopupVisible = false
                                    bar._calendarVisible  = false
                                    bar._popupVisible     = false
                                }
                            }
                            onEntered: {
                                btIcon.color = Commons.Appearance.colors.accent
                                if (!bar._btPopupVisible)
                                    bar.showPopup(parent, "BLUETOOTH",
                                        NetworkServices.Bluetooth.connected ? "󰂱  " + NetworkServices.Bluetooth.device
                                            : NetworkServices.Bluetooth.enabled ? "󰂯  On — no device" : "󰂲  Off",
                                        "", "Click to manage Bluetooth")
                            }
                            onExited: {
                                btIcon.color = NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                                    : NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.subtext1 : Commons.Appearance.colors.overlay0
                                bar.hidePopup(parent)
                            }
                        }
                    }

                    // Battery
                    Item {
                        visible: HardwareServices.Battery.present && Persistence.Config.get("bar.modules.battery", true)
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
                            onEntered: bar.showPopup(parent, "BATTERY",
                                HardwareServices.Battery.icon() + "  " + HardwareServices.Battery.percent + "%",
                                HardwareServices.Battery.charging ? "󰂄  Charging" : "󱉞  On battery", "")
                            onExited: bar.hidePopup(parent)
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
                            color: Drawer.DrawerVisibilities.ncVisible
                                ? Commons.Appearance.colors.accent
                                : SystemServices.Notifications.unreadCount > 0
                                ? Commons.Appearance.colors.red
                                : Commons.Appearance.colors.subtext1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }

                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onClicked: {
                                bar._wifiPopupVisible = false
                                bar._btPopupVisible   = false
                                if (!Drawer.DrawerVisibilities.ncVisible)
                                    SystemServices.Notifications.unreadCount = 0
                                Drawer.DrawerVisibilities.ncVisible = !Drawer.DrawerVisibilities.ncVisible
                            }
                            onEntered: {
                                if (!Drawer.DrawerVisibilities.ncVisible) bellIcon.color = Commons.Appearance.colors.accent
                                bar.showPopup(parent, "NOTIFICATIONS",
                                    SystemServices.Notifications.unreadCount > 0
                                        ? "󰂚  " + SystemServices.Notifications.unreadCount + " unread"
                                        : "󰂜  All caught up",
                                    SystemServices.Notifications.dndEnabled ? "󰂛  Do not disturb on" : "",
                                    "Click to toggle")
                            }
                            onExited: {
                                if (!Drawer.DrawerVisibilities.ncVisible)
                                    bellIcon.color = SystemServices.Notifications.unreadCount > 0
                                        ? Commons.Appearance.colors.red : Commons.Appearance.colors.subtext1
                                bar.hidePopup(parent)
                            }
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
                            onClicked: {
                                bar._wifiPopupVisible = false
                                bar._btPopupVisible   = false
                                Drawer.DrawerVisibilities.ccVisible = !Drawer.DrawerVisibilities.ccVisible
                            }
                            onEntered: {
                                settingsIcon.color = Commons.Appearance.colors.accent
                                bar.showPopup(parent, "SETTINGS", "󰒓  Control Center", "", "Click to toggle")
                            }
                            onExited: {
                                settingsIcon.color = Commons.Appearance.colors.subtext1
                                bar.hidePopup(parent)
                            }
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
                            onEntered: {
                                powerIcon.color = Commons.Appearance.colors.red
                                bar.showPopup(parent, "POWER", "󰐥  Power menu", "", "Click to open")
                            }
                            onExited: {
                                powerIcon.color = Commons.Appearance.colors.subtext1
                                bar.hidePopup(parent)
                            }
                        }
                    }
                }
            }

            // ── Vertical layout (left/right) — simplified icons, no popups ───
            // Bar widgets are stacked top-to-bottom on narrow vertical bars.
            // No tags/title/MPRIS/clock — S18 widget extraction will give each
            // widget proper orientation awareness. Hover popups are skipped.
            Column {
                visible: !bar._horizontal
                anchors.centerIn: parent
                spacing: 12

                // Mic
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: MediaServices.Audio.micMuted ? "󰍭" : "󰍬"
                        color: MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    }
                    TapHandler { onTapped: MediaServices.Audio.toggleMicMute() }
                }

                // Volume
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: MediaServices.Audio.muted ? "󰖁" : MediaServices.Audio.volume > 66 ? "󰕾" : MediaServices.Audio.volume > 33 ? "󰖀" : "󰕿"
                        color: MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                    TapHandler { onTapped: MediaServices.Audio.toggleMute() }
                }

                // Network
                Item {
                    visible: Persistence.Config.get("bar.modules.wifi", true)
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: NetworkServices.Network.icon()
                        color: NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                }

                // Bluetooth
                Item {
                    visible: Persistence.Config.get("bar.modules.bluetooth", true)
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: NetworkServices.Bluetooth.icon()
                        color: NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                             : NetworkServices.Bluetooth.enabled   ? Commons.Appearance.colors.subtext1
                             :                                        Commons.Appearance.colors.overlay0
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                }

                // Battery
                Item {
                    visible: HardwareServices.Battery.present && Persistence.Config.get("bar.modules.battery", true)
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: HardwareServices.Battery.icon()
                        color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.green
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                }

                // Notification bell
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: "󰂚"
                        color: Drawer.DrawerVisibilities.ncVisible       ? Commons.Appearance.colors.accent
                             : SystemServices.Notifications.unreadCount > 0 ? Commons.Appearance.colors.red
                             :                                                 Commons.Appearance.colors.subtext1
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                    TapHandler {
                        onTapped: {
                            if (!Drawer.DrawerVisibilities.ncVisible)
                                SystemServices.Notifications.unreadCount = 0
                            Drawer.DrawerVisibilities.ncVisible = !Drawer.DrawerVisibilities.ncVisible
                        }
                    }
                }

                // Settings (Control Center)
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: "󰒓"
                        color: Drawer.DrawerVisibilities.ccVisible ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                    TapHandler { onTapped: Drawer.DrawerVisibilities.ccVisible = !Drawer.DrawerVisibilities.ccVisible }
                }

                // Power
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 24; height: 24
                    Text {
                        anchors.centerIn: parent
                        text: "󰐥"
                        color: Commons.Appearance.colors.subtext1
                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                    }
                    TapHandler { onTapped: powerCmd.running = true }
                }
            }

            // Clock absolutely centered in the pill — unaffected by left/right section widths
            Text {
                id: centerClock
                visible: bar._horizontal
                anchors.centerIn: parent
                z: 1
                textFormat: Text.RichText
                text: clockText()
                font.pixelSize: Commons.Appearance.font.sizeMd
                font.family: Commons.Appearance.font.family
                function clockText() {
                    return "<span style='color:" + Commons.Appearance.colors.text + ";font-weight:600'>"
                        + Qt.formatDateTime(new Date(), Persistence.Config.get("bar.clockFormat", "HH:mm"))
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

            // Transparent hover region over the clock — opens calendar popup
            MouseArea {
                visible: bar._horizontal
                anchors.centerIn: parent
                width: centerClock.implicitWidth + 24
                height: parent.height
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                z: 2
                onEntered: {
                    bar._calendarYear      = new Date().getFullYear()
                    bar._calendarMonth     = new Date().getMonth() + 1
                    _calHideTimer.stop()
                    _hideTimer.stop()
                    bar._popupVisible      = false
                    bar._wifiPopupVisible  = false
                    bar._btPopupVisible    = false
                    bar._calendarVisible   = true
                }
                onExited: _calHideTimer.restart()
            }
        }


        // ── Popup card — persistent, never destroyed ────────────────────────
        // Top edge wider than body; CCW arcs curve inward to body width; rounded bottom corners.
        Shape {
            id: _popupCard

            property real _r:  Commons.Appearance.radius.xl
            property real _rb: Commons.Appearance.radius.md
            property real _bw: _popupCol.implicitWidth + 28  // body width, ears add _r on each side

            x: Math.min(
                   Math.max(bar._popupAnchorX - width / 2,
                            Commons.Appearance.bar.marginSide + 4),
                   bar.width - width - Commons.Appearance.bar.marginSide - 4
               )
            y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
            width:  _bw + _r * 2
            height: _popupCol.implicitHeight + Commons.Appearance.spacing.md * 2

            layer.enabled: true
            layer.samples: 8

            transformOrigin: Item.Top
            scale:   bar._popupVisible ? 1.0 : 0.85
            opacity: bar._popupVisible ? 1.0 : 0.0
            visible: bar._isTop && opacity > 0.01

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
                onExited:  if (Date.now() - bar._lastShowTime > 200) bar.hidePopup()
            }

            Column {
                id: _popupCol
                x: _popupCard._r + 14; y: Commons.Appearance.spacing.md
                spacing: 3

                Text {
                    visible: bar._popupLabel.length > 0
                    text: bar._popupLabel
                    color: Commons.Appearance.colors.accent
                    font.pixelSize: Commons.Appearance.font.sizeSm - 1
                    font.family: Commons.Appearance.font.family
                    font.letterSpacing: 1.2
                    font.weight: Font.DemiBold
                }
                Text {
                    text: bar._popupPrimary
                    color: Commons.Appearance.colors.text
                    font.pixelSize: Commons.Appearance.font.sizeLg
                    font.family: Commons.Appearance.font.family
                    font.weight: Font.Medium
                }
                Text {
                    visible: bar._popupSecondary.length > 0
                    text: bar._popupSecondary
                    color: Commons.Appearance.colors.subtext0
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                }
                Text {
                    visible: bar._popupHint.length > 0
                    text: bar._popupHint
                    color: Commons.Appearance.colors.overlay0
                    font.pixelSize: Commons.Appearance.font.sizeSm - 1
                    font.family: Commons.Appearance.font.family
                }
            }
        }

        // Calendar popup — same ear+arc shape as _popupCard so it merges with the bar
        Shape {
            id: _calendarCard

            property real cellW: 28
            property real cellH: 22
            property real _r:    Commons.Appearance.radius.xl   // ear radius (matches pill)
            property real _rb:   Commons.Appearance.radius.md   // bottom corner radius
            property real _bw:   cellW * 7 + 24                 // body width (content + padding)

            x: Math.max(
                   Commons.Appearance.bar.marginSide + 4,
                   Math.min(bar.width / 2 - (_bw + _r * 2) / 2,
                            bar.width - (_bw + _r * 2) - Commons.Appearance.bar.marginSide - 4))
            y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
            width:  _bw + _r * 2
            height: _calCol.implicitHeight + 20

            layer.enabled: true
            layer.samples: 8

            transformOrigin: Item.Top
            scale:   bar._calendarVisible ? 1.0 : 0.85
            opacity: bar._calendarVisible ? 1.0 : 0.0
            visible: bar._isTop && opacity > 0.01

            Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ShapePath {
                fillColor:   Commons.Appearance.colors.glassBgLight
                strokeWidth: 0
                strokeColor: "transparent"

                // Flat top ear-to-ear, CCW arcs curve inward to body width (same as _popupCard)
                startX: 0; startY: 0
                PathLine { x: _calendarCard._bw + _calendarCard._r * 2; y: 0 }
                PathArc  { x: _calendarCard._bw + _calendarCard._r;     y: _calendarCard._r
                           radiusX: _calendarCard._r; radiusY: _calendarCard._r
                           direction: PathArc.Counterclockwise }
                PathLine { x: _calendarCard._bw + _calendarCard._r;     y: _calendarCard.height - _calendarCard._rb }
                PathArc  { x: _calendarCard._bw + _calendarCard._r - _calendarCard._rb; y: _calendarCard.height
                           radiusX: _calendarCard._rb; radiusY: _calendarCard._rb
                           direction: PathArc.Clockwise }
                PathLine { x: _calendarCard._r + _calendarCard._rb;     y: _calendarCard.height }
                PathArc  { x: _calendarCard._r;                         y: _calendarCard.height - _calendarCard._rb
                           radiusX: _calendarCard._rb; radiusY: _calendarCard._rb
                           direction: PathArc.Clockwise }
                PathLine { x: _calendarCard._r;                         y: _calendarCard._r }
                PathArc  { x: 0;                                        y: 0
                           radiusX: _calendarCard._r; radiusY: _calendarCard._r
                           direction: PathArc.Counterclockwise }
                PathLine { x: 0;                                        y: 0 }
            }

            MouseArea {
                anchors.fill: parent; hoverEnabled: true
                onEntered: { _calHideTimer.stop(); _hideTimer.stop(); bar._popupVisible = false }
                onExited:  _calHideTimer.restart()
            }

            Column {
                id: _calCol
                x: _calendarCard._r + 12; y: 10
                width: _calendarCard._bw - 24
                spacing: 4

                // Month navigation
                Row {
                    width: parent.width

                    Text {
                        text: "‹"
                        color: Commons.Appearance.colors.subtext1
                        font.pixelSize: Commons.Appearance.font.sizeMd
                        font.family: Commons.Appearance.font.family
                        width: 20; horizontalAlignment: Text.AlignHCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (bar._calendarMonth === 1) { bar._calendarMonth = 12; bar._calendarYear-- }
                                else bar._calendarMonth--
                            }
                        }
                    }

                    Text {
                        text: bar.monthName(bar._calendarMonth) + " " + bar._calendarYear
                        color: Commons.Appearance.colors.text
                        font.pixelSize: Commons.Appearance.font.sizeMd
                        font.family: Commons.Appearance.font.family
                        font.weight: Font.Medium
                        width: parent.width - 40
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: "›"
                        color: Commons.Appearance.colors.subtext1
                        font.pixelSize: Commons.Appearance.font.sizeMd
                        font.family: Commons.Appearance.font.family
                        width: 20; horizontalAlignment: Text.AlignHCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (bar._calendarMonth === 12) { bar._calendarMonth = 1; bar._calendarYear++ }
                                else bar._calendarMonth++
                            }
                        }
                    }
                }

                // Day-of-week headers
                Row {
                    spacing: 0
                    Repeater {
                        model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                        delegate: Text {
                            required property string modelData
                            text: modelData
                            width: _calendarCard.cellW
                            horizontalAlignment: Text.AlignHCenter
                            color: Commons.Appearance.colors.overlay1
                            font.pixelSize: Commons.Appearance.font.sizeSm - 1
                            font.family: Commons.Appearance.font.family
                        }
                    }
                }

                // Day grid
                Grid {
                    columns: 7
                    rowSpacing: 0
                    columnSpacing: 0

                    Repeater {
                        model: bar.calendarDays(bar._calendarYear, bar._calendarMonth)
                        delegate: Item {
                            required property int modelData
                            property bool isToday: {
                                var now = new Date()
                                return modelData > 0
                                    && modelData === now.getDate()
                                    && bar._calendarMonth === (now.getMonth() + 1)
                                    && bar._calendarYear  === now.getFullYear()
                            }
                            width: _calendarCard.cellW
                            height: _calendarCard.cellH

                            Rectangle {
                                anchors.centerIn: parent
                                width: 20; height: 20
                                radius: Commons.Appearance.radius.pill
                                color: parent.isToday ? Commons.Appearance.colors.accent : "transparent"
                                visible: parent.modelData > 0
                            }

                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData > 0 ? parent.modelData : ""
                                color: parent.isToday ? Commons.Appearance.colors.base : Commons.Appearance.colors.text
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                                font.weight: parent.isToday ? Font.Medium : Font.Normal
                            }
                        }
                    }
                }
            }
        }

        Process { id: powerCmd; command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }

        // ── WiFi popup ─────────────────────────────────────────────────────────
        Shape {
            id: _wifiCard

            property real _r:  Commons.Appearance.radius.xl
            property real _rb: Commons.Appearance.radius.md
            property real _bw: 260

            x: Math.min(
                   Math.max(bar._wifiAnchorX - width / 2,
                            Commons.Appearance.bar.marginSide + 4),
                   bar.width - width - Commons.Appearance.bar.marginSide - 4)
            y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
            width:  _bw + _r * 2
            height: _wifiContent.implicitHeight + 20

            layer.enabled: true
            layer.samples: 8
            transformOrigin: Item.Top
            scale:   bar._wifiPopupVisible ? 1.0 : 0.85
            opacity: bar._wifiPopupVisible ? 1.0 : 0.0
            visible: bar._isTop && opacity > 0.01
            Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ShapePath {
                fillColor: Commons.Appearance.colors.glassBgLight
                strokeWidth: 0; strokeColor: "transparent"
                startX: 0; startY: 0
                PathLine { x: _wifiCard._bw + _wifiCard._r * 2; y: 0 }
                PathArc  { x: _wifiCard._bw + _wifiCard._r;     y: _wifiCard._r
                           radiusX: _wifiCard._r; radiusY: _wifiCard._r; direction: PathArc.Counterclockwise }
                PathLine { x: _wifiCard._bw + _wifiCard._r;     y: _wifiCard.height - _wifiCard._rb }
                PathArc  { x: _wifiCard._bw + _wifiCard._r - _wifiCard._rb; y: _wifiCard.height
                           radiusX: _wifiCard._rb; radiusY: _wifiCard._rb; direction: PathArc.Clockwise }
                PathLine { x: _wifiCard._r + _wifiCard._rb;     y: _wifiCard.height }
                PathArc  { x: _wifiCard._r;                     y: _wifiCard.height - _wifiCard._rb
                           radiusX: _wifiCard._rb; radiusY: _wifiCard._rb; direction: PathArc.Clockwise }
                PathLine { x: _wifiCard._r;                     y: _wifiCard._r }
                PathArc  { x: 0;                                y: 0
                           radiusX: _wifiCard._r; radiusY: _wifiCard._r; direction: PathArc.Counterclockwise }
                PathLine { x: 0; y: 0 }
            }

            MouseArea {
                anchors.fill: parent; hoverEnabled: true
                onEntered: { _hideTimer.stop(); _calHideTimer.stop() }
            }

            Column {
                id: _wifiContent
                x: _wifiCard._r + 12; y: 10
                width: _wifiCard._bw - 24
                spacing: 0

                // Header: adapter toggle + label + close
                Item {
                    width: parent.width; height: 40
                    RowLayout {
                        anchors.fill: parent; spacing: 8
                        Rectangle {
                            width: 28; height: 28; radius: Commons.Appearance.radius.base
                            color: NetworkServices.Network.wifiEnabled ? Commons.Appearance.colors.accent : Commons.Appearance.colors.surface0
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            Text {
                                anchors.centerIn: parent
                                text: NetworkServices.Network.icon()
                                color: NetworkServices.Network.wifiEnabled ? Commons.Appearance.colors.base : Commons.Appearance.colors.overlay0
                                font.pixelSize: 13; font.family: Commons.Appearance.font.family
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: NetworkServices.Network.toggleWifi() }
                        }
                        Text {
                            text: !NetworkServices.Network.wifiEnabled ? "WiFi — Off"
                                : NetworkServices.Network.connected ? "WiFi · " + NetworkServices.Network.ssid : "WiFi — Not connected"
                            color: NetworkServices.Network.wifiEnabled ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeMd; font.family: Commons.Appearance.font.family
                            font.weight: Font.Medium; Layout.fillWidth: true; elide: Text.ElideRight
                        }
                        Text {
                            text: "✕"
                            color: _wifiCloseMA.containsMouse ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                            font.pixelSize: 11; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            MouseArea { id: _wifiCloseMA; anchors.fill: parent; anchors.margins: -4; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: bar._wifiPopupVisible = false }
                        }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: Commons.Appearance.colors.surface0 }

                // Adapter-off placeholder
                Item {
                    width: parent.width; height: 32
                    visible: !NetworkServices.Network.wifiEnabled
                    Text {
                        anchors.centerIn: parent
                        text: "Enable WiFi to see networks"
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                    }
                }

                // Network list (up to 5, sorted: active → saved → available)
                Repeater {
                    model: NetworkServices.Network.wifiEnabled ? NetworkServices.Network.displayNetworks.slice(0, 5) : []
                    delegate: Item {
                        required property var modelData
                        width: parent.width; height: 32
                        property bool _busy: NetworkServices.Network.connectingTo === modelData.ssid
                            || (modelData.active && NetworkServices.Network.disconnectingFrom === modelData.ssid)
                        property bool _needsPw: !modelData.saved
                            && modelData.security !== "" && modelData.security !== "--"
                        RowLayout {
                            anchors.fill: parent; spacing: 6
                            Text {
                                text: NetworkServices.Network.signalIcon(
                                    modelData.signal, modelData.security !== "" && modelData.security !== "--")
                                color: modelData.active ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                font.pixelSize: 13; font.family: Commons.Appearance.font.family
                            }
                            Text {
                                text: modelData.ssid
                                color: modelData.active ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                                font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                            Item {
                                width: _busy ? 20 : _wBtnTxt.implicitWidth + 16; height: 22
                                Behavior on width { NumberAnimation { duration: Commons.Appearance.anim.fast } }
                                Text {
                                    id: _wBtnSpinner; visible: _busy; anchors.centerIn: parent
                                    text: "󰑙"; color: Commons.Appearance.colors.accent
                                    font.pixelSize: 13; font.family: Commons.Appearance.font.family
                                    RotationAnimator { target: _wBtnSpinner; running: _busy; loops: Animation.Infinite; from: 0; to: 360; duration: 900 }
                                }
                                Rectangle {
                                    id: _wBtn; visible: !_busy; anchors.fill: parent
                                    radius: Commons.Appearance.radius.sm
                                    color: _wBtnMA.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                    Text {
                                        id: _wBtnTxt; anchors.centerIn: parent
                                        text: modelData.active ? "Disconnect" : (_needsPw ? "Open CC" : "Connect")
                                        color: modelData.active ? Commons.Appearance.colors.red
                                            : _needsPw ? Commons.Appearance.colors.subtext0
                                            : Commons.Appearance.colors.mauve
                                        font.pixelSize: Commons.Appearance.font.sizeSm - 1; font.family: Commons.Appearance.font.family
                                    }
                                    MouseArea {
                                        id: _wBtnMA; anchors.fill: parent; hoverEnabled: true
                                        onClicked: {
                                            if (modelData.active) {
                                                NetworkServices.Network.disconnect()
                                            } else if (_needsPw) {
                                                Commons.State.controlCenterOpenSection = "wifi"
                                                Drawer.DrawerVisibilities.ccVisible = true
                                                bar._wifiPopupVisible = false
                                            } else {
                                                NetworkServices.Network.connect(modelData.ssid)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Rescan
                Item {
                    width: parent.width; height: 28
                    visible: NetworkServices.Network.wifiEnabled
                    Text {
                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                        text: NetworkServices.Network.scanning ? "Scanning…" : "󰑙  Rescan"
                        color: NetworkServices.Network.scanning ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.mauve
                        font.pixelSize: Commons.Appearance.font.sizeSm - 1; font.family: Commons.Appearance.font.family
                        MouseArea {
                            anchors.fill: parent; anchors.margins: -4
                            enabled: !NetworkServices.Network.scanning; cursorShape: Qt.PointingHandCursor
                            onClicked: NetworkServices.Network.scan()
                        }
                    }
                }
            }
        }

        // ── Bluetooth popup ────────────────────────────────────────────────────
        Shape {
            id: _btCard

            property real _r:  Commons.Appearance.radius.xl
            property real _rb: Commons.Appearance.radius.md
            property real _bw: 240

            x: Math.min(
                   Math.max(bar._btAnchorX - width / 2,
                            Commons.Appearance.bar.marginSide + 4),
                   bar.width - width - Commons.Appearance.bar.marginSide - 4)
            y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
            width:  _bw + _r * 2
            height: _btContent.implicitHeight + 20

            layer.enabled: true
            layer.samples: 8
            transformOrigin: Item.Top
            scale:   bar._btPopupVisible ? 1.0 : 0.85
            opacity: bar._btPopupVisible ? 1.0 : 0.0
            visible: bar._isTop && opacity > 0.01
            Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ShapePath {
                fillColor: Commons.Appearance.colors.glassBgLight
                strokeWidth: 0; strokeColor: "transparent"
                startX: 0; startY: 0
                PathLine { x: _btCard._bw + _btCard._r * 2; y: 0 }
                PathArc  { x: _btCard._bw + _btCard._r;     y: _btCard._r
                           radiusX: _btCard._r; radiusY: _btCard._r; direction: PathArc.Counterclockwise }
                PathLine { x: _btCard._bw + _btCard._r;     y: _btCard.height - _btCard._rb }
                PathArc  { x: _btCard._bw + _btCard._r - _btCard._rb; y: _btCard.height
                           radiusX: _btCard._rb; radiusY: _btCard._rb; direction: PathArc.Clockwise }
                PathLine { x: _btCard._r + _btCard._rb;     y: _btCard.height }
                PathArc  { x: _btCard._r;                   y: _btCard.height - _btCard._rb
                           radiusX: _btCard._rb; radiusY: _btCard._rb; direction: PathArc.Clockwise }
                PathLine { x: _btCard._r;                   y: _btCard._r }
                PathArc  { x: 0;                            y: 0
                           radiusX: _btCard._r; radiusY: _btCard._r; direction: PathArc.Counterclockwise }
                PathLine { x: 0; y: 0 }
            }

            MouseArea {
                anchors.fill: parent; hoverEnabled: true
                onEntered: { _hideTimer.stop(); _calHideTimer.stop() }
            }

            Column {
                id: _btContent
                x: _btCard._r + 12; y: 10
                width: _btCard._bw - 24
                spacing: 0

                // Header: adapter toggle + label + status + close
                Item {
                    width: parent.width; height: 40
                    RowLayout {
                        anchors.fill: parent; spacing: 8
                        Rectangle {
                            width: 28; height: 28; radius: Commons.Appearance.radius.base
                            color: NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.mauve : Commons.Appearance.colors.surface0
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            Text {
                                anchors.centerIn: parent
                                text: NetworkServices.Bluetooth.icon()
                                color: NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.base : Commons.Appearance.colors.overlay0
                                font.pixelSize: 13; font.family: Commons.Appearance.font.family
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: NetworkServices.Bluetooth.toggle() }
                        }
                        Text {
                            text: "Bluetooth"
                            color: Commons.Appearance.colors.text
                            font.pixelSize: Commons.Appearance.font.sizeMd; font.family: Commons.Appearance.font.family
                            font.weight: Font.Medium; Layout.fillWidth: true
                        }
                        Text {
                            text: !NetworkServices.Bluetooth.enabled ? "Off"
                                : NetworkServices.Bluetooth.connected ? NetworkServices.Bluetooth.device : "On"
                            color: NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.subtext0 : Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                            elide: Text.ElideRight; Layout.maximumWidth: 80
                        }
                        Text {
                            text: "✕"
                            color: _btCloseMA.containsMouse ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                            font.pixelSize: 11; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                            MouseArea { id: _btCloseMA; anchors.fill: parent; anchors.margins: -4; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: bar._btPopupVisible = false }
                        }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: Commons.Appearance.colors.surface0 }

                // Adapter-off placeholder
                Item {
                    width: parent.width; height: 32
                    visible: !NetworkServices.Bluetooth.enabled
                    Text {
                        anchors.centerIn: parent
                        text: "Bluetooth adapter is off"
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                    }
                }

                // No paired devices
                Item {
                    width: parent.width; height: 32
                    visible: NetworkServices.Bluetooth.enabled && NetworkServices.Bluetooth.devices.length === 0
                    Text {
                        anchors.left: parent.left; anchors.leftMargin: 2; anchors.verticalCenter: parent.verticalCenter
                        text: "No paired devices"
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                    }
                }

                // Device list
                Repeater {
                    model: NetworkServices.Bluetooth.enabled ? NetworkServices.Bluetooth.devices : []
                    delegate: Item {
                        required property var modelData
                        width: parent.width; height: 32
                        RowLayout {
                            anchors.fill: parent; spacing: 8
                            Text {
                                text: modelData.connected ? "󰂱" : "󰂯"
                                color: modelData.connected ? Commons.Appearance.colors.mauve : Commons.Appearance.colors.overlay0
                                font.pixelSize: 14; font.family: Commons.Appearance.font.family
                            }
                            Text {
                                text: modelData.name
                                color: modelData.connected ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                                font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
                                Layout.fillWidth: true; elide: Text.ElideRight
                            }
                            Rectangle {
                                width: _btDevLbl.implicitWidth + 16; height: 22
                                radius: Commons.Appearance.radius.sm
                                color: _btDevMA.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                Text {
                                    id: _btDevLbl; anchors.centerIn: parent
                                    text: modelData.connected ? "Disconnect" : "Connect"
                                    color: modelData.connected ? Commons.Appearance.colors.red : Commons.Appearance.colors.mauve
                                    font.pixelSize: Commons.Appearance.font.sizeSm - 1; font.family: Commons.Appearance.font.family
                                }
                                MouseArea {
                                    id: _btDevMA; anchors.fill: parent; hoverEnabled: true
                                    onClicked: modelData.connected
                                        ? NetworkServices.Bluetooth.disconnectDevice(modelData.address)
                                        : NetworkServices.Bluetooth.connectDevice(modelData.address)
                                }
                            }
                        }
                    }
                }
            }
        }
}

