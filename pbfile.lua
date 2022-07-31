hyper = {'cmd', 'shift'}

function paste_to_file()
	local button, text = hs.dialog.textPrompt('file name', '', 'copy.txt')
	local path = hs.fs.temporaryDirectory()..text
	hs.execute('pbpaste > '..path)
	local asset = hs.fs.urlFromPath(path)
	local t = { url = asset }
	local rv = hs.pasteboard.writeObjects(t)

	hs.notify.new(
		{
			title = 'Copied text to file',
			subtitle = "",
			informativeText = path,
			alwaysPresent = true,
			autoWithdraw = true
		}
	):send()
end

hs.hotkey.bind(hyper, '8', paste_to_file)

