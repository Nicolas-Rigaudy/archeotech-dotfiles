pragma Singleton
import QtQuick

QtObject {
    readonly property var panes: [
        { id: "appearance",    label: "Appearance",    icon: "󰔯", source: "./Panes/AppearancePane.qml"    },
        { id: "bar",           label: "Bar",           icon: "󰘧", source: "./Panes/BarPane.qml"           },
        { id: "display",       label: "Display",       icon: "󱄅", source: "./Panes/DisplayPane.qml"       },
        { id: "notifications", label: "Notifications", icon: "󰂚", source: "./Panes/NotificationsPane.qml" },
        { id: "connections",   label: "Connections",   icon: "󰤨", source: "./Panes/ConnectionsPane.qml"   },
        { id: "audio",         label: "Audio",         icon: "󰕾", source: "./Panes/AudioPane.qml"         },
        { id: "power",         label: "Power",         icon: "󱐋", source: "./Panes/PowerPane.qml"         },
        { id: "about",         label: "About",         icon: "󰅺", source: "./Panes/AboutPane.qml"         },
    ]

    function indexFor(paneId) {
        for (var i = 0; i < panes.length; i++) {
            if (panes[i].id === paneId) return i
        }
        return 0
    }
}
