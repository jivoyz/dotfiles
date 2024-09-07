scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"

if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

echo "Hey you, yes you!"
echo "This installation script is designed for minimal arch install"
echo "If your ~/.config/ directory is not empty this script will create a backup of your ~/.config/ directory."
echo "Path to backup config is ~/.config.bak"
sleep 5

if grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
  echo "Chaotic AUR is detected"
else
  read -p "Do you want to install Chaotic Aur for faster package installing? [Y/n]: " chaoticAur

  if [[ $chaoticAur =~ "y" ]]; then
    installChaoticAur

  elif [[ $chaoticAur =~ "Y" ]]; then
    installChaoticAur
  elif [[ -z $chaoticAur ]]; then
    installChaoticAur
  fi
fi

read -p "Do you want to confirm every action during installation? [y/N]: " isConfirm
pkgOpts=()
if [[ $isConfirm =~ "n" ]]; then
  pkgOpts+=(--noconfirm)
elif [[ $isConfirm =~ "N" ]]; then
  pkgOpts+=(--noconfirm)
elif [[ -z $isConfirm ]]; then
  pkgOpts+=(--noconfirm)
fi

# Install yay (AUR helper)
if pkg_installed yay; then
  echo "Yay is already installed. Skipping AUR installation"
elif pkg_installed yay-bin; then
  echo "Yay is already installed. Skipping AUR installation"
else
  echo "Installing Yay..."
  git clone https://aur.archlinux.org/yay.git $HOME/yay
  cd $HOME/yay
  makepkg -si
  cd $HOME
fi

# Install packages
pacmanList=()
aurList=()

# install rustup to prevent some errors in future
if pkg_installed rustup; then
  rustup default stable
else
  sudo pacman ${pkgOpts[@]} -S rustup
  rustup default stable
fi

echo "Installing these packages:"

while IFS= read -r pkg; do
  if pkg_installed $pkg; then
    echo -e "\n\033[0;32m[Arch]\033[0m $pkg is already installed"
  elif pkg_available $pkg; then
    pacmanList+=("$pkg")
    echo -e "\n\033[0;32m[Arch]\033[0m $pkg"
  elif aur_available $pkg; then
    aurList+=("$pkg")
    echo -e "\n\033[0;32m[AUR]\033[0m $pkg"
  else
    echo -e "\n\033[0;32m[Arch]\033[0m Package "$pkg" not found"
  fi
done < "${scrDir}/packages.txt"

if [ ${#pacmanList[@]} -gt 0 ]; then
  sudo pacman -S ${pkgOpts[@]} "${pacmanList[@]}"
fi

if [ ${#aurList[@]} -gt 0 ]; then
  yay -S ${pkgOpts[@]} "${aurList[@]}"
fi

setSymlinks() {
  for item in ${cloneDir}/Config/.config/*; do
    item_name=$(basename "$item")

    ln -sf "$item" "$HOME/.config/$item_name"
  done
}

ln -sf "${cloneDir}/Config/.tmux.conf" $HOME/.tmux.conf

if [[ -d $HOME/.tmux ]]; then
  rm -rf $HOME/.tmux
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copying config files to $HOME/.config
echo "Copying configuration files into "~/.config"..."
cp -r "${cloneDir}"/Config/.local/. $HOME/.local

if [ -d $HOME/.config ]; then
  cp -r $HOME/.config/ $HOME/.config.bak
  setSymlinks
else
  mkdir $HOME/.config
  setSymlinks
fi

# Installing themes
gtkThemesDir="${cloneDir}"/Config/.themes
iconsDir="${cloneDir}"/Config/.icons

echo "Installing GTK and Icon themes..."
for gtkTheme in ${gtkThemesDir}/*; do
  if [[ -e ${gtkTheme} && -d $HOME/.themes ]]; then
    echo "Extracting ${gtkTheme}"
    cd $HOME/.themes
    tar -xf ${gtkTheme} > /dev/null 2>&1
  else
    mkdir ~/.themes
    echo "Extracting ${gtkTheme}"
    cd $HOME/.themes
    tar -xf ${gtkTheme} > /dev/null 2>&1
  fi
done

for iconTheme in ${iconsDir}/*; do
  if [[ -e ${iconTheme} && -d $HOME/.icons ]]; then
    echo "Extracting ${iconTheme}"
    cd $HOME/.icons
    tar -xf ${iconTheme} > /dev/null 2>&1
  else
    mkdir ~/.icons
    echo "Extracting ${iconTheme}"
    cd $HOME/.icons
    tar -xf ${iconTheme} > /dev/null 2>&1
  fi
done

# Changing the default shell for user
chsh -s /bin/fish

echo "Installation completed. Have a great day :)"
