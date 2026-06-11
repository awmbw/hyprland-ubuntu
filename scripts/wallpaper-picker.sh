#!/usr/bin/env bash
# Rofi Wallpaper Picker with Image Previews

# Directories to scan
DIRS=(
    "$HOME/Pictures/Wallpapers"
    "$HOME/Backup/Old laptop backup/wallpapers"
    "$HOME/Backup/Old laptop backup/light"
    "$HOME/Backup/Old laptop backup/wallpapers/active_theme"
    "$HOME/Backup/Old laptop backup"
)

# Only search directories that exist
EXISTING_DIRS=()
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        EXISTING_DIRS+=("$dir")
    fi
done

# Find all image files
WALLPAPERS=""
if [ ${#EXISTING_DIRS[@]} -gt 0 ]; then
    WALLPAPERS=$(find "${EXISTING_DIRS[@]}" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | sort -u)
fi

if [ -z "$WALLPAPERS" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found. Please put some in ~/Pictures/Wallpapers"
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
