--[[
	MultiServer 
	Zasób: ms-teleports/s.lua
	Opis: Obsługa teleportów.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local mysql = exports["ms-database"]
local allTeleports = mysql:getRows("SELECT * FROM `ms_teleports`")
table.sort(allTeleports, function(a, b) return a["cmd"] < b["cmd"] end)

function teleportPlayer(player, x, y, z, int, dim, rot, type, name)
	if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Masz zablokowaną możliwość teleportowania się!", "error") return end
	if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się gdy wykonujesz pracę!", "error") return end
	if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby się teleportować najpierw wyjdź z areny wpisująć komendę /ae", "error") return end
	if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
	if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
	if isPedInVehicle(player) and int ~= 0 and dim ~= 0 then triggerClientEvent(player, "onClientAddNotification", player, "Najpierw wyjdź z pojazdu.", "warning") return end 
	if type == 6 then 
		local data = getElementData(player, "player:"..name.."_downloaded") or false 
		if not data then 
			triggerClientEvent(player, "onClientInitCustomDownload", player, name, "player:"..name.."_downloaded") 
			return
		end
	end 
	
	local now = getTickCount()
	local lastDamage = getElementData(player, "player:lastDamage") or 0 
	
	if lastDamage > now then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś niedawno postrzelony! Poczekaj chwilę", "error")
		return
	end
	
	if getPedOccupiedVehicle(player) and getElementData(getPedOccupiedVehicle(player), "vehicle:exchange") then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w pojeździe giełdowym.", "warning")
		return
	end
	
	if getPedOccupiedVehicle(player) and getElementData(getPedOccupiedVehicle(player), "vehicle:challange") then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić podczas wyzwania.", "warning")
		return
	end
	
	fadeCamera(player, false, 1)
	setTimer(
		function(player, x, y, z, int, dim)
			local vehicle = getPedOccupiedVehicle(player)
			if vehicle and getPedOccupiedVehicleSeat(player) == 0 then 
				setElementVelocity(vehicle, 0, 0, 0)
				
				setElementPosition(vehicle, x, y, z)
				setElementInterior(vehicle, int)
				setElementDimension(vehicle, dim)
				setElementRotation(vehicle, 0, 0, rot)
			end 
			
			if vehicle and getPedOccupiedVehicleSeat(player) ~= 0 then
				removePedFromVehicle(player)
			end
			
			setElementPosition(player, x, y, z)
			setElementInterior(player, int)
			setElementDimension(player, dim)
			setElementRotation(player, 0, 0, rot)
			
			fadeCamera(player, true, 1)
			
			if getElementData(player, "player:entrance") == "inside" then 
				triggerClientEvent(player, "onPlayerLoadEntranceMusic", player, false)
			end
		end, 1000, 1, player, x, y, z, int, dim, rot)
end 

function getTeleports()
	return allTeleports 
end 

function getRandomTeleport()
	local teleports = getTeleports()
	local temp = {} 
	for k,v in ipairs(teleports) do 
		if v["type"] == 4 then 
			table.insert(temp, v)
		end 
	end 
	
	local tp = temp[math.random(1, #temp)]
	return tp["x"], tp["y"], tp["z"], tp["interior"], tp["dimension"]
end 

-- ładowanie komend
function loadTeleportsCMD()
	local teleports = getTeleports()
	
	for k,v in ipairs(teleports) do 
		local cmd = v["cmd"]
		addCommandHandler(cmd, 
			function(player)
				if not getElementData(player, "player:spawned") then return end 
				
				local x,y,z = v["x"], v["y"], v["z"]
				local int, dim = v["interior"], v["dimension"]
				local rot = v["rot"]
				local type = v["type"]
				local name = v["cmd"]
				teleportPlayer(player, x, y, z, int, dim, rot, type, name)
			end 
		)
	end 
end 

-- /teles
function showTeleportWindow(player)
	triggerClientEvent(player, "onClientShowTeleportWindow", player, getTeleports())
end 

-- /addtp
function adminAddTeleport(player, cmd, arg1, arg2)
	local rank = getElementData(player, "player:rank") or 0
	if rank < 3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie masz uprawnień.", "warning")
		return
	end 
	
	if not arg1 or not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Składnia: /addtp <komenda> <typ 1-6>", "warning")
		return 
	end 
	
	local x,y,z = getElementPosition(player)
	local int,dim = getElementInterior(player), getElementDimension(player)
	local _, _, rot = getElementRotation(player) 
	mysql:query("INSERT INTO `ms_teleports` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", nil, arg1, arg2, x, y, z, rot, int, dim)
	triggerClientEvent(player, "onClientAddNotification", player, "Teleport "..arg1.." dodany pomyślnie.", "success")
end 

function adminDelTeleport(player, cmd, arg1)
	local rank = getElementData(player, "player:rank") or 0
	if rank < 3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie masz uprawnień.", "warning")
		return
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Składnia: /deltp <nazwa teleportu>", "warning")
		return 
	end 
	
	local query = mysql:query2("DELETE FROM `ms_teleports` WHERE `ms_teleports`.`cmd` = ?", tostring(arg1))
	triggerClientEvent(player, "onClientAddNotification", player, "Teleport "..arg1.." usunięty pomyślnie.", "success")
end 


function onPlayerTeleport(x, y, z, int, dim, rot, type, name)
	teleportPlayer(client, x, y, z, int, dim, rot, type, name)
end 
addEvent("onPlayerTeleport", true)
addEventHandler("onPlayerTeleport", root, onPlayerTeleport)

function onStart()
	loadTeleportsCMD()
	addCommandHandler("tp", showTeleportWindow)
	addCommandHandler("teles", showTeleportWindow)
	addCommandHandler("teleports", showTeleportWindow)
	addCommandHandler("addtp", adminAddTeleport)
	addCommandHandler("deltp", adminDelTeleport)
	
	for k,v in ipairs(getElementsByType("player")) do 
		bindKey(v, "f3", "down", showTeleportWindow)
	end 
	
	for k,v in ipairs(getTeleports()) do 
		local posX, posY, posZ = v.x, v.y, v.z 
		local rot = v.rot
		posX = posX - math.sin(math.rad(rot)) * 1
		posY = posY + math.cos(math.rad(rot)) * 1
		
		local pickup = createPickup(posX, posY, posZ, 3, 1239, 0)
		setElementInterior(pickup, v.interior)
		setElementDimension(pickup, v.dimension)
		
		local text = createElement("3dtext")
		setElementInterior(text, v.interior)
		setElementDimension(text, v.dimension)
		setElementPosition(text, posX, posY, posZ+0.5)
		setElementData(text, "text", "#3366FF/"..tostring(v.cmd).."\n#D9D9D9Potrzebujesz pomocy? Kliknij F9.")
		setElementData(text, "font", 0.6)
		
		local r = 10
		if v.cmd == "gielda" then 
			r = 50
		end 
		
		local col = createElement("antydm")
		setElementPosition(col, v.x, v.y, v.z)
		setElementData(col, "distance", r)
		setElementInterior(col, v.interior)
		setElementDimension(col, v.dimension)
		addEventHandler("onColShapeHit", col, function(el, dim)
			if getElementType(el) == "player" then 
				toggleControl(el,"fire", false)
				toggleControl(el,"aim_weapon", false)
				setElementData(el, "player:zone", "antydm")
			end
		end)
		
		addEventHandler("onColShapeLeave", col, function(el, dim)
			if getElementType(el) == "player" then 
				if not getElementData(el, "player:boombox") then
					toggleControl(el,"fire", true)
					toggleControl(el,"aim_weapon", true)
				end
				setElementData(el, "player:zone", false)
			end
		end)
	end 
	
	addEventHandler("onPlayerJoin", root, function() bindKey(source, "f3", "down", showTeleportWindow) end)
end 
addEventHandler("onResourceStart", resourceRoot, onStart)

-- utils 
function getPositionInFrontOf(x, y, z, rot, meters)
    local meters = (type(meters) == "number" and meters) or 3
    local posX, posY, posZ = x, y, z
    local rotation = rot

    return posX, posY, posZ , rot
end