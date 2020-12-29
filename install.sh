#!/bin/sh
set -e

echo 'set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/config.vim' > ~/.vimrc

echo "Installed the Vim configuration successfully! Enjoy :-)"
