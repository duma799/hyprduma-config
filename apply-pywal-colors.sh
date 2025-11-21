#!/bin/bash
# Script to apply pywal colors to Hyprland and Caelestia shell

echo "Applying pywal colors to Hyprland and Caelestia..."

if [ -f ~/.cache/wal/caelestia-scheme.json ]; then
    mkdir -p ~/.local/state/caelestia
    cp ~/.cache/wal/caelestia-scheme.json ~/.local/state/caelestia/scheme.json
    echo "✓ Caelestia colors updated"
fi

if command -v hyprctl &> /dev/null; then
    hyprctl reload
    echo "✓ Hyprland configuration reloaded"
fi

if pgrep -x "caelestia" > /dev/null; then
    pkill caelestia
    sleep 0.5
    caelestia shell -d &
    echo "✓ Caelestia shell restarted"
fi

echo "Done! Colors applied successfully."
