Race = {}  

function Race.load()
	Race.name = "Race"
	Race.team = createTeam(Race.name, 255, 255, 255)
	Race.cmd = "rc"
	Race.entriesTime = 30000 -- czas zapisów w milisekundach
	Race.money = 2500 -- nagroda dla pierwszego miejsca
	Race.exp = 25 -- nagroda exp dla pierwszego miejsca
	
	Race.minPlayers = 6
	Race.maxPlayers = 10
	Race.time = 60000*7.5 -- czas maks
	
	Race.maps = {
		--{"mapa", "ewentualny skrypt lua po stronie clienta"},
		{"maps/race-driftcity/driftcity.map"},
		{"maps/race-death/map.map", "maps/race-death/3dmodel.lua"},
		{"maps/race-f1/map.map", "maps/race-f1/3dmodel.lua"},
		{"maps/race-snow/map.map", "maps/race-snow/3dmodel.lua"},
		{"maps/race-luigicircuit/luigi.map", "maps/race-luigicircuit/3dmodel.lua"},
		{"maps/race-lvsprint/map.map"},
		{"maps/race-farm2city/map.map"},
		{"maps/race-awalk/map.map"},
		{"maps/race-bobcat/map.map"},
		{"maps/race-santosdrive/map.map"},
	}
	
	Race.waitTimeout = 15000 -- czekamy na zaladowanie
	
	Race.objects = {}
	Race.checkpoints = {} 
	Race.spawnpoints = {}
	Race.vehicles = {} 
	
	Race.godModeEnabled = false
	Race.ghostModeEnabled = false
	Race.script = false 
	
	addCommandHandler(Race.cmd, Race.entry)
	
	addEvent("onPlayerFinishRace", true)
	addEventHandler("onPlayerFinishRace", root, Race.onPlayerFinishRace)
	
	addEvent("onPlayerRaceRespawn", true)
	addEventHandler("onPlayerRaceRespawn", root, Race.onPlayerRaceRespawn)
end

function Race.stop()
	
end
 
