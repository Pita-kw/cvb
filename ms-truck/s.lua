--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: strona serwera pracy spedycji lądowej
]]


local truck_cars = {} 
local truck_trailers = {}

addEvent("giveRewardForTruckSpedition", true)
addEvent("deleteTruckVehicle", true)
addEvent("startTruckSpeditionServer", true)
addEvent("changeTruckWorld", true)

function changeTruckWorld(player, world)
	if player and world then
		setElementDimension(player, world)
	end
end
addEventHandler("changeTruckWorld", getRootElement(), changeTruckWorld)

function startTruckSpeditionServer(player, position)
	if isElement(truck_cars[source]) then
		destroyElement(truck_cars[source])
		truck_cars[source] = nil
	end
	
	if isElement(truck_trailers[source]) then
		destroyElement(truck_trailers[source])
		truck_trailers[source] = nil 
	end
	
	truck_cars[player] = createVehicle(455, position[1],position[2], position[3], position[4], position[5], position[6])
	setVehicleVariant(truck_cars[player], 2)
	warpPedIntoVehicle(player, truck_cars[player])
	setElementDimension(truck_cars[player], 1011)
	setElementDimension(player, 1011)
	setElementData(truck_cars[player], "vehicle:job", true)
	toggleVehicleRespawn(truck_cars[player], false)
	triggerClientEvent(player, "truckSpeditionStart", player, player, truck_cars[player], truck_trailers[player])
end
addEventHandler("startTruckSpeditionServer", getRootElement(), startTruckSpeditionServer)

function deleteTruckVehicle(player)
	if truck_cars[player] and isElement(truck_cars[player]) then
		destroyElement(truck_cars[player])
		truck_cars[player] = nil
	end
	
	if truck_trailers[player] and isElement(truck_trailers[player]) then
		destroyElement(truck_trailers[player])
		truck_trailers[player] = nil
	end
end
addEventHandler("deleteTruckVehicle", getRootElement(), deleteTruckVehicle)

function giveRewardForTruckSpedition(player, money, exp)
	exports["ms-gameplay"]:msGiveMoney(player, money)
	exports["ms-gameplay"]:msGiveExp(player, exp)
end
addEventHandler("giveRewardForTruckSpedition", getRootElement(), giveRewardForTruckSpedition)


function quitPlayer ( quitType )
	if isElement(truck_cars[source]) then
		destroyElement(truck_cars[source])
		truck_cars[source] = nil
	end
	
	if isElement(truck_trailers[source]) then
		destroyElement(truck_trailers[source])
		truck_trailers[source] = nil 
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )
