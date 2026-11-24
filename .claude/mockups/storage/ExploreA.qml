import QtQuick
import "K.js" as K
import "tree.js" as T
// Option A: treemap 2/3 left, largest-first list right; coloured by type
Panel { width: 1500; height: 900
  Header { id: hd; width: parent.width; tab: 1; hint: "Find a folder in ~" }
  Item { id: bar; anchors.top: hd.bottom; anchors.topMargin: 12; width: parent.width; height: 28
    Crumb { parts: ["~"]; total: "149.6 G  ·  12 folders" }
    Legend { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
      items: [["cache", "#9a9a9a"], ["old / leftover", "#7c7c7c"], ["apps & config", "#5e5e5e"], ["documents & code", "#3e3e3e"]] } }
  Rectangle { id: mapbox; anchors { top: bar.bottom; topMargin: 10; left: parent.left; bottom: foot.top; bottomMargin: 10 } width: 1000; radius: 10; color: K.crust; border.color: "#2a2a2a"
    Treemap { anchors.fill: parent; anchors.margins: 4; node: T.tree; colorBy: "cat" } }
  Card { anchors { top: bar.bottom; topMargin: 10; left: mapbox.right; leftMargin: 14; right: parent.right; bottom: foot.top; bottomMargin: 10 } title: "Largest first"
    BigList { width: parent.width; node: T.tree; limit: 15 } }
  Footer { id: foot; anchors.bottom: parent.bottom; width: parent.width; hint: "Scanned 4 min ago  ·  click a box to open it  ·  right-click: open in Files"; second: "Rescan" } }
