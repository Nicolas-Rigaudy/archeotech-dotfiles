import QtQuick
import "../../Commons" as Commons

// Example panel-content module (Sprint 21 Chunk 2).
//
// When this module is assigned to a strip, the strip auto-generates an opener
// icon (the module's `icon` glyph); clicking it toggles a panel whose content
// is this entry. `panelRoot` is injected (call panelRoot.close() to dismiss).
// Panel size comes from module.json `panel: { size, axisSize }`.
Item {
    id: root
    property var panelRoot

    Column {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Text {
            text: "󰎞  Quick Notes"
            color: Commons.Appearance.colors.accent
            font.family: Commons.Appearance.font.family
            font.pixelSize: Commons.Appearance.font.sizeLg
            font.bold: true
        }

        Rectangle {
            width: parent.width; height: 1
            color: Commons.Appearance.colors.surface0
        }

        Text {
            width: parent.width
            text: "This panel is a community module — a folder with a module.json + this QML, dropped into ~/.config/quickshell/modules/. It was discovered by ModuleRegistry, assigned to a strip in edit mode, and mounted here by the Strip card."
            color: Commons.Appearance.colors.subtext1
            font.family: Commons.Appearance.font.family
            font.pixelSize: Commons.Appearance.font.sizeBase
            wrapMode: Text.WordWrap
            lineHeight: 1.2
        }
    }
}
