#!/bin/bash

# reload_complete(action, file): Loads auto complete entries for 'action', by
# using the keys in 'file'.
function reload_complete {
  local action=$1
  local file=$2
  [[ -e $file ]] || touch $file
  complete -W "`filemap_complete_keys $file`" -f -d $action
}
