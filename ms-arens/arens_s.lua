--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: arens_s.lua
	@desc: lista aren, tworzenie komend, funkcje
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]



areas = {
	-- interior, dimension, weapon_id, health, armor, tgl
	["onede"] = {
		{3, 18, {24}, 15, 0, false},
		{248.1600, 141.6600, 1003.0200},
		{229.4300, 140.9400, 1003.0200},
		{210.5200, 150.6700, 1003.0200},
		{215.6400, 149.9600, 1003.8100},
		{221.0000, 149.6200, 1003.0200},
		{189.4400, 158.1600, 1003.0200},
		{197.9000, 167.9800, 1003.0200},
		{190.1100, 178.7600, 1003.0200},
		{211.1500, 187.5600, 1003.0200},
		{218.4300, 187.1300, 1003.0300},
		{223.4300, 187.9700, 1003.0300},
		{230.5200, 183.7000, 1003.0300},
		{245.7500, 185.5900, 1008.1700},
		{262.8200, 185.9300, 1008.1700},
		{299.5800, 190.5300, 1007.1700},
		{300.5200, 187.2800, 1007.1700},
		{301.0900, 171.0300, 1007.1700}	
	},
	
	["sniper"] = {
		{0, 699, {34}, 50, 0, false},
		{-34.8278, 1898.3304, 23.3720, 179.3659},
		{-15.4551, 1828.8514, 30.5484, 191.5860},
		{-25.6460, 1749.9182, 33.4875, 353.5575},
		{-77.9033, 1828.5179, 24.6038, 272.0900},
		{5.4035, 1902.1296, 23.9463, 87.5584},
		{19.6854, 1974.4396, 30.3828, 91.2949},
		{-64.0621, 1861.9757, 17.2266, 182.2094},
		{-59.4812, 1811.7493, 17.6406, 178.1360},
		{8.2910, 1804.0496, 17.6406, 177.5092},
		{-79.8744, 1931.4270, 19.9547, 267.1234},
		{3.0480, 1931.7384, 17.6406, 86.3283}		
	},

	["bazooka"] = {
		{0, 199, {35}, 100, 0, false},
		{664.8109, 885.9849, -40.3984},
		{774.3939, 828.9639, 5.8792},
		{481.3689, 958.4439, 5.3957},
		{688.9326, 748.8588, -5.6011},
		{705.7195, 919.0931, -18.6484},
		{628.1097, 993.2015, 5.8817},
		{449.2125, 876.3629, -4.8458},
		{564.4626, 778.8513, -17.1351},
		{566.4577, 874.8604, -35.9215},
		{504.8477, 826.9881, -10.5402}	
	},
	
	["minigun"] = {
		{0, 555, {38}, 100, 0, false},
		{2597.0564, 2726.5623, 23.8222},
		{2522.1343, 2759.0884, 10.8203},
		{2572.4695, 2802.6589, 10.8203},
		{2671.3713, 2765.5728, 10.8203},
		{2548.4849, 2787.6807, 10.8203},
		{2627.7424, 2840.4431, 10.8203},
		{2554.7559, 2719.7932, 10.9844},
		{2648.3906, 2697.1699, 19.3222},
		{2518.5825, 2717.0613, 14.2540},
		{2581.9644, 2731.2368, 10.8203},
		{2575.3718, 2848.3191, 19.9922},
		{2626.4485, 2713.6990, 36.5386},
		{2543.2124, 2833.9595, 10.8203},
		{2648.9546, 2731.5459, 10.8203},
		{2611.4790, 2811.9121, 10.8203}
	},
	
	["dust"] = {
		{1, 999, {4, 23, 25, 30, 16}, 100, 0, false},
		{47.053478240967, 2566.0046386719, 207.94580078125},
		{44.460113525391, 2548.9387207031, 207.07861328125},
		{40.584789276123, 2470.1008300781, 210.53704833984},
		{54.131675720215, 2507.1345214844, 207.94329833984},
		{105.68807220459, 2470.1535644531, 207.08714294434},
		{116.65836334229, 2482.5334472656, 207.08016967773},
		{105.17693328857, 2487.59765625, 207.08016967773},
		{145.31929016113, 2513.8662109375, 208.8076171875},
		{116.70550537109, 2515.1481933594, 207.0810546875},
		{131.77476501465, 2549.7578125, 207.07786560059},
		{120.06927490234, 2559.6997070313, 209.67161560059},
	},
}

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

