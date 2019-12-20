#!/bin/bash

secs=$(date +%S)
hour=$(($(date +%k)))

if [[ -e /tmp/.notification ]]; then
  notification_message="$(cat /tmp/.notification)"
fi
if [[ ! -z $notification_message ]]; then
  if [[ $((secs % 2)) -ne 0 ]]; then
    notification_message="notification:  $notification_message              "
  else
    notification_message="************** $notification_message ************ "
  fi
fi

# we also used to have: `uptime | sed 's/.*,//'`
keyboard=$(echo $(setxkbmap -query | grep "layout\|variant" | awk '{print toupper($2)}'))
datetime=$(date +"%T . %D")
echo "$notification_message [$keyboard] $datetime";
