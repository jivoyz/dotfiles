#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global.sh"
iconsDir=$HOME/.local/assets/

function send_notification() {
  volume=$(pamixer --get-volume)
  notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -a "Change volume" -u low -r 9944 -h int:value:"$volume" -i $2 "Volume ${volume}%" -t 1500
}

microphone_id=$(pamixer --list-sources | grep "USB Audio Device Mono" | awk '{print $1}')

function send_notification_spotify() {
  track_data=$(playerctl -p spotify metadata --format '{{artist}} - {{title}}')
  track_album=$(playerctl -p spotify metadata --format '{{xesam:album}}')
  track_art=$(playerctl -p spotify metadata --format '{{mpris:artUrl}}')

  spotify_volume=$(playerctl --player="spotify" volume | awk '{ printf "%.0f\n", $0 * 100 }')
  spotify_icon=$HOME/.local/assets/spotify.svg

  msg=" ${track_data} 
󰓃 Volume: ${spotify_volume}%"

  notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -a " Spotify" -u low -r 9944 -h int:value:${spotify_volume} -i $spotify_icon "${msg}" -t 1500
}

case $1 in
up)
  if [[ "$2" = "spotify" ]]; then
    playerctl -p spotify volume 0.05+
    send_notification_spotify up ${iconsDir}/volume-plus.svg
    exit 1
  fi

  if [[ "$2" = "microphone" ]]; then
    pamixer --source ${microphone_id} -i 5
    exit 1
  fi

  pamixer -u
  pamixer -i 5 --allow-boost
  send_notification $1 ${iconsDir}/volume-plus.svg
  ;;
down)
  if [[ "$2" = "spotify" ]]; then
    playerctl -p spotify volume 0.05-
    send_notification_spotify down ${iconsDir}/volume-minus.svg
    exit 1
  fi

  if [[ "$2" = "microphone" ]]; then
    pamixer --source ${microphone_id} -d 5
    notify-send -i ${iconsDir}/volume-plus.svg
    exit 1
  fi

  pamixer -u
  pamixer -d 5 --allow-boost
  send_notification $1 ${iconsDir}/volume-minus.svg
  ;;
mute)

  if [[ "$2" == "microphone" ]]; then
    pamixer --source ${microphone_id} -t
    exit 1
  fi

  pamixer -t
  if [[ $(pamixer --get-mute) == false ]]; then
    notify-send -i ${iconsDir}/volume.svg -a "󰓃 Volume" -t 1500 -r 9944 -u low "Unmuted"
  else
    notify-send -i ${iconsDir}/volume-mute.svg -a "󰓃 Volume" -t 1500 -r 9944 -u low "Muted"
  fi

  # if [[ "$2" = "microphone" ]]; then
  #    if [[ $(pamixer --get-mute) == false ]]; then
  #      send_notification_spotify up ${iconsDir}/volume-plus.svg
  #    fi
  # 	exit 1
  # fi
  ;;
esac
