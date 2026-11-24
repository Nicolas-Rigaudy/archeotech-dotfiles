import QtQuick
import "K.js" as K
// One header row: segmented tab switch + wide search (owner's Keyboard panel pattern)
Item { id: hd; property int tab: 0; property string hint: "Search 11 cleanups"
  height: 40
  Rectangle { id: seg; width: 260; height: 36; radius: 9; color: K.mantle; border.color: "#2a2a2a"
    Row { anchors.fill: parent; anchors.margins: 3
      Repeater { model: ["  Clean up", "  Explore"]
        Rectangle { width: (seg.width-6)/2; height: 30; radius: 7; color: index===hd.tab ? K.s2 : "transparent"
          border.color: index===hd.tab ? "#4a4a4a" : "transparent"
          Txt { anchors.centerIn: parent; text: modelData; m: false; font.pixelSize: 14; color: index===hd.tab ? K.text : K.ov2
            font.family: K.mono } } } } }
  Rectangle { anchors { left: seg.right; leftMargin: 12; right: parent.right } height: 36; radius: 9; color: K.mantle; border.color: "#2a2a2a"
    Txt { x: 14; anchors.verticalCenter: parent.verticalCenter; text: ""; m: true; color: K.ov1 }
    Txt { x: 40; anchors.verticalCenter: parent.verticalCenter; text: hd.hint; color: K.ov1 } } }
