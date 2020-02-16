#!/usr/bin/env bash
# Install Sphinx in a dedicated virtualenv


# Constants  ----------------------------------------------------------------

SPHINX_VERSION="2.4"
SPHINX_VENV_NAME="sphinx"
SPHINX_VENV_DIRPATH="/opt/${SPHINX_VENV_NAME}"
SPHINX_PIP="${SPHINX_VENV_DIRPATH}/bin/pip"
PYTHON_SETUP_PACKAGES="setuptools pip wheel"


# Maing  --------------------------------------------------------------------

# Make virtualenv directory
if [ ! -d $SPHINX_VENV_DIRPATH ]; then
    msg "Create dedicated Python virtualenv directory for Sphinx..."
    python3 -m venv $SPHINX_VENV_DIRPATH
fi

# Update Python packaging tools
msg "Install or upgade Python packaging tools..."
for package in "$PYTHON_SETUP_PACKAGES"; do
    $SPHINX_PIP install --upgrade $package
done

# Install or upgrade Sphinx and its dependencies
msg "Install or upgade Sphinx ${SPHINX_VERSION} and its dependencies..."
$SPHINX_PIP install --upgrade "Sphinx==${SPHINX_VERSION}.*"

