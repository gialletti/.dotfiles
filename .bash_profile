#!/usr/bin/env bash

# Load custom user files
for file in $HOME/.{user,profile}; do
  [ -f "$file" ] && [ -r "$file" ] && source "$file"
done
unset file

# Load the shell dotfiles, and then some.
for file in $USER_DOTFILES_DIR/.{aliases,functions,path,bash_prompt,exports,extra,profile}; do
  [ -f "$file" ] && [ -r "$file" ] && source "$file"
done
unset file

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
