#! /bin/bash

store_alias(){
    echo $1
    name=$(awk -v T="$1" 'BEGIN{split(T,a,"=");print a[1]}')
    alias=$(awk -v T="$1" 'BEGIN{split(T,a,"=");print a[2]}')
    echo $name
    echo $alias
}


add_alias() {
    echo $1
    al=$(alias $1)

    
    if [[ -z "$al" ]]
    then
        echo parse
        store_alias $1
    else
        echo load
        store_alias $al
    fi

}


toolsrc() {
    #
    # Check options
    while :
    do
    case $# in
    0)
        break
        ;;
    esac
    option=$1
    shift
    case "${option}" in
    -e | --edit )
        code ~/.toolsrc
        break
        ;;
    -a | --add )
        alias=$1
        add_alias $alias
        break
        ;;
    *)
        echo "usage: ${progname} [OPTION]..."
        echo
        echo "This script is used to run spark-submit with the  required structure"
        echo "for the DMPS spark ETL jobs."
        echo
        echo "Options:"
        echo "  --edit   -e            Open VSCODE to manually edit tools"
        echo "  --add    -a            Add specified alias spec or add from current session"
        echo
        break
        ;;
    esac
    done
}