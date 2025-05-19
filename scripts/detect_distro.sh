#!/bin/bash

# === Details ===
# Created by: Fuzzles92
# Created: May 07 2025
# Version: 1.0

# === Colour Definitions ===
arch_start="\e[1;34m"  # Bold blue for Arch
arch_finish="\e[0m"    # Reset color
debian_start="\033[1;31m"
debian_finish="\033[0m"

# === Load /etc/os-release ===
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_DISTRO=$ID
else
    echo "Could not detect your distribution automatically."
    DETECTED_DISTRO="unknown"
fi

# === Friendly Name ===
case "$DETECTED_DISTRO" in
    arch)    DISTRO_NAME="${arch_start}Arch Linux${arch_finish}" ;;
    debian)  DISTRO_NAME="${debian_start}Debian${debian_finish}" ;;
    fedora)  DISTRO_NAME="Fedora" ;;
    *)       DISTRO_NAME="Unknown" ;;
esac

# === User Confirmation ===
echo
echo -e "Detected Distribution: $DISTRO_NAME"
read -p "Is this correct? (y/n): " confirm

# === Manual Selection if Needed ===
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo
    echo "Please choose your distribution:"
    echo -e "  ${arch_start}1) Arch Linux${arch_finish}"
    echo -e "  ${debian_start}2) Debian${debian_finish}"
    echo -e "  3) Fedora"
    read -p "Enter the number (1-3): " choice

    case "$choice" in
        1) FINAL_DISTRO="arch" ;;
        2) FINAL_DISTRO="debian" ;;
        3) FINAL_DISTRO="fedora" ;;
        *) echo "Invalid Choice. Exiting." ; exit 1 ;;
    esac
else
    FINAL_DISTRO=$DETECTED_DISTRO
fi

# Optional color mapping for final output
case "$FINAL_DISTRO" in
    arch)    COLOR="${arch_start}Arch Linux${arch_finish}" ;;
    debian)  COLOR="${debian_start}Debian${debian_finish}" ;;
    fedora)  COLOR="Fedora" ;;
    *)       COLOR="Unknown" ;;
esac

echo
echo -e "Final Distribution set to: $COLOR"
