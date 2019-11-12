#!/usr/bin/env bash
# Install Sphinx dependencies

# Install building packages
msg "Install 'make' package..."
install make

# Install minimal LaTeX & TexLive packages
msg "Install 'LaTeX' and 'TexLive' packages..."
install texlive \
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
msg "Install 'Python' packages..."
install python3-setuptools python3-pip python3-wheel python3-venv

