-- nie ma berka po angielsku kurwa.
Berek = {}  

function Berek.load()
	Berek.name = "Berek"
	Berek.team = createTeam(Berek.name, 255, 255, 255)
	Berek.cmd = "br"
	Berek.entriesTime = 30000 -- czas zapisów w milisekundach
	Berek.money = 1000
	Berek.exp = 10
	
	Berek.minPlayers = 4
	Berek.maxPlayers = 15
	Berek.time = 60000*5 -- czas maks
	
	Berek.waitTimeout = 8000 
	
	Berek.maps = {
		{berek={938.3853, 2170.1804, 1011.1534, 193.0000}, gracz={948.1022, 2144.1167, 1011.1534, 76.0000}, interior=1, time=180},
		{berek={-954.5576, 1938.6359, 9.0385, 120.0000}, gracz={-942.8300, 1930.0282, 5.0685, 62.0000}, interior=17, time=240},
		{berek={762.0001, -19.1813, 1000.6547, 193.0000}, gracz={768.1399, -36.7768, 1000.6547, 0.0000}, interior=6, time=180},
		{berek={-974.6534, 1061.1130, 1345.7631, 91.0000}, gracz={-1009.7247, 1078.9292, 1343.3632, 236.0000}, interior=10, time=210},
	}
	
	Berek.marker = nil
	
	addCommandHandler(Berek.cmd, Berek.entry)
end

function Berek.stop()
	
end

function Berek.start()
	Berek.selectedMap = math.random(1, #Berek.maps)
	
	Berek.time = Berek.maps[Berek.selectedMap].time*1000 
	
	local players = getPlayersInTeam(Berek.team)
	local randomSeeker = 1
	Berek.seeker = players[randomSeeker]
	
	setElementData(resourceRoot, "berek:player", Berek.seeker)
	
	for k,v in ipairs(players) do 
		fadeCamera(v, false)
		removePedFromVehicle(v)
		setTimer(Berek.spawnPlayer, 1500, 1, v, Berek.seeker == v)
	end 
	
	triggerClientEvent(Berek.seeker, "onClientAddNotification", Berek.seeker, "Jesteś berkiem! Łap innych graczy poprzez uderzanie ich.", "info", Berek.timeout)
	
	setTimer(function()
		for k,v in ipairs(getPlayersInTeam(Berek.team)) do 
			triggerClientEvent(v, "onClientBerekStart", v, Berek.time, Berek.seeker == v)
			setElementFrozen(v, false)
		end
	end, Berek.waitTimeout, 1)
	
	addEventHandler("onPlayerQuit", root, Berek.onQuit)
	
	Berek.endTimer = setTimer(Berek.finish, Berek.time+Berek.waitTimeout, 1)
end 

function Berek.onDamage(who) 
	detachElements(source, Berek.marker)
	attachElements(Berek.marker, who, 0, 0, 1.5)
	setElementData(resourceRoot, "berek:player", who)
	triggerClientEvent(who, "onClientAddNotification", who, "Jesteś berkiem!", "info")
end 
addEvent("onPlayerBerekDamage", true)
addEventHandler("onPlayerBerekDamage", root, Berek.onDamage)

function Berek.spawnPlayer(player, seeker)
	triggerEvent("playAttractionMusic", player, player, "fun")
	setElementFrozen(player, true)
	setElementDimension(player, 69)
	setElementInterior(player, Berek.maps[Berek.selectedMap].interior)
	fadeCamera(player, true)
	takeAllWeapons(player)
	setElementData(player, "player:god", true)
	
	if seeker then 
		local pos = Berek.maps[Berek.selectedMap].berek
		setElementPosition(player, pos[1], pos[2], pos[3])
		setElementRotation(player, 0, 0, pos[4])
		
		Berek.marker = createMarker(pos[1], pos[2], pos[3], "arrow", 0.5, 255, 0, 0, 200)
		setElementDimension(Berek.marker, 69)
		setElementInterior(Berek.marker, Berek.maps[Berek.selectedMap].interior)
		attachElements(Berek.marker, Berek.seeker, 0, 0, 1.5)
	else
		
		local pos = Berek.maps[Berek.selectedMap].gracz
		setElementPosition(player, pos[1], pos[2], pos[3])
		setElementRotation(player, 0, 0, pos[4])
	end
end 

function Berek.onQuit(quitType)
	if getElementData(resourceRoot, "berek:player") == source then 
		if quitType == "Quit" then 
			-- kurwo masz bana
			exports["ms-admin"]:banMSPlayer(source, false, 60*60, "Wyjście podczas atrakcji berek.")
			setTimer(Berek.finish, 100, 1)
		end
	end
end 

function Berek.finish()
	Core.endAttraction(Berek)
	
	if isElement(Berek.marker) then 
		destroyElement(Berek.marker)
	end 
	
	local winners = ""
	
	for k,v in ipairs(getPlayersInTeam(Berek.team)) do 
		triggerClientEvent(v, "onClientFinishBerek", v)
		
		if v == getElementData(resourceRoot, "berek:player") then 
			triggerClientEvent(v, "onClientAddNotification", v, "Jako berek nie otrzymujesz żadnej nagrody za grę.", "info")
		else 
			if getElementData(v, "player:premium") then
				triggerClientEvent(v, "onClientAddNotification", v, "Wygrałeś! Jako nagrodę otrzymujesz ".. math.floor(Berek.money + Berek.money * 0.3) .."$ oraz ".. math.floor(Berek.exp + Berek.exp * 0.3) .." exp", "info")
			else
				triggerClientEvent(v, "onClientAddNotification", v, "Wygrałeś, Jako nagrodę otrzymujesz ".. Berek.money .."$ oraz ".. Berek.exp .." exp", "info")
			end
			
			if #winners == 0 then 
				winners = getPlayerName(v)
			else 
				winners = winners..", "..getPlayerName(v)
			end 
			
			triggerEvent("addPlayerStats", v, v, "player:bk_wins", 1)
			exports["ms-gameplay"]:msGiveMoney(v, Berek.money)
			exports["ms-gameplay"]:msGiveExp(v, Berek.exp)
		end
		
		triggerEvent("stopAttractionMusic", v, v)
		setPlayerTeam(v, nil)
		fadeCamera(v, false)
		setElementData(v, "player:god", false)
		setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 1200, 1, v)
	end 
	
	triggerClientEvent(root, "onClientAddNotification", root, winners.." wygrywają Berka! (/br)", {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-attractions/cup.png"}, 15000)
	
	if isTimer(Berek.endTimer) then 
		killTimer(Berek.endTimer)
	end 
	
	removeElementData(resourceRoot, "berek:player")
end

function Berek.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..Berek.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= Berek.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..Berek.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(Berek) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..Berek.cmd, attractionStart)
	setElementData(player, "player:attraction", Berek.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..Berek.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == Berek.minPlayers then 
		Core.initAttraction(Berek)
	end
end 

