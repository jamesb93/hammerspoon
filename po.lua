require("po_notify")
require("po_data")
-- Construct a 'pomo'
pomo = {}

-- Time parameters of the pomo
pomo.params = {
    work_dur = 60 * 20, -- 60 seconds * 20 minutes
    srest_dur = 60 * 5, -- 60 seconds * 5 minutes
    lrest_dur = 60 * 15, -- 60 seconds * 15 minute
    timecoef = 1, -- can be lowered for testing
}

pomo.data = {
    state = "work",
    time_now = pomo.params.work_dur,
    menu = hs.menubar.new(),
    project_chooser = hs.menubar.new(),
    project = "phd",
    work_count = 0,
    active = false,
    pause = false,
}

print_map = {
    work = "w",
    srest = "r",
    lrest = "r"
}

function format_menu()
    local mins = string.format("%02.f", math.floor(pomo.data.time_now/60));
    local seconds = string.format("%02.f", math.floor(pomo.data.time_now-(mins*60)))
    local formed = string.format(
        "[%s %s:%s]", 
        print_map[pomo.data.state], 
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
        work:send()
    else
        rest:send()
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
            add_entry(pomo.data.project)
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

pomo.data.project_chooser:setMenu({
    {title = "PhD", fn = function() pomo.data.project = "phd"; pomo.data.project_chooser:setTitle(pomo.data.project) end},
    {title = "Fell", fn = function() pomo.data.project = "fell"; pomo.data.project_chooser:setTitle(pomo.data.project) end},
    {title = "MetaBow", fn = function() pomo.data.project = "metabow"; pomo.data.project_chooser:setTitle(pomo.data.project) end}
})

function pomo_menu_click(mods)
    if mods then -- this was a click with modifiers not a keyboard shortcut
        if mods["alt"] == false then
            pomo_state_check()
        elseif mods["alt"] == true then
            reset_all()
        end
    else
        pomo_state_check()
    end
end



if pomo then
    timer = hs.timer.new(pomo.params.timecoef, update_time)

    -- Make a hotkey to emulate the click
    hotkey = hs.hotkey.bind(
        {"cmd", "shift"}, -- modifiers
        "`", -- key
        "Pomodoro Toggled", --message,
        pomo_menu_click -- function when pressed
    )

    format_menu()
    pomo.data.project_chooser:setTitle(pomo.data.project)
    pomo.data.menu:setClickCallback(pomo_menu_click)
end