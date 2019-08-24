--[[
	##########################################################################
	##                                                                      ##
	## Project: 'MTA Slender' - Gamemode for MTA: San Andreas               ##
	##                      Developer: Noneatme                             ##
	##           License: See LICENSE in the top level directory            ##
	##                                                                      ##
	##########################################################################
	[C] Copyright 2013-2014, Noneatme
]]
-- FUNCTIONS --
SLENDER_MONEY = 15000 
SLENDER_EXP = 50 
local slenderData = {} 

addEvent("doClientSpawnPlayerToServer", true)

local spawn_pos = {
	["forest"] = {-775.42193603516, -2214.1022949219, 20.011877059937, 50},
	["industry"] = {2232.5007324219, -2217.4895019531, 13.546875, 90},
	["city"] = {0, 0, 0, 0},
}
local playerLamp = {}

local randSkins = {
	[1] = 7,
	[2] = 11,
	[3] = 15,
	[4] = 22,
	[5] = 23,
	[6] = 25,
	[7] = 46,
	[8] = 47,
	[9] = 56,
	[10] = 59,
	[11] = 60,
	[12] = 82,
	[13] = 98,
	[14] = 143,
	[15] = 170,
	[16] = 169,
	[17] = 179,
	[18] = 180,
	[19] = 185,
	[20] = 188,
}


sFUNC["toggleplayerlamp"] = function(thePlayer)
	local flashlight = getElementData(thePlayer, "player:flashlight")
	setElementData(thePlayer, "player:flashlight", not flashlight)
	triggerClientEvent(thePlayer, "doSlenderClientPlaySound", thePlayer, "flashlight.mp3", false)
end

sFUNC["spawnplayer"] = function(thePlayer, auswahl)
	fadeCamera(thePlayer, false, 1, 0, 0, 0)
	setTimer(function()
		fadeCamera(thePlayer, true)
		local x, y, z, rot = spawn_pos[auswahl][1], spawn_pos[auswahl][2], spawn_pos[auswahl][3], spawn_pos[auswahl][4]
		spawnPlayer(thePlayer, x, y, z, rot, 60)
		setElementDimension(thePlayer, getElementData(thePlayer, "player:id"))
		setCameraTarget(thePlayer, thePlayer)
		setElementAlpha(thePlayer, 255)
		triggerClientEvent(thePlayer, "onSlenderEgoEnable", thePlayer)
		triggerClientEvent(thePlayer, "doSlenderClientSendMessage", thePlayer, "Zbierz 8 kartek.")
	end, 1000, 1)
end

addEventHandler("doClientSpawnPlayerToServer", getRootElement(), function(auswahl)
	sFUNC["spawnplayer"](source, auswahl)
end)

local function addSlenderData(data)
	local id = exports["ms-database"]:query("INSERT INTO ms_slender VALUES(?, ?, ?, ?, ?)", nil, data.accountid, data.name, data.time, data.pages)
	data.id = id
	data.today = true
	table.insert(slenderData, data)
end 

addEvent("onPlayerGetSlenderReward", true)
addEventHandler("onPlayerGetSlenderReward", root, function(won, time, pages)
	setElementDimension(client, 0)
	
	local found = false 
	local uid = getElementData(client, "player:uid")
	for k, v in ipairs(slenderData) do 
		if v.accountid == uid and v.pages == 8 then 
			found = k
			break
		end
	end
		
	addSlenderData({id=nil, accountid=uid, name=getPlayerName(client), time=time, pages=pages})	

	local m, s, cs = msToTimeStr(time)
	time = m..":"..s..":"..cs
	
	if won then	
		if found then 
			triggerClientEvent(client, "onClientAddNotification", client, "Dodano twój wynik do statystyk. Znalazłeś 8 kartek!\nTwój czas: "..time.."\nZebrane kartki: "..tostring(pages), "success")
			return
		end 
		
		triggerClientEvent(client, "onClientAddNotification", client, "Znalazłeś wszystkie 8 kartek. Otrzymujesz $"..tostring(SLENDER_MONEY).." i "..tostring(SLENDER_EXP).." EXP. Nagroda jest jednorazowa.\nTwój czas: "..time, "success", 15000)
		exports["ms-gameplay"]:msGiveMoney(client, SLENDER_MONEY)
		exports["ms-gameplay"]:msGiveExp(client, SLENDER_EXP)
	else 
		triggerClientEvent(client, "onClientAddNotification", client, "Zginąłeś!\nTwój czas: "..time.."\nZebrane kartki: "..tostring(pages), "error")
	end
end)

addEventHandler("onResourceStart", resourceRoot, function()
	slenderData = exports["ms-database"]:getRows("SELECT * FROM ms_slender")
	
	local pickup = createPickup(-1633.63, -2235.44, 31.48, 3, 1254, 1000)
	local blip = createBlipAttachedTo(pickup, 1)
	setElementData(blip, "blipIcon", "slender")
	
	addEventHandler("onPickupHit", pickup, function(player)
		local best = slenderData 
		table.sort(best, function(a, b)
			if a.pages ~= b.pages then 
				return a.pages > b.pages
			end
			
			return a.time < b.time
		end)
			
		local last = {}
		for k, v in ipairs(slenderData) do 
			if v.today then 
				table.insert(last, v)
			end
		end 
			
		triggerClientEvent(player, "onClientSlenderWindow", player, true, {bestPlaces=best, lastPlaces=last})
	end)
end)

function msToTimeStr(ms)
	if not ms then
		return ''
	end

	if ms < 0 then
		return "0","00","00"
	end

	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))

	return minutes, seconds, centiseconds
end