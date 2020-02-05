#!/usr/bin/env bash

# Change working directory to script's dirname
cd "$(dirname "${BASH_SOURCE}")"

# Update
{
  git submodule update --init --recursive &&
    git stash --include-untracked &&
    git pull origin master --recurse-submodules &&
    git stash pop
} &>/dev/null

# Link configuration files to $HOME
function _link_files() {
  # Create needed directories if necessary
  mkdir -p $HOME/{.gnupg,.ssh}

  # Find and create links in home to user files
  find -E $PWD \
    -iregex '.*/.(bash.*|editorconfig|hushlogin|[^.]+rc$|vim)' \
    -exec ln -sfn "{}" $HOME ";"
}

function _setup_config() {
  source ~/.bash_profile

  if [ ! -f $HOME/.user ]; then
    echo "
    #!/usr/bin/env bash

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
    path = $USER_DOTFILES_DIR/.global.gitconfig
    " >|$HOME/.gitconfig
  fi

  if [ ! -f $HOME/.npmrc ]; then
    echo "" >|$HOME/.npmrc
  fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  _link_files && _setup_config
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (Y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    _link_files && _setup_config
  fi
fi

unset _link_files
unset _setup_config
