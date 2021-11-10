
load_aliases_from_path() {
  ALIAS_PATH=$1
  for a in $( ls $ALIAS_PATH 2>/dev/null )
  do
    type -a $a >/dev/null
    ret=$?
    if [ $ret -eq 1 ]
    then
      alias $a="$(cat $ALIAS_PATH/$a)"
    else
      echo "cannot create $a because $(type -a $a) "
    fi
  done
}

load_aliases_from_path $(dirname $0)/aliases
load_aliases_from_path $(dirname $0)/private_aliases
