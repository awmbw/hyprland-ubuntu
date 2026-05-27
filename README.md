# Ubuntu Hyprland Setup

A clean, developer-focused, and highly polished Hyprland configuration tailored specifically for Ubuntu 26.04 LTS. This setup provides a fast, keyboard-centric workflow out of the box with a beautiful "Deep Ocean" (deep navy, turquoise, and sage green) aesthetic.

![Screenshot](wallpaper.png)

## Features

- **Window Manager:** Hyprland (Wayland)
- **Bar:** Waybar
- **Terminal:** Kitty
- **App Launcher & Menus:** Rofi (Wayland fork)
- **Notifications:** Dunst
- **Lock Screen:** Hyprlock
- **Idle Manager:** Hypridle
- **Shell:** Bash with Starship prompt
- **Editor:** Neovim + LazyVim
- **NVIDIA Support:** Configured out-of-the-box for smooth NVIDIA Wayland performance

### Modern CLI Stack Included
- `fzf` (Fuzzy finder)
- `zoxide` (Smarter `cd`)
- `eza` (Modern `ls` replacement)
- `bat` (Modern `cat` with syntax highlighting)
- `fd` / `rg` (Fast search tools)
- `btop` (Resource monitor)
- `lazygit` & `lazydocker` (Terminal UIs for Git and Docker)

## Installation

**Note:** This is designed for Ubuntu 26.04 LTS.

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/awmbw/hyprland-ubuntu.git ~/hyprland_ubuntu
   cd ~/hyprland_ubuntu
   ```

2. Run the installation script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. Log out of your current session.
4. On the GDM login screen, click the gear icon in the bottom right corner and select **Hyprland**.
5. Log in.

## Keybindings Cheatsheet

Once logged in, press **`Super + K`** to open the interactive keybinds cheatsheet via Rofi.

Here are a few essential shortcuts to get started:
- `Super + Return`: Terminal (Kitty)
- `Super + Space`: App Launcher (Rofi)
- `Super + B`: Browser (Chrome)
- `Super + W`: Close Window
- `Super + Shift + Q`: Exit Hyprland

## Structure

This repository uses a symlink approach. The `install.sh` script will link configurations from `~/hyprland_ubuntu` to `~/.config/`. This means you can update your configs in the repo directory, commit them, and push them back to GitHub seamlessly.
