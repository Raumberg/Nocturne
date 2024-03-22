#!/bin/bash

mkdir ~/Downloads

### CHECKING/INSTALLING YAY ###
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "yay was located, m0ving 0n.\n"
    yay -Suy
else 
    read -n1 -rep '[+] Set up yay? (y/n): ' YAY
    if [[ $INST == "Y" || $INST == "y" ]]; then
    git -C /tmp clone https://aur.archlinux.org/yay.git
    cd /tmp/yay && makepkg -si
    yay -Suy
    echo -e 'Yay installed.'
    exit 
fi

### PARU INSTALLING ###
read -n1 -rep '[+] Install paru? (y/n): ' PARU
if [[ $PARU == "Y" || $PARU == "y" ]]; then
    cd ~/Downloads
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
fi

### PACKAGES INSTALL ####
read -n1 -rep '[+] Set up [N0cturne] envir0nment? (y/n): ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
  # CREATING DOWNLOADS FOLDER
  mkdir ~/Downloads
  # INSTALLING PACKAGES
  paru -S kitty polybar rofi bspwm-rounded-corners-git xdg-user-dirs nautilus xorg \
  pavucontrol blueberry xfce4-power-manager feh lxappearance papirus-icon-theme file-roller \
  gtk-engines gtk-engine-murrine neofetch imagemagick parcellite xclip maim gpick curl jq tint2 \
  zsh moreutils recode dunst plank python-xdg redshift mate-polkit xfce4-settings mpv yaru-sound-theme \
  fish alsa-utils slim xorg-xinit brightnessctl acpi mugshot playerctl python-pytz glava wmctrl \
  i3lock-color jgmenu inter-font networkmanager-dmenu-git conky-lua bsp-layout zscroll \
  noise-suppression-for-voice starship lsof gamemode lib32-gamemode xdo bluez \
  bluez-utils bluez-libs bluez-tools
  # INSTALLING PYTHON AND RUST NIGHTLY
  sudo pacman -S python-pip
  sudo pip install pylrc
  paru -S rust-nightly-bin gtk3
fi

read -n1 -rep '[+] Build up [N0cturne]? (y/n): ' BUILD
if [[ $BUILD == "Y" || $BUILD == "y" ]]; then
  cd ~/Downloads
  git clone https://github.com/elkowar/eww.git
  cd eww
  cargo build --release -j $(nproc)
  cd target/release
  sudo mv eww /usr/bin/eww
fi

read -n1 -rep '[+] Build up XDP? (y/n): ' BLDSXP
if [[ $BLDSXP == "Y" || $BLDSXP == "y" ]]; then
  sudo pacman -S base-devel
  cd ~/Downloads
  git clone https://github.com/baskerville/xqp.git
  cd xqp
  make
  sudo make install
fi

read -n1 -rep '[+] Build up Libraries? (y/n): ' BLDLIBS
if [[ $BLDLIBS == "Y" || $BLDLIBS == "y" ]]; then
  sudo pacman -S libconfig libev libxdg-basedir pcre pixman \
  xcb-util-image xcb-util-renderutil hicolor-icon-theme libglvnd \
  libx11 libxcb libxext libdbus asciidoc uthash
  cd ~/Downloads
  git clone https://github.com/pijulius/picom.git
  cd picom/
  meson --buildtype=release . build --prefix=/usr -Dwith_docs=true
  sudo ninja -C build install
  sudo usermod -aG adm $USER
fi

### THEMES ###
read -n1 -rep '[+] Build up Themes? (y/n): ' BLDTMS
if [[ $BLDTMS == "Y" || $BLDTMS == "y" ]]; then
  cd ~/Downloads
  git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git
  cd Tokyo-Night-GTK-Theme/
  mv themes/Tokyonight-Dark-BL /usr/share/themes/
  
  cd ~/Downloads
  git clone https://github.com/syndrizzle/hotfiles.git -b bspwm
  cd hotfiles
  cp -r .config .scripts .local .cache .wallpapers ~/
  cp .xinitrc .gtkrc-2.0 ~/
  
  cd .fonts
  mv * /usr/share/fonts
  
  cd etc/
  mv slim.conf environment /etc/
  sudo cp -r usr/* /usr/
fi

### SPOTIFY ###
read -n1 -rep '[+] Build up Sp0tify? (y/n): ' BLDSPT
if [[ $BLDSPT == "Y" || $BLDSPT == "y" ]]; then
  paru -S spicetify-cli-git
  sudo chmod a+wr /opt/spotify
  sudo chmod a+wr /opt/spotify/Apps -R
  spicetify config current_theme Ziro
  spicetify config color_scheme tokyonight
  spicetify config extensions adblock.js
  spicetify backup apply
fi

### RUST ###
read -n1 -rep '[+] Set up Rust? (y/n): ' RST
if [[ $RST == "Y" || $RST == "y" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh
    ./rust.sh
    echo -e "[!] Rust is ready.\n"
fi
