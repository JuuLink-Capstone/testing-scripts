#!/bin/bash
##########################################################################
#
# Filename: dependencies.sh
#
# Author: Calin Schurig on 18 February 2026
#
# Intended usage: ssh <remote> $(cat dependencies.sh)
#
# Description:  Installs  the  list  of  dependendcies  listed  in  the 
#   $DEPENDENCIES variable.
#
##########################################################################

DEPENDENCIES=(at python3-locust tshark expect)

if [ "$USER" == root ]; then
    apt install $DEPENDENCIES
else
    # read password -s -p "[sudo] pasword for ${USER}: "
    sudo -S apt install $DEPENDENCIES
fi
