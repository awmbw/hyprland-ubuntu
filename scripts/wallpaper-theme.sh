#!/usr/bin/env bash
# Wallpaper Theme Orchestrator
# Applies a wallpaper and orchestrates theming across components

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

WALLPAPER="$1"
HYPR_DIR="$HOME/.config/hypr"
SCRIPTS_DIR="$HYPR_DIR/scripts"
COLORS_JSON="$HYPR_DIR/theme_colors.json"

if [ ! -f "$WALLPAPER" ]; then
    notify-send "Theme Error" "Wallpaper not found: $WALLPAPER"
    exit 1
fi

# 1. Apply Wallpaper
cp "$WALLPAPER" "$HYPR_DIR/wallpaper.png"
if pgrep swaybg > /dev/null; then
    killall swaybg
fi
swaybg -i "$HYPR_DIR/wallpaper.png" -m fill &

# 2. Extract Colors
if ! python3 "$SCRIPTS_DIR/color_extract.py" "$WALLPAPER" "$COLORS_JSON"; then
    notify-send "Theme Error" "Failed to extract colors from wallpaper."
    exit 1
fi

# Helper to read a value from JSON
get_color() {
    local key="$1"
    grep -o "\"$key\": \"[^\"]*\"" "$COLORS_JSON" | cut -d'"' -f4
}

# Load colors into variables
BG=$(get_color "background")
BG_ALT=$(get_color "background_alt")
FG=$(get_color "foreground")
FG_DIM=$(get_color "foreground_dim")

ACCENT=$(get_color "accent")
SECONDARY=$(get_color "secondary")
TERTIARY=$(get_color "tertiary")

ERROR=$(get_color "error")
WARNING=$(get_color "warning")
SUCCESS=$(get_color "success")

# RGB variants
BG_RGB=$(get_color "bg_rgb")
BG_ALT_RGB=$(get_color "bg_alt_rgb")
FG_RGB=$(get_color "fg_rgb")
FG_DIM_RGB=$(get_color "fg_dim_rgb")
ACCENT_RGB=$(get_color "accent_rgb")
SECONDARY_RGB=$(get_color "secondary_rgb")
TERTIARY_RGB=$(get_color "tertiary_rgb")
ERROR_RGB=$(get_color "error_rgb")
WARNING_RGB=$(get_color "warning_rgb")
SUCCESS_RGB=$(get_color "success_rgb")

# Terminal colors
COLOR0=$(get_color "color0")
COLOR1=$(get_color "color1")
COLOR2=$(get_color "color2")
COLOR3=$(get_color "color3")
COLOR4=$(get_color "color4")
COLOR5=$(get_color "color5")
COLOR6=$(get_color "color6")
COLOR7=$(get_color "color7")
COLOR8=$(get_color "color8")
COLOR9=$(get_color "color9")
COLOR10=$(get_color "color10")
COLOR11=$(get_color "color11")
COLOR12=$(get_color "color12")
COLOR13=$(get_color "color13")
COLOR14=$(get_color "color14")
COLOR15=$(get_color "color15")

