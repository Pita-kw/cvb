--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: komendy administracyjne
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]


local mysql = exports["ms-database"]

local allowed_weapons = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[9] = true,
		[22] = true,
		[23] = true,
		[24] = true,
		[25] = true,
		[26] = true,
		[27] = true,
		[28] = true,
		[29] = true,
		[30] = true,
		[31] = true,
		[32] = true,
		[33] = true,
		[34] = true,
		[16] = true,
		[17] = true,
		[43] = true,
		[10] = true,
		[11] = true,
		[12] = true,
		[13] = true,
		[14] = true,
		[15] = true
	}

spawn_cars = {}

-- EVENT
event_players = {}
event_pos_x = 0
event_pos_y = 0
event_pos_z = 0
ev_tp = false

-----------------------------------------------------------------------------------------
-- KOMENDY
-----------------------------------------------------------------------------------------


function tp(player, cmd, arg1, arg2, arg3, arg4, arg5)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/tpto (id gracza)", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local x,y,z = getElementPosition(v)
			local i = getElementInterior(v)
			local dim = getElementDimension(v)	
			setElementInterior(player, i)
			setElementDimension(player, dim)
			setElementPosition(player, x+5,y,z)
			triggerClientEvent(player, "onClientAddNotification", player, "Przeteleprtowałes się do gracza.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, ""..getPlayerName(player).." teleportował się do ciebie.", "info")
			return 
		end
	end 
end 
addCommandHandler("tpto", tp)

function clearChat(player, cmd)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end
	
	for i=0, 50 do 
		outputChatBox(" ")
	end
	outputChatBox("Czat został wyczyszczony przez administrację!")
end
addCommandHandler("cc", clearChat)

function tpp(player, cmd, arg1, arg2, arg3, arg4, arg5)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/tpplayer (id gracza)", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local x,y,z = getElementPosition(player)
			local i = getElementInterior(player)
			local dim = getElementDimension(player)	
			setElementInterior(v, i)
			setElementDimension(v, dim)
			setElementPosition(v, x,y,z+1)
			triggerClientEvent(player, "onClientAddNotification", player, "Przeteleprtowałes do siebie gracza.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, getPlayerName(player).." teleportował ciebie.", "info")
			return 
		end
	end 
end 
addCommandHandler("tpp", tpp)

function heal(player, cmd, arg1)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/heal (id gracza)", "info")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementHealth(v, 100)
			triggerClientEvent(player, "onClientAddNotification", player, "Gracz uleczony.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, "Administrator "..getPlayerName(player).." uleczył cię.", "info")
			gameView_add("[LOG]".. getPlayerName(player).." uleczył gracza ".. getPlayerName(v) .."")
			logAdd("heal", getElementData(player, "player:uid"), "Uleczył gracza ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..")")
			return 
		end
	end 
end 
addCommandHandler("heal", heal)

function checkGod(player, cmd, arg1)	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/checkgod (id gracza)", "info")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			if getElementData(v, "player:god") then
				triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz posiada godmode ze strony serwera.", "info")
			else
				if getElementData(v, "player:zone") == "antydm" then
					triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz przebywa w strefie anty dm dlatego jest nieśmiertelny.", "info")
				else
					triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz nie ma godmode ze strony serwera.", "info")
				end
			end
			return 
		end
	end 
end 
addCommandHandler("checkgod", checkGod)


function givePlayerGod(player, cmd, arg1)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/god (id gracza)", "info")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementData(v, "player:god", true)
			setElementData(v, "god:source", "Komenda administracyjna")
			triggerClientEvent(player, "onClientAddNotification", player, "Dałeś graczowi ".. getPlayerName(v) .." goda.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, "Administrator "..getPlayerName(player).." dał ci goda", "info")
			gameView_add("[LOG]".. getPlayerName(player).." dał goda graczowi ".. getPlayerName(v) .."")
			logAdd("god", getElementData(player, "player:uid"), "Dał goda graczowi ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..")")
			return 
		end
	end 
end 
addCommandHandler("god", givePlayerGod)


function takePlayerGod(player, cmd, arg1)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/ungod (id gracza)", "info")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementData(v, "player:god", false)
			setElementData(v, "god:source", false)
			triggerClientEvent(player, "onClientAddNotification", player, "Zabrałeś graczowi ".. getPlayerName(v) .." goda.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, "Administrator "..getPlayerName(player).." zabrał ci goda", "info")
			gameView_add("[LOG]".. getPlayerName(player).." zabrał goda graczowi ".. getPlayerName(v) .."")
			logAdd("god", getElementData(player, "player:uid"), "Zabrał goda graczowi ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..")")
			return 
		end
	end 
end 
addCommandHandler("ungod", takePlayerGod)


function givePlayerGun(player, cmd, arg1, arg2, arg3)

	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 or not arg3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/givegun (id gracza, id broni, ammo)", "info")
		return 
	end 
	
	
	if not allowed_weapons[tonumber(arg2)] == true then
		triggerClientEvent(player, "onClientAddNotification", player, "Nie znaleziono podanej broni lub jest ona zablokowana!", "error")
		return
	end
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementHealth(v, 100)
			giveWeapon(v, tonumber(arg2), tonumber(arg3), true)
			triggerClientEvent(player, "onClientAddNotification", player, "Dałes graczowi ".. getPlayerName(v) .." broń pomyślnie.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, "Administrator "..getPlayerName(player).." dał ci broń.", "info")
			gameView_add("[LOG]".. getPlayerName(player).." dał graczowi ".. getPlayerName(v) .." broń o id ".. arg2 .."")
			logAdd("givegun", getElementData(player, "player:uid"), "Dał broń graczowi ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..") broń o id ".. arg2 .."")
			return 
		end
	end 
end 
addCommandHandler("givegun", givePlayerGun)


function disarmPlayer(player, cmd, arg1)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/disarm (id gracza)", "info")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			takeAllWeapons(v)
			triggerClientEvent(player, "onClientAddNotification", player, "Gracz rozbrojony.", "info")
			triggerClientEvent(v, "onClientAddNotification", v, ""..getPlayerName(player).." rozbroił cię.", "info")
			return 
		end
	end 
end 
addCommandHandler("disarm", disarmPlayer)


function postp(player, cmd, arg1, arg2, arg3)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 or not arg3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/postp (x,y,z)", "error")
		return 
	end 
	
	setElementPosition(player, tonumber(arg1), tonumber(arg2), tonumber(arg3))
	triggerClientEvent(player, "onClientAddNotification", player, "Trwa teleportowanie", "info")
end 
addCommandHandler("postp", postp)

function giveexp(player, cmd, arg1, arg2, arg3)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 

	if not arg1 or not arg2 or not arg3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/giveexp (id gracza, ilość, powod)", "error")
		return 
	end 
	
	if tonumber(arg2) > 50 and getElementData(player, "player:rank") ~= 3 then
		triggerClientEvent(player, "onClientAddNotification", player, "Limit expa który możesz dać wynosi 50", "error")
		return
	end
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local mp = getElementData(v, 'player:exp') or 0
			exports["ms-gameplay"]:msGiveExp(v, tonumber(arg2))
			triggerClientEvent(player, "onClientAddNotification", player, "Dałeś ".. arg2 .." exp graczowi ".. getPlayerName(v) .." za ".. tostring(arg3) .." ", "info")
			triggerClientEvent(v, "onClientAddNotification", v, "Otrzymałeś ".. arg2 .." exp od "..getPlayerName(player).." za ".. tostring(arg3) .." ", "info")
			gameView_add("[LOG]:"..getPlayerName(player).." dał graczowi ".. getPlayerName(v) .." ".. arg2 .." exp za ".. arg3 .."")
			logAdd("exp", getElementData(player, "player:uid"), "Dał graczowi ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..") ".. arg2 .." exp za ".. arg3 .."")
			return 
		end 
	end 
	
end
addCommandHandler("giveexp", giveexp)

-- Urywa stringa, nie działa komenda jak się nie jest zalogowanym na admina tego od mta
function penaltyMessage(player, message)
	triggerClientEvent(player, "onClientAddNotification", player, message, {type="error", custom="image", x=0, y=0, w=40, h=40, image=":ms-admin/penalty.png"}, 20000, false)
end 

function kick(player, cmd, arg1, ...)

	local player_name

	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/kick <id gracza> <powód>", "error")
		return 
	end 
	
	local powod = table.concat ( {...}, " " )
	
	if #powod == 0 then
			triggerClientEvent(player, "onClientAddNotification", player, "Nie wpisałeś powodu!", "error")
			return
	end
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			triggerClientEvent(player, "onClientAddNotification", player, "Wyrzuciłeś gracza ".. getPlayerName(v) .." ", "info")
			player_name = getPlayerName(v)
			setTimer ( function()
				kickPlayer(v, powod)
			end, 5000, 1 )
			gameView_add("[LOG]:"..getPlayerName(player).." wyrzucił gracza ".. player_name .." za ".. powod .."")
			logAdd("kick", getElementData(player, "player:uid"), "Wyrzucił gracza ".. player_name .."(".. getElementData(v, "player:uid") ..") za ".. powod .."")
			local gracze = getElementsByType("player")
			
			for k,v in ipairs(gracze) do
				if getElementData(v, "player:spawned") == true then
					penaltyMessage(v, "Gracz " .. player_name .." został wyrzucony przez ".. getPlayerName(player) .." za ".. powod .."")
				end
			end
			return 
		end
	end 
end
addCommandHandler("akick", kick) 


function mutePlayer(player, cmd, arg1, arg2,  ...)

	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 and not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/mute <id gracza> <czas w minutach> <powód>", "error")
		return 
	end 
	
	local powod = table.concat ( {...}, " " )
	
	if #powod == 0 then
			triggerClientEvent(player, "onClientAddNotification", player, "Nie wpisałeś powodu!", "error")
			return
	end	
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 

			
			if getElementData(v, 'player:blockChat') > 0 then
				triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz jest już uciszony.", "warning")
				return
			end
			
			
			triggerClientEvent(player, "onClientAddNotification", player, "Dałeś mute graczowi ".. getPlayerName(v) .." na czas ".. arg2 .." minut. ", "info")
			local player_name = getPlayerName(v)
			
			gameView_add("[LOG]:"..getPlayerName(player).." dał mute graczowi ".. player_name .." za ".. powod .."")
			logAdd("mute", getElementData(player, "player:uid"), "Dał mute graczowi ".. player_name .."(".. getElementData(v, "player:uid") ..") za ".. powod .." na czas ".. arg2 .." minut")
			
			setElementData(v, 'player:blockChat', arg2 * 60000)
			
			for k,v in ipairs(getElementsByType("player")) do
				if getElementData(v, "player:spawned") == true then
					penaltyMessage(v, "Gracz " .. player_name .." został uciszony przez ".. getPlayerName(player) .." za ".. powod .." na czas ".. arg2 .." minut")
				end
			end
			return 
		end
	end 
end
addCommandHandler("amute", mutePlayer) 

function unmutePlayer(player, cmd, arg1)
			
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 and not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/unmute <id gracza>", "error")
		return 
	end 
	
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
		
			if getElementData(v, 'player:blockChat') == 0 then
				triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz nie jest uciszony.", "warning")
				return
			end

			setElementData(v, 'player:blockChat', 0)
			triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." ściągnął ci mute", "info")
			
			triggerClientEvent(player, "onClientAddNotification", player, "Ściągnąłeś mute graczowi ".. getPlayerName(v) .."", "info")
			local player_name = getPlayerName(v)
			
			gameView_add("[LOG]:"..getPlayerName(player).." ściągnął mute graczowi".. player_name .."")
			logAdd("mute", getElementData(player, "player:uid"), "Ściągnął mute graoczwi ".. player_name .."(".. getElementData(v, "player:uid") ..")")
			return 
		end
	end 
end
addCommandHandler("aunmute", unmutePlayer) 


-- BANY 
local gWeekDays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
function formatDate(format, escaper, timestamp)
	escaper = (escaper or "'"):sub(1, 1)
	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false
 
	time.year = time.year + 1900
	time.month = time.month + 1
 
	local datetime = { d = ("%02d"):format(time.monthday), h = ("%02d"):format(time.hour), i = ("%02d"):format(time.minute), m = ("%02d"):format(time.month), s = ("%02d"):format(time.second), w = gWeekDays[time.weekday+1]:sub(1, 2), W = gWeekDays[time.weekday+1], y = tostring(time.year):sub(-2), Y = time.year }
 
	for char in format:gmatch(".") do
		if (char == escaper) then escaped = not escaped
		else formattedDate = formattedDate..(not escaped and datetime[char] or char) end
	end
 
	return formattedDate
end

function banMSPlayer(player, byWho, time, reason)
	if not player or not byWho or not time or not reason then return end 
	time = time+getRealTime().timestamp 
	
	local ip = getPlayerIP(player)
	local serial = getPlayerSerial(player)
	
	local wUID = -1
	if isElement(byWho) then 
		wUID = getElementData(byWho, "player:uid")
		byWho = getPlayerName(byWho)
	else 
		byWho = "System"
	end
	
	mysql:query("INSERT INTO `ms_bans` VALUES (?, ?, ?, ?, ?, ?, ?, ?)", nil, getElementData(player, "player:uid") or -1, wUID, serial, ip, nil, time, reason)
	mysql:query("UPDATE `ms_accounts` SET `banned`=? WHERE `id`=?", 1, getElementData(player, "player:uid") or -1)
	
	gameView_add("[LOG]:"..byWho.." zbanował gracza".. getPlayerName(player) .." za ".. reason .."")
	logAdd("ban", wUID, "Zbanował gracza ".. getPlayerName(player) .."(".. getElementData(player, "player:uid") ..") za ".. reason .."")
	
	outputConsole("-----------------------------", player)
	outputConsole("Powód bana: "..reason, player)
	outputConsole("Wystawiający: "..byWho, player)
	outputConsole("Data otrzymania bana: "..formatDate("d/m/y h:i", "'", getRealTime().timestamp), player) 
	outputConsole("Kończy się: "..formatDate("d/m/y h:i", "'", time), player)
	outputConsole("-----------------------------", player)

	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "player:spawned") == true then
			penaltyMessage(v, ""..getPlayerName(player).." zostaje zbanowany przez "..byWho.." do dnia "..formatDate("d/m/y", "'", time)..". Powód: "..reason)
		end
	end
	kickPlayer(player, "Zostałeś zbanowany. Zobacz konsolę F8 lub ~")
end 


function ban(player, cmd, arg1, arg2, arg3, ...)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end
	
	local powod = table.concat ( {...}, " " )
	if not arg1 or not arg2 or not arg3 or #powod == 0 or tonumber(arg2) < -1 or tonumber(arg1) < -1 or tonumber(arg2) == nil or (arg3 ~= "d" and arg3 ~= "m" and arg3 ~= "y") then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/ban <id gracza> <czas> <d/m/y> <powód>", "error")
		return 
	end
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local t = tonumber(arg2) 
			if arg3 == "d" then 
				t = ((t*24)*60)*60
			elseif arg3 == "m" then 
				t = (((t*30)*24)*60)*60
			elseif arg3 == "y" then 
				t = (((t*365)*24)*60)*60
			end 
			
			triggerClientEvent(player, "onClientAddNotification", player, "Zbanowałeś gracza ".. getPlayerName(v) .." do "..formatDate("d/m/y h:i", "'", t).." z powodu "..powod, "info")
			banMSPlayer(v, player, t, powod)
			return 
		end
	end
end
addCommandHandler("aban", ban)

function admins(player, cmd)
	local str1, str2, str3, str4 = "brak", "brak", "brak", "brak"
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:rank") == 3 then 
			if #str1 > 4 then 
				str1 = str1..", ["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			else 
				str1 = "["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			end 
		elseif getElementData(v, "player:rank") == 2 then 
				if #str2 > 4 then 
				str2 = str2..", ["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			else 
				str2 = "["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			end 
		elseif getElementData(v, "player:rank") == 1 then 
				if #str3 > 4 then 
				str3 = str3..", ["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			else 
				str3 = "["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			end 
		elseif getElementData(v, "player:rank") == 1 then 
			if #str4 > 4 then 
				str4 = str4..", ["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			else 
				str4 = "["..tostring(getElementData(v, "player:id")).."] "..getPlayerName(v)
			end 
		end 
	end
	
	outputChatBox("Zarząd:"..str1, player, 170, 0, 20)
	outputChatBox("Administracja:"..str2, player, 255, 0, 51)
	outputChatBox("Moderatorzy:"..str3, player, 0, 204, 0)
end 
addCommandHandler("admins", admins)

function inv(player, cmd)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not getElementData(player, "player:invisible") then 
		setElementAlpha(player, 0)
		setElementData(player, "player:invisible", true)
	else 
		setElementAlpha(player, 255)
		setElementData(player, "player:invisible", false)
	end 
end 
addCommandHandler("inv", inv)


function spec(player, cmd, arg1)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/spec <id gracza>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setCameraTarget(player, v)
			setElementFrozen(player, true)
			setElementDimension(player, getElementDimension(v))
		end
	end
end 
addCommandHandler("spec", spec)

function setPlayerSkin(player, cmd, arg1, arg2)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/setskin <id gracza> <id skinu>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementModel(v, arg2)
			triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." zmienił ci skin", "info")
			gameView_add("[LOG]".. getPlayerName(player).." zmienił skin graczowi ".. getPlayerName(v) .."")
		end
	end
end 
addCommandHandler("setskin", setPlayerSkin)

function getPlayerAdress(player, cmd, arg1)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/getip <id gracza>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local ip_adress = getPlayerIP(v)
			outputChatBox(ip_adress, player)
		end
	end
end 
addCommandHandler("getip", getPlayerAdress)


function getPlayerKeyAdress(player, cmd, arg1)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/getserial <id gracza>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local serial = getPlayerSerial(v)
			outputChatBox(serial, player)
		end
	end
end 
addCommandHandler("getserial", getPlayerKeyAdress)

function givePlayersHealth(player, cmd, arg1)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj:\n/health-ex [dystans]", "error")
		return
	end

	if tonumber(arg1) > 200 then
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalny dystans uleczenia graczy wynosi 200", "error")
		return
	end
	
	local players_count = 0
	
	for k,v in pairs(getElementsByType("player")) do 
		local ax,ay,az = getElementPosition(player)
		local px,py,pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints2D(ax,ay,px,py)
			
		if distance < tonumber(arg1) and distance ~= 0 then
			setElementHealth(v, 100)
			if distance ~= 0 then
				triggerClientEvent(v, "onClientAddNotification", player, "".. getPlayerName(player) .." uleczył graczy w odległości ".. arg1 .."m (w tym także Ciebie)", "success")
			end
			players_count = players_count + 1
		end
	end
	
	if players_count == 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "W pobliżu nie ma żadnych graczy", "error")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Uleczyłeś ".. players_count .." graczy", "success")
		gameView_add("[LOG]".. getPlayerName(player).." uleczył graczy w odległości ".. tonumber(arg1) .."m")
		logAdd("health", getElementData(player, "player:uid"), "Uleczył graczy w odległości ".. tonumber(arg1) .."")
	end
end 
addCommandHandler("health-ex", givePlayersHealth)

local expex_lastUse = 0
function givePlayersExp(player, cmd, arg1, arg2)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 then
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj:\n/exp-ex [dystans] [exp]", "error")
		return
	end
	
	if tonumber(arg1) > 200 then
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalny dystans wynosi 200", "error")
		return
	end
	
	if tonumber(arg2) > 50 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalny exp może wynosić 50", "error")
		return
	end 
	
	if getElementData(player, "player:rank") < 3 then 
		if expex_lastUse > getTickCount() then 
			triggerClientEvent(player, "onClientAddNotification", player, "Możesz używać tej funkcji raz na godzinę.", "error")
			return
		end
	end 
	
	local players_count = 0
	
	for k,v in pairs(getElementsByType("player")) do 
		local ax,ay,az = getElementPosition(player)
		local px,py,pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints2D(ax,ay,px,py)
			
		if distance < tonumber(arg1) and distance ~= 0 then
			exports["ms-gameplay"]:msGiveExp(v, tonumber(arg2))
			triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." dał ".. arg2 .."exp graczom w odległości ".. arg1 .."m (w tym także Tobie)", "success")
			players_count = players_count + 1
		end
	end
	
	if players_count == 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "W pobliżu nie ma żadnych graczy", "error")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Exp otrzymało ".. players_count .." graczy", "success")
	end
	
	expex_lastUse = getTickCount()+(60000*60)
	gameView_add("[EXP-EX] "..getPlayerName(player).." dał "..arg2.." exp graczom w odległości "..arg1.." m.")
	outputServerLog("[EXP-EX] "..getPlayerName(player).." dał "..arg2.." exp graczom w odległości "..arg1.." m.")
