pragma Singleton
import QtQuick

QtObject {
    // ── Catppuccin Macchiato palette ───────────────────────────────────────────
    readonly property QtObject colors: QtObject {
        // Base surfaces
        readonly property color base:     "#24273a"
        readonly property color mantle:   "#1e2030"
        readonly property color crust:    "#181926"
        readonly property color surface0: "#363a4f"
        readonly property color surface1: "#494d64"
        readonly property color surface2: "#5b6078"

        // Text
        readonly property color text:     "#cad3f5"
        readonly property color subtext1: "#b8c0e0"
        readonly property color subtext0: "#a5adcb"
        readonly property color overlay2: "#939ab7"
        readonly property color overlay1: "#8087a2"
        readonly property color overlay0: "#6e738d"

        // Accents
        readonly property color mauve:    "#c6a0f6"
        readonly property color blue:     "#8aadf4"
        readonly property color sapphire: "#7dc4e4"
        readonly property color sky:      "#91d7e3"
        readonly property color teal:     "#8bd5ca"
        readonly property color green:    "#a6da95"
        readonly property color yellow:   "#eed49f"
        readonly property color peach:    "#f5a97f"
        readonly property color maroon:   "#ee99a0"
        readonly property color red:      "#ed8796"
        readonly property color pink:     "#f5bde6"
        readonly property color flamingo: "#f0c6c6"
        readonly property color rosewater:"#f4dbd6"
        readonly property color lavender: "#b7bdf8"

        // Semantic aliases
        readonly property color accent:   mauve
        readonly property color error:    red
        readonly property color warning:  yellow
        readonly property color success:  green
        readonly property color info:     blue

        // Transparent variants (used for glass panels, hover states)
        readonly property color baseAlpha:    Qt.rgba(0x24/255, 0x27/255, 0x3a/255, 0.85)
        readonly property color mantleAlpha:  Qt.rgba(0x1e/255, 0x20/255, 0x30/255, 0.90)
        readonly property color surface0Alpha: Qt.rgba(0x36/255, 0x3a/255, 0x4f/255, 0.60)
        readonly property color accentAlpha:  Qt.rgba(0xc6/255, 0xa0/255, 0xf6/255, 0.15)
    }

    // ── Typography ─────────────────────────────────────────────────────────────
    readonly property QtObject font: QtObject {
        readonly property string family: "FiraCode Nerd Font"
        readonly property int sizeSm:   11
        readonly property int sizeBase: 12
        readonly property int sizeMd:   13
        readonly property int sizeLg:   14
        readonly property int sizeXl:   16
        readonly property int sizeIcon: 16
    }

    // ── Geometry ───────────────────────────────────────────────────────────────
    readonly property QtObject radius: QtObject {
        readonly property int sm:   6
        readonly property int base: 8
        readonly property int md:   10
        readonly property int lg:   14
        readonly property int xl:   18
        readonly property int pill: 999
    }

    readonly property QtObject spacing: QtObject {
        readonly property int xs:  4
        readonly property int sm:  6
        readonly property int base: 8
        readonly property int md:  10
        readonly property int lg:  12
        readonly property int xl:  16
    }

    // ── Bar geometry ───────────────────────────────────────────────────────────
    readonly property QtObject bar: QtObject {
        readonly property int height:      36
        readonly property int marginTop:    6
        readonly property int marginSide:   8
        readonly property int innerPadding: 10
    }

    // ── Animation ─────────────────────────────────────────────────────────────
    readonly property QtObject anim: QtObject {
        readonly property int fast:   100
        readonly property int base:   200
        readonly property int slow:   300
        readonly property int spring: 400
    }
}
