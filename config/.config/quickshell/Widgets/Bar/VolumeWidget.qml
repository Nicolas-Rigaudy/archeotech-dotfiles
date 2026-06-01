import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Media" as MediaServices

// Volume indicator with scroll-to-adjust + click-to-mute.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: volRow.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    property bool _hovered: false

    Row {
        id: volRow
        spacing: 4
        anchors.centerIn: parent
        Text {
            id: volIcon
            text: MediaServices.Audio.muted ? "󰖁" : MediaServices.Audio.volume > 66 ? "󰕾" : MediaServices.Audio.volume > 33 ? "󰖀" : "󰕿"
            color: MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
            font.pixelSize: 18; font.family: Commons.Appearance.font.family
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
        }
        Text {
            text: MediaServices.Audio.volume + "%"
            color: Commons.Appearance.colors.overlay1
            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onClicked: MediaServices.Audio.toggleMute()
        onEntered: {
            root._hovered = true
            volIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot) root.barRoot.showPopup(root, "VOLUME",
                MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%",
                "", "Scroll to adjust · Click to mute")
        }
        onExited: {
            root._hovered = false
            volIcon.color = MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
        onWheel: wheel => {
            var delta = wheel.angleDelta.y > 0 ? 5 : -5
            MediaServices.Audio.setVolume(Math.max(0, Math.min(100, MediaServices.Audio.volume + delta)))
        }
    }
    Connections {
        target: MediaServices.Audio
        function onVolumeChanged() {
            if (root._hovered && root.barRoot && root.barRoot._popupVisible)
                root.barRoot._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
        }
        function onMutedChanged() {
            if (root._hovered && root.barRoot && root.barRoot._popupVisible)
                root.barRoot._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
        }
    }
}
