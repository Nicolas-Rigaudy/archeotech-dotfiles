import QtQuick
// Prim.Divider look: 3px recessed shade + 1px lit lip
Item { property bool vertical: false
  implicitHeight: vertical ? 0 : 4; implicitWidth: vertical ? 4 : 0
  Rectangle { x:0; y:0; width: parent.vertical ? 3 : parent.width; height: parent.vertical ? parent.height : 3; color: "#000000"; opacity: 0.35 }
  Rectangle { x: parent.vertical ? 3 : 0; y: parent.vertical ? 0 : 3; width: parent.vertical ? 1 : parent.width; height: parent.vertical ? parent.height : 1; color: "#ffffff"; opacity: 0.06 } }
