## adr_024_two_repo_split_public_archeotech_shell_vs_private_archeotech_dotfiles - Two-repo split: public archeotech-shell vs private archeotech-dotfiles
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Heading to distribution requires a clean public product repo with no leaked personal paths or Claude artifacts.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Split the monorepo into a public named-Quickshell-config shell repo (fresh history) and a private dotfiles repo (full history).

# Context
- Follows the Caelestia/Noctalia model; public repo root is a named Quickshell config run via qs -c archeotech.
- A fresh-start public history means zero risk of leaking personal paths/secrets from monorepo history.
- The move surfaced that ShellConfig and ModuleRegistry hardcoded default-config paths that don't exist under qs -c archeotech, so the shell silently ran on _defaults.

# Decision
- Public repo installs via its own install.sh (symlinks repo->~/.config/quickshell/archeotech, themes/scripts to ~/.config/archeotech and ~/.local/bin); private repo keeps stow.
- Public commits authored as the user with no Claude artifacts (.claude/ gitignored, no co-author trailers); the user pushes, never the assistant.
- shell-config.json moves to ~/.config/archeotech/ (per-user, writable) with a repo default copied by install.sh if absent; ModuleRegistry resolves its bundled dir via Qt.resolvedUrl.

# Consequences
- kitty theme confs became theme assets (themes/<variant>/kitty.conf); runtime wallpapers dir stays a symlink to the personal set while install.sh seeds only 2 non-IP defaults.
- Single authoritative launcher (exec-once), autostart.sh line disabled, since Quickshell does not dedupe per config.
- A cross-repo runtime coupling remains (e.g. private battery-alert.service ExecStarts the now-public script) — accepted on this machine.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
