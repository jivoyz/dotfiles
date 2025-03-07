#!/bin/env bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

imageToSet=$1

rofiCmd="rofi -dmenu -p "Wallpaper""

THEME=$(cat "$HOME/.local/theme.json" | jq -r '.themeName')
wallpaper_folder="${themesDir}/${THEME}/wallpapers"

# If path to image is not specified in parameters then let user to choose wallpaper
if [[ -z "${imageToSet}" ]]; then
  choice="$(ls "${wallpaper_folder}" | ${rofiCmd})"
fi

setWallpaper() {
  # $1 - path to wallpaper
  swww img --transition-duration 2 --transition-fps 60 --transition-type any "${1}"
}

cacheWallpaper() {
  # Add wallpaper to .cache directory so it will be used as background for hyprlock
  # $1 - wallpaper path
  if [[ "$1" == *.png ]]; then
    echo "This is .png image. No need to convert it"
    cp "$1" "${cacheDir}/wallpaper.png"
  elif [[ "$1" == *.gif ]]; then
    echo "Extracting first frame from .gif file"
    cp "$1" "${cacheDir}/wallpaper.gif"
    magick "${cacheDir}/wallpaper.gif[0]" "${cacheDir}/wallpaper.png"
    rm -rf "${cacheDir}/wallpaper.gif"
  else
    # Convert image to png because hyprlock does not want to work with .jpg for some reason
    echo "Converting .jpg to .png..."
    cp "$1" "${cacheDir}/wallpaper"
    magick "${cacheDir}/wallpaper" "${cacheDir}/wallpaper.png"
    rm -rf "${cacheDir}/wallpaper"
    echo "Done. Enjoy your wallpapers :)"
  fi
}

# If path to image is specified in parameters then set wallpaper
if [[ -n "${imageToSet}" ]]; then
  setWallpaper "${imageToSet}"
  cacheWallpaper "${imageToSet}"
  notify-send -i "${imageToSet}" -e -a "Wallpapers" "Wallpapers has been set"
  exit 1
fi

if [[ -d $wallpaper_folder/$choice ]]; then
  wallpaper_temp="${choice}"
elif [[ -f "$wallpaper_folder"/"${choice}" ]]; then
  wallPath="${wallpaper_folder}/${wallpaper_temp}/${choice}"
  # Update $THEME.json
  jq --arg wallpaper "$choice" '.wallpaper = $wallpaper' "${themesDir}/$THEME/$THEME.json" > "${cacheDir}/tmp.json" && mv "${cacheDir}/tmp.json" "${themesDir}/$THEME/$THEME.json"

  echo "${wallPath}"
  setWallpaper "${wallPath}"
  cacheWallpaper "${wallPath}"
  notify-send -i "${wallPath}" -e -a "Wallpapers" "Wallpapers has been set"
else
  exit 1
fi
