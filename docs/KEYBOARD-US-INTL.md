# US International (AltGr dead keys) — French cheat sheet

Layout on the external Ajazz keyboard: `us(altgr-intl)`, set per keyboard in
Settings → Input (QWERTY intl). Normal keys type plain US QWERTY; **AltGr = the
right Alt key**. Generated from the real keymap (`xkbcli compile-keymap --layout
us --variant altgr-intl`), 2026-10-12.

Two kinds of combos:
- **Direct**: hold AltGr and press the key → the character.
- **Dead key** (marked *then*): press AltGr + the accent key, release, then the
  letter. Press it then Space to get the accent on its own.

## French letters

| Want | Keys | | Want | Keys |
|---|---|---|---|---|
| é | AltGr + e | | É | AltGr + Shift + e |
| è | AltGr + `` ` `` *then* e | | È | AltGr + `` ` `` *then* Shift + e |
| à | AltGr + `` ` `` *then* a | | À | AltGr + `` ` `` *then* Shift + a |
| ù | AltGr + `` ` `` *then* u | | Ù | AltGr + `` ` `` *then* Shift + u |
| ê â î ô û | AltGr + 6 *then* e / a / i / o / u | | Ê … | AltGr + 6 *then* Shift + letter |
| ë ï ü ÿ | AltGr + Shift + ' *then* e / i / u / y | | | |
| ç | AltGr + , | | Ç | AltGr + Shift + , |
| œ | AltGr + k (or x) | | Œ | AltGr + Shift + k |
| æ | AltGr + z | | Æ | AltGr + Shift + z |

Shortcuts that skip the dead key: **ï** = AltGr + j, **ü** = AltGr + y,
**ë** = AltGr + r, **ä** = AltGr + q, **ö** = AltGr + p.

## Punctuation and symbols

| Want | Keys | | Want | Keys |
|---|---|---|---|---|
| « | AltGr + [ | | » | AltGr + ] |
| “ | AltGr + Shift + [ | | ” | AltGr + Shift + ] |
| ‘ | AltGr + 9 | | ’ (apostrophe) | AltGr + 0 |
| € | AltGr + 5 | | £ | AltGr + Shift + 4 |
| ° | AltGr + Shift + ; | | § | AltGr + Shift + s |
| × | AltGr + = | | ÷ | AltGr + Shift + = |
| ± | AltGr + Shift + m | | µ | AltGr + m |
| ¿ | AltGr + / | | ¡ | AltGr + Shift + 1 |
| © | AltGr + c | | ® | AltGr + v |
| ¹ ² ³ | AltGr + 1 / 2 / 3 | | ¬ | AltGr + \ |

## Other dead keys

| Accent | Keys *then* letter | Example |
|---|---|---|
| acute ´ | AltGr + ' | á í ó ú ý (also direct: AltGr + a / i / o / u) |
| tilde ~ | AltGr + Shift + `` ` `` | ã õ ñ (ñ also AltGr + n) |
| cedilla ¸ | AltGr + Shift + 5 | ş ţ |
| caron ˇ | AltGr + Shift + . | š č ž |
| ring ˚ | AltGr + Shift + 0 | å (also AltGr + w) |

Why this layout: mango gives a per-keyboard rule only one layout (`kb_layout:us,fr`
is rejected), so the Ajazz can't Alt+Shift to AZERTY. AltGr dead keys give the
French characters without switching. The built-in keyboard stays AZERTY.
