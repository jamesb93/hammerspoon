hyper = {'cmd', 'shift'}

-- function create_objects()
-- 	for i=1, 34 do
-- 		hs.eventtap.keyStroke({}, 'n', 0)
-- 		hs.eventtap.keyStrokes('buffer~'..' b'..i-1)
-- 		hs.eventtap.keyStroke({}, 'return', 0)
-- 	end
-- end

function create_objects()
	for i=1, 34 do
		local index = i-1
		hs.eventtap.keyStrokes('b'..index..' ')
	end
end

hs.hotkey.bind(hyper, '8', create_objects)