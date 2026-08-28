#!/bin/sh

set -eu

echo "== NetBSD release =="
uname -a
uname -r

if [ "$(uname -r | cut -d. -f1)" != "9" ]; then
    echo "Expected NetBSD 9.x, found: $(uname -r)" >&2
    exit 1
fi

echo "== Compiler =="
if ! command -v gcc >/dev/null 2>&1; then
    echo "gcc is not present in the NetBSD base system" >&2
    exit 1
fi

gcc --version | sed -n '1p'
gcc_version="$(gcc -dumpfullversion 2>/dev/null || gcc -dumpversion)"
case "$gcc_version" in
    7.5.0|7.4) ;;
    *)
        echo "Expected GCC 7.4.x, found: $gcc_version" >&2
        exit 1
        ;;
esac

echo "== Build tools =="
for command in make ar nm ld sh awk sed grep; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "Missing required command: $command" >&2
        exit 1
    fi
done

echo "== Installing APUE tools =="
if ! command -v pkgin >/dev/null 2>&1; then
    echo "pkgin is required to install the APUE tools" >&2
    exit 1
fi

pkgin -y update
pkgin -y install git gdb tmux vim less curl

cat <<'EOF'

APUE NetBSD lab is ready.
Run: vagrant ssh
Clone the lab repository into your home directory, then create any working
directories you need.
EOF
