--[[
	@project: multiserver
	@author: l0nger <l0nger.programmer@gmail.com>
	@filename: vehicles.lua
	@desc: pojazdy
]]

local mysql=exports['ms-database']

local vehicles_type =
{
	["Truck"] = {403, 406, 407, 408, 424, 427, 431, 432, 433, 437, 443, 444, 455, 456,
				 498, 499, 514, 515, 524, 531, 544, 556, 557, 573, 578, 601, 609},
	["Sport Vehicle"] = {402, 411, 415, 429, 451, 477, 480, 494, 495, 502, 503, 504, 506, 541, 555, 558, 559, 560,
						 562, 565, 568, 587, 602, 603},
	["Casual Vehicle"] = {400, 401, 404, 405, 410, 412, 413, 414, 416, 418, 419, 420, 421, 422,
						  426, 436, 438, 439, 440, 445, 458, 459, 466, 467, 470, 474, 475,
						  478, 479, 482, 489, 490, 491, 492, 495, 496, 500, 505, 507, 516, 517, 518,
						  526, 527, 528, 529, 533, 534, 535, 536, 540, 542, 543, 546, 547, 549, 550, 551, 552,
						  554, 561, 566, 567, 575, 576, 579, 580, 585, 589, 596, 597, 598, 599, 600, 604, 605},
	["Plane"] = {592, 577, 511, 548, 512, 593, 425, 520, 417, 487, 553, 488, 497, 563, 476, 447, 519, 460, 469, 513},
	["Boat"] = {472, 473, 493, 595, 484, 430, 453, 452, 446, 454},
	["Motorbike"] = {481, 462, 521, 463, 522, 461, 448, 468, 586, 471}
}

local vehicles_maxFuel =
{
	["Truck"] = 100,
	["Sport Vehicle"] = 40,
	["Casual Vehicle"] = 50,
	["Plane"] = 200,
	["Boat"] = 20,
	["Motorbike"] = 25,
}

