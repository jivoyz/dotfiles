!#/bin/bash

styles="#window {location: center; width: 50%; height: 240px; padding: 0;} listview {columns: 4; lines: 1; layout: horizontal;dynamic: true;} element { padding: 0 0;} inputbar {enabled: false;}"

options=("  Power off" " Restart" "  Lock")

selected=$(printf "${options[0]}\n${options[1]}\n${options[2]}" | rofi -dmenu -mesg "Bye, $USER" -hover-select -me-select-entry '' -me-accept-entry MousePrimary -theme-str "$styles")

case "$selected" in
"${options[0]}")
	shutdown -h now
	;;
"${options[1]}")
	shutdown -r now
	;;
"${options[2]}")
	hyprlock
	;;
*)
	exit 1
	;;
esac
