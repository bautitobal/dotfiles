-- Migrated Hyprland config to the Lua API format.
-- This keeps your existing setup but uses the modern hl.* syntax.

local terminal = "kitty"
local secondTerminal = "foot"
local fileManager = "dolphin"
local menu = "rofi -show drun -i"
local browser = "brave"
local mainMod = "SUPER"

local reloadWaybar = "pkill waybar; waybar &"

hl.env("HYPRCURSOR_THEME", "Nordic-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Nordic-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("TZ", "America/Argentina/Buenos_Aires")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("GBM_BACKEND", "nvidia-drm")

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60.0",
    position = "0x0",
    scale = 1.0,
})

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@144.0",
    position = "1920x0",
    scale = 1.0,
})

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1.2,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("hyprctl dispatch workspace 1")
    hl.exec_cmd("qs -c noctalia-shell")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("~/dotfiles/scripts/focus_reminder.sh")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 5,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo = true,
    },

    input = {
        kb_layout = "us,latam",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:alt_space_toggle",
        kb_rules = "",
        follow_mouse = 1,
        scroll_factor = 1.0,
        scroll_method = "on_button_down",
        scroll_button = 274,
        repeat_rate = 35,
        repeat_delay = 250,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },

    cursor = {
        inactive_timeout = 30,
        no_hardware_cursors = true,
    },
})

hl.animation({ leaf = "global", enabled = false })
-- Preserve the previous visual style with explicit curves and disabled animation.
hl.curve("easeOut", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("easeIn", { type = "bezier", points = { { 0.1, 0.0 }, { 0.0, 1.0 } } })

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(secondTerminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mainMod .. " + CTRL + SHIFT + P", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(reloadWaybar))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("keepassxc"))
hl.bind(mainMod .. " + SHIFT + PERIOD", hl.dsp.exec_cmd("rofimoji"))

hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + ALT + M", hl.dsp.exit())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + G", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next())

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/dotfiles/scripts/toggle-waybar.sh"))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("~/dotfiles/scripts/zen-mode.sh"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("~/dotfiles/scripts/mic-toggle"))

hl.bind("Print", hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh copy"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh area"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh monitor"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh all"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0 }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0 }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -20 }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 20 }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.swap({ direction = "right" }))

hl.bind(mainMod .. " + C", hl.dsp.window.center())

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && ~/.config/hypr/scripts/notifications.sh volume"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/.config/hypr/scripts/notifications.sh volume"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ~/.config/hypr/scripts/notifications.sh mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && ~/.config/hypr/scripts/notifications.sh mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+ && ~/.config/hypr/scripts/notifications.sh brightness"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%- && ~/.config/hypr/scripts/notifications.sh brightness"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "calculator-float",
    match = { class = "org.gnome.Calculator" },
    float = true,
    size = "800 600",
    center = true,
})

hl.window_rule({
    name = "calculator-float-legacy",
    match = { class = "Calculator" },
    float = true,
    size = "800 600",
    center = true,
})

hl.window_rule({
    name = "kcalc-float",
    match = { class = "org.kde.kcalc" },
    float = true,
    size = "800 600",
    center = true,
})

hl.window_rule({
    name = "archive-float",
    match = { class = "file-roller|ark|org.kde.ark" },
    float = true,
})

hl.window_rule({
    name = "pavucontrol-float",
    match = { class = "pavucontrol" },
    float = true,
    size = "1000 700",
    center = true,
})

hl.window_rule({
    name = "dialog-center",
    match = { title = "^(Open|Save|Confirm|Preferences|Settings)" },
    float = true,
    center = true,
})

hl.window_rule({
    name = "scratchpad-float",
    match = { class = "scratchpad" },
    float = true,
    size = "1200 700",
    center = true,
})

hl.window_rule({
    name = "waypaper-float",
    match = { class = "waypaper" },
    float = true,
    size = "900 650",
    center = true,
})

hl.window_rule({
    name = "xwayland-video-bridge-fixes",
    match = { class = "xwaylandvideobridge" },
    no_initial_focus = true,
    no_focus = true,
    no_anim = true,
    no_blur = true,
    max_size = "1 1",
    opacity = 0.0,
})

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })
