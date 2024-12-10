#!/bin/bash

color_picker() {
  format=$(printf "hex\nrgb\nhsl\nhsv" | rofi -dmenu)
  sleep 1
  color=$(hyprpicker --format=${format} --autocopy)
  notify-send "${color}
  copied to clipboard"
}

screenshot_area() {
  sleep 0.5
  path=$(grimblast copysave area $HOME/Pictures/"$(date)".png)
  notify-send -i "${path}" "${path}"
}

screenshot_screen() {
  sleep 0.5
  path=$(grimblast copysave screen $HOME/Pictures/"$(date)".png)
  notify-send -i "${path}" "${path}"
}

lock_screen() {
  hyprlock
}

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

rofiStyles="window {location: north; width: 20%;} inputbar {enabled: false;}"

choice=$(printf " Screenshot (Area)\n󰹑 Screenshot (Fullscreen)\n Lock Screen\n Color Picker" | rofi -dmenu -theme-str "${rofiStyles}")

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
    command ...
    ;;
esac

