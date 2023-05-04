function parse_tags(str)
	local words = {}

	-- Split the string into words and store them in a table
	for word in str:gmatch("%S+") do
		table.insert(words, word)
	end
	
	-- Iterate over the words and append a "+" to each one except the last one
	local result = ""
	for i, word in ipairs(words) do
		result = result .. word
		if i < #words then
			result = hs.http.encodeForQuery(result) .. "+"
		end
	end
	return result
end

function add_to_linkhut()
	btn, url = hs.dialog.textPrompt("URL", 'Check your URL', hs.pasteboard.getContents(), "OK", 'Cancel')
	if btn == "Cancel" then return end
	btn, description = hs.dialog.textPrompt("Description", "Enter a description", "", "OK", 'Cancel')
	if btn == "Cancel" then return end
	btn, tags = hs.dialog.textPrompt("Tags", "Enter space separated tags", "", "OK", 'Cancel')
	if btn == "Cancel" then return end
	
	description_url = "&description=" .. hs.http.encodeForQuery(description)
	tags_url = "&tags=" .. parse_tags(tags)
	print(description_url, tags_url)
	
	api_url = "https://api.ln.ht/v1/posts/add?".."url="..hs.http.encodeForQuery(url)..description_url..tags_url.."&shared=no"
	headers = {
		["Authorization"] = 'Bearer '.. hs.settings.get('linkhutkey')
	}
	response, body, headers = hs.http.asyncGet(api_url, headers, function(response) print(response) end)
end

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'u', nil, add_to_linkhut)
