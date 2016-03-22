#!/bin/bash

link() {
    target="$HOME/.$1"
    source="$DOTFILES_PATH/$1"

    if [ -d "$source" ] && [ -L "$target" ]; then
        unlink "$target"
    fi

    ln -vfs "$source" "$target"
}

get_font() {
    target="$HOME/.fonts/$1"
    github=$2

    if [ ! -f "$target" ]; then
        curl -s -o "$target" "$github"
    fi
}

DOTFILES_PATH=`pwd`
IFS=$'\n'

set -v

git submodule init
git submodule update

link aliases
link gitconfig
link gitignore_global
link powerline-shell.py
link tmux.conf
link vim
link vimrc
link zshrc

mkdir -p "$HOME/.fonts"

get_font "Droid Sans Mono for Powerline.otf" "https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf"

set +v

echo ""
echo "Be sure to import these fonts into your operating system:"
for font in $(ls "$HOME/.fonts"); do echo "  - $font"; done

echo ""
echo "Then choose one for your terminal."
