#!/bin/bash

CARGO_DIR="$HOME/.cargo"
CARGO_BINARY="$CARGO_DIR/bin/cargo"
RUSTUP_DIR="$HOME/.rustup"
RUSTUP_BINARY="$CARGO_DIR/bin/rustup"

# To install into "$CARGO_DIR/bin"
RUST_TO_INSTALL=(
	cargo-binutils # Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain
	cargo-update   # update installed binaries
	git-delta      # syntax highlighted pager and for diffs, grep and blames
	eza            # a modern alternative to ls
	fd-find        # a fast alternative to find
	fnm            # a node version manager
	just           # a command runner (like make)
	macchina       # system information fetcher (like neofetch)
	ripgrep        # recursively search dirs and subdirs with regex
	silicon        # take screenshots of code
	skim           # alternative to fzf
	viu            # terminal image viewer
)
RUST_TO_INSTALL_LOCKED=(
	ast-grep # structual search and replace
	bat      # a cat clone with syntax highlight
	bottom   # cross-platform graphical process/system monitor
	starship # cross-shell prompt
	zoxide   # a smarter cd command
)

main() {
	printf "[rust]: starting auto-install via chezmoi\n"

	if [ -d "$RUSTUP_DIR" ] && [ -d "$CARGO_DIR" ] && [ -s "$CARGO_DIR/env" ]; then
		printf "[rust]: found both RUSTUP_HOME (%s) and CARGO_HOME (%s), skipping install\n" "$RUSTUP_DIR" "$CARGO_DIR"
	elif ! [ -d "$RUSTUP_DIR" ]; then
		printf "[rust]: RUSTUP_HOME (%s) not found, running installer\n" "$RUSTUP_DIR"
		# install rustup automatically + quiet
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y
	fi

	# regardless of if just installed or installed from earlier, run updates and installs
	update_rustup

	printf "[rust]: auto-install via chezmoi is done\n\n"
}

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

	printf "[rust]: installing binaries via:\n"
	printf "[rust]:   > "
	printf "%q " "$CARGO_BINARY" install "${RUST_TO_INSTALL[@]}"
	echo
	if confirm "[rust]: proceed?"; then
		"$CARGO_BINARY" install "${RUST_TO_INSTALL[@]}"
	else
		printf "[rust]: skipping install\n"
	fi

	printf "[rust]: installing binaries via (with --locked):\n"
	printf "[rust]:   > "
	printf "%q " "$CARGO_BINARY" install --locked "${RUST_TO_INSTALL_LOCKED[@]}"
	echo
	if confirm "[rust]: proceed?"; then
		"$CARGO_BINARY" install --locked "${RUST_TO_INSTALL_LOCKED[@]}"
	else
		printf "[rust]: skipping install (with --locked)\n"
	fi
}

confirm() {
	# print prompt
	#   $(-n 1) is maximum number of chars to grab
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
