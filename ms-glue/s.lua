function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ, player)	
	attachElements(source, vehicle, x, y, z, rotX, rotY, rotZ)
	setPedWeaponSlot(source, slot)
	setElementData(player, "player:glue", true)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer",getRootElement(),gluePlayer)

function ungluePlayer(player)
	detachElements(source)
	setElementData(player, "player:glue", false)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer",getRootElement(),ungluePlayer)

function cancelEnterOnGlueActive(player)
	if getElementData(player, "player:glue") then
		triggerClientEvent(player, 'onClientAddNotification', player, 'Jesteś przyklejony do pojazdu. Aby się odkleić kliknij X.', 'error')
		cancelEvent()
		return
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), cancelEnterOnGlueActive)