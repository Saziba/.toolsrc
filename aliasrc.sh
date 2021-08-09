
ALIAS_PATH=$(dirname $0)/aliases

for a in $( ls $ALIAS_PATH )
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
