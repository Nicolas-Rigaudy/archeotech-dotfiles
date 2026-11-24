import QtQuick
import Quickshell
import Quickshell.Wayland
PanelWindow { id: w; default property alias content: stage.data; property string label: ""
  anchors { top: true; bottom: true; left: true; right: true }
  WlrLayershell.layer: WlrLayer.Overlay; exclusionMode: ExclusionMode.Ignore; color: "#000"
  Image { anchors.fill: parent; source: "wall.jpg"; fillMode: Image.PreserveAspectCrop }
  Rectangle { anchors.fill: parent; color: "#000"; opacity: 0.35 }
  // fake bar (top), so the panel sits in context
  Rectangle { width: parent.width; height: 40; color: "#141414"; opacity: 0.92 }
  Item { id: stage; anchors.fill: parent }
  Rectangle { x: 20; y: 56; width: lt.implicitWidth + 28; height: 40; radius: 8; color: "#000"; opacity: 0.8; visible: w.label !== ""
    Text { id: lt; anchors.centerIn: parent; text: w.label; color: "#fff"; font.pixelSize: 20; font.family: "Noto Sans"; font.weight: Font.Bold } } }
