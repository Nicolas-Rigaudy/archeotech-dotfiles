import QtQuick
import "K.js" as K
Row { property var items: []; spacing: 18; height: 20
  Repeater { model: parent.items
    Row { spacing: 6
      Rectangle { width: 16; height: 16; radius: 3; color: modelData[1]; anchors.verticalCenter: parent.verticalCenter; border.color: "#555" }
      Txt { text: modelData[0]; font.pixelSize: 12; color: K.sub0 } } } }
