function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function onPlayerChangeVehicleSetting(interaction)
	if client then 
		if getElementData(client, "player:onPiano") then return end
		
		local vehicle = getPedOccupiedVehicle(client)
		if getPedOccupiedVehicleSeat(client) == 0 then 
			if getElementData(vehicle, "vehicle:exchange") then 
				triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w pojeździe giełdowym.", "warning")
				return
			end 
			
			if interaction == 1 then 
				if getVehicleType(vehicle) == "BMX" then 
					triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w tym pojeździe.", "warning")
					return
				end 
				
				setVehicleEngineState(vehicle, not  getVehicleEngineState(vehicle))
			elseif interaction == 2 then 
				if getVehicleType(vehicle) == "BMX" then 
					triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w tym pojeździe.", "warning")
					return
				end 
				
				if getVehicleOverrideLights(vehicle) ~= 2 then 
					setVehicleOverrideLights(vehicle, 2)
				else 
					setVehicleOverrideLights(vehicle, 1)
				end
			elseif interaction == 3 then
				if getVehicleType(vehicle) ~= "Automobile" then
					triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w tym pojeździe.", "warning")
					return
				end 
				
				if getElementSpeed(vehicle, "km/h") > 3 then 
					triggerClientEvent(client, "onClientAddNotification", client, "Musisz zwolnić.", "warning", 3000)
				else 
					setElementFrozen(vehicle, not isElementFrozen(vehicle))
				end
			elseif interaction == 4 then 
				if getVehicleType(vehicle) ~= "Automobile" then 
					triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w tym pojeździe.", "warning")
					return
				end 
		
				if getVehicleDoorOpenRatio(vehicle, 0) == 1 then 
					setVehicleDoorOpenRatio(vehicle, 0, 0, 1000)
				else 
					setVehicleDoorOpenRatio(vehicle, 0, 1, 1000)
				end
			elseif interaction == 5 then 
				if getVehicleType(vehicle) ~= "Automobile" then 
					triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz tego zrobić w tym pojeździe.", "warning")
					return
				end 
				
				if getVehicleDoorOpenRatio(vehicle, 1) == 1 then 
					setVehicleDoorOpenRatio(vehicle, 1, 0, 1000)
				else 
					setVehicleDoorOpenRatio(vehicle, 1, 1, 1000)
				end
			elseif interaction == 6 then 
				if not getElementData(vehicle, "vehicle:id") then 
					triggerClientEvent(client, "onClientAddNotification", client, "Możesz zamykać tylko prywatne pojazdy.", "warning")
					return
				end 
				
				setVehicleLocked(vehicle, not isVehicleLocked(vehicle))
			elseif interaction == 7 then 
				if not getElementData(vehicle, "vehicle:neon") then 
					triggerClientEvent(client, "onClientAddNotification", client, "Nie masz neonów w tym pojeździe.", "warning")
					return
				end 
				
				local neon = getElementData(vehicle, "vehicle:neonDisabled") or false
				setElementData(vehicle, "vehicle:neonDisabled", not neon)
			end
		end
	end
end 
addEvent("onPlayerChangeVehicleSetting", true)
addEventHandler("onPlayerChangeVehicleSetting", root, onPlayerChangeVehicleSetting)