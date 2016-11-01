#!/bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh";

# Changes directories based on value associated with key.
function jump {
  local file=~/.jumpdirs;
  local current=`pwd`;
  if [[ $# -eq 0 ]]; then
    echo "$current";
    filemap_showValues "$file" "$current";
  else
    filemap_applyToKey $file $1 "eval cd";
    filemap_addToHistory $file "$current";
  fi;
}

function add_jump {
  if [[ $# -eq 0 ]]; then
    echo "ja/add_jump: Specify name for the jump";
  else
    local name=$1;
    local current=`pwd`;
    local file=~/.jumpdirs;
    filemap_addPair $file "$name" "$current"
    reload_complete jj ~/.jumpdirs;
  fi;
}

function reload_jump {
  reload_complete jj ~/.jumpdirs;
}

function edit_jump {
  vim ~/.jumpdirs;
  reload_jump;
}

alias jj='jump';
alias ja='add_jump';
alias je='edit_jump';
alias jjr='reload_jump';

#add_fix jump.sh jj jump
#add_fix jump.sh ja add_jump
#add_fix jump.sh je edit_jump
#add_fix jump.sh jjr reload_jump

reload_complete jj ~/.jumpdirs;
