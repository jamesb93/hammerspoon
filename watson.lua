-- module for painting a status bar showing watson status

watson_path = os.getenv("HOME") .. "/.config/watson/state"

function get_watson_state()
	rv = hs.execute('watson status', true)
	return rv == "No project started.\n" and 0 or 1
end

function set_display_state()
	watson.tracking = get_watson_state()
	local words = watson.tracking == 0 and 'Off' or 'On'
	local icons = watson.tracking == 0 and '🔴' or '🟢'
	watson.menubar:setTitle(icons..words)
end

watson = {
	menubar = hs.menubar.new(true, "watson-tracker"),
	watcher = hs.pathwatcher.new(watson_path, set_display_state),
	tracking = 0
}

watson.watcher:start()
set_display_state()

watson.menubar:setClickCallback(function()
	if watson.tracking == 1 then
		hs.execute('watson stop', true)
	end
end)