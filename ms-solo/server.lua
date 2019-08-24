local requests = {}

local spawns = {
	{1741.78,-2874.43,108.25, 0},
	{1741.95,-2833.92,108.25, 180},
}

local soloObjects = {}

local weaponStats = {
	[22] = 69, -- [id broni] = id ped statu
	[23] = 70,
	[24] = 71,
	[25] = 72,
	[26] = 73,
	[27] = 74,
	[28] = 75,
	[29] = 76,
	[30] = 77,
	[31] = 78,
	[34] = 79
}

function onSoloPlayerDie(totalAmmo, killer)
	if not getElementData(source, "player:solo") then return end 
	
	local soloPlayer1 = source 
	local soloPlayer2 = getElementData(source, "player:solo") 
	
	local winner = false 
	local loser = false 
	
	if source == soloPlayer1 then 
		winner = soloPlayer2
		loser = soloPlayer1
	elseif source == soloPlayer2 then 
		winner = soloPlayer1 
		loser = soloPlayer2
	end 
	
	if winner and loser then 
		soloPlayer1 = false 
		soloPlayer2 = false
		exports["ms-stats"]:addPlayerStat(winner, "player:solo_wins", 1)
		resetSoloPlayer(winner)
		resetSoloPlayer(loser)
		
		triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(winner).. " wygrywa pojedynek z "..getPlayerName(loser).."! (/wyzwij)", "info", 5000, false)
	end
end 
addEventHandler("onPlayerWasted", root, onSoloPlayerDie)

function onPlayerQuit()
	if not getElementData(source, "player:solo") then return end 
	
	local soloPlayer1 = source 
	local soloPlayer2 = getElementData(source, "player:solo") 
	if soloPlayer1 and soloPlayer2 then 
		if soloPlayer1 == source then 
			resetSoloPlayer(soloPlayer2)
		elseif soloPlayer2 == source then 
			resetSoloPlayer(soloPlayer1)
		end
	end
end 
addEventHandler("onPlayerQuit", root, onPlayerQuit)

function resetSoloPlayer(player)
	setElementData(player, "player:solo", false)
	setElementData(player, "player:block_teleport", false)
	setElementData(player, "player:status", "W grze")
	
	setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 100, 1, player)
	exports["ms-gameplay"]:restoreWeaponsSkills(player)
	
	local dim = getElementDimension(player)
	if soloObjects[dim] then 
		for k,v in ipairs(soloObjects[dim]) do 
			exports["ms-map"]:destroyMSObject(v)
		end
		
		soloObjects[dim] = nil
	end
	
	triggerEvent("onPlayerRequestSAMPObjects", player) -- odswiezenie obiektow SAMP 
end 

function createSoloObject(...)
	local obj = exports["ms-map"]:createMSObject(...)
	local dim = select(8, ...)
	if not soloObjects[dim] then 
		soloObjects[dim] = {}
	end 
	
	table.insert(soloObjects[dim], obj)
end 

function createSoloObjects(dimension)
	-- arena solo 
	createSoloObject(19272,1741.8700000,-2854.1100000,105.0000000,0.0000000,0.0000000,0.0000000, dimension, 0)
	createSoloObject(18876,1741.8700000,-2854.1100000,104.9000000,0.0000000,0.0000000,0.0000000, dimension, 0)
	createSoloObject(3799,1741.8700000,-2834.1100000,104.9000000,0.0000000,0.0000000,0.0000000, dimension, 0)
	createSoloObject(3799,1761.8700000,-2854.1100000,104.9000000,0.0000000,0.0000000,0.0000000, dimension, 0)
	createSoloObject(3799,1741.8700000,-2874.1100000,104.9000000,0.0000000,0.0000000,0.0000000, dimension, 0)
	createSoloObject(3799,1721.8700000,-2854.1100000,104.9000000,0.0000000,0.0000000,0.0000000, dimension, 0)
	createSoloObject(19075,1741.8700000,-2854.1100000,118.5000000,180.0000000,0.0000000,0.0000000, dimension, 0)
end 

