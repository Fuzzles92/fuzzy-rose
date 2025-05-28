#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Created: May 07 2025
# Version: 1.5

# === To DO ===
# Add Yay Install Package Support

# === Colour Definitions ===
arch_start="\e[1;34m"
arch_finish="\e[0m"
green_start="\033[1;32m"
green_finish="\033[0m"
yellow_start="\033[1;33m"
yellow_finish="\033[0m"
red_start="\033[1;31m"
red_finish="\033[0m"

# === Variables ===
arch_packages="./config/arch_packages.txt"

clear

# === ASCII Art ===
echo
echo -e "$arch_start"
cat << "EOF"
                  -`
                 .o+`
                `ooo/
               `+oooo:
              `+oooooo:
              -+oooooo+:
            `/:-:++oooo+:
           `/++++/+++++++:
          `/++++++++++++++:
         `/+++ooooooooooooo/`
        ./ooosssso++osssssso+`
       .oossssso-````/ossssss+`
      -osssssso.      :ssssssso.
     :osssssss/        osssso+++.
    /ossssssss/        +ssssooo/-
  `/ossssso+/:-        -:/+osssso+-
 `+sso+:-`                 `.-/+oso:
`++:.                           `-/+/
.`                                 `/
EOF
echo -e "$arch_finish"
echo -e "$arch_start==== Arch Linux Setup Triggered ====$arch_finish"
echo

# === Function Definitions ===

update_system() {
    read -p "Do you want to update your system now? (y/n): " confirm_update
    if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
        echo "Updating system via pacman..."
        sudo pacman -Syu --noconfirm
        if [ $? -eq 0 ]; then
            echo
            echo -e "${green_start}✔ Arch Linux Update Complete${green_finish}"
            echo

            # Update GRUB
            echo "Updating GRUB configuration..."
            if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
                echo
                echo -e "${green_start}✔ GRUB Configuration Updated Successfully${green_finish}"
                echo
            else
                echo -e "${red_start}✖ Failed to update GRUB configuration.${red_finish}"
            fi

        else
            echo -e "${red_start}✖ Update failed. Please check the error messages above.${red_finish}"
        fi
    else
        echo -e "${yellow_start}Skipping System Update...${yellow_finish}"
    fi
    echo
}

enable_multilib() {
    echo -e "${arch_start}Multilib Repo Check...${arch_finish}"
    if grep -Eq "^[[:space:]]*\[multilib\]" /etc/pacman.conf ; then
        echo -e "${green_start}✔ multilib repo already enabled.${green_finish}"
    else
        echo -e "${yellow_start}multilib repo disabled or missing.${yellow_finish}"
        read -rp "Add & enable multilib repo? (y/n): " enable_multilib
        if [[ "$enable_multilib" =~ ^[Yy]$ ]]; then
            sudo tee -a /etc/pacman.conf >/dev/null <<'MULTILIB'
[multilib]
Include = /etc/pacman.d/mirrorlist
MULTILIB
            sudo pacman -Sy
            echo -e "${green_start}✔ Multilib Repo Enabled and Refreshed.${green_finish}"
        else
            echo -e "${yellow_start}Skipping Multilib Enablement.${yellow_finish}"
        fi
    fi
    echo
}

install_packages() {
    if [[ ! -f "$arch_packages" ]]; then
        echo -e "${red_start}Package list not found at $arch_packages${red_finish}"
        return
    fi

    read -p "Install packages from $arch_packages? (y/n): " confirm_install
    if [[ "$confirm_install" =~ ^[Yy]$ ]]; then
        echo "Installing packages..."
        xargs -a "$arch_packages" sudo pacman -S --needed --noconfirm
        echo -e "${green_start}✔ Packages Installed Successfully.${green_finish}"
    else
        echo -e "${yellow_start}Skipping Package Installation.${yellow_finish}"
    fi
    echo
}

install_aur_helper() {
    echo "Choose AUR helper:"
    echo "1) yay"
    echo "2) paru"
    echo "3) Cancel"
    read -p "Enter choice: " aur_choice

    case "$aur_choice" in
        1)
            helper_name="yay"
            repo_url="https://aur.archlinux.org/yay.git"
            ;;
        2)
            helper_name="paru"
            repo_url="https://aur.archlinux.org/paru.git"
            ;;
        *)
            echo -e "${yellow_start}AUR helper installation cancelled.${yellow_finish}"
            return
            ;;
    esac

    if command -v "$helper_name" &>/dev/null; then
        echo -e "${yellow_start}$helper_name is already installed.${yellow_finish}"
    else
        sudo pacman -S --needed --noconfirm base-devel git
        git clone "$repo_url"
        cd "$helper_name" || { echo -e "${red_start}Failed to enter $helper_name dir.${red_finish}"; return; }
        makepkg -si --noconfirm
        cd ..
        rm -rf "$helper_name"
        echo -e "${green_start}✔ $helper_name installed successfully.${green_finish}"
    fi
    echo
}

flatpak_prompt() {
    read -p "Would you like to install and enable Flatpak? (y/n): " flatpak_answer
    if [[ "$flatpak_answer" =~ ^[Yy]$ ]]; then
        sudo pacman -S --noconfirm flatpak
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        echo
        echo -e "${green_start}✔ Flatpak Installed and Flathub Enabled.${green_finish}"
    else
        echo -e "${yellow_start}Skipping Flatpak Installation.${yellow_finish}"
    fi
    echo
}

create_timeshift_snapshot() {
    echo
    echo -e "${arch_start}Creating Timeshift Snapshot...${arch_finish}"

    if ! command -v timeshift &>/dev/null; then
        echo -e "${yellow_start}Timeshift is not installed. Installing now...${yellow_finish}"
        sudo pacman -S --noconfirm timeshift
    fi

    if sudo timeshift --create --comments "Manual snapshot from Arch setup script" --tags D; then
        echo
        echo -e "${green_start}✔ Timeshift Snapshot Created Successfully.${green_finish}"
    else
        echo
        echo -e "${red_start}✖ Failed to create Timeshift snapshot.${red_finish}"
    fi
}

# === Menu Loop ===
while true; do
    echo -e "${arch_start}Please choose an option:${arch_finish}"
    echo "0) Create Timeshift Snapshot"
    echo "1) Update System"
    echo "2) Enable multilib"
    echo "3) Install packages from $arch_packages"
    echo "4) Install AUR helper (yay/paru)"
    echo "5) Install Flatpak + Flathub"
    echo "6) Exit"
    echo
    read -p "Enter choice [0-6]: " choice
    echo

    case $choice in
        0) create_timeshift_snapshot ;;
        1) update_system ;;
        2) enable_multilib ;;
        3) install_packages ;;
        4) install_aur_helper ;;
        5) flatpak_prompt ;;
        6)
            echo -e "${green_start}Exiting Arch Linux setup. Goodbye!${green_finish}"
            echo
            break
            ;;
        *) echo -e "${red_start}Invalid choice. Try again.${red_finish}" ;;
    esac
    echo
done
