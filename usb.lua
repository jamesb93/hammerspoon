-- local devices = {
--     274 : 'v60-keyboard'
--     52225 : 'caldigit hub'
-- }
-- local audio_table = {
--     'Fireface UFX (23752577)' = 'de_RME_driver_USBAudioEngine:16A6F81'
-- }

function wifi_state(state)
    hs.wifi.setPower(state, 'en0')
end

function set_fireface_output()
    audio_devices = hs.audiodevice.allOutputDevices()
    local current = hs.audiodevice.current()
    if (current.uid ~= 'de_RME_driver_USBAudioEngine:16A6F81') then
        hs.audiodevice
        .findDeviceByUID('de_RME_driver_USBAudioEngine:16A6F81')
        :setDefaultOutputDevice()
    end
end

function watch(e)
    local event = e.eventType
    local id = e.productID
    local name = e.productName

    if (id == 52225 and event =='added') then
        wifi_state(true)
    end

    if (id == 50475 and event == 'added') then
        wifi_state(false)
    end

    if (id == 50475 and event == 'removed') then
        wifi_state(true)
    end

    -- Switch to Fireface @ Home
    -- if (id == 16328 and event == 'added') then set_fireface_output() end
end

watcher = hs.usb.watcher.new(watch)
watcher:start()