function Race.start()
	-- wczytywanie losowej mapy 
	local maps = Race.maps[math.random(1, #Race.maps)]
	local map = maps[1]
	local script = maps[2]
	if script then 
		Race.script = script
	end 
	
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
			table.insert(Race.objects, obj)
		end 
		i = i+1
	until child == false 
	
	-- ladowanie checkpointow
	i = 0 
	child = true
	repeat 
		child = xmlFindChild(xml, "checkpoint", i)
		if child then 
			local x,y,z,rot = xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rotation") or 0
			table.insert(Race.checkpoints, {x=x, y=y, z=z, rot=rot})
		end 
		i = i+1
	until child == false 
	
	-- ladowanie spawnpointsow
	i = 0 
	child = true
	repeat 
		child = xmlFindChild(xml, "spawnpoint", i)
		if child then 
			local vehicle,x,y,z,rotation =  xmlNodeGetAttribute(child, "vehicle"), xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rotation") or xmlNodeGetAttribute(child, "rotZ")
			table.insert(Race.spawnpoints, {x=x, y=y, z=z, rotation=rotation, vehicle=vehicle})
		end 
		i = i+1
	until child == false 
	
	Race.godModeEnabled = false
	Race.ghostModeEnabled = true
	
	xmlUnloadFile(xml)
	
	local players = getPlayersInTeam(Race.team)
	
	for k,v in ipairs(players) do 
		if not isPedDead(v) then 
			fadeCamera(v, false, 1)
			removePedFromVehicle(v)
			setTimer(function(player)
				Race.spawnPlayer(player, k)
			end, 3000, 1, v)
		else 
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientAddNotification", v, "Nie zostałeś przeniesiony na atrakcję "..Race.name..", bo nie żyjesz.", "error")
		end
	end 
	
	Race.allPlaces = #players
	Race.currentPlace = 0
	
	Race.finishTimer = setTimer(Race.finish, Race.time, 1)
end 

function Race.spawnPlayer(player, k)
	local spawnpoint = Race.spawnpoints[k] or Race.spawnpoints[#Race.spawnpoints]
	local vehicle = createVehicle(spawnpoint.vehicle, spawnpoint.x, spawnpoint.y, spawnpoint.z, 0, 0, spawnpoint.rotation or 0)
	addEventHandler("onVehicleStartExit", vehicle, function() cancelEvent() end)
	--triggerClientEvent(player, "onClientRaceSetGhostmode", player, vehicle, true)
	
	setElementFrozen(vehicle, true)
	setTimer(setElementFrozen, 5000+Race.waitTimeout, 1, vehicle, false) -- odliczanie :E 
	setElementDimension(vehicle, 69)
	table.insert(Race.vehicles, vehicle)
	
	setElementPosition(player, spawnpoint.x, spawnpoint.y, spawnpoint.z)
	setElementDimension(player, 69)
	setTimer(fadeCamera, 2000, 1, player, true, 2)
	
	if isPedInVehicle(player) then removePedFromVehicle(player) end 
	setTimer(warpPedIntoVehicle, 1300, 1, player, vehicle) -- cos sie pierdoli jak od razu
	
	if Race.script then 
		triggerClientEvent(player, "onClientRacePreLoad", player, Race.script)
	end 
	
	triggerEvent("playAttractionMusic", player, player, "race")
	
	setTimer(triggerClientEvent, Race.waitTimeout, 1, player, "onClientRaceStart", player, Race.checkpoints, Race.godModeEnabled, Race.ghostModeEnabled)
	
	table.insert(Race.vehicles, vehicle)
end 

function Race.onPlayerRaceRespawn()
	for k, v in ipairs(getPlayersInTeam(Race.team)) do 
		triggerClientEvent(v, "onClientRaceRespawn", client)
	end
end 

function Race.onPlayerFinishRace(isDead)
	if not isDead then 
		Race.currentPlace = Race.currentPlace+1
			
		if Race.currentPlace == 1 then 
			if getElementData(client, "player:premium") then
				triggerClientEvent(client, "onClientAddNotification", client, "Wygrałeś wyścig! Otrzymujesz ".. math.ceil(Race.money + Race.money * 0.3) .."$ oraz ".. math.ceil(Race.exp + Race.exp * 0.3) .." exp", "info")
			else
				triggerClientEvent(client, "onClientAddNotification", client, "Wygrałeś wyścig! Otrzymujesz ".. Race.money .."$ oraz ".. Race.exp .." exp", "info")
			end
			triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(client).." wygrywa Wyścig! (/rc)", {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-attractions/cup.png"}, 15000)
			triggerEvent("addPlayerStats", client, client, "player:race_wins", 1)
			exports["ms-gameplay"]:msGiveMoney(client, Race.money)
			exports["ms-gameplay"]:msGiveExp(client, Race.exp)
		elseif Race.currentPlace == 2 then 
		
			if getElementData(client, "player:premium") then
				triggerClientEvent(client, "onClientAddNotification", client, "Zająłeś 2 miejsce! Otrzymujesz ".. math.ceil(Race.money/2 + (Race.money/2) * 0.3) .."$ oraz ".. math.ceil(Race.exp/2 + Race.exp/2 * 0.3) .." exp", "info")
			else
				triggerClientEvent(client, "onClientAddNotification", client, "Zająłeś 2 miejsce!  Otrzymujesz ".. Race.money/2 .."$ oraz ".. math.ceil(Race.exp/2) .." exp", "info")
			end
			exports["ms-gameplay"]:msGiveMoney(client, Race.money/2)
			exports["ms-gameplay"]:msGiveExp(client, Race.exp/2)
		
		elseif Race.currentPlace == 3 then 

			if getElementData(client, "player:premium") then
				triggerClientEvent(client, "onClientAddNotification", client, "Zająłeś 3 miejsce!  Otrzymujesz ".. math.ceil(Race.money/3 + (Race.money/3) * 0.3) .."$ oraz ".. math.ceil(Race.exp/3 + Race.exp/3 * 0.3) .." exp", "info")
			else
				triggerClientEvent(client, "onClientAddNotification", client, "Zająłeś 3 miejsce!  Otrzymujesz ".. Race.money/3 .."$ oraz ".. math.ceil(Race.exp/3) .." exp", "info")
			end
			exports["ms-gameplay"]:msGiveMoney(client, Race.money/3)
			exports["ms-gameplay"]:msGiveExp(client, Race.exp/3)
		else 
			triggerClientEvent(client, "onClientAddNotification", client, "Nie otrzymujesz żadnej nagrody.", "info")
		end
	else
		triggerClientEvent(client, "onClientAddNotification", client, "Nie otrzymujesz żadnej nagrody.", "info")
	end 
	
	local vehicle = getPedOccupiedVehicle(client)
	for k,v in ipairs(Race.vehicles) do 
		if v == vehicle then 
			destroyElement(v)
			table.remove(Race.vehicles, k)
		end
	end 
	
	if #getPlayersInTeam(Race.team) <= 1 then 
		setTimer(Race.finish, 1000, 1)
	end
	
	setPlayerTeam(client, nil)
	triggerEvent("stopAttractionMusic", client, client)
	exports["ms-gameplay"]:ms_spawnPlayer(client)
end 

function Race.finish()
	Core.endAttraction(Race)
	
	for k,v in ipairs(getPlayersInTeam(getTeamFromName("Race"))) do 
		triggerClientEvent(v, "onClientFinishRace", v, true)
	end 
	
	for k,v in ipairs(Race.vehicles) do 
		if isElement(v) then 
			destroyElement(v)
		end 
	end 
	Race.vehicles = {} 
	
	for k,v in ipairs(Race.objects) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end 
	Race.objects = {} 
	
	Race.currentPlace = nil 
	Race.allPlaces = nil 
	Race.checkpoints = {} 
	Race.spawnpoints = {}

	Race.script = false 
	Race.godModeEnabled = false
	Race.ghostModeEnabled = false
	
	if isTimer(Race.finishTimer) then 
		killTimer(Race.finishTimer)
	end
end

function Race.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..Race.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= Race.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..Race.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(Race) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..Race.cmd, attractionStart)
	setElementData(player, "player:attraction", Race.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..Race.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == Race.minPlayers then 
		Core.initAttraction(Race)
	end
end 