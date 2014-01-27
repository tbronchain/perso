#!/bin/bash
##
## Google hosts auto-update script
## by Thibault BRONCHAIN
##

CUSTOM_HOSTS='/etc/hosts.my'
GOOGLE_HOSTS='/etc/hosts.google'
GOOGLE_HOSTS_URI='https://smarthosts.googlecode.com/svn/trunk/hosts'
UPDATE_PATTERN='#UPDATE:'

CURENT_VERSION=$(grep $UPDATE_PATTERN $GOOGLE_HOSTS)
curl -sSL -o $GOOGLE_HOSTS $GOOGLE_HOSTS_URI
LATEST_VERSION=$(grep $UPDATE_PATTERN $GOOGLE_HOSTS)

if [ "$CURENT_VERSION" != "$LATEST_VERSION" ]; then
    cat $GOOGLE_HOSTS > /etc/hosts
    if [ -f "$CUSTOM_HOSTS" ]; then
        echo >> /etc/hosts
        cat /$CUSTOM_HOSTS >> /etc/hosts
    fi
fi

exit 0

# EOF
