local weapons = { 
	-- [zakres lvl] = {id broni}
	[{1, 9}] = {5, 22, 25, 32, 30, 33, 43, 46}, -- baseball, pistolet, shotgun, tec9, ak-47, karabin, aparat
	[{10, 20}] = {5, 23, 27, 28, 30, 33, 43, 46}, -- baseball, tłumik, combat, uzi, ak-47, karabin, aparat
	[{21, 25}] = {4, 24, 26, 29, 30, 33, 43, 46}, -- nóż, desert, spawn-off, mp5, ak-47, karabin, aparat
	[{26, 1000}] = {4, 24, 26, 29, 31, 34, 43, 46} -- nóż, desert, spawn-off, mp5, m4, snajperka, aparat
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

SPAWN_WEAPON_AMMO = 400 -- ile maja miec bronie ammo na spawn 

function ms_spawnPlayer(player)
	if not isElement(player) and getElementType(player) == "player" then return end 
	
	local stats = exports["ms-database"]:getRows("SELECT * FROM `ms_players` WHERE `accountid`=?", getElementData(player, "player:uid"))
	if not stats then kickPlayer(player, "Proszę zalogować się ponownie") return end 
	stats = stats[1] 
	
	
	local x,y,z,int,dim = exports["ms-teleports"]:getRandomTeleport()
	spawnPlayer(player, x,y,z)
	setElementInterior(player, int)
	setElementDimension(player, dim)
	
	setElementData(player, "player:spawned", true)
	
	setPlayerMoney(player, stats["money"])
	setElementHealth(player, 100)
	setElementModel(player, getElementData(player, "player:skin") or 0)
	
	setElementData(player, "player:status", "W grze")
	
	setCameraTarget(player, player)
	
	-- statystyki peda 
	setPedStat(player, 160, 1000) -- driving skill
	setPedStat(player, 229, 750) -- bike skill  
	setPedStat(player, 230, 1000) -- cycle skill

	-- bronie na full
	for k, v in pairs(weaponStats) do 
		if v == 75 then -- uzi
			setPedStat(player, v, 500)
		else
			setPedStat(player, v, 1000)
		end
	end
	
	givePlayerWeaponLevel(player)
	
	fadeCamera(player, true)
	
	triggerClientEvent(player, "onClientShowHUD", player, true)
	
	if getElementData(player, "player:entrance") == "inside" then 
		triggerClientEvent(player, "onPlayerLoadEntranceMusic", player, false)
	end
end 


function givePlayerWeaponLevel(player)
	if not getPlayerTeam(player) or not getElementData(player, "player:arena") then -- nie jest na atrakcji 
		local lvl = getElementData(player, "player:level") or 1 
		for k, v in pairs (weapons) do 
			local required = k 
			local availableWeapons = v 
			if lvl >= required[1] and lvl <= required[2] then 
				for _, wep in ipairs(availableWeapons) do 
					giveWeapon(player, wep, SPAWN_WEAPON_AMMO)
				end 
				
				break
			end
		end
		
		setPedWeaponSlot(player, 5)
	end 
end
addEvent("giveLevelWeapons", true)
addEventHandler("giveLevelWeapons", getRootElement(), givePlayerWeaponLevel)
