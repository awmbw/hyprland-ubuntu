#!/usr/bin/env python3
"""
Color Extractor — Extract dominant colors from a wallpaper and generate a theme palette.
Uses Pillow's quantize (median-cut) for fast, reliable color extraction.
Outputs a JSON file with all colors needed to theme the desktop.
"""

import sys
import json
import colorsys
from pathlib import Path
from PIL import Image


def rgb_to_hex(r, g, b):
    """Convert RGB tuple to hex string."""
    return f"#{r:02x}{g:02x}{b:02x}"


def hex_to_rgb(hex_str):
    """Convert hex string to RGB tuple."""
    hex_str = hex_str.lstrip("#")
    return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))


def rgb_to_hsl(r, g, b):
    """Convert RGB (0-255) to HSL (h: 0-360, s: 0-100, l: 0-100)."""
    h, l, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
    return h * 360, s * 100, l * 100


def hsl_to_rgb(h, s, l):
    """Convert HSL (h: 0-360, s: 0-100, l: 0-100) to RGB (0-255)."""
    r, g, b = colorsys.hls_to_rgb(h / 360, l / 100, s / 100)
    return int(r * 255), int(g * 255), int(b * 255)


def color_brightness(r, g, b):
    """Perceived brightness (0-255)."""
    return 0.299 * r + 0.587 * g + 0.114 * b


def color_saturation(r, g, b):
    """Saturation component from HSL."""
    _, s, _ = rgb_to_hsl(r, g, b)
    return s


def darken_color(r, g, b, factor=0.3):
    """Darken a color by a factor (0 = black, 1 = unchanged)."""
    return (int(r * factor), int(g * factor), int(b * factor))


def lighten_color(r, g, b, factor=0.3):
    """Lighten a color by blending toward white."""
    return (
        int(r + (255 - r) * factor),
        int(g + (255 - g) * factor),
        int(b + (255 - b) * factor),
    )


def adjust_color(r, g, b, lightness=None, saturation=None):
    """Adjust a color's HSL lightness and/or saturation."""
    h, s, l = rgb_to_hsl(r, g, b)
    if lightness is not None:
        l = lightness
    if saturation is not None:
        s = saturation
    return hsl_to_rgb(h, max(0, min(100, s)), max(0, min(100, l)))


def extract_colors(image_path, num_colors=8):
    """Extract dominant colors from an image using median-cut quantization."""
    img = Image.open(image_path).convert("RGB")

    # Downsample for speed
    img = img.resize((300, 200), Image.LANCZOS)

    # Quantize to get dominant colors
    quantized = img.quantize(colors=num_colors, method=Image.Quantize.MEDIANCUT)
    palette = quantized.getpalette()

    # Extract RGB tuples from palette
    colors = []
    for i in range(num_colors):
        r, g, b = palette[i * 3], palette[i * 3 + 1], palette[i * 3 + 2]
        colors.append((r, g, b))

    # Sort by vibrancy (saturation * brightness weight) — most vibrant first
    colors.sort(key=lambda c: color_saturation(*c) * 0.7 + color_brightness(*c) * 0.3, reverse=True)

    return colors


