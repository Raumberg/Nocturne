#!/bin/bash

# https://github.com/hyprwm/Hypr/blob/main/README.md


# The follwoing will attempt to install all needed packages to run Hyprland
# This is a quick and dirty script there are no error checking
# This script is meant to run on a clean fresh system
#
# Below is a list of the packages that would be installed
#
# hyprland: This is the Hyprland compositor
# kitty: This is the default terminal
# waybar: Waybar now has hyprland support
# swaybg: This is used to set a desktop background image
# swaylock-effects: This allows for the locking of the desktop its a fork that adds some editional visual effects
# wofi: This is an application launcher menu
# wlogout: This is a logout menu that allows for shutdown, reboot and sleep
# mako: This is a graphical notification daemon
# thunar: This is a graphical file manager
# ttf-jetbrains-mono-nerd: Som nerd fonts for icons and overall look
# noto-fonts-emoji: fonts needed by the weather script in the top bar
# polkit-gnome: needed to get superuser access on some graphical appliaction
# python-requests: needed for the weather module script to execute
# starship: allows to customize the shell prompt
# swappy: This is a screenshot editor tool
# grim: This is a screenshot tool it grabs images from a Wayland compositor
# slurp: This helps with screenshots, it selects a region in a Wayland compositor
# pamixer: This helps with audio settings such as volume
# brightnessctl: used to control monitor bright level
# gvfs: adds missing functionality to thunar such as automount usb drives
# bluez: the bluetooth service
# bluez-utils: command line utilities to interact with bluettoth devices
# lxappearance: used to set GTK theme
# xfce4-settings: set of tools for xfce, needed to set GTK theme
# dracula-gtk-theme: the Dracula theme, it fits the overall look and feel
# dracula-icons-git" set of icons to go with the Dracula theme
# xdg-desktop-portal-hyprland: xdg-desktop-portal backend for hyprland

#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "yay was located, moving on.\n"
    yay -Suy
else 
    read -n1 -rep '[+] Set up yay? (y,n): ' YAY
    if [[ $INST == "Y" || $INST == "y" ]]; then
    git -C /tmp clone https://aur.archlinux.org/yay.git
    cd /tmp/yay && makepkg -si
    yay -Suy
    echo -e 'Yay installed.'
    exit 
fi

### Install all of the above pacakges ####
read -n1 -rep '[+] Set up [N0cturne] envir0nment? (y,n): ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    yay -S --noconfirm hyprland alacritty waybar automake tmux libreoffice spacevim rofi-lbonn-wayland-git \  
    swaybg swaylock-effects rofi wlogout mako thunar dunst fakeroot feh code neovim parallel \
    ttf-jetbrains-mono-nerd ttf-jetbrains-mono noto-fonts-emoji firefox obsidian flameshot jq \
    polkit-gnome python-requests starship tree lsd calc neofetch gcc gedit python-pip ipython bpython \
    swappy grim slurp pamixer brightnessctl gvfs nano htop btop gnu-netcat cloc chromium gucharmap gthumb gnome-clocks \
    bluez bluez-utils lxappearance xfce4-settings ranger redshift vlc wget bleachbit cava i3lock-color ptpython \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland ttf-iosevka-nerd evince gnome-calculator gnome-disk-utility
    
    # Clean out other portals
    echo -e "[?] Messing with XDG p0rtals...\n"
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    echo -e "[!] P0rtals ready.\n"

    # Mess with terminals
    sudo ln -sf /usr/bin/alacritty /usr/bin/xterm
fi

read -n1 -rep '[+] Set up Rust? (y,n): ' RST
if [[ $RST == "Y" || $RST == "y" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh # echo???
    ./rust.sh
    echo -e "[!] Rust is ready.\n"

### Copy Config Files ###
read -n1 -rep '[+] Set up [N0cturne] c0nfig files? (y,n): ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "[?] Building c0nfig files...\n"
    cp -R Nocturne/config ~/.config/
    echo -e "[!] C0nfig is ready.\n"
    
    # Set some files as exacutable 
    echo -e "[?] C0mpiling .exec files...\n"
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

### Install starship shell ###
read -n1 -rep '[+] Set up starship shell? (y,n): ' STAR
if [[ $STAR == "Y" || $STAR == "y" ]]; then
    # install the starship shell
    echo -e "[?] Updating .bashrc...\n"
    echo -e '\neval "$(starship init bash)"' >> ~/.bashrc
    echo -e "[?] C0pying starship c0nfig file t0 ~/.confg ...\n"
    cp starship.toml ~/.config/
    # echo -e "[?] C0pying and initializing c0l0rs for starship..."
    # git clone https://gitlab.com/dwt1/shell-color-scripts.git
    # cd shell-color-scripts
    # rm -rf /opt/shell-color-scripts || return 1
    # sudo mkdir -p /opt/shell-color-scripts/colorscripts || return 1
    # sudo cp -rf colorscripts/* /opt/shell-color-scripts/colorscripts
    # sudo cp colorscript.sh /usr/bin/colorscript                          # colorscript -e crunch add to ~/.bashrc https://habr.com/ru/companies/cloud4y/articles/574450/
    echo -e "[!] Starship initialized.\n"
fi

### Install Firefox theme ###
rean -n1 -rep '[+] Set up Firef0x themes? (y,n): ' FIRE
if [[ $FIRE == "Y" || $FIRE == "y" ]]; then
    timeout 10 firefox --headless
    sh firefox/install.sh
    echo -e "[!] Firefox themes installed.\n"
fi
    
### Building is done ###
echo -e "[!] [N0cturne] is assembled.\n"
echo -e "[!] Start by typing Hyprland (note the capital H).\n"
read -n1 -rep '[+] M00nlight is waiting for you... Ready? (y,n): ' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
