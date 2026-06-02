import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import "../../../../Commons" as Commons

// Wallpaper picker panel — replaces the legacy rofi picker (Super+W → this).
// Lives inside the bottom-strip card alongside Dashboard; PanelRegistry mounts
// this whenever the "wallpaper" strip icon is active.
//
// Top: centered row of 72×72 logo tiles (Off + Arch + Rebel + Imperial). Each
// tile renders the SAME SVG used by wallpaper-set.sh — read via FileView with
// LOGO_COLOR / LOGO_OPACITY substituted in-memory, fed to Image as a data URI.
// Click → wallpaper-set.sh --toggle-logo <id>.
//
// Below: 2-col grid of wallpaper thumbnails. Click → wallpaper-set.sh <path>.
// All apply paths go through wallpaper-set.sh so this UI and the bash keybind
// stay in sync.
Item {
    id: root
    anchors.fill: parent

    property var panelRoot
    property var wallpapers: []
    property string currentPath: ""
    property string currentLogo: ""    // "", "arch", "rebel", "imperial"

    readonly property string _assetsBase:
        Commons.Paths.home + "/Projects/archeotech-dotfiles/scripts/assets"

    // SVG content (data URIs) — filled by the three FileViews below.
    property string _archSvg: ""
    property string _rebelSvg: ""
    property string _imperialSvg: ""

    function _svgFor(id) {
        if (id === "arch")     return root._archSvg
        if (id === "rebel")    return root._rebelSvg
        if (id === "imperial") return root._imperialSvg
        return ""
    }

    // Build a data URI from a raw SVG template with placeholder substitution.
    // Mirrors what wallpaper-set.sh does on disk, but in-memory for previews.
    function _svgDataUri(content) {
        if (!content) return ""
        var sub = content
            .replace(/LOGO_COLOR/g,   "#cad3f5")
            .replace(/LOGO_OPACITY/g, "1.0")
        return "data:image/svg+xml;utf8," + encodeURIComponent(sub)
    }

    readonly property var _logoOptions: [
        { id: "",         label: "Off",      glyph: "󰳤" },
        { id: "arch",     label: "Arch",     glyph: "" },
        { id: "rebel",    label: "Rebel",    glyph: "" },
        { id: "imperial", label: "Imperial", glyph: "" }
    ]

    // ── Static asset readers — reuse the originals from scripts/assets/. ──
    FileView {
        path: root._assetsBase + "/arch-logo.svg"
        preload: true
        printErrors: false
        onTextChanged: root._archSvg = root._svgDataUri(text())
    }
    FileView {
        path: root._assetsBase + "/rebel-logo.svg"
        preload: true
        printErrors: false
        onTextChanged: root._rebelSvg = root._svgDataUri(text())
    }
    FileView {
        path: root._assetsBase + "/imperial-logo.svg"
        preload: true
        printErrors: false
        onTextChanged: root._imperialSvg = root._svgDataUri(text())
    }

    // Strip.qml's Loader only instantiates this Item when the panel opens
    // (active: strip._panelOpen). Do the initial scan immediately.
    Component.onCompleted: _refresh()
    Connections {
        target: root.panelRoot
        ignoreUnknownSignals: true
        function onPanelOpenChanged() {
            if (root.panelRoot && root.panelRoot.panelOpen) root._refresh()
        }
    }

    function _refresh() {
        root.wallpapers = []
        if (!scanProc.running)      scanProc.running = true
        if (!currentReader.running) currentReader.running = true
        if (!logoReader.running)    logoReader.running = true
    }

    // ── Apply functions ───────────────────────────────────────────────────
    // `applying` is true while wallpaper-set.sh is still running. The UI uses
    // it to (a) block re-clicks so a second invocation can't race the first
    // (which was causing the "did it work?" double-click bug), and (b) dim
    // inactive tiles so the user has visible feedback. currentPath / currentLogo
    // are flipped optimistically on click so the active tile updates instantly;
    // the readers reaffirm the value once the script exits.
    readonly property bool applying: applyProc.running || logoProc.running

    function _apply(path) {
        if (applying) return
        root.currentPath = path
        applyProc.command = [Commons.Paths.wallpaperSet, path]
        applyProc.running = true
    }
    function _applyLogo(id) {
        if (applying) return
        // Empty id OR clicking the active chip toggles off (matches
        // wallpaper-set.sh's --toggle-logo semantics).
        var toggleOff = (id === "" || id === root.currentLogo)
        root.currentLogo = toggleOff ? "" : id
        if (toggleOff)
            logoProc.command = [Commons.Paths.wallpaperSet, "--toggle-logo"]
        else
            logoProc.command = [Commons.Paths.wallpaperSet, "--toggle-logo", id]
        logoProc.running = true
        logoRefreshTimer.restart()
    }

    Process { id: applyProc; running: false }
    Process { id: logoProc;  running: false }
    Timer {
        id: logoRefreshTimer
        interval: 250
        onTriggered: { if (!logoReader.running) logoReader.running = true }
    }

    // ── Buf-and-commit scanners (ActiveProjects.qml pattern). ─────────────
    Process {
        id: scanProc
        running: false
        command: ["bash", "-lc",
            "find \"$HOME/Projects/archeotech-dotfiles/wallpapers\" " +
            "-maxdepth 1 -type f -regextype posix-extended " +
            "-iregex '.*\\.(jpe?g|png|webp)$' | sort"]
        property var _buf: []
        onRunningChanged: if (running) _buf = []
        stdout: SplitParser {
            onRead: line => {
                var p = line.trim()
                if (!p) return
                var slash = p.lastIndexOf("/")
                var dot   = p.lastIndexOf(".")
                var stem  = p.substring(slash + 1, dot >= 0 ? dot : p.length)
                var name  = stem.replace(/[_-]/g, " ")
                scanProc._buf = scanProc._buf.concat([{ path: p, name: name }])
            }
        }
        onExited: root.wallpapers = scanProc._buf
    }

    Process {
        id: currentReader
        running: false
        command: ["bash", "-lc",
            "cat \"$HOME/.cache/wallpaper/last-wallpaper\" 2>/dev/null || true"]
        stdout: SplitParser {
            onRead: line => { var t = line.trim(); if (t) root.currentPath = t }
        }
    }

    Process {
        id: logoReader
        running: false
        command: ["bash", "-lc",
            "cat \"$HOME/.cache/wallpaper/logo-active\" 2>/dev/null || true"]
        property string _buf: ""
        onRunningChanged: if (running) _buf = ""
        stdout: SplitParser { onRead: line => { logoReader._buf = line.trim() } }
        onExited: root.currentLogo = logoReader._buf
    }

    // ── UI ────────────────────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Commons.Appearance.spacing.lg
        spacing: Commons.Appearance.spacing.md

        // Combined header — title on the left, logo tiles centered, item
        // count + palette button on the right. Saves a row of vertical space
        // versus a stacked title/logos layout.
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 64

            // Title (left)
            Text {
                id: _title
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "󰸉  Wallpapers"
                color: Commons.Appearance.colors.text
                font.pixelSize: Commons.Appearance.font.sizeLg
                font.family: Commons.Appearance.font.family
                font.weight: Font.Medium
            }

            // Logo tiles (absolutely centered — independent of side widths)
            Row {
                anchors.centerIn: parent
                spacing: 10

                Repeater {
                    model: root._logoOptions
                    delegate: Item {
                        id: logoChip
                        required property var modelData

                        readonly property bool _active:  root.currentLogo === modelData.id
                        property bool _hovered: false
                        readonly property string _svgData: root._svgFor(modelData.id)

                        width: 60; height: 60

                        Rectangle {
                            anchors.fill: parent
                            radius: Commons.Appearance.radius.md
                            color: logoChip._active
                                ? Commons.Appearance.colors.accentAlpha
                                : (logoChip._hovered ? Commons.Appearance.colors.surface0Alpha : "transparent")
                            border.width: logoChip._active ? 2 : 0
                            border.color: Commons.Appearance.colors.accent
                            scale: logoChip._hovered && !logoChip._active ? 1.05 : 1.0
                            Behavior on color       { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                            Behavior on border.width{ NumberAnimation { duration: Commons.Appearance.anim.fast } }
                            Behavior on scale       { NumberAnimation { duration: Commons.Appearance.anim.fast; easing.type: Easing.OutCubic } }

                            Image {
                                anchors.fill: parent
                                anchors.margins: 6
                                source: logoChip._svgData
                                sourceSize.width: 96; sourceSize.height: 96
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                                visible: logoChip._svgData !== ""
                                opacity: logoChip._active ? 1.0 : (logoChip._hovered ? 1.0 : 0.7)
                                Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: logoChip._svgData === ""
                                text: logoChip.modelData.glyph
                                color: logoChip._active
                                    ? Commons.Appearance.colors.accent
                                    : (logoChip._hovered ? Commons.Appearance.colors.subtext1 : Commons.Appearance.colors.overlay0)
                                font.pixelSize: 24
                                font.family: Commons.Appearance.font.family
                            }
                        }

                        // Hover tooltip
                        Rectangle {
                            visible: logoChip._hovered
                            anchors.top: parent.bottom
                            anchors.topMargin: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitWidth: _tipLabel.implicitWidth + 10
                            implicitHeight: _tipLabel.implicitHeight + 4
                            radius: Commons.Appearance.radius.sm
                            color: Commons.Appearance.colors.crust
                            z: 10
                            Text {
                                id: _tipLabel
                                anchors.centerIn: parent
                                text: logoChip.modelData.label
                                color: Commons.Appearance.colors.text
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                            }
                        }

                        opacity: root.applying && !logoChip._active ? 0.45 : 1.0
                        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !root.applying
                            cursorShape: root.applying ? Qt.BusyCursor : Qt.PointingHandCursor
                            onEntered: logoChip._hovered = true
                            onExited:  logoChip._hovered = false
                            onClicked: root._applyLogo(logoChip.modelData.id)
                        }
                    }
                }
            }

            // Right side — items count + palette button
            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    text: root.wallpapers.length + " items"
                    color: Commons.Appearance.colors.subtext0
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    id: paletteBtn
                    width: 28; height: 28
                    radius: 14
                    property bool _hovered: false
                    color: _hovered ? Commons.Appearance.colors.surface0Alpha : "transparent"
                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "󰏘"
                        color: paletteBtn._hovered
                            ? Commons.Appearance.colors.accent
                            : Commons.Appearance.colors.subtext1
                        font.pixelSize: 16
                        font.family: Commons.Appearance.font.family
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: paletteBtn._hovered = true
                        onExited:  paletteBtn._hovered = false
                        onClicked: {
                            Commons.State.settingsOpenPane = "appearance"
                            Commons.State.settingsVisible  = true
                        }
                    }
                }
            }
        }

        // Thin separator between logo row and wallpaper grid
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Commons.Appearance.colors.surface0
            opacity: 0.5
        }

        // ── Wallpaper carousel — single horizontal row, scrolls left/right.
        //    16:10 aspect (matches a typical screen). Vertical scroll-wheel
        //    is translated to horizontal flick via WheelHandler.
        ListView {
            id: grid
            Layout.fillWidth:  true
            Layout.fillHeight: true
            clip: true
            orientation: ListView.Horizontal
            spacing: 12
            model: root.wallpapers
            interactive: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

            // Height-driven sizing — cellH fills the row, cellW = cellH × aspect.
            // 3:2 sits between "very square" (4:3) and "very widescreen" (16:9),
            // so each card reads as a screen preview without dominating the row.
            // Panel height (PanelRegistry: 420) gives ~245 cellH → ~367 cellW,
            // i.e. about 5 cards visible at 1920px screen width.
            readonly property real _aspect: 3 / 2
            readonly property int _cellH: Math.max(140, height - 14)
            readonly property int _cellW: Math.floor(_cellH * _aspect)

            // Vertical scroll-wheel translates to horizontal flick. Wheel
            // events with angleDelta.y < 0 mean "scroll down" → forward in
            // the carousel → contentX should increase → flick with negative
            // horizontal velocity. Sign convention: matches Flickable.flick
            // (positive xVel moves content right, i.e. backwards).
            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: (event) => {
                    var step = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                    grid.flick(step * 6, 0)
                    event.accepted = true
                }
            }

            delegate: Item {
                id: cell
                required property var modelData
                required property int index
                width:  grid._cellW
                height: grid._cellH

                readonly property bool _active:  root.currentPath === modelData.path
                property bool _hovered: false

                scale: cell._hovered && !cell._active && !root.applying ? 1.03 : 1.0
                Behavior on scale { NumberAnimation { duration: Commons.Appearance.anim.fast; easing.type: Easing.OutCubic } }

                opacity: root.applying && !cell._active ? 0.5 : 1.0
                Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                // Rounded image clipped via OpacityMask. The Rectangle
                // overlay above gives us the visible border on hover/active.
                Image {
                    id: cellImg
                    anchors.fill: parent
                    source: cell.modelData ? "file://" + cell.modelData.path : ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    sourceSize.width:  grid._cellW * 2
                    sourceSize.height: grid._cellH * 2
                    visible: false
                }
                Rectangle {
                    id: cellMask
                    anchors.fill: parent
                    radius: 14
                    visible: false
                }
                OpacityMask {
                    anchors.fill: cellImg
                    source: cellImg
                    maskSource: cellMask
                }

                // Border overlay — rounded so it follows the image shape.
                Rectangle {
                    anchors.fill: parent
                    radius: 14
                    color: "transparent"
                    border.width: cell._active ? 2 : (cell._hovered ? 1 : 0)
                    border.color: cell._active
                        ? Commons.Appearance.colors.accent
                        : Commons.Appearance.colors.subtext0
                    Behavior on border.color { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                    Behavior on border.width { NumberAnimation { duration: Commons.Appearance.anim.fast } }
                }

                // Active checkmark
                Rectangle {
                    visible: cell._active
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 8
                    width: 24; height: 24; radius: 12
                    color: Commons.Appearance.colors.accent
                    Text {
                        anchors.centerIn: parent
                        text: "✓"
                        color: Commons.Appearance.colors.base
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: !root.applying
                    cursorShape: root.applying ? Qt.BusyCursor : Qt.PointingHandCursor
                    onEntered: cell._hovered = true
                    onExited:  cell._hovered = false
                    onClicked: root._apply(cell.modelData.path)
                }
            }
        }
    }
}
