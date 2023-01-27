#export DURATION="43200"


load_vars_from_path() {
  ALIAS_PATH=$1
  for a in $( ls $ALIAS_PATH 2>/dev/null )
  do
    source $ALIAS_PATH/$a
  done
}

load_vars_from_path $1/vars
load_vars_from_path $1/private_vars