end 
addCommandHandler("exp-ex", givePlayersExp)

local moneyex_lastUse = 0
function givePlayersMoney(player, cmd, arg1, arg2)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 then
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj:\n/money-ex [dystans] [kasa]", "error")
		return
	end

	if tonumber(arg1) > 200 then
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalny dystans wynosi 200.", "error")
		return
	end
	
	if tonumber(arg2) > 15000 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalna kwota wynosi 15000$.", "error")
		return
	end
	
	if getElementData(player, "player:rank") < 3 then 
		if moneyex_lastUse > getTickCount() then 
			triggerClientEvent(player, "onClientAddNotification", player, "Możesz używać tej funkcji raz na godzinę.", "error")
			return
		end
	end 
	
	local players_count = 0
	
	for k,v in pairs(getElementsByType("player")) do 
		local ax,ay,az = getElementPosition(player)
		local px,py,pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints2D(ax,ay,px,py)
			
		if distance < tonumber(arg1) and distance ~= 0 then
			exports["ms-gameplay"]:msGiveMoney(v, tonumber(arg2))
			triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." dał ".. arg2 .."$ graczom w odległości ".. arg1 .."m (w tym także Tobie)", "success")
			players_count = players_count + 1
		end
	end
	
	if players_count == 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "W pobliżu nie ma żadnych graczy", "error")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Kase otrzymało ".. players_count .." graczy", "success")
	end
	
	moneyex_lastUse = getTickCount()+(60000*60)
	gameView_add("[MONEY-EX] "..getPlayerName(player).." dał "..arg2.." kasy graczom w odległości "..arg1.." m.")
	outputServerLog("[MONEY-EX] "..getPlayerName(player).." dał "..arg2.." kasy graczom w odległości "..arg1.." m.")
