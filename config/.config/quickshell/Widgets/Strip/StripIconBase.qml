import QtQuick
import "../../Commons" as Commons
import "../../Services/Shell" as ShellServices

// Common visuals + interaction for every strip icon. Per-icon wrappers
// (CcIcon, NcIcon, ...) just set `glyph` and optionally `panelId` if it
// differs from `widgetId`. Drop-in extra content (e.g. NcIcon's unread
// badge) goes inside the default `data` slot.
//
// Position + sizing comes from the parent Item (Strip.qml's Repeater
// delegate computes the per-icon coordinates).
Item {
    id: root
    required property var stripRoot
    property string widgetId
    property string glyph: "?"
    property string panelId: widgetId   // override if different from widgetId

    readonly property string _screenName: stripRoot && stripRoot.screen ? stripRoot.screen.name : ""
    readonly property bool   _active:     ShellServices.ShellState.isOpen(_screenName, panelId)
    property bool _hovered: false

    anchors.fill: parent

    Rectangle {
        anchors.centerIn: parent
        width:  36 + 8
        height: 36 + 8
        radius: Commons.Appearance.radius.md
        color: root._active  ? Commons.Appearance.colors.accentAlpha
             : root._hovered ? Commons.Appearance.colors.surface0Alpha
             :                 "transparent"
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }

    Text {
        id: _glyphText
        anchors.centerIn: parent
        text: root.glyph
        color: root._active || root._hovered
            ? Commons.Appearance.colors.accent
            : Commons.Appearance.colors.subtext1
        font.pixelSize: 22
        font.family: Commons.Appearance.font.family
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {
            root._hovered = true
            if (root.stripRoot) root.stripRoot._iconHoverEnter()
        }
        onExited: {
            root._hovered = false
            if (root.stripRoot) root.stripRoot._iconHoverExit()
        }
        onClicked: ShellServices.ShellState.toggle(root._screenName, root.panelId)
    }
}
