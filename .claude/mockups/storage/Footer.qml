import QtQuick
import "K.js" as K
// Muted footer: scan age + rescan left, action right
Item { id: f; property string hint: "Scanned 4 min ago"; property string action: ""; property string second: ""; height: 40
  Txt { anchors.verticalCenter: parent.verticalCenter; m: true; text: "  " + f.hint; font.pixelSize: 12; color: K.ov1 }
  Row { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; spacing: 10
    Btn { visible: f.second !== ""; label: f.second }
    Btn { visible: f.action !== ""; label: f.action; primary: true } } }
