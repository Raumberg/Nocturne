#!/usr/bin/env bash
#	██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
#	██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#	██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#	██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#	██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#	╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
#   			Script to install [N0cturne]
#   			Author: Raumberg
#   			url: https://github.com/Raumberg
#
#   What to do after installation: 	install the following packages (sudo pacman -S lightdm lightdm-gtk-greeter configuration-lightdm-gtk-greeter)
#   Activate the service:   		sudo systemctl enable lightdm.service
#
#   To change GTK Theme (Thunar and other system apps), use lxappearance (sudo pacman -S laxappearance). 
#   Download the GTK theme and put it in ~/.themes and in lxappearance it will be in the list.
#
#   To disable ASCII arts in Zsh open the .zshrc file located in your HOME and delete the last line, which would be $HOME/.local/bin/colorscript -r

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

backup_folder=~/.Backup
date=$(date +%Y%m%d-%H%M%S)

logo () {

    local text="${1:?}"
    echo -en "
    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
    [N0cturne] Installer\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

########## ---------- You must not run this as root ---------- ##########

if [ "$(id -u)" = 0 ]; then
    echo "Disable r00t."
    exit 1
fi

home_dir=$HOME
current_dir=$(pwd)

if [ "$current_dir" != "$home_dir" ]; then
    printf "%s%sThe script must be executed fr0m the HOME direct0ry.%s\n" "${BLD}" "${CYE}" "${CNC}"
    exit 1
fi

########## ---------- Welcome ---------- ##########

logo "Welcome!"
printf '%s%sHell0 and welc0me to [N0cturne].%s\n\n' "${BLD}" "${CRE}" "${CNC}"

while true; do
    read -rp " D0 y0u wish t0 c0ntinue? [y/N]: " yn
    case $yn in
        [Yy]* ) break ;;
        [Nn]* ) exit ;;
        * ) printf " Err0r: write 'y' or 'n'\n\n" ;;
    esac
done
clear

########## ---------- Install packages ---------- ##########

logo "Installing packages.."

