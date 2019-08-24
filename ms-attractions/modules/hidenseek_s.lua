HideNSeek = {}  

function HideNSeek.load()
	HideNSeek.name = "Chowany"
	HideNSeek.team = createTeam(HideNSeek.name, 255, 255, 255)
	HideNSeek.cmd = "ch"
	HideNSeek.entriesTime = 30000 -- czas zapisów w milisekundach
	
	HideNSeek.exp = 10 
	HideNSeek.money = 1000 
	
	HideNSeek.minPlayers = 6
	HideNSeek.maxPlayers = 20
	HideNSeek.time = 60000*5 -- czas maks
	
	HideNSeek.timeout = 5000 
	
	HideNSeek.maps = {
		{sz={2223.59, -1149.67, 1025.80, 180.0}, ch={2217.50, -1150.81, 1025.80, 270.0}, interior=15, time=120},
		{sz={2235.93, 1676.43, 1008.34, 180.0}, ch={2235.69, 1631.14, 1008.44, 0.0}, interior=1, time=210},
		{sz={359.8311, 206.9288, 1008.3750, 90.0}, ch={373.7381, 173.8021, 1008.3550, 270.0}, interior=3, time=230},
		{sz={246.7525, 124.0591, 1003.2031, 180.0}, ch={249.2540, 111.3937, 1003.2031, 0.0}, interior=10, time=180},
		{sz={254.5483, 66.1607, 1003.7000, 90.0}, ch={246.3946, 66.8222, 1003.7000, 180.0}, interior=6, time=90},
		{sz={230.7419, 161.5540, 1003.0500, 0.0}, ch={288.7309, 173.6857, 1007.1641, 0.0}, interior=3, time=180},
		{sz={1264.9446, -781.2303, 1091.9000, 90}, ch={1298.4697, -792.6687, 1084.0500, 180}, interior=5, time=240},
	}
	
	HideNSeek.selectedMap = false 
	HideNSeek.seekers = false
	addCommandHandler(HideNSeek.cmd, HideNSeek.entry)
end

function HideNSeek.stop()
	
end

