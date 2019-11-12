#!/usr/bin/env bash
# Common material, our "library" for other scripts.


# Constants  -----------------------------------------------------------------

# See https://stackoverflow.com/questions/59895/get-the-source-directory-of-a-bash-script-from-within-the-script-itself#answer-246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
VAGRANT_SHARED_DIR="/vagrant"
FILES="$DIR/files"
DEFAULT_MSG_LVL_INDENT=0
MSG_PREFIX=">>>"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)


# Functions  -----------------------------------------------------------------


msg () {
    ### Print a message on standart output.
    ###
    ### Accepts at least two arguments:
    ###
    ### 1. (int, optional) level of indentation of the message
    ### 2. (str) message it-self

    # Compute message parts
    if [ "$#" -eq 1 ]; then
        _LVL_INDENT=$DEFAULT_MSG_LVL_INDENT
        _MSG="$1"
    else
        _LVL_INDENT=$1
        _MSG="$2"
    fi
    _SPACES_NB=$(( 4 * $_LVL_INDENT ))
    _SPACES=""
    if [ "$_SPACES_NB" -ge 1 ]; then
        # See https://stackoverflow.com/questions/5799303/print-a-character-repeatedly-in-bash#answer-17030976
        _SPACES=$(printf "%0.s " $(seq 1 $_SPACES_NB))
    fi

    echo "$BOLD$MSG_PREFIX $_SPACES$_MSG$NORMAL"
}


install () {
    ### Install some package(s) via `apt`
    ###
    ### Accepts any argument(s): packages names

    _PKGS="$@"

    msg 1 "Installing or upgrading packages: $_PKGS"
    for _pkg in $_PKGS; do
        apt install --yes $_pkg
    done
}


purge () {
    ### Remove and purge all config. of some package(s) via `apt`
    ###
    ### Accepts any argument(s): packages names

    _PKGS="$@"

    msg 1 "Removing and purging packages: $_PKGS"
    for _pkg in $_PKGS; do
        apt purge --yes $_pkg
    done
}


apt_update () {
    # Check apt update
    msg "Update APT packages cache..."
    apt update
}


_reboot () {
    ### Reboot system

    msg 1 "WARNING: system will REBOOT!"
    shutdown -r now
    exit 0
}


copy () {
    ### Copy a file from $FILES in system dir. tree.
    ###
    ### Params:
    ### - $1 (string) Absolute filepath to copy from $DIR
    ###
    ### If parent directory of $1 file does not exist, this function will
    ### create all of its needed and imbricated parents.

    _FILEPATH=$1
    _DIRPATH=$(dirname $_FILEPATH)

    if [ ! -d $_DIRPATH ]; then
        msg 1 "Creating directories tree for '$_DIRPATH'..."
        mkdir -p $_DIRPATH
    fi
    msg 1 "Copy file '$_FILEPATH'..."
    cp "$FILES$_FILEPATH" $_FILEPATH
}

