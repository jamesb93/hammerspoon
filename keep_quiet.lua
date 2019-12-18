function mute_from_wake(event_type)
    if event_type == hs.caffeinate.watcher.systemDidWake then
        local output = hs.audiodevice.defaultOutputDevice()
        output:setMuted(true)
    end
end

wake_watcher = hs.caffeinate.watcher.new(mute_from_wake)
wake_watcher:start()