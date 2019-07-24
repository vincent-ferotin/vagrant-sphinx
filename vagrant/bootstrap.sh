#!/usr/bin/env bash

# Disable recommands and suggests
echo "Disable installing recommands and suggests through APT..."
sudo tee /etc/apt/apt.conf.d/90norecommends <<EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";

EOF
# Check apt update
sudo apt update
# Add apt-transport-https
echo "Install 'apt-transport-https'..."
sudo apt install --yes apt-transport-https
#   Check apt update
sudo apt update
# Rewrite /etc/apt/sources.list
echo "Rewrite /etc/apt/sources.list..."
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
echo "Ensure absent or remove 'unattended-upgrades'..."
sudo apt purge --yes unattended-upgrades
# Pin all packages from 'testing'/'bullseye' and 'sid': prevent by default to install any of them
echo "Disable 'bullseye' packages installation by default..."
sudo tee /etc/apt/preferences.d/pin_bullseye <<EOF
Package: *
Pin: release n=bullseye
Pin-Priority: -10

EOF
#   Check apt update
sudo apt update
#   Pin all packages from 'sid': prevent by default to install any of them
echo "Disable 'sid' packages installation by default..."
sudo tee /etc/apt/preferences.d/pin_sid <<EOF
Package: *
Pin: release a=sid
Pin-Priority: -10

EOF
#   Check apt update
sudo apt update

# Upgrade packaging-related packages
echo "Update packages related to packages management..."
sudo apt install --yes dpkg
sudo apt install --yes apt apt-utils libapt-inst2.0 libapt-pkg5.0
sudo apt install --yes ca-certificates debian-archive-keyring apt-listchanges libparse-debianchangelog-perl

# Upgrade packages
echo "Update system and packages..."
sudo apt upgrade --yes
sudo apt full-upgrade --yes
sudo apt autoremove --yes

