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
sudo pacman -S rustup
rustup default stable

echo "Installing these packages:"

while IFS= read -r pkg; do
  if pkg_available $pkg; then
    pacmanList+=("$pkg")
    echo -e "\n\033[0;32m[Arch]\033[0m $pkg"
  elif aur_available $pkg; then
    aurList+=("$pkg")
    echo -e "\n\033[0;32m[AUR]\033[0m $pkg"
  else
    echo -e "\n\033[0;32m[Arch]\033[0m Package '$pkg' not found"
  fi
done < "${scrDir}/packages.txt"


sudo pacman -S "${pacmanList[@]}"
yay -S "${aurList[@]}"

# Copying config files to $HOME/.config
echo "Copying configuration files into '~/.config'..."
cp -r "${cloneDir}"/Config/.local $HOME
if [ -d $HOME/.config ]; then
  mv ~/.config ~/.config.bak
  cp -r "${cloneDir}"/Config/.config/ $HOME
else
  echo "Config directory does not exist"
  mkdir ~/.config/
  cp -r "${cloneDir}"/Config/.config/ $HOME
fi

# Installing themes
gtkThemesDir="${cloneDir}"/Config/.themes
iconsDir="${cloneDir}"/Config/.icons

echo "Installing GTK and Icon themes..."
for gtkTheme in ${gtkThemesDir}/*; do
  if [[ -e ${gtkTheme} && -d $HOME/.themes ]]; then
    echo "Extracting ${gtkTheme}"
    cd $HOME/.themes
    tar -xf ${gtkTheme} > /dev/null
  else
    mkdir ~/.themes
    echo "Extracting ${gtkTheme}"
    cd $HOME/.themes
    tar -xf ${gtkTheme} > /dev/null
  fi
done

for iconTheme in ${iconsDir}/*; do
  if [[ -e ${iconTheme} && -d $HOME/.icons ]]; then
    echo "Extracting ${iconTheme}"
    cd $HOME/.icons
    tar -xf ${iconTheme} > /dev/null
  else
    mkdir ~/.icons
    echo "Extracting ${iconTheme}"
    cd $HOME/.icons
    tar -xf ${iconTheme} > /dev/null
  fi
done

# Changing the default shell for user
chsh -s /bin/fish

# sddm
sddmStatus=$(systemctl status sddm | grep "Active: active")

if [[ -z $sddmStatus ]]; then
  echo "Basic installation is complete"
  echo "Starting sddm..."
  systemctl enable sddm.service
  sleep 5
  systemctl start sddm
fi
sh ~/.config/hypr/scripts/switchTheme.sh Dracula 
