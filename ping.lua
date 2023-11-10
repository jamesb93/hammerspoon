local timeStart = 0
local timeEnd = 0
local lastPingTime = 0
menubar_item = hs.menubar.new(true, 'ping'):setTitle("🛜 "..lastPingTime)
pinger = nil
timer = nil

buffer = {}

function setPingTimeDisplay()
    local medianPingTime = 0
    local maxPingTime = 0
    if #buffer > 0 then
        local buffercpy = deepcopy(buffer)
        table.sort(buffercpy)
        maxPingTime = buffercpy[#buffercpy]
        local mid = math.floor(#buffercpy / 2)
        if #buffercpy % 2 == 0 then
            medianPingTime = (buffercpy[mid] + buffercpy[mid + 1]) / 2
        else
            medianPingTime = buffercpy[mid + 1]
        end
    end
    local medianPingTimeDisplay = string.format("%.0f", medianPingTime)
	local maxPingTimeDisplay    = string.format("%.0f", maxPingTime)
	menubar_item:setTitle("🛜 "..medianPingTimeDisplay.." | "..maxPingTimeDisplay)
end

function setFailure()
	menubar_item:setTitle("🛜 🔴")
end

function doPing()
    local s = ''
    for i=1, #buffer do
        s = s .. string.format("%.0f", buffer[i]) .. " "
    end
    print(s)
    pinger = hs.network.ping("8.8.8.8", 1, 0.001, 1, function(object, message, seqnum, error)
        if message == "didStart" then
            timeStart = hs.timer.secondsSinceEpoch()
        elseif message == "receivedPacket" then
            timeEnd = hs.timer.secondsSinceEpoch()
        elseif message == "didFinish" then
            lastPingTime = 1000 * (timeEnd - timeStart - 0.001) -- we have to subtract the time it takes to send the packet
            buffer[#buffer+1] = lastPingTime
            if #buffer > 20 then
                table.remove(buffer, 1)
            end
            setPingTimeDisplay()
        elseif message == "timeout" then
            setFailure()
        end
    end)
end

doPing()
timer = hs.timer.doEvery(3, doPing)

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


