#!/usr/bin/env bash

# Change working directory to script's dirname
cd "$(dirname "${BASH_SOURCE}")"
CWD="$(pwd -P)"

# Update
echo -e "Updating files to latest version available...\n"

{
  git submodule update --init --recursive &&
    git stash --include-untracked &&
    git pull origin HEAD --recurse-submodules &&
    git stash pop
} &>/dev/null

# Link configuration files to $HOME
function _link_files() {
  echo -e "Creating config dirs in HOME and linking files...\n"

  # Create needed directories if necessary
  mkdir -p $HOME/{.gnupg,.ssh}

  # Find and create links in home to user files
  find -E $PWD \
    -iregex '.*\/\.(bash.*|editorconfig|hushlogin|[^.\/]+rc$)' \
    -or -path '*/.gnupg/*' -or -path '*/.ssh/*' -or -path '*/.vim' \
    -exec ln -sfn "{}" $HOME ";"
}

function _setup_config() {
  echo -e "Creating user configuration files at HOME...\n"

  source ~/.bash_profile

  if [ ! -f $HOME/.user ]; then
    echo "
    #!/usr/bin/env bash

    # Set your configuration files path
    export USER_DOTFILES_DIR=$CWD

    # User configuration

    # Git configuration
    GIT_AUTHOR_NAME=\"\"
    GIT_COMMITTER_NAME=\"\$GIT_AUTHOR_NAME\"
    git config --global user.name \"\$GIT_AUTHOR_NAME\"

    GIT_AUTHOR_EMAIL=\"\"
    GIT_COMMITTER_EMAIL=\"\$GIT_AUTHOR_EMAIL\"
    git config --global user.email \"\$GIT_AUTHOR_EMAIL\"

    GIT_SIGN_KEYID=\"\"
    git config --global commit.gpgsign true
    git config --global user.signingkey \"\$GIT_SIGN_KEYID\"
    " >|$HOME/.user
  fi

  if [ ! -f $HOME/.gitconfig ]; then
    echo "
    [include]
    path = $CWD/.global.gitconfig
    " >|$HOME/.gitconfig
  fi

  if [ ! -f $HOME/.npmrc ]; then
    echo "" >|$HOME/.npmrc
  fi
}

function _install_brew() {
  if [ ! -x "$(command -v brew)" ]; then
    echo -e "Installing brew...\n"
    bash <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)
  fi

  echo -e "Installing bundles...\n"
  brew bundle
}

function _bootstrap() {
  _setup_config && _link_files && _install_brew
  unset CWD _link_files _setup_config _install_brew
}

if [ "$1" == "--quiet" -o "$1" == "-q" ]; then
  _bootstrap
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (Y/n) " -n 1
  echo -e "\n"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    _bootstrap
  fi
fi

unset _bootstrap
