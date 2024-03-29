# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

CONFIG_DIR=$(cd $(dirname $(readlink -f ${BASH_SOURCE[0]})) && pwd)
source $CONFIG_DIR/bash-prompt.sh

PS1='$(cmd_status)\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;37m\]\h\[\033[00m\]: $(parse_git_branch)\[\033[01;34m\]\w\[\033[00m\]\n[\[\033[01;35m\]\t\[\033[00m\]]$ '
PROMPT_COMMAND='echo -ne "\033]0;Terminal: $(parse_git_repo_name) ($(parse_git_branch_name))\007"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $CONFIG_DIR/bash_aliases ]; then
   source $CONFIG_DIR/bash_aliases
fi
if [ -f ~/.bash_aliases ]; then
   source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

. ~/.bash_completion.d/python-argcomplete.sh

### Personal Customization starts here

if [ -d $HOME/bin ]; then
    PATH=$HOME/bin:$PATH; export PATH
fi
if [ -d $HOME/.local/bin ]; then
    PATH=$HOME/.local/bin:$PATH; export PATH
fi

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

PATH=$PATH:$HOME/code/git/git-scripts/bin

export PATH LD_LIBRARY_PATH LIBRARY_PATH

export EDITOR=nvim

export CDPATH=.:$HOME

export CODE_PARENT=$HOME/code/git/fme.git

function choosefme {
    if [ ! -n "$CODE_PARENT" ]; then
       echo "\$CODE_PARENT is not set."
       return 1
    fi
    if [ ! -d $CODE_PARENT ]; then
       echo "$CODE_PARENT is not a directory"
       return 1
    fi

    if [ ! -d $CODE_PARENT/$1 ]; then
       echo "$1 was not found in $CODE_PARENT"
       return 1
    fi

    setfme $CODE_PARENT/$1 && cd $CODE_PARENT/$1
}

function setfme {

    unset CDPATH
    unset CODE_HOME

    if [ ! -z $CODE_ROOT ]; then
	    PATH=${PATH/:$CODE_ROOT\/install/}
    fi

    export CODE_ROOT=$(git -C $1 rev-parse --show-toplevel 2>/dev/null)

    if [ ! -n "$CODE_ROOT" ]; then
        echo "$1 is not in a git respository"
        return 1
    fi

    echo "New CODE_ROOT is $CODE_ROOT"

    CDPATH=.:$HOME:$CODE_ROOT
    alias cd='HOME=$CODE_ROOT cd'

    export CODE_HOME=$CODE_ROOT/install
    export PATH=$PATH:$CODE_HOME
    return 0
}

setfme $PWD 

unset CONFIG_DIR
