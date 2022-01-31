#!/bin/bash

if [[ -f /etc/redhat-release ]]; then
    echo "yum"
    yum install fedora-gnat-project-common gprbuild
elif [[ -f /etc/debian_version ]]; then
    echo "apt"
    sudo apt update -y
    sudo apt install -y gnat
    sudo apt install -y gprbuild
elif [[ -f /etc/gentoo-release ]]; then
    echo "emerge"
    emerge dev-lang/gnat
elif [[ -f pkg ]]; then
    echo "pkg"
    pkg install gps-ide
elif [[ -f /etc/arch-release ]]; then
    echo "pacman"
    pacman -S gcc-ada
elif [[ -f /etc/SuSe-release ]]; then
    echo "zypper"
    SUSEConnect -p sle-module-development-tools/15.1/x86_64
    zypper install gcc8-ada-8.2.1+r264010-1.3.7
else
    echo "Aucune distribution"
fi
