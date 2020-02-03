#!/usr/bin/env bash

# Change working directory to script's dirname
cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function overrideLinks() {
    find -E $PWD \
        -iregex '.*(aliases|bash.*|bin|editorconfig|exports|extra|functions|global.*|hushlogin|path|rc$|vim)' \
        -not -path "*/.vim/*" -not -path "*/.git/*" -not -name ".git" -not -name ".gitmodules" \
        -exec ln -sfn "{}" $HOME ";"
}

function userConfig() {
    echo '
    #!/usr/bin/env bash

    # User configuration

    # Git configuration
    GIT_AUTHOR_NAME=""
    GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
    git config --global user.name "$GIT_AUTHOR_NAME"
    GIT_AUTHOR_EMAIL=""
    GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
    git config --global user.email "$GIT_AUTHOR_EMAIL"
    GIT_SIGN_KEYID=""
    git config --global commit.gpgsign true
    git config --global user.signingkey "$GIT_SIGN_KEYID"
    ' >|$HOME/.user

    echo '
    [include]
    path = $HOME/.config/.global.gitconfig
    ' >|$HOME/.gitconfig

    echo '' >|$HOME/.npmrc

    source ~/.bash_profile
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    overrideLinks && userConfig
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (Y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        overrideLinks && userConfig
    fi
fi

unset overrideLinks
unset userConfig
