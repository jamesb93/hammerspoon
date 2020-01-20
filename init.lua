require("battery")
require("caffeine")
require("keep_quiet")
require("pomodoro")
-- require("backup")

-- Spectacle Replacement
custom_bindings = {
	leftHalf = {
		{{"cmd"}, "left"}
	},
	rightHalf = {
		{{"cmd"}, "right"}
	},
	fullScreen = {
		{{"cmd"}, "return"}
	},
	center = {
		{{"cmd", "alt"}, "c"}
	},
	undo = false,
	redo = false
}
hs.loadSpoon("Lunette")
spoon.Lunette:bindHotkeys(custom_bindings)