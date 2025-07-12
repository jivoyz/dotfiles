#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global.sh"
icons=$HOME/.local/assets
volume=$(pamixer --get-volume)

function send_notification() {
  volume=$(pamixer --get-volume)
  notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -a "Change volume" -u low -r 9944 -h int:value:"$volume" -i $2 "󰓃 Volume ${volume}%" -t 1500
}

# I use grep to find my microphone by its name
microphone_id=$(pamixer --list-sources | grep "USB Audio Device Mono" | awk '{print $1}')
function send_notification_mic() {
  volume=$(pamixer --source ${microphone_id} --get-volume)
  notify-send -u low -a "Change volume" -u low -r 9944 -h int:value:"$volume" -i $2 " Mic Volume $volume%" -t 1500
}

case $1 in
up)
  if [[ "$2" = "microphone" ]]; then
    pamixer --source "$microphone_id" -i 5
    send_notification_mic $1 "$icons/microphone.svg"
    exit 0
  else
    pamixer -u
    pamixer -i 5
    send_notification $1 "$icons/volume-plus.svg"
  fi
  ;;
down)
  if [[ "$2" = "microphone" ]]; then
    pamixer --source "$microphone_id" -d 5
    send_notification_mic $1 "$icons/microphone.svg"
    exit 0
  else
    pamixer -u
    pamixer -d 5
    send_notification $1 "$icons/volume-minus.svg"
  fi
  ;;
mute)
  if [[ "$2" == "microphone" ]]; then
    pamixer --source ${microphone_id} -t
    if [[ $(pamixer --source ${microphone_id} --get-mute) == false ]]; then
      send_notification_mic $1 ${icons}/microphone.svg
    else 
      send_notification_mic $1 ${icons}/microphone-muted.svg
    fi
    exit 0
  fi

  pamixer -t
  if [[ $(pamixer --get-mute) == false ]]; then
    notify-send -i ${icons}/volume.svg -a "󰓃 Volume" -t 1500 -r 9944 -u low "Unmuted"
  else
    notify-send -i ${icons}/volume-mute.svg -a "󰓃 Volume" -t 1500 -r 9944 -u low "Muted"
  fi
  ;;
esac
