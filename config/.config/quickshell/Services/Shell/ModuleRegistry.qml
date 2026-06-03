pragma Singleton
import QtQuick
import Quickshell.Io

// Sprint 21 Chunk 2 — community extension discovery.
//
// Scans two roots for self-describing modules (each a folder with a
// `module.json` + entry QML):
//   ~/.config/quickshell/modules/        — repo-tracked / bundled modules
//   ~/.local/share/archeotech/modules/   — user-installed modules
//
// A module is referenced from shell-config.json by `plugin:<id>` (matching
// WidgetRegistry's existing plugin-prefix convention). Built-in bar widgets,
// strip icons and panels are NOT modules — they stay in WidgetRegistry /
// PanelRegistry. This registry is purely the third-party extension layer.
//
// Discovery uses the codebase's standard Process+jq scan idiom (see
// ActiveProjects). jq emits one compact JSON object per module, each tagged
// with its absolute directory so `entryUrl()` can resolve the QML file.
//
// module.json schema — see docs/MODULE_API.md:
//   { id, name, author, version, canLiveIn[], entry, icon, defaultSize{}, panel{}, configSchema{} }
//   canLiveIn ∈ { "bar-zone", "strip-icon", "panel-content", "desktop-widget" }
QtObject {
    id: root

    // Discovered modules: array of the parsed manifest objects, each with an
    // extra `dir` (absolute, trailing slash) injected by the scan.
    property var modules: []
    property bool ready: false

    function _bare(id) {
        return (typeof id === "string" && id.indexOf("plugin:") === 0) ? id.slice(7) : id
    }

    function moduleFor(id) {
        var b = _bare(id)
        for (var i = 0; i < modules.length; i++)
            if (modules[i].id === b) return modules[i]
        return null
    }

    // Absolute file:// URL to a module's entry QML, or "" if unknown.
    function entryUrl(id) {
        var m = moduleFor(id)
        if (!m || !m.dir || !m.entry) return ""
        return "file://" + m.dir + m.entry
    }

    function canLiveIn(id, target) {
        var m = moduleFor(id)
        return !!m && (m.canLiveIn || []).indexOf(target) !== -1
    }

    // Modules accepting any of the given placement targets (for the palette).
    function modulesFor(targets) {
        var out = []
        for (var i = 0; i < modules.length; i++) {
            var cl = modules[i].canLiveIn || []
            for (var j = 0; j < targets.length; j++) {
                if (cl.indexOf(targets[j]) !== -1) { out.push(modules[i]); break }
            }
        }
        return out
    }

    function rescan() { if (!_scan.running) _scan.running = true }

    // FileView-style directory watching isn't available; we rescan on demand
    // (edit-mode open calls rescan()) plus once at startup.
    property Process _scan: Process {
        running: false
        command: ["bash", "-c",
            "scan(){ [ -d \"$1\" ] || return; for d in \"$1\"/*/; do m=\"${d}module.json\"; " +
            "[ -f \"$m\" ] || continue; " +
            "jq -c --arg dir \"$d\" '{dir:$dir, id, name, author, version, canLiveIn, entry, icon, defaultSize, panel, configSchema}' \"$m\" 2>/dev/null; " +
            "done; }; " +
            "scan \"$HOME/.config/quickshell/modules\"; " +
            "scan \"$HOME/.local/share/archeotech/modules\""
        ]

        property var _buf: []
        onRunningChanged: if (running) _buf = []

        stdout: SplitParser {
            onRead: line => {
                var t = line.trim()
                if (!t) return
                try {
                    var m = JSON.parse(t)
                    if (m && m.id && m.entry) _scan._buf = _scan._buf.concat([m])
                } catch (e) {
                    console.warn("[ModuleRegistry] bad manifest line:", t)
                }
            }
        }
        onExited: {
            root.modules = _scan._buf
            root.ready = true
            console.log("[ModuleRegistry] discovered", root.modules.length, "module(s):",
                root.modules.map(function(m) { return m.id }).join(" "))
        }
    }

    Component.onCompleted: rescan()
}
