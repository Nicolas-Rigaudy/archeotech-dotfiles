import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "." as Root
import "services" as Services

PanelWindow {
    id: osdWindow

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:osd"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors { bottom: true; left: true; right: true }
    implicitHeight: 80
    color: "transparent"

    // ── Public API — use `shown`, never shadow PanelWindow.visible ─────────────
    property bool   shown:   false
    property string osdType: "volume"

    function show(type) {
        osdType = type
        shown   = true
        hideTimer.restart()
    }

    // ── Derived values ─────────────────────────────────────────────────────────
    property int  osdValue: osdType === "brightness" ? Services.Brightness.percent : Services.Audio.volume
    property bool osdMuted: osdType === "volume" && Services.Audio.muted

    property string osdIcon: {
        if (osdType === "brightness")
            return osdValue >= 75 ? "󰃠" : osdValue >= 40 ? "󰃟" : "󰃞"
        if (osdMuted)      return "󰖁"
        if (osdValue > 66) return "󰕾"
        if (osdValue > 33) return "󰖀"
        return "󰕿"
    }

    property color osdColor: osdType === "brightness"
        ? Root.Appearance.colors.yellow
        : (osdMuted ? Root.Appearance.colors.overlay0 : Root.Appearance.colors.accent)

    // ── Auto-hide ──────────────────────────────────────────────────────────────
    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: osdWindow.shown = false
    }

    // ── Pill (opacity-animated, window itself stays mapped) ────────────────────
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: 220
        height: 46

        Rectangle {
            id: pill
            anchors.fill: parent
            radius: Root.Appearance.radius.xl
            color: Root.Appearance.colors.glassBg
            opacity: osdWindow.shown ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16; anchors.rightMargin: 16
                spacing: 12

                Text {
                    text: osdWindow.osdIcon
                    color: osdWindow.osdColor
                    font.pixelSize: 20
                    font.family: Root.Appearance.font.family
                    Layout.alignment: Qt.AlignVCenter
                    Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 4; radius: 2
                    color: Root.Appearance.colors.surface0
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        width: parent.width * (osdWindow.osdMuted ? 0 : Math.min(osdWindow.osdValue / 100, 1))
                        height: parent.height; radius: 2
                        color: osdWindow.osdColor
                        Behavior on width { NumberAnimation { duration: Root.Appearance.anim.fast; easing.type: Easing.OutCubic } }
                        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
                    }
                }

                Text {
                    text: osdWindow.osdMuted ? "Muted" : osdWindow.osdValue + "%"
                    color: Root.Appearance.colors.subtext0
                    font.pixelSize: Root.Appearance.font.sizeSm
                    font.family: Root.Appearance.font.family
                    font.weight: Font.Medium
                    Layout.alignment: Qt.AlignVCenter
                    Layout.minimumWidth: 38
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
