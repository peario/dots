#!/bin/bash

HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/opt/homebrew"}
is_brew_installed=$(which brew 1>/dev/null && echo "true" || echo "false")

if "$is_brew_installed"; then
	HOMEBREW_BINARY=${HOMEBREW_BINARY:-"/opt/homebrew/bin/brew"}
fi

main() {
	printf "[homebrew]: starting auto-install via chezmoi\n"

	# If both homebrew path and binary is found
	if [ -d "$HOMEBREW_PREFIX" ] && "$is_brew_installed"; then
		printf "[homebrew]: found HOMEBREW_PREFIX (%s) and brew binary (%s)\n" "$HOMEBREW_PREFIX" "$HOMEBREW_BINARY"
		# don't do anything and just exit the if statements,

		# If homebrew path is not found, but binary is found
	elif ! [ -d "$HOMEBREW_PREFIX" ] && "$is_brew_installed"; then
		printf "[homebrew]: could not find HOMEBREW_PREFIX (%s), but found brew binary (%s) in \$PATH\n" "$HOMEBREW_PREFIX" "$HOMEBREW_BINARY"

		if confirm "[homebrew]: assuming install to be invalid/incomplete, would you like to re-install?"; then
			install_homebrew
		else
			printf "[homebrew]: rejected re-install of brew\n"
			printf "[homebrew]: exiting...\n"
		fi

		# If homebrew path is found, but binary is not found
	elif [ -d "$HOMEBREW_PREFIX" ] && ! "$is_brew_installed"; then
		printf "[homebrew]: found HOMEBREW_PREFFIX (%s), but not brew binary (%s)\n" "$HOMEBREW_PREFIX" "$HOMEBREW_BINARY"

		if confirm "[homebrew]: assuming install to be invalid/incomplete, would you like to re-install?"; then
			install_homebrew
		else
			printf "[homebrew]: rejected re-install of brew\n"
			printf "[homebrew]: exiting...\n"
		fi

		# If homebrew path and binary is not found
	else
		printf "[homebrew]: could not find HOMEBREW_PREFIX (%s) and brew binary (%s)\n" "$HOMEBREW_PREFIX" "$HOMEBREW_BINARY"

		if confirm "[homebrew]: assuming homebrew is not installed, would you like to install?"; then
			install_homebrew
		else
			printf "[homebrew]: rejected install of brew\n"
			printf "[homebrew]: exiting...\n"
		fi
	fi

	printf "[homebrew]: auto-install via chezmoi is done\n\n"
}

install_homebrew() {
	BASH_BINARY=${BASH_BINARY:-"$(which bash)"}
	CURL_BINARY=${CURL_BINARY:-"$(which curl)"}

	printf "[homebrew]: installing homebrew (without prompting user for input\n"
	NONINTERACTIVE=1 "$BASH_BINARY" -c "$("$CURL_BINARY" -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	printf "[homebrew]: homebrew should be installed now, follow instructions on screen if they show"
	printf "[homebrew]: make sure to check any shell files (~/.zshrc, ~/.zshenv, ~/.profile, etc.) if things are in the right place"

	if confirm "[homebrew]: before confirming the following question, please take a look at: https://docs.brew.sh/Brew-Bundle-and-Brewfile\n[homebrew]: would you like to install extensions as well? (mas, vscode, whalebrew)"; then
		if confirm "[homebrew]: install mas? (https://github.com/mas-cli/mas)"; then
			printf "[homebrew]: installing mas"
			"$HOMEBREW_BINARY" install mas
		fi

		if confirm "[homebrew]: note that whalebrew requires docker to be installed!\n[homebrew]: install whalebrew? (https://github.com/whalebrew/whalebrew)"; then
			printf "[homebrew]: installing Docker (cask)"
			"$HOMEBREW_BINARY" install --cask docker

			printf "[homebrew]: installing whalebrew"
			"$HOMEBREW_BINARY" install whalebrew
		fi

		if confirm "[homebrew]: note that Visual Studio Code will allow install of extensions via homebrew for commandline\n[homebrew]: install Visual Studio Code? (https://code.visualstudio.com/"; then
			printf "[homebrew]: installing Visual Studio Code (cask)"
			"$HOMEBREW_BINARY" install --cask visual-studio-code
		fi
	else
		printf "[homebrew]: rejected install of homebrew extensions\n"
	fi
}

confirm() {
	read -r "?$1 [Y/n]: " answer
	if [[ "$answer" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
		echo "true"
	else
		echo "false"
	fi

	# unset answer variable to not mess with future confirms
	unset answer
}

main
