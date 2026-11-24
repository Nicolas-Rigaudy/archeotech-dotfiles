import QtQuick
import "K.js" as K
import "D.js" as D
// Free-space summary with btrfs metadata state
Item { id: db; property real freeing: 0; property bool narrow: false; height: narrow ? 92 : 74
  Txt { text: "/   btrfs   216.2 G"; m: true; color: K.sub0; font.pixelSize: 13 }
  Txt { anchors.right: parent.right; text: "<b>21.3 G</b> free  ·  9 %"; textFormat: Text.StyledText; font.pixelSize: 14 }
  Rectangle { id: track; y: 26; width: parent.width; height: 12; radius: 6; color: K.mantle; border.color: "#2a2a2a"
    Rectangle { width: parent.width*0.9; height: parent.height; radius: 6; color: K.ov1 }
    Rectangle { visible: db.freeing>0; x: parent.width*(0.9 - db.freeing/D.root.size); width: parent.width*db.freeing/D.root.size; height: parent.height; color: K.accent; opacity: 0.85
      radius: 0 } }
  Txt { y: 48; text: db.freeing>0 ? ("Selected frees <b>" + K.h(db.freeing) + "</b>  →  " + K.h(D.root.free+db.freeing) + " free") : ""; textFormat: Text.StyledText; color: K.sub1; font.pixelSize: 13 }
  Txt { y: db.narrow ? 70 : 48; anchors.right: db.narrow ? undefined : parent.right; text: "  btrfs metadata 2.5 G free · unallocated 1 M"; m: true; color: K.ov2; font.pixelSize: 12 } }
