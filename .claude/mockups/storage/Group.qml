import QtQuick
import "K.js" as K
Column { id: g; property string title; property string note; property var rows; property bool compact: false; property int hoverAt: -1
  spacing: 0
  Item { width: g.width; height: 30
    Txt { y: 4; text: g.title; font.pixelSize: 12; font.letterSpacing: 1.6; color: K.sub1; font.capitalization: Font.AllUppercase }
    Txt { y: 5; anchors.right: parent.right; text: g.note; font.pixelSize: 12; color: K.ov1 } }
  Repeater { model: g.rows
    Column { width: g.width
      Div { width: g.width; visible: index>0; height: 4 }
      CRow { width: g.width; d: modelData; compact: g.compact; hover: index===g.hoverAt } } } }
