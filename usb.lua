-- local devices = {
--     274 : 'v60-keyboard'
--     52225 : 'caldigit hub'
-- }
-- local audio_table = {
--     'Fireface UFX (23752577)' = 'de_RME_driver_USBAudioEngine:16A6F81'
-- }

-- function set_fireface_output()
--     audio_devices = hs.audiodevice.allOutputDevices()
--     local current = hs.audiodevice.current()
--     if (current.uid ~= 'de_RME_driver_USBAudioEngine:16A6F81') then
--         hs.audiodevice
--         .findDeviceByUID('de_RME_driver_USBAudioEngine:16A6F81')
--         :setDefaultOutputDevice()
--     end
-- end

function wifi_state(state)
    hs.wifi.setPower(state, 'en0')
end

function watch(e)
    local event = e.eventType
    local id = e.productID
    local name = e.productName
    
    if (id == 33107) then
        if (event == 'added') then
            wifi_state(false)
        elseif (event == 'removed') then
            wifi_state(true)
        end
    end
end

watcher = hs.usb.watcher.new(watch)
watcher:start()
