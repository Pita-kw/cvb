local vehicle = {} 
local vehicleTimer = {} 
local dimension = 1002

function giveWorkReward(player, exp, money)
	exports["ms-gameplay"]:msGiveMoney(player, money)
	exports["ms-gameplay"]:msGiveExp(player, exp)
end
addEvent("giveElectricReward", true)
addEventHandler("giveElectricReward", getRootElement(), giveWorkReward)


function onEnter(player)
	if isTimer(vehicleTimer[player]) then 
		killTimer(vehicleTimer[player])
	end 
end 

function onExit(player) 
	vehicleTimer[player] = setTimer(
		function(player)
			if getPedOccupiedVehicle(player) and getElementData(getPedOccupiedVehicle(player), "vehicle:job") == "job_elektryk" then 
			else 
				triggerClientEvent(player, "onClientAddNotification", player, "Praca zostaje przerwana z powodu zbyt długiego przebywania poza pojazdem", "error")
				triggerEvent("onPlayerStopElectrician", player)
			end 
		end, 60000*5, 1, player)
end 


function onPlayerStartElectrician()
	if getElementData(client, 'player:job') and getElementData(client, 'player:job')~='job_elektryk' then
		triggerClientEvent(client, 'onClientAddNotification', client, 'Posiadasz już aktywną prace!', 'error')
		return
	end
	
	triggerClientEvent(client, "onClientStartElectrician", client)
	
	vehicle[client] = createVehicle(459, 1996.89,-1094.42,24.92)
	setElementDimension(vehicle[client], dimension)
	setElementDimension(client, dimension)
	setElementData(vehicle[client], "vehicle:fuel", math.random(20,30))
	warpPedIntoVehicle(client, vehicle[client])
	setElementRotation(vehicle[client], 0, 0, 80)
	setElementData(vehicle[client], "vehicle:job", "job_elektryk")
	addEventHandler("onVehicleEnter", vehicle[client], onEnter)
	addEventHandler("onVehicleExit", vehicle[client], onExit)
	takeAllWeapons(client)
end
addEvent("onPlayerStartElectrician", true)
addEventHandler("onPlayerStartElectrician", root, onPlayerStartElectrician)

function onPlayerStopElectrician()
	if isElement(vehicle[source]) then 
		removeEventHandler("onVehicleEnter", vehicle[client], onEnter)
		removeEventHandler("onVehicleExit", vehicle[client], onExit)
		destroyElement(vehicle[source])
	end 
	
	if isTimer(vehicleTimer[source]) then 
		killTimer(vehicleTimer[source])
	end 
	
	triggerClientEvent(source, "onClientStopElectrician", source)
	setElementData(source, "player:job", false)
	setElementDimension(source, 0)
end
addEvent("onPlayerStopElectrician", true)
addEventHandler("onPlayerStopElectrician", root, onPlayerStopElectrician)


function onPlayerQuit()
	if vehicle[source] then 
		destroyElement(vehicle[source])
	end 
end 
addEventHandler("onPlayerQuit", root, onPlayerQuit)



addEventHandler( "onPlayerWasted", root,
	function()
		if getElementData(source, "player:job") == "job_elektryk" then
			triggerClientEvent(source, "onClientAddNotification", source, "Praca zostaje przerwana z powodu śmierci!", "error")
			triggerEvent("onPlayerStopElectrician", source)
		end
	end
)

for k,v in ipairs(getElementsByType("player")) do 
	if getElementData(v, "player:job") == "job_elektryk" then 
		setElementData(v, "player:job", false)
	end 
end 