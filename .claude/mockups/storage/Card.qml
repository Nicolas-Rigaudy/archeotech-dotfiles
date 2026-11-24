import QtQuick
import "K.js" as K
Rectangle { id: c; property string title: ""; property alias side: rightSlot.data
  default property alias content: body.data
  property int pad: 16
  radius: 10; color: "#222222"; border.color: "#2c2c2c"; border.width: 1
  Rectangle { anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 } height: 1; color: "#ffffff"; opacity: 0.05 }
  Txt { id: tt; visible: c.title !== ""; text: c.title; x: c.pad; y: 14; font.pixelSize: 13; font.letterSpacing: 1.6; color: K.sub1; font.capitalization: Font.AllUppercase }
  Item { id: rightSlot; anchors { right: parent.right; rightMargin: c.pad; top: parent.top; topMargin: 12 } width: childrenRect.width; height: 20 }
  Div { id: dv; visible: c.title !== ""; anchors { left: parent.left; right: parent.right; leftMargin: c.pad; rightMargin: c.pad } y: 40 }
  Item { id: body; anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: c.pad; top: parent.top; topMargin: c.title !== "" ? 54 : c.pad } } }