-- functions
function ms_createVehicle(data)
	if not data then return false end

	local pos=fromJSON(data.pos)
	local color=fromJSON(data.colors)
	local headlights=fromJSON(data.headlights)
	local vehicle=createVehicle(data.model, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6], data.license_plate)
	local sharing_players = fromJSON(data.sharing_players)
	
	setVehicleTaxiLightOn(vehicle, true)
	vehicle:setVelocity(0, 0, 0)
	vehicle:setInterior(data.interior)
	vehicle:setDimension(data.dimension)
	vehicle:setHealth(1000)
	vehicle:setFrozen(data.frozen==1)
	vehicle:setEngineState(false)
	vehicle:setHeadLightColor(headlights[1], headlights[2], headlights[3])
	vehicle:setColor(math.floor(color[1]/65536), math.floor(color[1]/256%256), color[1]%256, math.floor(color[2]/65536), math.floor(color[2]/256%256), color[2]%256, math.floor(color[3]/65536), math.floor(color[3]/256%256), color[3]%256, math.floor(color[4]/65536), math.floor(color[4]/256%256), color[4]%256)
	setVehicleOverrideLights(vehicle, 0)
	setVehiclePaintjob(vehicle, data.paintjob)
	vehicle:setLocked(data.locked==1)
	vehicle:setDamageProof(true)
	
	local vehicleType = getVehicleTypeByModel(getElementModel(vehicle))
	--vehicle:setData('vehicle:last_driver', nil)
	vehicle:setData('vehicle:id', data.id)
	vehicle:setData('vehicle:owner', data.owner or -1)
	vehicle:setData('vehicle:owner_name', data.ownerName or "?")
	vehicle:setData('vehicle:fractionid', data.ownerFaction or -1)
	vehicle:setData('vehicle:mileage', data.mileage)
	vehicle:setData('vehicle:fuel', data.fuel)
	vehicle:setData('vehicle:dirt_level', data.dirt_lvl)
	vehicle:setData('vehicle:spawn', true)
	vehicle:setData("vehicle:maxFuel", data.max_fuel)
	vehicle:setData('vehicle:sharing_players', sharing_players)
	
	if data.gielda > 0 then
		vehicle:setData("vehicle:exchange", true)
		vehicle:setData("vehicle:exchange:cena", data.gieldaCena)
		vehicle:setData("vehicle:exchange:miejsce", data.gieldaMiejsce)
		--vehicle:setData("vehicle:text", "#3366ffWłaściciel: #dcdcdc"..getElementData(vehicle, "vehicle:owner_name").."\n#3366ffPrzebieg: #dcdcdc".. string.format("%06d", math.floor(getElementData(vehicle, "vehicle:mileage"))/1000).."\n#3366ffModel: #dcdcdc"..getVehicleNameFromModel(getElementModel(vehicle)).."\n#3366ffCena: #dcdcdc"..data.gieldaCena)
	end
	if #data.blocked > 0 then
		vehicle:setData("vehicle:blocked", data.blocked)
	end

	
	local max_acc = data.max_acc
	local max_speed = data.max_speed 
	
	local components=fromJSON(data.components)
	local addons = {engine=0, jump=0, hp=0}
	for i,v in pairs(components) do
		if type(v) == "number" then 
			vehicle:addUpgrade(v)
			if v == 1010 then setElementData(vehicle, "vehicle:hasNOS", true) end
		else
			addons = v
		end
	end
	
	if addons.engine == 1 then 
		max_speed = max_speed + (max_speed*0.14)
		max_acc = max_acc + (max_acc*0.14)
	elseif addons.engine == 2 then 
		max_speed = max_speed + (max_speed*0.25)
		max_acc = max_acc + (max_acc*0.25)
	elseif addons.engine == 3 then 
		max_speed = max_speed + (max_speed*0.375)
		max_acc = max_acc + (max_acc*0.375)
	elseif addons.engine == 4 then
		max_speed = max_speed + (max_speed*0.5)
		max_acc = max_acc + (max_acc*0.5)
	end 
	
	if addons.jump == 1 then
		setElementData(vehicle, "vehicle:jump_extra", 0.20)
	elseif addons.jump == 2 then
		setElementData(vehicle, "vehicle:jump_extra", 0.30)
	elseif addons.jump == 3 then
		setElementData(vehicle, "vehicle:jump_extra", 0.40)
	elseif addons.jump == 4 then
		setElementData(vehicle, "vehicle:jump_extra", 0.50)
	end

	vehicle:setData("vehicle:extraHP", 250*addons.hp)
	 
	if addons.neon then 
		vehicle:setData("vehicle:neon", addons.neon)
	end 
	
	if not addons.suspension or type(addons.suspension) ~= "table" then 
		addons.suspension = {installed=0, value=0}
	end
	
	if addons.suspension.installed == 1 then 
		setSuspension(vehicle, addons.suspension.value*0.05)
	end
	
	vehicle:setData("vehicle:upgrade_addons", addons)
	setVehicleHandling(vehicle, "maxVelocity", max_speed)
	setVehicleHandling(vehicle, "engineAcceleration", max_acc)
	
	local panelstates=fromJSON(data.panelstates)
	for i,v in pairs(panelstates) do
		setVehiclePanelState(vehicle, i-1, tonumber(v))
	end
	local doorstate=fromJSON(data.doorstate)
	for i,v in pairs(doorstate) do
		setVehicleDoorState(vehicle, i-1, tonumber(v))
	end
	local wheelstate=fromJSON(data.wheelstate)
	setVehicleWheelStates(vehicle, wheelstate[1], wheelstate[2], wheelstate[3], wheelstate[4])

	local lightstate=fromJSON(data.lightstate)
	for i,v in pairs(lightstate) do
		setVehicleLightState(vehicle, i-1, tonumber(v))
	end
	return true
end

