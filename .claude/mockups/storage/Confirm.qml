import QtQuick
import "K.js" as K
import "D.js" as D
// Confirm step (shared by both options): exact commands, admin badge, one prompt
Panel { width: 1000; height: 580
  Column { anchors.fill: parent; spacing: 14
    Item { width: parent.width; height: 36
      Txt { text: "Free 45.2 G?"; font.pixelSize: 22; font.weight: Font.DemiBold; anchors.verticalCenter: parent.verticalCenter }
      Txt { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: "21.3 G free  →  66.5 G free"; m: true; color: K.sub1 } }
    Card { width: parent.width; height: 6*48 + 60; title: "These commands will run"
      side: Txt { text: "  one password prompt for 2"; m: true; font.pixelSize: 12; color: K.ov2 }
      Column { width: parent.width
        Repeater { model: [
            ["uv cache", "uv cache clean", "27.7 G", false],
            ["Pacman package cache", "paccache -rk2", "7.8 G", true],
            ["AUR build cache", "rm -rf ~/.cache/paru/clone", "5.0 G", false],
            ["App caches", "rm -rf ~/.cache/{zen,spotify,aws,pypoetry,wallpaper,…}", "3.6 G", false],
            ["Systemd journal", "journalctl --vacuum-size=500M", "648 M", true],
            ["Trash", "gio trash --empty", "531 M", false] ]
          Item { width: parent.width; height: 48
            Div { width: parent.width; visible: index>0 }
            Txt { y: 14; text: modelData[0]; font.pixelSize: 14; width: 210; elide: Text.ElideRight }
            Txt { x: 220; y: 15; m: true; font.pixelSize: 13; color: modelData[3] ? K.text : K.sub0; text: (modelData[3] ? "# " : "$ ") + modelData[1] }
            Rectangle { visible: modelData[3]; anchors.right: sz.left; anchors.rightMargin: 14; y: 13; width: 70; height: 22; radius: 6; color: K.s1
              Txt { anchors.centerIn: parent; m: true; text: " admin"; font.pixelSize: 11; color: K.sub1 } }
            Txt { id: sz; anchors.right: parent.right; y: 14; m: true; text: modelData[2] } } } } }
    Rectangle { width: parent.width; height: 70; radius: 10; color: "#262626"; border.color: "#333"
      Txt { x: 16; y: 12; m: true; text: "\uf120"; color: K.sub1; font.pixelSize: 18 }
      Txt { x: 46; y: 12; width: parent.width - 62; wrapMode: Text.WordWrap; font.pixelSize: 13; color: K.sub1
        text: "Caches are removed, not trashed. Nothing in Documents, Projects or Pictures is touched. Review items you tick go to the Trash, which frees space only once emptied." } }
    Footer { width: parent.width; hint: "Then rescans and reports what was freed"; second: "Back"; action: "Run" } } }
