#!/bin/bash
# Author: Thibault BRONCHAIN

USAGE="$0 [-yh]"
VERSION="6-8"

if [ "$1" = "-h" ]; then
    echo "syntax: $USAGE"
    exit 0
fi

# start service
echo -n "Cloudinit has been correctly configured. Would you like to start the service now? [y/N] "
if [ "$1" = "-y" ]; then
    c_start="y"
    echo "y"
else
    read c_start
fi
if [ "$c_start" = "y" ]; then
    echo "start"
else
    echo "cloudinit service not started, please do it manually, or restart your instance."
fi

# done
echo "Cloudinit bootstrap done."
