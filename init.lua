require("battery")
require("caffeine")
require("keep_quiet")
require("pomodoro")

-- Spectacle Replacement
custom_bindings = {
	leftHalf = {
		{{"cmd"}, "left"}
	},
	rightHalf = {
		{{"cmd"}, "right"}
	},
	undo = false,
	redo = false
}
hs.loadSpoon("Lunette")
spoon.Lunette:bindHotkeys(custom_bindings)