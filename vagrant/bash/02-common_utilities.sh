#!/usr/bin/env bash
# Install common utilities and configuration files

# Install misc.
install tree unzip wget

# Install aptitude
install aptitude

# Install vim
install vim vim-doc

# Copy common shell aliases
msg "Copy common shell aliases into '/etc/profile.d/'..."
copy /etc/profile.d/common_aliases.sh

