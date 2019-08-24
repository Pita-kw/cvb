local mysql = exports["ms-database"]

function onPlayerCreateNewEntrance(data)
	if data and client then
		if tonumber(data["faction"]) == nil then
			data["faction"] = 0
		end

		if tonumber(data["music_volume"]) == nil then
			data["music_volume"] = 0.6
		end

		if data["showgui"] then
			data["showgui"] = 1
		else
			data["showgui"] = 0
		end

		if data["music"] == "opcjonalne" then
			data["music"] = ""
		end

		mysql:query("INSERT INTO `ms_entrances` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil, data["name"], data["opis"], 0, tonumber(data["faction"]), 
		tonumber(data["pickupid"]), data["pk_pos"], tonumber(data["pki"]), tonumber(data["pkv"]), data["pk_tel"], tonumber(data["teli"]), tonumber(data["telv"]),
		data["image"], data["music"], tonumber(data["music_volume"]), tonumber(data["showgui"]), tonumber(data["blip"]))

		local entrance = CEntrance(data, #entrances+1)
		table.insert(entrances, entrance)
		startImageDownload(#entrances, data["image"])

		outputChatBox("Wnętrze stworzone pomyślnie.", client)
	end
end
addEvent("onPlayerCreateNewEntrance", true)
addEventHandler("onPlayerCreateNewEntrance", root, onPlayerCreateNewEntrance)
