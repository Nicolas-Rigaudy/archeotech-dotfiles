pragma Singleton
import QtQuick
import QtCore
import Quickshell.Io

QtObject {
    id: root

    property string barEdge:      "top"
    property string edgeRight:    "cc"
    property string edgeLeft:     "launcher"
    property string edgeBottom:   "dashboard"
    property string edgeTopRight: "nc"

    property var barModules: ({
        left:   ["workspaces", "active-window"],
        center: ["clock"],
        right:  ["systray", "battery", "network", "audio", "notifications", "settings"]
    })

    property FileView _file: FileView {
        path: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.config/quickshell/drawer-config.json"
        watchChanges: true
        preload: true
        printErrors: false
        onTextChanged: {
            var content = text()
            if (!content || !content.trim()) return
            try {
                var cfg = JSON.parse(content)
                if (cfg.barEdge)      root.barEdge      = cfg.barEdge
                if (cfg.edgeRight)    root.edgeRight    = cfg.edgeRight
                if (cfg.edgeLeft)     root.edgeLeft     = cfg.edgeLeft
                if (cfg.edgeBottom)   root.edgeBottom   = cfg.edgeBottom
                if (cfg.edgeTopRight) root.edgeTopRight = cfg.edgeTopRight
                if (cfg.barModules)   root.barModules   = cfg.barModules
            } catch(_) {}
        }
    }
}
