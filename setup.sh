#!/bin/bash

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
    echo -e "yay is not here, please install yay. Exiting building.\n"
    exit 
fi

### Install all of the above pacakges ####
read -n1 -rep '[+] Set up [N0cturne] envir0nment? (y,n): ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    yay -S --noconfirm hyprland alacritty waybar fish automake tmux libreoffice \      # polybar
    swaybg swaylock-effects rofi wlogout mako thunar dunst fakeroot feh code neovim \
    ttf-jetbrains-mono-nerd ttf-jetbrains-mono noto-fonts-emoji firefox obsidian flameshot \
    polkit-gnome python-requests starship tree lsd calc neofetch gcc gedit python-pip ipython bpython \
    swappy grim slurp pamixer brightnessctl gvfs nano htop btop gnu-netcat cloc chromium gucharmap gthumb gnome-clocks \
    bluez bluez-utils lxappearance xfce4-settings ranger redshift vlc wget bleachbit cava i3lock-color ptpython \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland ttf-iosevka-nerd evince gnome-calculator gnome-disk-utility
    
    # Clean out other portals
    echo -e "[?] Messing with XDG p0rtals...\n"
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    echo -e "[!] P0rtals ready.\n"
fi

### Copy Config Files ###
read -n1 -rep '[+] Set up [N0cturne] c0nfig files? (y,n): ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "[?] Building c0nfig files...\n"
    cp -R Nocturne/config ~/.config/
    echo -e "[!] C0nfig is ready.\n"
    #cp -R kitty ~/.config/
    #cp -R mako ~/.config/
    #cp -R waybar ~/.config/
    #cp -R swaylock ~/.config/
    #cp -R wofi ~/.config/
    
    # Set some files as exacutable 
    echo -e "[?] C0mpiling .exec files...\n"
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

### Install teh starship shell ###
read -n1 -rep '[+] Set up starship shell? (y,n): ' STAR
if [[ $STAR == "Y" || $STAR == "y" ]]; then
    # install the starship shell
    echo -e "[?] Updating .bashrc...\n"
    echo -e '\neval "$(starship init bash)"' >> ~/.bashrc
    echo -e "[?] C0pying starship c0nfig file to ~/.confg ...\n"
    cp starship.toml ~/.config/
    echo -e "[!] Starship initialized.\n"
fi

### Script is done ###
echo -e "[!] [N0cturne] is ready.\n"
echo -e "[!] Start by typing Hyprland (note the capital H).\n"
read -n1 -rep '[+] M00nlight is waiting for you... Ready? (y,n): ' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
