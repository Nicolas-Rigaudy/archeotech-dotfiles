import QtQuick
import "K.js" as K
// Largest-first list synced with the map: share bar, name, size
Column { id: bl; property var node; property int limit: 12; property string hoverName: ".cdx"; property bool tiers: false
  Repeater { model: bl.node.children.slice(0, bl.limit)
    Item { width: bl.width; height: 38
      Rectangle { anchors.fill: parent; anchors.leftMargin: -6; anchors.rightMargin: -6; radius: 6; color: "#fff"; opacity: modelData.name === bl.hoverName ? 0.06 : 0 }
      Txt { y: 4; m: true; text: modelData.children ? "\uf07b" : "\uf15b"; color: K.ov2; font.pixelSize: 13 }
      Txt { x: 26; y: 3; text: modelData.name; m: true; font.pixelSize: 13; width: bl.width - 26 - 80; elide: Text.ElideRight }
      Txt { anchors.right: parent.right; y: 3; text: K.h(modelData.bytes); m: true; font.pixelSize: 13; color: K.sub1 }
      Rectangle { x: 26; y: 24; width: bl.width - 26; height: 5; radius: 2.5; color: K.mantle
        Rectangle { width: parent.width * modelData.bytes / bl.node.bytes; height: parent.height; radius: 2.5; color: K.ov1 } }
      Txt { anchors.right: parent.right; y: 3; anchors.rightMargin: 74; text: (100*modelData.bytes/bl.node.bytes).toFixed(0) + " %"; m: true; font.pixelSize: 12; color: K.ov1 } } } }