function addNewVehicle(model, x, y, z, rx, ry, rz, owner, fraction, player)
	local vehicle = createVehicle(model, x, y, z)
	setElementRotation(vehicle, rx, ry, rz)
	setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255)
	if isElement(vehicle) then
		local isSpawned=true
		local model=vehicle:getModel()
		local health=vehicle:getHealth()
		local frozen=vehicle:isFrozen()
		local id=vehicle:getData('vehicle:id') or nil
		local vehicleType = getVehicleTypeByModel(model)
		local maxFuel = vehicles_maxFuel[vehicleType]
		setElementData(vehicle, "vehicle:fuel", maxFuel)
		local fuel=vehicle:getData('vehicle:fuel') or maxFuel
		local mileage=vehicle:getData('vehicle:mileage') or 0
		local c1,c2,c3,c4,c5,c6=vehicle:getColor()
		local paintjob=getVehiclePaintjob(vehicle)
		local h1,h2,h3=getVehicleHeadLightColor(vehicle)
		local locked=isVehicleLocked(vehicle)
		local license_plate = getVehiclePlateText(vehicle)
		local dirtlevel=vehicle:getData('vehicle:dirt_level') or 0
		local dimension=vehicle:getDimension()
		local interior=vehicle:getInterior()
		local c11,c12,c13, c21,c22,c23, c31,c32,c33, c41,c42,c43 = getVehicleColor(vehicle,true)
		local colors=toJSON({c13+c12*256+c11*256*256, c23+c22*256+c21*256*256, c33+c32*256+c31*256*256, c43+c42*256+c41*256*256})
		local doorstate={}
		for i=0,5 do table.insert(doorstate, getVehicleDoorState(vehicle, i)) end
		doorstate=toJSON(doorstate)
		local lightstate={}
		for i=0,3 do table.insert(lightstate, getVehicleLightState(vehicle, i)) end
		lightstate=toJSON(lightstate)
		local panelstates={}
		for i=0,6 do table.insert(panelstates, getVehiclePanelState(vehicle, i)) end
		panelstates=toJSON(panelstates)

		local headlights=toJSON({h1,h2,h3})
		local wh1,wh2,wh3,wh4=getVehicleWheelStates(vehicle)
		local wheelstate=toJSON({wh1,wh2,wh3,wh4})
		local upgrades=getVehicleUpgrades(vehicle)
		local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {engine=0, jump=0, hp=0, suspension={installed=0, value=0}}
		table.insert(upgrades, addons)
		upgrades=toJSON(upgrades)
		local handling = getModelHandling(model)
		local max_speed = handling["maxVelocity"]
		local max_acc = handling["engineAcceleration"]
		local uid = owner or -1
		local owner_name = getPlayerName(player)
		local group = fraction or -1

		mysql:query("INSERT INTO `ms_vehicles` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", id, isSpawned,
		nil, nil, uid, group, model, health, toJSON({x, y, z, rx, ry, rz}), upgrades, paintjob, panelstates, doorstate, wheelstate, lightstate,
		headlights, colors, interior, dimension, license_plate, fuel, dirtlevel, mileage, 0, 0, maxFuel, max_acc, max_speed, "", owner_name, 0, 0, 0)

		local last_id = mysql:getSingleRow("SELECT `id` FROM `ms_vehicles` ORDER BY `id` DESC LIMIT 1")
		setElementData(vehicle, "vehicle:id", last_id["id"])
		setElementData(vehicle, "vehicle:spawn", true)
		setElementData(vehicle, "vehicle:fractionid", group)
		setElementData(vehicle, "vehicle:owner", uid)
		setElementData(vehicle, "vehicle:owner_name", getPlayerName(player))
		return last_id["id"], vehicle
	end
end

