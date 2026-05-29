#!/usr/bin/env bash
set -e

OS="$(uname -s)"
case "$OS" in
  Linux)
    DEST="$HOME/.local/lib/wireshark/plugins/hassh"
    ;;
  Darwin)
    DEST="$HOME/Library/Application Support/Wireshark/plugins/hassh"
    ;;
  *)
    echo "Unsupported OS: $OS" >&2
    echo "Manually remove the hassh directory from your Wireshark plugins directory." >&2
    exit 1
    ;;
esac

rm -rf "$DEST"
echo "Uninstalled from: $DEST"
