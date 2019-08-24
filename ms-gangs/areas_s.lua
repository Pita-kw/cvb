local areas = {}
local areaAlpha = 100

local function getAreaTag(area)
	for k, v in ipairs(tags) do 
		if isInsideRadarArea(area, v.x, v.y) then 
			return k
		end
	end
end 

local function getTagArea(tagID)
	for k, v in ipairs(areas) do 
		if tagID == v.tag then 
			return v.area
		end
	end
end 

local function updateAreas()
	for _, data in ipairs(areas) do 
		local area = data.area
		local overtakers = getElementData(area, "overtakers") or {}
		if #overtakers > 0 then
			for i, player in ipairs(overtakers) do 
				if isElement(player) then 
					local x, y = getElementPosition(player)
					if not isInsideRadarArea(area, x, y) or getElementData(player, "player:zone") == "antydm" then
						triggerClientEvent(player, "onClientUpdateTag", player, data.tag, tags[data.tag])
						table.remove(overtakers, i)
					end
				else 
					table.remove(overtakers, i)
				end
			end
			
			setElementData(area, "overtakers", overtakers)
		else 
			if isRadarAreaFlashing(area) then 
				setRadarAreaFlashing(area, false)
			end
		end
	end
end 

function addAreaOvertaker(tag, player)
	local area = getTagArea(tag)
	if area then 
		local overtakers = getElementData(area, "overtakers") or {}
		table.insert(overtakers, player)
		setElementData(area, "overtakers", overtakers)
		
		if not isRadarAreaFlashing(area) then 
			setRadarAreaFlashing(area, true)
			
			local tagOwner = tags[tag].owner 
			if tagOwner ~= -1 then
				for k, v in ipairs(getElementsByType("player")) do 
					local gang = getElementData(v, "player:gang")
					if gang and tagOwner == gang.id then 
						triggerClientEvent(v, "onClientAddNotification", v, "Strefa twojego gangu jest atakowana! Sprawdź mapę F11.", "error", 10000, false)
					end
				end
			end
		end
	end
end

function setAreaOwner(tag, owner)
	local area = getTagArea(tag)
	if area then 
		local index = getGangIndexFromID(owner)
		local color = fromJSON(gangData[index].color)
		
		setRadarAreaColor(area, color[1], color[2], color[3], areaAlpha)
		setElementData(area, "overtakers", {})
		setElementData(area, "owner", owner)
		setRadarAreaFlashing(area, false)
	end
end 

function loadAreas()
	areas = exports["ms-database"]:getRows("SELECT * FROM ms_gangs_areas")
	for k, v in ipairs(areas) do 
		v.area = createRadarArea(v.x, v.y, v.w, v.h, v.r, v.g, v.b, areaAlpha)
		setElementData(v.area, "owner", v.owner)
		setElementData(v.area, "overtakers", {})
	end
	
	setTimer(function()
		for k, v in ipairs(areas) do
			v.tag = getAreaTag(v.area)
		end
		
		setTimer(updateAreas, 500, 0)
	end, 2000, 1)
end 
addEventHandler("onResourceStart", resourceRoot, loadAreas)
addEvent("loadAreas", true)
addEventHandler("loadAreas", resourceRoot, loadAreas)

function saveAreas()
	for k, v in ipairs(areas) do 
		local r, g, b = getRadarAreaColor(v.area)
		local owner = getElementData(v.area, "owner")
		exports["ms-database"]:query("UPDATE ms_gangs_areas SET r=?, g=?, b=?, owner=? WHERE id=?", r, g, b, owner, v.id)
	end
end 
addEventHandler("onResourceStop", resourceRoot, saveAreas)