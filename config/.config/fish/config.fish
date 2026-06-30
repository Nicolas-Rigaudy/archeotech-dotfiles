# ================================================================================
# ENVIRONMENT VARIABLES (always loaded, even in non-interactive shells)
# ================================================================================

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# ================================================================================
# INTERACTIVE SHELL CONFIGURATION (only for interactive terminals)
# ================================================================================

if status is-interactive
    # Fish colors are managed by theme-switch.py (conf.d/fish_frozen_theme.fish),
	# which regenerates them from the active palette. Don't pin a theme here —
	# it would override the active theme's colors on every shell start.

	# Shell integrations
	starship init fish | source
	zoxide init fish --cmd cd | source
	thefuck --alias | source
	atuin init fish --disable-up-arrow | source  # Ctrl+R for search, Up arrow for last command

	# Aliases
	alias ls "exa -al --icons"
	alias cat "bat"
	alias lg "lazygit"
	alias cp "/usr/local/bin/advcp -g"
	alias mv "/usr/local/bin/advmv -g"
	alias fuzzy="fzf --preview='cat {}' | xargs -r code"
	
	# Granted AWS profile switcher - needs to be sourced to export env vars
	alias assume="source /usr/bin/assume.fish"

	# Custom functions
	function c
		clear
		fastfetch
	end

	# Display system info on startup
	fastfetch
end
