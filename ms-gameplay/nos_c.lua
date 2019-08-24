function toggleNOS(key, state)
	local veh = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if veh and getElementData(veh, "vehicle:hasNOS") and seat == 0 then
		if state == "up" then
			removeVehicleUpgrade( veh, 1010 )
			setControlState( "vehicle_fire", false )
		else
			addVehicleUpgrade( veh, 1010 )
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	bindKey( "vehicle_fire", "both", toggleNOS )
	bindKey( "vehicle_secondary_fire", "both", toggleNOS )
	
	setBlurLevel(0)
end)