local mysql = exports["ms-database"]


function isColor(color)
	if color == nil or type(color) ~= 'string' then
        return false
    end
	
	if color:match('#%x%x%x%x%x%x') then 
		return true 
	end 
end

function onPlayerRequestDashboardData()
	if client then 
		local vehicles = exports["ms-vehicles"]:getPlayerVehicles(client) or {} 
		local achievements = exports["ms-achievements"]:getPlayerAchievements(client) or {}
		triggerClientEvent(client, "onClientGetDashboardData", client, vehicles, achievements)
	end
end 
addEvent("onPlayerRequestDashboardData", true)
addEventHandler("onPlayerRequestDashboardData", root, onPlayerRequestDashboardData)

function onPlayerSpawnVehicle(vehicleData)
	
	if spawn_block == true then return end
	spawn_block = true
	
	if client and vehicleData then 
		if isPedDead(client) then triggerClientEvent(client, "onClientAddNotification", client, "Jesteś martwy!", "error") return end 
		if getPlayerTeam(client) then triggerClientEvent(client, "onClientAddNotification", client, "Jesteś na atrakcji!", "error") return end 
		
		if vehicleData.gielda == 1 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Ten pojazd jest wystawiony na giełdę.", "error")
			spawn_block = false
			return
		end 
		
		if vehicleData.spawned == 0 then 
			exports["ms-vehicles"]:spawnVehicle(vehicleData.id)
			triggerClientEvent(client, "onClientAddNotification", client, "Pojazd zespawnowany pomyślnie.", "success", 4500)
			spawn_block = false
		else 
			exports["ms-vehicles"]:unspawnVehicle(vehicleData.id)
			triggerClientEvent(client, "onClientAddNotification", client, "Pojazd unspawnowany pomyślnie.", "info", 4500)
			spawn_block = false
		end
		
		onPlayerRequestDashboardData()
	end
end 
addEvent("onPlayerSpawnVehicle", true)
addEventHandler("onPlayerSpawnVehicle", root, onPlayerSpawnVehicle)

function onPlayerTeleportVehicle(vehicleData)
	if client and vehicleData then 
		if isPedDead(client) then triggerClientEvent(client, "onClientAddNotification", client, "Jesteś martwy!", "error") return end 
		
		if isPedInVehicle(client) or getPlayerTeam(client) or getElementData(client, "block:vehicle_spawn") or getElementInterior(client) ~= 0 or getElementData(client, 'player:job') then 
			triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz teraz teleportować pojazdu.", "error")
			return 
		end
		
		if vehicleData.gielda == 1 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Ten pojazd jest wystawiony na giełdę.", "error")
			return
		end 
		
		exports["ms-vehicles"]:trackVehicle(client, vehicleData.id)
		triggerClientEvent(client, "onClientAddNotification", client, "Pojazd przywołany.", "info")
	end
end 
addEvent("onPlayerTeleportVehicle", true)
addEventHandler("onPlayerTeleportVehicle", root, onPlayerTeleportVehicle)

function onPlayerLockVehicle(vehicleData)
	if client and vehicleData then 
		if vehicleData.gielda == 1 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Ten pojazd jest wystawiony na giełdę.", "error")
			return
		end 
		
		local state = vehicleData.locked == 1
		exports["ms-vehicles"]:lockVehicle(vehicleData.id, not state)
	end
end 
addEvent("onPlayerLockVehicle", true)
addEventHandler("onPlayerLockVehicle", root, onPlayerLockVehicle)


function onPlayerChangeAvatar(url)
	local uid = getElementData(client, "player:uid")
	local query = mysql:query("UPDATE `ms_accounts` SET `avatar`=? WHERE `id`=?", url, uid)
	triggerEvent("onPlayerResetAvatar", client, uid)
end 
addEvent("onPlayerChangeAvatar", true)
addEventHandler("onPlayerChangeAvatar", root, onPlayerChangeAvatar)

function onPlayerChangeNickname(nick)
	if client and nick then
		local accounts = mysql:getRows("SELECT * FROM `ms_accounts`")
		
		if isColor(nick) then 
			triggerClientEvent(client, "onClientAddNotification", client, "Nie można kolorować nicków!", "error")
			return
		end
		
		
		for k,v in ipairs(accounts) do 
			if v["login"] == nick:gsub("%s+", "") then 
				triggerClientEvent(client, "onClientAddNotification", client, "Ta nazwa jest już zajęta.", "error")
				return 
			end 
		end
		
		mysql:query("UPDATE `ms_accounts` SET `login`=? WHERE `id`=?", nick, getElementData(client, "player:uid"))
		mysql:query("UPDATE `ms_houses` SET `ownerName`=? WHERE `owner`=?", nick, getElementData(client, "player:uid"))
		mysql:query("UPDATE `ms_vehicles` SET `ownerName`=? WHERE `owner`=?", nick, getElementData(client, "player:uid"))
		triggerClientEvent(client, "onClientAddNotification", client, "Nick zmieniony pomyślnie.", "info")
		setPlayerName(client, nick)
	end
