addEvent("onClientEventSetVehicleGhostmode", true)
addEventHandler("onClientEventSetVehicleGhostmode", root, function(vehicles, enabled)
	enabled = not enabled 
	
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		for k, v in ipairs(vehicles) do 
			if isElement(v) then 
				setElementCollidableWith(veh, v, enabled)
			end
		end
	end
end)

function updateEvent()
	if getElementDimension(localPlayer) == getElementData(resourceRoot, "event:dimension") then 
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle then
			for k, v in ipairs(getElementsByType("vehicle")) do 
				setElementCollidableWith(vehicle, v, not getElementData(resourceRoot, "event:ghostmode"))
			end
		end
	end
end 
setTimer(updateEvent, 1000, 0)