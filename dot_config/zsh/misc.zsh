#!/usr/bin/env zsh
# Zsh options (miscellaneous)

# Enable vi-mode keybindings (modal editing)
bindkey -v

# Enable emacs-mode keybindings (more similar to regular typing)
# bindkey -e

# Custom TIMEFMT for 'time' keyword (real/user/sys format)
export TIMEFMT=$'real\t%E\nuser\t%U\nsys\t%S'

# Update terminal title to "user@host: cwd"
case "$TERM" in
  xterm*|rxvt*|screen*|tmux*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a"; }
    ;;
  *)
    ;;
esac