deps=(alacritty base-devel brightnessctl bspwm dunst feh code git imagemagick jq htop \
			        jgmenu libwebp lsd maim mpc mpd neovim ncmpcpp npm pamixer pacman-contrib \
			        papirus-icon-theme physlock picom playerctl polybar polkit-gnome python-gobject ranger \
			        rofi rustup sxhkd ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd \
			        ttf-joypixels ttf-terminus-nerd ueberzug webp-pixbuf-loader xclip xdg-user-dirs \
			        xdo xdotool xorg-xdpyinfo xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot firefox \
			        xorg-xwininfo zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

is_installed() {
    pacman -Q "$1" &> /dev/null
}

printf "%s%sChecking f0r required packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
for pac in "${deps[@]}"; do
    if ! is_installed "$pac"; then
        if sudo pacman -S "$pac" --noconfirm >/dev/null 2>> Errors.log; then
            printf "%s%s%s %sinstalled succesfully.%s\n" "${BLD}" "${CYE}" "$pac" "${CBL}" "${CNC}"
            sleep 1
        else
            printf "%s%s%s %sn0t installed. See %sErrors.log %sf0r m0re details.%s\n" "${BLD}" "${CYE}" "$paquete" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
            sleep 1
        fi
    else
        printf '%s%s%s %sis already installed.%s\n' "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
        sleep 1
    fi
done
sleep 5
clear

########## ---------- Preparing Folders ---------- ##########

# verify folders and prepare archives
if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
    xdg-user-dirs-update
fi

########## ---------- Cloning the repo ---------- ##########

logo "Setting up [N0cturne]"

repo_url="https://github.com/Raumberg/Nocturne"
repo_dir="$HOME/nocturne"

# remove existing dots
if [ -d "$repo_dir" ]; then
    printf "Rem0ving existing d0tfiles repository\n"
    rm -rf "$repo_dir"
fi

# cloning the repo
printf "Cl0ning [N0cturne] fr0m %s\n" "$repo_url"
git clone --depth=1 "$repo_url" "$repo_dir"
sleep 2
clear

########## ---------- Backup files ---------- ##########

logo "Backup files"

printf "[Ne0vim].\n\n"

while true; do
    read -rp "Set up Ne0vim c0nfig? (y/n): " try_nvim
    if [[ "$try_nvim" == "y" || "$try_nvim" == "n" ]]; then
        break
    else
        echo "Invalid input. Please enter 'y' 0r 'n'."
    fi
done

printf "\nBackup files will be st0red in %s%s%s/.Backup%s \n\n" "${BLD}" "${CRE}" "$HOME" "${CNC}"
sleep 10

[ ! -d "$backup_folder" ] && mkdir -p "$backup_folder"

for folder in bspwm alacritty picom rofi eww sxhkd dunst polybar ncmpcpp ranger zsh mpd paru; do
    if [ -d "$HOME/.config/$folder" ]; then
        if mv "$HOME/.config/$folder" "$backup_folder/${folder}_$date" 2>> Errors.log; then
            printf "%s%s%s f0lder backed up successfully at %s%s/%s_%s%s\n" "${BLD}" "${CGR}" "$folder" "${CBL}" "$backup_folder" "$folder" "$date" "${CNC}"
            sleep 1
        else
            printf "%s%sFailed t0 backup %s folder. See %sErrors.log%s\n" "${BLD}" "${CRE}" "$folder" "${CBL}" "${CNC}"
            sleep 1
        fi
    else
        printf "%s%s%s f0lder d0es n0t exist, %sn0 backup needed%s\n" "${BLD}" "${CGR}" "$folder" "${CYE}" "${CNC}"
        sleep 1
    fi
done

if [[ $try_nvim == "y" ]]; then
        # Download nvim
    if [ -d "$HOME/.config/nvim" ]; then
        if mv "$HOME/.config/nvim" "$backup_folder/nvim_$date" 2>> Errors.log; then
                printf "%s%snvim f0lder backed up successfully at %s%s/nvim_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "$date" "${CNC}"
                sleep 1
            else
                printf "%s%sFailed t0 backup nvim folder. See %sErrors.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
                sleep 1
        fi
        else
            printf "%s%snvim f0lder d0es n0t exist, %sn0 backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
            sleep 1
    fi
fi

for folder in "$HOME"/.mozilla/firefox/*.default-release/chrome; do
    if [ -d "$folder" ]; then
        if mv "$folder" "$backup_folder"/chrome_"$date" 2>> Errors.log; then
            printf "%s%sChr0me f0lder backed up successfully at %s%s/chrome_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "${date}" "${CNC}"
        else
            printf "%s%sFailed t0 backup Chr0me f0lder. See %sErrors.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
        fi
    else
        printf "%s%sThe f0lder Chr0me d0es n0t exist, %sn0 backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    fi
done

for file in "$HOME"/.mozilla/firefox/*.default-release/user.js; do
    if [ -f "$file" ]; then
        if mv "$file" "$backup_folder"/user.js_"$date" 2>> Errors.log; then
            printf "%s%suser.js file backed up successfully at %s%s/user.js_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "${date}" "${CNC}"
        else
            printf "%s%sFailed t0 backup user.js file. See %sErrors.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
        fi
    else
        printf "%s%sThe file user.js d0es n0t exist, %sn0 backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    fi
done

if [ -f ~/.zshrc ]; then
    if mv ~/.zshrc "$backup_folder"/.zshrc_"$date" 2>> Errors.log; then
        printf "%s%s.zshrc file backed up successfully at %s%s/.zshrc_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "${date}" "${CNC}"
    else
        printf "%s%sFailed t0 backup .zshrc file. See %sErrors.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
    fi
else
    printf "%s%sThe file .zshrc d0es n0t exist, %sn0 backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
fi

printf "%s%sD0ne.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
sleep 5

########## ---------- Copy the Rice! ---------- ##########

logo "Building [N0cturne] c0nfigs..."
printf "C0pying files t0 respective direct0ries..\n"

[ ! -d ~/.config ] && mkdir -p ~/.config
[ ! -d ~/.local/bin ] && mkdir -p ~/.local/bin
[ ! -d ~/.local/share ] && mkdir -p ~/.local/share

for dirs in ~/dotfiles/config/*; do
    dir_name=$(basename "$dirs")
    if [[ $dir_name == "nvim" && $try_nvim != "y" ]]; then
        continue
    fi
    if cp -R "${dirs}" ~/.config/ 2>> RiceError.log; then
        printf "%s%s%s %sc0nfigurati0n installed succesfully%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CGR}" "${CNC}"
        sleep 1
    else
        printf "%s%s%s %sc0nfigurati0n failed t0 been installed, see %sErrors.log %sf0r m0re details.%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 1
    fi
done

for folder in applications asciiart fonts startup-page; do
    if cp -R ~/dotfiles/misc/$folder ~/.local/share/ 2>> Errors.log; then
        printf "%s%s%s %sf0lder c0pied succesfully!%s\n" "${BLD}" "${CYE}" "$folder" "${CGR}" "${CNC}"
        sleep 1
    else
        printf "%s%s%s %sf0lder failed t0 c0py, see %sErrors.log %sf0r m0re details.%s\n" "${BLD}" "${CYE}" "$folder" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 1
    fi
done

if cp -R ~/dotfiles/misc/bin ~/.local/ 2>> Errors.log; then
    printf "%s%sbin %sf0lder c0pied succesfully!%s\n" "${BLD}" "${CYE}" "${CGR}" "${CNC}"
    sleep 1
else
    printf "%s%sbin %sf0lder failed t0 c0py, see %sErrors.log %sf0r m0re details.%s\n" "${BLD}" "${CYE}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
    sleep 1
fi

if cp -R ~/dotfiles/misc/firefox/* ~/.mozilla/firefox/*.default-release/ 2>> RiceError.log; then
    printf "%s%sFiref0x theme %sc0pied succesfully.%s\n" "${BLD}" "${CYE}" "${CGR}" "${CNC}"
    sleep 1
else
    printf "%s%sFiref0x theme %sfailed t0 c0py, see %sErrors.log %sf0r m0re details.%s\n" "${BLD}" "${CYE}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
    sleep 1
fi

sed -i "s/user_pref(\"browser.startup.homepage\", \"file:\/\/\/home\/z0mbi3\/.local\/share\/startup-page\/index.html\")/user_pref(\"browser.startup.homepage\", \"file:\/\/\/home\/$USER\/.local\/share\/startup-page\/index.html\")/" "$HOME"/.mozilla/firefox/*.default-release/user.js
sed -i "s/name: 'rmbrg'/name: '$USER'/" "$HOME"/.local/share/startup-page/config.js
cp -f "$HOME"/dotfiles/home/.zshrc "$HOME"
fc-cache -rv >/dev/null 2>&1

printf "\n\n%s%sFiles c0pied succesfully!!%s\n" "${BLD}" "${CGR}" "${CNC}"
sleep 5

########## ---------- Installing Paru & others ---------- ##########

logo "installing Paru, Eww, tdrop & xqp"

# Installing Paru
if command -v paru >/dev/null 2>&1; then
    printf "%s%sParu is already installed%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "%s%sInstalling paru%s\n" "${BLD}" "${CBL}" "${CNC}"
    {
        cd "$HOME" || exit
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin || exit
        makepkg -si --noconfirm
        } || {
        printf "\n%s%sFailed t0 install Paru. Y0u may need t0 install it manually%s\n" "${BLD}" "${CRE}" "${CNC}"
    }
fi

# Intalling tdrop for scratchpads
if command -v tdrop >/dev/null 2>&1; then
    printf "\n%s%sTdr0p is already installed.%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "\n%s%sInstalling tdr0p.%s\n" "${BLD}" "${CBL}" "${CNC}"
    paru -S tdrop-git --skipreview --noconfirm
fi

# Intalling xqpp
if command -v xqp >/dev/null 2>&1; then
    printf "\n%s%sxqp is already installed.%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "\n%s%sInstalling xqp.%s\n" "${BLD}" "${CBL}" "${CNC}"
    paru -S xqp --skipreview --noconfirm
fi

# Installing Eww
if command -v eww >/dev/null 2>&1; then
    printf "\n%s%sEww is already installed.%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "\n%s%sInstalling Eww, this c0uld take 10 mins or m0re.%s\n" "${BLD}" "${CBL}" "${CNC}"
    {
        sudo pacman -S rustup --noconfirm
        cd "$HOME" || exit
        git clone https://github.com/elkowar/eww
        cd eww || exit
        cargo build --release --no-default-features --features x11
        sudo install -m 755 "$HOME/eww/target/release/eww" -t /usr/bin/
        cd "$HOME" || exit
        rm -rf {paru-bin,.cargo,.rustup,eww}
        } || {
        printf "\n%s%sFailed t0 install Eww. Y0u may need t0 install it manually%s\n" "${BLD}" "${CRE}" "${CNC}"
    }
fi

########## ---------- Enabling MPD service ---------- ##########

logo "Enabling MPD service"

# Verifica si el servicio mpd está habilitado a nivel global (sistema)
if systemctl is-enabled --quiet mpd.service; then
    printf "\n%s%sDisabling and st0pping the gl0bal MPD service%s\n" "${BLD}" "${CBL}" "${CNC}"
    sudo systemctl stop mpd.service
    sudo systemctl disable mpd.service
fi

printf "\n%s%sEnabling and starting the user-level MPD service%s\n" "${BLD}" "${CYE}" "${CNC}"
systemctl --user enable --now mpd.service

printf "%s%sD0ne.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
sleep 2

########## --------- Changing shell to zsh ---------- ##########

logo "Changing default shell t0 zsh"

if [[ $SHELL != "/usr/bin/zsh" ]]; then
    printf "\n%s%sChanging y0ur shell t0 zsh. R00t?%s\n\n" "${BLD}" "${CYE}" "${CNC}"
    # Cambia la shell a zsh
    chsh -s /usr/bin/zsh
    printf "%s%sShell changed t0 zsh. Please, reb00t.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "%s%sShell is already zsh\nPlease, reb00t the system.%s\n" "${BLD}" "${CGR}" "${CNC}"
fi
zsh
