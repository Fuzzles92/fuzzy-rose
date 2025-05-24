#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Created: May 20 2025
# Version: 1.0

# === Colour Definitions ===
green_start="\033[1;32m"
green_finish="\033[0m"
yellow_start="\033[1;33m"
yellow_finish="\033[0m"
red_start="\033[1;31m"
red_finish="\033[0m"

# === Variables ===
opensuse_packages="./config/opensuse_packages.txt"

# === ASCII Logo ===
clear
echo -e "$green_start"
cat << "EOF"
         JJJJJJJJ
      JJJJJJJJJJJJJJ
    JJJJJJ   =JJJJJJJ
   JJJJ      =JJJ JJJJ
   JJJ       =JJJ   JJJ
  JJJJ       =JJJ   JJJ
  JJJJJJJJJJJJJJ   JJJJ
   JJJJJJJJJJJJJJ   JJJJ
   JJJJ             JJJJ
    JJJJJ=          JJJJ
      JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ=
        =JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
                    JJJJ         =JJJJJJ
                    JJJJ            =JJJJ
                    JJJJ   JJJJJJJJJJJJJJ
                    JJJJ   JJJJJJJJJJJJJJJ
                    JJJJ   JJJJ       JJJJ
                     JJJ   JJJJ       JJJ
                     JJJJJ JJJJ      JJJJ
                      =JJJJJJJJ   JJJJJJ
                        JJJJJJJJJJJJJJ
                           JJJJJJJ=
EOF
echo -e "$green_finish"
echo -e "${green_start}==== OpenSUSE Tumbleweed Setup Triggered ====${green_finish}"
echo

# === Menu Loop ===
while true; do
    echo -e "${yellow_start}Please choose an action:${yellow_finish}"
    echo "1) Update System"
    echo "2) Install Packages from $opensuse_packages"
    echo "3) Exit"
    read -rp "Enter choice [1-3]: " choice

    case "$choice" in
        1)
            echo
            echo -e "${green_start}Updating OpenSUSE TW System...${green_finish}"
            sudo zypper dup -y
            if [ $? -eq 0 ]; then
                echo
                echo -e "${green_start}✔ System Updated Successfully.${green_finish}"
            else
                echo -e "${red_start}✖ Update failed. Please check errors.${red_finish}"
            fi
            echo
            ;;
        2)
            echo
            if [[ -f "$opensuse_packages" ]]; then
                echo -e "${green_start}Installing Packages from $opensuse_packages...${green_finish}"
                echo
                sudo zypper in -y $(< "$opensuse_packages")
                if [ $? -eq 0 ]; then
                    echo
                    echo -e "${green_start}✔ Packages Installed Successfully.${green_finish}"
                else
                    echo
                    echo -e "${red_start}✖ Package Installation Failed.${red_finish}"
                fi
            else
                echo
                echo -e "${red_start}✖ Package list file not found: $opensuse_packages${red_finish}"
            fi
            echo
            ;;
        3)
            echo
            echo -e "${green_start}OpenSUSE TW Setup Complete. Goodbye!${green_finish}"
            echo
            break
            ;;
        *)
            echo -e "${red_start}Invalid choice. Please select 1, 2, or 3.${red_finish}"
            ;;
    esac
done
