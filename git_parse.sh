#!/bin/bash

##################################################################
function fg
{
    echo -en "$(tput setaf $1)$2$(tput sgr 0)"
}

##################################################################
# get current branch in git repo
function parse_git_branch() {
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ ! "${branch}" == "" ]
    then
       branch=$(fg 120 "${branch}")

       local prefix=$(fg 136 "(")
       local suffix=$(fg 136 ")")

       stat="${branch}$(fg 136 "|")$(parse_git_status)"

       echo "${prefix}${stat}${suffix}"
       echo -n " "
    else
        echo -n ""
    fi
}

##################################################################
# get current status of git repo
function parse_git_status {

    local modified=0
    local staged=0
    local added=0
    local renamed=0
    local deleted=0
    local conflicted=0
    local untracked=0
    local ahead=0
    local behind=0

    local status=$(git status --porcelain -b 2>/dev/null)
    IFS=$'\n'
    for line in ${status}; do
        local st=${line:0:2}
        local line=${line:3}

        case $st in
            "##")
                ahead=$(echo $line | grep -oP "ahead \d+" | grep -oP "\d+")
                behind=$(echo $line | grep -oP "behind \d+" | grep -oP "\d+")

                if [ -z "$ahead" ]; then
                   ahead=0
                fi
                if [ -z "$behind" ]; then
                   behind=0
                fi
                ;;
            "AM")
                ((modified++))
                ((added++))
                ;;
            "MM")
                ((modified++))
                ((staged++))
                ;;
            "UU"|"DD"|"AU"|"UD"|"UA"|"DU"|"AA")
                ((conflicted++))
                ;;
            " M")
                ((modified++))
                ;;
            "M ")
                ((staged++))
                ;;
            "A ")
                ((added++))
                ;;
            "R ")
                ((renamed++))
                ;;
            " D")
                ((deleted++))
                ;;
            "D ")
                ((deleted++))
                ;;
            "??")
                ((untracked++))
                ;;
        esac
    done
    unset IFS

    local dirty_bits=""

    if [ ${modified} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 207 "≢ ${modified}")
    fi
    if [ ${staged} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 39 "● ${staged}")
    fi
    if [ ${added} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 76 "✚ ${added}")
    fi
    if [ ${renamed} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 215 "→ ${renamed}")
    fi
    if [ ${deleted} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 160 "— ${deleted}")
    fi
    if [ ${conflicted} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 9 "✗ ${conflicted}")
    fi
    if [ ${untracked} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 226 "⁇ ${untracked}")
    fi
    if [ ${ahead} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 51 "↑ ${ahead}")
    fi
    if [ ${behind} -gt 0 ]; then
       dirty_bits=${dirty_bits}$(fg 200 "↓ ${behind}")
    fi

    if [ -z "${dirty_bits}" ]; then
       dirty_bits=$(fg 46 "✔")
    fi

    echo $dirty_bits
}
