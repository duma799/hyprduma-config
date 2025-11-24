#!/bin/bash
# Extended pywal script with system-wide theme support
# Usage: ./pywal.sh [wallpaper_path] [light|dark]
# Examples:
#   ./pywal.sh ~/Pictures/wallpaper.jpg       # Apply dark theme
#   ./pywal.sh ~/Pictures/wallpaper.jpg light # Apply light theme
#   ./pywal.sh                                # Just refresh themes (use existing wallpaper)

WALLPAPER="$1"
LIGHT_MODE="$2"

echo "Applying pywal colors system-wide..."

# Generate pywal colors
if [ -n "$WALLPAPER" ]; then
    # New wallpaper provided
    if [ "$LIGHT_MODE" = "-l" ] || [ "$LIGHT_MODE" = "light" ]; then
        wal -i "$WALLPAPER" -l
        DARK_MODE=0
        GTK_THEME="prefer-light"
        echo "✓ Generated light theme from wallpaper"
    else
        wal -i "$WALLPAPER"
        DARK_MODE=1
        GTK_THEME="prefer-dark"
        echo "✓ Generated dark theme from wallpaper"
    fi
elif [ "$LIGHT_MODE" = "light" ] || [ "$LIGHT_MODE" = "-l" ]; then
    # No wallpaper, just switch to light mode
    wal -l
    DARK_MODE=0
    GTK_THEME="prefer-light"
    echo "✓ Switched to light theme"
elif [ "$LIGHT_MODE" = "dark" ]; then
    # No wallpaper, just switch to dark mode
    wal
    DARK_MODE=1
    GTK_THEME="prefer-dark"
    echo "✓ Switched to dark theme"
else
    # No arguments, just refresh with existing colors
    if [ -f ~/.cache/wal/wal ]; then
        wal -R
        # Detect if current theme is light or dark
        BG_COLOR=$(grep -oP 'background.*#\K[0-9A-Fa-f]{6}' ~/.cache/wal/colors.json | head -1)
        if [ -n "$BG_COLOR" ]; then
            # Convert hex to decimal and check brightness
            R=$((16#${BG_COLOR:0:2}))
            G=$((16#${BG_COLOR:2:2}))
            B=$((16#${BG_COLOR:4:2}))
            BRIGHTNESS=$(( (R + G + B) / 3 ))
            if [ $BRIGHTNESS -gt 128 ]; then
                DARK_MODE=0
                GTK_THEME="prefer-light"
            else
                DARK_MODE=1
                GTK_THEME="prefer-dark"
            fi
        fi
        echo "✓ Refreshed existing theme"
    else
        echo "✗ No wallpaper specified and no existing theme found"
        exit 1
    fi
fi

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

# Generate GTK themes from PyWal colors
if command -v wal-gtk &> /dev/null; then
    wal-gtk
    echo "✓ GTK themes generated"
else
    echo "ℹ wal-gtk not found - install 'wal-gtk-theme-git' for GTK theme support"
fi

# Set GNOME/GTK dark mode preference (affects browsers and GTK apps)
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme "$GTK_THEME" 2>/dev/null && \
        echo "✓ System dark mode preference set to: $GTK_THEME" || \
        echo "ℹ Could not set GTK color scheme preference"
fi

# Update Firefox theme via pywalfox
if command -v pywalfox &> /dev/null; then
    pywalfox update &>/dev/null &
    echo "✓ Firefox theme update triggered"
else
    echo "ℹ pywalfox not found - install 'python-pywalfox' for Firefox support"
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

# Reload all running Kitty instances
if command -v kitty &> /dev/null; then
    if pgrep -x "kitty" > /dev/null; then
        killall -SIGUSR1 kitty 2>/dev/null
        echo "✓ Kitty terminal colors reloaded"
    fi
fi

echo ""
echo "Done! Theme applied system-wide."
echo "Current mode: $([ "$DARK_MODE" = "1" ] && echo "Dark" || echo "Light")"
