#!/usr/bin/env zsh
# shellcheck shell=zsh
#
# CLI tools for initialization

COMPLETIONS_PATH="${ZDOTDIT:-$HOME/.config/zsh}/completions"
EXTRAS_PATH="${ZDOTDIT:-$HOME/.config/zsh}/extras"
INITS_PATH="${ZDOTDIT:-$HOME/.config/zsh}/inits"

# Delta - git diff viewer
if (( $+commands[delta] )); then
  DELTA_COMP="$COMPLETIONS_PATH/delta.zsh"

  if [[ ! -f $DELTA_COMP || $DELTA_COMP(#qN.mh+24) ]]; then
    delta --generate-completion zsh >| "$DELTA_COMP"
  fi

  source "$DELTA_COMP"
fi

# bat - cat clone with syntax highlighting
if (( $+commands[bat] )); then
  BAT_COMP="$COMPLETIONS_PATH/bat.zsh"

  if [[ ! -f $BAT_COMP || $BAT_COMP(#qN.mh+24) ]]; then
    bat --completion zsh >| "$BAT_COMP"
  fi

  # aliases and exports are in `./alias.zsh`

  # FIX: bat completion is broken.
  # source "$BAT_COMP"
fi

# bob - neovim version manager
if (( $+commands[bob] )); then
  BOB_COMP="$COMPLETIONS_PATH/bob.zsh"
  BOB_CONFIG="$HOME/.config/bob/config"

  if [[ ! -f $BOB_COMP || $BOB_COMP(#qN.mh+24) ]]; then
    bob complete zsh >| "$BOB_COMP"
  fi

  for file in "$BOB_CONFIG"/*.{json,toml}; do 
    BOB_CONFIG="$file"

    if [[ -f "$BOB_CONFIG" ]]; then
        export BOB_CONFIG
	break
    fi
  done

  source "$BOB_COMP"
fi

# task - task runner / build tool
if (( $+commands[task] )); then
  TASK_COMP="$COMPLETIONS_PATH/task.zsh"

  if [[ ! -f $TASK_COMP || $TASK_COMP(#qN.mh+24) ]]; then
    task --completion zsh >| "$TASK_COMP"
  fi

  source "$TASK_COMP"
fi

# brew (homebrew) - a package manager
# NOTE: Can't check for `(( $+commands[brew] ))`
#       as `/opt/homebrew/bin` isn't part of `$PATH`.
if [ -x "/opt/homebrew/bin/brew" ]; then
  BREW_EXTRAS="$EXTRAS_PATH/brew.zsh"

  if [[ ! -f $BREW_EXTRAS || $BREW_EXTRAS(#qN.mh+24) ]]; then
    /opt/homebrew/bin/brew shellenv >| "$BREW_EXTRAS"
  fi

  if [[ ":$FPATH:" != *":$(/opt/homebrew/bin/brew --prefix)/share/zsh-completions:"* ]]; then
    fpath+=("$(/opt/homebrew/bin/brew --prefix)/share/zsh-completions")
  fi

  if [[ ":$FPATH:" != *":$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions:"* ]]; then
    fpath+=("$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions")
  fi

  source "$BREW_EXTRAS"
fi

# gh - github offical cli
if (( $+commands[gh] )); then
  GH_COMP="$COMPLETIONS_PATH/gh.zsh"

  if [[ ! -f $GH_COMP || $GH_COMP(#qN.mh+24) ]]; then
    gh completion -s zsh >| "$GH_COMP"
  fi

  source "$GH_COMP"
fi

if (( $+commands[br])) || (( $+commands[broot] )); then
  BR_FUNCTION="$HOME/.config/broot/launcher/bash/br"

  if [[ -f $BR_FUNCTION ]]; then
    source "$BR_FUNCTION"
  fi
fi

# perl5
if (( $+commands[perl] )); then
  PERL5_COMP="$COMPLETIONS_PATH/perl5.zsh"

  if [[ ! -f $PERL5_COMP || $PERL5_COMP(#qN.mh+24) ]]; then
    perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5 >| "$PERL5_COMP"
  fi

  source "$PERL5_COMP"
fi

# Java / Kotlin
JAVA_HOME="${JAVA_HOME:-$HOME/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
if [ -d "$JAVA_HOME" ]; then
  export JAVA_HOME

  ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
  NDK_HOME="$ANDROID_HOME/ndk/$(/bin/ls -1 $ANDROID_HOME/ndk)"

  if [ -d "$ANDROID_HOME" ]; then
    export ANDROID_HOME

    # Only export NDK_HOME if ANDROID_HOME is defined (due to it not being a valid path otherwise)
    [ -d "$NDK_HOME" ] && export NDK_HOME
  fi
fi

# g - go version manager
if ! (( $+commands[g] )) || (( $+commands[g])); then
  zi ice from"gh-r" as"program"
  zi light voidint/g

  # Required for custom go install (via g)
  export GOROOT="$HOME/.g/go"
  export GOPATH="${GOPATH:-$HOME/go}"
  # [ -d "$HOME/.g/bin" ] && path+=("$HOME/.g/bin")
  [ -d "$GOROOT/bin" ] && path+=("$GOROOT/bin")
  [ -d "$GOPATH/bin" ] && path+=("$GOPATH/bin")

  # Tells g from where to install go binaries
  export G_MIRROR="https://golang.google.cn/dl/"

  zsh-defer g self update
fi

# Golang
# NOTE: this is not needed as long as `g` is used.
# if [ -d "$HOME/.go" ] || [ -d "$HOME/go" ] || (( $+commands[go] )); then
#   [ -d "$HOME/.go" ] && export GOROOT=${GOROOT:-$HOME/.go}
#   [ -d "$HOME/go" ] && export GOPATH=${GOPATH:-$HOME/go}
# fi

# Rust
if [ -d "$HOME/.cargo/bin" ]; then
  case ":${PATH}:" in
    *:"$HOME/.cargo/bin":*)
      ;;
    *)
      # Prepending path in case a system-installed rustc needs to be overridden
      export PATH="$HOME/.cargo/bin:$PATH"
      ;;
  esac

  # if [ -x /Users/peario/.cargo/bin/cargo-ndk-env ]; then
  #   CARGO_NDK_ENV="$EXTRAS_PATH/cargo_ndk_env.zsh"
  #
  #   if [[ ! -f $CARGO_NDK_ENV || $CARGO_NDK_ENV(#qN.mh+24) ]]; then
  #     cargo ndk-env >| "$CARGO_NDK_ENV"
  #   fi
  #
  #   source "$CARGO_NDK_ENV"
  # fi
fi

# Nim
[ -d "$HOME/.nimble/bin" ] && path+=("$HOME/.nimble/bin")

# Python
## Installing packages via `pipx` places them here
[ -d "$HOME/.local/bin" ] && path+=("$HOME/.local/bin")

## Poetry
if (( $+commands[poetry] )) && [ "$DISABLE" = false ]; then
  # @see: https://github.com/python-poetry/cleo?tab=readme-ov-file#autocompletion
  POETRY_COMP="$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions/_poetry"

  if [[ ! -f $POETRY_COMP || $POETRY_COMP(#qN.mh+24) ]]; then
    poetry completions zsh >| "$POETRY_COMP"
  fi
fi

## uv (https://github.com/astral-sh/uv)
if (( $+commands[uv] )); then
  UV_COMP="$COMPLETIONS_PATH/uv.zsh"

  if [[ ! -f $UV_COMP || $UV_COMP(#qN.mh+24) ]]; then
    uv generate-shell-completion zsh >| "$UV_COMP"
  fi

  source "$UV_COMP"
fi

# FZF
if (( $+commands[fzf] )); then
  FZF_COMP="$COMPLETIONS_PATH/fzf.zsh"

  if [[ ! -f $FZF_COMP || $FZF_COMP(#qN.mh+24) ]]; then
    fzf --zsh >| "$FZF_COMP"
  fi

  source "$FZF_COMP"
fi

# Direnv
# if (( $+commands[direnv] )) && [ "$DISABLE" = false ]; then
#   DIRENV_HOOK="$EXTRAS_PATH/direnv.zsh"
#
#   if [[ ! -f $DIRENV_HOOK || $DIRENV_HOOK(#qN.mh+24) ]]; then
#     direnv hook zsh >| "$DIRENV_HOOK"
#   fi
#
#   source "$DIRENV_HOOK"
# fi

# For diesel.rs
## MySQL
if [[ -d "/opt/homebrew/opt/mysql-client/lib/pkgconfig" ]]; then
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/mysql-client/lib/pkgconfig"
fi

## PostgreSQL
if [[ -d "/opt/homebrew/opt/libpq/lib/pkgconfig" ]]; then
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libpq/lib/pkgconfig"

  export PQ_LIB_DIR="/opt/homebrew/opt/libpq/lib"

  # NOTE: If you still can't install resolve libpq and ld issue, try reading this:
  # - https://stackoverflow.com/a/70561227
fi

## SQLite3
if [[ -d "/opt/homebrew/opt/sqlite/lib/pkgconfig" ]]; then
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/sqlite/lib/pkgconfig"
fi

# Clang & LLVM
if [[ -d "/opt/homebrew/opt/llvm@19/bin/" ]]; then
  export PATH="/opt/homebrew/opt/llvm@19/bin:$PATH"

  # fd . "$bin_path" -0 | while read -r -d $'\0' file; do
  #   [[ -f "$HOME/.local/bin/$(basename "$file")" ]] && continue
  #   ln -s "$bin_path/$(basename "$file")" "$HOME/.local/bin/$(basename "$file")"
  # done
fi

# FNM - Node.js Version Manager
if (( $+commands[fnm] )); then
  FNM_COMP="$COMPLETIONS_PATH/fnm.zsh"
  FNM_EXTRAS="$EXTRAS_PATH/fnm.zsh"

  FNM_PATH="$HOME/.local/share/fnm"

  if [[ ! -f $FNM_EXTRAS || $FNM_EXTRAS(#qN.mh+24) ]]; then
    fnm env >| "$FNM_EXTRAS"
  fi

  if [[ ! -f $FNM_COMP || $FNM_COMP(#qN.mh+24) ]]; then
    fnm completions --shell zsh >| "$FNM_COMP"
  fi

  # Shorthand test if path exists, if not install FNM to $FNM_PATH
  # The latter part of this command can be used to update FNM.
  [ ! -d "$FNM_PATH" ] && { curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$FNM_PATH" --skip-shell; }

  path+=("$FNM_PATH")

  source "$FNM_EXTRAS"
  source "$FNM_COMP"
fi

if (( $+commands[node] )); then
  export NODE_COMPILE_CACHE="$HOME/.cache/nodejs-compile-cache"
fi

if (( $+commands[pnpm] )); then
  export PNPM_HOME="/Users/peario/Library/pnpm"
  if ! [[ "$PATH" =~ "$PNPM_HOME" ]]; then
    path+=("$PNPM_HOME")
  fi
  # case ":$PATH:" in
  #   *":$PNPM_HOME:"*) ;;
  #   *) export PATH="$PNPM_HOME:$PATH" ;;
  # esac
fi

# Less
if [ -x "/opt/homebrew/bin/lesspipe.sh" ]; then
  export LESSOPEN="|/opt/homebrew/bin/lesspipe.sh %s"
fi

# Bun
if (( $+commands[bun] )); then
  export BUN_INSTALL="$HOME/.bun"

  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
  path+=("$BUN_INSTALL/bin")
fi

# Chezmoi (dotfiles manager)
if (( $+commands[chezmoi] )); then
  CHEZMOI_COMP="$COMPLETIONS_PATH/chezmoi.zsh"

  if [[ ! -f $CHEZMOI_COMP || $CHEZMOI_COMP(#qN.mh+24) ]]; then
    chezmoi completion zsh >| "$CHEZMOI_COMP"
  fi

  source "$CHEZMOI_COMP"
fi

# Deno
if (( $+commands[deno] )); then
  DENO_COMP="$COMPLETIONS_PATH/deno.zsh"

  if [[ ! -f $DENO_COMP || $DENO_COMP(#qN.mh+24) ]]; then
    deno completions zsh >| "$DENO_COMP"
  fi

  source "$DENO_COMP"
fi

# rbenv - ruby version manager
if [[ -x /opt/homebrew/bin/rbenv ]]; then
  RBENV_INIT="$INITS_PATH/rbenv.zsh"

  if [[ ! -f $RBENV_INIT || $RBENV_INIT(#qN.mh+24) ]]; then
    /opt/homebrew/bin/rbenv init - --no-rehash zsh >| "$RBENV_INIT"
  fi

  # if [[ -d "$HOME/.rbenv/shims" ]]; then
  #   unset ruby gem
  #   path+=("$HOME/.rbenv/shims")
  # fi

  source "$RBENV_INIT"
fi

# Lua v5.1 (custom install)
if [[ -d "$HOME/.lua" ]]; then
  export LUA="$HOME/.lua"

  source "$LUA/.profile"
fi

# Added by Toolbox App
if [[ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts/" ]]; then
  path+=("/Users/peario/Library/Application Support/JetBrains/Toolbox/scripts")
fi

# Zellij
# NOTE: Needs to be pretty far down, not below starship.
# zellij is a terminal workspace
if (( $+commands[zellij] )); then
  ZELLIJ_INIT="$INITS_PATH/zellij.zsh"
  ZELLIJ_COMP="$COMPLETIONS_PATH/zellij.zsh"

  if [[ ! -f $ZELLIJ_INIT || $ZELLIJ_INIT(#qN.mh+24) ]]; then
    zellij setup --generate-auto-start zsh >| "$ZELLIJ_INIT"
  fi

  if [[ ! -f $ZELLIJ_COMP || $ZELLIJ_COMP(#qN.mh+24) ]]; then
    zellij setup --generate-completion zsh | sed '/_zellij "$@"/d' >| "$ZELLIJ_COMP"
    # zellij setup --generate-completion zsh >| "$ZELLIJ_COMP"
  fi

  # NOTE: Disable Zellij auto-start
  # source "$ZELLIJ_INIT"
  source "$ZELLIJ_COMP"
fi

# Zoxide - Advanced cd
if (( $+commands[zoxide] )); then
  ZOXIDE_COMP="$COMPLETIONS_PATH/zoxide.zsh"

  if [[ ! -f $ZOXIDE_COMP || $ZOXIDE_COMP(#qN.mh+24) ]]; then
    zoxide init zsh --cmd cd >| "$ZOXIDE_COMP"
  fi

  source "$ZOXIDE_COMP"
fi

# Macchina - a neofetch alternative
if (( $+commands[macchina] )); then
  macchina
fi

# Starship
# NOTE: Needs to be far down (otherwise other tooling interrupts starship)
if (( $+commands[starship] )); then
  STAR_INIT="$INITS_PATH/starship.zsh"
  STAR_COMP="$COMPLETIONS_PATH/starship.zsh"

  if [[ ! -f $STAR_INIT || $STAR_INIT(#qN.mh+24) ]]; then
    starship init zsh >| "$STAR_INIT"
  fi

  if [[ ! -f $STAR_COMP || $STAR_COMP(#qN.mh+24) ]]; then
    starship completions zsh >| "$STAR_COMP"
  fi

  source "$STAR_COMP"
  source "$STAR_INIT"
fi
