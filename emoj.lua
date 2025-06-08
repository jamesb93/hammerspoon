local lastBackslashPressTime = 0
local DOUBLE_PRESS_THRESHOLD = 0.3 -- Time in seconds for a double press (adjust as needed)

-- The function to execute on a double backslash
local function doubleBackslashAction()
    hs.alert.show("Double backslash detected!")
    print("Double backslash detected!")
    -- Add your desired actions here
end

print("me loaded")

-- Bind the single backslash key
-- We're using the keycode 42 for backslash based on your example.
-- Make sure this keycode is correct for your keyboard layout.
-- Alternatively, you can use the character string: "\\"
hs.hotkey.bind({}, 42, nil, function()
    local currentTime = hs.timer.secondsSinceEpoch()
    print("foo bar")
    if (currentTime - lastBackslashPressTime) < DOUBLE_PRESS_THRESHOLD then
        -- This is the second backslash within the threshold
        doubleBackslashAction()
        lastBackslashPressTime = 0 -- Reset for the next double press
    else
        -- This is the first backslash press
        lastBackslashPressTime = currentTime
        -- You might want to briefly show a visual cue or set a timer
        -- to indicate a single press, or just let it pass if no double press occurs.
        -- print("Single backslash detected, waiting for double...")
    end
end,
nil, nil -- Optional: you can add up/down/repeat callbacks here if needed
)

-- Optional: To prevent accidental double presses or clear the state
-- if another key is pressed between backslashes, you could add:
hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, function(event)
    if event:getKeyCode() ~= 42 then -- If it's not the backslash key
        lastBackslashPressTime = 0 -- Reset the double press detection
    end
end):start()