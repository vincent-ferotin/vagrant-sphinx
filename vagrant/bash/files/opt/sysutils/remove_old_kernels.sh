#!/usr/bin/env bash
#
# Remove all old kernel but two latest.
#
#
# ### Installation
#
# This script requires some additional packages to be already installed:
#
# - util-linux, for `getopt` utility
#
# Simply put main script (`remove_old_kernels.sh`) in your directory tree,
# e.g. in `/opt/sysutils`, with execution mode enabled
# (``sudo chmod +x remove_old_kernels.sh``).
# Additionaly, you could sym-link this script from e.g. `/usr/local/sbin`::
#
#   $ cd /usr/local/sbin
#   $ sudo ln -s /opt/sysutils/remove_old_kernels.sh remove_old_kernels
#
#
# ### Usage
#
# Simply call this script, either as root or with sudo::
#
#   $ sudo remove_old_kernels
#
# Besides help (``-h`` | ``--help``), this script also accepts only one and
# optional argument:
#
# ``-k N`` | ``--keep=N``, to set number of old kernels to keep
# (defaulting to 1, that is one plus current kernel).
#
#
# See also: https://askubuntu.com/questions/2793/how-do-i-remove-old-kernel-versions-to-clean-up-the-boot-menu


# Constants  ----------------------------------------------------------------

DEFAULT_NB_OLD_KERNELS_TO_KEEP=1
CURRENT_LINUX_VERSION=$(uname -r)
OLD_INSTALLED_LINUX_PACKAGES=$(dpkg --list |grep -e 'linux-image-*' |awk '{ print $2 }' |sort -V |sed -n "/$CURRENT_LINUX_VERSION/q;p")
NB_OLD_KERNELS=$(echo "$OLD_INSTALLED_LINUX_PACKAGES" |wc -l)


# Main  ---------------------------------------------------------------------

# Ensure this script is run as sudo/root
if [[ $(id -u) -ne 0 ]]; then
    echo "Error! This script *must* be run as sudo/root."
    exit 1
fi

# Parse CLI args
#   See https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#   and https://stackoverflow.com/questions/35235707/bash-how-to-avoid-command-eval-set-evaluating-variables
OPTIONS="hk:"
LONGOPTS="help,keep:"
HELP="no"
KEEP=$DEFAULT_NB_OLD_KERNELS_TO_KEEP
! PARSED_ARGS=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
eval set -- "$PARSED_ARGS"
while true; do
    case "$1" in
        -h|--help)
            HELP="yes"
            shift
            ;;
        -k|--keep)
            KEEP="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# Usage
if [ "$HELP" == "yes" ]; then
    echo "remove_old_kernels -- Remove some old installed and unused kernels."
    echo "    Usage:"
    echo "        $ remove_old_kernels [-k N | --keep=N]"
    echo "    where N is the number of old (unused) kernels to keep -- default to $DEFAULT_NB_OLD_KERNELS_TO_KEEP."
    exit 0
fi

# Check CLI args.
if ! [ "$KEEP" -eq "$KEEP" ] 2> /dev/null;then
    echo "'-k N' | '--keep=N' argument only accepts integer as N (received: '$KEEP')!"
    exit 1
fi

# Removing old kernels
echo "Removing old kernels, keeping $KEEP latest..."

if [ "$NB_OLD_KERNELS" -le "$KEEP" ]; then
    echo "    There already is $NB_OLD_KERNELS old kernels (<= $KEEP): do nothing!"
    exit 0
fi
# else:

NB_TO_REMOVE=$(( $NB_OLD_KERNELS - $KEEP ))
PACKAGES_TO_REMOVE=$(echo "$OLD_INSTALLED_LINUX_PACKAGES" |head -n $NB_TO_REMOVE |tr '\n' ' ')
echo "    Found to remove: $PACKAGES_TO_REMOVE"
apt purge --yes $PACKAGES_TO_REMOVE

exit 0