function saveVehicle(vehicle)
	if not vehicle then return end
	if isElement(vehicle) then
		local isSpawned=getElementData(vehicle, 'vehicle:spawn')
		if not isSpawned then return end

		local model=vehicle:getModel()
		local health=vehicle:getHealth()
		local x,y,z=getElementPosition(vehicle)
		local rx,ry,rz=getElementRotation(vehicle)
		local frozen=vehicle:isFrozen()
		local id=vehicle:getData('vehicle:id')
		if not id then return end 
		
		local fuel=vehicle:getData('vehicle:fuel')
		local mileage=vehicle:getData('vehicle:mileage')
		local exchange = vehicle:getData("vehicle:exchange") and 1 or 0
		local exchangeCena = vehicle:getData("vehicle:exchange:cena")
		local exchangeMiejsce = vehicle:getData("vehicle:exchange:miejsce")
		local c1,c2,c3,c4,c5,c6=vehicle:getColor()
		local paintjob=getVehiclePaintjob(vehicle)
		local h1,h2,h3=getVehicleHeadLightColor(vehicle)
		local locked=isVehicleLocked(vehicle)
		local dirtlevel=vehicle:getData('vehicle:dirt_level')
		local dimension=vehicle:getDimension()
		local interior=vehicle:getInterior()
		local c11,c12,c13, c21,c22,c23, c31,c32,c33, c41,c42,c43 = getVehicleColor(vehicle,true)
		local colors=toJSON({c13+c12*256+c11*256*256, c23+c22*256+c21*256*256, c33+c32*256+c31*256*256, c43+c42*256+c41*256*256})
		local doorstate={}
		for i=0,5 do table.insert(doorstate, getVehicleDoorState(vehicle, i)) end
		doorstate=toJSON(doorstate)
		local lightstate={}
		for i=0,3 do table.insert(lightstate, getVehicleLightState(vehicle, i)) end
		lightstate=toJSON(lightstate)
		local panelstates={}
		for i=0,6 do table.insert(panelstates, getVehiclePanelState(vehicle, i)) end
		panelstates=toJSON(panelstates)

		local headlights=toJSON({h1,h2,h3})
		local wh1,wh2,wh3,wh4=getVehicleWheelStates(vehicle)
		local wheelstate=toJSON({wh1,wh2,wh3,wh4})
		
		local upgrades=getVehicleUpgrades(vehicle)
		local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {engine=0, jump=0, hp=0, suspension={installed=0, value=0}}
		local neon = getElementData(vehicle, "vehicle:neon")
		addons.neon = neon 
		
		table.insert(upgrades, addons)
		upgrades=toJSON(upgrades)

		local vehicleType = getVehicleTypeByModel(model)
		local maxFuel = vehicles_maxFuel[vehicleType]
		local handling = getModelHandling(model)
		local max_speed = handling["maxVelocity"]
		local max_acc = handling["engineAcceleration"]

		local blocked = getElementData(vehicle, "vehicle:blocked") or ""
		
		local sharing_players = toJSON(vehicle:getData("vehicle:sharing_players"))

		local fractionid = vehicle:getData('vehicle:fractionid')
		if fractionid ~= -1 then
			local query=mysql:query("UPDATE ms_vehicles SET model=?, health=?, frozen=?, wheelstate=?, doorstate=?, lightstate=?, components=?, panelstates=?, headlights=?, colors=?, dimension=?, interior=?, fuel=?, dirt_lvl=?, mileage=?, locked=?, max_fuel=?, max_acc=?, max_speed=?, paintjob=?, blocked=?, gielda=?, gieldaCena=?, gieldaMiejsce=?, sharing_players=? WHERE id=?",
			model, health, frozen, wheelstate, doorstate, lightstate, upgrades, panelstates, headlights, colors, dimension, interior, fuel, dirtlevel, mileage, locked, maxFuel, tonumber(max_acc), tonumber(max_speed), paintjob, blocked, exchange, exchangeCena, exchangeMiejsce, sharing_players, id)
		else
			local query=mysql:query("UPDATE ms_vehicles SET model=?, pos=?, health=?, frozen=?, wheelstate=?, doorstate=?, lightstate=?, components=?, panelstates=?, headlights=?, colors=?, dimension=?, interior=?, fuel=?, dirt_lvl=?, mileage=?, locked=?, max_fuel=?, max_acc=?, max_speed=?, paintjob=?, blocked=?, gielda=?, gieldaCena=?, gieldaMiejsce=?, sharing_players=? WHERE id=?",
			model, ('[[ %0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f ]]'):format(x,y,z,rx,ry,rz), health, frozen, wheelstate, doorstate, lightstate, upgrades, panelstates, headlights, colors, dimension, interior, fuel, dirtlevel, mileage, locked, maxFuel, tonumber(max_acc), tonumber(max_speed), paintjob, blocked, exchange, exchangeCena, exchangeMiejsce, sharing_players, id)
		end
	end
	return true
end

function getVehicleFromUID(uid)
	for k,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:id") == uid then
			return v
		end
	end
end

function saveVehiclePosition(uid)
	local vehicle = getVehicleFromUID(uid)
	if vehicle then
		local x,y,z = getElementPosition(vehicle)
		local rx,ry,rz = getElementRotation(vehicle)
		mysql:query("UPDATE ms_vehicles SET pos=? WHERE id=?", ('[[ %0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f ]]'):format(x,y,z,rx,ry,rz), uid)
	end
end

function spawnVehicle(uid)
	local vehicles=mysql:getRows('SELECT * FROM ms_vehicles WHERE id=? LIMIT 1', uid)
	if vehicles[1] and vehicles[1].gielda > 0 then 
		outputDebugString("[ms-vehicles] Błąd spawnu pojazdu ".. uid .."")
		return
	end
	
	ms_createVehicle(vehicles[1])
	mysql:query("UPDATE ms_vehicles SET spawned=1 WHERE id=?", uid)
