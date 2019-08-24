local tuneShops = {
	{enter={830.62,-1206.97,16}, exit={865.70,-1239.13,15.5, 0}},
	{enter={2386.84,1039.71,10}, exit={2393.14,990.66,10.34, 90}},
	{enter={-1786.90,1206.32,24}, exit={-1772.04,1204.27,25.13, 180}}
}

function onPlayerAddUpgrade(upgrade, price, modifiers)
	if upgrade and price and client then
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then
			exports["ms-gameplay"]:msTakeMoney(client, price)
			exports["ms-achievements"]:addAchievement(client, "Szpan musi być")
			
			if upgrade == 1010 then 
				setElementData(vehicle, "vehicle:hasNOS", true)
				addVehicleUpgrade(vehicle, upgrade)
			elseif upgrade == 69 then 
				updateModifiers(vehicle, modifiers)
			else 
				addVehicleUpgrade(vehicle, upgrade)
			end
		end
	end
end
addEvent("onPlayerAddUpgrade", true)
addEventHandler("onPlayerAddUpgrade", root, onPlayerAddUpgrade)

function onPlayerSellUpgrade(upgrade, price, modifiers)
	if upgrade and price and client then
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then
			exports["ms-gameplay"]:msGiveMoney(client, price/2, true)
			
			if upgrade == 1010 then 
				setElementData(vehicle, "vehicle:hasNOS", false)
				removeVehicleUpgrade(vehicle, upgrade)
			elseif upgrade == 69 then 
				updateModifiers(vehicle, modifiers)
			else 
				removeVehicleUpgrade(vehicle, upgrade)
			end
		end
	end
end
addEvent("onPlayerSellUpgrade", true)
addEventHandler("onPlayerSellUpgrade", root, onPlayerSellUpgrade)

function onPlayerAddPaintjob(paintjob, price)
	if paintjob and price then
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then
			exports["ms-gameplay"]:msTakeMoney(client, price)
			setVehiclePaintjob(vehicle, paintjob)
		end
	end
end
addEvent("onPlayerAddPaintjob", true)
addEventHandler("onPlayerAddPaintjob", root, onPlayerAddPaintjob)

function onPlayerRemovePaintjob(paintjob, price)
	if paintjob and price and client then
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then
			exports["ms-gameplay"]:msTakeMoney(client, price)
			setVehiclePaintjob(vehicle, 3)
		end
	end
end
addEvent("onPlayerRemovePaintjob", true)
addEventHandler("onPlayerRemovePaintjob", root, onPlayerRemovePaintjob)

function onPlayerSetColor(vehicleColor, lightColor, price)
	if vehicleColor and lightColor and price then
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then
			exports["ms-gameplay"]:msTakeMoney(client, price)
			setVehicleColor(vehicle, vehicleColor[1], vehicleColor[2], vehicleColor[3], vehicleColor[4], vehicleColor[5], vehicleColor[6])
			setVehicleHeadLightColor(vehicle, lightColor[1], lightColor[2], lightColor[3])
		end
	end
end
addEvent("onPlayerSetColor", true)
addEventHandler("onPlayerSetColor", root, onPlayerSetColor)

function updateModifiers(vehicle, modifiers)
	local handling = getModelHandling(getElementModel(vehicle))
	local max_speed = handling["maxVelocity"]
	local max_acc = handling["engineAcceleration"]
	
	if modifiers.engine == 1 then 
		max_speed = max_speed + (max_speed*0.14)
		max_acc = max_acc + (max_acc*0.14)
	elseif modifiers.engine == 2 then 
		max_speed = max_speed + (max_speed*0.25)
		max_acc = max_acc + (max_acc*0.25)
	elseif modifiers.engine == 3 then 
		max_speed = max_speed + (max_speed*0.375)
		max_acc = max_acc + (max_acc*0.375)
	elseif modifiers.engine == 4 then
		max_speed = max_speed + (max_speed*0.5)
		max_acc = max_acc + (max_acc*0.5)
	end 	
		
	if modifiers.jump == 0 then 
		setElementData(vehicle, "vehicle:jump_extra", false)
	elseif modifiers.jump == 1 then
		setElementData(vehicle, "vehicle:jump_extra", 0.20)
	elseif modifiers.jump == 2 then
		setElementData(vehicle, "vehicle:jump_extra", 0.30)
	elseif modifiers.jump == 3 then
		setElementData(vehicle, "vehicle:jump_extra", 0.40)
	elseif modifiers.jump == 4 then
		setElementData(vehicle, "vehicle:jump_extra", 0.50)
	end
			
	setVehicleHandling(vehicle, "maxVelocity", max_speed)
	setVehicleHandling(vehicle, "engineAcceleration", max_acc)
			
	setElementData(vehicle, "vehicle:extraHP", 250*modifiers.hp)

	setElementData(vehicle, "vehicle:upgrade_addons", modifiers)
end 

function onPlayerAddModifier(modifiers, price)
	if client and modifiers and price then 
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then 
			updateModifiers(vehicle, modifiers)
			
			exports["ms-gameplay"]:msTakeMoney(client, price)
		end
	end
