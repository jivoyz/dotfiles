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

function installChaoticAur() {

  echo "Making backup of pacman.conf"
  sudo /etc/pacman.conf /etc/pacman.conf.bak

  echo "Installing Chaotic Aur..."
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

  echo "[chaotic-aur]" >> /etc/pacman.conf
  echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
}
