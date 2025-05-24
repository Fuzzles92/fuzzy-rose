#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Updated: May 20 2025
# Version: 1.1

# === Colour Definitions ===
green_start="\033[1;32m"
green_finish="\033[0m"
yellow_start="\033[1;33m"
yellow_finish="\033[0m"
red_start="\033[1;31m"
red_finish="\033[0m"

# === Variables ===
debian_packages="./config/debian_packages.txt"

# === ASCII Logo ===
clear
echo -e "$red_start"
cat << "EOF"
       _,met$$$$$gg.
    ,g$$$$$$$$$$$$$$$P.
  ,g$$P"     """Y$$.".
 ,$$P'              `$$$.
',$$P       ,ggs.     `$$b:
`d$$'     ,$P"'   .    $$$
 $$P      d$'     ,    $$P
 $$:      $$.   -    ,d$$'
 $$;      Y$b._   _,d$P'
 Y$$.    `.`"Y$$$$P"'
 `$$b      "-.__
  `Y$$
   `Y$$.
     `$$b.
       `Y$$b.
          `"Y$b._
              `"""
EOF
echo -e "$red_finish"
echo -e "${red_start}==== Debian Setup Triggered ====${red_finish}"
echo

# === Menu Loop ===
while true; do
    echo -e "${yellow_start}Please choose an action:${yellow_finish}"
    echo "1) Update System"
    echo "2) Install Packages from $debian_packages"
    echo "3) Exit"
    read -rp "Enter choice [1-3]: " choice

    case "$choice" in
        1)
            echo
            echo -e "${red_start}Updating Debian System...${red_finish}"
            sudo apt-get update && sudo apt-get upgrade -y
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
            if [[ -f "$debian_packages" ]]; then
                echo -e "${red_start}Installing Packages from $debian_packages...${red_finish}"
                echo
                sudo apt-get install -y $(< "$debian_packages")
                if [ $? -eq 0 ]; then
                    echo
                    echo -e "${green_start}✔ Packages Installed Successfully.${green_finish}"
                else
                    echo
                    echo -e "${red_start}✖ Package Installation Failed.${red_finish}"
                fi
            else
                echo
                echo -e "${red_start}✖ Package list file not found: $debian_packages${red_finish}"
            fi
            echo
            ;;
        3)
            echo
            echo -e "${green_start}Debian Setup Complete. Goodbye!${green_finish}"
            echo
            break
            ;;
        *)
            echo -e "${red_start}Invalid choice. Please select 1, 2, or 3.${red_finish}"
            ;;
    esac
done
