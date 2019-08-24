function loadSuspensionBinds(player)
	bindKey(player, "[", "down", suspensionUp)
	bindKey(player, "]", "down", suspensionDown)
end 

function loadSuspension()
	addEventHandler("onPlayerJoin", root, function()
		loadSuspensionBinds(source)
	end)
	
	for k, v in ipairs(getElementsByType("player")) do 
		loadSuspensionBinds(v)
	end
end 
addEventHandler("onResourceStart", resourceRoot, loadSuspension)

function setSuspension(vehicle, value)
	local hydraulics = getVehicleUpgradeOnSlot(vehicle, 9) == 1087
	if hydraulics then 
		removeVehicleUpgrade(vehicle, 1087)
	end 
	
	local handling = getModelHandling(getElementModel(vehicle))
	local s = handling["suspensionLowerLimit"]+value
	setVehicleHandling(vehicle, "suspensionLowerLimit", s)
	
	if hydraulics then 
		addVehicleUpgrade(vehicle, 1087)
	end 
end 

function suspensionUp(player)
	if not isPedInVehicle(player) then return end 
	
	local vehicle = getPedOccupiedVehicle(player)
	if getVehicleController(vehicle) ~= player then return end 
	
	local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {suspension={installed=0}}
	if addons.suspension.installed == 1 then
		if addons.suspension.value <= -4 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Osiągnąłeś limit podwyższenia zawieszenia.", "error", 3000)
			return
		end 
		
		addons.suspension.value = addons.suspension.value-1 
		setSuspension(vehicle, addons.suspension.value*0.05)
		
		setElementData(vehicle, "vehicle:upgrade_addons", addons)
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Ten pojazd nie ma zamontowanej kontroli zawieszenia.", "error", 3000)
	end
end 

function suspensionDown(player)
	if not isPedInVehicle(player) then return end 
	
	local vehicle = getPedOccupiedVehicle(player)
	if getVehicleController(vehicle) ~= player then return end 
	
	local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {suspension={installed=0}}
	if addons.suspension.installed == 1 then 
		if addons.suspension.value >= 4 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Osiągnąłeś limit zniżenia zawieszenia.", "error", 3000)
			return
		end 
		
		addons.suspension.value = addons.suspension.value+1 
		setSuspension(vehicle, addons.suspension.value*0.05)
		
		setElementData(vehicle, "vehicle:upgrade_addons", addons)
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Ten pojazd nie ma zamontowanej kontroli zawieszenia.", "error", 3000)
	end
end 