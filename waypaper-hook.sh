#!/bin/bash
# Waypaper post-change hook - automatically applies pywal colors when wallpaper changes
# This runs every time you change wallpaper in waypaper

# Lock file to prevent multiple simultaneous runs
LOCK_FILE="/tmp/waypaper-hook.lock"
LOG_FILE="/tmp/waypaper-hook.log"

# Check if already running
if [ -f "$LOCK_FILE" ]; then
    # Check if the process is actually running
    LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null)
    if [ -n "$LOCK_PID" ] && kill -0 "$LOCK_PID" 2>/dev/null; then
        echo "Hook already running (PID: $LOCK_PID), skipping..." >> "$LOG_FILE"
        exit 0
    fi
fi

# Create lock file
echo $$ > "$LOCK_FILE"

# Cleanup lock file on exit
trap "rm -f $LOCK_FILE" EXIT

echo "=== Waypaper hook triggered at $(date) ===" >> "$LOG_FILE"

# Wait a moment for waypaper to finish writing config
sleep 0.5

# Method 1: Get wallpaper from waypaper config
WALLPAPER=$(grep "^wallpaper = " ~/.config/waypaper/config.ini | cut -d' ' -f3-)
WALLPAPER="${WALLPAPER/#\~/$HOME}"

# Method 2: Get from swaybg process as fallback
if [ ! -f "$WALLPAPER" ]; then
    echo "Trying to get wallpaper from swaybg process..." >> "$LOG_FILE"
    WALLPAPER=$(pgrep -a swaybg | grep -oP '(?<=-i )[^ ]+' | head -1)
fi

if [ -f "$WALLPAPER" ]; then
    echo "Applying pywal for wallpaper: $WALLPAPER" >> "$LOG_FILE"

    # Generate pywal colors from new wallpaper
    # Use --backend wal to avoid hanging, -n to skip setting wallpaper, -s to skip reloading
    wal -i "$WALLPAPER" --backend wal -n -s -t >> "$LOG_FILE" 2>&1

    # Apply colors system-wide (run in background to avoid blocking)
    (
        # Update Caelestia
        if [ -f ~/.cache/wal/caelestia-scheme.json ]; then
            mkdir -p ~/.local/state/caelestia
            cp ~/.cache/wal/caelestia-scheme.json ~/.local/state/caelestia/scheme.json
            # Sync Caelestia wallpaper
            mkdir -p ~/.local/state/caelestia/wallpaper
            ln -sf "$WALLPAPER" ~/.local/state/caelestia/wallpaper/current
            echo "$WALLPAPER" > ~/.local/state/caelestia/wallpaper/path.txt
        fi

        # Restart Caelestia shell
        if pgrep -x "caelestia" > /dev/null; then
            pkill caelestia
            sleep 0.5
            caelestia shell -d &
        fi

        # Reload Hyprland
        hyprctl reload > /dev/null 2>&1

        # Reload all running Kitty instances
        if pgrep -x "kitty" > /dev/null; then
            killall -SIGUSR1 kitty 2>/dev/null
        fi

        # Update GTK themes if available
        if command -v wal-gtk &> /dev/null; then
            wal-gtk >> "$LOG_FILE" 2>&1
        fi

        # Set GTK dark mode preference if available
        if command -v gsettings &> /dev/null; then
            gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null
        fi

        # Update Firefox if available
        if command -v pywalfox &> /dev/null; then
            pywalfox update &>/dev/null &
        fi
    ) >> "$LOG_FILE" 2>&1

    echo "✓ Waypaper hook completed at $(date)" >> "$LOG_FILE"
else
    echo "✗ Wallpaper file not found: $WALLPAPER" >> "$LOG_FILE"
    exit 1
fi
