#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh
source $HOME/.bashrc

# getting json values
THEME_CONFIG="${confDir}/hypr/themes/$1/$1.json"
GTK_THEME=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".gtkTheme")
ICON_THEME=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".iconTheme")
KVANTUM_THEME=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".kvantumTheme")
THEME_NAME=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".themeName")
COLOR_MODE=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".colorMode")
NVIM_THEME=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".nvimTheme")
KITTY_THEME=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".kittyTheme")
WALLPAPER=$(cat ${confDir}/hypr/themes/$1/$1.json | jq -r ".wallpaper")

notify-send -e -a "Theme Switch" $THEME_NAME

ln -fs "${confDir}/hypr/themes/$1/$1.json" "${confDir}/hypr/theme.json"

# hyprland
ln -fs "${confDir}/hypr/themes/$1/hyprland.theme" "${confDir}/hypr/theme.conf"

# swaync
# sed -i "/^@import/c\@import url(\"./themes/$THEME_NAME.css\");" ${confDir}/swaync/style.css
swaync-client -rs

# kitty terminal
ln -fs "${confDir}/hypr/themes/$1/kitty.theme" $HOME/.config/kitty/theme.conf
killall -SIGUSR1 kitty

# kvantum themes
kvantummanager --set $KVANTUM_THEME

# gtk 3.0
sed -i "/^gtk-theme-name=/c\gtk-theme-name=${GTK_THEME}" ${confDir}/gtk-3.0/settings.ini
sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${ICON_THEME}" ${confDir}/gtk-3.0/settings.ini

# gtk 4.0
gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME
gsettings set org.gnome.desktop.interface icon-theme $ICON_THEME

# rofi
killall rofi
ln -fs "${confDir}/hypr/themes/$1/rofi.theme" $HOME/.config/rofi/theme.rasi

# wallpapers
wallPath="${confDir}/hypr/themes/$1/wallpapers/$WALLPAPER"
echo ${wallPath}
sh ${confDir}/hypr/scripts/swwallchange.sh ${wallPath}
notify-send -e -a "Theme Switch" "Wallpaper has been set"

# gtk 4.0
gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME
gsettings set org.gnome.desktop.interface icon-theme $ICON_THEME

rm -rf "${confDir}/gtk-4.0"
ln -s "$HOME/.themes/${GTK_THEME}/gtk-4.0" "${confDir}/gtk-4.0"

# rofi
killall rofi
ln -fs "${confDir}/hypr/themes/$1/rofi.theme" $HOME/.config/rofi/theme.rasi

# wallpapers
wallPath="${confDir}/hypr/themes/$1/wallpapers/$WALLPAPER"
echo ${wallPath}
sh ${confDir}/hypr/scripts/swwallchange.sh ${wallPath}
notify-send -e -a "Theme Switch" "Wallpaper has been set"

# waybar
killall waybar
sed -i "/^@import url/c\@import url(\"./themes/$THEME_NAME.css\");" ${confDir}/waybar/style.css
waybar & disown
