--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: strona serwera spedycji lotniczych
]]

local airplanes = {} 

addEvent("giveRewardForAirSpedition", true)
addEvent("deleteAirSpeditionVehicle", true)
addEvent("startAirSpeditionServer", true)
addEvent("changeAirWorld", true)

function changeAirWorld(player, world)
	if player and world then
		setElementDimension(player, world)
	end
end
addEventHandler("changeAirWorld", getRootElement(), changeAirWorld)

function startAirSpeditionServer(player, track_id)
	if isElement(airplanes[player]) then 
		destroyElement(airplanes[player])
	end
	airplanes[player] = createVehicle(553, 1478.46,1814.56,13.83, -10.76,-0.01,182.1)
	setElementDimension(airplanes[player], 1010)
	setElementDimension(player, 1010)
	setElementData(airplanes[player], "vehicle:job", true)
	warpPedIntoVehicle(player, airplanes[player])
	toggleVehicleRespawn(airplanes[player], false)
	triggerClientEvent(player, "airSpeditionStart", player, track_id, airplanes[player])
end
addEventHandler("startAirSpeditionServer", getRootElement(), startAirSpeditionServer)

function deleteAirSpeditionVehicle(player)
	if airplanes[player] then
		destroyElement(airplanes[player])
		airplanes[player] = nil
	else
		return false
	end	
end
addEventHandler("deleteAirSpeditionVehicle", getRootElement(), deleteAirSpeditionVehicle)

function giveRewardForAirSpedition(player, money, exp)
	exports["ms-gameplay"]:msGiveMoney(player, money)
	exports["ms-gameplay"]:msGiveExp(player, exp)
end
addEventHandler("giveRewardForAirSpedition", getRootElement(), giveRewardForAirSpedition)

function quitPlayer ( quitType )
	if isElement(airplanes[source]) then
		destroyElement(airplanes[source])
		airplanes[player] = nil
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )