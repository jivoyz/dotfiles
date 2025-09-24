#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

color_picker() {
  format=$(printf "Hex\nRGB\nHSL\nHSV" | rofi -dmenu -matching fuzzy -i)

  if [[ -z "$format" ]]; then
    exit 1
  fi

  sleep 0.5
  color=$(hyprpicker --format=${format} --autocopy)

  if [[ -z "$color" ]]; then
    exit 1
  fi

  notify-send "${color} copied to clipboard"
}

screenshot_area() {
  sleep 0.5
  area=$(slurp)
  img_filename="$(date +%F_%H-%M-%S).png"


  if [[ -z "$area" ]]; then
    exit 1
  fi

  path="$HOME/Pictures/$img_filename.png"
  grim -g "$area" -c "$path"
  action=$(notify-send -A "Copy to clipboard" -i "$path" "Screenshot")

  if [ "$action" == 0 ]; then
    wl-copy < $path 
    notify-send "Copied image to clipboard"
  fi
}

screenshot_screen() {
  sleep 0.5
  img_filename="$(date +%F_%H-%M-%S).png"
  path="$HOME/Pictures/$img_filename.png"
  grim -c "$path"

  action=$(notify-send -A "Copy to clipboard" -i "$path" "Screenshot")

  if [ "$action" == 0 ]; then
    wl-copy < $path 
    notify-send "Copied image to clipboard"
  fi
}

lock_screen() {
  if [[ "$XDG_CURRENT_DESKTOP" = "Sway" ]]; then
    swaylock --indicator-idle-visible --indicator-radius 100 -F -k -l  -e -i ~/.cache/wallpaper.png
  elif [[ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]]; then
    hyprlock
  fi
}

rofiStyles="window {location: north; width: 20%;} inputbar {enabled: false;}"

choice=$(printf " Screenshot (Area)\n󰹑 Screenshot (Fullscreen)\n Lock Screen\n Color Picker" | rofi -dmenu -theme-str "${rofiStyles}" -matching fuzzy -p "" -i)

case "${choice}" in
  " Screenshot (Area)")
    screenshot_area
    ;;
  "󰹑 Screenshot (Fullscreen)")
    screenshot_screen
    ;;
  " Lock Screen")
    lock_screen
    ;;
  " Color Picker")
    color_picker
    ;;
  *)
    exit 1
    ;;
esac
