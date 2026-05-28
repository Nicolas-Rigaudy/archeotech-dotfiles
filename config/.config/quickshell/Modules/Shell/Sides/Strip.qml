import QtQuick
import "../../../Commons" as Commons
import "../../../Services/Shell" as ShellServices

// Persistent edge strip — sibling Item inside ShellSurface (Sprint 17 Stage 4).
// Body hover reveals icons; each icon click toggles its panel in ShellState.
// Strip stays expanded while any of its panels is open.
//
// Orientation comes from `side`: top/bottom → horizontal Row; left/right → vertical Column.
// Cross-axis thickness is exposed via implicit size; the long axis is anchored by the parent.
Item {
    id: strip

    required property string side
    required property var screen

    readonly property string _screenName: screen ? screen.name : ""
    readonly property bool   _horizontal: side === "top" || side === "bottom"
    readonly property var    _icons: ShellServices.ShellConfig.stripIcons(side, _screenName)
    readonly property int    collapsedSize: ShellServices.ShellConfig.sideSize(side, _screenName)
    readonly property int    expandedSize:  ShellServices.ShellConfig.sideExpanded(side, _screenName)

    readonly property string _activePanel: ShellServices.ShellState.activePanel(_screenName)
    readonly property bool   _panelOpen:   _activePanel !== "" && _icons.indexOf(_activePanel) !== -1
    readonly property bool   expanded:     _hov || _panelOpen

    property bool _hov: false

    implicitWidth:  _horizontal ? 0 : (expanded ? expandedSize : collapsedSize)
    implicitHeight: _horizontal ? (expanded ? expandedSize : collapsedSize) : 0

    Behavior on implicitWidth  { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }
    Behavior on implicitHeight { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        color: strip._panelOpen ? Commons.Appearance.colors.accentAlpha
                                : Commons.Appearance.colors.glassBgLight
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }

    HoverHandler { onHoveredChanged: strip._hov = hovered }

    function _glyph(id) {
        if (id === "cc")        return "󰒓"
        if (id === "nc")        return "󰂚"
        if (id === "launcher")  return "󱓞"
        if (id === "dashboard") return "󰕮"
        return "?"
    }

    // Single delegate shared by Row + Column so the icon definition lives in one place.
    Component {
        id: _iconComp
        Item {
            id: iconItem
            required property string modelData
            readonly property string iconId: modelData
            readonly property bool _active: ShellServices.ShellState.isOpen(strip._screenName, iconId)

            width: 28
            height: 28

            Text {
                anchors.centerIn: parent
                text: strip._glyph(iconItem.iconId)
                color: iconItem._active ? Commons.Appearance.colors.accent
                                        : Commons.Appearance.colors.subtext1
                font.pixelSize: 18
                font.family: Commons.Appearance.font.family
                opacity: strip.expanded ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }
                Behavior on color   { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
            }

            TapHandler {
                onTapped: ShellServices.ShellState.toggle(strip._screenName, iconItem.iconId)
            }
        }
    }

    Column {
        visible: !strip._horizontal
        anchors.centerIn: parent
        spacing: 8
        Repeater { model: strip._icons; delegate: _iconComp }
    }

    Row {
        visible: strip._horizontal
        anchors.centerIn: parent
        spacing: 8
        Repeater { model: strip._icons; delegate: _iconComp }
    }
}
