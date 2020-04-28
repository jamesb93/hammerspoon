-- Construct a 'pomo'
pomo = {}

-- Time parameters of the pomo
pomo.params = {
    work_dur = 60 * 20, -- 60 seconds * 20 minutes
    srest_dur = 60 * 5, -- 60 seconds * 5 minutes
    lrest_dur = 60 * 15, -- 60 seconds * 15 minute
    logpath = "/Users/james/.pomo/.pomolog",
    timecoef = 1,
    chronoid = "pomodatetimeid"
}

pomo.data = {
    state = "work",
    time_now = pomo.params.work_dur,
    menu = hs.menubar.new(),
    work_count = 0,
    active = false,
    pause = false,
    sound = hs.sound.getByName("Glass")
}

print_map = {
    work = "w",
    srest = "r",
    lrest = "r"
}

function daily_check()
    -- Returns true if this is the first daily write otherwise false

    id = os.date("%x")
    print(id)
    print(hs.settings.get(pomo.params.chronoid))
    settings = hs.settings.getKeys()
    if settings[pomo.params.chronoid] ~= nil then
        if id ~= hs.settings.get(pomo.params.chronoid) then
            print('stored id does not match')
            hs.settings.set(pomo.params.chronoid, id)
            return true
        else
            print('ids match so no need to write')
            return false
        end
    else
        print('I should run once')
        hs.settings.set(pomo.params.chronoid, id)
        return true
    end
end

function log_entry(entry)
    log = io.open(pomo.params.logpath, "a")
    log:write(entry)
    log:write("\n")
    log:close()
end


function format_menu()
    local mins = string.format("%02.f", math.floor(pomo.data.time_now/60));
    local seconds = string.format("%02.f", math.floor(pomo.data.time_now-(mins*60)))
    local formed = string.format(
        "[%s |%01d| %s:%s]", 
        print_map[pomo.data.state], 
        pomo.data.work_count+1,
        mins,
        seconds
    )
    pomo.data.menu:setTitle(formed) -- TODO modularise this into a function that formats
end

function reset_all()
    timer:stop()
    pomo.data.state = "work"
    pomo.data.time_now = pomo.params.work_dur
    pomo.data.work_count = 0
    pomo.data.active = false
    pomo.data.pause = false
    format_menu()
end

function alert(alert_type)
    if alert_type == "end_work" then
        hs.osascript.applescriptFromFile("/Users/james/.hammerspoon/as/end_work.applescript")
    elseif alert_type == "end_rest_s" then
        hs.osascript.applescriptFromFile("/Users/james/.hammerspoon/as/end_rest_s.applescript")
    elseif alert_type == "end_rest_l" then
        hs.osascript.applescriptFromFile("/Users/james/.hammerspoon/as/end_rest_s.applescript")
    end
end

-- Called everytime the timer updates. Implemented as a callback function

-- This function does a lot of checking to see which state it is in
function update_time()
    -- Whenever the timer updates we need to subtract 1 second & format
    pomo.data.time_now = pomo.data.time_now - 1
    format_menu()

    if pomo.data.time_now <= 0 then -- when we get to the end of any timer
        timer:stop()
        -- Now figure out where to go next
        if pomo.data.state == "work" then -- if it was a work period
            alert("end_work")
            if pomo.data.work_count >= 2 then
                pomo.data.time_now = pomo.params.lrest_dur
                pomo.data.state = "lrest"
                pomo.data.active = false
            elseif pomo.data.work_count < 2 then
                pomo.data.time_now = pomo.params.srest_dur
                pomo.data.state = "srest"
                pomo.data.active = false
            end

        elseif pomo.data.state == "srest" then -- if it was a short rest period
            alert("end_rest_s")
            pomo.data.work_count = pomo.data.work_count+1
            pomo.data.time_now = pomo.params.work_dur
            pomo.data.state = "work"
            pomo.data.active = false

        elseif pomo.data.state == "lrest" then -- if it was a long rest period
            alert("end_rest_l")
            pomo.data.work_count = 0
            pomo.data.time_now = pomo.params.work_dur
            pomo.data.state = "work"
            pomo.data.active = false
            pomo.data.pause = false
        end
    end
end


function pomo_state_check()
    if pomo.data.active == false then -- the pomodoro hasnt been started
        if pomo.data.pause == false then -- and its not paused
            pomo.data.active = true            
            if daily_check() then log_entry(os.date("\n---- %c ----")) end
            local _, pomo_desc = hs.dialog.textPrompt("Pomo Description", "Give a description to your pomo", "", "", "", false)

            log_entry(
                os.date("%X") .. " | " .. pomo_desc
            )

            timer:start()

        end
    elseif pomo.data.active == true then -- the pomodoro has been started
        if pomo.data.pause == false then -- and its not paused
            pomo.data.pause = true-- we need to pause it
            timer:stop()
        elseif pomo.data.pause == true then
            pomo.data.pause = false
            timer:start()
        end
    end
end

function pomo_menu_click(mods)
    if mods["alt"] == false then
        pomo_state_check()
    elseif mods["alt"] == true then
        reset_all()
    end
end

if pomo then
    timer = hs.timer.new(pomo.params.timecoef, update_time)
    format_menu()
    pomo.data.menu:setClickCallback(pomo_menu_click)
end