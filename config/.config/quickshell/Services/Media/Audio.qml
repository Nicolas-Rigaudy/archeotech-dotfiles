pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property int  volume:     0
    property bool muted:      false
    property int  micVolume:  0
    property bool micMuted:   false

    // ── Initial reads ──────────────────────────────────────────────────────────

    Component.onCompleted: {
        refreshSink.running  = true
        refreshMute.running  = true
        refreshMic.running   = true
        refreshMicMute.running = true
        subscribe.running    = true
    }

    // ── pactl subscribe — fires on every sink/source change ───────────────────

    property var subscribe: Process {
        command: ["pactl", "subscribe"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                if (line.includes("sink") || line.includes("'change'")) {
                    refreshSink.running = true
                    refreshMute.running = true
                }
                if (line.includes("source")) {
                    refreshMic.running    = true
                    refreshMicMute.running = true
                }
            }
        }
        // Auto-restart if it dies
        onExited: (code, status) => { if (code !== 0 || status !== 0) running = true }
    }

    // ── One-shot readers ───────────────────────────────────────────────────────

    property var refreshSink: Process {
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -1"]
        running: false
        stdout: SplitParser { onRead: data => root.volume = parseInt(data.trim()) || 0 }
        onExited: (code, status) => {
            if (code !== 0) console.warn("Audio: refreshSink exited with code " + code)
        }
    }

    property var refreshMute: Process {
        command: ["bash", "-c", "pactl get-sink-mute @DEFAULT_SINK@ | grep -c 'yes' || echo 0"]
        running: false
        stdout: SplitParser { onRead: data => root.muted = data.trim() === "1" }
        onExited: (code, status) => {
            if (code !== 0) console.warn("Audio: refreshMute exited with code " + code)
        }
    }

    property var refreshMic: Process {
        command: ["bash", "-c", "pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\\d+(?=%)' | head -1"]
        running: false
        stdout: SplitParser { onRead: data => root.micVolume = parseInt(data.trim()) || 0 }
        onExited: (code, status) => {
            if (code !== 0) console.warn("Audio: refreshMic exited with code " + code)
        }
    }

    property var refreshMicMute: Process {
        command: ["bash", "-c", "pactl get-source-mute @DEFAULT_SOURCE@ | grep -c 'yes' || echo 0"]
        running: false
        stdout: SplitParser { onRead: data => root.micMuted = data.trim() === "1" }
        onExited: (code, status) => {
            if (code !== 0) console.warn("Audio: refreshMicMute exited with code " + code)
        }
    }

    // ── Actions ────────────────────────────────────────────────────────────────

    property var _cmd: Process {
        id: cmdRunner
        property string cmd: ""
        command: ["bash", "-c", cmd]
        running: false
        onExited: (code, status) => {
            if (code !== 0) console.warn("Audio: command exited with code " + code)
        }
    }

    function setVolume(pct) {
        _cmd.cmd = "pactl set-sink-volume @DEFAULT_SINK@ " + Math.round(pct) + "%"
        _cmd.running = true
    }

    function toggleMute() {
        _cmd.cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
        _cmd.running = true
    }

    function toggleMicMute() {
        _cmd.cmd = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"
        _cmd.running = true
    }
}
