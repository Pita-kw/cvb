local mysql = exports["ms-database"]

function onPickupHit(hitElement)
	if isPedInVehicle(hitElement) then return end
	
	if hitElement then
		fadeCamera(hitElement, false, 0.5)
		setTimer(
		function()
			local query = mysql:getRows("SELECT * FROM `ms_vehicleshop`")
			local playerVehicle = exports["ms-vehicles"]:getPlayerVehicles(hitElement)
			triggerClientEvent(hitElement, "onPlayerEnterVehicleShop", hitElement, query, playerVehicles)
			fadeCamera(hitElement, true, 0.5)
			toggleAllControls(hitElement, false)
		end, 500, 1)
	end
end

function onStart()
	local pickup = createPickup(2132.26,-1148.82,24.34, 3, 1239, 1)
	local blip = createBlipAttachedTo(pickup, 55, 2, 255, 255, 255, 255, 0, 300, root)
	setElementData(blip, 'blipIcon', 'vehicle_shop')
	addEventHandler("onPickupHit", pickup, onPickupHit)
end
addEventHandler("onResourceStart", resourceRoot, onStart)


function onPlayerBuyVehicle(vehicleModel, price)
	if vehicleModel and client then
		local databaseID, vehicle = exports["ms-vehicles"]:addNewVehicle(vehicleModel, 2148.69, -1161.37 - math.random(1, 8), 24, 0, 0, 270, getElementData(client, "player:uid"), -1, client)
		warpPedIntoVehicle(client, vehicle)
		triggerClientEvent(client, "onClientAddNotification", client, "Zakupiłeś "..tostring(getVehicleNameFromModel(vehicleModel)).." za $"..tostring(price).." pomyślnie.", "success")
		exports["ms-achievements"]:addAchievement(client, "Moje pierwsze auto")
		exports["ms-gameplay"]:msTakeMoney(client, price)
	end
end
addEvent("onPlayerBuyVehicle", true)
addEventHandler("onPlayerBuyVehicle", root, onPlayerBuyVehicle)
