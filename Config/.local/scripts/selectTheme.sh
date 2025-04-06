#!/bin/sh

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

styles="inputbar {enabled: false;} window {width: 20%;}"

selected="$(ls "${themesDir}" | sort | rofi -dmenu -theme-str "${styles}" -matching fuzzy -i -select "$(jq -r '.themeName' ~/.local/theme.json)")"

if [ -z $selected ]; then
	exit 1
else
	"${scriptsDir}/switchTheme.sh" "${selected}"
fi
