pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool ccVisible:        false
    property bool ncVisible:        false
    property bool launcherVisible:  false
    property bool dashboardVisible: false

    readonly property bool anyDrawerActive:
        ccVisible || ncVisible || launcherVisible || dashboardVisible

    onCcVisibleChanged:        if (ccVisible)        { ncVisible = false; launcherVisible = false; dashboardVisible = false }
    onNcVisibleChanged:        if (ncVisible)        { ccVisible = false; launcherVisible = false; dashboardVisible = false }
    onLauncherVisibleChanged:  if (launcherVisible)  { ccVisible = false; ncVisible = false; dashboardVisible = false }
    onDashboardVisibleChanged: if (dashboardVisible) { ccVisible = false; ncVisible = false; launcherVisible = false }

    function hideAll() {
        ccVisible = false
        ncVisible = false
        launcherVisible = false
        dashboardVisible = false
    }
}
