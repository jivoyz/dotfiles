#!/bin/sh

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

THEMES_FOLDER="${confDir}/hypr/themes"

styles="inputbar {enabled: false;} window {width: 20%;}"

selected="$(ls "${confDir}/hypr/themes" | sort | rofi -dmenu -theme-str "${styles}")"

if [ -z $selected ]; then
	exit 1
else
	"${confDir}/hypr/scripts/switchTheme.sh" $selected
fi
