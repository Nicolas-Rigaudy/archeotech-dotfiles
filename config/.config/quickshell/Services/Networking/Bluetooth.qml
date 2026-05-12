pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool   enabled:   false
    property bool   connected: false
    property string device:    ""
    property var    devices:   []

    Component.onCompleted: _refresh()

    function _refresh() {
        if (!pollEnabled.running) pollEnabled.running = true
        if (!pollDevices.running) {
            pollDevices._incoming = []
            pollDevices.running   = true
        }
    }

    // ── D-Bus signal monitor ───────────────────────────────────────────────────
    property var monitor: Process {
        command: ["busctl", "monitor", "--json=short", "org.bluez"]
        running: true
        stdout: SplitParser { onRead: _line => root._refresh() }
        onExited: (code, status) => {
            console.warn("Bluetooth: busctl monitor exited, restarting")
            running = true
        }
    }

    // ── Adapter powered state ──────────────────────────────────────────────────
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

    // ── Paired device list ─────────────────────────────────────────────────────
    property var pollDevices: Process {
        property var _incoming: []
        command: ["bash", "-c",
            "busctl tree org.bluez 2>/dev/null | grep -oP '/org/bluez/hci0/dev_\\w+' | " +
            "while IFS= read -r dev; do " +
            "  name=$(busctl get-property org.bluez \"$dev\" org.bluez.Device1 Alias 2>/dev/null | cut -d'\"' -f2); " +
            "  addr=$(busctl get-property org.bluez \"$dev\" org.bluez.Device1 Address 2>/dev/null | cut -d'\"' -f2); " +
            "  conn=$(busctl get-property org.bluez \"$dev\" org.bluez.Device1 Connected 2>/dev/null | awk '{print $2}'); " +
            "  paird=$(busctl get-property org.bluez \"$dev\" org.bluez.Device1 Paired 2>/dev/null | awk '{print $2}'); " +
            "  [ \"$paird\" = true ] && " +
            "    printf '{\"name\":\"%s\",\"address\":\"%s\",\"connected\":%s}\\n' \"$name\" \"$addr\" \"${conn:-false}\"; " +
            "done"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                try {
                    var d = JSON.parse(data.trim())
                    pollDevices._incoming = pollDevices._incoming.concat([d])
                } catch(e) {}
            }
        }
        onExited: (code, status) => {
            root.devices = pollDevices._incoming
            var conn = pollDevices._incoming.filter(d => d.connected)
            root.connected = conn.length > 0
            root.device    = conn.length > 0 ? conn[0].name : ""
            if (code !== 0) console.warn("Bluetooth: pollDevices exited with code " + code)
        }
    }

    // ── Commands ───────────────────────────────────────────────────────────────
    property var _cmd: Process {
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
        onExited: (code, status) => {
            if (code !== 0) console.warn("Bluetooth: command exited with code " + code)
            root._refresh()
        }
    }

    function _run(cmd) { _cmd.cmd = cmd; _cmd.running = true }

    function toggle() {
        _run("busctl set-property org.bluez /org/bluez/hci0 org.bluez.Adapter1 Powered b " +
             (enabled ? "false" : "true"))
    }

    function connectDevice(address) {
        var path = "/org/bluez/hci0/dev_" + address.replace(/:/g, "_")
        _run("busctl call org.bluez \"" + path + "\" org.bluez.Device1 Connect")
    }

    function disconnectDevice(address) {
        var path = "/org/bluez/hci0/dev_" + address.replace(/:/g, "_")
        _run("busctl call org.bluez \"" + path + "\" org.bluez.Device1 Disconnect")
    }

    function icon() {
        if (connected) return "󰂱"
        if (enabled)   return "󰂯"
        return "󰂲"
    }
}