end

function unspawnVehicle(uid)
	local vehicle = getVehicleFromUID(uid)
	if vehicle then
		if getElementData(vehicle, "vehicle:exchange") then 
			outputDebugString("[ms-vehicles] Błąd unspawnu pojazdu ".. uid .." Pojazd znajduje się na giełdzie")
			return
		end 
		
		saveVehicle(vehicle)
		destroyElement(vehicle)
		mysql:query("UPDATE ms_vehicles SET spawned=0 WHERE id=?", uid)
	end
end

function lockVehicle(uid, state)
	local veh = getVehicleFromUID(uid)
	if veh then
		setVehicleLocked(veh, state)
		if state then state = 1 else state = 0 end
		mysql:query("UPDATE ms_vehicles SET locked=? WHERE id=?", state, uid)
	end
end

function trackVehicle(player, uid)
	if player and uid then
		local vehicle = getVehicleFromUID(uid)
		if vehicle then
			local x,y,z = getElementPosition(player)
			local x2,y2,z2 = getElementRotation(player)
			setElementRotation(vehicle, x2,y2,z2)
			setElementPosition(vehicle, x,y+1,z)
			setElementInterior(vehicle, getElementInterior(player))
			setElementDimension(vehicle, getElementDimension(player))
			setElementFrozen(vehicle, false)
			triggerClientEvent(player, "onClientAddNotification", player, "Pojazd został teleportowany.", "info")
			return true
		else
			return false
		end
	end

	return false
end

function saveAllVehicles(vehicle)
	local vehicles=getElementsByType('vehicle')
	for _, vehicle in pairs(vehicles) do
		saveVehicle(vehicle)
	end
end

function getVehicleTypeByModel(model)
	for k,v in ipairs(vehicles_type["Truck"]) do
		if v == model then
			return "Truck"
		end
	end

	for k,v in ipairs(vehicles_type["Sport Vehicle"]) do
		if v == model then
			return "Sport Vehicle"
		end
	end

	for k,v in ipairs(vehicles_type["Casual Vehicle"]) do
		if v == model then
			return "Casual Vehicle"
		end
	end

	for k,v in ipairs(vehicles_type["Plane"]) do
		if v == model then
			return "Plane"
		end
	end

	for k,v in ipairs(vehicles_type["Boat"]) do
		if v == model then
			return "Boat"
		end
	end

	for k,v in ipairs(vehicles_type["Motorbike"]) do
		if v == model then
			return "Motorbike"
		end
	end

	return "Casual Vehicle"
end

function getGroupVehicles(group)
	local vehs = {}
	for k,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:fractionid") == group then
			table.insert(vehs, v)
		end
	end

	return vehs
end

function getPlayerVehicles(player)
	if player then
		local query = mysql:getRows("SELECT * FROM `ms_vehicles` WHERE `owner`=?", getElementData(player, "player:uid"))
		return query
	end
end

function respawnVehicles()
	local vehicles = getElementsByType("vehicle")
	
	for k,v in ipairs(vehicles) do
		if not getVehicleController(v) and not getElementData(v, "vehicle:id") and not getElementData(v, "vehicle:job") and not getElementData(v, "vehicle:exchange") then
			respawnVehicle(v)
			fixVehicle(v)
		end
	end
end

-- zdarzenia
function onStartScript()
	local cnt_vehicles=0
	local vehicles=mysql:getRows('SELECT * FROM ms_vehicles WHERE spawned=1')
	for i,v in pairs(vehicles) do
		ms_createVehicle(v, i)
		cnt_vehicles=cnt_vehicles+1
	end
	outputDebugString('[ms-vehicles]: wczytano ' ..cnt_vehicles.. ' pojazdow')
	setTimer(saveAllVehicles, 60000*5, 0)
	setTimer(respawnVehicles, 60000*5, 0)
	
	for k,v in ipairs(getElementsByType("vehicle")) do 
		v:setDamageProof(true)
	end
	
	for k,v in ipairs(getElementsByType("player")) do 
		bindKey(v, "lalt", "down", jumpVehicle)
	end
	addEventHandler("onPlayerJoin", root, function() bindKey(source, "lalt", "down", jumpVehicle) end)
	
	local gielda = getResourceFromName("ms-vehicle_uzywane")
	if gielda then 
		if getResourceState(gielda) == "running" then 
			restartResource(gielda)
		else 
			startResource(gielda)
		end
	end
