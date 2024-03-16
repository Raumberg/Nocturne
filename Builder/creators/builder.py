import os
import packages

from logger import Logger, LoggerStatus
from creators.software import AurBuilder, FirefoxCustomize
from creators.drivers import GraphicDrivers
from creators.patches import PatchSystemBugs
from creators.daemons import Daemons

# TODO: Implement error handling for package installation

class SystemConfiguration:
    def start(*args):
        start_text = f"[+] Assembling. 0ptions: {args}"
        Logger.add_record(start_text, status=LoggerStatus.SUCCESS)
        if args[0]: SystemConfiguration.__start_option_1()
        if args[1]: SystemConfiguration.__start_option_2()
        if args[2]: SystemConfiguration.__start_option_3()
        if args[3]: SystemConfiguration.__start_option_4()
        if args[5]: SystemConfiguration.__start_option_6()
        if args[4]: GraphicDrivers.build()
        Daemons.enable_all_daemons()
        PatchSystemBugs.enable_all_patches()

    @staticmethod
    def __start_option_1():
        SystemConfiguration.__create_default_folders()
        SystemConfiguration.__copy_nocturne_dotfiles()

    @staticmethod
    def __start_option_2():
        Logger.add_record("[+] Updates Enabled", status=LoggerStatus.SUCCESS)
        os.system("sudo pacman -Sy")

    @staticmethod
    def __start_option_3():
        Logger.add_record("[+] Installed [N0cturne] Dependencies", status=LoggerStatus.SUCCESS)
        AurBuilder.build()
        SystemConfiguration.__install_pacman_package(packages.BASE_PACKAGES)
        SystemConfiguration.__install_aur_package(packages.AUR_PACKAGES)
        FirefoxCustomize.build()

    @staticmethod
    def __start_option_4():
        Logger.add_record("[+] Installed Dev Dependencies", status=LoggerStatus.SUCCESS)
        SystemConfiguration.__install_pacman_package(packages.DEV_PACKAGES)
        SystemConfiguration.__install_pacman_package(packages.GNOME_OFFICIAL_TOOLS)

    @staticmethod
    def __start_option_6():
        Logger.add_record("[+] Installed Rust", status=LoggerStatus.SUCCESS)
        os.system("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh")
        os.system("./rust.sh")

    @staticmethod
    # TODO: Make a universal function for installing packages
    # TODO: Catch errors if the software is not detected
    def __install_pacman_package(package_names: list):
        for package in package_names:
            os.system(f"sudo pacman -S --noconfirm {package}")
            Logger.add_record(f"Installed: {package}", status=LoggerStatus.SUCCESS)

    @staticmethod
    # TODO: Make a universal function for installing packages
    # TODO: Catch errors if the software is not detected
    def __install_aur_package(package_names: list):
        for package in package_names:
            os.system(f"yay -S --noconfirm {package}")
            Logger.add_record(f"Installed: {package}", status=LoggerStatus.SUCCESS)

    @staticmethod
    def __create_default_folders():
        Logger.add_record("[+] Create default direct0ries", status=LoggerStatus.SUCCESS)
        default_folders = "~/Videos ~/Documents ~/Downloads " + \
                          "~/Music ~/Desktop"
        os.system("mkdir -p ~/.config")
        os.system(f"mkdir -p {default_folders}")
        os.system("cp -r Images/ ~/")

    @staticmethod
    def __copy_nocturne_dotfiles():
        Logger.add_record("[+] C0py .Files", status=LoggerStatus.SUCCESS)
        os.system("cp -r config/* ~/.config/")
        os.system("cp ./hypr ~/.config/hypr")
        os.system("cp Xresources ~/.Xresources")
        os.system("cp gtkrc-2.0 ~/.gtkrc-2.0")
        os.system("cp -r local ~/.local")
        os.system("cp -r themes ~/.themes")
        os.system("cp xinitrc ~/.xinitrc")
        os.system("cp -r bin/ ~/")
