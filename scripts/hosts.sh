#!/bin/bash
##
## Google hosts auto-update script
## by Thibault BRONCHAIN
##

CUSTOM_HOSTS='/etc/hosts.my'
GOOGLE_HOSTS='/etc/hosts.google'
GOOGLE_HOSTS_URI='http://smarthosts.googlecode.com/svn/trunk/hosts'
UPDATE_PATTERN='#UPDATE:'
IGNORED_HOST='groups.google.com'

CURENT_VERSION=$(grep $UPDATE_PATTERN $GOOGLE_HOSTS)
curl -sSL $GOOGLE_HOSTS_URI | grep -v $IGNORED_HOST > $GOOGLE_HOSTS
LATEST_VERSION=$(grep $UPDATE_PATTERN $GOOGLE_HOSTS)

if [ "$CURENT_VERSION" != "$LATEST_VERSION" ]; then
    cat $GOOGLE_HOSTS > /etc/hosts
    if [ -f "$CUSTOM_HOSTS" ]; then
        echo >> /etc/hosts
        cat $CUSTOM_HOSTS >> /etc/hosts
    fi
fi

exit 0

# EOF
