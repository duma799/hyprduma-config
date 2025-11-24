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

### Prerequisites: Install AUR Helpers (Optional but Recommended)

If you don't have yay and paru installed yet, you can install both:

```bash
# Install yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay

# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd .. && rm -rf paru
```

### Step 1: Install Required Packages

```bash
# Install all required packages in one command
sudo pacman -S hyprland hyprlock hyprshot wlogout kitty waybar swaybg waypaper wofi nautilus wireplumber pipewire-pulse brightnessctl playerctl adwaita-cursors python-pywal
```

### Step 2: Install Caelestia Shell (Recommended)

Caelestia is a modern shell with AI features that integrates with the pywal theming system.

```bash
# Install Caelestia via yay
yay -S caelestia-shell # caelestia-shell-git is bleeding edge & unstable one

# Start Caelestia daemon (it will auto-restart when pywal colors change)
caelestia shell -d &
```

**Note:** Caelestia runs as a background service and integrates with pywal for dynamic color theming.

### Step 3: Clone This Repository

```bash
# Clone to a temporary location
cd ~/Downloads
git clone https://github.com/duma97/hyprduma-config.git
cd hyprduma-config
```

### Step 4: Backup Existing Configs (If Any)

```bash
# Backup existing Hyprland config
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr.backup

# Backup existing waybar config
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar.backup

# Backup existing wlogout config
[ -d ~/.config/wlogout ] && mv ~/.config/wlogout ~/.config/wlogout.backup
```

### Step 5: Install Hyprland Configuration

```bash
# Create Hypr config directory
mkdir -p ~/.config/hypr

# Copy main config
cp hyprland.conf ~/.config/hypr/
cp hyprland-colors.conf ~/.config/hypr/

# Create screenshots directory (used by config)
mkdir -p ~/Pictures/Screenshots
```

### Step 6: Configure Your Applications

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

### Step 7: Install Pywal Integration (Strongly Recommended)

Pywal provides dynamic color theming based on your wallpaper.

```bash
# Install pywal templates (REQUIRED for color generation)
mkdir -p ~/.config/wal/templates
cp -r wal/templates/* ~/.config/wal/templates/

# Copy the color application and wallpaper sync scripts
cp pywal.sh ~/.config/hypr/
cp sync-caelestia-wallpaper.sh ~/.config/hypr/
chmod +x ~/.config/hypr/pywal.sh
chmod +x ~/.config/hypr/sync-caelestia-wallpaper.sh

# Also copy to home directory for easier access
cp pywal.sh ~/pywal.sh
chmod +x ~/pywal.sh

# Setup Kitty terminal to use pywal colors
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/

# Configure bash shell to load pywal colors
# Add these lines to your ~/.bashrc if they're not already there:
cat >> ~/.bashrc << 'EOF'

# Import pywal colorscheme from cache
(cat ~/.cache/wal/sequences &)

# To add support for TTYs (optional)
source ~/.cache/wal/colors-tty.sh 2>/dev/null
EOF

# Generate initial colors from a wallpaper
wal -i /path/to/your/wallpaper.png

# Or use included wallpaper
wal -i wallpapers/sakura.jpg

# Apply colors to all components
~/pywal.sh

# Reload bash to apply shell colors
source ~/.bashrc
```

**What this does:**
- Generates a color scheme from your wallpaper
- Applies colors to Hyprland window borders
- Applies colors to Caelestia shell (if installed)
- Applies colors to Kitty terminals
- Applies colors to bash shell
- Restarts necessary services to apply changes

### Step 8: Start Hyprland

```bash
# If you're in a TTY, start Hyprland
Hyprland

# If already in Hyprland, reload the config
# Press SUPER + SHIFT + R (or restart Hyprland session)
```

---

## Post-Installation

### Setting Wallpaper with Pywal

```bash
# Generate colors and apply them
wal -i /path/to/wallpaper.png && ~/pywal.sh

# Or use the wallpapers included in this repo
wal -i ~/.config/hypr/wallpapers/sakura.jpg && ~/pywal.sh
```

