#!/bin/bash

set -e

scrDir=$(dirname "$(realpath "$0")")
cloneDir="$(dirname "${scrDir}")"
aurList=(yay paru)

pkg_installed() {
    local PkgIn=$1

    if pacman -Qi "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

pkg_available() {
    local PkgIn=$1

    if pacman -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

aur_available() {
    local PkgIn=$1

    if yay -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}
