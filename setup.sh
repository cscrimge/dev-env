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
          if [ ! -f $dest ]; then
             echo "Removing broken symlink: $dest"
             rm -f $dest
          fi
       fi
    fi
    if [ -e $dest ]; then
       echo "Backing up $dest to $backup"
       mv $dest $backup
    fi
    ln -s $src $dest
}

symlink $mydir/.bashrc ~/.bashrc ~/bashrc.orig
symlink $mydir/.gitconfig ~/.gitconfig ~/gitconfig.orig
symlink $mydir/.emacs ~/.emacs ~/emacs.orig

unset mydir
unset -f symlink

source ~/.bashrc
