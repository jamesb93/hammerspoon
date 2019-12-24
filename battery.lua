---------- Battery Percentage ----------
-- battery_percentage = hs.menubar.newWithPriority()
battery_percentage = hs.menubar.new()

function battery_callback()
	if battery_percentage then
		local power_source = hs.battery.powerSource()

		if power_source == "AC Power" then
			battery_percentage:setTitle(
				"(".."~"..math.floor(hs.battery.percentage())..")"
			)
		end

		if power_source == "Battery Power" then
			battery_percentage:setTitle(
				"("..math.floor(hs.battery.percentage())..")"
			)
		end
	end
end
battery_callback()
battery_watcher = hs.battery.watcher.new(battery_callback)
battery_watcher:start()