import QtQuick
import "K.js" as K
// Bottom-centred panel shell (glass-ish dark plate, like the dashboard)
Rectangle { default property alias content: inner.data
  anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 14
  radius: 16; color: K.base; border.color: "#2e2e2e"
  Rectangle { anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 } height: 1; color: "#fff"; opacity: 0.07 }
  Item { id: inner; anchors.fill: parent; anchors.margins: 20 } }
