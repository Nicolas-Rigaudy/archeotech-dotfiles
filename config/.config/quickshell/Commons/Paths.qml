pragma Singleton
import QtQuick

QtObject {
    readonly property string home:         StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property string cache:        home + "/.cache"
    readonly property string config:       home + "/.config"
    readonly property string localBin:     home + "/.local/bin"
    readonly property string wallpaperSet: localBin + "/wallpaper-set.sh"
    readonly property string wallpaperPicker: localBin + "/wallpaper-picker.sh"
    readonly property string swaylockLaunch: localBin + "/swaylock-launch.sh"
    readonly property string wlogoutLaunch:  localBin + "/wlogout-launch.sh"
}
