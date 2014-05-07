#!/bin/bash

CAT="test"
TYPE="MainActivity"

if [ "$1" == "" ]; then
    if [ "$ANDROID_PROJECT" != "" ]; then
        unset ANDROID_PROJECT
    else
        echo -e "syntax error.\nUsage: . $0 <project name>"
    fi
fi

if [ ! -f "/Users/thibaultbronchain/Sources/android/$1/build.xml" ]; then
    mkdir -p /Users/thibaultbronchain/Sources/android/$1
    cd /Users/thibaultbronchain/Sources/android/$1
    android list targets
    echo -n "Please input the target [1]: "
    read TARGET
    if [ "$TARGET" == "" ]; then
        TARGET=1
    fi
    android create project -t $TARGET -n $1 -p . -a ${TYPE} -k com.${CAT}.${1}
fi

export ANDROID_PROJECT=$1
