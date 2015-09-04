#!/usr/bin/env sh

git clone --recursive git://github.com/antoinealb/dotvim.git ~/.vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s ~/.vim/vimrc ~/.vimrc
vim -c ":PluginInstall" -c ":qa"
