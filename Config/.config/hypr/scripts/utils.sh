#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

choice=$(printf "Screenshot\nColor Picker" | rofi -dmenu -theme-str "inputbar {enabled: false;}")
