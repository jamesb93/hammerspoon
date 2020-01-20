backup = hs.menubar.new()
function done(exitCode, stdOut, stdErr)
	print(exitCode, stdErr, stdOut)
end
function cb()
	exec = hs.task.new("/Users/james/dev/setup_scripts/update.sh", done)
	exec:start()
end

backup:setTitle('hihi')
if backup then
	timer = hs.timer.doWhile(1, )
	backup:setClickCallback(cb)
	-- local power_source = hs.battery.powerSource()

	-- if power_source == "AC Power" then
	-- 	battery_percentage:setTitle(
	-- 		"(".."~"..math.floor(hs.battery.percentage())..")"
	-- 	)
	-- end

	-- if power_source == "Battery Power" then
	-- 	battery_percentage:setTitle(
	-- 		"("..math.floor(hs.battery.percentage())..")"
	-- 	)
	-- end
end