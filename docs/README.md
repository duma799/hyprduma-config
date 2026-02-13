# HyprDuma Dotfiles

https://github.com/user-attachments/assets/17ff7195-82e0-4b48-9309-1a5ec9d6e5a4

Personal Hyprland configuration focused on productivity and ergonomics.

## Features

### Enhanced Keybindings
- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference

### Visual & UX
- Minimal gaps (10px/40px) for space efficiency
- Transparency with configurable opacity (active: 0.985, inactive: 0.85)
- Smooth custom animations with bezier curves
- **Pywal integration** - Dynamic system-wide colors from wallpaper
- **Caelestia shell** integration for dynamic theming and AI features

### Input
- 3-finger gestures (horizontal: workspace, vertical: fullscreen)
- Dual keyboard layout (US/RU with `ALT + SHIFT` toggle)
- Numlock enabled by default
- Optimized touchpad scrolling

### Display Setup
- Auto-detected monitor configuration (works with any setup out of the box)
- Workspaces 1-4 on external monitor, 5-10 on laptop screen
- **Monitor handler** - automatically restores wallpaper and Caelestia shell after config reload

### Automation
- **Auto-installer** - interactive Python installer handles the entire setup
- **Waypaper hook** - pywal colors auto-apply when wallpaper changes via waypaper GUI
- **Monitor handler** - listens for Hyprland config reloads and restarts swaybg/Caelestia
- **Fastfetch config** - custom system info display with ASCII art

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/duma799/hyprduma-config/master/install.sh | bash
```

Or manually:
```bash
git clone https://github.com/duma799/hyprduma-config.git ~/Downloads/hyprduma-config
python3 ~/Downloads/hyprduma-config/install.py
```

The interactive installer handles everything:
1. AUR helpers (yay/paru)
2. Required packages via pacman
3. Caelestia shell
4. Config backup and installation
5. Pywal integration (templates, scripts, bashrc, initial colors)
6. Waypaper hook for automatic color application
7. Monitor handler for config reload resilience
8. Fastfetch config with custom ASCII art

---

## Manual Installation Guide

If you prefer to install manually instead of using the auto-installer, follow these steps.

### Prerequisites: Install AUR Helpers (Optional but Recommended)

```bash
# Install yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd .. && rm -rf yay

# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si && cd .. && rm -rf paru
```

### Step 1: Install Required Packages

```bash
sudo pacman -S hyprland hyprlock hyprshot wlogout kitty waybar swaybg waypaper wofi nautilus wireplumber pipewire-pulse brightnessctl playerctl adwaita-cursors python-pywal fastfetch
```

### Step 2: Install Caelestia Shell (Recommended)

```bash
yay -S caelestia-shell
```

### Step 3: Clone and Install Config

```bash
cd ~/Downloads
git clone https://github.com/duma799/hyprduma-config.git
cd hyprduma-config

# Backup existing configs
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr.backup
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar.backup
[ -d ~/.config/wlogout ] && mv ~/.config/wlogout ~/.config/wlogout.backup

# Install Hyprland config
mkdir -p ~/.config/hypr
cp hyprland.conf ~/.config/hypr/
cp -r wallpapers ~/.config/hypr/
mkdir -p ~/Pictures/Screenshots
```

### Step 4: Install Scripts

```bash
# Copy all scripts
cp pywal.sh sync-caelestia-wallpaper.sh waypaper-hook.sh ~/.config/hypr/
cp monitor-handler.py ~/.config/hypr/
chmod +x ~/.config/hypr/pywal.sh ~/.config/hypr/sync-caelestia-wallpaper.sh ~/.config/hypr/waypaper-hook.sh

