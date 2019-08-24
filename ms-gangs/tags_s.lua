tags = {}

function loadTags()
	tags = exports["ms-database"]:getRows("SELECT * FROM ms_gangs_tags")
	
	addEventHandler("onPlayerJoin", root, function()
		setTimer(triggerClientEvent, 5000, 1, source, "onClientLoadTags", source, tags)
	end)
	
	setTimer(function()
		for k, v in ipairs(getElementsByType("player")) do
			triggerClientEvent(v, "onClientLoadTags", v, tags)
		end
	end, 500, 1)
	
	setTimer(saveTags, 60000*30, 0)
end 
addEventHandler("onResourceStart", resourceRoot, loadTags)

function saveTags()
	for k, v in ipairs(tags) do 
		exports["ms-database"]:query("UPDATE ms_gangs_tags SET owner=? WHERE id=?", v.owner, v.id)  
	end
	
	saveAreas()
end 
addEventHandler("onResourceStop", resourceRoot, saveTags)

function refreshGangTags(id)
	local gangTags = {}
	for k, v in ipairs(tags) do 
		if v.owner == id then 
			table.insert(gangTags, k)
		end
	end
	
	for k, v in ipairs(getElementsByType("player")) do 
		triggerClientEvent(v, "onClientUpdateTagLogo", v, gangTags)
	end
end 

function onPlayerChangeTag(id, owner)
	tags[id].owner = owner 
	
	setAreaOwner(id, owner)
	 
	for k, v in ipairs(getElementsByType("player")) do 
		triggerClientEvent(v, "onClientUpdateTag", v, id, tags[id])
	end
	
	giveGangExp(owner, TAG_EXP)
	triggerClientEvent(client, "onClientAddNotification", client, "Oznaczyłeś teren! Twój gang otrzymuje "..tostring(TAG_EXP).." EXP.", "success")
end 
addEvent("onPlayerChangeTag", true)
addEventHandler("onPlayerChangeTag", root, onPlayerChangeTag)

function onPlayerStartSprayingTag(id)
	addAreaOvertaker(id, client)
end 
addEvent("onPlayerStartSprayingTag", true)
addEventHandler("onPlayerStartSprayingTag", root, onPlayerStartSprayingTag)

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function addGangTag(player)
	local rank = getElementData(player, "player:rank") or 0 
	if rank < 3 then return end 
	
	local x, y, z = getElementPosition(player)
	x, y, z = round(x, 5), round(y, 5), round(z, 5)
	
	local _, _, rot = getElementRotation(player)
	rot = math.floor(rot)
	
	local owner = -1 
	exports["ms-database"]:query("INSERT INTO ms_gangs_tags(id, x, y, z, rot, owner) VALUES(?, ?, ?, ?, ?, ?)", nil, x, y, z, rot, owner)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Dodano tag pomyślnie.", "success")
end 
addCommandHandler("addtag", addGangTag)


function resetGangTags(player, cmd, id)
	if getElementData(player, "player:rank") ~= 3 then return end
	
	gang_areas = exports["ms-database"]:getRows("SELECT * FROM ms_gangs_areas WHERE owner = ?", id)
	
	if #gang_tags > 0 then
		exports["ms-database"]:query("UPDATE ms_gangs_areas SET owner=-1, r=255, g=255, b=255, WHERE id=?", id)  
		exports["ms-database"]:query("UPDATE ms_gangs_tags SET owner=-1 WHERE owner=?", id) 
		loadTags()
		triggerEvent("loadAreas", root)
		triggerClientEvent(player, "onClientAddNotification", player, "Strefy dla tego gangu zostały zresetowane.", "success")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Ten gang nie ma żadnych stref.", "warning")
	end
end
addCommandHandler("resetgangzones", resetGangsZones)