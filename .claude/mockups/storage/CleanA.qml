import QtQuick
import "K.js" as K
import "D.js" as D
// Option A: one column, two-line rows, Free button in the footer
Panel { width: 1000; height: 990
  Column { anchors.fill: parent; spacing: 14
    Header { width: parent.width; tab: 0; hint: "Search 11 cleanups" }
    Card { width: parent.width; height: 108; DiskBar { width: parent.width; freeing: 48494021780 } }
    Card { width: parent.width; height: 7*54 + 62
      Group { width: parent.width; title: "Safe to remove"; note: "6 of 7 selected  ·  45.2 G"; rows: D.safe; hoverAt: 1 } }
    Card { width: parent.width; height: 4*54 + 62
      Group { width: parent.width; title: "Review first"; note: "personal files go to the Trash"; rows: D.review } }
    Footer { width: parent.width; hint: "Scanned 4 min ago  ·  Rescan"; second: "Show commands"; action: "Free 45.2 G" } } }
