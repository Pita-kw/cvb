function onClientVehicleDamage(attacker, weapon, loss)
	local extraHP = getElementData(source, "vehicle:extraHP") or 0 
	extraHP = math.max(0, extraHP-loss)
	setElementData(source, "vehicle:extraHP", extraHP)
	
	if extraHP > 0 then 
		cancelEvent()
	end
end 
addEventHandler("onClientVehicleDamage", root, onClientVehicleDamage)


function setLastJump(player, vehicle)
	local now = getTickCount() 
	local lastUse = getElementData(vehicle, "vehicle:jump_delay_client") or 0 
	local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {jump=0}
	setElementData(vehicle, "vehicle:jump_delay_client", now+((math.floor(60/addons.jump))*1000))
end
addEvent("setLastJump", true)
addEventHandler("setLastJump", getRootElement(), setLastJump)