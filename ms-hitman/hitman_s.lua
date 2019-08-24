local hitman_players = {}
local hitman_blips = {}

local function informationForPlayers(text, time)
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:spawned") then 
				triggerClientEvent(v, "onClientAddNotification", v, tostring(text), {type="error", custom="image", x=0, y=0, w=40, h=40, image=":ms-hitman/skull.png"}, tonumber(time), false)
		end
	end	
end

function createSkullBlipForPlayer(player) 
	local player_cost = getElementData(player, "player:hitman_cost") or 0
	
	if player and tonumber(player_cost) > 0 and not isElement(hitman_blips[player]) then
		local x,y,z = getElementPosition(player)
		hitman_blips[player] = createBlipAttachedTo(player, 52)
		setElementData(hitman_blips[player], 'blipIcon', 'skull')
		setElementData(hitman_blips[player], 'exclusiveBlip', true)
		setElementData(player, "player:hide_blip", true)
	end
end	
addEvent("createSkullBlipForPlayer", true)
addEventHandler("createSkullBlipForPlayer", getRootElement(), createSkullBlipForPlayer)

function createSkullBlipForPlayers()
	for k,v in pairs(getElementsByType("player")) do 
			if getElementData(v, "player:id") then 
				createSkullBlipForPlayer(v)
			end
	end
end
addEventHandler("onResourceStart", getRootElement(), createSkullBlipForPlayers)

local function hitmanOrder(player, cmd, arg1, arg2)
	if not arg1 or not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nieprawidłowe użycie komendy\n/hitman [id gracza] [cena].", "error")
		return 
	end
	
	if tonumber(arg2) < 100 or tonumber(arg2) > 50000 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nieprawidłowa kwota. Dozwolona kwota to 500$ - 50000$.", "error")
		outputServerLog("[HITMAN]: Próba wystawienia dużej kwoty! ".. getPlayerName(player) .." (".. arg2 ..")")
		return 
	end
	
	if tonumber(getElementData(player, "player:level")) < 5 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Aby wystawić pieniądze za gracza musisz mieć przynajmniej 5 lvl.", "error")
		return 
	end
	
	local player_money = getElementData(player, "player:money")

	
	if tonumber(player_money) < tonumber(arg2) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie masz tyle pieniędzy!", "error")
		return 
	end
	
	local now = getTickCount()
		
	local lastHitman = getElementData(player, "player:lastHitman") or 0 
	if lastHitman > now then 
		local time = math.ceil(((lastHitman-now)/1000))
		triggerClientEvent(player, "onClientAddNotification", player, "Kolejne wyznaczenie dostepne za "..tostring(time).."s.", "warning", 2500)
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
				local player_cost = getElementData(v, "player:hitman_cost") or 0
				
				if tonumber(player_cost) > 0 then
					local cost_to_add = player_cost + tonumber(arg2)
					setElementData(v, "player:hitman_cost", cost_to_add)
					informationForPlayers("".. getPlayerName(player) .." dokłada ".. math.floor(arg2) .."$ za zabicie gracza ".. getPlayerName(v) .."  Łączna kwota za zabicie wynosi ".. math.floor(cost_to_add) .."$", 15000)
					outputServerLog("[HITMAN] Gracz ".. getPlayerName(player) .." dokłada ".. math.floor(arg2) .."$ za zabicie gracza ".. getPlayerName(v) .."  Łączna kwota za zabicie wynosi ".. math.floor(cost_to_add) .."$")
				else
					informationForPlayers("".. getPlayerName(player) .." oferuje ".. math.floor(arg2) .."$ za zabicie gracza ".. getPlayerName(v) .." został on oznaczony na mapie czaszką.", 15000)
					setElementData(v, "player:hitman_cost", math.floor(arg2))
					outputServerLog("[HITMAN] Gracz ".. getPlayerName(player) .." oferuje ".. math.floor(arg2) .."$ za zabicie gracza ".. getPlayerName(v) .." został on oznaczony na mapie czaszką.")
				end
				
				createSkullBlipForPlayer(v)
				exports["ms-gameplay"]:msTakeMoney(player, math.floor(tonumber(arg2)))
				setElementData(player, "player:lastHitman", now+60*1000)
			return 
		end
	end 
end
addCommandHandler("hitman", hitmanOrder)


function showOrderPlayers(player)
	local index_count = 1
	
	for k,v in ipairs(getElementsByType("player")) do
		local hitman_cost = getElementData(v, "player:hitman_cost") or 0
		if tonumber(hitman_cost) > 0 then
			outputChatBox("".. index_count ..". ".. getPlayerName(v) .."		(".. hitman_cost .."$)", player)
			index_count = index_count + 1
		end
	end
	
	if index_count == 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "Obecnie nie ma graczy za które można zgarnąć nagrodę.", "warning")
	end
end
addCommandHandler("hitman-list", showOrderPlayers)


local function checkPlayerCost( ammo, attacker, weapon, bodypart, stealth )

	if weapon == 51 then return end
	if not isElement(attacker) then return end
	if source == attacker then return end
	
	if getElementType(attacker) == "player" then
		local player_cost = getElementData(source, "player:hitman_cost") or 0
		if tonumber(player_cost) > 0 then
			exports["ms-gameplay"]:msGiveMoney(attacker, player_cost, true)
			setElementData(source, "player:hitman_cost", 0)
			setElementData(source, 'blipIcon', 'player')
			
			if isElement(hitman_blips[source]) then 
				destroyElement(hitman_blips[source]) 
				hitman_blips[source] = nil
				setElementData(source, "player:hide_blip", false)
			end
			
			informationForPlayers("Gracz ".. getPlayerName(attacker) .." zgarnął ".. player_cost .."$ za zabicie gracza ".. getPlayerName(source) .."", 5000)
			outputServerLog("[HITMAN] Gracz ".. getPlayerName(attacker) .." zgarnął ".. player_cost .."$ za zabicie gracza ".. getPlayerName(source) .."")
		end
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), checkPlayerCost )


function onPlayerCostQuit ()
	if isElement(hitman_blips[source]) then
		destroyElement(hitman_blips[source])
		hitman_blips[source] = nil
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), onPlayerCostQuit )