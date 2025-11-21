# HyprDuma Dotfiles

Personal Hyprland configuration focused on productivity and ergonomics.

## Features

### Enhanced Keybindings
- See in KEYBINDS.md (link below)
- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference

### Visual & UX
- Minimal gaps (3.5px/4.5px) for space efficiency
- Blur effects on waybar (in progress)
- Smooth custom animations with bezier curves
- Automatic floating for file pickers and dialogs (in progress)
- Picture-in-Picture auto-positioning (in progress)
- **Pywal integration** - Dynamic colors from wallpaper (optional)

### Input
- 3-finger gestures (horizontal: workspace, vertical: fullscreen)
- Dual keyboard layout (US/RU with `ALT + SHIFT` toggle)
- Numlock enabled by default
- Optimized touchpad scrolling

### Display Setup
- Dual monitor configuration (HDMI-A-1 flipped + eDP-1)
- Workspaces 1-4 on external monitor
- Workspace 5 on laptop screen

## Quick Start

### Requirements
```bash
# Core Hyprland components
sudo pacman -S hyprland hyprlock hyprshot wlogout

# Terminal & Shell
sudo pacman -S kitty

# Status bar & Wallpaper
sudo pacman -S waybar swww waypaper

# Application launcher
sudo pacman -S wofi

# File manager (GNOME)
sudo pacman -S nautilus

# Audio control (PipeWire)
sudo pacman -S wireplumber pipewire-pulse

# Brightness control
sudo pacman -S brightnessctl

# Media player control
sudo pacman -S playerctl

# Optional applications (adjust in config)
sudo pacman -S telegram-desktop spotify code  # Telegram, Spotify, VSCode
yay -S google-chrome  # Browser (AUR)

# Cursor theme
sudo pacman -S adwaita-cursors
```

### Installation
```bash
# Backup existing config
mv ~/.config/hypr ~/.config/hypr.backup

# Create directory (if do not have already) and copy config
mkdir -p ~/.config/hypr
cp hyprland.conf ~/.config/hypr/

# Adjust your apps (lines 26-32) HIGHLY RECOMMENDED!!!
nvim ~/.config/hypr/hyprland.conf

# Reload or restart Hyprland
```
## Documentation

- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference
- **[PYWAL-SETUP.md](PYWAL-SETUP.md)** - Pywal color integration setup guide (optional)

## Optional: Pywal Integration

This config includes optional pywal integration for dynamic theming based on your wallpaper. See [PYWAL-SETUP.md](PYWAL-SETUP.md) for installation and usage instructions.

**Quick setup:**
```bash
# Install pywal
sudo pacman -S python-pywal

# Copy templates and script
mkdir -p ~/.config/wal/templates
cp wal/templates/* ~/.config/wal/templates/
cp apply-pywal-colors.sh ~/.config/hypr/
chmod +x ~/.config/hypr/apply-pywal-colors.sh

# Generate colors from wallpaper
wal -i /path/to/wallpaper.png && ~/.config/hypr/apply-pywal-colors.sh
```

## Note

Everything is still in progress.