**Note about waypaper and Caelestia:**
- This config uses **swaybg** as the wallpaper backend (not hyprpaper)
- Use `waypaper` GUI (Super+W) to select wallpapers
- Waypaper with swaybg backend automatically saves and restores your wallpaper on login
- **Important**: Caelestia shell has its own wallpaper management that may conflict with waypaper
- The config includes `sync-caelestia-wallpaper.sh` to automatically sync Caelestia's wallpaper reference with swaybg
- This sync happens automatically on startup and when you open waypaper (Super+W)
- For pywal integration, use `wal -i` as shown above, then run the apply script (which also syncs Caelestia)

### System-Wide Theme Syncing (Dark/Light Mode)

The enhanced `pywal.sh` script now supports system-wide theme synchronization, making browsers, GTK apps, and other applications respect PyWal color scheme and dark/light mode preference.

#### Basic Usage

```bash
# Apply dark theme with wallpaper (default)
~/.config/hypr/pywal.sh ~/Pictures/wallpaper.jpg

# Apply light theme with wallpaper
~/.config/hypr/pywal.sh ~/Pictures/wallpaper.jpg light

# Switch to light mode (keep current wallpaper)
~/.config/hypr/pywal.sh "" light

# Switch to dark mode (keep current wallpaper)
~/.config/hypr/pywal.sh "" dark

# Refresh themes (reapply current colors)
~/.config/hypr/pywal.sh
```

#### Enhanced System-Wide Support (Optional)

For full system-wide theming across all applications, install these optional packages:

**1. GTK Theme Support**

```bash
# Install GTK theme generator
yay -S wal-gtk-theme-git

# The script will automatically generate GTK themes
# GTK apps (Nautilus, GNOME apps, etc.) will use PyWal colors
```

**2. Firefox Theme Support**

```bash
# Install pywalfox backend
yay -S python-pywalfox
pywalfox install

# Then install the Pywalfox extension from Firefox Add-ons:
# https://addons.mozilla.org/en-US/firefox/addon/pywalfox/
```

**3. Qt Application Support (Optional)**

```bash
# Install Qt theming tools
yay -S qt5ct qt6ct kvantum

# Set environment variables
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> ~/.config/environment.d/qt.conf
echo "QT_STYLE_OVERRIDE=kvantum" >> ~/.config/environment.d/qt.conf
```

**4. Create GTK Configuration Files**

```bash
# Create GTK 3 settings
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=FlatColor
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

# Create GTK 4 settings (same content)
mkdir -p ~/.config/gtk-4.0
cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/
```

#### What Gets Themed

Once configured, the following applications will sync with your PyWal colors:

- **Hyprland**: Window borders and decorations
- **Caelestia Shell**: Status bar and UI elements
- **Kitty Terminal**: Background, foreground, and color palette
- **GTK Applications**: File managers (Nautilus), settings, GNOME apps
- **Firefox**: Browser UI via Pywalfox (if installed)
- **Chrome/Chromium**: Via system dark mode preference
- **Qt Applications**: Via qt5ct/qt6ct (if configured)
- **Bash Shell**: Terminal color sequences

#### Automatic Dark/Light Mode by Time (Optional)

Create a script to automatically switch themes based on time of day:

```bash
# Create auto-theme script
cat > ~/.local/bin/auto-theme.sh << 'EOF'
#!/bin/bash
HOUR=$(date +%H)

if [ $HOUR -ge 18 ] || [ $HOUR -lt 6 ]; then
    # Dark mode (6 PM to 6 AM)
    ~/.config/hypr/pywal.sh "" dark
else
    # Light mode (6 AM to 6 PM)
    ~/.config/hypr/pywal.sh "" light
fi
EOF

chmod +x ~/.local/bin/auto-theme.sh

# Add to Hyprland config to run on startup
echo "exec-once = ~/.local/bin/auto-theme.sh" >> ~/.config/hypr/hyprland.conf
```

#### How It Works

The enhanced `pywal.sh` script:
1. Generates PyWal colors from wallpaper (or switches theme mode)
2. Creates GTK themes via `wal-gtk` (if installed)
3. Sets system-wide dark/light preference via `gsettings`
4. Updates Firefox theme via `pywalfox` (if installed)
5. Reloads Hyprland, Caelestia, and Kitty with new colors
6. Automatically detects if theme is light or dark based on background brightness

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

### Wallpaper not showing on startup
```bash
# Restore wallpaper with waypaper
waypaper restore

# Manually restart swaybg if needed
pkill swaybg && swaybg &
```

---

## Note

Everything is still in progress. Feel free to customize and adjust to your needs!
