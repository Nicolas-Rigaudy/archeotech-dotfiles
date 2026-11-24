import QtQuick
import "K.js" as K
import "TM.js" as TM
// Two-level squarified treemap: level-1 frames with a header strip, level-2 boxes inside
Item { id: tm; property var node; property string colorBy: "cat"; property string hoverName: ".cdx/profiles"
  readonly property var catCol: ({ cache: "#9a9a9a", apps: "#5e5e5e", docs: "#3e3e3e", old: "#7c7c7c" })
  function tierOf(path) {
    var safe = [".cdx/shared-cache", ".cache/paru", ".cache/zen", ".cache/spotify", ".cache/aws", ".cache/pypoetry", ".cache/wallpaper", ".cache/other"]
    var review = [".cdx/profiles", "arch-backup-20251126", "Downloads", "Documents/downloads_archive"]
    for (var i=0;i<safe.length;i++) if (path.indexOf(safe[i])===0) return "safe"
    for (i=0;i<review.length;i++) if (path.indexOf(review[i])===0) return "review"
    return "" }
  function fill(n, path) {
    if (colorBy === "cat") return catCol[n.cat] || "#4a4a4a"
    var t = tierOf(path); return t === "safe" ? K.accent : t === "review" ? "#767676" : "#333333" }
  function ink(c) { return (c.hslLightness > 0.42) ? "#141414" : K.text }
  Repeater { model: TM.layout(tm.node.children, 0, 0, tm.width, tm.height)
    Item { id: f; property var n: modelData.item; x: modelData.x + 1; y: modelData.y + 1; width: modelData.w - 2; height: modelData.h - 2
      property bool hasKids: !!n.children && n.children.length > 0 && width > 40 && height > 40
      Rectangle { anchors.fill: parent; radius: 4; color: K.crust; border.color: "#000" }
      // header strip
      Item { id: hs; visible: f.hasKids; width: parent.width; height: f.height > 70 ? 22 : 0; clip: true
        Txt { x: 6; y: 3; text: f.n.name; m: true; font.pixelSize: 12; font.weight: Font.DemiBold; color: K.text; width: parent.width - 70; elide: Text.ElideRight }
        Txt { anchors.right: parent.right; anchors.rightMargin: 6; y: 3; text: K.h(f.n.bytes); m: true; font.pixelSize: 12; color: K.sub0 } }
      // leaf (no children): one box
      Rectangle { visible: !f.hasKids; anchors.fill: parent; anchors.margins: 1; radius: 3; color: tm.fill(f.n, f.n.name)
        Txt { visible: parent.width > 50 && parent.height > 34; x: 5; y: 3; text: f.n.name; m: true; font.pixelSize: 11; color: tm.ink(parent.color); width: parent.width - 8; elide: Text.ElideRight }
        Txt { visible: parent.width > 50 && parent.height > 34; x: 5; y: 18; text: K.h(f.n.bytes); m: true; font.pixelSize: 11; color: tm.ink(parent.color); opacity: 0.75 } }
      Item { visible: f.hasKids; anchors { fill: parent; topMargin: hs.height + 1; margins: 1 }
        Repeater { model: f.hasKids ? TM.layout(f.n.children, 0, 0, parent.width, parent.height) : []
          Rectangle { property string p: f.n.name + "/" + modelData.item.name
            x: modelData.x + 1; y: modelData.y + 1; width: Math.max(0, modelData.w - 2); height: Math.max(0, modelData.h - 2); radius: 3
            color: tm.fill(modelData.item, p)
            border.width: p === tm.hoverName ? 2 : 0; border.color: "#ffffff"
            Rectangle { anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 } height: 1; color: "#fff"; opacity: 0.10 }
            Txt { visible: parent.width > 54 && parent.height > 22; x: 5; y: 3; text: modelData.item.name; m: true; font.pixelSize: 11; color: tm.ink(parent.color); width: parent.width - 8; elide: Text.ElideRight }
            Txt { visible: parent.width > 54 && parent.height > 38; x: 5; y: 18; text: K.h(modelData.item.bytes); m: true; font.pixelSize: 11; color: tm.ink(parent.color); opacity: 0.75 } } } } } } }
