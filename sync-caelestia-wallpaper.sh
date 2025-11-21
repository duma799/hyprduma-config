#!/bin/bash
# Sync Caelestia's wallpaper reference with the currently running swaybg wallpaper

# Get the wallpaper path from running swaybg process
WALLPAPER_PATH=$(pgrep -a swaybg | grep -oP '(?<=-i )[^ ]+' | head -1)

if [ -n "$WALLPAPER_PATH" ] && [ -f "$WALLPAPER_PATH" ]; then
    mkdir -p ~/.local/state/caelestia/wallpaper
    ln -sf "$WALLPAPER_PATH" ~/.local/state/caelestia/wallpaper/current
    echo "$WALLPAPER_PATH" > ~/.local/state/caelestia/wallpaper/path.txt
    echo "✓ Caelestia wallpaper synced to: $WALLPAPER_PATH"
else
    echo "⚠ Could not detect swaybg wallpaper"
fi
