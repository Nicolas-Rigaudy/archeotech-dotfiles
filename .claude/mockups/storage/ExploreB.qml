import QtQuick
import "K.js" as K
import "tree.js" as T
// Option B: treemap full width on top, list below; coloured by cleanup tier
Panel { width: 1240; height: 1040
  Header { id: hd; width: parent.width; tab: 1; hint: "Find a folder in ~" }
  Item { id: bar; anchors.top: hd.bottom; anchors.topMargin: 12; width: parent.width; height: 28
    Crumb { parts: ["~"]; total: "149.6 G" }
    Legend { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
      items: [["safe to clean", K.accent], ["review", "#767676"], ["yours", "#333333"]] } }
  Rectangle { id: mapbox; anchors { top: bar.bottom; topMargin: 10; left: parent.left; right: parent.right } height: 560; radius: 10; color: K.crust; border.color: "#2a2a2a"
    Treemap { anchors.fill: parent; anchors.margins: 4; node: T.tree; colorBy: "tier" } }
  Card { id: lc; anchors { top: mapbox.bottom; topMargin: 12; left: parent.left; bottom: foot.top; bottomMargin: 8 } width: (parent.width - 12)/2; title: "Largest first"
    BigList { width: parent.width; node: T.tree; limit: 6 } }
  Card { anchors { top: mapbox.bottom; topMargin: 12; left: lc.right; leftMargin: 12; right: parent.right; bottom: foot.top; bottomMargin: 8 } title: ".cdx/profiles  ·  hovered"
    Column { width: parent.width; spacing: 8
      Txt { text: "42.8 G  ·  29 % of ~"; m: true; font.pixelSize: 20; font.weight: Font.DemiBold }
      Txt { text: "Contains 2 leftover profile folders (21.4 G) listed in Clean up › Review."; wrapMode: Text.WordWrap; width: parent.width; color: K.sub0; font.pixelSize: 13 }
      Row { spacing: 10; Btn { label: "Open in Files" } Btn { label: "Show in Clean up" } } } }
  Footer { id: foot; anchors.bottom: parent.bottom; width: parent.width; hint: "Scanned 4 min ago  ·  click a box to open it"; second: "Rescan" } }
