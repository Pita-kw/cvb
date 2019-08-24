local nitros = {[1008] = true, [1009] = true, [1010] = true}

function onVehicleEnter(player, seat)
	if player and seat == 0 then 
		if not getElementData(source, "vehicle:job") and not getElementData(source, "vehicle:id") then 
			if (getVehicleUpgradeOnSlot(source, 8) == 1010) == false then 
				addVehicleUpgrade(source, 1010)
				setElementData(source, "vehicle:hasNOS", true)
			end
		else 
			local upgrade = getVehicleUpgradeOnSlot(source, 8) 
			setElementData(source, "vehicle:hasNOS", nitros[upgrade] or false)
		end
	end
end 
addEventHandler("onVehicleEnter", root, onVehicleEnter)