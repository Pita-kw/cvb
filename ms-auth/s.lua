--[[
	MultiServer 
	Zasób: ms-auth/s.lua
	Opis: Logowanie / tworzenie kont.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local mysql = exports["ms-database"]
local nametagColors = 
{
	-- [ranga] = {r, g, b}
	[0] = {220, 220, 220},
	[1] = {46, 204, 113},
	[2] = {51, 102, 255},
	[3] = {231, 76, 60},
}

function onPlayerCreateAccount(login, password, email)
	if not client then return end 
	
	local accounts = mysql:getRows("SELECT * FROM `ms_accounts`")
	
	local mk = 0 
	
	for k,v in ipairs(accounts) do 
		if v["login"] == login:gsub("%s+", "") then 
			triggerClientEvent(client, "onClientAddNotification", client, "Ta nazwa jest już zajęta.", "error")
			return 
		end 
		
		if v["ip"] == getPlayerIP(client) or v["serial"] == getPlayerSerial(client) then 
			mk = mk+1 
		end 
	end 
	
	if mk == 2 then 
		triggerClientEvent(client, "onClientAddNotification", client, "Możesz posiadać maksymalnie 2 konta.", "error")
		return 
	end 
	
	local last_id = mysql:query("INSERT INTO `ms_accounts` (login, password, email, serial, ip, online) VALUES (?, ?, ?, ?, ?, ?)", login, sha256(md5(password)), email, getPlayerSerial(client), getPlayerIP(client), 1)
	mysql:query("INSERT INTO `ms_players` (accountid) VALUES (?)", last_id)

	setElementData(client, "player:uid", last_id)
	setElementData(client, "player:rank", 0)
	setElementData(client, "player:premium", false)
	setElementData(client, "player:registered", formatDate("Y-m-d h:i:s", "'", getRealTime().timestamp))
	setElementData(client, "player:sp", 0)
	
	restorePlayerNametagColor(client)
	
	setPlayerName(client, login)
	loadData(client) 
	
	triggerClientEvent(client, "onClientRegisterSuccess", client)
end 
addEvent("onPlayerCreateAccount", true)
addEventHandler("onPlayerCreateAccount", root, onPlayerCreateAccount) 

function onPlayerEnterAccount(login, password)
	if not client then return end 
	
	local accounts = mysql:getRows("SELECT * FROM `ms_accounts` WHERE `login`=?", login, sha256(md5(password)))
	if #accounts > 0 then 
		local acc = accounts[1] 
		if acc["password"] ~= sha256(md5(password)) then 
			triggerClientEvent(client, "onClientAddNotification", client, "Nieprawidłowe hasło.", "error")
			return 
		end 
		
		if acc["online"] == 1 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Ktoś jest zalogowany na to konto.", "error")
			return
		end 
		
		if acc["banned"] == 1 then 
			triggerClientEvent(client, "onClientAddNotification", client, "To konto jest zbanowane.", "error")
			return
		end 
		
		mysql:query("UPDATE `ms_accounts` SET `online`=1, `timestamp_last`=NOW() WHERE `id`=?", acc["id"])
		
		local premiumTimestamp = acc["premium"]
		local timestamp = getRealTime().timestamp 
		if premiumTimestamp > timestamp then 
			outputChatBox("Posiadasz konto premium ważne do "..formatDate("h:i d/m/y", "'", premiumTimestamp)..".", client)
			setElementData(client, "player:premium", premiumTimestamp)
		else 
			setElementData(client, "player:premium", false)
		end 
		
		setElementData(client, "player:uid", acc["id"])
		setElementData(client, "player:rank", acc["rank"])
		setElementData(client, "player:registered", acc["timestamp_registered"])
		setElementData(client, "player:sp", acc["sp"])
		setElementData(client, "player:warns", acc["warns"])
		
		restorePlayerNametagColor(client)
		
		setPlayerName(client, login)
		triggerClientEvent(client, "onClientLoginSuccess", client)
		loadData(client)
	else 
		triggerClientEvent(client, "onClientAddNotification", client, "Takie konto nie istnieje", "error")
	end 
end 
addEvent("onPlayerEnterAccount", true)
addEventHandler("onPlayerEnterAccount", root, onPlayerEnterAccount)

function enterGame(player)
	exports["ms-gameplay"]:ms_spawnPlayer(player)
end 
addEvent("onPlayerEnterGame", true)
addEventHandler("onPlayerEnterGame", root, enterGame)

function loadData(player)
	local uid = getElementData(player, "player:uid") or false 
	local query = mysql:getRows("SELECT * FROM `ms_players` WHERE `accountid`= ?", getElementData(player, "player:uid"))
	if not query or not query[1] then kickPlayer(player, "Błąd wczytywania danych. KOD: DNLFA") return end 
 	setElementData(player, "player:money", query[1]["money"])
	setElementData(player, "player:level", 999)
	setElementData(player, "player:totalEXP", 999999)
	setElementData(player, "player:exp", 0)
	setElementData(player, "player:money", 9999999)
	setElementData(player, "player:skin", query[1]["skin"])
	setElementData(player, "player:playtime", query[1]["playtime"])
	setElementData(player, 'player:blockChat', query[1]["mute"])
	setElementData(player, 'player:aj', query[1]["jail"])
	
	exports["ms-stats"]:loadPlayerStat(player)
	exports["ms-gangs"]:loadPlayerGang(player)
	triggerEvent("createSkullBlipForPlayer", player, player)
	triggerClientEvent(player, "onPlayerLoadShaders", player, query[1]["shaders"])
end

function savePlayer(player)
	local uid = getElementData(player, "player:uid") or false 
	if uid then 
		local sp = getElementData(player, "player:sp") or 0 
		local money = getElementData(player, "player:money") or 0
		local exp = getElementData(player, "player:exp") or 0 
		local level = getElementData(player, "player:level") or 1 
		local totalexp = getElementData(player, "player:totalEXP") or 0 
		
		local sky = getElementData(player, "player:shader_sky") or false
		local dof = getElementData(player, "player:shader_dof") or false
		local palette = getElementData(player, "player:shader_palette") or false
		local carpaint = getElementData(player, "player:shader_carpaint") or false
		local water = getElementData(player, "player:shader_water") or false
		local detail = getElementData(player, "player:shader_detail") or false
		local roadshine = getElementData(player, "player:shader_roadshine") or false
		local snow = getElementData(player, "player:shader_snow") or false
		local player_skin = getElementData(player, "player:skin") or 0
		local shaders = toJSON({sky, dof, palette, carpaint, water, detail, roadshine, snow})
	
		local playtime = getElementData(player, "player:playtime") or 0 
		
		local mute = getElementData(player, "player:blockChat") or 0
		local jail = getElementData(player, "player:aj") or 0
		
		mysql:query("UPDATE `ms_players` SET `money`=?,  `exp`=?, `totalexp`=?, `level`=?, `shaders`=?, `playtime`=?, `skin`=?, `mute`=?, `jail`=? WHERE `accountid`=?", money, exp, totalexp, level, shaders, playtime, player_skin, mute, jail, uid)
		mysql:query("UPDATE `ms_accounts` SET `sp`=? WHERE `id`=?", sp, uid)
	end 
end 

function saveData()
	for k,v in ipairs(getElementsByType("player")) do 
		savePlayer(v)
	end
end 
setTimer(saveData, 10000, 0)

addEventHandler("onPlayerQuit", root, function() 
	savePlayer(source)
	
	local uid = getElementData(source, "player:uid") or false 
	if uid then 
		mysql:query("UPDATE `ms_accounts` SET `online`=0 WHERE `id`=?", uid)	
	end 
end)

function restorePlayerNametagColor(player)
	local rank = getElementData(player, "player:rank") or 0
	local r, g, b = nametagColors[rank][1], nametagColors[rank][2], nametagColors[rank][3]
	if rank == 0 and getElementData(player, "player:premium") then 
		r, g, b = 241, 196, 15
	end 
	setPlayerNametagColor(player, r, g, b)	
end 

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