# ╔══════════════════════════════════════════════════════════════╗
# ║              Kitty — Auto-Themed                             ║
# ╚══════════════════════════════════════════════════════════════╝

# Allow remote control so we can update colors on the fly
allow_remote_control yes
listen_on unix:/tmp/kitty

# ── Font ──────────────────────────────────────────────────────
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        11.0

# ── Cursor ────────────────────────────────────────────────────
cursor_shape          beam
cursor_blink_interval 0.5
cursor_stop_blinking_after 15

# ── Scrollback ────────────────────────────────────────────────
scrollback_lines 10000

# ── Window ────────────────────────────────────────────────────
window_padding_width  8
confirm_os_window_close 0
background_opacity    0.88
dynamic_background_opacity yes

# ── URLs ──────────────────────────────────────────────────────
url_style    curly
open_url_with default

# ── Bell ──────────────────────────────────────────────────────
enable_audio_bell no
visual_bell_duration 0

# ── Performance ───────────────────────────────────────────────
repaint_delay   6
input_delay     1
sync_to_monitor yes

# ── Tab Bar ───────────────────────────────────────────────────
tab_bar_style       powerline
tab_powerline_style slanted

# ── Color Scheme — Auto-Generated ─────────────────────────────
foreground          {{FG}}
background          {{BG}}
selection_foreground  {{SELECTION_FG}}
selection_background  {{SELECTION_BG}}

cursor              {{CURSOR}}
cursor_text_color   {{CURSOR_TEXT}}

url_color           {{ACCENT}}

# Tab bar
active_tab_foreground   {{BG}}
active_tab_background   {{ACCENT}}
inactive_tab_foreground {{FG_DIM}}
inactive_tab_background {{BG_ALT}}

# Normal colors
color0  {{COLOR0}}
color1  {{COLOR1}}
color2  {{COLOR2}}
color3  {{COLOR3}}
color4  {{COLOR4}}
color5  {{COLOR5}}
color6  {{COLOR6}}
color7  {{COLOR7}}

# Bright colors
color8  {{COLOR8}}
color9  {{COLOR9}}
color10 {{COLOR10}}
color11 {{COLOR11}}
color12 {{COLOR12}}
color13 {{COLOR13}}
color14 {{COLOR14}}
color15 {{COLOR15}}

# Marks
mark1_foreground {{BG}}
mark1_background {{ACCENT}}
mark2_foreground {{BG}}
mark2_background {{SECONDARY}}
mark3_foreground {{BG}}
mark3_background {{TERTIARY}}
