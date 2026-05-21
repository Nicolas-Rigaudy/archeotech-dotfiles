pragma Singleton
import QtQuick
import QtCore

QtObject {
    readonly property string home:         StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property string cache:        home + "/.cache"
    readonly property string config:       home + "/.config"
    readonly property string localBin:     home + "/.local/bin"
    readonly property string wallpaperSet: localBin + "/wallpaper-set.sh"
    readonly property string wallpaperPicker: localBin + "/wallpaper-picker.sh"
    readonly property string swaylockLaunch: localBin + "/swaylock-launch.sh"
    readonly property string wlogoutLaunch:  localBin + "/wlogout-launch.sh"
    readonly property string listDesktopApps: home + "/Projects/archeotech-dotfiles/scripts/list-desktop-apps.sh"
    readonly property string wifiScan:        home + "/Projects/archeotech-dotfiles/scripts/wifi-scan.sh"
    readonly property string themeSwitch:        home + "/Projects/archeotech-dotfiles/scripts/theme-switch.sh"
    readonly property string dashboardStats:     home + "/Projects/archeotech-dotfiles/scripts/dashboard-stats.sh"
    readonly property string dashboardProjects:  home + "/Projects/archeotech-dotfiles/scripts/dashboard-projects.sh"
    readonly property string dashboardNotes:     home + "/Projects/archeotech-dotfiles/scripts/dashboard-notes.sh"
}
