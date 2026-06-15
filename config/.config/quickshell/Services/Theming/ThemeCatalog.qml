pragma Singleton
import QtQuick

// Sprint 25 — the curated theme catalogue: family → flavors (→ accents).
// The flavor axis carries the light/dark mode. `variant` is the on-disk
// themes/<variant>/ dir that theme-switch.py applies. Accents (Sprint 25
// Phase 2) name palette colors that have matching per-accent app packages;
// families without them expose an empty accent list.
//
// Adding a theme = add its dir under themes/ + a flavor entry here (and, for
// full app coverage, the kitty .conf / GTK package / VSCode ext — see
// theme-switch.py coverage notes).
QtObject {
    id: root

    // Catppuccin's 14 named accents (matching the catppuccin-gtk per-accent
    // packages + the palette color names).
    readonly property var _catppuccinAccents: [
        "rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach",
        "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender"
    ]

    readonly property var families: [
        {
            id: "catppuccin", label: "Catppuccin",
            accents: _catppuccinAccents,
            flavors: [
                { id: "latte",     label: "Latte",     variant: "archeotech-latte",     mode: "light" },
                { id: "frappe",    label: "Frappé",    variant: "archeotech-frappe",    mode: "dark"  },
                { id: "macchiato", label: "Macchiato", variant: "archeotech-macchiato", mode: "dark"  },
                { id: "mocha",     label: "Mocha",     variant: "archeotech-mocha",     mode: "dark"  }
            ]
        },
        {
            id: "dracula", label: "Dracula", accents: [],
            flavors: [ { id: "dracula", label: "Dracula", variant: "dracula", mode: "dark" } ]
        },
        {
            id: "tokyo-night", label: "Tokyo Night", accents: [],
            flavors: [ { id: "night", label: "Night", variant: "tokyo-night", mode: "dark" } ]
        },
        {
            id: "gruvbox", label: "Gruvbox", accents: [],
            flavors: [ { id: "dark", label: "Dark", variant: "gruvbox", mode: "dark" } ]
        },
        {
            id: "nord", label: "Nord", accents: [],
            flavors: [ { id: "nord", label: "Nord", variant: "nord", mode: "dark" } ]
        },
        {
            id: "monochrome", label: "Monochrome", accents: [],
            flavors: [ { id: "dark", label: "Dark", variant: "monochrome", mode: "dark" } ]
        }
    ]

    function familyById(id) {
        for (var i = 0; i < families.length; i++)
            if (families[i].id === id) return families[i]
        return families[0]
    }

    // All flavors of a family matching a mode ("dark"/"light").
    function flavorsForMode(familyId, mode) {
        var fam = familyById(familyId)
        return fam.flavors.filter(function(f) { return f.mode === mode })
    }

    function hasLight(familyId) { return flavorsForMode(familyId, "light").length > 0 }

    function flavorById(familyId, flavorId) {
        var fam = familyById(familyId)
        for (var i = 0; i < fam.flavors.length; i++)
            if (fam.flavors[i].id === flavorId) return fam.flavors[i]
        return null
    }

    // First flavor of a family for a mode, or the first flavor overall.
    function defaultFlavor(familyId, mode) {
        var list = flavorsForMode(familyId, mode)
        if (list.length > 0) return list[0].id
        return familyById(familyId).flavors[0].id
    }

    function variantFor(familyId, flavorId) {
        var f = flavorById(familyId, flavorId)
        return f ? f.variant : ""
    }

    // Reverse lookups: seed config from the currently-applied theme.variant so
    // first boot doesn't switch themes out from under the user.
    function familyOfVariant(variant) {
        for (var i = 0; i < families.length; i++)
            for (var j = 0; j < families[i].flavors.length; j++)
                if (families[i].flavors[j].variant === variant) return families[i].id
        return "catppuccin"
    }
    function flavorOfVariant(variant) {
        for (var i = 0; i < families.length; i++)
            for (var j = 0; j < families[i].flavors.length; j++)
                if (families[i].flavors[j].variant === variant) return families[i].flavors[j].id
        return "macchiato"
    }
    function modeOfVariant(variant) {
        for (var i = 0; i < families.length; i++)
            for (var j = 0; j < families[i].flavors.length; j++)
                if (families[i].flavors[j].variant === variant) return families[i].flavors[j].mode
        return "dark"
    }
}
