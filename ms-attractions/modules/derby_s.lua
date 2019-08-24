Derby = {}  

function Derby.load()
	Derby.name = "Derby"
	Derby.team = createTeam(Derby.name, 255, 255, 255)
	Derby.cmd = "db"
	Derby.entriesTime = 30000 -- czas zapisów w milisekundach
	Derby.money = 2000
	Derby.exp = 20
	
	Derby.minPlayers = 4
	Derby.maxPlayers = 10
	Derby.time = 60000*5 -- czas maks
	
	Derby.maps = {
		-- {"mapa", "ewentualny skrypt lua po stronie clienta"}
		{"maps/derby-fucktheloop/map.map"},
		{"maps/derby-locateddemolition/map.map"},
		{"maps/derby-minecrash/map.map", "maps/derby-minecrash/3dmodel.lua"},
		{"maps/derby-minecrash2/map.map", "maps/derby-minecrash2/3dmodel.lua"},
		{"maps/derby-nfs/map.map"},
		{"maps/derby-shadow/map.map", "maps/derby-shadow/3dmodel.lua"},
		{"maps/derby-shukaku/map.map", "maps/derby-shukaku/3dmodel.lua"},
		
		-- mapy Devana
		--{"maps/derby-ancient/ancient.map"},
		{"maps/derby-avci/avci.map"},
		{"maps/derby-fnsh/fnsh.map"},
		{"maps/derby-kamikaze/kamikaze.map"},
		{"maps/derby-laviva/laviva.map"},
		{"maps/derby-smalldd/smalldd.map"},
		{"maps/derby-utopia/utopia.map"},
	}
	
	Derby.waitTimeout = 15000 -- czekamy na zaladowanie
	
	Derby.objects = {}
	Derby.spawnpoints = {}
	Derby.vehicles = {} 
	
	Derby.script = false 
	
	addCommandHandler(Derby.cmd, Derby.entry)
	
	addEvent("onPlayerFinishDerby", true)
	addEventHandler("onPlayerFinishDerby", root, Derby.onPlayerFinishDerby)
end

function Derby.stop()
	
end
 
