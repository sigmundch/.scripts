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

raw_temp=$(cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon?/temp1_input)
fan_speed="$(cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon?/fan1_input)\U0001F300"
temp="$(echo $raw_temp | cut -b -2).$(echo $raw_temp | cut -b 3- | cut -b -1)°C"
battery="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}')"
wifi_name="$(nmcli -t -f name c show --active | sed -e 's/Auto //')\U0001F4F6"

if [[ "$(bluetoothctl info 7C:96:D2:6E:F0:28 | grep Connected | sed -e "s/.*Connected: //")" == "yes" ]]; then
  headset="\U0001F3A7"
else
  headset="\U0001F50A"
fi
echo -e "$notification_message [$keyboard] $datetime . $temp $fan_speed $battery\U0001F50B $wifi_name $headset";
