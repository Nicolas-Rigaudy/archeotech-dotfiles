import QtQuick
import "../../" as Root

Text {
    property string label: ""
    text: label

    color: Root.Appearance.colors.overlay0
    font.pixelSize: Root.Appearance.font.sizeSm - 1
    font.family: Root.Appearance.font.family
    font.letterSpacing: 1.5
    font.weight: Font.Bold
    topPadding: 4
    bottomPadding: 2
}