function Derby.start()
	-- wczytywanie losowej mapy 
	local maps = Derby.maps[math.random(1, #Derby.maps)]
	local map = maps[1]
	outputDebugString("Derby mapa: "..map)
	
	local script = maps[2]
	if script then 
		Derby.script = script
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
			setElementData(obj, "derby", true)
			setElementDimension(obj, 69)
			table.insert(Derby.objects, obj)
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
			table.insert(Derby.spawnpoints, {x=x, y=y, z=z, rotation=rotation, vehicle=vehicle})
		end 
		i = i+1
	until child == false 
	
	local players = getPlayersInTeam(Derby.team)
	
	Derby.currentPlace = #players
	
	for k,v in ipairs(players) do 
		if not isPedDead(v) then 
			removePedFromVehicle(v)
			fadeCamera(v, false, 1)
			setTimer(function(player)
				Derby.spawnPlayer(player, k)
			end, 3000, 1, v)
		else 
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientAddNotification", v, "Nie zostałeś przeniesiony na atrakcję "..Derby.name..", bo nie żyjesz.", "error")
		end
	end 
	
	addEventHandler("onPlayerWasted", root, Derby.onWasted)
	
	setTimer(function()
		Derby.checkTimer = setTimer(Derby.checkPlayers, 2000, 0)
	end, Derby.waitTimeout, 1)
	
	Derby.endTimer = setTimer(Derby.finish, Derby.time+Derby.waitTimeout, 1)
end 


function Derby.checkPlayers()
	local players = getPlayersInTeam(Derby.team)
	for k,v in ipairs(players) do 
		local veh = getPedOccupiedVehicle(v)
		if veh and isElementInWater(veh) then 
			Derby.onPlayerFinishDerby(v)
		end
	end
	
	if #players == 0 then 
		Derby.finish()
	elseif #players == 1 then 
		Derby.onPlayerFinishDerby(players[1])
	end
end 

function Derby.spawnPlayer(player, k)
	local spawnpoint = Derby.spawnpoints[k] or Derby.spawnpoints[#Derby.spawnpoints]
	local vehicle = createVehicle(spawnpoint.vehicle, spawnpoint.x, spawnpoint.y, spawnpoint.z, 0, 0, spawnpoint.rotation or 0)
	addEventHandler("onVehicleStartExit", vehicle, function() cancelEvent() end)
	
	setElementFrozen(vehicle, true)
	setTimer(setElementFrozen, 5000+Derby.waitTimeout, 1, vehicle, false) -- odliczanie :E 
	setElementDimension(vehicle, 69)
	table.insert(Derby.vehicles, vehicle)
	
	setElementPosition(player, spawnpoint.x, spawnpoint.y, spawnpoint.z)
	setElementDimension(player, 69)
	fadeCamera(player, true, 3)
	
	if isPedInVehicle(player) then removePedFromVehicle(player) end 
	setTimer(warpPedIntoVehicle, 300, 1, player, vehicle) -- cos sie pierdoli jak od razu
	
	if Derby.script then 
		triggerClientEvent(player, "onClientDerbyPreLoad", player, Derby.script)
	end 
	
	triggerEvent("playAttractionMusic", player, player, "derby")
	setTimer(triggerClientEvent, Derby.waitTimeout, 1, player, "onClientDerbyStart", player, Derby.time)
	
	table.insert(Derby.vehicles, vehicle)
end 

function Derby.onWasted()
	if getPlayerTeam(source) == Derby.team then 
		Derby.onPlayerFinishDerby(source)
	end
end 

function Derby.onPlayerFinishDerby(player, outTime)
	if not getPlayerTeam(player) then return end 
	triggerEvent("stopAttractionMusic", player, player)
	
	if not outTime then
		Derby.currentPlace = Derby.currentPlace-1
		
		if Derby.currentPlace == 0 then 
			triggerEvent("addPlayerStats", player, player, "player:derby_wins", 1)
			if getElementData(player, "player:premium") then
				triggerClientEvent(player, "onClientAddNotification", player, "Wygrałeś derby, w nagrodę otrzymujesz ".. math.floor(Derby.money + Derby.money * 0.3) .."$ oraz ".. math.floor(Derby.exp + Derby.exp * 0.3) .." exp", "info")
			else
				triggerClientEvent(player, "onClientAddNotification", player, "Wygrałeś derby, w nagrodę otrzymujesz ".. Derby.money .."$ oraz ".. Derby.exp .." exp", "info")
			end
			
			exports["ms-gameplay"]:msGiveMoney(player, Derby.money)
			exports["ms-gameplay"]:msGiveExp(player, Derby.exp)
			
			triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(player).." wygrywa Derby! (/db)", {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-attractions/cup.png"}, 15000)
		end
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Derby skończone z powodu skończenia się czasu.", "info")
	end 
	
	setPlayerTeam(player, nil)
	
	fadeCamera(player, false, 1)
	setTimer(function(player)
		local vehicle = getPedOccupiedVehicle(player)
		for k,v in ipairs(Derby.vehicles) do 
			if v == vehicle then 
				destroyElement(v)
				table.remove(Derby.vehicles, k)
			end
		end 
		
		fadeCamera(player, true, 1)
		triggerClientEvent(player, "onClientFinishDerby", player)
		exports["ms-gameplay"]:ms_spawnPlayer(player)
	end, 1500, 1, player)
end 

function Derby.finish()
	if #Derby.spawnpoints == 0 then return end 
	
	Core.endAttraction(Derby)
	
	local players = getPlayersInTeam(Derby.team)
	if #players > 0 then 
		for k,v in ipairs(players) do 
			Derby.onPlayerFinishDerby(v, true)
		end
	end 
	
	for k,v in ipairs(Derby.vehicles) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end 
	
	for k,v in ipairs(Derby.objects) do 
		if isElement(v) then 
			destroyElement(v)
		end 
	end
	
	Derby.spawnpoints = {}
	
	if isTimer(Derby.checkTimer) then 
		killTimer(Derby.checkTimer)
	end 
	
	if isTimer(Derby.endTimer) then 
		killTimer(Derby.endTimer)
	end 
	
	removeEventHandler("onPlayerWasted", root, Derby.onWasted)
	
	Derby.script = false 
end

function Derby.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..Derby.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= Derby.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..Derby.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(Derby) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..Derby.cmd, attractionStart)
	setElementData(player, "player:attraction", Derby.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..Derby.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == Derby.minPlayers then 
		Core.initAttraction(Derby)
	end
end 