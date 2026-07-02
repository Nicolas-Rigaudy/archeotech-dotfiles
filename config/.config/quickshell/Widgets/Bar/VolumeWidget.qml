import QtQuick
import "../../Commons" as Commons
import "../../Services/Media" as MediaServices

// Volume indicator: scroll-to-adjust + click-to-mute. Icon+value horizontal,
// icon-only vertical (BarPill).
BarPill {
    id: root
    icon: MediaServices.Audio.muted ? "󰖁" : MediaServices.Audio.volume > 66 ? "󰕾" : MediaServices.Audio.volume > 33 ? "󰖀" : "󰕿"
    iconColor: MediaServices.Audio.muted ? Commons.Appearance.colors.overlay0 : Commons.Appearance.colors.subtext1
    text: MediaServices.Audio.volume + "%"

    onClicked: MediaServices.Audio.toggleMute()
    onWheel: d => MediaServices.Audio.setVolume(Math.max(0, Math.min(100, MediaServices.Audio.volume + d * 5)))
    onEntered: if (barRoot && barRoot.horizontal) barRoot.showPopup(root, "VOLUME",
        MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%",
        "", "Scroll to adjust · Click to mute")
    onExited: if (barRoot) barRoot.hidePopup(root)

    Connections {
        target: MediaServices.Audio
        function onVolumeChanged() { root._syncPopup() }
        function onMutedChanged()  { root._syncPopup() }
    }
    function _syncPopup() {
        if (hovered && barRoot && barRoot._popupVisible)
            barRoot._popupPrimary = MediaServices.Audio.muted ? "󰖁  Muted" : "󰕾  " + MediaServices.Audio.volume + "%"
    }
}
