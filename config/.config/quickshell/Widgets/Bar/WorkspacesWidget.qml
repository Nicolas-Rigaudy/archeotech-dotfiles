import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Compositor" as CompositorServices

// Tag dot row for the focused screen. Click to switch tag.
Row {
    id: root
    required property var barRoot
    property string widgetId

    spacing: 4
    visible: barRoot && barRoot.horizontal
    Layout.alignment: Qt.AlignVCenter

    Repeater {
        model: CompositorServices.MangoWC.tagsFor(root.barRoot && root.barRoot.screen ? root.barRoot.screen.name : "")
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
                    root.barRoot.screen ? root.barRoot.screen.name : "", modelData.num)
            }
        }
    }
}
