#!/bin/bash

is_neovim_installed=$(which nvim 1>/dev/null && echo "true" || echo "false")
is_brew_installed=$(which brew 1>/dev/null && echo "true" || echo "false")

if "$is_neovim_installed"; then
	NEOVIM_BINARY=${NEOVIM_BINARY:-"$(which nvim)"}
fi

if "$is_brew_installed"; then
	HOMEBREW_BINARY=${HOMEBREW_BINARY:-"/opt/homebrew/bin/brew"}
fi

# 1. check if neovim is installed
# 2. if not installed, prompt if it should be installed
# 3. if installed (or after install) run the update procedure for:
#   3.1 Lazy
#   3.2 Mason
#   3.3 TreeSitter
main() {
	printf "[neovim]: starting auto-install via chezmoi\n"

	if ! "$is_neovim_installed"; then
		if confirm "[neovim]: binary not found, do you wish to install?"; then
			if "$is_brew_installed"; then
				printf "[neovim]: attempting to install neovim (via homebrew)\n"
				"$HOMEBREW_BINARY" install neovim
			else
				printf "[neovim] homebrew not found and is required for this installation, try again later\n"
			fi
		fi
	else
		printf "[neovim]: found binary (%s)\n" "$NEOVIM_BINARY"
	fi

	printf "[neovim]: if you have yet to install/update, this process might hang when installing packages like \`tinymist\`\n"
	if confirm "[neovim]: would you like to run updates? (lazy, mason, treesitter)"; then
		printf "[neovim]: updating plugins via lazy\n"
		nvim --headless +'Lazy sync' +'q!'

		printf "[neovim]: updating tools via mason (async)\n"
		nvim --headless +'MasonToolsInstall' +'MasonToolsUpdate' +'q!'

		printf "[neovim]: updating parsers via treesitter (async)\n"
		nvim --headless +'TSUpdate' +'q!'
	else
		printf "[neovim]: skipping updates\n"
	fi

	printf "[neovim]: auto-install via chezmoi is done\n\n"
}

confirm() {
	# print prompt
	#   `-n 1` is maximum number of chars to grab
	read -p "$1 [Y/n]: " -n 1 -r
	echo

	# If return 0 = success, no error, true
	# any other number = failure, error, false
	if [[ "$REPLY" =~ ^[Yy]|[Yy][Ee][Ss]$ ]]; then
		# yes
		return 0
	else
		# no
		return 1
	fi
}

main
