#!/usr/bin/env bash
# Install common utilities and configuration files


# Constants  ----------------------------------------------------------------

COMMON_ALIASES="/etc/profile.d/common_aliases.sh"
REMOVE_OLD_KERNELS_SCRIPT="/opt/sysutils/remove_old_kernels.sh"
REMOVE_OLD_KERNELS_LOCALBIN="/usr/local/sbin/$(basename $REMOVE_OLD_KERNELS_SCRIPT .sh)"


# Main  ---------------------------------------------------------------------

# Utilities, notably getopt
install util-linux

# Install misc.
install tree unzip wget

# Install aptitude
install aptitude

# Install vim
install vim vim-doc

# Copy common shell aliases
msg "Copy common shell aliases into '/etc/profile.d/'..."
copy $COMMON_ALIASES

# Put utility script
msg "Copy 'remove_old_kernels.sh' script..."
copy $REMOVE_OLD_KERNELS_SCRIPT
chmod +x $REMOVE_OLD_KERNELS_SCRIPT
if [ -L $REMOVE_OLD_KERNELS_LOCALBIN ]; then
    unlink $REMOVE_OLD_KERNELS_LOCALBIN
fi
msg 1 "Symlink 'remove_old_kernels' in '/usr/local/sbin'..."
ln -s $REMOVE_OLD_KERNELS_SCRIPT $REMOVE_OLD_KERNELS_LOCALBIN

