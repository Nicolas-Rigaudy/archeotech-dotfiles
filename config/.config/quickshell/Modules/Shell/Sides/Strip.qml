import QtQuick
import QtQuick.Shapes
import "../../../Commons" as Commons
import "../../../Services/Shell" as ShellServices

// Edge strip + popup + panel — single component for all three states.
//
//   1. Idle  — thin frame at the screen edge (collapsedSize).
//   2. Hover — popup card grows from the strip's inner edge; icons centered.
//   3. Active — popup expands further into a full panel; the icons stay as a
//      sidebar/tabbar at the strip-attached edge (so the user can switch
//      between e.g. CC and NC), content from PanelRegistry fills the rest.
//
// The card's screen position is invariant: idle and panel modes both grow
// perpendicular to the strip, and the icon column sits at the strip-attached
// edge of the body the whole time — so icons stay glued to the screen edge
// while content emerges into the new space.
Item {
    id: strip

    required property string side
    required property var screen

    // Holder mode (Sprint 21): the resting strip body is hidden and reserves
    // no space — only an invisible edge-width hover zone remains, so the card
    // reveals on hover/shortcut and floats over tiled windows. Card + icons +
    // panel behaviour are otherwise identical to a strip.
    property bool holderMode: false

    // panelRoot interface for content modules (mirrors Panel.qml).
    function close() { ShellServices.ShellState.close(_screenName) }
    readonly property bool panelOpen: _panelOpen

    readonly property string _screenName: screen ? screen.name : ""
    readonly property bool   _horizontal: side === "top" || side === "bottom"
    readonly property var    _icons: ShellServices.ShellConfig.stripIcons(side, _screenName)
    readonly property int    collapsedSize: ShellServices.ShellConfig.sideSize(side, _screenName)
    readonly property int    _expanded:     ShellServices.ShellConfig.sideExpanded(side, _screenName)

    readonly property string _activePanel: ShellServices.ShellState.activePanel(_screenName)
    readonly property bool   _panelOpen:   _activePanel !== "" && _icons.indexOf(_activePanel) !== -1
    readonly property bool   _showCard:    _hov || _panelOpen

    // Panel metadata: built-in panels come from PanelRegistry; an unknown
    // plugin id falls back to a panel-content module (Sprint 21 Chunk 2).
    // Plugin panels carry `contentUrl` (absolute QML) instead of `content`.
    function _metaFor(id) {
        var m = ShellServices.PanelRegistry.panelFor(id)
        if (m) return m
        if (ShellServices.WidgetRegistry.isPlugin(id)) {
            var mod = ShellServices.ModuleRegistry.moduleFor(id)
            if (mod && (mod.canLiveIn || []).indexOf("panel-content") !== -1) {
                var p = mod.panel || {}
                return {
                    contentUrl: ShellServices.ModuleRegistry.entryUrl(id),
                    content:    null,
                    size:       p.size || (mod.defaultSize && mod.defaultSize.width) || 380,
                    axisSize:   p.axisSize !== undefined ? p.axisSize : "auto"
                }
            }
        }
        return null
    }
    readonly property var    _activeMeta:  _panelOpen ? _metaFor(_activePanel) : null
    readonly property int    _panelSize:   _activeMeta ? _activeMeta.size : 0
    readonly property var    _axisSizeRaw: _activeMeta && _activeMeta.axisSize !== undefined
                                           ? _activeMeta.axisSize : "full"
    // Panel content may expose `implicitAxis` (numeric) to drive axisSize:"auto".
    // Either the built-in or the plugin loader holds the live item.
    readonly property var    _contentItem: contentLoader.item || pluginContentLoader.item
    readonly property real   _contentImplicitAxis: (_panelOpen && _contentItem
                                                    && _contentItem.implicitAxis !== undefined)
                                                   ? _contentItem.implicitAxis : 0

    property bool _hov: false
    // Defensive: child MouseAreas can shadow the strip-level MA's hover in Qt 6.
    // OR'ing an explicit icon-hover counter keeps the popup alive even when
    // the strip MA momentarily loses its containsMouse to an icon's MouseArea.
    property int _iconHoverCount: 0
    function _updateHover() {
        if (_stripMA.containsMouse || _iconHoverCount > 0) {
            _leaveTimer.stop()
            strip._hov = true
        } else {
            _leaveTimer.restart()
        }
    }

    // ── Sizing ─────────────────────────────────────────────────────────────────
    readonly property int _iconSize:    36
    readonly property int _iconSpacing: 8
    readonly property int _padLong:     14
    readonly property int _padShort:    4
    readonly property int _iconsLen:    _icons.length * _iconSize
                                      + Math.max(0, _icons.length - 1) * _iconSpacing
    readonly property int _bodyAxis:    Math.max(_expanded, _iconsLen + 2 * _padLong)
    readonly property int _bodyDepth:   _iconSize + 2 * _padShort

    readonly property int _r:  Commons.Appearance.radius.md  // neck arc radius (smaller = popup less tall)
    readonly property int _rb: Commons.Appearance.radius.md
    readonly property int _popupExtra: _bodyDepth + _r

    // Perpendicular expansion target (drives strip Item size + card perpendicular dim).
    readonly property real _perpTarget: _panelOpen ? _panelSize
                                       : _hov      ? _popupExtra
                                       :             0

    // Animated values — bound to targets so they animate on state changes.
    property real _perp: _perpTarget
    Behavior on _perp { NumberAnimation { duration: Commons.Appearance.anim.panel; easing.type: Easing.OutCubic } }

    // Along-strip extent. Floor at the icon cluster width; ceil at the screen
    // axis. axisSize "full" = legacy (entire screen edge), "auto" = follow
    // content's implicitAxis, numeric = exact pixels (still clamped).
    readonly property int _screenAxis: _horizontal ? width : height
    readonly property int _axisFloor:  _bodyAxis + 2 * _r
    readonly property real _axisTarget: !_panelOpen
        ? _axisFloor
        : _axisSizeRaw === "full" ? _screenAxis
        : _axisSizeRaw === "auto" ? Math.min(_screenAxis, Math.max(_axisFloor, _contentImplicitAxis + 2 * _r))
        :                            Math.min(_screenAxis, Math.max(_axisFloor, _axisSizeRaw))
    property real _axis: _axisTarget
    Behavior on _axis { NumberAnimation { duration: Commons.Appearance.anim.panel; easing.type: Easing.OutCubic } }

    // Card position along the strip axis: always centered on the screen.
    // Icons cluster around the card's center via iconArea, so a centered
    // card means icons stay glued to their idle screen position regardless
    // of card width or which icon is active. (An earlier draft anchored the
    // card on the active icon — that pulled the whole card sideways when
    // switching panels, since the icon row clusters and isn't spread out.)
    readonly property real _cardAxis: (_screenAxis - _axis) / 2

    // Perpendicular offset of the card from the screen edge. A strip insets
    // the card by its (visible) collapsed body; a holder has no resting body,
    // so the card sits flush against the screen edge (no gap).
    readonly property real _edgeInset:  holderMode ? 0 : collapsedSize
    // At rest a holder still needs a thin hover-catch even though _perp is 0.
    readonly property real _perpExtent: holderMode ? Math.max(collapsedSize, _perp)
                                                   : (collapsedSize + _perp)

    // Item grows perpendicular to the strip so the popup/panel falls inside
    // ShellSurface's input mask.
    implicitWidth:  _horizontal ? 0 : _perpExtent
    implicitHeight: _horizontal ? _perpExtent : 0

    // Keyboard focus + Esc-to-close when panel is open.
    focus: _panelOpen
    Keys.priority: Keys.BeforeItem
    Keys.onEscapePressed: strip.close()

    // Strip-level hover tracker. Hover-only (clicks pass through). The
    // containsMouseChanged handler funnels into _updateHover() so the popup
    // state is the OR of (strip-MA hover, any-icon hover) — robust to Qt 6's
    // child-MA hover shadowing.
    MouseArea {
        id: _stripMA
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onContainsMouseChanged: strip._updateHover()
    }

    Timer {
        id: _leaveTimer
        interval: 250
        onTriggered: strip._hov = false
    }

    // Called by strip icons via stripRoot — keeps the popup card open
    // when the cursor crosses from the strip body onto an icon (and
    // back), even when child MouseAreas shadow the strip-level hover.
    function _iconHoverEnter() { _iconHoverCount++;                       _updateHover() }
    function _iconHoverExit()  { _iconHoverCount = Math.max(0, _iconHoverCount - 1); _updateHover() }

    // ── Always-visible strip body ─────────────────────────────────────────────
    Rectangle {
        id: stripBody
        z: 1
        visible: !strip.holderMode
        color: Commons.Appearance.colors.glassBgLight

        anchors.left:   (strip._horizontal || strip.side === "left")    ? parent.left   : undefined
        anchors.right:  (strip._horizontal || strip.side === "right")   ? parent.right  : undefined
        anchors.top:    (!strip._horizontal || strip.side === "top")    ? parent.top    : undefined
        anchors.bottom: (!strip._horizontal || strip.side === "bottom") ? parent.bottom : undefined
        width:  strip._horizontal ? undefined : strip.collapsedSize
        height: strip._horizontal ? strip.collapsedSize : undefined
    }

    // ── Card (popup → panel) ───────────────────────────────────────────────────
    Shape {
        id: card

        readonly property real _r:  strip._r
        readonly property real _rb: strip._rb

        // Perpendicular dim follows _perp; along-strip dim follows _axis.
        width:  strip._horizontal ? strip._axis : strip._perp
        height: strip._horizontal ? strip._perp : strip._axis

        // Perpendicular: attach edge sits at the strip body's inner edge.
        // Along-axis: anchored on the active icon's screen center
        // (preserves popup→panel continuity), clamped to screen bounds.
        x: strip.side === "right" ? parent.width  - strip._edgeInset - card.width
         : strip.side === "left"  ? strip._edgeInset
         : strip._cardAxis
        y: strip.side === "bottom" ? parent.height - strip._edgeInset - card.height
         : strip.side === "top"    ? strip._edgeInset
         : strip._cardAxis

        layer.enabled: true
        layer.samples: 8

        transformOrigin: strip.side === "right"  ? Item.Right
                       : strip.side === "left"   ? Item.Left
                       : strip.side === "bottom" ? Item.Bottom : Item.Top

        opacity: strip._showCard ? 1.0 : 0.0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

        readonly property var _p: {
            const W = width, H = height, r = _r, rb = _rb
            if (strip.side === "right")  return [
                Qt.point(W,     0),       Qt.point(W,     H),
                Qt.point(W - r, H - r),   Qt.point(rb,    H - r),
                Qt.point(0,     H - r - rb), Qt.point(0,  r + rb),
                Qt.point(rb,    r),       Qt.point(W - r, r)
            ]
            if (strip.side === "left") return [
                Qt.point(0,     H),       Qt.point(0,     0),
                Qt.point(r,     r),       Qt.point(W - rb, r),
                Qt.point(W,     r + rb),  Qt.point(W,     H - r - rb),
                Qt.point(W - rb, H - r),  Qt.point(r,     H - r)
            ]
            if (strip.side === "top") return [
                Qt.point(0,         0),     Qt.point(W,         0),
                Qt.point(W - r,     r),     Qt.point(W - r,     H - rb),
                Qt.point(W - r - rb, H),    Qt.point(r + rb,    H),
                Qt.point(r,         H - rb), Qt.point(r,        r)
            ]
            return [
                Qt.point(W,         H),     Qt.point(0,         H),
                Qt.point(r,         H - r), Qt.point(r,         rb),
                Qt.point(r + rb,    0),     Qt.point(W - r - rb, 0),
                Qt.point(W - r,     rb),    Qt.point(W - r,     H - r)
            ]
        }

        ShapePath {
            fillColor:   Commons.Appearance.colors.glassBgLight
            strokeWidth: 0
            strokeColor: "transparent"

            startX: card._p[0].x
            startY: card._p[0].y
            PathLine { x: card._p[1].x; y: card._p[1].y }
            PathArc  { x: card._p[2].x; y: card._p[2].y
                       radiusX: card._r;  radiusY: card._r;  direction: PathArc.Counterclockwise }
            PathLine { x: card._p[3].x; y: card._p[3].y }
            PathArc  { x: card._p[4].x; y: card._p[4].y
                       radiusX: card._rb; radiusY: card._rb; direction: PathArc.Clockwise }
            PathLine { x: card._p[5].x; y: card._p[5].y }
            PathArc  { x: card._p[6].x; y: card._p[6].y
                       radiusX: card._rb; radiusY: card._rb; direction: PathArc.Clockwise }
            PathLine { x: card._p[7].x; y: card._p[7].y }
            PathArc  { x: card._p[0].x; y: card._p[0].y
                       radiusX: card._r;  radiusY: card._r;  direction: PathArc.Counterclockwise }
        }

        // ── Content area: active panel content ────────────────────────────────
        // Content area: built-in panels load via `sourceComponent` (a Component
        // from PanelRegistry); plugin panel modules load via `source` (an
        // absolute file:// URL). They're split into two mutually-exclusive
        // Loaders because binding both `source` and `sourceComponent` on one
        // Loader races (Qt treats them as exclusive). `active` gates each.
        Item {
            id: contentArea

            anchors.left:   strip.side === "left"   ? iconArea.right  : parent.left
            anchors.right:  strip.side === "right"  ? iconArea.left   : parent.right
            anchors.top:    strip.side === "top"    ? iconArea.bottom : parent.top
            anchors.bottom: strip.side === "bottom" ? iconArea.top    : parent.bottom
            anchors.leftMargin:   strip.side === "left"   ? 4 : strip._r
            anchors.rightMargin:  strip.side === "right"  ? 4 : strip._r
            anchors.topMargin:    strip.side === "top"    ? 4 : strip._r
            anchors.bottomMargin: strip.side === "bottom" ? 4 : strip._r

            opacity: strip._panelOpen ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

            Loader {
                id: contentLoader
                anchors.fill: parent
                active: strip._panelOpen && !!strip._activeMeta && !strip._activeMeta.contentUrl
                sourceComponent: (strip._activeMeta && !strip._activeMeta.contentUrl) ? strip._activeMeta.content : null
                onLoaded: { if (item && 'panelRoot' in item) item.panelRoot = strip }
            }

            Loader {
                id: pluginContentLoader
                anchors.fill: parent
                active: strip._panelOpen && !!strip._activeMeta && !!strip._activeMeta.contentUrl
                source: (strip._activeMeta && strip._activeMeta.contentUrl) ? strip._activeMeta.contentUrl : ""
                onLoaded: { if (item && 'panelRoot' in item) item.panelRoot = strip }
            }
        }

        // ── Icon area: anchored to the card's strip-attached edge with a r/2
        // margin (so the icon is perpendicular-centered in the small popup
        // and stays at the same screen position when the panel expands).
        // Full extent along the strip; icons cluster around the bodyAxis-wide
        // center so they don't fly apart in panel mode.
        Item {
            id: iconArea

            anchors.left:   strip.side === "right"  ? undefined : parent.left
            anchors.right:  strip.side === "left"   ? undefined : parent.right
            anchors.top:    strip.side === "bottom" ? undefined : parent.top
            anchors.bottom: strip.side === "top"    ? undefined : parent.bottom

            anchors.leftMargin:   strip.side === "left"   ? strip._r / 2 : strip._r
            anchors.rightMargin:  strip.side === "right"  ? strip._r / 2 : strip._r
            anchors.topMargin:    strip.side === "top"    ? strip._r / 2 : strip._r
            anchors.bottomMargin: strip.side === "bottom" ? strip._r / 2 : strip._r

            width:  strip._horizontal ? undefined        : strip._bodyDepth
            height: strip._horizontal ? strip._bodyDepth : undefined

            Repeater {
                model: strip._icons
                delegate: Item {
                    id: iconSlot
                    required property string modelData
                    required property int index

                    // Cluster icons around the bodyAxis-wide center so they
                    // stay put when iconArea grows for the panel.
                    readonly property int  _n:       strip._icons.length
                    readonly property real _axisLen: strip._horizontal ? iconArea.width : iconArea.height
                    readonly property real _cluster: (_axisLen - strip._bodyAxis) / 2
                    readonly property real _center:  _cluster + strip._bodyAxis * (index + 0.5) / Math.max(1, _n)

                    readonly property int _hitLong:  48
                    readonly property int _hitShort: strip._bodyDepth
                    width:  strip._horizontal ? _hitLong  : _hitShort
                    height: strip._horizontal ? _hitShort : _hitLong
                    x: strip._horizontal ? _center - width  / 2 : (iconArea.width  - width)  / 2
                    y: strip._horizontal ? (iconArea.height - height) / 2 : _center - height / 2

                    StripWidgetLoader {
                        anchors.fill: parent
                        widgetId: iconSlot.modelData
                        stripRoot: strip
                    }
                }
            }
        }
    }
}