# RGB variants for some terminal colors used in CSS
get_hex_rgb() {
    local hex="$1"
    hex="${hex#\#}"
    printf "%d, %d, %d" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

COLOR2_RGB=$(get_hex_rgb "$COLOR2")
COLOR3_RGB=$(get_hex_rgb "$COLOR3")
COLOR4_RGB=$(get_hex_rgb "$COLOR4")
COLOR6_RGB=$(get_hex_rgb "$COLOR6")

SELECTION_FG=$(get_color "selection_fg")
SELECTION_BG=$(get_color "selection_bg")
CURSOR=$(get_color "cursor")
CURSOR_TEXT=$(get_color "cursor_text")

# 3. Apply Templates

apply_template() {
    local tpl="$1"
    local dest="$2"
    
    # We use sed to replace placeholders
    sed -e "s/{{BG}}/$BG/g" \
        -e "s/{{BG_ALT}}/$BG_ALT/g" \
        -e "s/{{FG}}/$FG/g" \
        -e "s/{{FG_DIM}}/$FG_DIM/g" \
        -e "s/{{ACCENT}}/$ACCENT/g" \
        -e "s/{{SECONDARY}}/$SECONDARY/g" \
        -e "s/{{TERTIARY}}/$TERTIARY/g" \
        -e "s/{{ERROR}}/$ERROR/g" \
        -e "s/{{WARNING}}/$WARNING/g" \
        -e "s/{{SUCCESS}}/$SUCCESS/g" \
        -e "s/{{BG_RGB}}/$BG_RGB/g" \
        -e "s/{{BG_ALT_RGB}}/$BG_ALT_RGB/g" \
        -e "s/{{FG_RGB}}/$FG_RGB/g" \
        -e "s/{{FG_DIM_RGB}}/$FG_DIM_RGB/g" \
        -e "s/{{ACCENT_RGB}}/$ACCENT_RGB/g" \
        -e "s/{{SECONDARY_RGB}}/$SECONDARY_RGB/g" \
        -e "s/{{TERTIARY_RGB}}/$TERTIARY_RGB/g" \
        -e "s/{{ERROR_RGB}}/$ERROR_RGB/g" \
        -e "s/{{WARNING_RGB}}/$WARNING_RGB/g" \
        -e "s/{{SUCCESS_RGB}}/$SUCCESS_RGB/g" \
        -e "s/{{COLOR0}}/$COLOR0/g" \
        -e "s/{{COLOR1}}/$COLOR1/g" \
        -e "s/{{COLOR2}}/$COLOR2/g" \
        -e "s/{{COLOR3}}/$COLOR3/g" \
        -e "s/{{COLOR4}}/$COLOR4/g" \
        -e "s/{{COLOR5}}/$COLOR5/g" \
        -e "s/{{COLOR6}}/$COLOR6/g" \
        -e "s/{{COLOR7}}/$COLOR7/g" \
        -e "s/{{COLOR8}}/$COLOR8/g" \
        -e "s/{{COLOR9}}/$COLOR9/g" \
        -e "s/{{COLOR10}}/$COLOR10/g" \
        -e "s/{{COLOR11}}/$COLOR11/g" \
        -e "s/{{COLOR12}}/$COLOR12/g" \
        -e "s/{{COLOR13}}/$COLOR13/g" \
        -e "s/{{COLOR14}}/$COLOR14/g" \
        -e "s/{{COLOR15}}/$COLOR15/g" \
        -e "s/{{COLOR2_RGB}}/$COLOR2_RGB/g" \
        -e "s/{{COLOR3_RGB}}/$COLOR3_RGB/g" \
        -e "s/{{COLOR4_RGB}}/$COLOR4_RGB/g" \
        -e "s/{{COLOR6_RGB}}/$COLOR6_RGB/g" \
        -e "s/{{SELECTION_FG}}/$SELECTION_FG/g" \
        -e "s/{{SELECTION_BG}}/$SELECTION_BG/g" \
        -e "s/{{CURSOR}}/$CURSOR/g" \
        -e "s/{{CURSOR_TEXT}}/$CURSOR_TEXT/g" \
        "$tpl" > "$dest"
}

# Base repo path
REPO_DIR="/home/aum/hyprland-ubuntu"

# Waybar
apply_template "$REPO_DIR/waybar/style.css.tpl" "$REPO_DIR/waybar/style.css"
if pgrep waybar > /dev/null; then
    killall waybar
fi
waybar &

# Kitty
apply_template "$REPO_DIR/kitty/kitty.conf.tpl" "$REPO_DIR/kitty/kitty.conf"
if pgrep kitty > /dev/null; then
    # Try to live reload kitty if allow_remote_control is yes
    kitty @ set-colors --all --configured ~/.config/kitty/kitty.conf 2>/dev/null || true
fi

# Rofi
apply_template "$REPO_DIR/rofi/theme.rasi.tpl" "$REPO_DIR/rofi/theme.rasi"

# Dunst
apply_template "$REPO_DIR/dunst/dunstrc.tpl" "$REPO_DIR/dunst/dunstrc"
if pgrep dunst > /dev/null; then
    killall dunst
fi
dunst &

# Hyprlock
apply_template "$REPO_DIR/hypr/hyprlock.conf.tpl" "$REPO_DIR/hypr/hyprlock.conf"

# Hyprland borders
cat <<EOF > "$REPO_DIR/hypr/theme_colors.conf"
general {
    col.active_border = rgba(${ACCENT:1}ee) rgba(${SECONDARY:1}ee) 45deg
    col.inactive_border = rgba(${BG:1}88)
}
EOF
hyprctl reload

notify-send "Theme Applied" "System colors updated based on wallpaper."
