#!/bin/env bash

icons=$HOME/.local/assets
player="$1"
action="$2"
step=0.05
# icon=/home/jivoy/.local/assets/yt-music.svg
icon="$icons/yt-music.svg"

if playerctl --player="$player" status; then
  artist="$(playerctl --player="$player" metadata --format '{{artist}}')"
  title="$(playerctl --player="$player" metadata --format '{{title}}')"
  album="$(playerctl --player="$player" metadata --format '{{album}}')"
  artUrl="$(playerctl --player="$player" metadata mpris:artUrl)"
  # volume=$(playerctl --player="$player" volume | awk '{ printf "%.0f\n", $0 * 100 }')
else
  echo "undefined player: $player"
  exit 1
fi

if [[ "$player" == "YoutubeMusic" ]]; then
  step=0.02
  icon="$icons/yt-music.svg"
elif [[ "$player" == "spotify" ]]; then
  icon="$icons/spotify.svg"
fi

parse_volume() {
  return $(echo $1 | awk '{ printf "%.0f\n", $0 * 100 }')
}


send_notification() {
  local icon=$1
  local volume=$(playerctl --player="$player" volume)
  local parsed_volume=$(echo $volume | awk '{ printf "%.0f\n", $0 * 100 }')

  msg=$(printf " ${track_data}\n󰀥 Album: $album\n󰓃 Volume: $parsed_volume%%")

  notify-send -a " $player" -u low -r 9944 -i "$icon" "$msg" -t 1500 -h int:value:$parsed_volume
}

track_data=$(playerctl -p "$player" metadata --format '{{artist}} - {{title}}')
case "$action" in
  up)
    playerctl --player="$player" volume "$step+"
    send_notification "$icon"
    exit 0
    ;;
  down)
    playerctl --player="$player" volume "$step-"
    send_notification "$icon"
    exit 0
    ;;
  *)
    echo "undefined action"
    exit 1
    ;;
esac
