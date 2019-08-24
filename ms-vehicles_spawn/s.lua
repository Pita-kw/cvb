local spawnedVehicles = {}
local airPlanes = {592,577,511,512,593,520,553,476,519,460,513,548,425,417,487,488,497,563,447,469}

function isVehicleOccupied(vehicle)
    assert(isElement(vehicle) and getElementType(vehicle) == "vehicle", "Bad argument @ isVehicleOccupied [expected vehicle, got " .. tostring(vehicle) .. "]")
    local _, occupant = next(getVehicleOccupants(vehicle))
    return occupant and true, occupant
end

function updateVehicles()
	for k,v in ipairs(spawnedVehicles) do 
		if isElement(v) then 
			if not isVehicleOccupied(v) then 
				local now = getTickCount()
				local lastExit = getElementData(v, "vehicle:lastExit")
				if now > (lastExit + 60000) then 
					table.remove(spawnedVehicles, k)
					destroyElement(v)
				end
			end
		else 
			table.remove(spawnedVehicles, k)
		end
	end
end 
setTimer(updateVehicles, 60000, 0)

function onVehicleExit(player, seat)
	if player and seat == 0 then 
		setElementData(source, "vehicle:lastExit", getTickCount())
	end
end

function onVehicleExplode()
	setTimer(destroyElement, 10000, 1, source)
end 

function onClientVehicleSpawn(name)
	local is_airplane = false
	local model = getVehicleModelFromName(name)
	local x,y,z = getElementPosition(client)
	
	if getPlayerTeam(client) or getElementData(client, "block:vehicle_spawn") or getElementInterior(client) ~= 0 or getElementData(client, 'player:job') or getElementData(client, "player:entrance") == "inside" or isPedDead(client) then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz teraz zespawnować pojazdu.", "error")
		return 
	end
	
	if isPedInVehicle(client) then 
		triggerClientEvent(client, "onClientAddNotification", client, "By to zrobić wyjdź z pojazdu.", "error")
		return
	end 
	
	if name then
		local now = getTickCount()
		local lastVehicleSpawn = getElementData(client, 'player:lastVehicleSpawn') or 0
		local lastDamage = getElementData(client, "player:lastDamage") or 0 
		
		if lastDamage > now then 
			triggerClientEvent(client, "onClientAddNotification", client, "Zostałeś niedawno postrzelony! Poczekaj chwilę", "error")
			return
		end
		
		for k,v in ipairs(airPlanes) do
			if v == model then
				is_airplane = true
			end
		end
		
		if is_airplane then 
			local zone = getZoneName(x,y,z)
			if zone ~= "Los Santos International" and zone ~= "Las Venturas Airport" then
				triggerClientEvent(client, "onClientAddNotification", client, "Samoloty możesz spawnować tylko na lotniskach!", "warning")
				return
			end
		end		
		
		if lastVehicleSpawn > now then
			local time = math.ceil((lastVehicleSpawn-now)/1000)  
			triggerClientEvent(client, "onClientAddNotification", client, 'Odczekaj jeszcze '..tostring(time)..' sekund przed zrespawnowaniem kolejnego pojazdu.', "error")
			return
		end
		setElementData(client, 'player:lastVehicleSpawn', getTickCount()+60000)
		
		local hasVeh = getElementData(client, "player:vehicle")
		if isElement(hasVeh) then 
			destroyElement(hasVeh)
		end 
		
		local veh = createVehicle(model, x+1, y, z)
		local int = getElementInterior(client)
		local dim = getElementDimension(client)
		setElementInterior(veh, int)
		setElementDimension(veh, dim)
		table.insert(spawnedVehicles, veh)
		triggerClientEvent(client, "onClientAddNotification", client, "Pojazd "..name.." zespawnowany pomyślnie.", "success")
		setElementData(client, "player:vehicle", veh)
		setElementData(veh, "vehicle:spawner", getPlayerName(client))
		setElementData(veh, "vehicle:lastExit", getTickCount())
		addEventHandler("onVehicleExit", veh, onVehicleExit)
		addEventHandler("onVehicleExplode", veh, onVehicleExplode)
	end
end 
addEvent("onClientVehicleSpawn", true)
addEventHandler("onClientVehicleSpawn", root, onClientVehicleSpawn)

