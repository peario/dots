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
