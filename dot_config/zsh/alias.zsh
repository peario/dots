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

## Bat and cat
cat () {
  if (( $+commands[bat] )); then
    bat --paging=never "$@"
  else
    /bin/cat "$@"
  fi
}

if (( $+commands[bat] )); then
  # FIX: This breaks cli tools which have -h as actual flag, such as `redis-cli -h` for hostname
  # alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

  export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
fi

# Navigation
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

if (( $+commands[eza] )); then
  extra_opts="--group-directories-first --git --color=always --icons=always"
  alias ls="eza -a $extra_opts"
  alias ll="eza -l $extra_opts"
  alias la="eza -la $extra_opts"
  alias lt="eza -a --tree --git-ignore $extra_opts"
  alias li="eza -la --git-ignore $extra_opts"
fi
