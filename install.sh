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
    echo "Manually copy hassh.lua and lib/md5.lua into your Wireshark plugins directory." >&2
    exit 1
    ;;
esac

mkdir -p "$DEST/lib"
cp hassh.lua "$DEST/"
cp lib/md5.lua "$DEST/lib/"

echo "Installed to: $DEST"
echo "Restart Wireshark, then go to Analyze → Reload Lua Plugins."
