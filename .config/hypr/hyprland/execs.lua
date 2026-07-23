-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function () 
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.on("hyprland.start", function()
    hl.exec_cmd('hyprpm reload')
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    -- hl.exec_cmd("sunshine")
    -- hl.exec_cmd("wechat")


    hl.exec_cmd("wl-paste --type text --watch cliphist store")   -- 监听文本复制
    hl.exec_cmd("wl-paste --type image --watch cliphist store")  -- 监听图片复制




    -- hl.exec_cmd("hyprctl output create headless HEADLESS-2")
    -- hl.exec_cmd("hyprctl keyword monitor HDMI-A-1,disable")
    -- hl.exec_cmd("wayvnc -o DP-1 -f 120")
end)
