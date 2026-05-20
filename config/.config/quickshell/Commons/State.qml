pragma Singleton
import QtQuick

QtObject {
    property bool   controlCenterVisible:      false
    property bool   notificationCenterVisible: false
    property bool   launcherVisible:           false
    property bool   settingsVisible:           false
    property string controlCenterOpenSection:  ""
    property string settingsOpenPane:          ""
}
