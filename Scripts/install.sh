scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"

if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

echo "READ THE MESSAGE ABOVE!"
echo "This installation script is designed for minimal arch install"
echo "If your ~/.config/ directory is not empty this script will create a backup of your ~/.config/ directory."
echo "Path to backup config is ~/.config.bak"
sleep 15


# Install packages
pacmanList=()
aurList=()

echo "\n Choose AUR helper:"
echo "[1] yay"
echo "[2] paru"
read -p "===> " getAur

case $getAur in
  "1") source "${scrDir}/install_aur.sh" yay;;
  "2") source "${scrDir}/install_aur.sh" paru;;
  *) source "${scrDir}/install_aur.sh" yay;;
esac


echo "Installing these packages:"

while IFS= read -r pkg; do
  if pkg_available $pkg; then
    pacmanList+=("$pkg")
    echo "[Arch] $pkg"
  elif aur_available $pkg; then
    aurList+=("$pkg")
    echo "[AUR]  $pkg"
  else
    echo "Package '$pkg' not found"
  fi
done < "${scrDir}/packages.txt"


sudo pacman -S "${pacmanList[@]}"
${aurhlpr} -S "${aurList[@]}"

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
    tar -xf ${gtkTheme}
  else
    mkdir ~/.themes
    echo "Extracting ${gtkTheme}"
    cd $HOME/.themes
    tar -xf ${gtkTheme}
  fi
done

for iconTheme in ${iconsDir}/*; do
  if [[ -e ${iconTheme} && -d $HOME/.icons ]]; then
    echo "Extracting ${iconTheme}"
    cd $HOME/.icons
    tar -xf ${iconTheme}
  else
    mkdir ~/.icons
    echo "Extracting ${iconTheme}"
    cd $HOME/.icons
    tar -xf ${iconTheme}
  fi
done

# Changing the default shell for user
chsh -s /bin/fish

# sddm
echo "Basic installation is complete"
echo "Starting sddm..."
systemctl enable sddm.service
sleep 5
systemctl start sddm
