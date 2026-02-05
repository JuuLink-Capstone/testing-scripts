##########################################################################
#
# Filename: packet_capture.sh
#
# Author: Calin Schurig on 5 February, 2025
# Reviewer: Chase Miner on 5 February, 2025
#
# Usage: packet_capture.sh [-o OUTPUT_DIR] [interface]
#
# Description: This script is responsible for starting packet capture on
#   the WANulator. It uses the tshark cli utility to start and configure
#   the packet capture, and will automatically direct output to a file.
#   If no interface is supplied, then this script will start multiple
#   tshark instances.
#   
##########################################################################

OUTPUT_DIR=.

while getopts "o:" opt; do
  case $opt in
    o) OUTPUT_DIR="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
  esac
done

shift $((OPTIND - 1))

if [ "$#" -gt 1 ]; then
    echo "Error: expected at most 1 argument, got $#" >&2
    echo "Usage: $0 [-o OUTPUT_DIR] [interface]" >&2
fi

interface="$1"

if ! [ "$(whatis tshark)" ]; then
    echo "Error: tshark not found. tshark is required to run this script." >&2
fi

start_tshark() {
    local interface=$1
    local DATE=$2
    if ! [ "$DATE" ]; then
        DATE=$(date -I"seconds")
    fi
    local log_file="$OUTPUT_DIR/$DATE-$interface.pcapng"
    touch $log_file
    chmod o+wr $log_file # tshark runs from a daemon, so log files need to be writable.
    tshark -i $interface -w $log_file
}

trap 'kill $(jobs -p)' EXIT # Kill all child processes on exit.

if [ $interface ]; then
    start_tshark $interface
else
    # loops through all interfaces listed by ip link
    DATE=$(date -I"seconds")
    for interface in $(ip -o link show | awk -F': ' '!/lo|vir|^[^0-9]/ {print $2}'); do
        start_tshark $interface &
    done
fi

while [ "true" ]; do
    echo "Capturing packets..."
    sleep 5
done
