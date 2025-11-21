# Pywal Colors Integration for Hyprland & Caelestia

This setup automatically applies pywal-generated colors to both Hyprland borders and Caelestia shell.

## Files Created

1. **`~/.config/wal/templates/hyprland-colors.conf`** - Template for Hyprland border colors
2. **`~/.config/wal/templates/caelestia-scheme.json`** - Template for Caelestia color scheme
3. **`~/.config/hypr/apply-pywal-colors.sh`** - Script to apply colors to both systems

## How It Works

- When you run `wal -i /path/to/wallpaper`, pywal automatically processes the templates
- The generated files are placed in `~/.cache/wal/`
- Hyprland sources `~/.cache/wal/hyprland-colors.conf` for border colors
- Caelestia reads from `~/.local/state/caelestia/scheme.json` for its color scheme

## Usage

### First Time Setup
Already done! Your Hyprland config now sources pywal colors automatically.

### Generate Colors from a Wallpaper
```bash
# Generate colors from a wallpaper
wal -i /path/to/your/wallpaper.png

# Apply colors to Hyprland and Caelestia
~/.config/hypr/apply-pywal-colors.sh
```

### Regenerate from Current Wallpaper
```bash
# Regenerate colors from the current cached wallpaper
wal -R

# Apply colors
~/.config/hypr/apply-pywal-colors.sh
```

### Quick Apply
```bash
# One-liner to generate and apply colors
wal -i /path/to/wallpaper.png && ~/.config/hypr/apply-pywal-colors.sh
```

## What Gets Colored

### Hyprland
- Active window border (gradient using colors 4 and 6)
- Inactive window border (using color 8)

### Caelestia Shell
- All Material Design 3 colors
- Terminal colors (term0-term15)
- Background, surface, and accent colors
- Complete color scheme based on wallpaper

## Customization

### Modify Border Colors
Edit `~/.config/wal/templates/hyprland-colors.conf` to use different pywal colors:
- Available variables: `{color0}` through `{color15}`, `{background}`, `{foreground}`, `{cursor}`

### Modify Caelestia Colors
Edit `~/.config/wal/templates/caelestia-scheme.json` to adjust color mappings.

After editing templates, run `wal -R` to regenerate colors.

## Automation

To automatically apply pywal colors on wallpaper change, you can add this to your autostart:
```bash
# In your ~/.config/hypr/hyprland.conf
exec-once = ~/.config/hypr/apply-pywal-colors.sh
```

Or create a wallpaper script that calls pywal automatically.

## Troubleshooting

### Colors not updating in Hyprland
```bash
# Reload Hyprland config
hyprctl reload
```

### Colors not updating in Caelestia
```bash
# Restart Caelestia shell
pkill caelestia && sleep 0.5 && caelestia shell -d &
```

### Check generated files
```bash
# View generated Hyprland colors
cat ~/.cache/wal/hyprland-colors.conf

# View generated Caelestia scheme
cat ~/.cache/wal/caelestia-scheme.json
```
