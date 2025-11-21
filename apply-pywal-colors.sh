#!/bin/bash
# Script to apply pywal colors to Hyprland and Caelestia shell

# Generate pywal colors (this assumes you've already run 'wal -i /path/to/wallpaper')
# The templates will be automatically processed

echo "Applying pywal colors to Hyprland and Caelestia..."

# Update Caelestia's wallpaper reference to match the one pywal used
if [ -f ~/.cache/wal/wal ]; then
    WALLPAPER_PATH=$(cat ~/.cache/wal/wal)
    mkdir -p ~/.local/state/caelestia/wallpaper
    ln -sf "$WALLPAPER_PATH" ~/.local/state/caelestia/wallpaper/current
    echo "$WALLPAPER_PATH" > ~/.local/state/caelestia/wallpaper/path.txt
    echo "✓ Caelestia wallpaper reference updated"
fi

# Copy the generated Caelestia scheme to the proper location
if [ -f ~/.cache/wal/caelestia-scheme.json ]; then
    mkdir -p ~/.local/state/caelestia
    cp ~/.cache/wal/caelestia-scheme.json ~/.local/state/caelestia/scheme.json
    echo "✓ Caelestia colors updated"
fi

# Reload Hyprland configuration
if command -v hyprctl &> /dev/null; then
    hyprctl reload
    echo "✓ Hyprland configuration reloaded"
fi

# Restart Caelestia shell to apply new colors
if pgrep -x "caelestia" > /dev/null; then
    pkill caelestia
    sleep 0.5
    caelestia shell -d &
    echo "✓ Caelestia shell restarted"
fi

echo "Done! Colors applied successfully."
