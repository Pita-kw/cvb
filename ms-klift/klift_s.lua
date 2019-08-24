--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: klift_s.lua
	@desc: praca "widlarza" ?
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

addEvent("startJobKlift", true)
addEvent("removeKliftVehicle", true)

local klift_vehicle={}
local allow_work = true
local player_used = false
local player_data = false
local dimension = 1003

function giveWorkReward(player, exp, money)
	exports["ms-gameplay"]:msGiveMoney(player, money)
	exports["ms-gameplay"]:msGiveExp(player, exp)
end
addEvent("giveKliftReward", true)
addEventHandler("giveKliftReward", getRootElement(), giveWorkReward)

function startJobHandler(gracz)
	if allow_work == true then
		klift_vehicle[gracz] = createVehicle(530,2773.19,-2473.10,13.64, 0, 0, 88.27)
		setElementDimension(gracz, dimension)
		setElementDimension(klift_vehicle[gracz], dimension)
		setElementData(klift_vehicle[gracz], 'vehicle:mileage', math.random(1000, 10000))
		setElementData(klift_vehicle[gracz], 'vehicle:fuel', 35)
		setElementData(klift_vehicle[gracz], 'vehicle:job', "job_klift")
		warpPedIntoVehicle(gracz, klift_vehicle[gracz])
		triggerClientEvent('startJobKlift2', gracz, klift_vehicle[gracz])
		allow_work = false
		player_used = getPlayerName(gracz)
		player_data  = gracz
	else
		triggerClientEvent(gracz, 'onClientAddNotification', gracz, 'Praca zajęta przez gracza '.. player_used ..' ', 'error')
	end
end
addEventHandler("startJobKlift", getRootElement(), startJobHandler)


function removeWorkVehicle()
	if isElement(klift_vehicle[source]) then destroyElement(klift_vehicle[source]) end
	allow_work = true
	player_used = false
	player_data = false
end
addEventHandler("removeKliftVehicle", getRootElement(), removeWorkVehicle)


function quitPlayer ( quitType )
	if source == player_data then
		if isElement(klift_vehicle[source]) then
			destroyElement(klift_vehicle[source])
		end
		allow_work = true
		player_used = false
		player_data = false
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )
