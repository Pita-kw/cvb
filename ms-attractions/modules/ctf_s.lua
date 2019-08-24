CTF = {} 

function CTF.load()
	CTF.name = "Capture The Flag"
	CTF.team = createTeam(CTF.name, 255, 255, 255)
	CTF.cmd = "ctf"
	CTF.entriesTime = 30000 -- czas zapisów w milisekundach
	
	CTF.minPlayers = 6
	CTF.maxPlayers = 20
	
	CTF.money = 1000
	CTF.exp = 10
	
	
	CTF.maps = {
		{flag={-2404.0627, -597.7464, 132.6484}, red={-2629.7891, -492.6855, 70.0517}, blue={-2340.9756, -791.2807, 93.4068}, interior=0, time=360},
		{flag={1271.5486, 295.1437, 20.6563}, red={1353.0691, 435.5396, 19.7596}, blue={1233.4905, 133.8251, 20.1546}, interior=0, time=300},
		{flag={-2807.4358, -1516.5872, 140.8438}, red={-2806.5645, -1755.3763, 141.6299}, blue={-2805.9421, -1338.5043, 128.9040}, interior=0, time=300},
		{flag={-1380.8540, 1489.5900, 19.0547}, red={-1283.4552, 1659.5562, 2.4358}, blue={-1505.4889, 1375.8252, 3.7879}, interior=0, time=300},
		{flag={-1258.6486, 762.7333, 34.4795}, red={-1013.79, 941.24, 34.78}, blue={-1503.99, 584.74, 34.78}, interior=0, time=180},
		{flag={-1549.3195, -434.3228, 5.9200}, red={-1525.0269, -216.8282, 14.1444}, blue={-1333.6688, -409.5918, 14.1444}, interior=0, time=360},
		{flag={1618.8181, -1717.8267, 3.9854}, red={1899.0760, -1829.8500, 4.0054}, blue={1384.9348, -1715.7794, 8.9054}, interior=0, time=240},
		{flag={-301.8067, 1515.3179, 75.3405}, red={-336.9941, 1262.4905, 23.0931}, blue={-452.6270, 1600.4965, 35.9385}, interior=0, time=300},
		{flag={-329.3210, 1860.8453, 44.7986}, red={-423.0605, 1666.6588, 37.2781}, blue={-211.9975, 2076.4329, 21.6940}, interior=0, time=300},
	}
	
	-- po rozpoczeciu gry
	CTF.selectedMap = false
	
	CTF.blueMarker = false 
	CTF.redMarker = false 
	
	CTF.flagObject = false 
	CTF.flagCol = false 
	CTF.flagMarker = false 
	CTF.flagBlip = false 
	
	addCommandHandler(CTF.cmd, CTF.entry)
end

function CTF.stop()
	for k,v in ipairs(getPlayersInTeam(CTF.team)) do 
		removeElementData(v, "player:CTF_team")
	end
end

