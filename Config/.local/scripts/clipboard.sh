#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

# $(cliphist list | rofi -dmenu | cliphist decode | wl-copy)
choice=$(cliphist list | rofi -dmenu)

# if didn't select anything from rofi don't do anything
if [[ -n $choice ]]; then
  $(cliphist decode $choice | wl-copy)
fi
