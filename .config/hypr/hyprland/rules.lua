--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})



hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})






-- #set opacity for alacritty activation：1

hl.window_rule({
    match = {
        class = "^Alacritty$", 
    },
    opacity = "1 0.85", 
})

hl.window_rule({
  name = "force-fullscreen-waydroid",
  match = {
    class = "^Waydroid$",
  },
  --persistent_size = true,
  fullscreen_state = "2 2",  -- internal,client
  --max_size = {1920,1080},
  --min_size = {1920,1080}
})

hl.window_rule({
    name = "firefox-on-ws3",
    match = {
        class = "^firefox$", 
    },
    workspace = "3"
})


