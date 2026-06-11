background {
    monitor =
    path = ~/.config/hypr/wallpaper.png
    blur_passes = 3
    blur_size = 6
    noise = 0.02
    contrast = 0.9
    brightness = 0.6
    vibrancy = 0.2
}

input-field {
    monitor =
    size = 280, 48
    outline_thickness = 2
    dots_size = 0.25
    dots_spacing = 0.2
    dots_center = true
    dots_rounding = -1
    outer_color = rgba({{ACCENT_RGB}}, 0.4)
    inner_color = rgba({{BG_RGB}}, 0.85)
    font_color = rgb({{FG_RGB}})
    fade_on_empty = true
    fade_timeout = 2000
    placeholder_text = <i>  Enter Password...</i>
    hide_input = false
    rounding = 12
    check_color = rgba({{SUCCESS_RGB}}, 0.4)
    fail_color = rgba({{ERROR_RGB}}, 0.4)
    fail_text = <i>$FAIL</i>
    fail_transition = 300
    capslock_color = rgba({{WARNING_RGB}}, 0.4)
    position = 0, -120
    halign = center
    valign = center
}

label {
    monitor =
    text = $TIME
    color = rgba({{FG_RGB}}, 0.95)
    font_size = 72
    font_family = JetBrainsMono Nerd Font Bold
    position = 0, 80
    halign = center
    valign = center
    shadow_passes = 2
    shadow_size = 4
    shadow_color = rgba(0, 0, 0, 0.5)
}

label {
    monitor =
    text = cmd[update:3600000] date +"%A, %B %d"
    color = rgba({{FG_RGB}}, 0.6)
    font_size = 16
    font_family = JetBrainsMono Nerd Font
    position = 0, 20
    halign = center
    valign = center
}

label {
    monitor =
    text = Hi, $USER
    color = rgba({{ACCENT_RGB}}, 0.8)
    font_size = 14
    font_family = JetBrainsMono Nerd Font
    position = 0, -60
    halign = center
    valign = center
}
