/* ╔══════════════════════════════════════════════════════════════╗
   ║              Waybar — Auto-Themed                            ║
   ╚══════════════════════════════════════════════════════════════╝ */

/* ── Reset ──────────────────────────────────────── */
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font", "JetBrainsMono NF", "Noto Sans", sans-serif;
    font-size: 13px;
    min-height: 0;
    margin: 0;
    padding: 0;
}

/* ── Bar ────────────────────────────────────────── */
window#waybar {
    background: rgba({{BG_RGB}}, 0.85);
    border-radius: 14px;
    border: 1px solid rgba({{ACCENT_RGB}}, 0.2);
    color: {{FG}};
    transition: background 0.3s ease;
}

window#waybar.hidden {
    opacity: 0;
}

tooltip {
    background: rgba({{BG_RGB}}, 0.95);
    border: 1px solid rgba({{ACCENT_RGB}}, 0.3);
    border-radius: 10px;
    color: {{FG}};
}

tooltip label {
    color: {{FG}};
    font-size: 12px;
}

/* ── Workspaces ─────────────────────────────────── */
#workspaces {
    margin-left: 6px;
}

#workspaces button {
    color: rgba({{FG_RGB}}, 0.4);
    padding: 2px 8px;
    margin: 4px 2px;
    border-radius: 8px;
    background: transparent;
    transition: all 0.2s ease;
    font-size: 14px;
}

#workspaces button:hover {
    color: rgba({{FG_RGB}}, 0.8);
    background: rgba({{ACCENT_RGB}}, 0.1);
}

#workspaces button.active {
    color: {{ACCENT}};
    background: rgba({{ACCENT_RGB}}, 0.15);
    text-shadow: 0 0 8px rgba({{ACCENT_RGB}}, 0.5);
    font-weight: bold;
}

#workspaces button.urgent {
    color: {{WARNING}};
    background: rgba({{WARNING_RGB}}, 0.15);
}

/* ── Window Title ───────────────────────────────── */
#window {
    color: rgba({{FG_RGB}}, 0.6);
    padding: 0 12px;
    margin-left: 8px;
    font-size: 12px;
    font-style: italic;
}

window#waybar.empty #window {
    background: transparent;
    padding: 0;
}

/* ── Clock ──────────────────────────────────────── */
#clock {
    color: {{FG}};
    font-weight: 600;
    font-size: 13px;
    padding: 0 14px;
    letter-spacing: 0.5px;
}

/* ── Module Defaults ────────────────────────────── */
#cpu,
#memory,
#pulseaudio,
#network,
#battery,
#tray {
    color: rgba({{FG_RGB}}, 0.75);
    padding: 0 10px;
    margin: 4px 2px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.04);
    transition: all 0.2s ease;
}

#cpu:hover,
#memory:hover,
#pulseaudio:hover,
#network:hover,
#battery:hover {
    color: {{FG}};
    background: rgba({{ACCENT_RGB}}, 0.1);
}

/* ── CPU ────────────────────────────────────────── */
#cpu {
    color: rgba({{COLOR2_RGB}}, 0.85); /* Green-ish */
}

/* ── Memory ─────────────────────────────────────── */
#memory {
    color: rgba({{COLOR4_RGB}}, 0.85); /* Blue-ish */
}

/* ── Audio ──────────────────────────────────────── */
#pulseaudio {
    color: rgba({{COLOR3_RGB}}, 0.85); /* Yellow-ish */
}

#pulseaudio.muted {
    color: rgba({{FG_RGB}}, 0.3);
}

/* ── Network ────────────────────────────────────── */
#network {
    color: rgba({{COLOR6_RGB}}, 0.85); /* Cyan-ish */
}

#network.disconnected {
    color: rgba({{FG_RGB}}, 0.3);
}

/* ── Battery ────────────────────────────────────── */
#battery {
    color: rgba({{COLOR2_RGB}}, 0.85); /* Green-ish */
}

#battery.warning {
    color: rgba({{WARNING_RGB}}, 0.9);
}

#battery.critical {
    color: rgba({{ERROR_RGB}}, 0.9);
    animation: blink 1.5s ease-in-out infinite;
}

#battery.charging,
#battery.plugged {
    color: rgba({{COLOR2_RGB}}, 0.9);
}

@keyframes blink {
    0% { opacity: 1; }
    50% { opacity: 0.5; }
    100% { opacity: 1; }
}

/* ── Tray ───────────────────────────────────────── */
#tray {
    background: transparent;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
}

/* ── Power ──────────────────────────────────────── */
#custom-power {
    color: rgba({{ERROR_RGB}}, 0.7);
    padding: 0 12px 0 8px;
    margin: 4px 4px 4px 2px;
    border-radius: 8px;
    font-size: 14px;
    transition: all 0.2s ease;
}

#custom-power:hover {
    color: {{ERROR}};
    background: rgba({{ERROR_RGB}}, 0.12);
}
