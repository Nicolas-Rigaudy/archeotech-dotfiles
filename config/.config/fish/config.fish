if status is-interactive
    # Commands to run in interactive sessions can go here
	starship init fish | source
	zoxide init fish --cmd cd | source
	thefuck --alias | source
	alias ls "exa -al --icons"
	alias cat "bat"
	fastfetch
end

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
alias cp "/usr/local/bin/advcp -g"
alias mv "/usr/local/bin/advmv -g"

function c
	clear
	fastfetch
end
