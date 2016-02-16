#!/usr/bin/env sh
mv ~/.vim ~/.vim.orig
mv ~/.vimrc ~/.vimrc.orig
cp -rf vim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
echo "config vim ok , please run PluginInstal in vim!"
