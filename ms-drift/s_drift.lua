function updateDriftRecord(count)
	local uid = getElementData(client, "player:uid")
	if uid then 
		local playerRecord = exports["ms-database"]:getSingleRow("SELECT bestDrift FROM ms_players WHERE accountid=?", uid).bestDrift
		if count > playerRecord then 
			exports["ms-database"]:query("UPDATE ms_players SET bestDrift=? WHERE accountid=?", count, uid)
		end
	end
end 
addEvent("onPlayerUpdateDrift", true)
addEventHandler("onPlayerUpdateDrift", root, updateDriftRecord)