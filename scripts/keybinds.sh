#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║              Keybind Cheatsheet — Rofi Menu                  ║
# ╚══════════════════════════════════════════════════════════════╝

keybinds="╔══════════════════════════════════════════════╗
║           HYPRLAND KEYBINDINGS              ║
╚══════════════════════════════════════════════╝

── APPLICATIONS ───────────────────────────────
Super + Return          Terminal (Kitty)
Super + Space           App Launcher (Rofi)
Super + B                Browser (Chrome)
Super + E               File Manager (Thunar)
Super + O               Obsidian
Super + A               Antigravity
Super + R               OBS Studio
Super + Shift + D       Lazydocker
Super + C               Clipboard History

── WINDOWS ────────────────────────────────────
Super + W               Close Window
Super + F               Fullscreen
Super + Shift + F       Maximize (keep bar)
Super + T               Toggle Floating
Super + J               Toggle Split Direction
Super + P               Pseudo Tiling
Super + S               Special Workspace
Super + Shift + S       Move to Special

── FOCUS (Arrow Keys) ─────────────────────────
Super + ← ↑ → ↓        Move Focus
Super + Alt + H/J/K/L   Move Focus (Vim)

── MOVE WINDOWS ───────────────────────────────
Super + Shift + ← ↑ → ↓     Move Window
Super + Shift + H/J/K/L     Move Window (Vim)

── RESIZE ─────────────────────────────────────
Super + Ctrl + ← ↑ → ↓      Resize Window
Super + Ctrl + H/J/K/L      Resize (Vim)

── WORKSPACES ─────────────────────────────────
Super + 1-9,0           Switch Workspace
Super + Shift + 1-9,0   Move to Workspace
Super + Scroll           Cycle Workspaces

── SCREENSHOTS ────────────────────────────────
Print                   Region → Clipboard
Super + Print            Full Screen → Clipboard
Super + Shift + Print    Region → Save to File

── MEDIA ──────────────────────────────────────
Volume Keys             Volume Up/Down
Mute Key                Toggle Mute
Brightness Keys         Brightness Up/Down

── SYSTEM ─────────────────────────────────────
Super + Ctrl + L        Lock Screen
Super + Shift + Q       Exit Hyprland
Super + K               This Cheatsheet

── SHELL (Terminal) ───────────────────────────
ff                      Fuzzy Find Files
lg                      Lazygit
v / vim                 Neovim
ls / ll / lt            eza (pretty ls)
cat                     bat (syntax cat)
cd                      zoxide (smart cd)
top                     btop (system monitor)
compress  <dir>         Create .tar.gz
decompress <file>       Extract .tar.gz

── TMUX (Ctrl+A prefix) ──────────────────────
Ctrl+A then |           Split Horizontal
Ctrl+A then -           Split Vertical
Ctrl+A then h/j/k/l    Navigate Panes
Ctrl+A then c           New Window
Ctrl+A then r           Reload Config"

echo "$keybinds" | rofi -dmenu -theme ~/.config/rofi/theme.rasi -p "Keybinds" -i -no-custom 2>/dev/null
