#!/bin/bash

SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
source "$SCRIPT_DIR/common.sh";

function fix {
  if [[ $# -eq 0 ]]; then
    filemap_showValues ~/.fixtable;
    return;
  fi;
  local func_name=$1;
  filemap_getValue ~/.fixtable $func_name;
  local loc=$value_get_result;
  if [[ $loc == "" ]]; then
    echo "fix: \"$func_name\" not found";
    filemap_showValues ~/.fixtable;
    return;
  fi;
  echo \"$loc\";
  vim $loc;
  reload_programs;
  return;
}

function add_fix {
  local file=$1;
  local action=$2;
  local funcname=$3;
  filemap_addPair ~/.fixtable $action "/$SCRIPT_DIR/bin/$file +0 +/function\\s$funcname";
  reload_complete fix ~/.fixtable;
}

add_fix fix.sh fix fix;
