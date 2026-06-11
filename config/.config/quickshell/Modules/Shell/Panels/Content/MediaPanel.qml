import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../../Commons" as Commons
import "../../../../Services/Media" as MediaServices

// Standalone media player panel (Sprint 24) — extracted from the old Control
// Center MEDIA section. Lives on the bottom strip next to Dashboard +
// Wallpaper (Caelestia-style). Bound to MprisService; the bar media-marquee
// click opens it. Reports implicitAxis so the strip sizes to content.
Item {
    id: root
    anchors.fill: parent

    property var panelRoot

    readonly property bool _available: MediaServices.MprisService.available

    // axisSize:"auto" — width follows content (wide enough for art + controls).
    readonly property real implicitAxis: 520

    Process {
        id: cmdRunner
        running: false
        property string cmd: ""
        command: ["bash", "-c", cmd]
    }
    function run(cmd) { cmdRunner.cmd = cmd; cmdRunner.running = true }

    function formatTime(secs) {
        var s = Math.floor(secs)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Commons.Appearance.spacing.lg
        spacing: Commons.Appearance.spacing.md

        Text {
            text: "󰝚  Media"
            color: Commons.Appearance.colors.text
            font.pixelSize: Commons.Appearance.font.sizeLg
            font.family: Commons.Appearance.font.family
            font.weight: Font.Medium
            Layout.fillWidth: true
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0; opacity: 0.5 }

        // Nothing playing — launch shortcut
        RowLayout {
            Layout.fillWidth: true
            visible: !root._available
            spacing: 10
            Text {
                text: "󰝚  Nothing playing"
                color: Commons.Appearance.colors.overlay0
                font.pixelSize: Commons.Appearance.font.sizeBase
                font.family: Commons.Appearance.font.family
                Layout.fillWidth: true
            }
            Rectangle {
                width: 100; height: 30
                radius: Commons.Appearance.radius.base
                color: spotifyArea.containsMouse ? Commons.Appearance.colors.surface0 : Commons.Appearance.colors.base
                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                Text {
                    anchors.centerIn: parent
                    text: "󰓇  Spotify"
                    color: Commons.Appearance.colors.subtext1
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                }
                MouseArea {
                    id: spotifyArea; anchors.fill: parent; hoverEnabled: true
                    onClicked: { root.run("spotify-launcher &"); if (root.panelRoot) root.panelRoot.close() }
                }
            }
        }

        // Player card
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root._available
            spacing: 14

            // Album art / app icon
            Rectangle {
                Layout.preferredWidth: 92; Layout.preferredHeight: 92
                Layout.alignment: Qt.AlignVCenter
                radius: Commons.Appearance.radius.base
                color: Commons.Appearance.colors.base

                Image {
                    id: albumArt
                    anchors.fill: parent
                    source: MediaServices.MprisService.artUrl || ""
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready
                    Rectangle {
                        anchors.fill: parent
                        radius: Commons.Appearance.radius.base
                        color: "transparent"
                        border.color: Commons.Appearance.colors.accentBorder
                        border.width: 1
                    }
                }
                Text {
                    anchors.centerIn: parent
                    visible: albumArt.status !== Image.Ready
                    text: MediaServices.MprisService.appIcon || "󰝚"
                    color: Commons.Appearance.colors.accent
                    font.pixelSize: 40
                    font.family: Commons.Appearance.font.family
                }
            }

            // Track info + controls
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 4

                Text {
                    Layout.fillWidth: true
                    text: MediaServices.MprisService.title || "Unknown track"
                    color: Commons.Appearance.colors.text
                    font.pixelSize: Commons.Appearance.font.sizeMd
                    font.family: Commons.Appearance.font.family
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    text: MediaServices.MprisService.artist || MediaServices.MprisService.identity || ""
                    color: Commons.Appearance.colors.subtext0
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                    elide: Text.ElideRight
                }

                // Progress bar (seekable)
                Item {
                    Layout.fillWidth: true
                    height: 28
                    visible: MediaServices.MprisService.length > 0

                    Rectangle {
                        anchors.left: parent.left; anchors.right: parent.right
                        anchors.top: parent.top; anchors.topMargin: 6
                        height: 4; radius: 2
                        color: Commons.Appearance.colors.surface0

                        Rectangle {
                            width: MediaServices.MprisService.length > 0 ? parent.width * Math.min(MediaServices.MprisService.position / MediaServices.MprisService.length, 1) : 0
                            height: parent.height; radius: 2
                            color: Commons.Appearance.colors.accent
                            Behavior on width { NumberAnimation { duration: 950 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -4
                            onClicked: mouse => MediaServices.MprisService.seekTo(MediaServices.MprisService.length * (mouse.x / width))
                        }
                    }

                    Text {
                        anchors.left: parent.left; anchors.bottom: parent.bottom
                        text: formatTime(MediaServices.MprisService.position)
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: 9; font.family: Commons.Appearance.font.family
                    }
                    Text {
                        anchors.right: parent.right; anchors.bottom: parent.bottom
                        text: formatTime(MediaServices.MprisService.length)
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: 9; font.family: Commons.Appearance.font.family
                    }
                }

                // Playback controls
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "󰒮"
                        color: prevArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                        font.pixelSize: 20; font.family: Commons.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea { id: prevArea; anchors.fill: parent; anchors.margins: -6; hoverEnabled: true; onClicked: MediaServices.MprisService.previous() }
                    }

                    Item { width: 24 }

                    Text {
                        text: MediaServices.MprisService.playing ? "󰏤" : "󰐊"
                        color: playArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.text
                        font.pixelSize: 26; font.family: Commons.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea { id: playArea; anchors.fill: parent; anchors.margins: -6; hoverEnabled: true; onClicked: MediaServices.MprisService.togglePlay() }
                    }

                    Item { width: 24 }

                    Text {
                        text: "󰒭"
                        color: nextArea.containsMouse ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1
                        font.pixelSize: 20; font.family: Commons.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        MouseArea { id: nextArea; anchors.fill: parent; anchors.margins: -6; hoverEnabled: true; onClicked: MediaServices.MprisService.next() }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }
    }
}
