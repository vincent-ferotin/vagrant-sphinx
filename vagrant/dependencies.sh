#!/usr/bin/env bash

bold=$(tput bold)
normal=$(tput sgr0)

# Install building packages
echo "${bold}Install 'make' package...${normal}"
sudo apt install --yes make

# Install minimal LaTeX & TexLive packages
echo "${bold}Install 'LaTeX' and 'TexLive' packages...${normal}"
sudo apt install --yes texlive \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-luatex \
    texlive-lang-french \
    texlive-lang-cyrillic \
    texlive-lang-greek \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-fonts-extra-links \
    latexmk \
    xindy \
    fonts-freefont-otf

# Install Python packages
echo "${bold}Install 'Python' packages...${normal}"
sudo apt install --yes python3-venv

