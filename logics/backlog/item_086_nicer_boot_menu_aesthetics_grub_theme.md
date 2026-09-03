## item_086_nicer_boot_menu_aesthetics_grub_theme - Nicer boot menu aesthetics GRUB theme
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 55
> Confidence: 55
> Progress: 0
> Complexity: Medium
> Theme: Boot
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: A polished GRUB boot-menu theme that matches the shell identity, staying on GRUB + grub-btrfs + snapper (adr_002). Candidate from ANALYSIS.md §20.5 (user liked IO-ZetZor/Visor-BootManager's look; kept as an aesthetic reference, NOT a bootloader swap).
- Keywords: boot, grub, theme, aesthetics, first-impression, polish
- Use when: authoring/deploying a GRUB theme; polishing the boot experience.
- Skip when: replacing the bootloader (Visor/systemd-boot) — out of scope per adr_002.

# Problem
- The current GRUB menu is plain and breaks the otherwise-cohesive visual identity at the very first screen the user sees. A themed menu improves first impression with zero bootloader risk.

# Scope
- In:
  - A custom GRUB theme (fonts/colours/layout matching the shell aesthetic — e.g. HUD/console identity), deployed via install.sh; must preserve grub-btrfs snapshot submenus.
- Out:
  - Switching bootloader (Visor-BootManager / systemd-boot) — reference only; we stay GRUB (adr_002).

# Acceptance criteria
- AC1: A themed GRUB menu matching the shell aesthetic deploys via install.sh and preserves grub-btrfs snapshot entries.

# AC Traceability
- request-AC5 -> This backlog slice. Proof: a boot-menu polish slice extending shell aesthetic cohesion to the boot screen (req_000 AC5 polish/aesthetics).

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
