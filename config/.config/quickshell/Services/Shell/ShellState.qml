pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root

    property var stateMap: ({})

    function _emptyForScreens(screens) {
        var m = {}
        for (var i = 0; i < screens.length; i++) {
            m[screens[i].name] = { open: "" }
        }
        return m
    }

    function _clone() {
        var copy = {}
        for (var k in stateMap) copy[k] = { open: stateMap[k].open }
        return copy
    }

    function _commit(m) { root.stateMap = m }

    function getState(screenName) {
        return stateMap[screenName] || { open: "" }
    }

    function isOpen(screenName, panel) {
        var s = stateMap[screenName]
        return !!s && s.open === panel
    }

    function anyOpen(screenName) {
        var s = stateMap[screenName]
        return !!s && s.open !== ""
    }

    function activePanel(screenName) {
        var s = stateMap[screenName]
        return s ? s.open : ""
    }

    function open(screenName, panel) {
        var m = _clone()
        if (!m[screenName]) m[screenName] = { open: "" }
        m[screenName].open = panel
        _commit(m)
    }

    function close(screenName) {
        var m = _clone()
        if (!m[screenName]) m[screenName] = { open: "" }
        m[screenName].open = ""
        _commit(m)
    }

    function toggle(screenName, panel) {
        if (isOpen(screenName, panel)) close(screenName)
        else open(screenName, panel)
    }

    function closeAllAcross() {
        var m = _clone()
        for (var k in m) m[k].open = ""
        _commit(m)
    }

    // True if `panel` is open on any screen — used by IPC toggles that want
    // global "is this panel showing somewhere?" semantics.
    function isOpenAnywhere(panel) {
        for (var k in stateMap) if (stateMap[k].open === panel) return true
        return false
    }

    // True if any screen has any panel open — drives the mutual exclusion
    // with the Settings window.
    function anyOpenAnywhere() {
        for (var k in stateMap) if (stateMap[k].open !== "") return true
        return false
    }

    // Open the same panel on all screens (IPC entry point — no per-screen
    // routing yet).
    function openGlobal(panel) {
        var screens = Quickshell.screens
        var m = {}
        for (var i = 0; i < screens.length; i++) m[screens[i].name] = { open: panel }
        _commit(m)
    }

    function toggleGlobal(panel) {
        // If any screen has this panel open, close all; otherwise open all.
        var anyOpen = false
        for (var k in stateMap) if (stateMap[k].open === panel) { anyOpen = true; break }
        if (anyOpen) closeAllAcross()
        else openGlobal(panel)
    }

    property Connections _screensConn: Connections {
        target: Quickshell
        function onScreensChanged() {
            var current = Quickshell.screens
            var existing = root.stateMap
            var next = {}
            for (var i = 0; i < current.length; i++) {
                var name = current[i].name
                next[name] = existing[name] || { open: "" }
            }
            root.stateMap = next
        }
    }

    Component.onCompleted: {
        root.stateMap = _emptyForScreens(Quickshell.screens)
        console.log("[ShellState] initialised for screens:", Quickshell.screens.map(function(s) { return s.name }).join(" "))
    }
}
