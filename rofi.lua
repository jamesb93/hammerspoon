require("lib")
require("fzsearch")

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
	-- Get the text value of each a and b and query the distance table with that text
	return distances[a["text"]] < distances[b["text"]]
end

function rofi()
	chooser:query("")
	local wins = hs.window.allWindows()
	local choices = {}

	for i=1, #wins do
		local title = wins[i]:title()
		if title ~= "" then
			local app = wins[i]:application():name()
			local PID = tostring(wins[i]:id())
			local id = app.." | "..title
			valid_wins[id] = wins[i]
			choices[#choices+1] = {["text"] = id, ["subText"] = PID}
		end
	end

	chooser:choices(choices)
	chooser:queryChangedCallback(function(ins)
		distances = {}
		for k, v in pairs(valid_wins) do
			local n = v:application():name()
			distances[k] = fz.damleven(ins, n) * (1.0 / fz.weightearly(ins, n, 2))
		end

		table.sort(choices, customSort)
		chooser:choices(choices)
	end)
	
	chooser:show()
end

hs.hotkey.bind({"alt"}, "tab", rofi)


