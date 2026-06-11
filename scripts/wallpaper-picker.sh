#!/usr/bin/env bash
# Rofi Wallpaper Picker with Image Previews

# Directories to scan
DIRS=(
    "/home/aum/Backup/Old laptop backup"
    "/home/aum/Backup/Old laptop backup/wallpapers"
    "/home/aum/Backup/Old laptop backup/light"
    # Include the active_theme dir inside wallpapers just in case it's missed by maxdepth 1
    "/home/aum/Backup/Old laptop backup/wallpapers/active_theme"
)

# Find all image files
WALLPAPERS=$(find "${DIRS[@]}" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | sort -u)

if [ -z "$WALLPAPERS" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found in configured directories."
    exit 1
fi

# Generate Rofi input with icons and show menu (using awk for ~100x speedup)
SELECTED=$(echo "$WALLPAPERS" | awk -F/ '{print $NF "\x00icon\x1f" $0}' | rofi -dmenu -i \
    -theme ~/.config/rofi/wallpaper-picker.rasi \
    -p "Wallpaper")

if [ -n "$SELECTED" ]; then
    # Find the full path of the selected filename
    # Since we only get the filename back, we search the WALLPAPERS list for a match
    FULL_PATH=$(echo "$WALLPAPERS" | grep "/${SELECTED}$" | head -n 1)
    
    if [ -n "$FULL_PATH" ] && [ -f "$FULL_PATH" ]; then
        notify-send "Theming System" "Applying theme for: $SELECTED..."
        ~/.config/hypr/scripts/wallpaper-theme.sh "$FULL_PATH"
    fi
fi
