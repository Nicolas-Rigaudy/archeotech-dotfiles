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

    // Live widths of the non-title left-zone widgets, reported by their loaders
    // (see the left Repeater delegate). Used to size the title so the left
    // cluster can't slide under the centered clock.
    property real _wsWidth:    0
    property real _mediaWidth: 0

    // Max width the title may take before the left cluster (workspaces + title
    // + media) would reach the centered clock. The title caps its own implicit
    // width to this and elides — no Layout clamps (those stretched the zone).
    readonly property real _titleMaxWidth: Math.max(60,
        pill.width / 2 - _centerRow.width / 2
        - Commons.Appearance.bar.innerPadding - _wsWidth - _mediaWidth - 16)

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

    // Pinned hover card (Sprint ② increment 2): a click "pins" the status card
    // open with inline controls (e.g. a volume slider) so it can be interacted
    // with — unlike a hover peek, which auto-hides on mouse-leave. `_popupId`
    // selects which inline control the card renders. Opening a WiFi/BT/calendar
    // popup clears the pin (handlers below) so only one popup is ever live.
    property bool   _popupPinned: false
    property string _popupId:     ""
    on_wifiPopupVisibleChanged: if (_wifiPopupVisible) _popupPinned = false
    on_btPopupVisibleChanged:   if (_btPopupVisible)   _popupPinned = false
    on_calendarVisibleChanged:  if (_calendarVisible)  _popupPinned = false

    // ── Bar-popup input region (consumed by ShellSurface's input mask) ──────────
    // The popup cards float BELOW the bar, outside the SideLoader rect that the
    // surface mask covers — without this, clicks on them pass straight through to
    // the windows behind. We expose the union bounding box (bar-local coords) of
    // every visible popup; ShellSurface mirrors it into a mask region. Ids are
    // resolved at component scope, so referencing the popups declared further
    // down is fine.
    readonly property bool _anyPopupOpen:
        _hoverCardPopup.visible || _calendarPopup.visible
        || _wifiPopup.visible   || _btPopup.visible
    readonly property rect _popupBounds: {
        var ps = [_hoverCardPopup, _calendarPopup, _wifiPopup, _btPopup]
        var l = 1e9, t = 1e9, r = -1e9, b = -1e9, any = false
        for (var i = 0; i < ps.length; i++) {
            if (!ps[i].visible) continue
            any = true
            l = Math.min(l, ps[i].x); t = Math.min(t, ps[i].y)
            r = Math.max(r, ps[i].x + ps[i].width); b = Math.max(b, ps[i].y + ps[i].height)
        }
        return any ? Qt.rect(l, t, r - l, b - t) : Qt.rect(0, 0, 0, 0)
    }

    // ── barRoot API surface ─────────────────────────────────────────────────────
    function showPopup(item, label, primary, secondary, hint) {
        // A pinned control popup (WiFi/BT) owns the screen — never raise a hover
        // status card while one is open (it would render behind it). This makes
        // the hover card and the click popups mutually exclusive: one slot only.
        if (_wifiPopupVisible || _btPopupVisible) return
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

    // ── Stable ListModels for each zone ────────────────────────────────────────
    // HyprPanel's preserve-delegates pattern. When shell-config.json changes,
    // _syncZone() does an in-place add/remove/move diff on the ListModel so
    // unchanged widgets (e.g. MPRIS marquee mid-scroll) keep their state.
    // A plain `model: <jsArray>` Repeater would destroy + recreate everything.
    ListModel { id: _leftModel }
    ListModel { id: _centerModel }
    ListModel { id: _rightModel }

    function _syncZone(model, newIds) {
        // Remove ids no longer present.
        var newSet = {}
        for (var j = 0; j < newIds.length; j++) newSet[newIds[j]] = true
        for (var k = model.count - 1; k >= 0; k--) {
            if (!newSet[model.get(k).widgetId]) model.remove(k)
        }
        // Insert or move so model order matches newIds.
        for (var m = 0; m < newIds.length; m++) {
            var id = newIds[m]
            var currentIdx = -1
            for (var n = m; n < model.count; n++) {
                if (model.get(n).widgetId === id) { currentIdx = n; break }
            }
            if (currentIdx === -1)     model.insert(m, { widgetId: id })
            else if (currentIdx !== m) model.move(currentIdx, m, 1)
        }
    }

    function _syncAllZones() {
        _syncZone(_leftModel,   ShellServices.ShellConfig.zoneWidgets(bar.side, "left",   bar._screenName))
        _syncZone(_centerModel, ShellServices.ShellConfig.zoneWidgets(bar.side, "center", bar._screenName))
        _syncZone(_rightModel,  ShellServices.ShellConfig.zoneWidgets(bar.side, "right",  bar._screenName))
    }

    Component.onCompleted: _syncAllZones()
    Connections {
        target: ShellServices.ShellConfig
        function onDataChanged() { bar._syncAllZones() }
    }

    // ── Pill — anchored to the bar's outer edge ────────────────────────────────
    Rectangle {
        id: pill
        z: 1
        // Transparent — the unified FrameBackground (ShellSurface) draws the
        // resting glass for every side + the shared rounded/capped corners (S22).
        // This pill only positions/hosts the bar widgets.
        color: "transparent"

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
                    model: _leftModel
                    delegate: BarWidgetLoader {
                        // Qt 6.11.1 stopped auto-binding ListModel roles to
                        // a delegate's *inherited* required properties; we
                        // pass widgetId explicitly via `model.widgetId`.
                        required property var model
                        required property int index
                        widgetId: model ? model.widgetId : ""
                        barRoot:  bar
                        isFirst:  index === 0
                        isLast:   index === _leftZone.count - 1
                        // Report the non-title widths up so the title can size
                        // itself to never reach the clock (see bar._titleMaxWidth).
                        onWidthChanged: {
                            if (widgetId === "workspaces") bar._wsWidth    = width
                            else if (widgetId === "media")  bar._mediaWidth = width
                        }
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
                    model: _rightModel
                    delegate: BarWidgetLoader {
                        required property var model
                        required property int index
                        widgetId: model ? model.widgetId : ""
                        barRoot:  bar
                        isFirst:  index === 0
                        isLast:   index === _rightZone.count - 1
                    }
                }
            }
        }

        // CENTER zone — overlay, absolutely centered. z above the RowLayout
        // so the clock isn't pushed when the left/right zone widths change.
        Row {
            id: _centerRow
            visible: bar.horizontal
            anchors.centerIn: parent
            z: 2
            spacing: 0
            Repeater {
                id: _centerZone
                model: _centerModel
                delegate: BarWidgetLoader {
                    required property var model
                    required property int index
                    widgetId: model ? model.widgetId : ""
                    barRoot:  bar
                    isFirst:  index === 0
                    isLast:   index === _centerZone.count - 1
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
                    color: ShellServices.ShellState.isOpenAnywhere("settings") ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                    font.pixelSize: 16; font.family: Commons.Appearance.font.family
                }
                TapHandler { onTapped: ShellServices.ShellState.toggleGlobal("settings") }
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
    BarWidgets.HoverCard     { id: _hoverCardPopup; barRoot: bar }
    BarWidgets.CalendarPopup { id: _calendarPopup;  barRoot: bar }
    BarWidgets.WifiPopup     { id: _wifiPopup;       barRoot: bar }
    BarWidgets.BtPopup       { id: _btPopup;         barRoot: bar }

    Process { id: powerCmd; command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }
}
