#!/usr/bin/zsh
# shellcheck shell=zsh
#
# Aliases go here

# Development tools
## Lazygit
if (( $+commands[lazygit] )); then
  alias lg="lazygit"
fi

## Git
if (( $+commands[git] )); then
  alias ga="git add"
  alias gs="git status"
fi

## PIP3 as PIP
if (( $+commands[pip3] )); then
  if ! (( $+commands[pip] )); then
    alias pip=pip3
  fi
fi

## Bat and cat
cat () {
  if (( $+commands[bat] )); then
    bat --paging=never "$@"
  else
    /bin/cat "$@"
  fi
}

if (( $+commands[bat] )); then
  # WARN: This breaks cli tools which have -h as actual flag, such as `redis-cli -h` for hostname
  # alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

  export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
fi

# Navigation
if (( $+commands[eza] )); then
  extra_opts="--group-directories-first --git --color=always --icons=always"
  alias ls="eza -a $extra_opts"
  alias ll="eza -l $extra_opts"
  alias la="eza -la $extra_opts"
  alias lt="eza -a --tree --git-ignore $extra_opts"
  alias li="eza -la --git-ignore $extra_opts"
fi

if (( $+commands[z] || $+commands[zoxide] )) && (( $+commands[lacy] )); then
  z_br() {
    if [[ $# -eq 0 ]]; then
      cd
    else
      __zoxide_z "$@"
    fi
  }

  unset cd
  alias cd=z_br
else
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias .....="cd ../../../.."
fi

# Make apps installed via Winget on windows more easily accessible
if (which winget.exe && echo true || echo false)>/dev/null; then
  alias winget="$(which winget.exe)"
fi

## Use fzf installed via winget
if (which fzf.exe && echo true || echo false)>/dev/null; then
  alias fzf="$(which fzf.exe)"
fi

# Easier checking of PATH
gpath () {
    # NOTE: Don't add "-i" (interactive) to sk (skim) as it will cause the entire line of code below to fail.
    echo "$PATH" | tr ":" "\n" | uniq | sort | sk --ansi -c "rg --color=always {}"
}
