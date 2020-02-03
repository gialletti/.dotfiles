#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function link() {
	find -E $PWD \
		-iregex '.*(aliases|bash.*|editorconfig|exports|extra|functions|git.*|hushlogin|path|rc$|vim)' \
		-not -path "*/.vim/*" -not -path "*/.git/*" -not -name ".git" -not -name ".gitmodules" \
		-exec ln -sfn "{}" $HOME ";"
	source ~/.bash_profile
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	link
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		link
	fi
fi

unset link