end 
addCommandHandler("money-ex", givePlayersMoney)

function removePlayersWeapons(player, cmd, arg1)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj:\n/disarm-ex [dystans]", "error")
		return
	end

	if tonumber(arg1) > 200 then
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalny dystans rozbrojenia graczy wynosi 200", "error")
		return
	end
	
	local players_count = 0
	
	for k,v in pairs(getElementsByType("player")) do 
		local ax,ay,az = getElementPosition(player)
		local px,py,pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints2D(ax,ay,px,py)
			
		if distance < tonumber(arg1) and distance ~= 0 then
			takeAllWeapons(v)
			if distance ~= 0 then
				triggerClientEvent(v, "onClientAddNotification", player, "".. getPlayerName(player) .." rozbroił graczy w odległości ".. arg1 .."m (w tym także Ciebie)", "success")
			end
			players_count = players_count + 1
		end
	end
	
	if players_count == 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "W pobliżu nie ma żadnych graczy", "error")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Rozbroiłeś ".. players_count .." graczy", "success")
	end
end 
addCommandHandler("disarm-ex", removePlayersWeapons)

function givePlayersWeapons(player, cmd, arg1, arg2, arg3)
	if getElementData(player, "player:rank") < 3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 or not arg3 then
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj:\n/givegun-ex [dystans, id broni, ammo]", "error")
		return
	end
	
	if not allowed_weapons[tonumber(arg2)] == true then
		triggerClientEvent(player, "onClientAddNotification", player, "Podana broń jest nieprawidłowa lub zablokowana!", "error")
		return
	end

	if tonumber(arg1) > 200 then
		triggerClientEvent(player, "onClientAddNotification", player, "Maksymalny dystans rozbrojenia graczy wynosi 200", "error")
		return
	end
	
	local players_count = 0
	
	for k,v in pairs(getElementsByType("player")) do 
		local ax,ay,az = getElementPosition(player)
		local px,py,pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints2D(ax,ay,px,py)
			
		if distance < tonumber(arg1) and distance ~= 0 then
			giveWeapon(v, tonumber(arg2), tonumber(arg3), true)
			if distance ~= 0 then
				triggerClientEvent(v, "onClientAddNotification", player, "".. getPlayerName(player) .." dał graczom broń w odległości ".. arg1 .."m (w tym także Tobie)", "success")
			end
			players_count = players_count + 1
		end
	end
	
	
	if players_count == 0 then
		triggerClientEvent(player, "onClientAddNotification", player, "W pobliżu nie ma żadnych graczy", "error")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Dałeś borń ".. players_count .." graczom", "success")
		gameView_add("[LOG]".. getPlayerName(player).." dał broń graczom w odległości ".. tonumber(arg1) .."m broń o id ".. tonumber(arg2) .."")
		logAdd("givegun", getElementData(player, "player:uid"), "Dał broń graczom w odległości ".. tonumber(arg1) .." broń o id ".. tonumber(arg2) .."")
	end
