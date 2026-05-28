pragma Singleton
import QtQuick
import "../../Modules/Shell/Panels/Content" as Content

// Sprint 17 Stage 5 — registry mapping panelId → { content, side, size }.
// Adding a panel = one entry here + one file in Modules/Shell/Panels/Content/.
// ShellSurface mounts every entry via Repeater; Panel.qml reads `content`
// and renders it inside the uniform glass chrome with offsetScale anim.
//
// Sprint 18 makes this hot-loadable from `shell-config.json` (alongside
// widget registry); for Stage 5 it stays in QML so the four built-in panels
// can be migrated incrementally without a config-schema change.
QtObject {
    id: root

    readonly property var panels: ({
        cc: {
            content: _ccComp,
            side:    "right",
            size:    320
        },
        nc: {
            content: _ncComp,
            side:    "right",
            size:    320
        },
        launcher: {
            content: _launcherComp,
            side:    "left",
            size:    600
        },
        dashboard: {
            content: _dashboardComp,
            side:    "bottom",
            size:    600
        }
    })

    readonly property var panelIds: Object.keys(panels)

    function panelFor(id) {
        return panels[id]
    }

    // Stage 5 commit-1 placeholder. Each subsequent commit replaces one
    // entry's `content` with an extracted Content/*.qml component.
    property Component _placeholderComp: Component {
        Item {
            property var panelRoot
            Text {
                anchors.centerIn: parent
                text: "(panel content TODO)"
                color: "#cad3f5"
                font.pixelSize: 14
                font.family: "FiraCode Nerd Font"
            }
        }
    }

    // Extracted panel content components — one per migrated panel.
    property Component _ccComp:        Component { Content.ControlCenter      {} }
    property Component _ncComp:        Component { Content.NotificationCenter {} }
    property Component _launcherComp:  Component { Content.Launcher           {} }
    property Component _dashboardComp: Component { Content.Dashboard          {} }
}
