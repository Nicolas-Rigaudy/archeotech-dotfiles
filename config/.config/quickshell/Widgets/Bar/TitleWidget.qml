import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Compositor" as CompositorServices

// Focused window title with app icon prefix. Hides when nothing focused.
Text {
    id: root
    required property var barRoot
    property string widgetId

    property string raw: CompositorServices.MangoWC.titleFor(barRoot && barRoot.screen ? barRoot.screen.name : "")

    text: {
        if (raw.includes("Visual Studio Code")) return "󰨞  " + raw.replace(/ - Visual Studio Code$/, "").replace(/^.*\//, "").trim()
        if (raw.includes("Zen Browser"))        return "󰈹  " + raw.replace(/ — Zen Browser$/, "").replace(/^\(\d+\) /, "")
        if (raw.includes("kitty"))              return "  " + raw.replace(/ - kitty$/, "")
        if (raw.includes("fish"))               return "  " + raw.replace(/ - fish$/, "")
        return raw
    }
    visible: raw.length > 0 && barRoot && barRoot.horizontal
    color: Commons.Appearance.colors.subtext0
    font.pixelSize: Commons.Appearance.font.sizeSm
    font.family: Commons.Appearance.font.family
    elide: Text.ElideRight

    Layout.maximumWidth: 200
    Layout.leftMargin: 14
    Layout.alignment: Qt.AlignVCenter
}
