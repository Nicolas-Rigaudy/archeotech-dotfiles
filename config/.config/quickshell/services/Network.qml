pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool   connected:  false
    property string ssid:       ""
    property int    signal:     0
    property string band:       ""
    property bool   wired:      false

    Component.onCompleted: { refresh.running = true; monitor.running = true }

    // Persistent monitor — nmcli emits a line on any connectivity change
    property var monitor: Process {
        command: ["nmcli", "monitor"]
        running: false
        stdout: SplitParser {
            onRead: _line => { refresh.running = true }
        }
        onExited: (code, status) => { running = true }
    }

    property var refresh: Process {
        command: ["bash", "-c",
            "LINE=$(nmcli -t -f active,ssid,signal,freq dev wifi 2>/dev/null | grep '^yes' | head -1); " +
            "SSID=$(echo \"$LINE\" | cut -d: -f2); " +
            "SIG=$(echo \"$LINE\" | cut -d: -f3); " +
            "FREQ=$(echo \"$LINE\" | cut -d: -f4); " +
            "echo \"$SSID|$SIG|$FREQ\""]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split("|")
                var s = parts[0] || ""
                root.ssid      = s
                root.connected = s.length > 0
                root.signal    = parseInt(parts[1]) || 0
                var freq       = parseInt(parts[2]) || 0
                root.band      = freq >= 5000 ? "5 GHz" : freq >= 2000 ? "2.4 GHz" : ""
            }
        }
    }

    function icon() {
        if (!connected) return "󰖪"
        return "󰖩"
    }
}
