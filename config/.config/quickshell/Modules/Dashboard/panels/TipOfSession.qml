import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../Commons" as Commons

Rectangle {
    id: root
    implicitHeight: 88
    color: Commons.Appearance.colors.mantle
    border.color: Commons.Appearance.colors.surface0
    border.width: 1
    radius: Commons.Appearance.radius.md

    property string tip:    ""
    property var    _lines: []

    FileView {
        path: Commons.Paths.config + "/quickshell/assets/tips.txt"
        preload: true
        printErrors: false
        onTextChanged: {
            root._lines = text().split("\n").filter(l => l.trim().length > 0)
            root._pickTip()
        }
    }

    function _pickTip() {
        if (_lines.length > 0)
            tip = _lines[Math.floor(Math.random() * _lines.length)]
    }

    Connections {
        target: Commons.State
        function onDashboardVisibleChanged() {
            if (Commons.State.dashboardVisible) root._pickTip()
        }
    }

    ColumnLayout {
        anchors { fill: parent; margins: 12 }
        spacing: 6

        Text {
            text: "TIP OF THE SESSION"
            color: Commons.Appearance.colors.accent
            font.family: Commons.Appearance.font.family
            font.pixelSize: Commons.Appearance.font.sizeSm
            font.letterSpacing: 1.5
            opacity: 0.85
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

        Text {
            Layout.fillWidth: true
            text: root.tip || "loading…"
            color: Commons.Appearance.colors.subtext1
            font.family: Commons.Appearance.font.family
            font.pixelSize: Commons.Appearance.font.sizeSm
            wrapMode: Text.WordWrap
            font.italic: root.tip === ""
            maximumLineCount: 2
            elide: Text.ElideRight
        }
    }
}
