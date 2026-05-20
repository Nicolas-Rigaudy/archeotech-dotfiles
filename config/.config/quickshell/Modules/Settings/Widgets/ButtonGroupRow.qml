import QtQuick
import QtQuick.Layouts
import "../../../Commons" as Commons

Item {
    id: root
    property string label: ""
    property string description: ""
    property var options: []    // list of { value: string, label: string }
    property string currentValue: ""
    signal selected(string value)

    implicitHeight: description ? 56 : 40
    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        spacing: Commons.Appearance.spacing.xl

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.label
                color: Commons.Appearance.colors.text
                font.pixelSize: Commons.Appearance.font.sizeBase
                font.family: Commons.Appearance.font.family
            }

            Text {
                visible: root.description !== ""
                text: root.description
                color: Commons.Appearance.colors.overlay0
                font.pixelSize: Commons.Appearance.font.sizeSm
                font.family: Commons.Appearance.font.family
            }
        }

        Row {
            spacing: 4

            Repeater {
                model: root.options
                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    width: 72; height: 28
                    color: modelData.value === root.currentValue
                        ? Commons.Appearance.colors.accentAlpha
                        : (btnArea.containsMouse ? Commons.Appearance.colors.surface0 : Commons.Appearance.colors.base)
                    border.color: modelData.value === root.currentValue
                        ? Commons.Appearance.colors.accent
                        : Commons.Appearance.colors.surface1
                    border.width: 1
                    radius: Commons.Appearance.radius.base

                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: modelData.value === root.currentValue
                            ? Commons.Appearance.colors.accent
                            : Commons.Appearance.colors.subtext1
                        font.pixelSize: Commons.Appearance.font.sizeSm
                        font.family: Commons.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    }

                    MouseArea {
                        id: btnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.selected(modelData.value)
                    }
                }
            }
        }
    }
}
