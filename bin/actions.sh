#!/bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh";

function aa {
  local file=~/.actionlist;
  if [[ $# -eq 0 ]]; then
    filemap_getValue "$file" "-";
    filemap_showValues "$file" "$value_get_result";
  else
    local key=$1;
    shift;
    if ( filemap_keyExists $file $key ); then
      filemap_applyToKey $file $key eval $@;
      filemap_updateHistory $file $key;
    else
      echo "Error(aa): the action '$key' doesn't exist";
    fi;
  fi;
}

function reload_actions {
  reload_complete aa ~/.actionlist;
  reload_complete ag ~/.actionlist;
}

function edit_actions {
  vim ~/.actionlist;
  reload_actions;
}

function grep_actions {
  aa | grep $1;
}


alias ae='edit_actions';
alias ag='grep_actions';
alias aar='reload_actions';

reload_complete aa ~/.actionlist;
reload_complete ag ~/.actionlist;

#add_fix actions.sh aa aa;
#add_fix actions.sh ae edit_actions;
#add_fix actions.sh ag grep_actions;
#add_fix actions.sh aar reload_actions;
