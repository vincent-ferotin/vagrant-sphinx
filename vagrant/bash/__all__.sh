#!/usr/bin/env bash
# Bash script starting provisioning Vagrant virtual machine.


# Main  ----------------------------------------------------------------------

# Import "our library"
source /vagrant/vagrant/bash/_common.sh

# Call all scripts
source $DIR/01-bootstrap.sh
source $DIR/02-common_utilities.sh
source $DIR/03-dependencies.sh
source $DIR/04-virtualenv.sh

