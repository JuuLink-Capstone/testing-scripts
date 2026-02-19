#!/bin/bash
##########################################################################
#
# Filename: setup.sh
# Author: Calin Schurig on 17 Feb 2026
#
# Description: Sets up necessary dependencies.
#
# Intended usage: ./setup.sh <remotes...>
#
##########################################################################

script_dir=$(dirname $0)
ssh_config=$script_dir/ssh_config
dependencies_sh=$script_dir/dependencies.sh

for host in ${@:1}; do
    ssh-copy-id -F $ssh_config $host
done

for host in ${@:1}; do
    echo ssh -F $ssh_config $host $(cat $dependencies_sh)
    ssh -F $ssh_config $host "$(cat $dependencies_sh)"
done
