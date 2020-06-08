local cmd = "/usr/local/bin/yabai -m "
local numspaces = 5

-- Reload Hammerspoon
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
    hs.reload()
end)
hs.alert.show("Config loaded")

-- Focus Windows
-- local focus_win = {
--     j = "west",
--     l = "east",
--     i = "north",
--     k = "south"
-- }

-- for k, v in pairs(focus_win) do
--     hs.hotkey.bind(
--     {"shift, cmd"}, k, function()
--         os.execute(cmd.."window --focus "..v)
--     end)
-- end

-- Balance space
-- hs.hotkey.bind(
--     {"shift, cmd"}, "\\", function()
--         os.execute(cmd .. "space --balance")
--     end
-- )

-- Delete space
hs.hotkey.bind(
    {"shift, cmd"}, "w", function()
        os.execute(cmd .. "space --destroy")
    end
)

-- Create space
hs.hotkey.bind(
    {"shift, cmd"}, ";", function()
        os.execute(cmd .. "space --create")
    end
)

-- Next space
hs.hotkey.bind(
    {"ctrl"}, "right", function()
        os.execute(cmd.. "space --focus next || "..cmd.."space --focus first")
    end
)

-- Prev space
hs.hotkey.bind(
    {"ctrl"}, "left", function()
        os.execute(cmd.. "space --focus prev || "..cmd.."space --focus last")
    end
)

-- Maximise a window
-- hs.hotkey.bind(
--     {"cmd"}, "return", function()
--         os.execute(cmd.."window --toggle zoom-parent")
--     end
-- )

-- Move windows inside a space
-- hs.hotkey.bind(
    -- {"cmd"}, "left", function()
        -- os.execute(cmd .. "window --warp west")
    -- end
-- )
-- 
-- hs.hotkey.bind({"cmd"}, "right", function()
        -- os.execute(cmd .."window --warp east")
   -- end
-- )

-- Programatic Keybindings
for i=1, numspaces do
    i = tostring(i)
    -- Space Switching
    hs.hotkey.bind({"alt"}, i, function()
        os.execute(cmd .."space --focus " .. i)
    end)

    -- Send window to desktop and follow focus
    hs.hotkey.bind({"shift, cmd"}, i, function()
        os.execute(
            cmd.."window --space "..i..
            " && ".. 
            cmd.."space --focus "..i)
    end)
end

----------------------------------------------------------------
-- Unused or deprecated functions
----------------------------------------------------------------
-- hs.hotkey.bind(
--     {"cmd"}, "up", function()
--         hs.execute("/usr/local/bin/yabai -m window --warp north")
--     end
-- )

-- hs.hotkey.bind(
--     {"cmd"}, "down", function()
--         hs.execute("/usr/local/bin/yabai -m window --warp south")
--     end
-- )