end 
addCommandHandler("givegun-ex", givePlayersWeapons)

function setPlayerInterior(player, cmd, arg1, arg2)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/setint <id gracza> <id interioru>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementInterior(v, arg2)
			triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." zmienił ci interior", "info")
		end
	end
end 
addCommandHandler("setint", setPlayerInterior)


function setPlayerWorld(player, cmd, arg1, arg2)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/setworld <id gracza> <id interioru>", "error")
		triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." zmienił ci świat", "info")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			setElementDimension(v, arg2)
		end
	end
end 
addCommandHandler("setworld", setPlayerWorld)


function givemoney(player, cmd, arg1, arg2, arg3)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 or not arg2 or not arg3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/givecash <id gracza> <kasa> <powod>", "error")
		return 
	end 
	
	if tonumber(arg2) > 1500 and getElementData(player, "player:rank") ~= 3 then
		triggerClientEvent(player, "onClientAddNotification", player, "Limit pieniędzy który możesz dać wynosi 1500$", "error")
		return
	end

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			exports["ms-gameplay"]:msGiveMoney(v, tonumber(arg2))
			triggerClientEvent(v, "onClientAddNotification", v, "".. getPlayerName(player) .." dał ci ".. arg2 .."$ za ".. arg3 .."", "info")
			triggerClientEvent(player, "onClientAddNotification", player, "Gracz ".. getPlayerName(v) .." otrzymał od ciebie ".. arg2 .."$ z powodu ".. arg3 .." ", "success")
			gameView_add("[LOG]:"..getPlayerName(player).." dał graczowi ".. getPlayerName(v) .." ".. arg2 .."$ za ".. arg3 .."")
			logAdd("money", getElementData(player, "player:uid"), "Dał graczowi ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..") ".. arg2 .."$ za ".. arg3 .."")
		end
	end
