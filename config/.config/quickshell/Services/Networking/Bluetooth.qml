pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool   enabled:   false
    property bool   connected: false
    property string device:    ""

    Component.onCompleted: {
        pollEnabled.running = true
        pollDevice.running  = true
        monitor.running     = true
    }

    // ── D-Bus signal monitor — fires on any org.bluez PropertiesChanged ────────
    // Replaces 5s poll timer. Triggers a re-query on adapter or device changes.
    property var monitor: Process {
        command: ["busctl", "monitor", "--json=short", "org.bluez"]
        running: false
        stdout: SplitParser {
            onRead: _line => {
                pollEnabled.running = true
                pollDevice.running  = true
            }
        }
        onExited: (code, status) => {
            console.warn("Bluetooth: busctl monitor exited (code=" + code + "), restarting")
            running = true
        }
    }

    property var pollEnabled: Process {
        command: ["busctl", "get-property", "org.bluez", "/org/bluez/hci0",
                  "org.bluez.Adapter1", "Powered"]
        running: false
        stdout: SplitParser {
            onRead: data => { root.enabled = data.trim().includes("true") }
        }
        onExited: (code, status) => {
            if (code !== 0) console.warn("Bluetooth: pollEnabled exited with code " + code)
        }
    }

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
        onExited: (code, status) => {
            if (code !== 0) console.warn("Bluetooth: pollDevice exited with code " + code)
        }
    }

    property var _cmd: Process {
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
        onExited: (code, status) => {
            if (code !== 0) console.warn("Bluetooth: command exited with code " + code)
        }
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
