# Light Theme with Pywal

Your shell, Kitty terminal, Hyprland, and Caelestia are now fully integrated with pywal!

## How to Switch Between Light and Dark Themes

### Dark Theme (Default)
```bash
# Generate dark theme from wallpaper
wal -i /path/to/wallpaper.png && ~/pywal.sh
```

### Light Theme
```bash
# Generate light theme from wallpaper (use -l flag)
wal -i /path/to/wallpaper.png -l && ~/pywal.sh
```

## Examples with Your Wallpapers

### Light Theme Examples
```bash
# Bright wallpapers work best for light themes
wal -i ~/.config/hypr/wallpapers/nix-white.png -l && ~/pywal.sh
wal -i ~/.config/hypr/wallpapers/clouds.jpg -l && ~/pywal.sh
wal -i ~/.config/hypr/wallpapers/blue_mountains.JPG -l && ~/pywal.sh
wal -i ~/.config/hypr/wallpapers/mountain_snow_white_clouds_fog.jpg -l && ~/pywal.sh
```

### Dark Theme Examples
```bash
# Dark wallpapers work best for dark themes
wal -i ~/.config/hypr/wallpapers/windows-11-dark.jpg && ~/pywal.sh
wal -i ~/.config/hypr/wallpapers/black-hole-wallpaper.png && ~/pywal.sh
wal -i ~/.config/hypr/wallpapers/berserk-manga.png && ~/pywal.sh
```

## What Gets Themed

When you run `~/pywal.sh`, colors are applied to:

✓ **Kitty Terminal** - Background, foreground, and all 16 terminal colors
✓ **Bash Shell** - Terminal colors via sequences
✓ **Hyprland** - Window borders (active and inactive)
✓ **Caelestia Shell** - Complete Material Design 3 color scheme

## Testing Light Mode Right Now

Try this with a bright wallpaper:
```bash
wal -i ~/.config/hypr/wallpapers/nix-white.png -l && ~/pywal.sh
```

Your terminal should switch to a light theme with dark text on light background!

## Switching Back to Dark

If you want to go back to dark theme:
```bash
# Restore from cache (last used theme)
wal -R && ~/pywal.sh

# Or pick a dark wallpaper
wal -i ~/.config/hypr/wallpapers/windows-11-dark.jpg && ~/pywal.sh
```

## Backend Options for Better Colors

Pywal has different backends that can generate different color palettes:

```bash
# Try different backends for better light theme colors
wal -i /path/to/wallpaper.png -l --backend colorz && ~/pywal.sh
wal -i /path/to/wallpaper.png -l --backend colorthief && ~/pywal.sh
wal -i /path/to/wallpaper.png -l --backend haishoku && ~/pywal.sh
```

## Pro Tips

1. **Light wallpapers** → Use `-l` flag
2. **Dark wallpapers** → Don't use `-l` flag
3. **Kitty colors reload instantly** - No need to restart terminal!
4. **Shell colors apply on new terminal** - Open a new terminal or run: `cat ~/.cache/wal/sequences`
5. **Want consistent theme on login?** Add to your `~/.config/hypr/hyprland.conf`:
   ```
   exec-once = wal -R && ~/pywal.sh
   ```

## Adjusting Kitty Opacity for Light Themes

If the light theme is too transparent, you can adjust opacity in `~/.config/kitty/kitty.conf`:

```conf
# For light themes, you might want less transparency
background_opacity 0.95

# Or make it fully opaque
background_opacity 1.0
```

Then reload: `killall -SIGUSR1 kitty`
