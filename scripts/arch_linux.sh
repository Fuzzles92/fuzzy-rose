#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Created: May 07 2025
# Version: 1.1

# add matlib repo


# === Colour Definitions ===
arch_start="\e[1;34m"    # Bold blue for Arch
arch_finish="\e[0m"      # Reset color
green_start="\033[1;32m" # Bold green for success
green_finish="\033[0m"
yellow_start="\033[1;33m" # Bold yellow for questions
yellow_finish="\033[0m"
red_start="\033[1;31m"   # Bold red for errors
red_finish="\033[0m"

# === Variables ===
arch_packages="./config/arch_packages.txt"
flatpak_packages="./flatpak_packages.txt"
yay_packages="./yay_packages.txt"

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

# === Check for Pacman ===
if command -v pacman >/dev/null 2>&1; then
    echo -e "${arch_start}✔ Pacman Found. Ready to Update System...${arch_finish}"
else
    echo -e "${red_start}✖ Pacman not found. Are you sure this is an Arch-based system?${red_finish}"
    exit 1
fi

# === Confirm System Update ===
read -p "Do you want to update your system now? (y/n): " confirm_update
if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
    echo "Updating system via pacman..."
    sudo pacman -Syu --noconfirm

    if [ $? -eq 0 ]; then
        echo
        echo -e "${green_start}✔ Arch Linux Update Complete${green_finish}"
    else
        echo -e "${red_start}✖ Update failed. Please check the error messages above.${red_finish}"
    fi
else
    echo
    echo -e "${yellow_start}Skipping System Update...${yellow_finish}"
fi

# === Install via Pacman ===
echo
echo -e "${arch_start}Pacman Package Installation...${arch_finish}"
echo "Would you like to install some commonly used packages (git, vim, htop)?"
read -p "Install packages? (y/n): " confirm_install
if [[ "$confirm_install" =~ ^[Yy]$ ]]; then
    echo "Installing Packages..."
    sudo pacman -S --needed --noconfirm $(< "$arch_packages")
    if [ $? -eq 0 ]; then
        echo
        echo -e "${green_start}✔ Packages Installed Successfully.${green_finish}"
    else
    echo
        echo -e "${red_start}✖ Failed to install packages.${red_finish}"
    fi
else
    echo
    echo -e "${yellow_start}Skipping Package Installation...${yellow_finish}"
fi

# === Install AUR Helper ===
echo
echo "Would you like to install an AUR helper?"
echo "1) yay"
echo "2) paru"
echo "3) No"
read -p "Enter your choice (1/2/3): " aur_choice

install_aur_helper() {
    local helper_name=$1
    local repo_url=$2

    echo
    echo -e "${yellow_start}Installing $helper_name...${yellow_finish}"
    sudo pacman -S --needed --noconfirm base-devel git
    git clone "$repo_url"
    cd "$helper_name" || { echo -e "${red_start}Failed to enter $helper_name directory.${red_finish}"; return; }
    makepkg -si --noconfirm
    cd ..
    rm -rf "$helper_name"
    echo
    echo -e "${green_start}✔ $helper_name Installed Successfully.${green_finish}"
}

case "$aur_choice" in
    1)
        install_aur_helper "yay" "https://aur.archlinux.org/yay.git"
        ;;
    2)
        install_aur_helper "paru" "https://aur.archlinux.org/paru.git"
        ;;
    3)
        echo
        echo -e "${yellow_start}Skipping AUR helper installation...${yellow_finish}"
        ;;
    *)
        echo
        echo -e "${red_start}Invalid choice. Skipping AUR helper installation.${red_finish}"
        ;;
esac

# === Placeholder for Further Arch Setup ===
echo
echo -e "${green_start}Arch Linux Setup Complete${green_finish}"
echo
