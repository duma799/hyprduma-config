#!/bin/bash
# HyprDuma Config - Quick Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/duma799/hyprduma-config/master/install.sh | bash

set -e

REPO="https://github.com/duma799/hyprduma-config.git"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo -e "\033[36m=> Downloading HyprDuma config...\033[0m"

if ! command -v git &>/dev/null; then
    echo -e "\033[31mError: git is not installed. Run: sudo pacman -S git\033[0m"
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo -e "\033[31mError: python3 is not installed. Run: sudo pacman -S python\033[0m"
    exit 1
fi

git clone --depth 1 "$REPO" "$TMPDIR/hyprduma-config" 2>/dev/null

echo -e "\033[36m=> Launching installer...\033[0m\n"

# </dev/tty reconnects stdin to the terminal so interactive prompts work
# even when this script is piped from curl
python3 "$TMPDIR/hyprduma-config/install.py" </dev/tty
