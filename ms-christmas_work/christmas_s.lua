local reward = 200
local dimension = 1009
local vehicles = {}

function onPlayerStartChristmasWork()
	if getElementData(client, "player:job") then 
		triggerClientEvent(client, "onClientAddNotification", client, "Już pracujesz!", "error")
		return 
	end 
	
	setElementDimension(client, dimension)
	
	setElementModel(client, 239)
	
	vehicles[client] = createVehicle(505, -2346.15, -1649.86 - math.random(1, 10), 484, 0, 0, 304)
	addEventHandler("onVehicleStartExit", vehicles[client], function() cancelEvent() end)
	
	setElementDimension(vehicles[client], dimension)
	warpPedIntoVehicle(client, vehicles[client])
	
	setElementData(client, "player:job", "christmas")
	setElementData(client, "player:status", "Praca: rozrzucanie prezentów")
	setElementData(client, "block:player_teleport", true)
	
	triggerClientEvent(client, "onClientStartChristmasWork", client)
end 
addEvent("onPlayerStartChristmasWork", true)
addEventHandler("onPlayerStartChristmasWork", root, onPlayerStartChristmasWork)

function onPlayerEndChristmasWork(collected)
	removePedFromVehicle(client)
	
	if vehicles[client] then 
		destroyElement(vehicles[client])
		vehicles[client] = nil
	end
	
	setElementDimension(client, 0)
	setElementPosition(client, -2343.93,-1621.65+3,489.03)
	setElementModel(client, getElementData(client, "player:skin"))
	setElementData(client, "player:job", false)
	setElementData(client, "player:status", "W grze")
	setElementData(client, "block:player_teleport", false)
		
	if collected and collected > 0 then 
		-- wypłata :8
		exports["ms-gameplay"]:msGiveExp(client, math.floor((reward*collected)/200))
		exports["ms-gameplay"]:msGiveMoney(client, reward*collected)
		if getElementData(client, "player:premium") then 
			triggerClientEvent(client, "onClientAddNotification", client, "Za rozrzucone prezenty ("..tostring(collected)..") otrzymujesz $"..tostring(math.floor((reward*collected)*1.3)).." i "..tostring(math.floor(((reward*collected)*1.3)/200)).." EXP", "success")
		else
			triggerClientEvent(client, "onClientAddNotification", client, "Za rozrzucone prezenty ("..tostring(collected)..") otrzymujesz $"..tostring(reward*collected).." i "..tostring(math.floor((reward*collected)/200)).." EXP", "success")
		end
	else 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie zebrałeś żadnego prezentu!", "error")
	end
end 
addEvent("onPlayerEndChristmasWork", true)
addEventHandler("onPlayerEndChristmasWork", root, onPlayerEndChristmasWork)

addEventHandler("onResourceStop", resourceRoot, function()
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:job") == "christmas" then 
			client = v 
			onPlayerEndChristmasWork(true)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	if vehicles[source] then 
		destroyElement(vehicles[source])
	end
end)