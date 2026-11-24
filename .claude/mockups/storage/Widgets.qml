import QtQuick
import "K.js" as K
// Bar widget options, shown 2x on fake bar strips, three levels each
Item { width: 1920; height: 1200
  Rectangle { anchors.centerIn: parent; width: 1500; height: 820; radius: 16; color: K.base; border.color: "#2e2e2e"
    Txt { x: 30; y: 24; text: "Bar widget  ·  shown at 2x on a bar strip  ·  left to right: normal, warn (≤ 15 % free), critical (≤ 8 %)"; color: K.sub1; font.pixelSize: 16 }
    Column { x: 30; y: 70; spacing: 26
      Repeater { model: [["a  Ring", "ring", "ring only when fine; free space appears when low"], ["b  Bar", "bar", "drive icon + mini bar; free space appears when low"], ["c  Text", "text", "drive icon + free space, always"]]
        Column { id: vc; spacing: 8; property string vv: modelData[1]
          Item { width: 900; height: 26
            Txt { text: modelData[0]; font.pixelSize: 18; font.weight: Font.DemiBold }
            Txt { x: 120; y: 3; text: modelData[2]; color: K.ov2; font.pixelSize: 14 } }
          Row { spacing: 30
            Repeater { model: ["ok", "warn", "crit"]
              Rectangle { width: 450; height: 80; radius: 10; color: K.mantle; border.color: "#2a2a2a"; clip: true
                Item { width: 165; height: 40; scale: 2; transformOrigin: Item.TopLeft
                  Row { anchors.verticalCenter: parent.verticalCenter; x: 8; spacing: 8
                    Txt { m: true; text: "\uf1eb"; color: K.ov2; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Wid { v: vc.vv; lv: modelData; anchors.verticalCenter: parent.verticalCenter }
                    Txt { m: true; text: "14:32"; color: K.text; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter } } } } } } } } }
    // hover card
    Rectangle { x: 30; y: 570; width: 520; height: 220; radius: 12; color: "#232323"; border.color: "#3a3a3a"
      Txt { x: 16; y: 14; text: "HOVER CARD"; font.pixelSize: 12; font.letterSpacing: 1.6; color: K.sub1 }
      Txt { x: 16; y: 44; text: "/  ·  21.3 G free of 216 G"; m: true; font.pixelSize: 15 }
      Txt { x: 16; y: 72; text: "btrfs metadata 2.5 G free  ·  unallocated 1 M"; m: true; font.pixelSize: 12; color: K.ov2 }
      Txt { x: 16; y: 100; text: "Top: uv cache 27.7 G, leftover cdx 18.4 G, pacman 7.8 G"; font.pixelSize: 13; color: K.sub0; width: 490; wrapMode: Text.WordWrap }
      Txt { x: 16; y: 180; text: "Click: open Storage  ·  Right-click: rescan"; font.pixelSize: 12; color: K.ov1 } } } }
