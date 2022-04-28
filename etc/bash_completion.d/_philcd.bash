#!/bin/bash

bash_source=${BASH_SOURCE[0]}
# echo "bash_source=${bash_source}"
source_dirname=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
# echo "source_dirname=${source_dirname}"
__philcd_base=$(cd $(dirname $(readlink -f ${BASH_SOURCE[0]}))/../.. && pwd)
# echo "__philcd_base=${__philcd_base}"

function cd(){
    if [[ "$1" == :/* ]] ; then
        local root
        if ! root=$(git rev-parse --show-toplevel 2>/dev/null) ; then
            printf "PHIL: cd ERROR ':/' used outside a git repo\n"
            return 1
        fi
        command cd ${root}/${1##:/}
        return
    fi

    command cd $1
}

function _orig_cd(){
    _cd "$@"
    echo "after normal _cd, COMPREPLY=${COMPREPLY[@]}" >> ~/.log.txt
}


function _phil_cd(){
    compopt -o filenames
    local cur prev words cword
    _init_completion -n : || return
    if [[ "${cur}" != :/* ]] ; then
        _orig_cd "$@"
        return
    fi


    echo "=========================================================" >> ~/.log.txt
    echo "cur=${cur}, prev=${prev}, words=${words}, cword=${cword}" >> ~/.log.txt
    # echo "cur=$cur, prev=$prev words=${words[@]}, cword=$cword" >> ~/.log.txt
    # echo "_phil_cd()" >> ~/.log.txt
    # cur="$2"
    # echo "COMP_WORDS[@] = '${COMP_WORDS[@]}'" >> ~/.log.txt
    # echo "_phil_cd() : cur = '$cur'" >> ~/.log.txt
    echo "hello" >> ~/.log.txt
    case ${COMP_WORDS[1]} in
        :*)
            if ! root=$(git rev-parse --show-toplevel 2>/dev/null) ; then
                echo "PHIL _cd() error not in git repo"
                return 1
            fi

            candidates="$(${__philcd_base}/libexec/philcd/philcd_get_colonpath_candidates.py ${root} ${cur} 2>>~/.log.txt)"
            # echo "candidates=${candidates}" >> ~/.log.txt
            COMPREPLY=($(compgen -W "${candidates}" -- ${cur}))
            echo "COMPREPLY = ${COMPREPLY[@]}" >> ~/.log.txt
            __ltrim_colon_completions :
            echo "COMPREPLY = ${COMPREPLY[@]}" >> ~/.log.txt
	# COMPREPLY=( $(compgen -W "$(__suggest_gitlab_runner_compreply_candidates)" -- ${cur}))
            return
            ;;
    esac
    _cd "$@"
}
complete -F _phil_cd cd

