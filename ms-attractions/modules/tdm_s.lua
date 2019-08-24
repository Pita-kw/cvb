TDM = {} 

function TDM.load()
	TDM.name = "Team Deathmatch"
	TDM.team = createTeam(TDM.name, 255, 255, 255)
	TDM.cmd = "tdm"
	TDM.entriesTime = 30000 -- czas zapisów w milisekundach
	TDM.money = 1000
	TDM.exp = 10
	
	
	TDM.minPlayers = 6
	TDM.maxPlayers = 20
	TDM.time = 60000*3 -- czas TDM 
	
	TDM.maps = {
		"maps/tdm-medieval/medieval.map",
		"maps/tdm-vinewood/vinewood.map",
		"maps/tdm-gridlock/gridlock.map",
		"maps/tdm-damwars/damwars.map",
	}
	
	-- po rozpoczeciu gry
	TDM.teamRedData = {}
	TDM.teamBlueData = {}
	TDM.objects = {}
	TDM.vehicles = {} 
	
	addCommandHandler(TDM.cmd, TDM.entry)
end

function TDM.stop()
	for k,v in ipairs(getPlayersInTeam(TDM.team)) do 
		removeElementData(v, "player:tdm_team")
	end
end

function TDM.start()
	-- wczytywanie losowej mapy 
	local map = TDM.maps[math.random(1, #TDM.maps)]
	 
	
	-- ładowanie XML chce by zostalo na takim niskim poziomie nie uzywajac zadnych dodatkowych funkcji
	-- ladowanie obiektow
	local xml = xmlLoadFile(map)
	
	local i = 0
	local child = true 
	repeat 
		child = xmlFindChild(xml, "object", i)
		if child then 
			local model, x,y,z,rx,ry,rz = xmlNodeGetAttribute(child, "model"), xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rotX"), xmlNodeGetAttribute(child, "rotY"), xmlNodeGetAttribute(child, "rotZ")
			local obj = createObject(model, x, y, z, rx, ry, rz)
			setElementDimension(obj, 69)
			table.insert(TDM.objects, obj)
		end 
		i = i+1
	until child == false 
	
	-- ladowanie pojazdow 
	i = 0 
	child = true 
	repeat 
		child = xmlFindChild(xml, "vehicle", i)
		if child then 
			local model, x,y,z,rx,ry,rz = xmlNodeGetAttribute(child, "model"), xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rotX"), xmlNodeGetAttribute(child, "rotY"), xmlNodeGetAttribute(child, "rotZ")
			local obj = createVehicle(tonumber(model), tonumber(x), tonumber(y), tonumber(z), tonumber(rx), tonumber(ry), tonumber(rz))
			setElementDimension(obj, 69)
			table.insert(TDM.vehicles, obj)
		end 
		i = i+1
	until child == false 
	
	-- ladowanie spawnow i broni 
	-- druzyna czerwona  
	local base = xmlFindChild(xml, "base", 0)
	-- bronie
	i = 0 
	child = true 
	TDM.teamRedData.weapons = {} 
	repeat 
		child = xmlFindChild(base, "weapon", i)
		if child then 
			local model, ammo = xmlNodeGetAttribute(child, "model"), xmlNodeGetAttribute(child, "ammo")
			table.insert(TDM.teamRedData.weapons, {model, ammo})
		end
		i = i+1
	until child == false 
	-- skiny 
	i = 0 
	child = true 
	TDM.teamRedData.skins = {} 
	repeat 
		child = xmlFindChild(base, "skin", i)
		if child then 
			local model = xmlNodeGetAttribute(child, "model")
			table.insert(TDM.teamRedData.skins, model)
		end
		i = i+1
	until child == false 
	-- spawny 
	i = 0 
	child = true 
	TDM.teamRedData.spawns = {} 
	repeat 
		child = xmlFindChild(base, "spawn", i)
		if child then 
			local x, y, z, rot = xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rot")
			table.insert(TDM.teamRedData.spawns, {x, y, z, rot})
		end
		i = i+1
	until child == false 
	
	-- druzyna niebieska 
	base = xmlFindChild(xml, "base", 1)
	-- bronie
	i = 0 
	child = true 
	TDM.teamBlueData.weapons = {} 
	repeat 
		child = xmlFindChild(base, "weapon", i)
		if child then 
			local model, ammo = xmlNodeGetAttribute(child, "model"), xmlNodeGetAttribute(child, "ammo")
			table.insert(TDM.teamBlueData.weapons, {model, ammo})
		end
		i = i+1
	until child == false 
	-- skiny 
	i = 0 
	child = true 
	TDM.teamBlueData.skins = {} 
	repeat 
		child = xmlFindChild(base, "skin", i)
		if child then 
			local model = xmlNodeGetAttribute(child, "model")
			table.insert(TDM.teamBlueData.skins, model)
		end
		i = i+1
	until child == false 
	-- spawny 
	i = 0 
	child = true 
	TDM.teamBlueData.spawns = {} 
	repeat 
		child = xmlFindChild(base, "spawn", i)
		if child then 
			local x, y, z, rot = xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rot")
			table.insert(TDM.teamBlueData.spawns, {x, y, z, rot})
		end
		i = i+1
	until child == false 
	
	
	xmlUnloadFile(xml)
	
	local players = getPlayersInTeam(TDM.team)
	local lastSpawnedTeam = "red"
	for k,v in ipairs(players) do 
		if not isPedDead(v) then 
			if lastSpawnedTeam == "blue" then 
				setElementData(v, "player:tdm_team", "red")
				lastSpawnedTeam = "red"
			elseif lastSpawnedTeam == "red" then 
				setElementData(v, "player:tdm_team", "blue")
				lastSpawnedTeam = "blue"
			end
			removePedFromVehicle(v)
			fadeCamera(v, false, 1)
			setTimer(function(player)
				triggerEvent("playAttractionMusic", player, player, "war")
				triggerClientEvent(player, "onClientStartTDM", player, TDM.time)
				TDM.spawnPlayer(player)
			end, 1000, 1, v)
		else 
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientAddNotification", v, "Nie zostałeś przeniesiony na atrakcję "..TDM.name..", bo nie żyjesz.", "error")
		end
	end
	
	setElementData(resourceRoot, "tdm:points_red", 0)
	setElementData(resourceRoot, "tdm:points_blue", 0)
	
	addEventHandler("onPlayerWasted", root, TDM.onWasted)
	
	TDM.finishTimer = setTimer(TDM.finish, TDM.time, 1)
end 

function TDM.finish()
	Core.endAttraction(TDM)
	
	local redPoints = getElementData(resourceRoot, "tdm:points_red") or 0 
	local bluePoints = getElementData(resourceRoot, "tdm:points_blue") or 0 
	local winner = "draw"
	if redPoints > bluePoints then 
		winner = "red"
	elseif bluePoints > redPoints then
		winner = "blue"
	end 
	
	local players = getPlayersInTeam(TDM.team)
	for k,v in ipairs(players) do 
		triggerEvent("stopAttractionMusic", v, v)
		exports["ms-auth"]:restorePlayerNametagColor(v)
		
		local playerTeam = getElementData(v, "player:tdm_team")
		if winner == "draw" then 
			triggerClientEvent(v, "onClientAddNotification", v, "Team Deathmatch zakończony remisem.", "info")
		elseif winner == playerTeam then 
			if getElementData(v, "player:premium") then
				triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna wygrała Team Deathmatch! Otrzymujesz ".. math.floor(TDM.money + TDM.money * 0.3) .."$ oraz ".. math.floor(TDM.exp + TDM.exp * 0.3) .." exp ", "success")
			else
				triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna wygrała Team Deathmatch! Otrzymujesz ".. TDM.money .."$ oraz ".. TDM.exp .." exp ", "success")
			end
			
			triggerEvent("addPlayerStats", v, v, "player:tdm_wins", 1)
			exports["ms-gameplay"]:msGiveMoney(v, TDM.money)
			exports["ms-gameplay"]:msGiveExp(v, TDM.exp)
			
		elseif winner ~= playerTeam then  
			triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna przegrała Team Deathmatch! Nie otrzymujesz żadnej nagrody.", "error")
		end 
		
		setPlayerTeam(v, nil)
		takeAllWeapons(v)
		fadeCamera(v, false)
		setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 1000, 1, v)
	end
	
	for k,v in ipairs(TDM.vehicles) do 
		destroyElement(v)
	end 
	
	for k,v in ipairs(TDM.objects) do 
		destroyElement(v)
	end
	
	removeElementData(resourceRoot, "tdm:points_red")
	removeElementData(resourceRoot, "tdm:points_blue")
	
	removeEventHandler("onPlayerWasted", root, TDM.onWasted)
	
	if isTimer(TDM.finishTimer) then 
		killTimer(TDM.finishTimer)
	end 
	
	TDM.teamRedData = {}
	TDM.teamBlueData = {}
	TDM.objects = {}
	TDM.vehicles = {} 
end

function TDM.spawnPlayer(player)
	local team = getElementData(player, "player:tdm_team") or false 
	if not team then return end 
	
	takeAllWeapons(player)
	setElementHealth(player, 100)
	setPedArmor(player, 0)
	fadeCamera(player, true)
	
	if team == "red" then 
		local rand = math.random(1, #TDM.teamRedData.spawns)
		local spawnX, spawnY, spawnZ, rot = TDM.teamRedData.spawns[rand][1], TDM.teamRedData.spawns[rand][2], TDM.teamRedData.spawns[rand][3], TDM.teamRedData.spawns[rand][4]
		
		spawnPlayer(player, spawnX, spawnY, spawnZ)
		setElementRotation(player, 0, 0, rot)
		setElementDimension(player, 69)
		
		for k,v in ipairs(TDM.teamRedData.weapons) do 
			giveWeapon(player, v[1], v[2])
		end
		
		setElementModel(player, TDM.teamRedData.skins[math.random(1, #TDM.teamRedData.skins)])
		setPlayerNametagColor(player, 231, 76, 60)
	elseif team == "blue" then 
		local rand = math.random(1, #TDM.teamBlueData.spawns)
		local spawnX, spawnY, spawnZ, rot = TDM.teamBlueData.spawns[rand][1], TDM.teamBlueData.spawns[rand][2], TDM.teamBlueData.spawns[rand][3], TDM.teamBlueData.spawns[rand][4]
		
		spawnPlayer(player, spawnX, spawnY, spawnZ)
		setElementRotation(player, 0, 0, rot)
		setElementDimension(player, 69)
		
		for k,v in ipairs(TDM.teamBlueData.weapons) do 
			giveWeapon(player, v[1], v[2])
		end
		
		setElementModel(player, TDM.teamBlueData.skins[math.random(1, #TDM.teamBlueData.skins)])
		setPlayerNametagColor(player, 52, 152, 219)
	end
end 

function TDM.onWasted(totalAmmo, killer)
	local team = getElementData(source, "player:tdm_team") or false 
	if not team then return end
	
	if killer then 
		local killerTeam = getElementData(killer, "player:tdm_team")
		setElementData(resourceRoot, "tdm:points_"..tostring(killerTeam), getElementData(resourceRoot, "tdm:points_"..tostring(killerTeam))+1)
	end
end 

function TDM.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..TDM.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= TDM.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..TDM.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(TDM) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..TDM.cmd, attractionStart)
	setElementData(player, "player:attraction", TDM.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..TDM.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == TDM.minPlayers then 
		Core.initAttraction(TDM)
	end
end 