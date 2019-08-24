local mysql = exports["ms-database"]
addEventHandler("onResourceStart", resourceRoot, function()
	interiorData = mysql:getRows("SELECT * FROM `ms_custominteriors`")
end)

function getInteriorObjects(int)
	local query = false
	for k, v in ipairs(interiorData) do 
		if v.id == int then 
			query = v
			break
		end
	end 
	
	if query then 
		if query["disableFurniture"] == 1 then 
			return fromJSON(query["objects"])
		else 
			return tonumber(query["objects"])
		end
	else 	
		return {} 
	end 
end 

function getTeleportPosition(int)
	local query = false
	for k, v in ipairs(interiorData) do 
		if v.id == int then 
			query = v
			break
		end
	end 
	
	if query then 
		local pos = fromJSON(query["enterPos"])
		return pos[1], pos[2], pos[3] 
	end 
end 

function isFurnitureDisabled(int)
	local query = false
	for k, v in ipairs(interiorData) do 
		if v.id == int then 
			query = v
			break
		end
	end
	
	return query["disableFurniture"] == 1
end

function onAuthLoadHouse(id)
	local houseData = getHouseByID(id).data
	local interiorObjects = getInteriorObjects(houseData["interiorid"])
	
	loadFurnitureForPlayer(source, id)
	if type(interiorObjects) == "table" then
		triggerClientEvent(source, "onCreateInteriorObjects", source, interiorObjects, id)
	end
	
	local tx,ty,tz = getTeleportPosition(houseData["interiorid"])
	setElementData(source, "player:inHouse", id)
	setTimer(
		function(plr,x,y,z, id)
			setElementPosition(plr, x, y, z)
			setElementDimension(plr, id)
			if isFurnitureDisabled(houseData["interiorid"]) then 
				setElementInterior(plr, 200)
			else 
				setElementInterior(plr, interiorObjects)
			end
		end, 500, 1, source, tx, ty, tz, id)
end 
addEvent("onAuthLoadHouse", true)
addEventHandler("onAuthLoadHouse", root, onAuthLoadHouse)