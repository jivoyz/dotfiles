!#/bin/bash

styles="#window {location: northeast; width: 320px; height: 320px; padding: 0;} listview {lines: 1;} element {padding: 0 0;} inputbar {enabled: false;}"

selected=$(printf "  Power off\n  Restart\n  Lock" | rofi -dmenu -mesg "Bye, $USER" -hover-select -me-select-entry '' -me-accept-entry MousePrimary -theme-str "$styles")

case "$selected" in
"  Power off")
	shutdown -h now
	;;
"  Restart")
	shutdown -r now
	;;
"  Lock")
	hyprlock
	;;
*)
	exit 1
	;;
esac
