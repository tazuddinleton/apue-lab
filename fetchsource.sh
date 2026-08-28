#!/bin/sh
set -eu
umask 022

base_url="https://archive.netbsd.org/pub/NetBSD-archive/NetBSD-9.0/source/sets"

for set in gnusrc sharesrc src syssrc; do
    echo "Fetching ${set}..."
    ftp -V -o "${set}.tgz" "${base_url}/${set}.tgz"
    echo "Extracting ${set}..."
    sudo tar zxf ${set}.tgz -C /
    rm -f "${set}".tgz

done
