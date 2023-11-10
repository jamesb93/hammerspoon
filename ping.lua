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

local function deepcopy(o, seen)
    seen = seen or {}
    if o == nil then return nil end
    if seen[o] then return seen[o] end
    
    local no
    if type(o) == 'table' then
        no = {}
        seen[o] = no
        
        for k, v in next, o, nil do
            no[deepcopy(k, seen)] = deepcopy(v, seen)
        end
        setmetatable(no, deepcopy(getmetatable(o), seen))
    else -- number, string, boolean, etc
        no = o
    end
    return no
end



