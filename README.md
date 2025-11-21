# HyprDuma Dotfiles

Personal Hyprland configuration focused on productivity and ergonomics.

## Features

### Enhanced Keybindings
- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference

### Visual & UX
- Minimal gaps (10px/40px) for space efficiency
- Blur effects and transparency
- Smooth custom animations with bezier curves
- **Pywal integration** - Dynamic colors from wallpaper (optional)

### Input
- 3-finger gestures (horizontal: workspace, vertical: fullscreen)
- Dual keyboard layout (US/RU with `ALT + SHIFT` toggle)
- Numlock enabled by default
- Optimized touchpad scrolling

### Display Setup
- Dual monitor configuration (HDMI-A-1 flipped + eDP-1)
- Workspaces 1-4 on external monitor
- Workspaces 5-10 on laptop screen

---

## Complete Installation Guide

Follow these steps in order to install the complete setup from scratch.

### Step 1: Install Required Packages

```bash
# Core Hyprland components
sudo pacman -S hyprland hyprlock hyprshot wlogout

# Terminal emulator
sudo pacman -S kitty

# Status bar & Wallpaper manager
sudo pacman -S waybar swww waypaper hyprpaper

# Application launcher
sudo pacman -S wofi

# File manager
sudo pacman -S nautilus

# Audio control (PipeWire)
sudo pacman -S wireplumber pipewire-pulse

# Brightness control
sudo pacman -S brightnessctl

# Media player control
sudo pacman -S playerctl

# Cursor theme
sudo pacman -S adwaita-cursors

# Pywal for dynamic colors (optional but recommended)
sudo pacman -S python-pywal

# Install rust/cargo if you don't have it (needed for Caelestia)
sudo pacman -S rust
```

### Step 2: Install Optional Applications

```bash
# Applications referenced in config (adjust to your preference)
sudo pacman -S telegram-desktop spotify code

# AUR packages (requires yay or another AUR helper)
yay -S google-chrome zen-browser-bin  # or your preferred browser
```

### Step 3: Install Caelestia Shell (Optional)

Caelestia is a modern shell with AI features that integrates with the pywal theming system.

```bash
# Install Caelestia via cargo
cargo install caelestia

# Start Caelestia daemon (it will auto-restart when pywal colors change)
caelestia shell -d &
```

**Note:** Caelestia runs as a background service and integrates with pywal for dynamic color theming.

### Step 4: Clone This Repository

```bash
# Clone to a temporary location
cd ~/Downloads
git clone https://github.com/yourusername/hyprduma-config.git
cd hyprduma-config
```

### Step 5: Backup Existing Configs (If Any)

```bash
# Backup existing Hyprland config
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr.backup

# Backup existing waybar config
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar.backup

# Backup existing wlogout config
[ -d ~/.config/wlogout ] && mv ~/.config/wlogout ~/.config/wlogout.backup
```

### Step 6: Install Hyprland Configuration

```bash
# Create Hypr config directory
mkdir -p ~/.config/hypr

# Copy main config
cp hyprland.conf ~/.config/hypr/

# Create screenshots directory (used by config)
mkdir -p ~/Pictures/Screenshots
```

### Step 7: Configure Your Applications

**IMPORTANT:** Edit the config file to set your preferred applications.

```bash
# Open the config file
nvim ~/.config/hypr/hyprland.conf

# Find lines 27-34 and adjust these variables:
# $terminal = kitty              # Your terminal
# $fileManager = dolphin         # Your file manager
# $menu = wofi --show drun       # Your app launcher
# $telegram = Telegram           # Path to Telegram
# $spotify = spotify             # Path to Spotify
# $vscode = code                 # Path to VSCode
# $browser = your-browser        # Your browser command
```

### Step 8: Install Pywal Integration (Optional but Recommended)

Pywal provides dynamic color theming based on your wallpaper.

```bash
# Install pywal templates
mkdir -p ~/.config/wal/templates
cp -r wal/templates/* ~/.config/wal/templates/

# Copy the color application script
cp apply-pywal-colors.sh ~/.config/hypr/
chmod +x ~/.config/hypr/apply-pywal-colors.sh

# Test pywal with a wallpaper
wal -i /path/to/your/wallpaper.png

# Apply colors to Hyprland and Caelestia
~/.config/hypr/apply-pywal-colors.sh
```

**What this does:**
- Generates a color scheme from your wallpaper
- Applies colors to Hyprland window borders
- Applies colors to Caelestia shell (if installed)
- Restarts necessary services to apply changes

### Step 9: Install Waybar Config (If You Have It)

```bash
# If you have waybar configs in this repo
mkdir -p ~/.config/waybar
cp -r waybar/* ~/.config/waybar/
```

### Step 10: Install Wlogout Config (If You Have It)

```bash
# If you have wlogout configs in this repo
mkdir -p ~/.config/wlogout
cp -r wlogout/* ~/.config/wlogout/
```

### Step 11: Start Hyprland

```bash
# If you're in a TTY, start Hyprland
Hyprland

# If already in Hyprland, reload the config
# Press SUPER + SHIFT + R (or restart Hyprland session)
```

### Step 12: Set Up Autostart for Caelestia (Optional)

If you want Caelestia to start automatically with Hyprland:

```bash
# Edit your Hyprland config
nvim ~/.config/hypr/hyprland.conf

# Add this line in the Autostart section (around line 21-25):
# exec-once = caelestia shell -d
```

---

## Post-Installation

### Setting Wallpaper with Pywal

```bash
# Generate colors and apply them
wal -i /path/to/wallpaper.png && ~/.config/hypr/apply-pywal-colors.sh

# Or use waypaper GUI to select wallpapers
waypaper
```

### Monitor Configuration

If you have different monitors, adjust lines 4-18 in `~/.config/hypr/hyprland.conf`:

```bash
nvim ~/.config/hypr/hyprland.conf

# Edit monitor configuration:
# monitor = eDP-1, 1920x1080@144, 1920x0, 1
# monitor = HDMI-A-1, 1920x1080@144, 0x0, 1, transform, 2
```

### Keyboard Layout

Default is US/RU with ALT+SHIFT toggle. To change, edit `~/.config/hypr/hyprland.conf` line 42:

```
kb_layout = us, ru  # Change to your layouts
```

---

## Documentation

- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference
- **[PYWAL-SETUP.md](PYWAL-SETUP.md)** - Detailed pywal integration guide

---

## Troubleshooting

### Hyprland won't start
- Check if all required packages are installed
- Review error logs: `journalctl -b | grep hyprland`

### Applications don't launch
- Make sure you edited the app variables in `hyprland.conf` (lines 27-34)
- Check if the applications are actually installed

### Pywal colors not applying
- Ensure the script is executable: `chmod +x ~/.config/hypr/apply-pywal-colors.sh`
- Check if pywal cache exists: `ls ~/.cache/wal/`
- Manually reload: `~/.config/hypr/apply-pywal-colors.sh`

### Caelestia colors not updating
```bash
# Restart Caelestia daemon
pkill caelestia && sleep 0.5 && caelestia shell -d &
```

---

## Note

Everything is still in progress. Feel free to customize and adjust to your needs!
