------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor({
--     output   = "",
--     mode     = "preferred",
--     position = "auto",
--     scale    = "auto",
-- })
sunshine = true
if sunshine then
hl.monitor({ output = "DP-1", mode = "maxwidth", position = "auto", scale = "auto" })
else
hl.monitor({ output = "DP-1", disabled = true})
end
hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1.5, mirror = "DP-1" })
hl.monitor({ output = "HDMI-A-1", mode = "maxwidth", position = "auto", scale = 1.25, mirror = "DP-1" })
hl.monitor({ output = "HDMI-A-2", mode = "maxwidth", position = "auto", scale = 1.25, mirror = "DP-1" })


hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })
hl.workspace_rule({ workspace = "5", persistent = true })
