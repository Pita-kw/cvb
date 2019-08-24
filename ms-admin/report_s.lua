--[[
	@project: multiserver
	@author: Brzysiek <brzysiekdev@gmail.com>
	@filename: report_c.lua
	@desc: raporty
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]


local mysql = exports["ms-database"]

function getReports()
	local requests = mysql:getRows("SELECT * FROM `ms_reports`")
	return requests
end

function addReport(player, target, reason)
	if player and target and reason then
		mysql:query("INSERT INTO `ms_reports` VALUES (?, ?, ?, ?, ?, ?)", nil, player, target, reason, nil, "brak")
		for k,v in pairs(getElementsByType("player")) do
			if getElementData(v, "player:rank") then 
				if getElementData(v, "player:rank") > 0 then
					triggerClientEvent(v, "onClientAddNotification", v, "Otrzymałeś nowy raport", "info")
				end
			end 
		end
	end
end

function onPlayerAcceptReport(id, player, index)
	local isUsed = mysql:getSingleRow("SELECT `used` FROM `ms_reports` WHERE `id`=?", id)
	if isUsed and isUsed["used"] ~= "brak" then 
		triggerClientEvent(client, "onClientAddNotification", client, "Ktoś już przejął ten raport", "error")
		triggerClientEvent(client, "onClientSetUsingReport", client, index, isUsed["used"])
		return 
	end 
	
	mysql:query("UPDATE `ms_reports` SET `used`=? WHERE `id`=?", getPlayerName(client), id)
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:rank") > 0 then triggerClientEvent(v, "onClientSetUsingReport", v, index, getPlayerName(client)) end 
	end 
	
	if getPlayerFromName(player) then 
		triggerClientEvent(getPlayerFromName(player), "onClientAddNotification", getPlayerFromName(player), "Twój raport jest rozpatrywany", "info")
	end 
end 
addEvent("onPlayerAcceptReport", true)
addEventHandler("onPlayerAcceptReport", root, onPlayerAcceptReport)

function deleteRequest(id, player)
	if id and player then
		if #mysql:getRows("SELECT `id` FROM `ms_reports` WHERE `id`=?", id) == 0 then return end 
		
		mysql:query("DELETE FROM `ms_reports` WHERE `id`=?", id)
		if getPlayerFromName(player) then 
			triggerClientEvent(getPlayerFromName(player), "onClientAddNotification", getPlayerFromName(player), "Twój raport został rozstrzygnięty", "info") 
		end 
	end
end
addEvent("onPlayerDeleteReport", true)
addEventHandler("onPlayerDeleteReport", root, deleteRequest)

function zgloszenia(player, cmd)
	if player and cmd then
		if getElementData(player, "player:rank") < 1 then 
			return 
		end 

		local requests = getReports()
		triggerClientEvent(player, "onShowReportsWindow", player, requests)
	end
end
addCommandHandler("raporty", zgloszenia)
addCommandHandler("reports", zgloszenia)
addCommandHandler("raports", zgloszenia) 

function report(player, cmd, arg1, ...)
	if player and cmd then
		if not getElementData(player, "player:spawned") then return end 
		
		local now = getTickCount()
		local lastMessageTick = getElementData(player, "player:lastMessage") or 0
		if lastMessageTick > now then
			local time = math.ceil((lastMessageTick-now)/1000)  
			triggerClientEvent(client, "onClientAddNotification", client, "Odczekaj jeszcze "..tostring(time).."s przed wysłaniem następnej wiadomości.", "error")
			setElementData(player, "player:lastMessage", lastMessageTick+400)
			cancelEvent()
			return
		end
		setElementData(player, "player:lastMessage", getTickCount()+5000)
		
		local powod = table.concat ( {...}, " " )	
		if arg1 and #powod > 0 then 
			local plr = false 
			
			for k,v in ipairs(getElementsByType("player")) do 
				if getElementData(v, "player:id") == tonumber(arg1) then 
					plr = v 
				end 
			end 
			
			if not plr then 
				triggerClientEvent(player, "onClientAddNotification", player, "Użycie:\n/raport <id gracza> <wiadomość>", "info")
				return 
			end 
			
			addReport(getPlayerName(player), getPlayerName(plr), powod) 
			triggerClientEvent(player, "onClientAddNotification", player, "Twój raport zostanie rozpatrzony.", "success")
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Użycie:\n/raport <id gracza> <wiadomość>", "info")
		end 
	end 
end 
addCommandHandler("raport", report)
addCommandHandler("report", report)