--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: tree_c.lua
	@desc: serverside code
]]

local work_dim = 1001

local tree_vehicles = {}


function giveWorkReward(player, exp, money)
	if money > 0 then
		exports["ms-gameplay"]:msGiveMoney(player, tonumber(money))
	end
	
	if exp > 0 then
		exports["ms-gameplay"]:msGiveExp(player, tonumber(exp))
	end
end
addEvent("giveTreeReward", true)
addEventHandler("giveTreeReward", getRootElement(), giveWorkReward)

function startTreeJobServerHandler(gracz)
	tree_vehicles[gracz] =  createVehicle(572, 1134.59,-2036.67,69.01, 0,0,266, "TRAWA")
	setElementDimension(tree_vehicles[gracz], work_dim)
	setElementDimension(gracz, work_dim)
	warpPedIntoVehicle(gracz, tree_vehicles[gracz])
	setVehicleHandling(tree_vehicles[gracz], 'maxVelocity', 60)
	setElementData(tree_vehicles[gracz], 'vehicle:mileage', math.random(1000, 10000))
	setElementData(tree_vehicles[gracz], 'vehicle:fuel', 35)
	setElementData(tree_vehicles[gracz], 'vehicle:type', 'job')
	setElementData(tree_vehicles[gracz], 'vehicle:job', 'job_tree')
	setElementData(gracz, "player:job", 'job_tree')
	setElementData(gracz, "player:status", "Praca: Ogrodnik")
	triggerClientEvent('startTreeJob', gracz, tree_vehicles[gracz])
	takeAllWeapons(gracz)
end
addEvent("startTreeJobServer", true)
addEventHandler("startTreeJobServer", getRootElement(), startTreeJobServerHandler)


function removeVehicleOnExit ( gracz, seat, jacked )
    if source == tree_vehicles[gracz] then
        destroyElement (tree_vehicles[gracz])
		triggerClientEvent(gracz, 'onClientAddNotification', gracz, 'Zakończyłeś pracę!\nAby odebrać wypłatę podejdź do bota', 'info')
		setElementDimension(gracz, 0)
    end
end
addEventHandler ( "onVehicleExit", getRootElement(), removeVehicleOnExit )

function endTreeJob(gracz)
	if getElementType(gracz)=='player' then
		triggerClientEvent('endWorkServer', gracz)
		if isElement(tree_vehicles[gracz]) then destroyElement(tree_vehicles[gracz]) end
	end
end
addEvent("endTreeJob", true)
addEventHandler("endTreeJob", getRootElement(), endTreeJob)


function removeVehicleOnQuit()
	if isElement(tree_vehicles[source]) then
		destroyElement(tree_vehicles[source])
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeVehicleOnQuit)

	