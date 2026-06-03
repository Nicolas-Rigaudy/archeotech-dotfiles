import QtQuick
import "../../Commons" as Commons

// Example bar-zone module (Sprint 21 Chunk 2).
//
// A module's entry is a plain widget that follows the same contract as a
// built-in bar widget: it receives `barRoot` + `widgetId` injected via
// Loader.setSource, and may use barRoot's popup API (see docs/WIDGET_API.md).
//
// Modules bundled under ~/.config/quickshell/modules/ can import the shell's
// Commons (relative path below). Fully external modules in ~/.local/share
// should be self-styled — see docs/MODULE_API.md.
Item {
    id: root
    required property var    barRoot
    required property string widgetId

    implicitWidth:  label.implicitWidth + 14
    implicitHeight: 22

    Rectangle {
        anchors.fill: parent
        radius: Commons.Appearance.radius.sm
        color: ma.containsMouse ? Commons.Appearance.colors.surface0Alpha : "transparent"
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

        Text {
            id: label
            anchors.centerIn: parent
            text: "󰜗 hello"
            color: Commons.Appearance.colors.text
            font.family: Commons.Appearance.font.family
            font.pixelSize: Commons.Appearance.font.sizeBase
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.barRoot.showPopup(root, "Hello", "An example bar-zone module", "Sprint 21 · Chunk 2", "")
            onExited:  root.barRoot.hidePopup(root)
        }
    }
}
