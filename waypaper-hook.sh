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

    # Resolve pywal.sh location (same directory as this hook, or ~/pywal.sh)
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    PYWAL_SCRIPT="$SCRIPT_DIR/pywal.sh"
    if [ ! -f "$PYWAL_SCRIPT" ]; then
        PYWAL_SCRIPT="$HOME/pywal.sh"
    fi

    if [ -f "$PYWAL_SCRIPT" ]; then
        bash "$PYWAL_SCRIPT" "$WALLPAPER" >> "$LOG_FILE" 2>&1
    else
        echo "✗ pywal.sh not found" >> "$LOG_FILE"
        exit 1
    fi

    echo "✓ Waypaper hook completed at $(date)" >> "$LOG_FILE"
else
    echo "✗ Wallpaper file not found: $WALLPAPER" >> "$LOG_FILE"
    exit 1
fi
