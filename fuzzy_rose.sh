#!/bin/bash

# === Details ===
# Created by: Fuzzles92
# Created: May 07 2025
# Version: 1.0

# Colours
pink_start="\e[38;5;212m"
pink_finish="\e[0m"

# === Welcome Screen ===
clear
echo -e $pink_start"=========================================="$pink_finish
echo -e $pink_start"         🌹 Welcome to Fuzzy Rose         "$pink_finish
echo -e $pink_start"     A Linux Distro Management Toolit     "$pink_finish
echo -e $pink_start"=========================================="$pink_finish
echo

# Optional: Pause for user input
read -p "Press Enter to start distro detection..."

# === Distro Detection ===
if [ -f scripts/detect_distro.sh ]; then
    source scripts/detect_distro.sh
else
    echo "Error: detect_distro.sh not found in scripts/"
    exit 1
fi

# === Follow-up Actions ===
echo "Detected distribution: $FINAL_DISTRO"

# === Arch Linux Trigger ===
# if [[ "$FINAL_DISTRO" == "arch" ]]; then
#     echo "Arch Linux Detected! Running Arch-specific setup..."
#     bash scripts/arch_linux.sh
# else
#     echo "No Arch Linux detected. Proceeding with other tasks..."
#     # Placeholder for other distro logic (Debian, Fedora, etc.)
# fi

if [[ "$FINAL_DISTRO" == "arch" ]]; then
    echo "Arch Linux Detected! Running Arch-specific setup..."
    bash scripts/arch_linux.sh

elif [[ "$FINAL_DISTRO" == "debian" ]]; then
    echo "Debian Detected! Running Debian-specific setup..."
    bash scripts/debian.sh

else
    echo "No supported distribution detected. Proceeding with generic or placeholder tasks..."
    # Add Fedora or other distro logic here later
fi
