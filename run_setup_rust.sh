#!/bin/bash

CARGO_DIR="$HOME/.cargo"
CARGO_BINARY="$CARGO_DIR/bin/cargo"
RUSTUP_DIR="$HOME/.rustup"
RUSTUP_BINARY="$CARGO_DIR/bin/rustup"

# To install into "$CARGO_DIR/bin"
RUST_TO_INSTALL=(
	cargo-cov    # source coverage and reporting for rust crates
	cargo-update # update installed binaries
	cargo-size   # prints memory usage of a (rust) binary
	cargo-strip  # reduce the size of rust binaries
	git-delta    # syntax highlighted pager and for diffs, grep and blames
	eza          # a modern alternative to ls
	fd-find      # a fast alternative to find
	fnm          # a node version manager
	just         # a command runner (like make)
	macchina     # system information fetcher (like neofetch)
	ripgrep      # recursively search dirs and subdirs with regex
	silicon      # take screenshots of code
	skim         # alternative to fzf
	viu          # terminal image viewer
)
RUST_TO_INSTALL_LOCKED=(
	ast-grep # structual search and replace
	bat      # a cat clone with syntax highlight
	bottom   # cross-platform graphical process/system monitor
	starship # cross-shell prompt
	zoxide   # a smarter cd command
)

printf "[rust]: starting auto-install via chezmoi\n"

if [ -d "$RUSTUP_DIR" ] && [ -d "$CARGO_DIR" ] && [ -s "$CARGO_DIR/env" ]; then
	printf "[rust]: found both RUSTUP_HOME (%s) and CARGO_HOME (%s), skipping install\n" "$RUSTUP_DIR" "$CARGO_DIR"
elif ! [ -d "$RUSTUP_DIR" ]; then
	prinft "[rust]: RUSTUP_HOME (%s) not found, running installer\n" "$RUSTUP_DIR"
	# install rustup automatically + quiet
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y

	update_rustup
fi

update_rustup() {
	if ! [ -x "$RUSTUP_BINARY" ]; then
		printf "[rust]: %s not found!\n" "$RUSTUP_BINARY"
		exit 1
	fi

	printf "[rust]: updating rustup (%s)\n" "$RUSTUP_BINARY"
	"$RUSTUP_BINARY" self update 1>/dev/null

	printf "[rust]: installing stable toolchain\n"
	"$RUSTUP_BINARY" install stable 1>/dev/null

	printf "[rust]: installing nightly toolchain\n"
	"$RUSTUP_BINARY" install nightly 1>/dev/null

	printf "[rust]: setting default toolchain to stable\n"
	"$RUSTUP_BINARY" default stable 1>/dev/null

	install_binaries
}

install_binaries() {
	if ! [ -d "$CARGO_DIR/bin" ]; then
		printf "[rust]: path to binaries installed via cargo not found!\n"
		printf "[rust]: creating path: %s" "$CARGO_DIR/bin\n"
		mkdir -p "$CARGO_DIR/bin"
	fi

	printf "[rust]: installing binaries via cargo\n"
	to_install=""
	for binary in "${RUST_TO_INSTALL[@]}"; do
		to_install="${to_install:+$to_install } $binary"
	done

	printf "[rust]: installing: %s\n" "$to_install"
	if confirm "[rust]: Proceed?"; then
		"$CARGO_BINARY" install "$to_install"
	else
		printf "[rust]: skipping install\n"
	fi

	printf "[rust]: installing locked binaries via cargo\n"
	to_install_locked=""
	for binary in "${RUST_TO_INSTALL_LOCKED[@]}"; do
		to_install_locked="${to_install_locked:+$to_install_locked } $binary"
	done

	printf "[rust]: installing (with --locked): %s\n" "$to_install"
	if confirm "[rust]: Proceed?"; then
		"$CARGO_BINARY" install --locked "$to_install_locked"
	else
		printf "[rust]: skipping install (with --locked)\n"
	fi
}

#### CONFIRM IF TO PROCEED
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

printf "[rust]: auto-install via chezmoi is done\n\n"
