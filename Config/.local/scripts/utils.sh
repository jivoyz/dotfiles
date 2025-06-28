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

  if [[ -z "$area" ]]; then
    exit 1
  fi

  path="$HOME/Pictures/$(date).png"
  grim -g "$area" -c "$path"
  action=$(notify-send -A "Copy to clipboard" -i "$path" "Screenshot")

  if [ "$action" == 0 ]; then
    wl-copy < $path 
    notify-send "Copied image to clipboard"
  fi
}

screenshot_screen() {
  sleep 0.5
  path=$(grim -c "$HOME/Pictures/$(date).png")
  notify-send -i "$HOME/Pictures/$(date).png" "Screenshot"
}

lock_screen() {
  if [[ "$XDG_CURRENT_DESKTOP" = "Sway" ]]; then
    swaylock --indicator-idle-visible --indicator-radius 100 -F -k -l  -e -i ~/.cache/wallpaper.png
  elif [[ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]]; then
    hyprlock
  fi
}

game_mode_hypr() {
  if [[ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]]; then
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        exit
    fi
    hyprctl reload
    notify-send "Game Mode Enabled"
  else
    notify-send -t 1000 "Not Hyprland"
  fi
}

rofiStyles="window {location: north; width: 20%;} inputbar {enabled: false;}"

choice=$(printf " Screenshot (Area)\n󰹑 Screenshot (Fullscreen)\n Lock Screen\n Color Picker\n󰊗 Game Mode (Hyprland)" | rofi -dmenu -theme-str "${rofiStyles}" -matching fuzzy -i)

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
  "󰊗 Game Mode (Hyprland)")
    game_mode_hypr
    ;;
  *)
    exit 1
    ;;
esac