end 
addCommandHandler("givecash", givemoney) 

function unspec(player, cmd)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	setCameraTarget(player, player)
	setElementFrozen(player, false)
	setElementDimension(player, 0)
end 
addCommandHandler("unspec", unspec)

function aj(player, cmd, arg1, arg2, ...)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	local msg = table.concat ( {...}, " " )
	if not arg1 or not arg2 or tonumber(arg2) <= 0 or #msg == 0 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/aj <id gracza> <czas w minutach> <powód>", "error")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			if isPedInVehicle(v) then 
				removePedFromVehicle(v) 
			end 
			local player_name = getPlayerName(v)
			setElementData(v, "player:aj", tonumber(arg2)*60)
			triggerClientEvent(player, "onClientAddNotification", player, "Gracz "..getPlayerName(v).." został przeniesiony do AJ na "..tostring(arg2).." minut.", "success")
			triggerClientEvent(v, "onClientAddNotification", v, "Zostałeś przeniesiony do AJ przez "..getPlayerName(player)..".\nPowód: "..msg, "info")
			gameView_add("[LOG]:"..getPlayerName(player).." uwięził gracza ".. getPlayerName(v) .." na czas ".. arg2 .." minut za ".. msg .."")
			logAdd("jail", getElementData(player, "player:uid"), "Uwięził gracza ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..") na czas ".. arg2 .." minut za ".. msg .."")
			for k,v in ipairs(getElementsByType("player")) do
				if getElementData(v, "player:spawned") == true then
					penaltyMessage(v, ""..player_name.." zostaje uwięziony przez "..getPlayerName(player).." na czas ".. arg2 .." minut za "..  msg.." ")
				end
			end
			return 
		end
	end
