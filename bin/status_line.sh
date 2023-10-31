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
# 🌀= \U0001F300 , other ideas: 🍃 🔥 🌡
fan_speed="$(cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon?/fan1_input)🌡"
temp="$(echo $raw_temp | cut -b -2).$(echo $raw_temp | cut -b 3- | cut -b -1)°C"
battery="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}')"
battery_icon="🔋"
if [[ "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state:)" =~ " charging" ]]; then
  battery_icon="⚡"
fi
if [[ "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state:)" =~ " pending-charge" ]]; then
  battery_icon="⚡"
fi
# Filter out the loopback wifi interface, and remove "Auto " from the network name.
# 📶 = \U0001F4F6
# other options, font doesn't work well 🛜🈻🖧📡 🔌
wifi_name="$(nmcli -t -f name c show --active | grep -v "lo" | sed -e 's/Auto //')🖧"

if [[ "$(bluetoothctl info 7C:96:D2:6E:F0:28 | grep Connected | sed -e "s/.*Connected: //")" == "yes" ]]; then
  headset="\U0001F3A7"
else
  if [[ "$(bluetoothctl info E8:07:BF:13:1E:8B | grep Connected | sed -e "s/.*Connected: //")" == "yes" ]]; then
    headset="\U0001F3A7"
  else
    headset="\U0001F50A"
  fi
fi
# 🔋 = \U0001F50B
echo -e "$notification_message [$keyboard] $datetime . $temp . $fan_speed . $battery$battery_icon . $wifi_name . $headset";