# Copy pywal.sh to home for convenience
cp pywal.sh ~/pywal.sh && chmod +x ~/pywal.sh
```

### Step 5: Configure Your Applications

Edit `~/.config/hypr/hyprland.conf` and adjust the app variables (lines 28-34):

```
$terminal = kitty
$fileManager = nautilus
$menu = wofi --show drun
$telegram = Telegram
$spotify = spotify
$vscode = code
$browser = your-browser
```

### Step 6: Install Pywal Integration

```bash
# Install pywal templates
mkdir -p ~/.config/wal/templates
cp -r wal/templates/* ~/.config/wal/templates/

# Setup Kitty terminal
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/

# Add pywal to bashrc
cat >> ~/.bashrc << 'EOF'

# Import pywal colorscheme from cache
(cat ~/.cache/wal/sequences &)

# To add support for TTYs (optional)
source ~/.cache/wal/colors-tty.sh 2>/dev/null
EOF

# Generate initial colors
wal -i wallpapers/sakura.jpg && ~/pywal.sh
source ~/.bashrc
```

### Step 7: Configure Waypaper Hook

The waypaper hook automatically applies pywal colors whenever you change wallpaper through the waypaper GUI.

```bash
# Set waypaper-hook.sh as waypaper's post_command
mkdir -p ~/.config/waypaper
# Add to ~/.config/waypaper/config.ini under [Settings]:
# post_command = /home/YOUR_USER/.config/hypr/waypaper-hook.sh
```

### Step 8: Install Fastfetch Config (Optional)

```bash
cp -r fastfetch ~/.config/fastfetch

# Fix hardcoded paths for your user
sed -i "s|/home/duma/|$HOME/|g" ~/.config/fastfetch/config.jsonc
```

### Step 9: Start Hyprland

```bash
# From TTY
Hyprland

# Or if already running, reload config
# Press SUPER + SHIFT + R
```

---

## Post-Installation

### Setting Wallpaper

**Using waypaper GUI (recommended):**
- Press `Super+W` to open waypaper
- Select a wallpaper - the **waypaper hook** automatically runs pywal and syncs colors to all components (Hyprland, Caelestia, Kitty, GTK, Firefox)

**Using command line:**
```bash
wal -i /path/to/wallpaper.png && ~/pywal.sh
```

**How wallpaper management works:**
- **swaybg** is the wallpaper backend (not hyprpaper)
- **waypaper** GUI sets the wallpaper and triggers `waypaper-hook.sh` as a post-command
- The hook runs pywal, syncs Caelestia colors/wallpaper, reloads Hyprland, and updates GTK/Firefox themes
- **sync-caelestia-wallpaper.sh** syncs Caelestia's wallpaper reference with swaybg on startup
- **monitor-handler.py** listens for config reloads and restores swaybg/Caelestia if they get killed

### System-Wide Theme Syncing

The `pywal.sh` script supports dark/light mode and system-wide theme synchronization (GTK, Firefox, Qt). See **[PYWAL-SETUP.md](PYWAL-SETUP.md)** for the full guide including optional enhancements, light/dark theme switching, and backend options.

```bash
~/pywal.sh ~/Pictures/wallpaper.jpg          # Dark theme (default)
~/pywal.sh ~/Pictures/wallpaper.jpg light    # Light theme
~/pywal.sh "" dark                            # Switch mode, keep wallpaper
~/pywal.sh                                    # Refresh current theme
```

### Monitor Configuration

The default config uses auto-detection which works with any monitor setup:

```
monitor = , preferred, auto, 1
```

To customize for specific monitors, edit `~/.config/hypr/hyprland.conf` (line 4):

```bash
# Example: dual monitor with specific resolution
monitor = eDP-1, 1920x1080@144, 1920x0, 1
monitor = HDMI-A-1, 1920x1080@144, 0x0, 1, transform, 2
```

Workspace assignment (lines 7-17) distributes workspaces 1-4 to the external monitor and 5-10 to the laptop screen.

### Monitor Handler

The `monitor-handler.py` script runs in the background and listens for Hyprland config reloads. When a reload is detected, it checks if swaybg and Caelestia are still running, and restarts them if needed. This prevents losing your wallpaper or shell after editing the config.

### Keyboard Layout

Default is US/RU with ALT+SHIFT toggle. To change, edit the input section in `~/.config/hypr/hyprland.conf`:

```
kb_layout = us, ru  # Change to your layouts
```

---

## Project Structure

```
hyprduma-config/
├── hyprland.conf              # Main Hyprland configuration
├── pywal.sh                   # Apply pywal colors to all components
├── waypaper-hook.sh           # Auto-apply colors on wallpaper change
├── sync-caelestia-wallpaper.sh # Sync swaybg wallpaper to Caelestia
├── monitor-handler.py         # Restart wallpaper/shell after config reload
├── install.py                 # Interactive auto-installer
├── install.sh                 # Curl one-liner bootstrap script
├── wallpapers/                # Included wallpapers
├── wal/templates/             # Pywal templates for Hyprland & Caelestia
├── kitty/kitty.conf           # Kitty terminal config with pywal support
├── fastfetch/                 # Custom fastfetch config with ASCII art
├── KEYBINDS.md                # Complete keybindings reference
└── PYWAL-SETUP.md             # Detailed pywal integration guide
```

## Documentation

- **[KEYBINDS.md](KEYBINDS.md)** - Complete keybindings reference
- **[PYWAL-SETUP.md](PYWAL-SETUP.md)** - Detailed pywal integration guide

---

## Troubleshooting

### Hyprland won't start
- Check if all required packages are installed
- Review error logs: `journalctl -b | grep hyprland`

### Applications don't launch
- Make sure you edited the app variables in `hyprland.conf` (lines 28-34)
- Check if the applications are actually installed

### Pywal colors not applying

**If colors work in Hyprland but not in terminals/shell:**

1. **Check if templates are installed:**
   ```bash
   ls ~/.config/wal/templates/
   # Should show: hyprland-colors.conf, caelestia-scheme.json
   ```

   If missing, copy them:
   ```bash
   mkdir -p ~/.config/wal/templates
   cp ~/.config/hypr/wal/templates/* ~/.config/wal/templates/
   ```

2. **Regenerate colors:**
   ```bash
   wal -R && ~/pywal.sh
   ```

3. **Check bash configuration:**
   ```bash
   grep -A 5 "pywal" ~/.bashrc
   ```

   If missing, add:
   ```bash
   cat >> ~/.bashrc << 'EOF'

   # Import pywal colorscheme from cache
   (cat ~/.cache/wal/sequences &)

   # To add support for TTYs (optional)
   source ~/.cache/wal/colors-tty.sh 2>/dev/null
   EOF

   source ~/.bashrc
   ```

4. **Check Kitty configuration:**
   ```bash
   grep "colors-kitty" ~/.config/kitty/kitty.conf
   ```

   Should show: `include ~/.cache/wal/colors-kitty.conf`

   If it shows `kitty-colors.conf` (wrong filename), fix it:
   ```bash
   sed -i 's/kitty-colors.conf/colors-kitty.conf/g' ~/.config/kitty/kitty.conf
   killall -SIGUSR1 kitty  # Reload kitty
   ```

5. **Verify pywal cache files exist:**
   ```bash
   ls ~/.cache/wal/hyprland-colors.conf
   ls ~/.cache/wal/colors-kitty.conf
   ls ~/.cache/wal/sequences
   ```

**General pywal troubleshooting:**
- Ensure the script is executable: `chmod +x ~/pywal.sh`
- Check if pywal cache exists: `ls ~/.cache/wal/`
- Manually reload: `~/pywal.sh`

### Caelestia colors not updating
```bash
# Restart Caelestia daemon
pkill caelestia && sleep 0.5 && caelestia shell -d &
```

### Wallpaper not showing after config reload
The monitor handler should restore it automatically. If not:
```bash
# Check if monitor-handler is running
pgrep -f monitor-handler.py

# Restart it if needed
python3 ~/.config/hypr/monitor-handler.py &

# Or manually restore
waypaper --restore
```

### Waypaper hook not applying colors
```bash
# Check if hook is registered
grep post_command ~/.config/waypaper/config.ini

# Check hook logs
cat /tmp/waypaper-hook.log
```

---

## Note

Everything is still in progress. Feel free to customize and adjust to your needs!
