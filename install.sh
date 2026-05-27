#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║       Hyprland Sleek Setup — Ubuntu 26.04 LTS Installer      ║
# ║       NVIDIA GTX 1650 · Omarchy-inspired · Custom Dotfiles   ║
# ╚══════════════════════════════════════════════════════════════╝
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

log()  { echo -e "${CYAN}[•]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
step() { echo -e "\n${BOLD}${CYAN}── $1 ──${NC}"; }

echo -e "\n${BOLD}${CYAN}"
echo "  ╦ ╦╦ ╦╔═╗╦═╗╦  ╔═╗╔╗╔╔╦╗"
echo "  ╠═╣╚╦╝╠═╝╠╦╝║  ╠═╣║║║ ║║"
echo "  ╩ ╩ ╩ ╩  ╩╚═╩═╝╩ ╩╝╚╝═╩╝"
echo -e "${NC}${BOLD}  Sleek & Fast · Ubuntu 26.04${NC}"
echo -e "${DIM}  Omarchy-inspired · NVIDIA-ready${NC}\n"

# ═══════════════════════════════════════════════════════════════
step "Phase 1: Core Desktop Packages"
# ═══════════════════════════════════════════════════════════════
sudo apt update -qq

CORE_PACKAGES=(
    # Hyprland core
    hyprland
    xdg-desktop-portal-hyprland
    hyprlock
    hypridle
    hyprpaper
    hyprpolkitagent

    # Status bar & launcher
    waybar
    rofi

    # Terminal & file manager
    kitty
    thunar

    # Notifications
    dunst
    libnotify-bin

    # Screenshot & clipboard
    grim
    slurp
    wl-clipboard
    cliphist

    # System utilities
    brightnessctl
    playerctl
    pavucontrol
    jq
    curl
    unzip
    wget

    # NVIDIA Wayland support
    libnvidia-egl-wayland1
)

log "Installing ${#CORE_PACKAGES[@]} core desktop packages..."
sudo apt install -y "${CORE_PACKAGES[@]}"
ok "Core desktop packages installed"

# ═══════════════════════════════════════════════════════════════
step "Phase 2: Developer Tooling (Omarchy-style)"
# ═══════════════════════════════════════════════════════════════

DEV_PACKAGES=(
    # Modern CLI replacements
    eza                    # ls replacement
    bat                    # cat replacement
    fd-find                # find replacement
    ripgrep                # grep replacement
    fzf                    # fuzzy finder

    # Developer TUIs
    btop                   # system monitor
    tmux                   # terminal multiplexer
    neovim                 # editor

    # System info
    fastfetch              # system fetch

    # Version control
    git

    # Build essentials (for LazyVim plugins)
    build-essential
    cmake
    python3-pip
    nodejs
    npm
)

log "Installing ${#DEV_PACKAGES[@]} developer tool packages..."
sudo apt install -y "${DEV_PACKAGES[@]}" 2>/dev/null || {
    warn "Some packages may not be available, installing what we can..."
    for pkg in "${DEV_PACKAGES[@]}"; do
        sudo apt install -y "$pkg" 2>/dev/null || warn "Skipped: $pkg"
    done
}
ok "Developer tools installed"

# ── Lazygit (not in Ubuntu repos, install from GitHub) ────────
if ! command -v lazygit &>/dev/null; then
    log "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    if [ -n "$LAZYGIT_VERSION" ]; then
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin/
        rm -f /tmp/lazygit /tmp/lazygit.tar.gz
        ok "lazygit installed"
    else
        warn "Could not determine lazygit version, skipping"
    fi
else
    ok "lazygit already installed"
fi

# ── Zoxide (smart cd) ────────────────────────────────────────
if ! command -v zoxide &>/dev/null; then
    log "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash 2>/dev/null || {
        warn "zoxide install script failed, trying apt..."
        sudo apt install -y zoxide 2>/dev/null || warn "Skipped: zoxide"
    }
    ok "zoxide installed"
else
    ok "zoxide already installed"
fi

# ── Starship prompt ──────────────────────────────────────────
if ! command -v starship &>/dev/null; then
    log "Installing starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    ok "starship installed"
else
    ok "starship already installed"
fi

# ═══════════════════════════════════════════════════════════════
step "Phase 3: JetBrainsMono Nerd Font"
# ═══════════════════════════════════════════════════════════════
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
if [ ! -d "$FONT_DIR" ] || [ -z "$(ls -A "$FONT_DIR" 2>/dev/null)" ]; then
    log "Downloading JetBrainsMono Nerd Font..."
    mkdir -p "$FONT_DIR"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o /tmp/JetBrainsMono.tar.xz
    tar -xf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
    rm -f /tmp/JetBrainsMono.tar.xz
    fc-cache -fv "$FONT_DIR" >/dev/null 2>&1
    ok "JetBrainsMono Nerd Font installed"
