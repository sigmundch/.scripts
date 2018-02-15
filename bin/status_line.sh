#!/bin/bash

secs=$(date +%S)
hour=$(($(date +%k)))

notification_message="$(cat /tmp/.notification)"
if [[ ! -z $notification_message ]]; then
  if [[ $((secs % 2)) -ne 0 ]]; then
    notification_message="notification:  $notification_message              "
  else
    notification_message="************** $notification_message ************ "
  fi
fi

# we also used to have: `uptime | sed 's/.*,//'`

datetime=$(date +"%T . %D")
echo "$notification_message$datetime";
