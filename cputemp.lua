cputemp = hs.menubar.new()

function cb()
	if cputemp then
        local power_source = hs.host.thermalState()
        local ascii = nil
        local ascii = [[ASCII:
        
        ]]
        if power_source == "nominal" then

        

        end



        
        
                cputemp:setTitle()
	end
end

cb()
watcher = hs.battery.watcher.new(cb)
watcher:start()