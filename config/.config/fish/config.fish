# ================================================================================
# ENVIRONMENT VARIABLES (always loaded, even in non-interactive shells)
# ================================================================================

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# ================================================================================
# INTERACTIVE SHELL CONFIGURATION (only for interactive terminals)
# ================================================================================

if status is-interactive
    # Apply Catppuccin Macchiato theme - Official theme from: https://github.com/catppuccin/fish
	fish_config theme choose "Catppuccin Macchiato"

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
