#!/bin/bash

mydir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

function symlink
{
    src=$1
    dest=$2
    backup=$3

    if [ -L $dest ]; then
       dest_ref=$(readlink -f $dest)
       if [ "$src" == "$dest_ref" ]; then
          echo "$dest is already symlinked"
          return
       fi
       if [ ! -e $dest ]; then
          echo "Removing broken symlink: $dest"
          rm -f $dest
       fi
    fi
    if [ -e $dest ]; then
       echo "Backing up $dest to $backup"
       mv $dest $backup
    fi
    echo "Linking $src to $dest"
    ln -s $src $dest
}

symlink $mydir/bashrc ~/.bashrc ~/bashrc.orig
symlink $mydir/gitconfig ~/.gitconfig ~/gitconfig.orig
symlink $mydir/emacs ~/.emacs ~/emacs.orig
symlink $mydir/clang-format ~/.clang-format ~/clang-format.orig
symlink $mydir/emacs.d/custom-modes ~/.emacs.d/custom-modes ~/emacs.d/custom-modes.orig

for file in $(find $mydir/config -type f); do
	dest="$HOME/.$(realpath --relative-to=$mydir $file)"
	mkdir -p $(dirname $dest)
	symlink $file $dest "$dest.orig"
done

unset mydir
unset -f symlink

source ~/.bashrc
