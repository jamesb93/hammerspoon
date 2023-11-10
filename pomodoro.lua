local WORK = 20*60 -- 20 minutes
local elapsed_time = 0

function secondsToMinutesAndSeconds(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

local function remaining_time()
	return secondsToMinutesAndSeconds(WORK-elapsed_time)
end

local menubar_item = hs.menubar.new(true, 'pomo'):setTitle("👀"..remaining_time())

local timer
timer = hs.timer.new(1, function()
	elapsed_time = elapsed_time + 1
	if (elapsed_time > WORK) then
		hs.notify.new({title="Eye Break", informativeText="Time to take a break!"}):send()
		timer:stop()
		elapsed_time = 0
	end
	menubar_item:setTitle("👀"..remaining_time())
end)

local function startStopPauseReset()
	if timer:running() then
		timer:stop()
	else
		timer:start()
	end

end

menubar_item:setClickCallback(startStopPauseReset)
