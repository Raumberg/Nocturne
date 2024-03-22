#!/bin/bash

mkdir ~/Downloads

paru -S kitty polybar rofi bspwm-rounded-corners-git xdg-user-dirs nautilus xorg pavucontrol blueberry xfce4-power-manager feh lxappearance papirus-icon-theme file-roller gtk-engines gtk-engine-murrine neofetch imagemagick parcellite xclip maim gpick curl jq tint2 zsh moreutils recode dunst plank python-xdg redshift mate-polkit xfce4-settings mpv yaru-sound-theme fish alsa-utils slim xorg-xinit brightnessctl acpi mugshot playerctl python-pytz glava wmctrl i3lock-color jgmenu inter-font networkmanager-dmenu-git conky-lua bsp-layout zscroll noise-suppression-for-voice starship system76-power lsof gamemode lib32-gamemode xdo bluez bluez-utils bluez-libs bluez-tools
sudo pacman -S python-pip
sudo pip install pylrc
paru -S rust-nightly-bin gtk3

cd ~/Downloads
git clone https://github.com/elkowar/eww.git
cd eww
cargo build --release -j $(nproc)
cd target/release
sudo mv eww /usr/bin/eww

sudo pacman -S base-devel

cd ~/Downloads
git clone https://github.com/baskerville/xqp.git
cd xqp
make
sudo make install

sudo pacman -S libconfig libev libxdg-basedir pcre pixman xcb-util-image xcb-util-renderutil hicolor-icon-theme libglvnd libx11 libxcb libxext libdbus asciidoc uthash

cd ~/Downloads
git clone https://github.com/pijulius/picom.git
cd picom/
meson --buildtype=release . build --prefix=/usr -Dwith_docs=true
sudo ninja -C build install

sudo usermod -aG adm $USER

#theme
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
