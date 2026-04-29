pragma Singleton
import QtQuick
import Quickshell.Io

// Uses busctl to query org.bluez — bluetoothctl is not installed on this system.
// Polls every 5s; busctl monitor would be ideal but adds complexity.

QtObject {
    id: root

    property bool   enabled:   false
    property bool   connected: false
    property string device:    ""

    Component.onCompleted: { pollEnabled.running = true; pollDevice.running = true }

    property var pollEnabled: Process {
        command: ["busctl", "get-property", "org.bluez", "/org/bluez/hci0",
                  "org.bluez.Adapter1", "Powered"]
        running: false
        stdout: SplitParser {
            onRead: data => { root.enabled = data.trim().includes("true") }
        }
    }

    // Check first known device path; fallback to no device
    property var pollDevice: Process {
        command: ["bash", "-c",
            "for dev in $(busctl tree org.bluez 2>/dev/null | grep 'dev_' | awk '{print $NF}'); do " +
            "  conn=$(busctl get-property org.bluez $dev org.bluez.Device1 Connected 2>/dev/null); " +
            "  if echo \"$conn\" | grep -q true; then " +
            "    busctl get-property org.bluez $dev org.bluez.Device1 Alias 2>/dev/null | tr -d '\"' | awk '{print $2}'; " +
            "    exit 0; " +
            "  fi; " +
            "done; echo ''"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var d = data.trim().replace(/^s /, "").replace(/"/g, "")
                root.device    = d
                root.connected = d.length > 0
            }
        }
    }

    property var _timer: Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: { pollEnabled.running = true; pollDevice.running = true }
    }

    property var _cmd: Process {
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
    }

    function toggle() {
        var newState = enabled ? "false" : "true"
        _cmd.cmd = "busctl set-property org.bluez /org/bluez/hci0 org.bluez.Adapter1 Powered b " + newState
        _cmd.running = true
    }

    function icon() {
        if (connected) return "󰂱"
        if (enabled)   return "󰂯"
        return "󰂲"
    }
}
