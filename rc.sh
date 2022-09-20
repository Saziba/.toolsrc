
where_am_i=$(dirname $0)

run_if_exists(){
    script=${where_am_i}/${1}.sh
    [[ -s "$script" ]] && source $script
}

run_if_exists bin
run_if_exists exportrc
run_if_exists aliasrc
run_if_exists otherrc

