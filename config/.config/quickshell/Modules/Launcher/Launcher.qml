import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../../Commons" as Commons

Item {
    id: root
    anchors.fill: parent

    // ── State ──────────────────────────────────────────────────────────────────
    property var    allApps:      []
    property var    filtered:     []
    property string query:        ""
    property int    selectedIdx:  0
    property var    _depIds:      ({})
    property var    _usageCounts: ({})

    // usage → dep → _loadApps chain on startup
    Component.onCompleted: usageReader.running = true

    // re-index when new apps are installed
    Connections {
        target: DesktopEntries
        function onApplicationsChanged() { root._loadApps() }
    }

    // ── Load apps from native API ──────────────────────────────────────────────
    function _loadApps() {
        var model = DesktopEntries.applications
        var entries = model.values || []
        if (!entries.length && model.count) {
            entries = []
            for (var i = 0; i < model.count; i++) entries.push(model.get(i))
        }
        var buf = []
        for (var j = 0; j < entries.length; j++) {
            if (!root._depIds[entries[j].id]) buf.push(entries[j])
        }
        root.allApps = buf
        root._filter()
    }

    // ── Usage reader ───────────────────────────────────────────────────────────
    property var usageReader: Process {
        command: ["bash", "-c", "cat \"$HOME/.cache/qs-launcher-usage\" 2>/dev/null"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var p = data.split("\t")
                if (p.length >= 2 && p[0].trim())
                    root._usageCounts[p[0]] = parseInt(p[1]) || 0
            }
        }
        onExited: (code, status) => { depReader.running = true }
    }

    // ── Dep-ID reader ──────────────────────────────────────────────────────────
    property var depReader: Process {
        command: ["bash", "-c",
            "pacman -Qdq | xargs -r pacman -Ql 2>/dev/null | " +
            "awk '/\\.desktop$/{gsub(\".*/\",\"\"); gsub(\"\\.desktop$\",\"\"); print}'"]
        running: false
        stdout: SplitParser {
            onRead: data => { var id = data.trim(); if (id) root._depIds[id] = true }
        }
        onExited: (code, status) => { root._loadApps() }
    }

    // ── Usage writer ───────────────────────────────────────────────────────────
    property var usageWriter: Process { running: false }

    function _bumpUsage(name) {
        root._usageCounts[name] = (root._usageCounts[name] || 0) + 1
        if (usageWriter.running) return
        var lines = []
        for (var k in root._usageCounts) {
            lines.push("printf '%s\\t%s\\n' '" + k.replace(/'/g, "'\\''") + "' " + root._usageCounts[k])
        }
        usageWriter.command = ["bash", "-c",
            "{ " + lines.join("; ") + "; } > \"$HOME/.cache/qs-launcher-usage\""]
        usageWriter.running = true
    }

    // ── Fuzzy scorer ───────────────────────────────────────────────────────────
    function _fuzzyScore(str, q) {
        if (!str || !q) return 0
        str = str.toLowerCase()
        q   = q.toLowerCase()
        if (str === q)             return 1.0
        if (str.startsWith(q))     return 0.9
        if (str.indexOf(q) !== -1) return 0.7
        var si = 0, qi = 0, score = 0, consec = 0, prev = -1
        while (si < str.length && qi < q.length) {
            if (str[si] === q[qi]) {
                consec = (prev === si - 1) ? consec + 1 : 0
                score += 1.0 + consec * 0.3
                if (si === 0 || " -_".indexOf(str[si - 1]) !== -1) score += 0.8
                prev = si
                qi++
            }
            si++
        }
        if (qi < q.length) return 0
        return score / (q.length * 2.5)
    }

    function _appScore(entry, q) {
        var s = _fuzzyScore(entry.name        || "", q) * 0.70
              + _fuzzyScore(entry.genericName  || "", q) * 0.15
              + _fuzzyScore(entry.comment      || "", q) * 0.05
        var kws = entry.keywords
        if (kws) {
            if (typeof kws === "string") kws = kws.split(";").filter(Boolean)
            var kmax = 0
            for (var i = 0; i < kws.length; i++) {
                var ks = _fuzzyScore(kws[i], q) * 0.10
                if (ks > kmax) kmax = ks
            }
            s += kmax
        }
        return s
    }

    // ── Filter + sort ──────────────────────────────────────────────────────────
    function _filter() {
        var apps = allApps.slice()
        var result
        if (query.length === 0) {
            apps.sort(function(a, b) {
                var ca = root._usageCounts[a.name] || 0
                var cb = root._usageCounts[b.name] || 0
                if (cb !== ca) return cb - ca
                return (a.name || "") < (b.name || "") ? -1 : 1
            })
            result = apps
        } else {
            var q = query
            var scored = []
            for (var i = 0; i < apps.length; i++) {
                var sc = root._appScore(apps[i], q)
                if (sc > 0) scored.push({ entry: apps[i], score: sc })
            }
            scored.sort(function(a, b) { return b.score - a.score })
            result = scored.map(function(x) { return x.entry })
        }
        filtered    = result
        selectedIdx = 0
    }
    onQueryChanged: _filter()

    // ── Launch ─────────────────────────────────────────────────────────────────
    property var appProc: Process { running: false }

    function _launch(entry) {
        if (!entry) return
        root._bumpUsage(entry.name || "")
        // Prefer parsed command array; fall back to execString
        var cmd = []
        if (entry.command && entry.command.length > 0) {
            for (var i = 0; i < entry.command.length; i++) cmd.push(entry.command[i])
        } else {
            var raw = (entry.execString || "").replace(/ *%[uUfFdDnNickvm]/g, "").trim()
            if (!raw) return
            cmd = ["bash", "-c", raw]
        }
        appProc.command = entry.runInTerminal ? ["kitty", "-e"].concat(cmd) : cmd
        appProc.running = true
        Commons.State.launcherVisible = false
    }

    // ── Reset on open ──────────────────────────────────────────────────────────
    Connections {
        target: Commons.State
        function onLauncherVisibleChanged() {
            if (!Commons.State.launcherVisible) return
            root.query = ""
            searchInput.text = ""
            root._filter()
            searchInput.forceActiveFocus()
        }
    }

    // ── Click-outside-to-close ─────────────────────────────────────────────────
    TapHandler {
        onTapped: point => {
            var x = point.position.x, y = point.position.y
            if (x < panel.x || x > panel.x + panel.width ||
                y < panel.y || y > panel.y + panel.height)
                Commons.State.launcherVisible = false
        }
    }

    // ── Panel ──────────────────────────────────────────────────────────────────
    Rectangle {
        id: panel
        width:  520
        height: col.implicitHeight + Commons.Appearance.spacing.lg * 2
        anchors.centerIn:             parent
        anchors.verticalCenterOffset: -80

        color:        Commons.Appearance.colors.base
        border.color: Commons.Appearance.colors.accentBorder
        border.width: 2
        radius:       Commons.Appearance.radius.lg

        scale:   Commons.State.launcherVisible ? 1.0 : 0.95
        opacity: Commons.State.launcherVisible ? 1.0 : 0.0
        Behavior on scale   { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutQuart } }
        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }

        Column {
            id: col
            anchors {
                top:   parent.top;   topMargin:   Commons.Appearance.spacing.lg
                left:  parent.left;  leftMargin:  Commons.Appearance.spacing.lg
                right: parent.right; rightMargin: Commons.Appearance.spacing.lg
            }
            spacing: Commons.Appearance.spacing.sm

            // ── Search box ─────────────────────────────────────────────────────
            Rectangle {
                width:        parent.width
                height:       38
                color:        Commons.Appearance.colors.surface0Alpha
                border.color: Commons.Appearance.colors.accentBorder
                border.width: 1
                radius:       Commons.Appearance.radius.base

                Text {
                    id: searchGlyph
                    anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                    text:  ""
                    font { family: Commons.Appearance.font.family; pixelSize: 14 }
                    color: Commons.Appearance.colors.overlay1
                }
                TextInput {
                    id: searchInput
                    anchors {
                        left: searchGlyph.right; leftMargin: 6
                        right: parent.right;     rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    color:         Commons.Appearance.colors.text
                    font { family: Commons.Appearance.font.family; pixelSize: Commons.Appearance.font.sizeBase }
                    selectByMouse: true
                    onTextChanged: root.query = text
                    Keys.onUpPressed: {
                        if (root.selectedIdx > 0) root.selectedIdx--
                        resultList.positionViewAtIndex(root.selectedIdx, ListView.Contain)
                    }
                    Keys.onDownPressed: {
                        if (root.selectedIdx < root.filtered.length - 1) root.selectedIdx++
                        resultList.positionViewAtIndex(root.selectedIdx, ListView.Contain)
                    }
                    Keys.onReturnPressed: root._launch(root.filtered[root.selectedIdx])
                    Keys.onEscapePressed: Commons.State.launcherVisible = false
                }
            }

            // ── Result list ────────────────────────────────────────────────────
            ListView {
                id:             resultList
                width:          parent.width
                height:         Math.min(contentHeight, 8 * 40)
                implicitHeight: height
                clip:           true
                model:          root.filtered
                currentIndex:   root.selectedIdx

                // animated sliding highlight bar
                highlightMoveDuration: 120
                highlightMoveVelocity: -1
                highlight: Rectangle {
                    width:  resultList.width
                    height: 40
                    radius: Commons.Appearance.radius.sm
                    color:  Commons.Appearance.colors.accentAlpha
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Item {
                    required property var modelData
                    required property int index
                    width:  ListView.view.width
                    height: 40

                    // ── Icon with fallback chain ───────────────────────────────
                    Item {
                        id: iconWrapper
                        anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                        width: 22; height: 22

                        property int _idx: 0
                        property var _cands: {
                            var n = modelData.icon || "", id = modelData.id || "", c = []
                            if (n) {
                                c.push(n.startsWith("/") ? n : "image://icon/" + n)
                                if (n !== n.toLowerCase()) c.push("image://icon/" + n.toLowerCase())
                            }
                            if (id && id !== n && id !== n.toLowerCase())
                                c.push("image://icon/" + id)
                            return c
                        }

                        Image {
                            id: appIcon
                            anchors.fill: parent
                            source:       iconWrapper._cands[iconWrapper._idx] || ""
                            fillMode:     Image.PreserveAspectFit
                            smooth:       true
                            onStatusChanged: {
                                if (status === Image.Error &&
                                        iconWrapper._idx < iconWrapper._cands.length - 1)
                                    iconWrapper._idx++
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            visible: appIcon.status !== Image.Ready || iconWrapper._cands.length === 0
                            text:  ""
                            font { family: Commons.Appearance.font.family; pixelSize: 16 }
                            color: Commons.Appearance.colors.overlay1
                        }
                    }

                    Text {
                        anchors {
                            left:  iconWrapper.right; leftMargin:  10
                            right: parent.right;      rightMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        text:  modelData.name || ""
                        color: root.selectedIdx === index
                                   ? Commons.Appearance.colors.text
                                   : Commons.Appearance.colors.subtext1
                        font { family: Commons.Appearance.font.family; pixelSize: Commons.Appearance.font.sizeBase }
                        elide: Text.ElideRight
                    }

                    HoverHandler { onHoveredChanged: if (hovered) root.selectedIdx = index }
                    TapHandler   { onTapped: root._launch(modelData) }
                }
            }

            // ── Empty state ────────────────────────────────────────────────────
            Item {
                visible: root.filtered.length === 0
                width:   parent.width
                height:  40
                Text {
                    anchors.centerIn: parent
                    text:  root.allApps.length === 0 ? "Loading…" : "No results"
                    color: Commons.Appearance.colors.overlay1
                    font { family: Commons.Appearance.font.family; pixelSize: Commons.Appearance.font.sizeBase }
                }
            }
        }
    }
}
