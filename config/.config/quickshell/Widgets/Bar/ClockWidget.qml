import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons

// Time + date display. Hover anywhere over the clock area opens the
// calendar popup (state lives in barRoot — see CalendarPopup.qml).
Item {
    id: root
    required property var barRoot
    property string widgetId
    // Sprint 26 — per-instance config (schema in WidgetRegistry._builtinSchemas):
    //   format: "24h" | "12h"    showSeconds: bool
    // Injected by BarWidgetLoader; two clocks can differ.
    property var config: ({})

    // Qt time-format string from the instance config.
    function _timeFmt() {
        var h = (config && config.format === "12h") ? "h:mm" : "HH:mm"
        if (config && config.showSeconds === true) h += ":ss"
        return (config && config.format === "12h") ? h + " AP" : h
    }

    visible: barRoot && barRoot.horizontal
    Layout.alignment: Qt.AlignVCenter

    implicitWidth:  centerClock.implicitWidth
    implicitHeight: Commons.Appearance.bar.height

    Text {
        id: centerClock
        anchors.centerIn: parent
        textFormat: Text.RichText
        text: clockText()
        font.pixelSize: Commons.Appearance.font.sizeMd
        font.family: Commons.Appearance.font.family

        function clockText() {
            return "<span style='color:" + Commons.Appearance.colors.text + ";font-weight:600'>"
                + Qt.formatDateTime(new Date(), root._timeFmt())
                + "</span>"
                + "<span style='color:" + Commons.Appearance.colors.surface1 + "'> &nbsp;·&nbsp; </span>"
                + "<span style='color:" + Commons.Appearance.colors.subtext0 + "'>"
                + Qt.formatDateTime(new Date(), "ddd d MMM")
                + "</span>"
        }
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: centerClock.text = centerClock.clockText()
        }
    }

    MouseArea {
        anchors.centerIn: parent
        width: centerClock.implicitWidth + 24
        height: parent.height
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        z: 2
        onEntered: {
            if (!root.barRoot) return
            root.barRoot._calendarYear  = new Date().getFullYear()
            root.barRoot._calendarMonth = new Date().getMonth() + 1
            root.barRoot._popupVisible      = false
            root.barRoot._wifiPopupVisible  = false
            root.barRoot._btPopupVisible    = false
            root.barRoot._calendarVisible   = true
        }
        onExited: if (root.barRoot) root.barRoot.hideCalendar(root)
    }
}
