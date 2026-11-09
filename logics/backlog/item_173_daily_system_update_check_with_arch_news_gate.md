## item_173_daily_system_update_check_with_arch_news_gate - arch-update: system update check, tray and upgrade flow
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:49:22

# AI Context
- Summary: Sets up arch-update (AUR) as the system tier: tracked config, check timer, tray icon in the bar, kitty on click. A run shows Arch news, upgrades with paru and offers pacnew, service and reboot steps. Replaces the custom check and sysup plan (owner, 2026-11-09).
- Keywords: arch-update, system, update, check, arch, news, tray, paru
- Use when: changing how pacman and AUR updates are checked, announced or applied.
- Skip when: user tools in ~/.local (item_172).

# Problem
- Nothing tells the owner when system updates are pending or when Arch news needs reading before an upgrade, and the safety steps after an upgrade (pacnew, services, reboot) depend on memory.

# Scope
- In:
  - Owner installs arch-update from the AUR (`! paru -S arch-update`, or arch-update-bin to skip the local cargo build of the tray) and xdg-terminal-exec from extra.
  - Tracked config/.config/arch-update/arch-update.conf (stowed): AURHelper=paru, KeepOldPackages=2, NoFlatpak; other options stay at defaults unless the owner asks.
  - Tracked config/.config/xdg-terminals.list naming kitty.desktop, so a tray click opens arch-update in kitty.
  - Check timer: `arch-update --check --enable` (arch-update.timer, at boot then every 6 h). Keep the 6 h default unless the owner asks otherwise.
  - Tray: mango exec_once `sh -c "sleep 3 && arch-update --tray"` in config/.config/mango/config.conf (mango runs no XDG autostart). That file carries the owner's uncommitted recolour lines: stage only this hunk.
  - Owner checks the tray icon in the shell's TrayWidget on the live bar after SUPER+SHIFT+R.
- Out:
  - Applying any update unattended.
  - A custom check or upgrade wrapper (item_174 sysup, dropped).
  - informant (arch-update shows the news before its upgrade prompt).
  - A bar widget reading ~/.local/state/arch-update (later archeotech-shell item).

# Acceptance criteria
- AC2: After `arch-update --check`, ~/.local/state/arch-update/last_updates_check_packages matches checkupdates output and /var/lib/pacman/sync is untouched.
- AC2: The tray icon shows in the bar and switches to updates available when the check finds updates.
- AC3: A run lists Arch news published since the last run before asking to proceed, upgrades AUR packages with paru, and ends with the pacnew, services and kernel reboot prompts; nothing reboots without a yes.
- AC3: After the first run, snapper list shows the snap-pac pre/post pair.
- AC4: A check that finds updates sends one notification whose action opens arch-update in kitty.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: After `arch-update --check`, ~/.local/state/arch-update/last_updates_check_packages matches checkupdates output and /var/lib/pacman/sync is untouched.
- request-AC3 -> This backlog slice. Proof: AC3: A run lists Arch news published since the last run before asking to proceed, upgrades AUR packages with paru, and ends with the pacnew, services and kernel reboot prompts; nothing reboots without a yes.
- request-AC4 -> This backlog slice. Proof: AC4: A check that finds updates sends one notification whose action opens arch-update in kitty.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Primary task(s): `task_082_orchestrate_automatic_updates`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
