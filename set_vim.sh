#!/usr/bin/env bash
mv ~/.vim ~/.vim.orig
mv ~/.vimrc ~/.vimrc.orig
cp -rf vim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
echo "config plugin done"

git clone git@github.com:github/copilot.vim.git \
~/.vim/pack/github/start/copilot.vim

echo "download github copilot done"


