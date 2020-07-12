require("lib")

-- 2. Filter and Update the view
local valid_wins = {}
local chooser = hs.chooser.new(function(choice)
	if choice then 
		local id = choice["text"]
		local win = valid_wins[id]
		win:application():activate()
	end
	valid_wins = {}
end)
-- Set the sub text to be transparent
local subColor = {
	red = 0.8,
	green = 0.8,
	blue = 0.8,
	alpha = 0.25
}
chooser:subTextColor(subColor)

function customSort(a, b)
	id1 = a["text"]
	id2 = b["text"]
	dist1 = distances[id1]
	dist2 = distances[id2]
	return dist1 < dist2
end

function rofi()
	local wins = hs.window.allWindows()
	local choices = {}
	for k, v in pairs(wins) do
		local title = v:title()
		if title ~= "" then
			local app = v:application():name()
			local PID = tostring(v:id())
			id = tostring(app.."  |  "..title)
			valid_wins[id] = v
			choices[#choices+1] = {
				["text"] = id,
				["subText"] = PID
			}

		end
	end

	chooser:choices(choices)
	
	chooser:queryChangedCallback(function(ins)
		distances = {}
		for k, v in pairs(valid_wins) do
			local n = v:application():name()
			distances[k] = lib.damleven(ins, n) * (1.0 / lib.weightearly(ins, n, 2))
		end

		table.sort(choices, customSort)
		chooser:choices(choices)
	end)
	
	chooser:show()
end

hs.hotkey.bind({"alt"}, "tab", rofi)


