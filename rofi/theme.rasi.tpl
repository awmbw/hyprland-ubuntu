/* ╔══════════════════════════════════════════════════════════════╗
   ║              Rofi — Auto-Themed                              ║
   ╚══════════════════════════════════════════════════════════════╝ */

* {
    bg:       rgba({{BG_RGB}}, 0.92);
    bg-alt:   rgba({{BG_ALT_RGB}}, 0.95);
    fg:       {{FG}};
    fg-dim:   {{FG_DIM}};
    accent:   {{ACCENT}};
    urgent:   {{WARNING}};
    border:   rgba({{ACCENT_RGB}}, 0.25);

    background-color: transparent;
    text-color:       @fg;
    font: "JetBrainsMono Nerd Font 12";
}

window {
    width:            600px;
    location:         center;
    anchor:           center;
    background-color: @bg;
    border:           2px solid;
    border-color:     @border;
    border-radius:    14px;
    padding:          0;
}

mainbox {
    background-color: transparent;
    children:         [ inputbar, listview ];
    spacing:          0;
    padding:          0;
}

inputbar {
    background-color: @bg-alt;
    text-color:       @fg;
    padding:          14px 18px;
    border-radius:    14px 14px 0 0;
    children:         [ prompt, entry ];
    spacing:          10px;
}

prompt {
    text-color: @accent;
    font: "JetBrainsMono Nerd Font Bold 12";
}

entry {
    text-color:        @fg;
    placeholder:       "Search...";
    placeholder-color: @fg-dim;
}

listview {
    background-color: transparent;
    lines:            8;
    columns:          1;
    fixed-height:     true;
    padding:          8px 0;
    scrollbar:        false;
    spacing:          2px;
}

element {
    padding:          10px 18px;
    background-color: transparent;
    text-color:       @fg;
    border-radius:    0;
}

element selected {
    background-color: rgba({{ACCENT_RGB}}, 0.15);
    text-color:       @accent;
}

element-text {
    background-color: transparent;
    text-color:       inherit;
    highlight:        bold;
}

element-icon {
    background-color: transparent;
    size:             24px;
    padding:          0 8px 0 0;
}
