hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)
hs.alert.show("Config loaded")

hs.hotkey.bind(
    {"cmd"}, "left", function()
        hs.execute("/usr/local/bin/yabai -m window --warp west")
    end
)

hs.hotkey.bind(
    {"cmd"}, "right", function()
        hs.execute("/usr/local/bin/yabai -m window --warp east")
    end
)

hs.hotkey.bind(
    {"cmd"}, "up", function()
        hs.execute("/usr/local/bin/yabai -m window --warp north")
    end
)

hs.hotkey.bind(
    {"cmd"}, "down", function()
        hs.execute("/usr/local/bin/yabai -m window --warp south")
    end
)