def generate_palette(colors):
    """Generate a full theme palette from extracted dominant colors."""

    # Pick the most vibrant color as accent
    accent = colors[0]

    # Find darkest color for background base
    sorted_by_dark = sorted(colors, key=lambda c: color_brightness(*c))
    darkest = sorted_by_dark[0]

    # Generate background — very dark version of the darkest color
    bg_h, bg_s, bg_l = rgb_to_hsl(*darkest)
    background = hsl_to_rgb(bg_h, min(bg_s, 40), 10)  # Very dark, slightly tinted

    # Slightly lighter bg variant
    bg_alt = hsl_to_rgb(bg_h, min(bg_s, 35), 14)

    # Foreground — light, slightly warm
    fg_h, _, _ = rgb_to_hsl(*accent)
    foreground = hsl_to_rgb(fg_h, 12, 88)  # Near-white with slight tint
    fg_dim = hsl_to_rgb(fg_h, 10, 60)  # Dimmed foreground

    # Accent / Primary — the most vibrant extracted color
    acc_h, acc_s, acc_l = rgb_to_hsl(*accent)
    primary = hsl_to_rgb(acc_h, min(acc_s, 80), max(55, min(65, acc_l)))

    # Secondary — 2nd most prominent
    secondary_src = colors[1] if len(colors) > 1 else accent
    sec_h, sec_s, sec_l = rgb_to_hsl(*secondary_src)
    secondary = hsl_to_rgb(sec_h, min(sec_s, 70), max(50, min(60, sec_l)))

    # Tertiary — 3rd color
    tertiary_src = colors[2] if len(colors) > 2 else colors[0]
    ter_h, ter_s, ter_l = rgb_to_hsl(*tertiary_src)
    tertiary = hsl_to_rgb(ter_h, min(ter_s, 65), max(50, min(60, ter_l)))

    # Derived semantic colors
    # Red/Error — shift accent hue toward red
    error = hsl_to_rgb(0, 55, 55)
    # Yellow/Warning — shift toward yellow/amber
    warning = hsl_to_rgb(40, 60, 58)
    # Green/Success
    success = hsl_to_rgb(100, 50, 50)

    # Generate 16 terminal colors
    # color0-7: normal, color8-15: bright variants
    # Strategy: use extracted colors mapped to standard ANSI color roles

    # For terminal colors, we need specific hue slots:
    # 0: black (bg), 1: red, 2: green, 3: yellow, 4: blue, 5: magenta, 6: cyan, 7: white (fg)
    term_hues = {
        'red': 0,
        'green': 120,
        'yellow': 45,
        'blue': 220,
        'magenta': 280,
        'cyan': 180,
    }

    # Try to match extracted colors to terminal slots
    # Find which extracted color is closest to each hue
    def closest_to_hue(target_hue, pool):
        """Find pool color closest to target hue."""
        best = None
        best_diff = 999
        for c in pool:
            h, s, l = rgb_to_hsl(*c)
            diff = min(abs(h - target_hue), 360 - abs(h - target_hue))
            if diff < best_diff and s > 15:  # Require some saturation
                best_diff = diff
                best = c
        return best

    terminal = {}

    # color0: dark background
    terminal['color0'] = rgb_to_hex(*background)

    # color1-6: map to hue slots using extracted colors or generated ones
    for name, hue in term_hues.items():
        matched = closest_to_hue(hue, colors)
        if matched and min(abs(rgb_to_hsl(*matched)[0] - hue), 360 - abs(rgb_to_hsl(*matched)[0] - hue)) < 60:
            # Use extracted color, adjusted to proper lightness
            mh, ms, ml = rgb_to_hsl(*matched)
            normal = hsl_to_rgb(mh, min(ms, 65), 50)
            bright = hsl_to_rgb(mh, min(ms, 70), 62)
        else:
            # Generate color at target hue with accent-inspired saturation
            normal = hsl_to_rgb(hue, 55, 50)
            bright = hsl_to_rgb(hue, 60, 62)

        idx = {'red': 1, 'green': 2, 'yellow': 3, 'blue': 4, 'magenta': 5, 'cyan': 6}[name]
        terminal[f'color{idx}'] = rgb_to_hex(*normal)
        terminal[f'color{idx + 8}'] = rgb_to_hex(*bright)

    # color7: light foreground
    terminal['color7'] = rgb_to_hex(*foreground)

    # color8: bright black (lighter bg)
    terminal['color8'] = rgb_to_hex(*bg_alt)

    # color15: bright white
    terminal['color15'] = rgb_to_hex(*lighten_color(*foreground, 0.4))

    # Build the full palette
    palette = {
        # Core
        'background': rgb_to_hex(*background),
        'background_alt': rgb_to_hex(*bg_alt),
        'foreground': rgb_to_hex(*foreground),
        'foreground_dim': rgb_to_hex(*fg_dim),

        # Accents
        'accent': rgb_to_hex(*primary),
        'secondary': rgb_to_hex(*secondary),
        'tertiary': rgb_to_hex(*tertiary),

        # Semantic
        'error': rgb_to_hex(*error),
        'warning': rgb_to_hex(*warning),
        'success': rgb_to_hex(*success),

        # Border colors (for Hyprland)
        'border_active': rgb_to_hex(*primary),
        'border_inactive': rgb_to_hex(*darken_color(*primary, 0.3)),

        # Accent with alpha variants (for CSS rgba)
        'accent_rgb': f"{primary[0]}, {primary[1]}, {primary[2]}",
        'bg_rgb': f"{background[0]}, {background[1]}, {background[2]}",
        'bg_alt_rgb': f"{bg_alt[0]}, {bg_alt[1]}, {bg_alt[2]}",
        'fg_rgb': f"{foreground[0]}, {foreground[1]}, {foreground[2]}",
        'fg_dim_rgb': f"{fg_dim[0]}, {fg_dim[1]}, {fg_dim[2]}",
        'secondary_rgb': f"{secondary[0]}, {secondary[1]}, {secondary[2]}",
        'tertiary_rgb': f"{tertiary[0]}, {tertiary[1]}, {tertiary[2]}",
        'error_rgb': f"{error[0]}, {error[1]}, {error[2]}",
        'warning_rgb': f"{warning[0]}, {warning[1]}, {warning[2]}",
        'success_rgb': f"{success[0]}, {success[1]}, {success[2]}",

        # Terminal colors
        **terminal,

        # Selection colors
        'selection_fg': rgb_to_hex(*background),
        'selection_bg': rgb_to_hex(*primary),

        # Cursor
        'cursor': rgb_to_hex(*primary),
        'cursor_text': rgb_to_hex(*background),
    }

    return palette


def main():
    if len(sys.argv) < 2:
        print("Usage: color_extract.py <image_path> [output_json_path]", file=sys.stderr)
        sys.exit(1)

    image_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else str(
        Path.home() / ".config" / "hypr" / "theme_colors.json"
    )

    if not Path(image_path).exists():
        print(f"Error: Image not found: {image_path}", file=sys.stderr)
        sys.exit(1)

    # Extract and generate
    colors = extract_colors(image_path, num_colors=8)
    palette = generate_palette(colors)

    # Ensure output directory exists
    Path(output_path).parent.mkdir(parents=True, exist_ok=True)

    # Write JSON
    with open(output_path, 'w') as f:
        json.dump(palette, f, indent=2)

    print(f"Theme palette written to {output_path}")
    print(f"  Background: {palette['background']}")
    print(f"  Foreground: {palette['foreground']}")
    print(f"  Accent:     {palette['accent']}")
    print(f"  Secondary:  {palette['secondary']}")


if __name__ == "__main__":
    main()
