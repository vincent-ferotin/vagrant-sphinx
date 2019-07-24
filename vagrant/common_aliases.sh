#!/usr/bin/env bash

# Set common shell aliases to all profiles
echo "Set common shell aliases to all profiles..."
sudo tee /etc/profile.d/common_aliases.sh <<EOF
# Allow `sudo` to run on following aliases!
#   Tip from https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# Only allow ENGLISH man pages, as they are much up-to-date and complete, and
# serve as reference!
alias man='LANG=C man'

EOF