function CTF.start()
	-- wczytywanie losowej mapy 
	local map = CTF.maps[math.random(1, #CTF.maps)]
	CTF.selectedMap = map 
	
	CTF.blueMarker = createMarker(map.blue[1], map.blue[2], map.blue[3]-1, "cylinder", 2.5, 52, 152, 219, 120)
	setElementInterior(CTF.blueMarker, map.interior)
	setElementDimension(CTF.blueMarker, 69)
	addEventHandler("onMarkerHit", CTF.blueMarker, CTF.dropFlagBlue)
	
	CTF.blueBlip = createBlipAttachedTo(CTF.blueMarker, 0, 2, 0, 0, 255, 255)
	setElementData(CTF.blueBlip, "blipIcon", "target")
	setElementData(CTF.blueBlip, "blipColor", {52, 152, 219})
	setElementInterior(CTF.blueBlip, map.interior)
	setElementDimension(CTF.blueBlip, 69)

	CTF.redMarker = createMarker(map.red[1], map.red[2], map.red[3]-1, "cylinder", 2.5, 231, 76, 60, 120)
	setElementInterior(CTF.redMarker, map.interior)
	setElementDimension(CTF.redMarker, 69)
	addEventHandler("onMarkerHit", CTF.redMarker, CTF.dropFlagRed)
	
	CTF.redBlip = createBlipAttachedTo(CTF.redMarker, 0, 2, 255, 0, 0, 255)
	setElementData(CTF.redBlip, "blipIcon", "target")
	setElementData(CTF.redBlip, "blipColor", {231, 76, 60})
	setElementInterior(CTF.redBlip, map.interior)
	setElementDimension(CTF.redBlip, 69)
	
	CTF.flagObject = createObject(2993, map.flag[1], map.flag[2], map.flag[3]-1)
	setElementInterior(CTF.flagObject, map.interior)
	setElementDimension(CTF.flagObject, 69)
	
	CTF.flagCol = createColSphere(map.flag[1], map.flag[2], map.flag[3]-1, 3)
	setElementInterior(CTF.flagCol, map.interior)
	setElementDimension(CTF.flagCol, 69)
	addEventHandler("onColShapeHit", CTF.flagCol, CTF.takeFlag)
	
	CTF.flagMarker = createMarker(map.flag[1], map.flag[2], map.flag[3]-1, "cylinder", 2, 200, 200, 200, 70)
	setElementInterior(CTF.flagMarker, map.interior)
	setElementDimension(CTF.flagMarker, 69)
	
	CTF.flagBlip = createBlipAttachedTo(CTF.flagObject, 19)
	setElementInterior(CTF.flagBlip, map.interior)
	setElementDimension(CTF.flagBlip, 69)
	setElementData(CTF.flagBlip, "blipIcon", "flag")
	
	CTF.time = CTF.selectedMap.time*1000
	
	local players = getPlayersInTeam(CTF.team)
	local lastSpawnedTeam = "red"
	for k,v in ipairs(players) do 
		if not isPedDead(v) then 
			if lastSpawnedTeam == "blue" then 
				setElementData(v, "player:CTF_team", "red")
				lastSpawnedTeam = "red"
			elseif lastSpawnedTeam == "red" then 
				setElementData(v, "player:CTF_team", "blue")
				lastSpawnedTeam = "blue"
			end
			removePedFromVehicle(v)
			fadeCamera(v, false, 1)
			setTimer(function(player)
				triggerEvent("playAttractionMusic", player, player, "war")
				triggerClientEvent(player, "onClientStartCTF", player, CTF.time)
				CTF.spawnPlayer(player)
			end, 1000, 1, v)
		else 
			exports["ms-auth"]:restorePlayerNametagColor(v)
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientAddNotification", v, "Nie zostałeś przeniesiony na atrakcję "..CTF.name..", bo nie żyjesz.", "error")
		end
	end
	
	setElementData(resourceRoot, "CTF:points_red", 0)
	setElementData(resourceRoot, "CTF:points_blue", 0)
	
	addEventHandler("onPlayerWasted", root, CTF.onWasted)
	
	CTF.endTimer = setTimer(CTF.finish, CTF.time, 1)
end 

function CTF.finish()
	Core.endAttraction(CTF)
	
	local redPoints = getElementData(resourceRoot, "CTF:points_red") or 0 
	local bluePoints = getElementData(resourceRoot, "CTF:points_blue") or 0 
	local winner = "draw"
	if redPoints > bluePoints then 
		winner = "red"
	elseif bluePoints > redPoints then
		winner = "blue"
	end 
	
	local players = getPlayersInTeam(CTF.team)
	for k,v in ipairs(players) do 
		local playerTeam = getElementData(v, "player:CTF_team")
		if winner == "draw" then 
			triggerClientEvent(v, "onClientAddNotification", v, "Capture The Flag zakończony remisem nikt nie otrzymuje żadnej nagrody.", "info")
		elseif winner == playerTeam then 
			if getElementData(v, "player:premium") then
				triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna wygrała Capture The Flag! Otrzymujesz ".. math.floor(CTF.money + CTF.money * 0.3) .."$ oraz ".. math.floor(CTF.exp + CTF.exp * 0.3) .."exp", "success")
			else
				triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna wygrała Capture The Flag! Otrzymujesz ".. CTF.money .."$ oraz ".. CTF.exp .."exp", "success")
			end
			
			triggerEvent("addPlayerStats", v, v, "player:ctf_wins", 1)
			exports["ms-gameplay"]:msGiveMoney(v, CTF.money)
			exports["ms-gameplay"]:msGiveExp(v, CTF.exp)
			
		elseif winner ~= playerTeam then  
			triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna przegrała Capture The Flag! Nie otrzymujesz żadnej nagrody.", "error")
		end 
		
		exports["ms-auth"]:restorePlayerNametagColor(v)
		triggerEvent("stopAttractionMusic", v, v)
		setPlayerTeam(v, nil)
		takeAllWeapons(v)
		fadeCamera(v, false)
		setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 1000, 1, v)
	end
	
	if isElement(CTF.redMarker) then 
		destroyElement(CTF.redMarker)
	end 
	
	if isElement(CTF.blueMarker) then 
		destroyElement(CTF.blueMarker)
	end 
	
	if isElement(CTF.flagObject) then 
		destroyElement(CTF.flagObject)
	end 
	
	if isElement(CTF.flagCol) then 
		destroyElement(CTF.flagCol)
	end 
	
 	if isElement(CTF.flagMarker) then 
		destroyElement(CTF.flagMarker)
	end 
	
	if isElement(CTF.flagBlip) then 
		destroyElement(CTF.flagBlip)
	end
	
	if isElement(CTF.blueBlip) then 
		destroyElement(CTF.blueBlip)
	end 
	
	if isElement(CTF.redBlip) then 
		destroyElement(CTF.redBlip)
	end
	
	removeElementData(resourceRoot, "CTF:points_red")
	removeElementData(resourceRoot, "CTF:points_blue")
	
	if isTimer(CTF.endTimer) then 
		killTimer(CTF.endTimer)
	end 
	
	removeEventHandler("onPlayerWasted", root, CTF.onWasted)
end

function CTF.takeFlag(player, matchingDimension) 
	if getElementType(player) == "player" and matchingDimension then 
		if isElement(CTF.flagMarker) then 
			destroyElement(CTF.flagMarker)
			CTF.flagMarker = false 
		end 
		
		destroyElement(source)
		CTF.flagCol = false 
		
		attachElements(CTF.flagObject, player, 0, 0, 1.1)
		
		triggerClientEvent(player, "onClientAddNotification", player, "Przejąłeś flagę! Zanieś ją do swojej bazy!", "success")
		for k,v in ipairs(getPlayersInTeam(CTF.team)) do 
			if getElementData(player, "player:CTF_team") == "red" then 
				triggerClientEvent(v, "onClientAddNotification", v, getPlayerName(player).." z drużyny czerwonych przejmuje flagę!", "info")
			else 
				triggerClientEvent(v, "onClientAddNotification", v, getPlayerName(player).." z drużyny niebieskich przejmuje flagę!", "info")
			end
		end
	end
end 

function CTF.spawnPlayer(player)
	local team = getElementData(player, "player:CTF_team") or false 
	if not team then return end 
	
	takeAllWeapons(player)
	setElementHealth(player, 100)
	setPedArmor(player, 0)
	fadeCamera(player, true)
	
	if team == "red" then 
		local x,y,z = CTF.selectedMap.red[1], CTF.selectedMap.red[2], CTF.selectedMap.red[3]
		spawnPlayer(player, x, y, z)
		setElementModel(player, getElementData(player, "player:skin"))
		setPlayerNametagColor(player, 231, 76, 60)
	elseif team == "blue" then 
		local x,y,z = CTF.selectedMap.blue[1], CTF.selectedMap.blue[2], CTF.selectedMap.blue[3]
		spawnPlayer(player, x, y, z)
		setElementModel(player, getElementData(player, "player:skin"))
		setPlayerNametagColor(player, 52, 152, 219)
	end
	
	giveWeapon(player, 26, 9999)
	giveWeapon(player, 34, 9999)
	giveWeapon(player, 29, 9999)
	setElementInterior(player, CTF.selectedMap.interior)
	setElementDimension(player, 69)
end 

function CTF.dropFlagRed(player, matchingDimension)
	if getElementType(player) == "player" and matchingDimension then 
		local attached = getAttachedElements(player)
		local hasFlag = false 
		for k,v in ipairs(attached) do 
			if v == CTF.flagObject then 
				hasFlag = true
			end
		end 
		
		if hasFlag then 
			local team = getElementData(player, "player:CTF_team")
			if team == "red" then 
				local map = CTF.selectedMap 
					
				destroyElement(CTF.flagObject)
				destroyElement(CTF.flagBlip)
				
				CTF.flagObject = createObject(2993, map.flag[1], map.flag[2], map.flag[3]-1)
				setElementInterior(CTF.flagObject, map.interior)
				setElementDimension(CTF.flagObject, 69)
				
				CTF.flagCol = createColSphere(map.flag[1], map.flag[2], map.flag[3]-1, 3)
				setElementInterior(CTF.flagCol, map.interior)
				setElementDimension(CTF.flagCol, 69)
				addEventHandler("onColShapeHit", CTF.flagCol, CTF.takeFlag)
				
				CTF.flagMarker = createMarker(map.flag[1], map.flag[2], map.flag[3]-1, "cylinder", 2, 200, 200, 200, 70)
				setElementInterior(CTF.flagMarker, map.interior)
				setElementDimension(CTF.flagMarker, 69)
				
				CTF.flagBlip = createBlipAttachedTo(CTF.flagObject, 19)
				setElementInterior(CTF.flagBlip, map.interior)
				setElementDimension(CTF.flagBlip, 69)
				setElementData(CTF.flagBlip, "blipIcon", "flag")
				
				setElementData(resourceRoot, "CTF:points_red", getElementData(resourceRoot, "CTF:points_red")+1)
				
				triggerClientEvent(player, "onClientAddNotification", player, "Twoja drużyna zyskuje jeden punkt!", "info")
				for k,v in ipairs(getPlayersInTeam(CTF.team)) do 
					triggerClientEvent(v, "onClientAddNotification", v, "Drużyna czerwonych zyskuje punkt!", "info")
				end
			end
		end
	end
end 

function CTF.dropFlagBlue(player, matchingDimension)
	if getElementType(player) == "player" and matchingDimension then 
		local attached = getAttachedElements(player)
		local hasFlag = false 
		for k,v in ipairs(attached) do 
			if v == CTF.flagObject then 
				hasFlag = true
			end
		end 
		
		if hasFlag then 
			local team = getElementData(player, "player:CTF_team")
			if team == "blue" then 
				local map = CTF.selectedMap 
				
				destroyElement(CTF.flagObject)
				destroyElement(CTF.flagBlip)
				
				CTF.flagObject = createObject(2993, map.flag[1], map.flag[2], map.flag[3]-1)
				setElementInterior(CTF.flagObject, map.interior)
				setElementDimension(CTF.flagObject, 69)
				
				CTF.flagCol = createColSphere(map.flag[1], map.flag[2], map.flag[3]-1, 3)
				setElementInterior(CTF.flagCol, map.interior)
				setElementDimension(CTF.flagCol, 69)
				addEventHandler("onColShapeHit", CTF.flagCol, CTF.takeFlag)
				
				CTF.flagMarker = createMarker(map.flag[1], map.flag[2], map.flag[3]-1, "cylinder", 2, 200, 200, 200, 70)
				setElementInterior(CTF.flagMarker, map.interior)
				setElementDimension(CTF.flagMarker, 69)
				
				CTF.flagBlip = createBlipAttachedTo(CTF.flagObject, 19)
				setElementInterior(CTF.flagBlip, map.interior)
				setElementDimension(CTF.flagBlip, 69)
				setElementData(CTF.flagBlip, "blipIcon", "flag")
				
				setElementData(resourceRoot, "CTF:points_blue", getElementData(resourceRoot, "CTF:points_blue")+1)
				
				triggerClientEvent(player, "onClientAddNotification", player, "Twoja drużyna zyskuje jeden punkt!", "info")
				for k,v in ipairs(getPlayersInTeam(CTF.team)) do 
					triggerClientEvent(v, "onClientAddNotification", v, "Drużyna niebieskich zyskuje punkt!", "info")
				end
			end
		end
	end
end 


function CTF.onWasted(totalAmmo, killer)
	local team = getElementData(source, "player:CTF_team") or false 
	if not team then return end
	
	local attached = getAttachedElements(source)
	for k,v in ipairs(attached) do 
		if v == CTF.flagObject then 
			destroyElement(CTF.flagObject)
			destroyElement(CTF.flagBlip)
			
			local map = CTF.selectedMap
			local x,y,z = getElementPosition(source)
			CTF.flagObject = createObject(2993, x, y, z-1)
			setElementInterior(CTF.flagObject, map.interior)
			setElementDimension(CTF.flagObject, 69)
				
			CTF.flagCol = createColSphere(x, y, z-1, 3)
			setElementInterior(CTF.flagCol, map.interior)
			setElementDimension(CTF.flagCol, 69)
			addEventHandler("onColShapeHit", CTF.flagCol, CTF.takeFlag)
				
			CTF.flagMarker = createMarker(x, y, z-1, "cylinder", 2, 200, 200, 200, 70)
			setElementInterior(CTF.flagMarker, map.interior)
			setElementDimension(CTF.flagMarker, 69)
				
			CTF.flagBlip = createBlipAttachedTo(CTF.flagObject, 19)
			setElementInterior(CTF.flagBlip, map.interior)
			setElementDimension(CTF.flagBlip, 69)
			setElementData(CTF.flagBlip, "blipIcon", "flag")
			
			for k,v in ipairs(getPlayersInTeam(CTF.team)) do 
				triggerClientEvent(v, "onClientAddNotification", v, getPlayerName(source).." traci flagę!", "info")
			end
			
			break
		end
	end 
end 

function CTF.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..CTF.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= CTF.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..CTF.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(CTF) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..CTF.cmd, attractionStart)
	setElementData(player, "player:attraction", CTF.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..CTF.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == CTF.minPlayers then 
		Core.initAttraction(CTF)
	end
end 