end 
addCommandHandler("aj", aj)

function unaj(player, cmd, arg1)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/unaj <id gracza>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) and getElementData(v, "player:aj") then 
			setElementData(v, "player:aj", 0)
			triggerClientEvent(player, "onClientAddNotification", player, "Zdjęto AJ graczowi "..getPlayerName(v)..".", "success") 
			gameView_add("[LOG]:"..getPlayerName(player).." wypuścił gracza ".. getPlayerName(v) .." z więzienia")
			logAdd("unjail", getElementData(player, "player:uid"), "Wypuścił gracza ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..") za więzienia")
			return 
		end
	end
end 
addCommandHandler("unaj", unaj)

function warn(player, cmd, arg1, ...)
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	local msg = table.concat ( {...}, " " )
	if not arg1 or #msg == 0 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/warn <id gracza> <powód>", "error")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		local uid = getElementData(v, "player:uid")  
		if getElementData(v, "player:id") == tonumber(arg1) and uid then 
			local warns = mysql:getSingleRow("SELECT `warns` FROM `ms_accounts` WHERE `id`=?", uid)
			local player_name = getPlayerName(v)
			warns = warns["warns"]
			if warns == 5 then warns = 0 end 
			
			warns = warns+1 
			
			if warns == 5 then 
				banMSPlayer(v, player, (60*60)*72, "Ban na 3 dni za ostrzeżenia")
				warns = 0 
			end
			
			setElementData(v, "player:warns", warns)
			mysql:query("UPDATE `ms_accounts` SET `warns`=? WHERE `id`=?", warns, uid)
			
			if warns ~= 0 then 
				for k,v in ipairs(getElementsByType("player")) do
					if getElementData(v, "player:spawned") == true then
						penaltyMessage(v, ""..player_name.." ostrzymuje ostrzeżenie od  "..getPlayerName(player).." za "..  msg.." ")
					end
				end
			end 
			
			triggerClientEvent(v, "onClientAddNotification", v, "Otrzymałeś ostrzeżenie od "..getPlayerName(player)..".\nPowód: "..tostring(msg), "info")
			triggerClientEvent(player, "onClientAddNotification", player, "Wręczyłeś ostrzeżenie graczowi "..getPlayerName(player))
			
			gameView_add("[LOG]:"..getPlayerName(player).." ostrzegł gracza ".. getPlayerName(v) .." za ".. tostring(msg) .."")
			logAdd("warn", getElementData(player, "player:uid"), "Ostrzegł gracza ".. getPlayerName(v) .."(".. getElementData(v, "player:uid") ..") za ".. tostring(msg) .."")
			return 
		end
	end