end
addEventHandler('onResourceStart', resourceRoot, onStartScript)

function onExitScript()
	saveAllVehicles()
end
addEventHandler('onResourceStop', resourceRoot, onExitScript)

addEventHandler('onVehicleStartEnter', root, function(player, seat, jacked, door)
	if not source then return end 
	
	local owner = getElementData(source, "vehicle:owner") or false
	local sharing_players = getElementData(source, "vehicle:sharing_players")
	local allow_access = false
	
	if sharing_players then
		for k,v in ipairs(sharing_players) do
			if tonumber(v) == tonumber(getElementData(player, "player:uid")) then	
				allow_access = true
				break
			end
		end
	end
	
	if seat == 0 then
		if owner then 
			if owner ~= getElementData(player, "player:uid") and getElementData(player, "player:rank") ~= 3 and allow_access == false then
				triggerClientEvent(player, 'onClientAddNotification', player, 'Nie jesteś właścicielem tego pojazdu!', 'error')
				cancelEvent()
			end
		end
	end
	
	local x,y,z=getElementPosition(source)
	local x2,y2,z2=getElementPosition(player)
	if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2)>10 then
		-- anulowanie animacji wejscia do pojazdu powyzej 10j
		cancelEvent()
		return false
	end

	if isVehicleLocked(source) then	
		if getElementData(player, "player:rank") == 3 then
			warpPedIntoVehicle(player, source)
		end
		triggerClientEvent(player, 'onClientAddNotification', player, 'Ten pojazd jest zamknięty!', 'error')
		cancelEvent()
		return false
	end
	
	if seat == 0 then 
	source:setDamageProof(false)
	end
end)

addEventHandler("onVehicleEnter", root, function(player)
	if getElementData(source, "vehicle:exchange") then 
		setVehicleEngineState(source, false)
	end 
end)

addEventHandler('onVehicleStartEnter', root, function(player)
	local job = getElementData(source, "vehicle:job") or false
	local playerJob = getElementData(player, "player:job") or false
	if job ~= playerJob then
		triggerClientEvent(player, 'onClientAddNotification', player, 'Nie możesz korzystać z tego pojazdu!', 'error')
		cancelEvent()
		return
	end
	
	if getElementData(source, "vehicle:exchange") then 
		cancelEvent()
		return
	end
end)

addEventHandler('onVehicleExit', root, function(player, seat, jacked)
	if seat~=0 then return end
	saveVehicle(source)
end)

-- skoki pojazdami 
function jumpVehicle(player)
	local vehicle = getPedOccupiedVehicle(player)
	local seat = getPedOccupiedVehicleSeat(player)
	if vehicle and seat == 0 then 
		local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {jump=0}
		if addons.jump > 0 then 
			local now = getTickCount() 
			local lastUse = getElementData(vehicle, "vehicle:jump_delay") or 0 
			local jump_extra = getElementData(vehicle, "vehicle:jump_extra")
			if lastUse > now then 
				local time = math.ceil(((lastUse-now)/1000))
				triggerClientEvent(player, "onClientAddNotification", player, "Skok pojazdu dostępny za "..tostring(time).."s.", "warning", 2500)
				return 
			end
			
			local x, y, z = getElementVelocity(vehicle)
			setElementVelocity(vehicle, x, y, z+jump_extra)
			setElementData(vehicle, "vehicle:jump_delay", now+((math.floor(60/addons.jump))*1000))
			triggerClientEvent(player, "setLastJump", player, player, vehicle)
		end
	end
end