else
    ok "JetBrainsMono Nerd Font already installed"
fi

# ═══════════════════════════════════════════════════════════════
step "Phase 4: Neovim + LazyVim (IDE-like editor)"
# ═══════════════════════════════════════════════════════════════
NVIM_CONFIG="$HOME/.config/nvim"
if [ ! -d "$NVIM_CONFIG" ] || [ ! -f "$NVIM_CONFIG/lazy-lock.json" ]; then
    log "Setting up LazyVim for Neovim..."
    # Back up existing nvim config
    if [ -d "$NVIM_CONFIG" ]; then
        mv "$NVIM_CONFIG" "${NVIM_CONFIG}.bak.$(date +%s)"
        warn "Backed up existing nvim config"
    fi
    # Clone LazyVim starter
    git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_CONFIG"
    rm -rf "$NVIM_CONFIG/.git"
    ok "LazyVim installed (plugins will auto-install on first nvim launch)"
else
    ok "LazyVim already configured"
fi

# ═══════════════════════════════════════════════════════════════
step "Phase 5: Wallpaper"
# ═══════════════════════════════════════════════════════════════
WALLPAPER_DST="$HOME/.config/hypr/wallpaper.png"
if [ ! -f "$WALLPAPER_DST" ]; then
    log "Generating dark wallpaper..."
    mkdir -p "$HOME/.config/hypr"
    if command -v convert &>/dev/null; then
        convert -size 1920x1080 \
            -define gradient:angle=135 \
            gradient:'#0a0a12-#141420' \
            -fill 'rgba(86,182,194,0.03)' \
            -draw "circle 960,540 960,800" \
            "$WALLPAPER_DST" 2>/dev/null && ok "Gradient wallpaper generated" || {
            # Fallback to python
            python3 -c "
import struct
w, h = 1920, 1080
header = f'P6\n{w} {h}\n255\n'.encode()
pixels = b''
for y in range(h):
    for x in range(w):
        t = (x/w + y/h) / 2
        r = int(10 + t * 10)
        g = int(10 + t * 10)
        b = int(18 + t * 14)
        pixels += struct.pack('BBB', r, g, b)
with open('$WALLPAPER_DST', 'wb') as f:
    f.write(header + pixels)
" && ok "Dark wallpaper generated (PPM)" || warn "Set wallpaper manually at $WALLPAPER_DST"
        }
    else
        python3 -c "
import struct
w, h = 1920, 1080
header = f'P6\n{w} {h}\n255\n'.encode()
pixels = b''
for y in range(h):
    for x in range(w):
        t = (x/w + y/h) / 2
        r = int(10 + t * 10)
        g = int(10 + t * 10)
        b = int(18 + t * 14)
        pixels += struct.pack('BBB', r, g, b)
with open('$WALLPAPER_DST', 'wb') as f:
    f.write(header + pixels)
" && ok "Dark wallpaper generated" || warn "Set wallpaper manually at $WALLPAPER_DST"
    fi
else
    ok "Wallpaper already exists"
fi

# ═══════════════════════════════════════════════════════════════
step "Phase 6: Symlink All Configs"
# ═══════════════════════════════════════════════════════════════

create_symlink() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        mv "$dst" "${dst}.bak.$(date +%s)"
        warn "Backed up existing $(basename "$dst")"
    fi
    ln -sf "$src" "$dst"
}

log "Creating config symlinks..."

# Hyprland configs
create_symlink "$SCRIPT_DIR/hypr/hyprland.conf"     "$HOME/.config/hypr/hyprland.conf"
create_symlink "$SCRIPT_DIR/hypr/nvidia.conf"        "$HOME/.config/hypr/nvidia.conf"
create_symlink "$SCRIPT_DIR/hypr/monitors.conf"      "$HOME/.config/hypr/monitors.conf"
create_symlink "$SCRIPT_DIR/hypr/keybinds.conf"      "$HOME/.config/hypr/keybinds.conf"
create_symlink "$SCRIPT_DIR/hypr/windowrules.conf"   "$HOME/.config/hypr/windowrules.conf"
create_symlink "$SCRIPT_DIR/hypr/autostart.conf"     "$HOME/.config/hypr/autostart.conf"
create_symlink "$SCRIPT_DIR/hypr/hyprpaper.conf"     "$HOME/.config/hypr/hyprpaper.conf"
create_symlink "$SCRIPT_DIR/hypr/hyprlock.conf"      "$HOME/.config/hypr/hyprlock.conf"
create_symlink "$SCRIPT_DIR/hypr/hypridle.conf"      "$HOME/.config/hypr/hypridle.conf"

