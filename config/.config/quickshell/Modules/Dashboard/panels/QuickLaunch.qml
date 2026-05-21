import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../Commons" as Commons

Rectangle {
    id: root
    implicitHeight: col.implicitHeight + 24
    color: Commons.Appearance.colors.mantle
    border.color: Commons.Appearance.colors.surface0
    border.width: 1
    radius: Commons.Appearance.radius.md

    Process {
        id: launchProc
        running: false
        command: ["bash", "-c", ""]
        onExited: command = ["bash", "-c", ""]
    }

    function launch(cmd) {
        launchProc.command = ["bash", "-c", "setsid " + cmd + " >/dev/null 2>&1 &"]
        launchProc.running = true
        Commons.State.dashboardVisible = false
    }

    // icon: real .desktop icon name, or "" to skip
    readonly property var apps: [
        { label: "Terminal",    icon: "kitty",                cmd: "kitty" },
        { label: "Browser",     icon: "zen-browser",          cmd: "zen-browser" },
        { label: "Editor",      icon: "visual-studio-code",   cmd: "code" },
        { label: "Notes",       icon: "obsidian",             cmd: "obsidian" },
        { label: "Lazygit",     icon: "git",                  cmd: "kitty --title lazygit -e lazygit" },
        { label: "Files",       icon: "folder",               cmd: "kitty --title yazi -e yazi" },
        { label: "Monitor",     icon: "btop",                 cmd: "kitty --title btop -e btop" },
        { label: "Cheatsheets", icon: "help-browser",         cmd: "kitty --title navi -e navi" }
    ]

    ColumnLayout {
        id: col
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
        spacing: 8

        Text {
            text: "QUICK LAUNCH"
            color: Commons.Appearance.colors.accent
            font.family: Commons.Appearance.font.family
            font.pixelSize: Commons.Appearance.font.sizeSm
            font.letterSpacing: 1.5
            opacity: 0.85
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

        Flow {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: root.apps
                delegate: Rectangle {
                    required property var modelData
                    width: 110; height: 34
                    radius: Commons.Appearance.radius.base
                    color: hov.containsMouse ? Commons.Appearance.colors.accentAlpha : Commons.Appearance.colors.surface0Alpha
                    border.color: hov.containsMouse ? Commons.Appearance.colors.accentBorder : "transparent"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                    Row {
                        anchors.centerIn: parent
                        spacing: 6

                        Image {
                            source: "image://icon/" + modelData.icon
                            width: 16; height: 16
                            anchors.verticalCenter: parent.verticalCenter
                            smooth: true
                            // hide broken icon placeholder — keep label only
                            visible: status === Image.Ready
                        }

                        Text {
                            text: modelData.label
                            color: Commons.Appearance.colors.text
                            font.family: Commons.Appearance.font.family
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HoverHandler { id: hov }
                    TapHandler { onTapped: root.launch(modelData.cmd) }
                }
            }
        }
    }
}
