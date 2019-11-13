#!/usr/bin/env bash

NO_MORE_UPGRADE="0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded."


# Disable recommands and suggests
msg "Disable installing recommands and suggests through APT..."
copy /etc/apt/apt.conf.d/90norecommends

# Check apt update
apt_update

# Add apt-transport-https
install apt-transport-https

# Rewrite /etc/apt/sources.list
msg "Set specific APT sources list..."
copy /etc/apt/apt/sources.list

# Check apt update and ensure config is well formed
apt_update

# Ensure absent: unattended-upgrades
purge unattended-upgrades

# Pin all packages from 'testing'/'bullseye' and 'sid': prevent by default to install any of them
msg "Disable 'bullseye' packages installation by default..."
copy /etc/apt/preferences.d/pin_bullseye
msg "Disable 'sid' packages installation by default..."
copy /etc/apt/preferences.d/pin_sid

# Check apt update and ensure config is well formed
apt_update

# Upgrade packaging-related packages
msg "Update packages related to packages management..."
install dpkg
install apt apt-utils libapt-inst2.0 libapt-pkg5.0
install ca-certificates debian-archive-keyring apt-listchanges libparse-debianchangelog-perl

# Upgrade packages
msg "Update system and packages..."
#   See https://stackoverflow.com/questions/12451278/capture-stdout-to-a-variable-but-still-display-it-in-the-console#answer-12451419
exec 5>&1
UPGRADE=$(apt upgrade --yes |tee >(cat - >&5))
LAST_LINE=$(echo "$UPGRADE" |tail -n 1)
if [ "$LAST_LINE" != "$NO_MORE_UPGRADE" ]; then
    _reboot
fi
UPGRADE=$(apt full-upgrade --yes |tee >(cat - >&5))
LAST_LINE=$(echo "$UPGRADE" |tail -n 1)
if [ "$LAST_LINE" != "$NO_MORE_UPGRADE" ]; then
    _reboot
fi
msg "Remove automatically obsolete packages..."
msg 1 "'apt autoremove'..."
apt autoremove --yes

# Remove old kernels if any
#   See https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script#answer-26759734
if [ -x "$(command -v remove_old_kernels)" ]; then
    msg "Remove some old kernels..."
    remove_old_kernels
fi