end  
addCommandHandler("warn", warn)



function setPlayerDIM(player, cmd, dim)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	if dim then
		triggerClientEvent(player, "onClientAddNotification", player, "Ustawiłeś sobie dimenstion na ".. dim .."", "info")
		setElementDimension(player, dim)
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj /dim id", "error")
	end
end
addCommandHandler("dim", setPlayerDIM)

function setPlayerINT(player, cmd, int)
	if getElementData(player, "player:rank") < 2 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	if int then
		triggerClientEvent(player, "onClientAddNotification", player, "Ustawiłeś sobie interior na ".. int .."", "info")
		setElementInterior(player, int)
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj /int id", "error")
	end
end
addCommandHandler("int", setPlayerINT)



function giveRewardForBag(hit, match)
	if hit == dropped_cash  then
		if source ~= source then
			triggerClientEvent(source, "onClientAddNotification", source, "Nie możesz podnieść torby którą sam położyłeś!", "error") 
			return
		else
			exports["ms-gameplay"]:msGiveMoney(source, money_bag)
			exports["ms-gameplay"]:msGiveExp(source, math.floor(money_bag/100))
			
			if getElementData(source, "player:premium") then
				triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(source).." znalazł torbę i otrzymuje ".. math.floor(money_bag + money_bag * 0.3) .."$ oraz ".. math.floor(money_bag/100 + money_bag/100 * 0.3) .." exp!", {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-admin/bag.png"}, 10000) 
			else
				triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(source).." znalazł torbę i otrzymuje ".. money_bag .."$ oraz ".. math.floor(money_bag/100) .." exp", {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-admin/bag.png"}) 
			end
			
			if isElement(dropped_cash) then destroyElement(dropped_cash) end
			removeEventHandler("onPlayerPickupHit", getRootElement(), giveRewardForBag)
			money_bag = nil
			put_by = nil
		end
	end
end

local lastDroppedCash = 0
function dropCashFunction(player, cmd, reward, ...)
	local prompt = table.concat ( {...}, " " )
	-- warunki
	
	if getElementData(player, "player:rank") < 1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error") 
		return 
	end 
	
	if isElement(dropped_cash) then 
		removeEventHandler("onPlayerPickupHit", getRootElement(), giveRewardForBag)
		destroyElement(dropped_cash) 	
		triggerClientEvent(player, "onClientAddNotification", player, "Torba została usunięta!", "success") 
		return 
	end
	
	if getTickCount() < lastDroppedCash+60000*15 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Możesz kłaść walizki raz na 15 minut!", "error") 
		return 
	end 
	
	if not reward or #prompt == 0 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie wpisałeś nagrody lub podpowiedzi!", "error") 
		return 
	end
	
	if tonumber(reward) > 7500 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Przekroczyłeś limit nagrody która wynosi 7500!", "error") 
		return 
	end
	
	
	local x,y,z = getElementPosition(player)
	
	-- globalne zmienne
	dropped_cash = createPickup(x+3, y, z, 3, 1550, 500)
	money_bag = reward
	put_by = player
	lastDroppedCash = getTickCount()
	
	triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(player).." upuścił torbę z pieniędzmi! Podpowiedź: "..prompt, {type="info", custom="image", x=0, y=0, w=40, h=40, image=":ms-admin/bag.png"}, 60000)
	addEventHandler("onPlayerPickupHit", getRootElement(), giveRewardForBag)
	
	outputServerLog("[WALIZKA] Administrator "..getPlayerName(player).." zrzucił walizkę o wartości $"..tostring(reward))
	logAdd("walizka", getElementData(player, "player:uid"), "zrzucił walizkę o wartości $"..tostring(reward))
end
addCommandHandler("walizka", dropCashFunction)


-- events
function onPlayerJoin()
	local ip = getPlayerIP(source)
	local serial = getPlayerSerial(source)
	
	local query = mysql:getRows("SELECT * FROM `ms_bans` WHERE `ip`=? OR `serial`=? LIMIT 1", ip, serial)
	if #query > 0 then 
		local reason = query[1]["reason"]
		local time = query[1]["date_to"]
		if getRealTime().timestamp > time then 
			mysql:query("DELETE FROM `ms_bans` WHERE `id`=?", query[1]["id"])
			mysql:query("UPDATE `ms_accounts` SET `banned`=? WHERE `id`=?", 0, query[1]["accountid"])
			return 
		end 
		
		local got = query[1]["date_from"]
		local byWho = query[1]["bannedby"]
		byWho = mysql:getRows("SELECT `login` FROM `ms_accounts` WHERE `id`=?", byWho)[1]
		byWho = byWho["login"]
		
		outputConsole("-----------------------------", source)
		outputConsole("Powód bana: "..reason, source)
		outputConsole("Wystawiający: "..byWho, source)
		outputConsole("Data otrzymania bana: "..got, source)
		outputConsole("Kończy się: "..formatDate("d/m/y h:i", "'", time), source)
		outputConsole("-----------------------------", source)
		
		setTimer(kickPlayer, 10000, 1, source, "Zostałeś zbanowany. Zobacz konsolę F8 lub ~")
	end 
end 
addEventHandler("onPlayerJoin", root, onPlayerJoin)

function onLogin(prev, curr)
	local rank = getElementData(source, "player:rank") or 0 
	outputDebugString(getAccountName(curr))
	if getAccountName(curr) == "dev" or getAccountName(curr) == "dev2" or getAccountName(curr) == "dev3" then 
		if rank ~= 3 then 
			cancelEvent()
		end 
	end 
end
addEventHandler("onPlayerLogin", root, onLogin)

function onRegister(cmd)
	if cmd == "register" then 
		cancelEvent()
	end
end 
addEventHandler("onPlayerCommand", root, onRegister)

function onVehicleEnter(player, seat)
	if player and seat == 0 then 
		setElementData(source, "vehicle:lastDriver", getPlayerName(player))
	end 
end 
addEventHandler("onVehicleEnter", root, onVehicleEnter)



function jebuduBazooka(player, cmd, arg1)
	if getElementData(player, "player:rank") < 3 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Brak uprawnień", "error")
		return 
	end 
	
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/jebudu <id gracza>", "error")
		return 
	end 

	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local x,y,z = getElementPosition(v)
			createExplosion(x,y,z, 2, v)
			return 
		end
	end
end 
addCommandHandler("jebudu", jebuduBazooka)


function destroyVehicleOrRespawn(vehicle, type)
	if vehicle then
		if type == "unspawn" then
			local id = getElementData(vehicle, "vehicle:id")
			exports["ms-vehicles"]:unspawnVehicle(id)
		end
		
		if type == "respawn" then
			respawnVehicle(vehicle)
		end
		
		if type == "delete" then
			destroyElement(vehicle)
		end
	end
end
addEvent("destroyVehicleOrRespawn", true)
addEventHandler("destroyVehicleOrRespawn", root, destroyVehicleOrRespawn)
