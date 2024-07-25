#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"

if [ $? -ne 0 ]; then
  echo "Unable to source global_fn.sh..."
  exit 1
fi

aurhlpr="${1:-yay}"

if [ -d "$HOME/Clone" ]; then
    echo "~/Clone directory exists..."
    rm -rf "$HOME/Clone/${aurhlpr}"
else
    mkdir "$HOME/Clone"
    echo -e "[Desktop Entry]\nIcon=default-folder-git" > "$HOME/Clone/.directory"
    echo "~/Clone directory created..."
fi

if pkg_installed git; then
    git clone "https://aur.archlinux.org/${aurhlpr}.git" "$HOME/Clone/${aurhlpr}"
else
    echo "git dependency is not installed..."
    exit 1
fi

cd "$HOME/Clone/${aurhlpr}"
makepkg ${use_default} -si

if [ $? -eq 0 ]; then
    echo "${aurhlpr} aur helper installed..."
else
    echo "${aurhlpr} installation failed..."
    exit 1
fi
