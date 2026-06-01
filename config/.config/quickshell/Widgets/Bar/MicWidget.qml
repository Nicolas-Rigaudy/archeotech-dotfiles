import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Media" as MediaServices

// Microphone mute toggle.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: micIcon.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    property bool _hovered: false

    Text {
        id: micIcon
        anchors.centerIn: parent
        text: MediaServices.Audio.micMuted ? "󰍭" : "󰍬"
        color: MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
        font.pixelSize: 18; font.family: Commons.Appearance.font.family
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onClicked: MediaServices.Audio.toggleMicMute()
        onEntered: {
            root._hovered = true
            micIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot) root.barRoot.showPopup(root, "MICROPHONE",
                MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active",
                "", "Click to toggle")
        }
        onExited: {
            root._hovered = false
            micIcon.color = MediaServices.Audio.micMuted ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
    }
    Connections {
        target: MediaServices.Audio
        function onMicMutedChanged() {
            if (root._hovered && root.barRoot && root.barRoot._popupVisible)
                root.barRoot._popupPrimary = MediaServices.Audio.micMuted ? "󰍭  Muted" : "󰍬  Active"
        }
    }
}
