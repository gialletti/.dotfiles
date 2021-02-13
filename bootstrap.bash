#!/usr/bin/env bash

# Change working directory to script's dirname
cd "$(dirname "${BASH_SOURCE}")"
CWD="$(pwd -P)"

# Update
echo -e "Updating files to latest version available...\n"
git pull origin HEAD --autostash --rebase --recurse-submodules &>/dev/null

# Link configuration files to $HOME
function _link_files() {
  echo -e "Linking configuration files to HOME...\n"

  # Find and create links in home to user files
  find -E $CWD \( \
    -iregex "$CWD\/\.bash.*$" -or \
    -iregex "$CWD\/\.[^.\/]+rc$" -or \
    -iregex "$CWD\/\.(editorconfig|hushlogin)$" -or \
    -path "$CWD/.gnupg" -or \
    -path "$CWD/.ssh" \
    \) -exec sh -c 'ln -sfn {} $HOME &>/dev/null || (mv $HOME/$(basename {}) $HOME/$(basename {})_duped && ln -sfn {} $HOME)' \;
}

function _setup_config() {
  echo -e "Creating user configuration files at HOME...\n"

  export USER_DOTFILES_DIR=$CWD
  source ~/.bash_profile

  if [ ! -f $HOME/.user ]; then
    echo "
    #!/usr/bin/env bash

    # Export configuration files path
    export USER_DOTFILES_DIR=$CWD

    # Export user info
    export USER_AUTHOR_NAME=\"\"
    export USER_AUTHOR_EMAIL=\"\"

    # Set git configuration from environment variables
    GIT_COMMITTER_NAME=\"\$USER_AUTHOR_NAME\"
    GIT_COMMITTER_EMAIL=\"\$USER_AUTHOR_EMAIL\"
    GIT_SIGN_KEYID=\"\"
    git config --global user.name \"\$GIT_COMMITTER_NAME\"
    git config --global user.email \"\$GIT_COMMITTER_EMAIL\"
    git config --global commit.gpgsign true
    git config --global user.signingkey \"\$GIT_SIGN_KEYID\"
    " | awk '{$1=$1}!/^$/' >|$HOME/.user
  fi

  # Create user defined git config if doesn't exist
  if [ ! -f $HOME/.gitconfig ]; then
    echo "" >|$HOME/.gitconfig
  fi
}

function _install_brew() {
  if [ ! -x "$(command -v brew)" ]; then
    echo -e "Installing brew...\n"
    bash <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)
  fi

  echo -e "Installing bundles...\n"
  brew bundle

  echo -e "Configuring...\n"

  # Replace macOS bash
  sudo echo /usr/local/bin/bash >>/etc/shells
  chsh -s /usr/local/bin/bash
  # Create bash-completion@2 completions directory
  mkdir -p "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
}

function _bootstrap() {
  _setup_config && _link_files && _install_brew
  unset CWD _link_files _setup_config _install_brew
}

if [ "$1" == "--quiet" -o "$1" == "-q" ]; then _bootstrap; else
  read -p "This may overwrite existing files in your home directory. Are you sure? (Y/n) " -n 1
  echo -e "\n"
  if [[ $REPLY =~ ^[Yy]$ ]]; then _bootstrap; fi
fi

unset _bootstrap
