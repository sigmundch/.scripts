#!/bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh";

export open_spattern="\[\[";
export close_spattern="\]\]";
export open_ppattern="[[";
export close_ppattern="]]";

function filemap_getValue() {
  if [[ $# -lt 2 ]]; then
    echo "filemap_getValue: Not enough params";
    return 1;
  fi;
  local file=$1; 
  local key=$2; 
  value_get_result=`grep "$open_spattern$key$close_spattern" $file | 
      sed -e "s/^[^ ]*$close_spattern *\([^ ].*\)[ ]*$/\1/"`; 
  return 0;
}

function filemap_keyExists() {
  filemap_getValue $1 $2;
  value_get_result=`grep "$open_spattern$key$close_spattern" $file | 
      sed -e "s/^[^ ]$close_spattern *\([^ ].*\)[ ]*$/\1/"`; 
  if [[ $value_get_result == "" ]]; then
    return 1;
  else
    return 0;
  fi;
}

# Show values in table
# highlight rows match a particular value
# $1 - file
# $2 - value to highlight 
function filemap_showValues() {
  local file=$1;
  local value="------novalue------";
  if [[ $# -ge 2 ]]; then 
    value=$2;
  fi;
  cat $file |grep -v "^#" | sed -e "s/$open_spattern/$green/" | 
          sed -e "s/$close_spattern/$nocolor/" | 
          sed -e "s/     \// --> \//" |
          sed -e "s^\($value\)$^$blue\1$nocolor^" | sort -i;
  return;
}

function filemap_showKeys() {
  local file=$1;
  local key=$2;
  cat $file | grep -v "^#" |grep "$key" | sed -e "s/^$open_spattern\([^ ]*\)$close_spattern.*$/\1/";
  return;
}


function filemap_removeKey() {
    local file=$1;
    local key=$2;
    grep -v "$open_spattern$key$close_spattern" $file > $file.tmp; 
    mv $file.tmp $file;
    return;
}

function filemap_replaceKeySuffix() {
   local file=$1;
   local oldsuffix=$2;
   local newsuffix=$3;
   cat $file | 
       sed -e "s/$oldsuffix$close_spattern /$newsuffix$close_ppattern/" > $file.tmp;
   mv $file.tmp $file;
   return;
}

function filemap_addPair() {
   local file=$1;
   local key=$2;
   local value=$3;
    grep -v "$open_spattern$key$close_spattern" $file > $file.tmp; 
   printf "%-17s %s\n" "$open_ppattern$key$close_ppattern" "$value" >> $file.tmp;
   mv $file.tmp $file;
}

# filemap_applyToKey
# @param file - file containing key-value pairs
# @param key  - key to find value and apply action to
# @param action - command to apply, 
#
# The 'action' will be called with the value of 'key' as
# a parameter. The map will be updated to replace the last a

function filemap_applyToKey {
    local file=$1; shift;
    local key=$1; shift;
    local action=$1; shift;
    local addionalargs=$@;
    filemap_getValue "$file" "$key";
    $action "$value_get_result" $addionalargs;
}

# filemap_updateHistory (file, key): updates history to include the 
# value of key as the last value used in the filemap.
# The history of last 5 values is represented with 5 special keys:
# -, --, ---, ----, -----.
function filemap_updateHistory {
    local file=$1;
    local key=`echo $2 | sed -e "s/-$/--/"`;
    filemap_replaceKeySuffix $file "-" "--";
    filemap_applyToKey $file $key "filemap_addPair $file -"
    filemap_removeKey $file "------";
}

# filemap_addToHistory (file, value): appends value to the end of
# history. The history of last 5 values is represented with 5 special keys:
# -, --, ---, ----, -----. Older than 6 values are discarded.
function filemap_addToHistory {
    local file=$1;
    filemap_replaceKeySuffix $file "-" "--";
    filemap_addPair $file "-" $2;
    filemap_removeKey $file "------";
}

# filemap_complete_keys (file) : shows the keys in the file in a single line,
# separated by spaces.
function filemap_complete_keys {
   local file=$1;
   filemap_showKeys $file "" | grep -v "^-" | xargs echo;
}
