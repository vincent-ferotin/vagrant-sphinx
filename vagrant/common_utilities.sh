#!/usr/bin/env bash

bold=$(tput bold)
normal=$(tput sgr0)

# Install aptitude
echo "${bold}Install 'aptitude' package...${normal}"
sudo apt install --yes aptitude

# Install vim
echo "${bold}Install 'vim' pacakges...${normal}"
sudo apt install --yes vim vim-doc

