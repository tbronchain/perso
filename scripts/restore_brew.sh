#!/bin/bash

failed_items=""
function install_package() {
    echo EXECUTING: brew install $1 $2
    brew install $1 $2
    [ $? -ne 0 ] && $failed_items="$failed_items $1" # package failed to install.
}

brew tap homebrew/dupes
brew tap josegonzalez/php
install_package autoconf ''
install_package automake ''
install_package bash ''
install_package bazaar ''
install_package cmake ''
install_package colordiff ''
install_package docker ''
install_package dos2unix ''
install_package emacs ''
#install_package ext4fuse ''
install_package fish ''
install_package freetype ''
#install_package fuse4x ''
#install_package fuse4x-kext ''
install_package gettext ''
install_package git ''
install_package gnupg ''
install_package htop-osx ''
install_package httrack ''
install_package imap-uw ''
install_package jpeg ''
install_package libevent ''
install_package libpng ''
install_package libtool ''
install_package mcrypt ''
#install_package mercurial ''
install_package most ''
#install_package mysql '  --enable-debug'
#install_package nginx ''
install_package node ''
install_package openssl ''
#install_package pcre ''
install_package php56 '  --with-debug  --without-apache  --with-imap  --with-fpm'
#install_package php56-mcrypt ''
install_package pkg-config ''
install_package readline ''
install_package s-lang ''
install_package sbt ''
install_package scala ''
install_package tree ''
install_package unixodbc ''
install_package wdiff ''
install_package wget ''
install_package zlib ''
[ ! -z $failed_items ] && echo The following items were failed to install: && echo $failed_items
