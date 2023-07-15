local hyper = {"cmd"}

local function getWindows()
	local win = hs.window.focusedWindow()
	local screen = win:screen()
	return win, screen
end

local function getFrames(win, screen)
	return win:frame(), screen:frame()
end

local function calcNextRatio(win, screen, command)
	-- Is it on the left and you're asking to go on the right?

	if command == 'left' and win.x + (win.w / 2) >= screen.w / 2 then
		return 2
	end
	
	if command == 'right' and win.x + (win.w / 2) < screen.w / 2 then
		return 2
	end

	-- calculates the ratio that the screen takes up currently
	local ratio = 1 / (win.w / screen.w)

	if ratio == 2 then
		return 3 / 2
	elseif ratio == (3 / 2) then
		return 3
	elseif ratio == 3 then
		return 2
	end

	return 2
end

local function setWindowFrameRect(window, windowframe, x, y, w, h)
	windowframe.x = x
	windowframe.y = y
	windowframe.w = w
	windowframe.h = h
	window:setFrame(windowframe, 0)
end

hs.hotkey.bind(hyper, "left", function()
	local win, screen = getWindows()
	local wf, sf = getFrames(win, screen)
	local nextRatio = calcNextRatio(wf, sf, "left")
	setWindowFrameRect(win, wf, sf.x, sf.y, sf.w / nextRatio, sf.h)
end)

hs.hotkey.bind(hyper, "right", function()
	local win, screen = getWindows()
	local wf, sf = getFrames(win, screen)
	local nextRatio = calcNextRatio(wf, sf, "right")
	local offset = sf.x + (sf.w - (sf.w / nextRatio))
	setWindowFrameRect(win, wf, offset, sf.y, sf.w / nextRatio, sf.h)
end)

hs.hotkey.bind(hyper, "return", function()
	local win, screen = getWindows()
	local wf, sf = getFrames(win, screen)
	setWindowFrameRect(win, wf, sf.x, sf.y, sf.w, sf.h)
end)

local screenHyper = {"ctrl", "shift"}
hs.hotkey.bind(screenHyper, "up", function()
	local win, screen = getWindows()
	local next = screen:next()
	win:moveToScreen(next, true)
end)
