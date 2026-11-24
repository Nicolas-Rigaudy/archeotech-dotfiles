import QtQuick
import "K.js" as K
// One cleanup source, two-line (label + cost) or compact one-line
Item { id: r; property var d; property bool compact: false; property bool hover: false
  height: compact ? 34 : 50
  Rectangle { anchors.fill: parent; anchors.leftMargin: -8; anchors.rightMargin: -8; radius: 7; color: "#ffffff"; opacity: r.hover ? 0.05 : 0 }
  Txt { id: cb; anchors.verticalCenter: parent.verticalCenter; m: true; font.pixelSize: 17
    text: r.d.open ? "" : (r.d.on ? "" : ""); color: r.d.on ? K.accent : K.ov1 }
  Txt { id: lb; x: 32; y: r.compact ? 8 : 6; text: r.d.l; font.pixelSize: 14; color: K.text }
  Txt { visible: r.d.a; anchors.left: lb.right; anchors.leftMargin: 8; y: lb.y + 2; m: true; text: " admin"; font.pixelSize: 11; color: K.ov2 }
  Txt { visible: !r.compact; x: 32; y: 27; text: r.d.c; font.pixelSize: 12; color: K.ov2 }
  Txt { visible: r.compact; x: 270; y: 9; text: r.d.p; m: true; font.pixelSize: 12; color: K.ov1; width: parent.width-270-90; elide: Text.ElideMiddle }
  Txt { visible: !r.compact; anchors.right: sz.left; anchors.rightMargin: 18; y: 8; text: r.d.p; m: true; font.pixelSize: 12; color: K.ov1; horizontalAlignment: Text.AlignRight }
  Txt { id: sz; anchors.right: parent.right; y: r.compact ? 8 : 6; m: true; text: K.h(r.d.b); font.pixelSize: 14; color: r.d.on ? K.text : K.sub0 } }
