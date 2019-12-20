#!/bin/bash

keyboard=`setxkbmap -query | grep "layout\|variant" | awk '{print $2}'`
if [[ $keyboard == "us" ]]; then
  setxkbmap us intl
else
  setxkbmap us
fi
