#!/bin/bash

GOPATH=${GOPATH:-$HOME/go}
GOROOT=${GOROOT:-$HOME/.go}

# To install into "$GO_PATH/bin"
GOLANG_TO_INSTALL=(
	air
	cobra-cli
	fzf
	gdu
	gotypist
	lazygit
	lazydocker
	tomlv
	wails
)

is_g_manager_installed=$([ -x "$GOPATH/bin/g" ] && echo "true" || echo "false")
is_golang_installed=$(which go 1>/dev/null && echo "true" || echo "false")

if "$is_g_manager_installed"; then
	G_MANAGER=${G_MANAGER:-$(which "$GOPATH/bin/g")}
fi

if "$is_golang_installed"; then
	GO_BINARY=${GO_BINARY:-$(which go)}
fi

main() {
	printf "[go]: starting auto-install via chezmoi\n"

	if [ -d "$GOPATH" ] && [ -d "$GOROOT" ] && "$is_golang_installed"; then
		printf "[go]: found GOPATH (%s), GOROOT (%s) and go binary (%s)\n" "$GOPATH" "$GOROOT" "$GO_BINARY"

		if ! "$is_g_manager_installed"; then
			printf "[go]: g manager was not found (url: https://github.com/stefanmaric/g)\n"
			if confirm "[go]: do you wish to install g manager (go version manager)?"; then
				install_g_manager
			else
				printf "[go]: rejected install of g manager\n"
				printf "[go]: exiting...\n"
				exit 0
			fi
		fi
	elif [ -d "$GOPATH" ] && [ -d "$GOROOT" ] && ! "$is_golang_installed"; then
		printf "[go]: found GOPATH (%s) and GOROOT (%s)\n" "$GOPATH" "$GOROOT"
		printf "[go]: no go binary found in \$PATH!\n"

		if ! "$is_g_manager_installed"; then
			printf "[go]: g manager was not found (url: https://github.com/stefanmaric/g)\n"
			if confirm "[go]: do you wish to install g manager (go version manager)?"; then
				install_g_manager
			else
				printf "[go]: rejected install of g manager, go cannot be installed (via this script)\n"
				printf "[go]: exiting...\n"
			fi
		fi
	fi

	printf "[go]: auto-install via chezmoi is done\n\n"
}

install_g_manager() {
	printf "[go]: making sure directories for GOPATH (%s) and GOROOT (%s) exists\n" "$GOPATH" "$GOROOT"
	mkdir -p "$GOPATH" "$GOROOT"

	printf "[go]: installing g manager to manage go versions\n"
	CURL_BINARY=${curl_exe:-$(which curl)}

	"$CURL_BINARY" -sSL https://git.io/g-install | sh -s -- -y
	printf "[go]: g manager is now installed (at %s)\n" "$GOPATH/bin/g"

	setup_g_manager
}

setup_g_manager() {
	printf "[go]: updating g manager (%s) to latest version\n" "$G_MANAGER"
	"$G_MANAGER" self-upgrade 1>/dev/null

	latest_version_go="$(G_MANAGER list-all | awk '/./ {print $NF}' | tail -n 1)"
	printf "[go]: install latest version of go (%s)\n" "$latest_version_go"
	"$G_MANAGER" install latest 1>/dev/null

	install_binaries
}

install_binaries() {
	printf "[go]: installing binaries via 'go install'\n"
	to_install=""
	for binary in "${GOLANG_TO_INSTALL[@]}"; do
		# If a @ exists in the binary name, it's most likely a version tag.
		# As such we want to leave it as is.
		if [[ $binary == *"@"* ]]; then
			to_install="${to_install:+$to_install } $binary"
			# If the binary does not contain a version tag, then add "@latest"
		else
			to_install="${to_install:+$to_install } $binary@latest"
		fi
	done

	printf "[go]: installing: %s\n" "$to_install"
	if confirm "[go]: Proceed?"; then
		"$GO_BINARY" install "$to_install"
	else
		printf "[go]: skipping install\n"
	fi
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
