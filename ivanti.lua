event_map = { 
	[5] = "open", 
	[6] = "close" 
}

function is_avanti(name, event)
	return name == 'Ivanti Secure Access Client' and event_map[event] == "open"
end

function cb(name, e, app)
	if is_avanti(name, e) then
		app:hide()
	end
end

local watcher = hs.application.watcher.new(cb)
watcher:start()