function joinArena(player, cmdName, respawn)
	if player then 
		local arena = areas[cmdName]
		if arena then 
			if not getElementData(player, "player:spawned") then return end 
			if getElementData(player, "player:job") then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz wejść na arenę podczas pracy.", "error")
				return 
			end 
			
			if getPlayerTeam(player) then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz wejść na arenę podczas atrakcji.", "error")
				return
			end
			
			if (getElementData(player, "player:arena") and respawn ~= true) then triggerClientEvent(player, "onClientAddNotification", player, "Już znajdujesz się na arenie.\nWpisz /ae aby ją opuścić.", "error")  return end
				if cmdName == "dust" then
					triggerClientEvent(player, "loadDustModels", player)
				end
				setElementData(player, "player:arena", cmdName)
				setElementData(player, "player:status", "Arena ".. cmdName .."")
				local spawn_id = math.random(2, #areas[cmdName])
				spawnPlayer(player, areas[cmdName][spawn_id][1], areas[cmdName][spawn_id][2], areas[cmdName][spawn_id][3], 0, getElementData(player, "player:skin"))
				setElementHealth(player, areas[cmdName][1][4])
				setElementInterior(player, areas[cmdName][1][1])
				setElementDimension(player, areas[cmdName][1][2])
				fadeCamera(player, true)
				takeAllWeapons(player)
				local i = 0
				for k,v in ipairs(areas[cmdName][1][3]) do
					if v == 16 then 
						giveWeapon(player, v, 5, true)
					else
						giveWeapon(player, v, 999999, true)
					end
					i = i + 1
				end
				for k, v in pairs(weaponStats) do 
					setPedStat(player, v, 1000)
				end
				setPedArmor(player, areas[cmdName][1][5])
				toggleControl(player, "fire", true)
				toggleControl(player, "aim_weapon", true)
				setElementData(player, "player:zone", false)
				if respawn ~= true then 
					triggerClientEvent(player, "onClientAddNotification", player, "Dołączyłeś do areny "..cmdName.." aby ją opuścić wpisz /ae\nObecnie na arenie jest ".. getArenaPlayers(cmdName) .." graczy", "success")
					triggerClientEvent(player, "arenaHudTrigger", player, true)
					updateArenaPlayers()
				end
		end
	end
end 

for k, v in pairs(areas) do 
	addCommandHandler(k, joinArena)
end 



function exitArena(player, reason)
	if  not getElementData(player, "player:arena") then
		triggerClientEvent(player, "onClientAddNotification", player, "Nie jesteś na żadnej arenie.", "error")
	else
		if getElementData(player, "player:arena") == "dust" then
				triggerClientEvent(player, "unloadDustModels", player)
		end
		
		if reason ~= "restart" then triggerClientEvent(player, "onClientAddNotification", player, "Opuściłeś arenę ".. getElementData(player, "player:arena") or "?" .."", "success") end
		-- Tutaj jakaś funkcja na przywrócenie broni z levela
		exports["ms-gameplay"]:ms_spawnPlayer(player)
		setElementData(player, "player:arena", false)
		setElementData(player, "player:status", "W grze")
		triggerClientEvent(player, "arenaHudTrigger", player, false)
		updateArenaPlayers()
	end
end
addCommandHandler("ae", exitArena)


function getArenaPlayers(arena)
	local players = getElementsByType("player")
	local count = 0
	for k,v in ipairs(players) do 
		if getElementData(v, "player:arena") == arena then
			count = count + 1
		end
	end
	return count
end

function updateArenaPlayers()
	for k, v in pairs(areas) do 
		setElementData(resourceRoot, "".. k ..":players", getArenaPlayers(k))
	end 
end

addEvent("onPlayerEnterArena", true)
addEventHandler("onPlayerEnterArena", root, function(name)
	executeCommandHandler(name, client)
end)

addEventHandler ( "onResourceStop", resourceRoot, 
    function ()
        local players = getElementsByType("player")
		for k,v in ipairs(players) do
			if getElementData(v, "player:arena") then
				exitArena(v, "restart")
				triggerClientEvent(v, "onClientAddNotification", v, "Zostałeś wyrzucony z areny z powodu restartu systemu aren.", "error")
			end
		end
   end 
)


function headShot (attacker, weapon, bodypart, loss )
	if isElement(attacker) then
		if getElementData(attacker, "player:arena") == "sniper" and getElementData(source, "player:arena") == "sniper" then
			if weapon == 34 and bodypart == 9 then
				killPed ( source, attacker, weapon, bodypart )
			end
		end
	end
end
addEventHandler ( "onPlayerDamage", getRootElement (), headShot )

local glitches = {"quickreload","fastmove","fastfire","crouchbug","highcloserangedamage","hitanim","fastsprint","baddrivebyhitbox","quickstand"}

function disableGlitches ()
   for _,glitch in ipairs(glitches) do
      setGlitchEnabled (glitch, false )
   end 
   
   setGlitchEnabled("crouchbug", true)
end
addEventHandler ( "onResourceStart", getResourceRootElement ( ),disableGlitches)

