local distance = 50 

function odlicz(player, cmd)
	if player and cmd then 
		if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Dostępne tylko na domyślnym świecie gry. (Virtual World 0)", "info")
			return
		end 
		
		local now = getTickCount()
		local last = getElementData(player, "player:lastCountdown") or 0 
		if last > now then 
			local time = math.ceil(((last-now)/1000))
			triggerClientEvent(player, "onClientAddNotification", player, "Odliczanie dostępne za "..tostring(time).."s.", "warning", 2500)
			return 
		end 
		setElementData(player, "player:lastCountdown", now+30000)
		
		local px, py, pz = getElementPosition(player)
		for k, v in ipairs(getElementsByType("player")) do 
			local x, y, z = getElementPosition(v)
			if getDistanceBetweenPoints3D(px, py, pz, x, y, z) < distance then 
				triggerClientEvent(v, "onClientShowCountdown", v)
				triggerClientEvent(v, "onClientAddNotification", v, "Gracz "..getPlayerName(player).." rozpoczął odliczanie dla graczy w pobliżu "..tostring(distance).." m.", "info")
			end
		end
	end
end 
addCommandHandler("odlicz", odlicz)