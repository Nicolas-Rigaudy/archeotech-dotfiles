import QtQuick
import "K.js" as K
Row { property var parts: ["~"]; property string total: ""; spacing: 8; height: 28
  Txt { m: true; text: "\uf015"; color: K.ov2; anchors.verticalCenter: parent.verticalCenter }
  Repeater { model: parent.parts
    Row { spacing: 8; anchors.verticalCenter: parent.verticalCenter
      Txt { visible: index > 0; m: true; text: "›"; color: K.ov0 }
      Txt { m: true; text: modelData; color: index === parent.parent.parts.length - 1 ? K.text : K.ov2; font.weight: index === parent.parent.parts.length - 1 ? Font.DemiBold : Font.Normal } } }
  Txt { m: true; text: parent.total; color: K.ov1; anchors.verticalCenter: parent.verticalCenter; leftPadding: 10 } }
