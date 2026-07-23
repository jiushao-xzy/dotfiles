
---------------------
---- KEYBINDINGS ----
---------------------
--mainMod
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

--apps
local terminal    = "alacritty"
local fileManager = "thunar"
local menu        = "wofi --show drun --allow-images --normal-window --width 400"

-- exit
-- bind = mainMod+Shift, e, exec, uwsm stop
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"))
-- bind = mainMod SHIFT, E, exec, systemctl --user stop "app-*.scope 2">/dev/null; uwsm stop

-- lock
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))


-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- brightness
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("hyprlock"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })


--Windows Manager
-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
-- Move focus with mainMod + h/k/l/j
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))

-- Move focus with mainMod + [/]
hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ direction = "right" }))

-- Window split ratio +/- 0.1
--hl.bind(mainMod .. " + minus",      hl.dsp.layoutmsg("mfact -0.1"))
--hl.bind(mainMod .. " + equal",      hl.dsp.layoutmsg("mfact +0.1"))
--hl.bind(mainMod .. " + semicolon",  hl.dsp.layoutmsg("mfact -0.1"))
--hl.bind(mainMod .. " + apostrophe", hl.dsp.layoutmsg("mfact +0.1"))

-- Move/resize windows with mainMod + mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Kill window
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
-- hl.bind(mainMod .. " + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))

-- Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())


-- Toggle floating
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Switch windows (Alt+Tab)
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

-- --expo (mainMod+Tab)
-- hl.bind(mainMod .. " + Tab",function()hl.plugin.hyprexpo.expo("toggle")end)



-- Workspace navigation
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces with mainMod + mouse wheel
hl.bind(mainMod .. " + mouse_up",     hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + " .. mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + " .. mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r-1" }))

-- Scroll with Ctrl+Super+Left/Right
hl.bind("CTRL + " .. mainMod .. " + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + " .. mainMod .. " + Left",  hl.dsp.focus({ workspace = "r-1" }))

-- Scroll with Page Up/Down
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + " .. mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + " .. mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "r-1" }))

-- Scroll non-empty workspaces with Ctrl+Super+Alt+Left/Right
hl.bind("CTRL + " .. mainMod .. " + ALT + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("CTRL + " .. mainMod .. " + ALT + Left",  hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("special"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:special" }))


-- Apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("uwsm app -- firefox"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("uwsm app -- " .. fileManager))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("uwsm app -- " .. menu))
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd("uwsm app -- code"))
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("uwsm app -- lx-music-desktop"))
hl.bind(mainMod .. " + Z",      hl.dsp.exec_cmd("uwsm app -- zotero"))


-- Screenshot
hl.bind("CTRL + ALT + A",       hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/ScreenShot/"))
hl.bind("ALT + SHIFT + A",      hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/ScreenShot/"))
hl.bind("CTRL + ALT + SHIFT + A", hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/ScreenShot/"))



-- Paste (clipboard manager)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(
    "bash -c 'cliphist list | wofi --dmenu --allow-images --normal-window --width 400 --prompt=\"Clipboard\" | cliphist decode | wl-copy'"
))


-- Wallpapers
hl.bind(mainMod .. " + W",        hl.dsp.exec_cmd(
    "bash -c 'wall=$(~/.config/hypr/scripts/wallpaper/wallpaper_random.sh); awww img \"$wall\" --transition-type wave; killall -SIGUSR2 waybar'"
))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper/wofi-wallpaper-selector.sh"))


--~
hl.bind("SHIFT + ESCAPE", hl.dsp.exec_cmd("wtype '~'"))