end
addEvent("onPlayerChangeNickname", true)
addEventHandler("onPlayerChangeNickname", root, onPlayerChangeNickname)


function onPlayerChangePassword(curpaswd, passwd)
	if client and passwd and curpaswd then
		local clientPassword = mysql:getSingleRow("SELECT `password` FROM `ms_accounts` WHERE `id`=?", getElementData(client, "player:uid"))["password"]
		if clientPassword ~= sha256(md5(curpaswd)) then
			triggerClientEvent(client, "onClientAddNotification", client, "Podałeś złe aktualne hasło.", "error")
			return
		end
		
		if #passwd < 6 or #passwd > 22 then
			triggerClientEvent(client, "onClientAddNotification", client, "Hasło musi składać się od 6 do 22 znaków!", "error")
			return
		end

		mysql:query("UPDATE `ms_accounts` SET `password`=? WHERE `id`=?", sha256(md5(passwd)), getElementData(client, "player:uid"))
		triggerClientEvent(client, "onClientAddNotification", client, "Hasło zmienione pomyślnie.", "info")
	end
end
addEvent("onPlayerChangePassword", true)
addEventHandler("onPlayerChangePassword", root, onPlayerChangePassword)

function onPlayerChangeMail(pass, mail)
	if pass and mail then
		local clientPassword = mysql:getSingleRow("SELECT `password` FROM `ms_accounts` WHERE `id`=?", getElementData(client, "player:uid"))["password"]
		local clientMail = mysql:getSingleRow("SELECT `email` FROM `ms_accounts` WHERE `id`=?", getElementData(client, "player:uid"))["email"]
		if clientPassword ~= sha256(md5(pass)) then
			triggerClientEvent(client, "onClientAddNotification", client, "Podałeś złe aktualne hasło.", "error")
			return
		end
		
		if clientMail == mail then
			triggerClientEvent(client, "onClientAddNotification", client, "Podany nowy email jest taki sam jak aktualny.", "error")
			return
		end
		
		if mail:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") then  
			mysql:query("UPDATE `ms_accounts` SET `email`=? WHERE `id`=?", mail, getElementData(client, "player:uid"))
			triggerClientEvent(client, "onClientAddNotification", client, "E-Mail zmieniony pomyślnie.", "info")
		else
			triggerClientEvent(client, "onClientAddNotification", client, "Podany adres email jest nieprawidłowy!", "error")
		end
	end
end
addEvent("onPlayerChangeMail", true)
addEventHandler("onPlayerChangeMail", root, onPlayerChangeMail)

function onPlayerBuyPremium(player, days, cost, check)
	if player then 
		local h = days*24 
		local m = h*60 
		local s = m*60 
		
		
		local sp = getElementData(player, "player:sp") or 0
		
		sp = sp-cost 
		if sp < 0 and check ~= true then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie masz tyle diamentów!", "error")
			return 
		end 
		
		if check ~= true then
			setElementData(player, "player:sp", sp)
		end
		
		local premium = getElementData(player, "player:premium") or 0 
		
		if premium == 0 then 
			setElementData(player, "player:premium", getRealTime().timestamp+s) 
			mysql:query("UPDATE `ms_accounts` SET `premium`=? WHERE `id`=?", getRealTime().timestamp+s, getElementData(player, "player:uid"))
		else 
			setElementData(player, "player:premium", premium+s) 
			mysql:query("UPDATE `ms_accounts` SET `premium`=? WHERE `id`=?", premium+s, getElementData(player, "player:uid"))
		end 
		
		triggerClientEvent(player, "onClientAddNotification", player, "Do długości twojego konta premium zostało dodanych "..tostring(days).." dni.", "info")
	end 
end 
addEvent("onPlayerBuyPremium", true)
addEventHandler("onPlayerBuyPremium", root, onPlayerBuyPremium)

function onPlayerBuyGang(player, cost)
	if player then 
		local level = getElementData(player, "player:level") or 0 
		if level < 20 then 
			triggerClientEvent(player, "onClientAddNotification", player, "By założyć gang potrzebujesz conajmniej 20 levela.", "error")
			return
		end 
		
		local playerGang = getElementData(player, "player:gang") or false
		if playerGang then 
			triggerClientEvent(player, "onClientAddNotification", player, "Znajdujesz się już w jakimś gangu.", "error")
			return
		end 
		
		local sp = getElementData(player, "player:sp") or 0 
		sp = sp-cost 
		if sp < 0 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie masz tyle diamentów!", "error")
			return
		end
		setElementData(player, "player:sp", sp)
		
		exports["ms-gangs"]:createDefaultGang("Gang "..getPlayerName(player), getElementData(player, "player:uid"), getPlayerName(player))
		exports["ms-gangs"]:loadPlayerGang(player)
		
		triggerClientEvent(player, "onClientAddNotification", player, "Twój własny gang został stworzony. Znajdziesz go pod komendą /gangs gdzie możesz go zedytować.\nZAPOZNAJ SIĘ Z REGULAMINEM GANGU NA FORUM.", "success", 15000)
	end
end
addEvent("onPlayerBuyGang", true)
addEventHandler("onPlayerBuyGang", root, onPlayerBuyGang)