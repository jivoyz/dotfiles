#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

$(cliphist list | rofi -dmenu | cliphist decode | wl-copy)
