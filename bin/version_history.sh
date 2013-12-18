#!/bin/bash

limit=5
if [[ $# -gt 0 ]]; then
  limit=$1
fi


svn log -l $limit https://dart.googlecode.com/svn/trunk dart/tools/VERSION | \
    grep "r[0-9]\+\|Version\|merge" | \
    sed -e "s/\(r[0-9]\+\) | .*/\n(\1)/" | \
    sed -e "s/Version \([^ ]*\).*/  [32mversion \1:[0m/" | \
    sed -e "s/svn merge -c \([0-9,]*\) .*/  +\1/" | \
    sed -e "s/svn merge -r\( \)\?\([0-9]*\):\([0-9]*\) .*/  \2 .. \3/"
