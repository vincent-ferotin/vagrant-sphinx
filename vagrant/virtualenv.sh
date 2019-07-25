#!/usr/bin/env bash

bold=$(tput bold)
normal=$(tput sgr0)

# Constants
SPHINX_VERSION="2.1"
SPHINX_VENV_NAME="sphinx-${SPHINX_VERSION}"
SPHINX_VENV_DIRPATH="/opt/${SPHINX_VENV_NAME}"
SPHINX_PIP="${SPHINX_VENV_DIRPATH}/bin/pip"

# Make virtualenv directory
if [ ! -d $SPHINX_VENV_DIRPATH ]; then
    echo "${bold}Create Python virtualenv directory for Sphinx...${normal}"
    sudo python3 -m venv $SPHINX_VENV_DIRPATH
fi

# Update Python packaging tools
echo "${bold}Install or upgade Python packaging tools...${normal}"
for package in setuptools pip wheel; do
    sudo $SPHINX_PIP install --upgrade $package
done

# Install or upgrade Sphinx and its dependencies
echo "${bold}Install or upgade Sphinx ${SPHINX_VERSION} and its dependencies...${normal}"
sudo $SPHINX_PIP install --upgrade "Sphinx==${SPHINX_VERSION}.*"

