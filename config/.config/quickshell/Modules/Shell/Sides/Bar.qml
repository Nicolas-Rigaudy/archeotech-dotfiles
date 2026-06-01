import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../Commons" as Commons
import "../../../Services/Media" as MediaServices
import "../../../Services/Hardware" as HardwareServices
import "../../../Services/Networking" as NetworkServices
import "../../../Services/System" as SystemServices
import "../../../Services/Persistence" as Persistence
import "../../../Services/Shell" as ShellServices
import "../../../Widgets/Bar" as BarWidgets

// Bar — a side container that hosts widgets driven by shell-config.json.
// Three zones on horizontal bars (left / center / right) each mount a
// Repeater of BarWidgetLoader, resolving widget ids via WidgetRegistry's
// filename convention (Widgets/Bar/<PascalId>Widget.qml).
//
// Bar owns the popup state (hover info, calendar, WiFi, BT) — widgets
// flip these properties through the barRoot API. Popup components live
// in Widgets/Bar/*Popup.qml and read state directly from barRoot.
//
// Vertical side bars still inline a simplified icon Column for now.
// Widget-aware vertical layouts arrive in a later sprint.
Item {
    id: bar

    required property string side
    required property var screen

    readonly property bool   horizontal: side === "top" || side === "bottom"
    readonly property bool   _isTop:     side === "top"
    readonly property bool   _isBottom:  side === "bottom"
    readonly property bool   _isLeft:    side === "left"
    readonly property bool   _isRight:   side === "right"
    readonly property int    thickness:  Commons.Appearance.bar.height
    readonly property string _screenName: screen ? screen.name : ""

    implicitWidth:  horizontal ? 0 : thickness
    implicitHeight: horizontal ? thickness : 0

    // ── Popup state (read/written by widgets via barRoot) ──────────────────────
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

    // ── barRoot API surface ─────────────────────────────────────────────────────
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
    // caller === undefined means a popup card itself is hiding (always allowed).
    // caller !== _popupOwner means a stale onExited from the previous icon — ignore.
    function hidePopup(caller) {
        if (caller === undefined || caller === _popupOwner) _hideTimer.restart()
    }
    function hideCalendar(caller) { _calHideTimer.restart() }
    function keepPopupsAlive() {
        _hideTimer.stop()
        _calHideTimer.stop()
        _popupVisible = false
    }

    Timer { id: _hideTimer;    interval: 250; onTriggered: bar._popupVisible    = false }
    Timer { id: _calHideTimer; interval: 250; onTriggered: bar._calendarVisible = false }

    // ── Pill — anchored to the bar's outer edge ────────────────────────────────
    Rectangle {
        id: pill
        z: 1
        color: Commons.Appearance.colors.glassBgLight

        anchors.top:    bar._isBottom ? undefined : parent.top
        anchors.bottom: bar._isTop    ? undefined : parent.bottom
        anchors.left:   bar._isRight  ? undefined : parent.left
        anchors.right:  bar._isLeft   ? undefined : parent.right

        anchors.topMargin:    Commons.Appearance.bar.marginTop
        anchors.bottomMargin: Commons.Appearance.bar.marginTop
        anchors.leftMargin:   Commons.Appearance.bar.marginSide
        anchors.rightMargin:  Commons.Appearance.bar.marginSide

        width:  bar.thickness
        height: bar.thickness

        // ── Horizontal layout — LEFT | filler | RIGHT in a RowLayout,
        //    CENTER absolutely centered (overlay so widget widths in
        //    left/right zones don't push the clock off-center).
        RowLayout {
            visible: bar.horizontal
            anchors.fill: parent
            anchors.leftMargin:  Commons.Appearance.bar.innerPadding
            anchors.rightMargin: Commons.Appearance.bar.innerPadding
            spacing: 0

            // LEFT zone
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 0
                Repeater {
                    id: _leftZone
                    model: ShellServices.ShellConfig.zoneWidgets(bar.side, "left", bar._screenName)
                    delegate: BarWidgetLoader {
                        required property string modelData
                        required property int index
                        widgetId: modelData
                        barRoot: bar
                        isFirst: index === 0
                        isLast:  index === _leftZone.count - 1
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // RIGHT zone
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 0
                Repeater {
                    id: _rightZone
                    model: ShellServices.ShellConfig.zoneWidgets(bar.side, "right", bar._screenName)
                    delegate: BarWidgetLoader {
                        required property string modelData
                        required property int index
                        widgetId: modelData
                        barRoot: bar
                        isFirst: index === 0
                        isLast:  index === _rightZone.count - 1
                    }
                }
            }
        }

        // CENTER zone — overlay, absolutely centered. z above the RowLayout
        // so the clock isn't pushed when the left/right zone widths change.
        Row {
            visible: bar.horizontal
            anchors.centerIn: parent
            z: 2
            spacing: 0
            Repeater {
                id: _centerZone
                model: ShellServices.ShellConfig.zoneWidgets(bar.side, "center", bar._screenName)
                delegate: BarWidgetLoader {
                    required property string modelData
                    required property int index
                    widgetId: modelData
                    barRoot: bar
                    isFirst: index === 0
                    isLast:  index === _centerZone.count - 1
                }
            }
        }

        // ── Vertical layout (left/right side bars) — simplified icons, no popups.
        // Widget-aware vertical layouts arrive in a later sprint.
        Column {
            visible: !bar.horizontal
            anchors.centerIn: parent
            spacing: 12

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
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 24; height: 24
                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    color: ShellServices.ShellState.isOpenAnywhere("nc")       ? Commons.Appearance.colors.accent
                         : SystemServices.Notifications.unreadCount > 0 ? Commons.Appearance.colors.red
                         :                                                 Commons.Appearance.colors.subtext1
                    font.pixelSize: 16; font.family: Commons.Appearance.font.family
                }
                TapHandler {
                    onTapped: {
                        if (!ShellServices.ShellState.isOpenAnywhere("nc"))
                            SystemServices.Notifications.unreadCount = 0
                        ShellServices.ShellState.toggleGlobal("nc")
                    }
                }
            }
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 24; height: 24
                Text {
                    anchors.centerIn: parent
                    text: "󰒓"
                    color: ShellServices.ShellState.isOpenAnywhere("cc") ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                    font.pixelSize: 16; font.family: Commons.Appearance.font.family
                }
                TapHandler { onTapped: ShellServices.ShellState.toggleGlobal("cc") }
            }
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
    }

    // ── Popup overlays — single instance, persistent ───────────────────────────
    BarWidgets.HoverCard     { barRoot: bar }
    BarWidgets.CalendarPopup { barRoot: bar }
    BarWidgets.WifiPopup     { barRoot: bar }
    BarWidgets.BtPopup       { barRoot: bar }

    Process { id: powerCmd; command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }
}
