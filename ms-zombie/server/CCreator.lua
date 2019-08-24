-- ###############################
-- ## Name: CCreator.lua		##
-- ## Author: Noneatme			##
-- ## Version: 1.0				##
-- ## Lizenz: Freie Benutzung	##
-- ###############################g


Creator = {}
Creator.__index = Creator

-- FUNCTIONS & METHODS --

addEvent("doSpawnZombie", true)

local cFunc = {}
local cSetting = {}


cSetting["spawn_randomly"] = false -- false - spawnpointy 
cSetting["spawnpoints"] = {
	{518.52, -2704.43, 11.48},
	{545.12, -2752.85, 11.34}, 
	{594.12, -2732.91, 11.48},
	{662.38, -2709.18, 11.34},
	{644.45, -2639.93, 11.49},
	{562.19, -2632.34, 11.49},
	{543.77, -2603.74, 11.48},
	{604.54, -2671.15, 11.49},
	{685.74, -2667.17, 11.49},
	{545.74, -2686.70, 11.30},
	{649.56, -2603.46, 11.69},
	{646.17, -2682.40, 11.33},
	{578.01, -2720.44, 11.35},
}
cSetting["spawnpointZombies"] = {}

cSetting["check_intervall"] = 1000  -- In welchen Zyclen Zombies erstellt werden (Default 60000, sollte so bleiben da das der Brennpunkt der Ressourcen ist)

cSetting["area_zombies"] = {}

cSetting["zombies"] = {};


-- ///////////////////////////////
-- ///// Zombie Spawn    	//////
-- ///////////////////////////////

spawnSomeZombies = function(x, y, player, area)
	assert(isElement(player), "Player is not given")
	for i = 1, math.random(40, 60), 1 do
		local rx, ry
		if(math.random(0, 1) == 0) then
			if(math.random(0, 1) == 0) then
				rx, ry = x + math.random(10, 150), y + math.random(10, 150)
			else
				rx, ry = x + math.random(10, 150), y - math.random(10, 150)
			end
		else
			if(math.random(0, 1) == 0) then
				rx, ry = x - math.random(10, 150), y - math.random(10, 150)
			else
				rx, ry = x + math.random(10, 150), y - math.random(10, 150)
			end
		end
		triggerClientEvent(player, "onZombieSpawnPosGet", player, rx, ry, area)
	end
end


-- ///////////////////////////////
-- ///// CheckRegion    	//////
-- ///////////////////////////////

cFunc["check_regions"] = function()
	local usedAreas = {}
	
	for index, player in pairs(getElementsByType("player")) do
		if getElementDimension(player) == 666 then 
			local x, y, z = getElementPosition(player)
			local area = getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true)
			usedAreas[area] = player
		end
	end
	for area, player in pairs(usedAreas) do
		if not(cSetting["area_zombies"][area]) then
			cSetting["area_zombies"][area] = {}
			cSetting["area_zombies"][area]["intervall"] = 0
			cSetting["area_zombies"][area]["zombies"] = {}
		end
		if(cSetting["area_zombies"][area]["intervall"] < 5) then
			cSetting["area_zombies"][area]["intervall"] = cSetting["area_zombies"][area]["intervall"]+1
			
			-- // Zombie Creation --
			if(cSetting["area_zombies"][area]["intervall"] == 1) then
				local x, y, z = getElementPosition(player)
				spawnSomeZombies(x, y, player, area)
			end
		else
			for index, zombie in pairs(cSetting["area_zombies"][area]["zombies"]) do
				if(isElement(zombie.ped)) then
					zombie:Destructor()
				end
			end
			cSetting["area_zombies"][area]["intervall"] = 0
			cSetting["area_zombies"][area]["zombies"] = {}
		end
	end
end


-- ///////////////////////////////
-- ///// SpawnZombie    	//////
-- ///////////////////////////////

cFunc["spawn_zombie_func"] = function(x, y, z, area)
	local zombie = Zombie:New(x, y, z, getRandomZombieSkin())
	if(area) then
		cSetting["area_zombies"][area]["zombies"][zombie] = zombie
	end
	
	if(math.random(1, 5) == 3) then
		local randweapon = getRandomZombieWeapon()
		giveWeapon(zombie.ped, randweapon, 9999)
	end
	
	return zombie
end

-- ///////////////////////////////
-- ///// OnStart    		//////
-- ///////////////////////////////

cFunc["on_start"] = function()
	if(cSetting["spawn_randomly"] == true) then
		if(ressourcenSchonend) then
			setTimer(cFunc["check_regions"], 5*60*1000, 0)
		else
			setTimer(cFunc["check_regions"], 30000, 0)
		
		end
		setTimer(function()
			cFunc["check_regions"]()
		end, 1000, 1)
	else
		setTimer(cFunc["spawn_zombies_over_spawnpoints"], 10000, 0)
		
		for i=1, 60 do 
			local spawnpoint = math.random(1, #cSetting["spawnpoints"])
			local x, y, z = cSetting["spawnpoints"][spawnpoint][1], cSetting["spawnpoints"][spawnpoint][2], cSetting["spawnpoints"][spawnpoint][3]
			table.insert(cSetting["spawnpointZombies"], cFunc["spawn_zombie_func"](x+math.random(1,5), y+math.random(1,5), z, false))
		end
	end
end

-- ///////////////////////////////
-- ///// SpawnZombiesOverMap//////
-- ///////////////////////////////

cFunc["spawn_zombies_over_spawnpoints"] = function()
	for k,v in ipairs(cSetting["spawnpointZombies"]) do 
		if not isElement(v.ped) then 
			table.remove(cSetting["spawnpointZombies"], k)
		end
	end 
	
	if #cSetting["spawnpointZombies"] < 60 then 
		for i=1, math.random(2, 5) do 
			local spawnpoint = math.random(1, #cSetting["spawnpoints"])
			local x, y, z = cSetting["spawnpoints"][spawnpoint][1], cSetting["spawnpoints"][spawnpoint][2], cSetting["spawnpoints"][spawnpoint][3]
			table.insert(cSetting["spawnpointZombies"], cFunc["spawn_zombie_func"](x+math.random(1,5), y+math.random(1,5), z, false))
		end
	end
end


-- ///////////////////////////////
-- ///// getRandomZombieSkin//////
-- ///////////////////////////////

getRandomZombieSkin = function()
	local skins = {108,126,127,188,195,206,209,258,264,56,68,92}
	return skins[math.random(1, #skins)]
end

getRandomZombieWeapon = function()
	local weapons = {6, 7, 8, 9}
	
	return weapons[math.random(1, #weapons)]
end
-- EVENT HANDLER --

addEventHandler("onResourceStart", getResourceRootElement(), cFunc["on_start"])
addEventHandler("doSpawnZombie", getRootElement(), cFunc["spawn_zombie_func"])