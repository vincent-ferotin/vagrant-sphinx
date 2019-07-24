#!/usr/bin/env bash

bold=$(tput bold)
normal=$(tput sgr0)

# Disable recommands and suggests
echo "${bold}Disable installing recommands and suggests through APT...${normal}"
sudo tee /etc/apt/apt.conf.d/90norecommends <<EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";

EOF
# Check apt update
sudo apt update
# Add apt-transport-https
echo "${bold}Install 'apt-transport-https'...${normal}"
sudo apt install --yes apt-transport-https
#   Check apt update
sudo apt update
# Rewrite /etc/apt/sources.list
echo "${bold}Rewrite /etc/apt/sources.list...${normal}"
sudo tee /etc/apt/sources.list <<EOF
deb https://deb.debian.org/debian buster main
deb-src https://deb.debian.org/debian buster main

deb http://security.debian.org/debian-security buster/updates main
deb-src http://security.debian.org/debian-security buster/updates main

deb https://deb.debian.org/debian buster-updates main
deb-src https://deb.debian.org/debian buster-updates main

EOF
# Check apt update
sudo apt update
# Ensure absent: unattended-upgrades
echo "${bold}Ensure absent or remove 'unattended-upgrades'...${normal}"
sudo apt purge --yes unattended-upgrades
# Pin all packages from 'testing'/'bullseye' and 'sid': prevent by default to install any of them
echo "${bold}Disable 'bullseye' packages installation by default...${normal}"
sudo tee /etc/apt/preferences.d/pin_bullseye <<EOF
Package: *
Pin: release n=bullseye
Pin-Priority: -10

EOF
#   Check apt update
sudo apt update
#   Pin all packages from 'sid': prevent by default to install any of them
echo "${bold}Disable 'sid' packages installation by default...${normal}"
sudo tee /etc/apt/preferences.d/pin_sid <<EOF
Package: *
Pin: release a=sid
Pin-Priority: -10

EOF
#   Check apt update
sudo apt update

# Upgrade packaging-related packages
echo "${bold}Update packages related to packages management...${normal}"
sudo apt install --yes dpkg
sudo apt install --yes apt apt-utils libapt-inst2.0 libapt-pkg5.0
sudo apt install --yes ca-certificates debian-archive-keyring apt-listchanges libparse-debianchangelog-perl

# Upgrade packages
echo "${bold}Update system and packages...${normal}"
sudo apt upgrade --yes
sudo apt full-upgrade --yes
sudo apt autoremove --yes

