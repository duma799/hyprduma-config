# Pywal Color Integration Setup

This dotfiles repository includes pywal integration for dynamic color theming based on your wallpaper. The setup works with both Hyprland borders and Caelestia shell.

## Prerequisites

- `pywal` (python-pywal) installed
- Hyprland window manager
- Caelestia shell (optional, for full integration)

## Installation

### 1. Install pywal

```bash
# Arch Linux
sudo pacman -S python-pywal

# Or via pip
pip install pywal
```

### 2. Copy Template Files

Copy the pywal template files to your config directory:

```bash
# Create templates directory if it doesn't exist
mkdir -p ~/.config/wal/templates

# Copy Hyprland border colors template
cp wal/templates/hyprland-colors.conf ~/.config/wal/templates/

# Copy Caelestia color scheme template (if using Caelestia)
cp wal/templates/caelestia-scheme.json ~/.config/wal/templates/
```

### 3. Copy the Apply Script

```bash
# Copy the color application script to your hypr config
cp pywal.sh ~/.config/hypr/

# Make it executable
chmod +x ~/.config/hypr/pywal.sh

# Also copy to home directory for easier access
cp pywal.sh ~/pywal.sh
chmod +x ~/pywal.sh
```

### 4. Link Hyprland Config

If you haven't already, link the Hyprland config:

```bash
# Backup existing config if needed
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup

# Link the new config
ln -s ~/hyprduma-config/hyprland.conf ~/.config/hypr/hyprland.conf
```

## Usage

### Generate Colors from Wallpaper

```bash
# Generate color palette from a wallpaper
wal -i /path/to/your/wallpaper.png

# Apply the generated colors to Hyprland and Caelestia (from anywhere)
~/pywal.sh
```

### Quick Apply (One Command)

```bash
# Generate and apply in one go
wal -i /path/to/wallpaper.png && ~/pywal.sh
```

### Regenerate from Current Wallpaper

```bash
# Regenerate colors from cached wallpaper
wal -R && ~/pywal.sh
```

## What Gets Themed

### Hyprland
- **Active window borders**: Gradient using pywal colors 4 and 6
- **Inactive window borders**: Using pywal color 8 (muted gray tone)

### Caelestia Shell (if installed)
- Complete Material Design 3 color scheme
- Terminal colors (color0-color15)
- Background, surface, and accent colors
- All UI elements adapt to wallpaper colors

## Files Structure

```
hyprduma-config/
├── hyprland.conf                    # Main config with pywal integration
├── pywal.sh                         # Script to apply colors (easy name!)
└── wal/
    └── templates/
        ├── hyprland-colors.conf     # Hyprland border colors template
        └── caelestia-scheme.json    # Caelestia color scheme template
```

## Customization

### Changing Border Color Mapping

Edit `~/.config/wal/templates/hyprland-colors.conf`:

```conf
# Example: Use different colors for borders
general {
    col.active_border = rgba({color2.strip}ee) rgba({color5.strip}ee) 45deg
    col.inactive_border = rgba({color0.strip}aa)
}
```

Available variables:
- `{color0}` through `{color15}` - Palette colors
- `{background}` - Background color
- `{foreground}` - Foreground/text color
- `{cursor}` - Cursor color

After editing, regenerate colors with `wal -R`.

### Modifying Caelestia Colors

Edit `~/.config/wal/templates/caelestia-scheme.json` to change how pywal colors map to Caelestia's Material Design 3 scheme.

## Automation

### Auto-apply on Hyprland Startup

The colors are automatically loaded via the `source` directive in `hyprland.conf`. However, to regenerate on startup:

```bash
# Add to hyprland.conf autostart section
exec-once = wal -R -n
```

### Integrate with Wallpaper Managers

If using `waypaper`, `hyprpaper`, or similar:

```bash
# Create a wrapper script that sets wallpaper and applies colors
#!/bin/bash
# Set wallpaper with your tool of choice
hyprctl hyprpaper wallpaper "eDP-1,/path/to/wallpaper.png"

# Generate and apply pywal colors
wal -i /path/to/wallpaper.png && ~/pywal.sh
```

## Troubleshooting

### Colors not updating in Hyprland

```bash
# Reload Hyprland configuration
hyprctl reload
```

### Colors not updating in Caelestia

```bash
# Restart Caelestia shell
pkill caelestia && sleep 0.5 && caelestia shell -d &
```

### Hyprland fails to start (source file not found)

If pywal hasn't been run yet, the source file won't exist. Either:

1. Run `wal -i /path/to/wallpaper.png` once to generate initial colors
2. Or comment out the `source` line in `hyprland.conf` until you set up pywal

### Check Generated Files

```bash
# View generated Hyprland colors
cat ~/.cache/wal/hyprland-colors.conf

# View generated Caelestia scheme
cat ~/.cache/wal/caelestia-scheme.json

# View pywal color palette
cat ~/.cache/wal/colors.json
```

## Pywal Backend Options

Pywal supports different color extraction backends:

```bash
# Use imagemagick (default)
wal -i /path/to/wallpaper.png

# Use colorz (more vibrant colors)
wal -i /path/to/wallpaper.png --backend colorz

# Use colorthief
wal -i /path/to/wallpaper.png --backend colorthief

# Use haishoku
wal -i /path/to/wallpaper.png --backend haishoku
```
