---------- Caffeine ----------
caffeine = hs.menubar.new()
function set_caffeine_display(state)
	if state then
		caffeine:setTitle("!!")
	else
		caffeine:setTitle("--")
	end
end

function caffeine_clicked()
	set_caffeine_display(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
	caffeine:setClickCallback(caffeine_clicked)
	set_caffeine_display(hs.caffeinate.get("displayIdle"))
end