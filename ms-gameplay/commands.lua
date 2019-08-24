local players_position = {}
local teleports_invites = {}


function teleportPlayerToPlayer(player, cmd, player_id)
	for k,v in pairs(getElementsByType("player")) do 
			if getElementData(v, "player:id") == tonumber(player_id) then 
				if v == player then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się do samego siebie!", "error") return end
				if getElementData(v, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz ma zablokowane teleporty!!", "error") return end
				if getElementData(v, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz obecnie wykonuje prace!!", "error") return end
				if getElementData(v, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz jest na arenie!", "error") return end
				if getPlayerTeam(v) then triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz jest na evencie!", "error") return end
				if isPedDead(v) then triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz jest martwy!", "error") return end 
				if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Masz zablokowaną możliwość teleportowania się!", "error") return end
				if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się gdy wykonujesz pracę!", "error") return end
				if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby się teleportować najpierw wyjdź z areny wpisująć komendę /ae", "error") return end
				if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
				if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
					
				triggerClientEvent(player, "onClientAddNotification", player, "Wysłałeś prośbę o teleport do gracza ".. getPlayerName(v).. ". Czekaj na akceptację", "info")
				triggerClientEvent(v, "onClientAddNotification", v, "Gracz ".. getPlayerName(player).. ". Wysłał prośbę o teleport do ciebie. Wpisz /tpac ".. getElementData(player, "player:id") .." aby zaakceptować teleport.", "info")
				teleports_invites[player] = v
				teleport_timer = setTimer(onTeleportExpired, 30000, 1, player, v)
			end
	end 
end
addCommandHandler("idzdo", teleportPlayerToPlayer)

function acceptPlayerTeleport(player, cmd, player_id)
	for k,v in pairs(getElementsByType("player")) do 
			if getElementData(v, "player:id") == tonumber(player_id) then 
				if teleports_invites[v] == player then
					if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Masz zablokowaną możliwość teleportowania się!", "error") return end
					if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się gdy wykonujesz pracę!", "error") return end
					if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby się teleportować najpierw wyjdź z areny wpisująć komendę /ae", "error") return end
					if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
					if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
					
					local x,y,z = getElementPosition(player)
					local i = getElementInterior(player)
					local dim = getElementDimension(player)
					setElementPosition(v, x,y,z)
					setElementInterior(v, i)
					setElementDimension(v, dim)
					teleports_invites[v] = nil
					triggerClientEvent(player, "onClientAddNotification", player, "Zaakceptowałeś teleport gracza ".. getPlayerName(v) .."", "info")
					triggerClientEvent(v, "onClientAddNotification", v, "Gracz ".. getPlayerName(player) .." zaaceptował twój teleport", "info")
					killTimer(teleport_timer)
				else
					triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz nie wysyłał do ciebie prośby o teleport", "error")
				end
			end
	end 
end
addCommandHandler("tpac", acceptPlayerTeleport)

function onTeleportExpired(player, player_invited)
	teleports_invites[player] = nil
	triggerClientEvent(player, "onClientAddNotification", player, "Prośba o teleport do gracza ".. getPlayerName(player_invited).. " straciło ważność.", "error")
end

function savePlayerPosition(player)
	if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teraz użyć tej komendy!", "error") return end
	if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz użyć tej komendy gdy wykonujesz pracę!", "error") return end
	if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby użyć tej komendy wyjdź z areny wpisująć komendę /ae", "error") return end
	if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
	if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teraz użyć tej komendy.", "error") return end 

	local x,y,z = getElementPosition(player)
	local rx,ry,rz = getElementRotation(player)
	
	players_position[player] = {x, y, z, rx, ry, rz}
	
	triggerClientEvent(player, "onClientAddNotification", player, "Pozycja pomyślnie zapisana!", "success")
end
addCommandHandler("sp", savePlayerPosition)

function loadPlayerPosition(player)
	if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Masz zablokowaną możliwość teleportowania się!", "error") return end
	if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się gdy wykonujesz pracę!", "error") return end
	if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby się teleportować najpierw wyjdź z areny wpisująć komendę /ae", "error") return end
	if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
	if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz się teraz teleportować.", "error") return end 
	if not players_position[player] then triggerClientEvent(player, "onClientAddNotification", player, "Nie masz zapisanej pozycji!", "warning") return end
	
	local now = getTickCount()
	local lastDamage = getElementData(player, "player:lastDamage") or 0 
	
	if lastDamage > now then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś niedawno postrzelony! Poczekaj chwilę", "error")
		return
	end
	fadeCamera(player, false, 1)
	setTimer(
		function(player, x, y, z, int, dim)
		local vehicle = getPedOccupiedVehicle(player)
		local seat = getPedOccupiedVehicleSeat(player)
		if vehicle and seat == 0 then
			setElementPosition(vehicle, players_position[player][1], players_position[player][2], players_position[player][3])
			setElementRotation(vehicle, players_position[player][4], players_position[player][5], players_position[player][6])
		else
			if vehicle and seat ~= 0 then
				removePedFromVehicle(player)
			end
			setElementPosition(player, players_position[player][1], players_position[player][2], players_position[player][3])
			setElementRotation(player, players_position[player][4], players_position[player][5], players_position[player][6])
		end
		fadeCamera(player, true, 1)
	end, 1000, 1, player, x, y, z, int, dim, rot)	
	
	triggerClientEvent(player, "onClientAddNotification", player, "Pozycja pomyślnie wczytana!", "success")
end
addCommandHandler("lp", loadPlayerPosition)

function przelej(player, cmd, id, ilosc)
	if getElementData(player, "player:spawned") then 
		
		if tonumber(getElementData(player, "player:level")) < 5 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Aby przelewać pieniądze musisz osiągnąć co najmniej 5 level.", "warning")
			return
		end
		
		if not id then 
			triggerClientEvent(player, "onClientAddNotification", player, "Składnia: /przelej <id gracza> <kwota od 100>", "warning")
			return
		end 
		
		if not ilosc or not tonumber(ilosc) or tonumber(ilosc) < 100 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Składnia: /przelej <id gracza> <kwota od 100>", "warning")
			return 
		end
		
		local money = getElementData(player, "player:money") or 0 
		if money < tonumber(ilosc) then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie masz tyle pieniędzy.", "warning")
			return 
		end 
		
		local targetPlayer = getElementByID("p"..tostring(id))
		if player == targetPlayer then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz przelewać pieniędzy sobie.", "warning")
			return
		end 
		
		if isElement(targetPlayer) then 
			local targetMoney = getElementData(targetPlayer, "player:money") or 0 
			setElementData(targetPlayer, "player:money", targetMoney+tonumber(ilosc))
			setElementData(player, "player:money", money-tonumber(ilosc))
			
			triggerClientEvent(targetPlayer, "onClientAddNotification", targetPlayer, "Dostałeś $"..tostring(ilosc).." od gracza "..getPlayerName(player), "info")
			triggerClientEvent(player, "onClientAddNotification", player, "Przelałeś $"..tostring(ilosc).." graczowi "..getPlayerName(targetPlayer), "info")
			exports["ms-admin"]:gameView_add("[PRZELEW] "..getPlayerName(player).." przelał graczowi "..getPlayerName(targetPlayer).." $"..tostring(ilosc))
			outputServerLog("[PRZELEW] "..getPlayerName(player).." przelał graczowi "..getPlayerName(targetPlayer).." $"..tostring(ilosc))
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie znaleziono takiego gracza.", "warning")
		end
	end
end
addCommandHandler("przelej", przelej)

local style = {
	[1] = 4,
	[2] = 5,
	[3] = 6,
	[4] = 7,
	[5] = 15,
	[6] = 16,
}

addCommandHandler("stylwalki", function(player, cmd, arg1)
	local styl = tonumber(arg1)
	if style[styl] then 
		setPedFightingStyle(player, style[styl])
		triggerClientEvent(player, "onClientAddNotification", player, "Zmieniono styl walki na "..tostring(styl)..".", "info")
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Składnia: /stylwalki <od 1 do 6>", "error")
	end
end)

addEventHandler("onClientPlayerQuit", getRootElement(), 
	function()
		players_position[source] = nil
	end
)