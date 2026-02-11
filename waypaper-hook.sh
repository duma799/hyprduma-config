#!/bin/bash
# Waypaper hook - applies pywal colors on wallpaper change

LOCK_FILE="/tmp/waypaper-hook.lock"
LOG_FILE="/tmp/waypaper-hook.log"

if [ -f "$LOCK_FILE" ]; then
    LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null)
    if [ -n "$LOCK_PID" ] && kill -0 "$LOCK_PID" 2>/dev/null; then
        echo "Hook already running (PID: $LOCK_PID), skipping..." >> "$LOG_FILE"
        exit 0
    fi
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

echo "=== Waypaper hook triggered at $(date) ===" >> "$LOG_FILE"

sleep 0.5

# Get wallpaper from waypaper config
WALLPAPER=$(grep "^wallpaper = " ~/.config/waypaper/config.ini | cut -d' ' -f3-)
WALLPAPER="${WALLPAPER/#\~/$HOME}"

# Fallback: swaybg process
if [ ! -f "$WALLPAPER" ]; then
    WALLPAPER=$(pgrep -a swaybg | grep -oP '(?<=-i )[^ ]+' | head -1)
fi

if [ -f "$WALLPAPER" ]; then
    echo "Applying pywal for wallpaper: $WALLPAPER" >> "$LOG_FILE"

    wal -i "$WALLPAPER" --backend wal -n -s -t >> "$LOG_FILE" 2>&1

    (
        if [ -f ~/.cache/wal/caelestia-scheme.json ]; then
            mkdir -p ~/.local/state/caelestia
            cp ~/.cache/wal/caelestia-scheme.json ~/.local/state/caelestia/scheme.json
            mkdir -p ~/.local/state/caelestia/wallpaper
            ln -sf "$WALLPAPER" ~/.local/state/caelestia/wallpaper/current
            echo "$WALLPAPER" > ~/.local/state/caelestia/wallpaper/path.txt
        fi

        if pgrep -x "caelestia" > /dev/null; then
            pkill caelestia
            sleep 0.5
            caelestia shell -d &
        fi

        hyprctl reload > /dev/null 2>&1

        if pgrep -x "kitty" > /dev/null; then
            killall -SIGUSR1 kitty 2>/dev/null
        fi

        if command -v wal-gtk &> /dev/null; then
            wal-gtk >> "$LOG_FILE" 2>&1
        fi

        if command -v gsettings &> /dev/null; then
            gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null
        fi

        if command -v pywalfox &> /dev/null; then
            pywalfox update &>/dev/null &
        fi
    ) >> "$LOG_FILE" 2>&1

    echo "✓ Waypaper hook completed at $(date)" >> "$LOG_FILE"
else
    echo "✗ Wallpaper file not found: $WALLPAPER" >> "$LOG_FILE"
    exit 1
fi