function HideNSeek.start()
	HideNSeek.selectedMap = math.random(1, #HideNSeek.maps)
	
	HideNSeek.time = HideNSeek.maps[HideNSeek.selectedMap].time*1000 
	
	local players = getPlayersInTeam(HideNSeek.team)
	
	local seekerAmount = math.ceil(#players/10)
	HideNSeek.seekers = {}
	for i=1, seekerAmount do 
		randomSeeker = math.random(1, #players)
		table.insert(HideNSeek.seekers, players[randomSeeker])
	end 
	
	for k,v in ipairs(players) do 
		removePedFromVehicle(v)
		fadeCamera(v, false)
		
		local isSeaker = false 
		for _, seeker in ipairs(HideNSeek.seekers) do 
			if seeker == v then 
				isSeaker = true 
			end 
		end 
		
		setTimer(HideNSeek.spawnPlayer, 1500, 1, v, isSeaker)
	end 
	
	setTimer(function()
		for k,v in ipairs(HideNSeek.seekers) do 
			triggerClientEvent(v, "onClientAddNotification", v, "Jesteś szukającym. Zostaniesz uwolniony za 30 sekund.", "info", 30000)
		end 
		
		for k,v in ipairs(getPlayersInTeam(HideNSeek.team)) do 
			triggerEvent("playAttractionMusic", v, v, "fun")
			
			local isSeaker = false 
			for _, seeker in ipairs(HideNSeek.seekers) do 
				if seeker == v then 
					isSeaker = true 
				end 
			end 
			
			if not isSeaker then 
				setElementFrozen(v, false)
			end 
			
			triggerClientEvent(v, "onClientHideNSeekStart", v, HideNSeek.time, isSeaker, HideNSeek.seekers)
		end
	end, HideNSeek.timeout, 1)
	
	addEventHandler("onPlayerWasted", root, HideNSeek.onWasted)
	addEventHandler("onPlayerQuit", root, HideNSeek.onSeekerQuit)
	
	HideNSeek.finishTimer = setTimer(HideNSeek.finish, HideNSeek.time+HideNSeek.timeout, 1)
end 

function HideNSeek.onWasted()
	if getPlayerTeam(source) == HideNSeek.team then 
		triggerClientEvent(source, "onClientFinishHideNSeek", source)
		setPlayerTeam(source, nil)
		takeAllWeapons(source)
		triggerEvent("stopAttractionMusic", source, source)
		fadeCamera(source, false)
		setTimer(function(player)
			exports["ms-gameplay"]:ms_spawnPlayer(player)
		end, 1500, 1, source)
		
		if #getPlayersInTeam(HideNSeek.team) == #HideNSeek.seekers then 
			HideNSeek.finish()
		end
	end
end 

function HideNSeek.onSeekerQuit(quitType)
	for k,v in ipairs(HideNSeek.seekers) do
 		if source == v then 
		
			if quitType == "Quit" then 
				exports["ms-admin"]:banMSPlayer(source, false, 60*60, "Wyjście podczas atrakcji chowany.")
				setTimer(HideNSeek.finish, 100, 1, true)
			end
			
			return
		end
	end
end 

function HideNSeek.spawnPlayer(player, seeker)
	setElementFrozen(player, true)
	setElementDimension(player, 69)
	setElementInterior(player, HideNSeek.maps[HideNSeek.selectedMap].interior)
	takeAllWeapons(player)
	
	if seeker then 
		setTimer(function(player)
			fadeCamera(player, true)
			setElementFrozen(player, false)
			toggleControl(player, "fire", true)
		end, 30000, 1, player)
		
		local pos = HideNSeek.maps[HideNSeek.selectedMap].sz 
		setElementPosition(player, pos[1], pos[2], pos[3])
		setElementRotation(player, 0, 0, pos[4])
		
		giveWeapon(player, 27, 99999)
		giveWeapon(player, 38, 99999)
		
		toggleControl(player, "fire", false)
	else 
		fadeCamera(player, true)
		local pos = HideNSeek.maps[HideNSeek.selectedMap].ch 
		setElementPosition(player, pos[1]+math.random(1,3)/10, pos[2]+math.random(1,3)/10, pos[3]+math.random(1,3)/10)
		setElementRotation(player, 0, 0, pos[4])
	end
end 

function HideNSeek.finish(seekerQuit)
	Core.endAttraction(HideNSeek)
	
	local players = getPlayersInTeam(HideNSeek.team)
	for k,v in ipairs(players) do 
		triggerEvent("stopAttractionMusic", v, v)
		triggerClientEvent(v, "onClientFinishHideNSeek", v)
		setPlayerTeam(v, nil)
		takeAllWeapons(v)
		fadeCamera(v, false)
		setTimer(function(player)
			if not isPedDead(player) then -- jest w killcamie 
				exports["ms-gameplay"]:ms_spawnPlayer(player)
			end
		end, 1500, 1, v)
		if seekerQuit then 
			triggerClientEvent(v, "onClientAddNotification", v, "Chowany przerwany z powodu wyjścia z gry szukającego.", "warning")
		else 
			local isSeeker = false 
			for _, seeker in ipairs(HideNSeek.seekers) do 
				if seeker == v then 
					isSeeker = true 
				end
			end
			
			if isSeeker then 
				if #players > #HideNSeek.seekers then 
					triggerClientEvent(v, "onClientAddNotification", v, "Nie udało się tobie znaleźć wszystkich graczy.", "info")
				else 
					if getElementData(v, "player:premium") then
						triggerClientEvent(v, "onClientAddNotification", v, "Wygrałeś chowanego! Otrzymujesz ".. math.floor(HideNSeek.money + HideNSeek.money * 0.3) .."$ oraz ".. math.floor(HideNSeek.exp + HideNSeek.exp * 0.3) .." exp", "info")
					else
						triggerClientEvent(v, "onClientAddNotification", v, "Wygrałeś chowanego! Otrzymujesz ".. HideNSeek.money .."$ oraz ".. HideNSeek.exp .." exp", "info")
					end
					triggerEvent("addPlayerStats", v, v, "player:hide_wins", 1)
					exports["ms-gameplay"]:msGiveMoney(v, HideNSeek.money)
					exports["ms-gameplay"]:msGiveExp(v, HideNSeek.exp)
				end 
			else 
				if getElementData(v, "player:premium") then
					triggerClientEvent(v, "onClientAddNotification", v, "Wygrałeś chowanego! Otrzymujesz ".. math.floor(HideNSeek.money + HideNSeek.money * 0.3) .."$ oraz ".. math.floor(HideNSeek.exp + HideNSeek.exp * 0.3) .." exp", "info")
				else
					triggerClientEvent(v, "onClientAddNotification", v, "Wygrałeś chowanego! Otrzymujesz ".. HideNSeek.money .."$ oraz ".. HideNSeek.exp .." exp", "info")
				end
				triggerEvent("addPlayerStats", v, v, "player:hide_wins", 1)
				exports["ms-gameplay"]:msGiveMoney(v, HideNSeek.money)
				exports["ms-gameplay"]:msGiveExp(v, HideNSeek.exp)
			end
		end
	end

	removeEventHandler("onPlayerQuit", root, HideNSeek.onSeekerQuit)
	removeEventHandler("onPlayerWasted", root, HideNSeek.onWasted)
	HideNSeek.selectedMap = nil
	HideNSeek.seekers = nil
	HideNSeek.time = nil 
	
	if isTimer(HideNSeek.finishTimer) then killTimer(HideNSeek.finishTimer) end
end 

function HideNSeek.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
		
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..HideNSeek.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= HideNSeek.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..HideNSeek.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(HideNSeek) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..HideNSeek.cmd, attractionStart)
	setElementData(player, "player:attraction", HideNSeek.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..HideNSeek.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == HideNSeek.minPlayers then 
		Core.initAttraction(HideNSeek)
	end
end 
