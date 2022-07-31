hyper = {'cmd', 'shift'}


function simulate_typing()
	local paste = hs.pasteboard.getContents()
	if paste ~= nil then
		hs.eventtap.keyStrokes(paste)
	end
end

hs.hotkey.bind(hyper, 'i', simulate_typing)

