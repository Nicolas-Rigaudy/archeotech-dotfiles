import QtQuick
import "K.js" as K
import "D.js" as D
// Picked: B side card + A two-line rows
Panel { width: 1400; height: 880
  Header { id: hd; width: parent.width; tab: 0; hint: "Search 11 cleanups" }
  Card { id: lst; anchors { top: hd.bottom; topMargin: 14; left: parent.left; bottom: parent.bottom } width: 900
    Column { width: parent.width; spacing: 10
      Group { width: parent.width; title: "Safe to remove"; note: "6 of 7  ·  45.2 G"; rows: D.safe; hoverAt: 1 }
      Item { width: 1; height: 6 }
      Group { width: parent.width; title: "Review first"; note: "to the Trash"; rows: D.review } } }
  Card { anchors { top: hd.bottom; topMargin: 14; left: lst.right; leftMargin: 14; right: parent.right; bottom: parent.bottom } title: "Selected"
    Column { width: parent.width; spacing: 12
      Txt { text: "45.2 G"; m: true; font.pixelSize: 40; font.weight: Font.DemiBold }
      Txt { text: "6 cleanups  ·  2 need your password"; color: K.ov2; font.pixelSize: 13 }
      DiskBar { narrow: true; width: parent.width; freeing: 48494021780 }
      Div { width: parent.width }
      Txt { text: "WILL RUN"; font.pixelSize: 12; font.letterSpacing: 1.6; color: K.sub1 }
      Rectangle { width: parent.width; height: 168; radius: 8; color: K.crust; border.color: "#262626"
        Column { x: 12; y: 10; spacing: 6
          Repeater { model: ["uv cache clean", "pkexec paccache -rk2", "rm -rf ~/.cache/paru/clone", "rm -rf ~/.cache/{zen,spotify,…}", "pkexec journalctl --vacuum-size=500M", "gio trash --empty"]
            Txt { m: true; font.pixelSize: 12; color: modelData.indexOf("pkexec")===0 ? K.text : K.sub0; text: (modelData.indexOf("pkexec")===0 ? "# " : "$ ") + modelData.replace("pkexec ", "") } } } }
      Item { width: 1; height: 4 }
      Row { spacing: 10; anchors.right: parent.right
        Btn { label: "Rescan" }
        Btn { label: "Free 45.2 G"; primary: true } }
      Txt { text: "  Scanned 4 min ago"; m: true; font.pixelSize: 12; color: K.ov1 } } } }
