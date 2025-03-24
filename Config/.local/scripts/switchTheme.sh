#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source ${scrDir}/global.sh

# getting json values
HOME_CONFIG="${themesDir}/${1}/${1}.json"
GTK_THEME=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".gtkTheme")
ICON_THEME=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".iconTheme")
KVANTUM_THEME=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".kvantumTheme")
THEME_NAME=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".themeName")
COLOR_MODE=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".colorMode")
NVIM_THEME=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".nvimTheme")
WALLPAPER=$(cat "${themesDir}/${1}/${1}.json" | jq -r ".wallpaper")

notify-send -e -a "Theme Switch" $THEME_NAME

ln -fs "${themesDir}/${1}/${1}.json" "$HOME/.local/theme.json"

# waybar
# killall -SIGUSR1 waybar
sed -i "/^@import url/c\@import url(\"./themes/$THEME_NAME.css\");" ${confDir}/waybar/style.css

# hyprland
ln -fs "${themesDir}/${1}/hyprland.theme" "${confDir}/hypr/theme.conf"

# sway
cp "${themesDir}/${1}/sway.theme" "${confDir}/sway/theme"
swaymsg reload

# fzf
cp "${themesDir}/${1}/fzf.fish" "${confDir}/fish/fzf.fish"

# tmux
ln -fs "${themesDir}/${1}/tmux.theme" "$HOME/.tmux-theme.conf"

# dunst
killall dunst
cp "${themesDir}/${1}/dunstrc" "${confDir}/dunst/dunstrc"

# kitty terminal
ln -fs "${themesDir}/"${1}"/kitty.theme" "${confDir}/kitty/theme.conf"
killall -SIGUSR1 kitty

rm -rf "${confDir}/gtk-4.0"
ln -s "$HOME/.themes/${GTK_THEME}/gtk-4.0" "${confDir}/gtk-4.0"

# rofi
killall rofi
ln -fs "${themesDir}/"${1}"/rofi.theme" "${confDir}/rofi/theme.rasi"

# kvantum themes
kvantummanager --set $KVANTUM_THEME

# GTK
gsettings set org.gnome.desktop.interface gtk-theme "${GTK_THEME}"
gsettings set org.gnome.desktop.interface icon-theme "${ICON_THEME}"
gsettings set org.gnome.desktop.interface color-scheme prefer-${COLOR_MODE}

# wallpapers
wallPath="${themesDir}/${1}/wallpapers/${WALLPAPER}"
echo "${wallPath}"
sh "${scriptsDir}/swwallchange.sh" "${wallPath}"
