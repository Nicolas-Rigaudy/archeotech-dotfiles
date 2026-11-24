import QtQuick
import "K.js" as K
Text { property bool m: false
  color: K.text; font.family: m ? K.mono : K.sans; font.pixelSize: 14 }