function addPlayerToVehicle(player, cmd, id)
	
	local vehicle = getPedOccupiedVehicle(player)
	local player_find = false
	
	if tonumber(id) == getElementData(player, "player:id") then return triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz dodać samego siebie.", "warning", 2500) end
	
	
	if id then
		if vehicle then
		
			local sharing_players = getElementData(vehicle, "vehicle:sharing_players") or {}
			
			if getPedOccupiedVehicleSeat ( player ) ~= 0 then
				triggerClientEvent(player, "onClientAddNotification", player, "Musisz siedzieć na miejscu kierowcy!", "warning", 2500)
				return
			end
			
			if getElementData(vehicle, "vehicle:owner") ~= getElementData(player, "player:uid") then
				triggerClientEvent(player, "onClientAddNotification", player, "Nie jesteś właścicielem tego pojazdu!", "warning", 2500)
				return
			end
			
			if not getElementData(vehicle, "vehicle:id") then
				triggerClientEvent(player, "onClientAddNotification", player, "Ta opcja jest przeznaczona tylko do prywatnych pojazdów!.", "warning", 2500)
				return 
			end
			
			for k,v in ipairs(getElementsByType("player")) do
				if tonumber(id) == getElementData(v, "player:id") then
					player_find = v
					break
				end
			end
			
			for k,v in ipairs(sharing_players) do
				if v == getElementData(player_find, "player:uid") then
					triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz już jest dodany!", "error", 2500)
					return
				end
			end		
			
			if player_find then
				sharing_players = getElementData(vehicle, "vehicle:sharing_players") or {}
				table.insert(sharing_players, tonumber(getElementData(player_find, "player:uid")))
				setElementData(vehicle, "vehicle:sharing_players", sharing_players)
				triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz może już korzystać z twojego pojazdu.", "success", 2500)
				triggerClientEvent(player_find, "onClientAddNotification", player_find, "".. getPlayerName(player).. " przyznał ci dostęp do pojazdu ".. getVehicleName(vehicle) .."!", "success", 2500)
			else
				triggerClientEvent(player, "onClientAddNotification", player, "Nie znaleziono podanego gracza.", "warning", 2500)
			end
		else
			triggerClientEvent(player, "onClientAddNotification", player, "Wsiądź do pojazdu", "warning", 2500)
		end
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Wpisz id gracza którego chcesz dodać do pojazdu", "warning", 2500)
	end
end
addCommandHandler("vdodaj", addPlayerToVehicle)

function deletePlayerFromVehicle(player, cmd, id)
	local vehicle = getPedOccupiedVehicle(player)
	local player_find = false
	
	if tonumber(id) == getElementData(player, "player:id") then return triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz dodać samego siebie.", "warning", 2500) end
	
	if id then
		if vehicle then
			if getPedOccupiedVehicleSeat ( player ) ~= 0 then
				triggerClientEvent(player, "onClientAddNotification", player, "Musisz siedzieć na miejscu kierowcy!", "warning", 2500)
				return
			end
			
			if getElementData(vehicle, "vehicle:owner") ~= getElementData(player, "player:uid") then
				triggerClientEvent(player, "onClientAddNotification", player, "Nie jesteś właścicielem tego pojazdu!", "warning", 2500)
				return
			end
			
			if not getElementData(vehicle, "vehicle:id") then
				triggerClientEvent(player, "onClientAddNotification", player, "Ta opcja jest przeznaczona tylko do prywatnych pojazdów!.", "warning", 2500)
				return 
			end
			
			local sharing_players = getElementData(vehicle, "vehicle:sharing_players")
			local find = false
			
			for k,v in ipairs(getElementsByType("player")) do
				if tonumber(id) == getElementData(v, "player:id") then
					player_find = v
					break
				end
			end
		
			if player_find then
				for k,v in ipairs(sharing_players) do
					if tonumber(v) == tonumber(getElementData(player_find, "player:uid")) then
						table.remove(sharing_players, k)
						find = true
						break
					end
				end
			else
				triggerClientEvent(player, "onClientAddNotification", player, "Gracz nie został znaleziony!", "warning", 2500)
			end
			
			if find then
				triggerClientEvent(player, "onClientAddNotification", player, "Gracz został pomyślnie usunięty!", "success", 2500)
				triggerClientEvent(player_find, "onClientAddNotification", player_find, "".. getPlayerName(player).. " zabrał ci dostęp do pojazdu ".. getVehicleName(vehicle) .."!", "success", 2500)
				setElementData(vehicle, "vehicle:sharing_players", sharing_players)
			else
				triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz nie ma dostepu do twojego pojazdu!", "warning", 2500)
			end
		else
			triggerClientEvent(player, "onClientAddNotification", player, "Wsiądź do pojazdu", "warning", 2500)
		end
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Wpisz id gracza którego chcesz usunąć z pojazdu.", "warning", 2500)
	end
end
addCommandHandler("vusun", deletePlayerFromVehicle)
