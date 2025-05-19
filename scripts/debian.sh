#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Created: May 11 2025
# Version: 1.0

# === Colour Definitions ===
green_start="\033[1;32m" # Bold green for success
green_finish="\033[0m"
yellow_start="\033[1;33m" # Bold yellow for questions
yellow_finish="\033[0m"
red_start="\033[1;31m"   # Bold red for errors
red_finish="\033[0m"

# === Variables ===
debian_packages="./config/debian_packages.txt"

echo
echo -e $red_start  # Bold red
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
echo -e $red_finish
echo -e "$red_start==== Debian Setup Triggered ====$red_finish"
echo

# === Update System ===
echo -e "${red_start}System Update...${red_finish}"
read -p "Do you want to update your Debian system now? (y/n): " confirm_update
if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
    echo "Updating system via apt-get..."
    sudo apt-get update && sudo apt-get upgrade -y
    if [ $? -eq 0 ]; then
        echo
        echo -e "$green_start✔ Debian Update Complete$green_finish"
        echo
    else
        echo
        echo -e "$red_start✖ Update failed. Please check the error messages above.$red_finish"
    fi
else
    echo
    echo -e "$yellow_start Skipping System Update...$yellow_finish"
    echo
fi

# === Install Packages from .txt File ===
echo -e "${red_start}Package Installation...${red_finish}"
read -p "Do you want to install packages from $debian_package? (y/n): " confirm_install
if [[ "$confirm_install" =~ ^[Yy]$ ]]; then
    # Check if the file exists
    if [[ -f "$debian_package" ]]; then
        echo "Installing packages from $debian_package..."

        # Install packages using apt-get
        sudo apt-get install -y $(cat "$debian_packages")

        if [ $? -eq 0 ]; then
            echo -e "$green_start✔ Packages Installed Successfully.$green_finish"
        else
            echo -e "$red_start✖ Failed to install packages from $debian_packages.$red_finish"
        fi
    else
        echo
        echo -e "$red_start✖ The specified file ($debian_packages) does not exist.$red_finish"
    fi
else
    echo
    echo -e "$yellow_start Skipping Package Installation...$yellow_finish"
fi

# === Final Message ===
echo
echo -e "$green_start Debian Setup Complete $green_finish"
echo
