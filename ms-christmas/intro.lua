local rotation = 178
local teleport_allow = false
local positions = {
	{x = -2330.91, y = -1619.97, z = 485.36},
	{x = -2328.30, y = -1620.01, z = 485.36},
	{x = -2325.95, y = -1620.21, z = 485.36},
	{x = -2323.44, y = -1620.16, z = 485.36},
	{x = -2320.79, y = -1620.16, z = 485.36},
	{x = -2318.26, y = -1620.19, z = 485.36},
	{x = -2316.09, y = -1620.02, z = 485.36},
	{x = -2316.10, y = -1617.58, z = 485.36},
	{x = -2318.40, y = -1617.63, z = 485.36},
	{x = -2321.17, y = -1617.76, z = 485.36},
	{x = -2323.61, y = -1617.37, z = 485.36},
	{x = -2326.06, y = -1617.78, z = 485.36},
	{x = -2328.58, y = -1617.39, z = 485.36},
	{x = -2330.94, y = -1617.50, z = 485.36},
	{x = -2330.89, y = -1614.94, z = 485.36},
	{x = -2328.30, y = -1614.91, z = 485.36},
	{x = -2325.87, y = -1615.19, z = 485.36},
	{x = -2323.19, y = -1615.31, z = 485.36},
	{x = -2320.77, y = -1615.03, z = 485.36},
	{x = -2318.27, y = -1615.08, z = 485.36},
	{x = -2315.99, y = -1614.81, z = 485.36},
	{x = -2315.84, y = -1612.52, z = 485.36},
	{x = -2318.65, y = -1612.85, z = 485.36},
	{x = -2320.97, y = -1612.81, z = 485.36},
	{x = -2323.59, y = -1612.52, z = 485.36},
	{x = -2326.10, y = -1612.43, z = 485.36},
	{x = -2328.29, y = -1612.62, z = 485.36},
	{x = -2331.02, y = -1612.63, z = 485.36},
	{x = -2330.97, y = -1609.94, z = 485.36},
	{x = -2328.57, y = -1610.12, z = 485.36},
	{x = -2325.90, y = -1610.10, z = 485.36},
	{x = -2322.22, y = -1610.01, z = 485.36},
	{x = -2319.66, y = -1609.93, z = 485.36},
	{x = -2317.20, y = -1609.91, z = 485.36},
	{x = -2314.62, y = -1609.98, z = 485.36},
	{x = -2314.65, y = -1607.59, z = 485.36},
	{x = -2317.23, y = -1607.67, z = 485.36},
	{x = -2319.87, y = -1607.53, z = 485.36},
	{x = -2322.23, y = -1607.42, z = 485.36},
	{x = -2324.62, y = -1607.49, z = 485.36},
	{x = -2327.24, y = -1607.57, z = 485.36},
	{x = -2329.74, y = -1607.64, z = 485.36},
	{x = -2329.74, y = -1605.05, z = 485.36},
	{x = -2327.19, y = -1604.97, z = 485.36},
	{x = -2324.73, y = -1605.16, z = 485.36},
	{x = -2322.20, y = -1604.96, z = 485.36},
	{x = -2319.67, y = -1605.06, z = 485.36},
	{x = -2317.16, y = -1604.98, z = 485.36},
	{x = -2314.74, y = -1605.15, z = 485.36}
}


function startChristmas(player)
	if getElementData(player, "player:rank") ~= 3 then return end
	local index = 1
	
	for k,v in ipairs(getElementsByType("player")) do
		if getPedOccupiedVehicle(v) then removePedFromVehicle(v) end
		if not getPlayerTeam(v) or not getElementData(v, 'player:job') or not getElementData(v, "player:arena") or not isPedDead(v) then
			if positions[index].x and positions[index].y and positions[index].z then
				setElementPosition(v, positions[index].x, positions[index].y, positions[index].z)
				setElementRotation(v, 0, 0, rotation)
			else
				local random = math.random(1, #positions)
				setElementPosition(v, positions[random].x, positions[random].y, positions[random].z)
				setElementRotation(v, 0, 0, rotation)
			end
			
			index = index + 1
			triggerClientEvent(v, "startChristmasIntro", v)
			setPedAnimation(v, "DANCING", "DAN_left_A", 1, true, false, true, true)
			setElementData(v, "intro_view", true)
			takeAllWeapons(v)
		else
			triggerClientEvent(v, 'onClientAddNotification', v,  "Nie możesz zostać przeniesiony na event mikołajkowy. Spróbuj ponownie wpisując komendę /mikolajki", "error")
		end
	end
end
addCommandHandler("mikostart", startChristmas)

function teleportPlayer(player)
	if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Masz zablokowaną możliwość teleportowania się!", "error") return end
	if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się gdy wykonujesz pracę!", "error") return end
	if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby się teleportować najpierw wyjdź z areny wpisująć komendę /ae", "error") return end
	if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
	if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
	if isPedInVehicle(player) and int ~= 0 and dim ~= 0 then triggerClientEvent(player, "onClientAddNotification", player, "Najpierw wyjdź z pojazdu.", "warning") return end 
	if not teleport_allow then triggerClientEvent(player, "onClientAddNotification", player, "Teleport zablokowany.", "warning") return end
	
	if getElementData(player, "intro_view") == false then
		triggerClientEvent(player, "startChristmasIntro", player)
		setElementData(player, "intro_view", true)
	end
	
	local random = math.random(1, #positions)
	setElementPosition(player, positions[random].x, positions[random].y, positions[random].z)
	setElementRotation(player, 0, 0, rotation)
	takeAllWeapons(player)
end
addCommandHandler("mikolajki", teleportPlayer)

function allowTeleports(player)
	if teleport_allow == false then
		triggerClientEvent(player, "onClientAddNotification", player, "Teleport odblokowany.", "success")
		teleport_allow = true
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Teleport zablokowany.", "info")
		teleport_allow = false
	end
end
addCommandHandler("allowteleports", allowTeleports)