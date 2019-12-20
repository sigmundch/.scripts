#!/bin/bash

function reload_programs() {
  SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
  source "$SCRIPT_DIR/common.sh";
  source "$SCRIPT_DIR/filemap.sh";
  #source "$SCRIPT_DIR/fix.sh";
  source "$SCRIPT_DIR/jump.sh";
  #source "$SCRIPT_DIR/actions.sh";
}

function reload_completion() {
  #reload_complete aa ~/.actionlist;
  #reload_complete ag ~/.actionlist;
  #reload_complete fix ~/.fixtable;
  reload_complete jj ~/.jumpdirs;
}

reload_programs;

#add_fix "load_all.sh" "reload_programs" "reload_programs";