# Waybar
create_symlink "$SCRIPT_DIR/waybar/config.jsonc"     "$HOME/.config/waybar/config.jsonc"
create_symlink "$SCRIPT_DIR/waybar/style.css"        "$HOME/.config/waybar/style.css"

# Rofi
create_symlink "$SCRIPT_DIR/rofi/config.rasi"        "$HOME/.config/rofi/config.rasi"
create_symlink "$SCRIPT_DIR/rofi/theme.rasi"         "$HOME/.config/rofi/theme.rasi"

# Kitty
create_symlink "$SCRIPT_DIR/kitty/kitty.conf"        "$HOME/.config/kitty/kitty.conf"

# Dunst
create_symlink "$SCRIPT_DIR/dunst/dunstrc"           "$HOME/.config/dunst/dunstrc"

# tmux
create_symlink "$SCRIPT_DIR/tmux/tmux.conf"          "$HOME/.config/tmux/tmux.conf"

# Starship
create_symlink "$SCRIPT_DIR/starship.toml"           "$HOME/.config/starship.toml"

ok "All config symlinks created"

# ═══════════════════════════════════════════════════════════════
step "Phase 7: Shell Configuration"
# ═══════════════════════════════════════════════════════════════
BASHRC_SOURCE="source $SCRIPT_DIR/bashrc"
if ! grep -qF "$BASHRC_SOURCE" "$HOME/.bashrc" 2>/dev/null; then
    log "Adding custom bashrc to ~/.bashrc..."
    echo "" >> "$HOME/.bashrc"
    echo "# ── Hyprland Omarchy-style shell config ──" >> "$HOME/.bashrc"
    echo "$BASHRC_SOURCE" >> "$HOME/.bashrc"
    ok "bashrc sourced from ~/.bashrc"
else
    ok "bashrc already sourced"
fi

# ═══════════════════════════════════════════════════════════════
step "Phase 8: System Checks"
# ═══════════════════════════════════════════════════════════════

# Screenshots directory
mkdir -p "$HOME/Pictures/Screenshots"

# NVIDIA DRM modeset
GRUB_FILE="/etc/default/grub"
if grep -q "nvidia_drm.modeset=1" "$GRUB_FILE" 2>/dev/null; then
    ok "nvidia_drm.modeset=1 already set"
else
    warn "nvidia_drm.modeset=1 not found in GRUB"
    echo -e "  ${YELLOW}→ If you have rendering issues, run:${NC}"
    echo -e "    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"nvidia_drm.modeset=1 /' $GRUB_FILE"
    echo -e "    sudo update-grub && sudo reboot"
fi

# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}  ║              Setup Complete!                                 ║${NC}"
echo -e "${GREEN}${BOLD}  ╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}What was installed:${NC}"
echo -e "  ${CYAN}Desktop${NC}     Hyprland · Waybar · Rofi · Kitty · Dunst"
echo -e "  ${CYAN}Dev Tools${NC}  Neovim+LazyVim · lazygit · btop · tmux"
echo -e "  ${CYAN}Shell${NC}      starship · eza · bat · fd · rg · fzf · zoxide"
echo -e "  ${CYAN}Theme${NC}     Dark + Teal (#56b6c2) across all components"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "  1. Log out of GNOME"
echo -e "  2. At GDM login, click ⚙️  → select ${CYAN}Hyprland${NC}"
echo -e "  3. Log in and enjoy!"
echo ""
echo -e "  ${BOLD}Key bindings:${NC}"
echo -e "  ${CYAN}Super + Return${NC}     Terminal      ${CYAN}Super + D${NC}       Launcher"
echo -e "  ${CYAN}Super + Q${NC}          Close         ${CYAN}Super + F${NC}       Fullscreen"
echo -e "  ${CYAN}Super + 1-9${NC}        Workspaces    ${CYAN}Super + V${NC}       Float"
echo -e "  ${CYAN}Super + E${NC}          Files         ${CYAN}Super + B${NC}       Browser"
echo -e "  ${CYAN}Super + Shift + Q${NC}  Exit          ${CYAN}Super + C${NC}       Clipboard"
echo ""
echo -e "  ${BOLD}Dev shortcuts:${NC}"
echo -e "  ${CYAN}v${NC} or ${CYAN}vim${NC}  → nvim    ${CYAN}lg${NC}  → lazygit    ${CYAN}top${NC}  → btop"
echo -e "  ${CYAN}ls${NC}  → eza         ${CYAN}cat${NC} → bat         ${CYAN}cd${NC}   → zoxide"
echo ""
