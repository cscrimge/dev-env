#!/bin/bash

script_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

source $script_dir/git_parse.sh

##################################################################
function fg
{
    echo -n "$(tput setaf $1)$2$(tput sgr 0)"
}

##################################################################
function leftpad
{
    o=$1
    if [ $1 -lt 10 ]; then
       o="00$1"
    elif [ $1 -lt 100 ]; then
       o="0$1"
    fi
    echo -n $o
}

##################################################################
function colortab {
    echo "tput setaf/setab - Colour table"
    f=0
    for (( b=0; b<16 ; b++ ));do
        if [ $(($b % 8)) -eq 0 ]; then
           echo -e "";
        fi
        fg $b " $(leftpad $b) "
    done
    echo -e "";
    for (( b=16; b<256 ; b++ ));do
        if [ $((($b-16) % 12)) -eq 0 ]; then
           echo -e "";
        fi
        fg $b " $(leftpad $b) "
    done
    echo -e "";
}

##################################################################
function get_time
{
    fg 14 $(date +%H:%M:%S)
}


##################################################################
function get_prompt
{
    # Common elements
    local user="\u"
    local host="\h"
    local path="\w"
    local time="\t"

    # Set up colours:
    user=$(fg 10 $user)
    host=$(fg 13 $host)
    path=$(fg 12 $path)
    time=$(fg 14 $time)

    echo "${user}@${host}: "'$(parse_git_branch)'" $path\n[$time]$ "
}
