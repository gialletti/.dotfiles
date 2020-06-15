#!/usr/bin/env bash

# Load custom user files
for file in $HOME/.{user,profile}; do
  [ -f "$file" ] && [ -r "$file" ] && source "$file"
done
unset file

# Load the shell dotfiles, and then some.
for file in $USER_DOTFILES_DIR/.{aliases,path,bash_prompt,exports,functions,extra,profile,user}; do
  [ -f "$file" ] && [ -r "$file" ] && source "$file"
done
unset file

# Activate shell options
for option in ignoreeof noclobber; do
  set -o "$option" 2>/dev/null
done
unset option

# Enable some optional shell features when possible
for option in autocd cdspell extglob globstar histappend nocaseglob progcomp; do
  shopt -s "$option" 2>/dev/null
done
unset option

# Add tab completion for many Bash commands
if [ -d /usr/local/etc/bash_completion.d ]; then
  BASH_COMPLETION=/usr/local/etc/bash_completion
  BASH_COMPLETION_DIR=/usr/local/etc/bash_completion.d
  BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
  BASH_COMPLETION_COMPAT_SOURCE=/usr/local/etc/profile.d/bash_completion.sh
elif [ -d /etc/bash_completion.d ]; then
  BASH_COMPLETION=/etc/bash_completion
  BASH_COMPLETION_DIR=/etc/bash_completion.d
  BASH_COMPLETION_COMPAT_DIR=/etc/bash_completion.d
  BASH_COMPLETION_COMPAT_SOURCE=/etc/profile.d/bash_completion.sh
fi

if [ ! -z $BASH_COMPLETION_DIR ]; then
  [ -r $BASH_COMPLETION ] && source $BASH_COMPLETION
  [ -r $BASH_COMPLETION_COMPAT_SOURCE ] && source $BASH_COMPLETION_COMPAT_SOURCE
fi
