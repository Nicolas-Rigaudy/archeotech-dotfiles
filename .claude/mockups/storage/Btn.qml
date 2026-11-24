import QtQuick
import "K.js" as K
Rectangle { property string label; property bool primary: false
  width: tl.implicitWidth + 32; height: 36; radius: 9
  color: primary ? K.accent : K.s1; border.color: primary ? "#f0f0f0" : "#3c3c3c"
  Txt { id: tl; anchors.centerIn: parent; text: parent.label; m: false; font.pixelSize: 14; font.weight: parent.primary ? Font.DemiBold : Font.Normal; color: parent.primary ? K.base : K.text } }
