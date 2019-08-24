local SHOW_TIME = 9000 
local FADE_TIME = 1000 
local MESSAGE_MINIMUM = 10 
local MESSAGE_MAXIMUM = 100 

local rankColors = {
	[0] = "#f1c40f", -- vip, 
	[1] = "#2ecc71",
	[2] = "#2980b9", 
	[3] = "#e74c3c",
}

local blocked = false 

function ann(player, cmd, ...)
	if not getElementData(player, "player:spawned") then return end 
	if not getElementData(player, "player:premium") then 
		triggerClientEvent(player, "onClientAddNotification", player, "Funkcja dostępna tylko dla VIPów.", "error")
		return 
	end 
	if blocked then 
		triggerClientEvent(player, "onClientAddNotification", player, "Ktoś inny właśnie korzysta z tej funkcji.", "error")
		return
	end 
	
	local now = getTickCount()
	local lastUse = getElementData(player, "player:lastAnnUsed") or 0 
	lastUse = lastUse+60000
	
	
	local blockPlayerChat = getElementData(player, 'player:blockChat') or 0
	local block_time = math.ceil((blockPlayerChat-now)/1000)  
	
	if blockPlayerChat > 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "Jesteś uciszony! Będziesz mógł pisać za ".. block_time .." sekund", "warning")
		cancelEvent()
		return
	end	
	
	if lastUse > now then 
		local time = math.ceil(((lastUse-now)/1000))
		triggerClientEvent(player, "onClientAddNotification", player, "Ogłoszenie dostępne dla ciebie za "..tostring(time).."s.", "warning", 5000)
		return 
	end 
	
	local color = rankColors[0]
	local message=table.concat({ ... }, ' ')
	if #message > MESSAGE_MINIMUM and #message < MESSAGE_MAXIMUM then 
		local name = getPlayerName(player)
		name = color..name 
		triggerClientEvent(root, "onClientAddAnnouncement", root, name, message, SHOW_TIME, FADE_TIME, color)
		
		setElementData(player, "player:lastAnnUsed", now) 
		
		blocked = true 
		setTimer(function() blocked = false end, SHOW_TIME+FADE_TIME, 1)
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Twoja wiadomość musi mieć conajmniej "..tostring(MESSAGE_MINIMUM).." i maksimum "..tostring(MESSAGE_MAXIMUM).." znaków.", "error")
	end
end 
addCommandHandler("ann", ann)

function og(player, cmd, time, ...)
	if not getElementData(player, "player:spawned") then return end 
	local rank = getElementData(player, "player:rank") or 0 
	if rank < 1 then return end 
	if blocked then 
		triggerClientEvent(player, "onClientAddNotification", player, "Ktoś inny właśnie korzysta z tej funkcji.", "error")
		return
	end 
	
	if not time or (time and tonumber(time) < 5) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Składnia: /og <czas w sekundach (minimum 5)> <wiadomość>", "error")
		return
	end 
	
	local color = rankColors[rank]
	local message=table.concat({ ... }, ' ')
	if #message > MESSAGE_MINIMUM then 
		local name = getPlayerName(player)
		name = color..name 
		triggerClientEvent(root, "onClientAddAnnouncement", root, name, message, tonumber(time)*1000, FADE_TIME, color)
		
		blocked = true 
		setTimer(function() blocked = false end, tonumber(time)*1000+FADE_TIME, 1)
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Twoja wiadomość musi mieć conajmniej "..tostring(MESSAGE_MINIMUM).." i maksimum "..tostring(MESSAGE_MAXIMUM).." znaków.", "error")
	end
end 
addCommandHandler("og", og)