function spawnSoloPlayers(player1, player2, weapon, stats, armor)
	if not player1 or not player2 then return end 
	if getElementData(player1, "player:solo") then return end
	if getElementData(player1, "block:player_teleport") then return end
	if getElementData(player1, 'player:job') then return end
	if getElementData(player1, "player:arena") then return end
	if getPlayerTeam(player1) then return end
	if isPedDead(player1) then return end 
	
	if getElementData(player2, "player:solo") then return end
	if getElementData(player2, "block:player_teleport") then return end
	if getElementData(player2, 'player:job') then return end
	if getElementData(player2, "player:arena") then return end
	if getPlayerTeam(player2) then return end
	if isPedDead(player2) then return end 
	
	local dim = getElementData(player1, "player:id")
	createSoloObjects(dim)
	
	local player = player1
	local x, y, z, rot = spawns[1][1], spawns[1][2], spawns[1][3], spawns[1][4]
	removePedFromVehicle(player)
	setElementPosition(player, x, y, z)
	setElementRotation(player, 0, 0, rot)
	setElementDimension(player, dim)
	setElementInterior(player, 0)
	setElementHealth(player, 100)
	setElementData(player, "player:zone", false)
	setElementData(player, "player:god", false)
	setElementData(player, "player:block_teleport", true)
	setElementData(player, "player:solo", player2)
	setElementData(player, "player:status", "Solo z "..getPlayerName(player2))
	takeAllWeapons(player)
	giveWeapon(player, weapon, 99999)
	setPedArmor(player, (armor and 100 or 0))
	if stats then 
		for k, v in pairs(weaponStats) do 
			setPedStat(player, v, 1000)
		end
	end 
	triggerEvent("onPlayerRequestSAMPObjects", player) -- odswiezenie obiektow SAMP  
	
	local player = player2
	local x, y, z, rot = spawns[2][1], spawns[2][2], spawns[2][3], spawns[2][4]
	removePedFromVehicle(player)
	setElementPosition(player, x, y, z)
	setElementRotation(player, 0, 0, rot)
	setElementDimension(player, dim)
	setElementInterior(player, 0)
	setElementHealth(player, 100)
	setElementData(player, "player:zone", false)
	setElementData(player, "player:god", false)
	setElementData(player, "player:block_teleport", true)
	setElementData(player, "player:solo", player1)
	setElementData(player, "player:status", "Solo z "..getPlayerName(player1))
	takeAllWeapons(player)
	giveWeapon(player, weapon, 99999)
	setPedArmor(player, (armor and 100 or 0))	
	if stats then 
		for k, v in pairs(weaponStats) do 
			setPedStat(player, v, 1000)
		end
	end 
	triggerEvent("onPlayerRequestSAMPObjects", player) -- odswiezenie obiektow SAMP 
	
	return true
end 

function awyzwij(player, cmd)
	local request = requests[player]
	if request then 
		if not isElement(request[1]) then 
			triggerClientEvent(player, "onClientAddNotification", player, "Gracz, który rzucił ci wyzwanie, wyszedł z gry.", "error")
			return
		end 
		
		if spawnSoloPlayers(player, request[1], request[2], request[3], request[4]) then 
			requests[player] = nil
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Ty lub drugi gracz nie możecie teraz przyjąć wyzwania.", "error")
		end
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie masz żadnych oczekujących wyzwań (lub poprzednie wygasło).", "info")
	end
end
addCommandHandler("awyzwanie", awyzwij)

function onPlayerSendSoloRequest(targetPlayer, weapon, glitches, stats)
	if client then 
		if requests[targetPlayer] then 
			triggerClientEvent(targetPlayer, "onClientAddNotification", targetPlayer, "Ktoś wyzwał tego gracza. Jego zaproszenie musi wygasnąć.", "error")
			return
		end 
		
		if getElementData(targetPlayer, "player:solo") then 
			triggerClientEvent(targetPlayer, "onClientAddNotification", targetPlayer, "Ten gracz jest już na solo.", "error")
			return
		end
		
		if isElement(targetPlayer) then 
			triggerClientEvent(targetPlayer, "onClientAddNotification", targetPlayer, getPlayerName(client).." wyzywa cię na pojedynek!\nWpisz /awyzwanie by akceptować.\nBroń: "..getWeaponNameFromID(weapon).."\nUmiejętności broni na 100%: "..(glitches and "tak" or "nie").."\nArmor: "..(stats and "tak" or "nie"), "info", 20000)
			requests[targetPlayer] = {client, weapon, glitches, stats}
			setTimer(function(targetPlayer) requests[targetPlayer] = nil end, 30000, 1, targetPlayer)
			
			triggerClientEvent(client, "onClientAddNotification", client, "Wyzwanie wysłane pomyślnie!", "success")
		else 
			triggerClientEvent(client, "onClientAddNotification", client, "Gracz, którego chciałeś wyzwać wyszedł z gry.", "error")
		end
	end
end
addEvent("onPlayerSendSoloRequest", true)
addEventHandler("onPlayerSendSoloRequest", root, onPlayerSendSoloRequest)

function onResourceStop()
	for index, objects in pairs(soloObjects) do 
		for k, v in ipairs(objects) do 
			exports["ms-map"]:destroyMSObject(v)
		end
	end
	
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:solo") then 
			setElementData(v, "player:solo", false)
			setElementData(v, "player:status", "W grze")
			triggerEvent("onPlayerRequestSAMPObjects", v)
		end
	end 
	
	soloObjects = {}
end 
addEventHandler("onResourceStop", resourceRoot, onResourceStop)