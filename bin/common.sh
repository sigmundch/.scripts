#!/bin/bash

# reload_complete(action, file): Loads auto complete entries for 'action', by
# using the keys in 'file'.
function reload_complete {
  complete -W "`filemap_complete_keys $2`" -f -d $1
}
