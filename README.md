# HyprDuma Dotfiles

Personal Hyprland configuration focused on productivity and ergonomics.

## Features

### Enhanced Keybindings
- **See in KEYBINDS.md (link below)
- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference

### Visual & UX
- Minimal gaps (3.5px/4.5px) for space efficiency
- Blur effects on waybar (in progress)
- Smooth custom animations with bezier curves
- Automatic floating for file pickers and dialogs (in progress)
- Picture-in-Picture auto-positioning (in progress)

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
# Arch Linux
sudo pacman -S hyprland kitty waybar hyprpaper wofi \
               brightnessctl playerctl wl-clipboard
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

## Note

Everything is still in progress.
