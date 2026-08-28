#!/bin/sh
set -eu
umask 022

base_url="https://archive.netbsd.org/pub/NetBSD-archive/NetBSD-9.0/source/sets"

fetch_and_extract() {
    set_name="$1"
    marker="$2"
    archive="${set_name}.tgz"

    if [ -e "$marker" ]; then
        echo "${set_name}: already extracted; skipping"
        return 0
    fi

    if [ -f "$archive" ]; then
        echo "${set_name}: archive already exists; skipping download"
    else
        echo "${set_name}: fetching..."
        ftp -V -o "$archive" "${base_url}/${archive}"
    fi

    echo "${set_name}: extracting..."
    tar zxf "$archive" -C .
    echo "${set_name}: complete"
}

fetch_and_extract gnusrc ./usr/src/gnu &
gnusrc_pid=$!
fetch_and_extract sharesrc ./usr/src/share &
sharesrc_pid=$!
fetch_and_extract src ./usr/src/bin &
src_pid=$!
fetch_and_extract syssrc ./usr/src/sys &
syssrc_pid=$!

failed=0
if ! wait "$gnusrc_pid"; then failed=1; fi
if ! wait "$sharesrc_pid"; then failed=1; fi
if ! wait "$src_pid"; then failed=1; fi
if ! wait "$syssrc_pid"; then failed=1; fi

if [ "$failed" -ne 0 ]; then
    echo "One or more source sets failed; inspect the output and rerun." >&2
    exit 1
fi
