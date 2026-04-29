pragma Singleton
import QtQuick
import Quickshell.Io

// Parses mmsg -w output. Line format examples:
//   eDP-1 tag 3 1 0 0        → output, "tag", tagNum, selected, occupied, urgent
//   eDP-1 title some text     → focused window title
//   eDP-1 appid kitty         → focused window app id
//   eDP-1 layout S            → current layout symbol
//   eDP-1 selmon 0/1          → whether this output is the focused monitor (watch-mode only)

QtObject {
    id: root

    // Per-output state — keyed by output name (e.g. "eDP-1")
    // Each entry: { tags: [{num, selected, occupied, urgent}], title, appid, layout, focused }
    property var outputs: ({})

    // Convenience: focused output name
    property string focusedOutput: ""

    Component.onCompleted: watch.running = true

    property var watch: Process {
        command: ["mmsg", "-w", "-O", "-t", "-l", "-c"]
        running: false
        stdout: SplitParser {
            onRead: line => root._parseLine(line.trim())
        }
        onExited: (code, status) => { running = true }
    }

    function _parseLine(line) {
        if (!line || line.startsWith("+") || line.startsWith("-")) return

        var parts = line.split(" ")
        if (parts.length < 2) return

        var output = parts[0]
        var field  = parts[1]

        // Ensure output entry exists
        if (!outputs[output]) {
            outputs[output] = {
                tags:   [],
                title:  "",
                appid:  "",
                layout: "",
                focused: false
            }
        }

        var entry = outputs[output]

        if (field === "tag" && parts.length >= 6) {
            var num      = parseInt(parts[2])
            var selected = parts[3] === "1"
            var occupied = parts[4] === "1"
            var urgent   = parts[5] === "1"
            // Update or insert
            var existing = false
            for (var i = 0; i < entry.tags.length; i++) {
                if (entry.tags[i].num === num) {
                    entry.tags[i] = { num, selected, occupied, urgent }
                    existing = true
                    break
                }
            }
            if (!existing) entry.tags.push({ num, selected, occupied, urgent })
            entry.tags.sort((a, b) => a.num - b.num)
        } else if (field === "title") {
            entry.title = parts.slice(2).join(" ")
        } else if (field === "appid") {
            entry.appid = parts.slice(2).join(" ")
        } else if (field === "layout") {
            entry.layout = parts[2] || ""
        } else if (field === "selmon") {
            var isFocused = parts[2] === "1" || parts[2] === "0"
            // selmon value is 0 = not selected monitor in watch, but in -g mode the selected monitor
            // is indicated by "selmon 0". Track which output line has selmon.
            // In watch mode, selmon is emitted when focus changes.
            entry.focused = (parts[2] !== undefined)
            if (entry.focused) root.focusedOutput = output
        }

        // Force QML to notice the object changed
        root.outputs = Object.assign({}, root.outputs)
    }

    // Helper: get tags for a given output, sorted
    function tagsFor(output) {
        return outputs[output] ? outputs[output].tags : []
    }

    // Helper: get title for a given output
    function titleFor(output) {
        return outputs[output] ? outputs[output].title : ""
    }

    // Helper: layout symbol for a given output
    function layoutFor(output) {
        return outputs[output] ? outputs[output].layout : ""
    }

    // Switch to tag N on a given output
    property var _setTag: Process {
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
    }

    function switchTag(output, tagNum) {
        _setTag.cmd = "mmsg -o " + output + " -s -t " + tagNum
        _setTag.running = true
    }
}