end 
addEvent("onPlayerAddModifier", true)
addEventHandler("onPlayerAddModifier", root, onPlayerAddModifier)

function onPlayerRemoveModifier(modifiers, price)
	if client and modifiers and price then 
		local vehicle = getPedOccupiedVehicle(client)
		if vehicle then 
			updateModifiers(vehicle, modifiers)
			
			exports["ms-gameplay"]:msGiveMoney(client, price/2, true)
		end
	end
end 
addEvent("onPlayerRemoveModifier", true)
addEventHandler("onPlayerRemoveModifier", root, onPlayerRemoveModifier)

function onPlayerBuyNeon(price)
	if client and price then 
		exports["ms-gameplay"]:msTakeMoney(client, price)
	end
end 
addEvent("onPlayerBuyNeon", true)
addEventHandler("onPlayerBuyNeon", root, onPlayerBuyNeon)

addEvent("onPlayerExitTuneShop", true)
addEventHandler("onPlayerExitTuneShop", root, 
	function(tuneshopID)
		local x, y, z = tuneShops[tuneshopID].exit[1], tuneShops[tuneshopID].exit[2], tuneShops[tuneshopID].exit[3]
		local rot = tuneShops[tuneshopID].exit[4] 
		setElementData(source, "block:player_teleport", false)
		local vehicle = getPedOccupiedVehicle(client)
		removePedFromVehicle(client)
		setElementFrozen(vehicle, false)
		setElementPosition(client, x, y, z)
		setElementInterior(client, 0)
		setElementDimension(client, 0)
		
		setElementPosition(vehicle, x, y, z)
		setElementRotation(vehicle, 0, 0, rot)
		setElementInterior(vehicle, 0)
		setElementDimension(vehicle, 0)
		
		setTimer(warpPedIntoVehicle, 1000, 1, client, vehicle)
	end 
)

addEventHandler("onPlayerCommand", root,
	function()
		if getElementData(source, "player:inTuneShop") then 
			cancelEvent()
		end
	end  
)

addEventHandler("onResourceStart", resourceRoot, 
	function()
		for k,v in ipairs(tuneShops) do 
			local marker = createMarker(v.enter[1], v.enter[2], v.enter[3], "cylinder", 6, 0, 200, 200, 150, root) 
			setElementData(marker, "tuneshop:id", k)
			addEventHandler("onMarkerHit", marker, onEnterTuneShop)
			
			local blip = createBlipAttachedTo(marker, 27, 2, 255, 0, 0, 255, 0, 300, root)
			setElementData(blip, 'blipIcon', 'tune')
			setElementData(blip, 'blipColor', {255,0,0,255})
			
			local text = createElement("3dtext")
			setElementPosition(text, v.enter[1], v.enter[2], v.enter[3]+2)
			setElementData(text, "text", "Tuning prywatnych pojazdów")
		end
	end 
)

function onEnterTuneShop(hitElement)
	if getElementType(hitElement) == "player" then
		local vehicle = getPedOccupiedVehicle(hitElement)
		if not vehicle then return end 
			
		if not getElementData(vehicle, "vehicle:id") then 
			triggerClientEvent(hitElement, "onClientAddNotification", hitElement, "Możesz tuningować tylko prywatne pojazdy.", "error", 5000)
			return
		end 
		
		if getElementData(vehicle, "vehicle:owner") ~= getElementData(hitElement, "player:uid") then
			triggerClientEvent(hitElement, "onClientAddNotification", hitElement, "Tylko właściciel może tuningować pojazd!", "error", 5000)
			return
		end
		
		for seat, player in pairs(getVehicleOccupants(vehicle)) do
			if seat ~= 0 then
				removePedFromVehicle(player)
			end
		end

		if isElement(vehicle) then
			if getVehicleType(vehicle) == "BMX" then
				triggerClientEvent(hitElement, "onClientAddNotification", hitElement, "Nie możesz tuningować tego pojazdu.", "error", 5000)
				return
			end

			local tuneshopID = getElementData(source, "tuneshop:id")
			setElementData(source, "block:player_teleport", true)
			fadeCamera(hitElement, false, 0.5)
			setTimer(function(player, vehicle)
				local rand = math.random(1, 10000)
				removePedFromVehicle(player)
				setElementInterior(player, 1)
				setElementDimension(player, rand)
				setElementPosition(player, 1391.86, -16.71, 1000.61)
				
				setElementInterior(vehicle, 1)
				setElementPosition(vehicle, 1391.86, -16.71, 1000.61)
				setElementRotation(vehicle, 0, 0, 270)
				setElementDimension(vehicle, rand)
				setElementFrozen(vehicle, true)
				setTimer(warpPedIntoVehicle, 500, 1, player, vehicle)
				triggerClientEvent(player, "onPlayerShowTuneShop", player, vehicle, tuneshopID)
				fadeCamera(hitElement, true)
			end, 510, 1, hitElement, vehicle)
		end
	end
end
