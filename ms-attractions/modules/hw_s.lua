HunterWar = {}  

function HunterWar.load()
	HunterWar.name = "Wojna Hunterów"
	HunterWar.team = createTeam(HunterWar.name, 255, 255, 255)
	HunterWar.cmd = "hw"
	HunterWar.entriesTime = 30000 -- czas zapisów w milisekundach
	HunterWar.money = 2000
	HunterWar.exp = 20
	HunterWar.minPlayers = 6
	HunterWar.maxPlayers = 20
	HunterWar.time = 60000*5 -- czas maks wojny
	
	HunterWar.spawn = {x=-1000, y=-1000, z=500}
	HunterWar.vehicles = {} 
	
	addCommandHandler(HunterWar.cmd, HunterWar.entry)
end

function HunterWar.stop()

end

function HunterWar.start()
	local players = getPlayersInTeam(HunterWar.team)
	for k,v in ipairs(players) do 
		if not isPedDead(v) then 
			HunterWar.spawnPlayer(v)
		else 
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientAddNotification", v, "Nie zostałeś przeniesiony na atrakcję "..HunterWar.name.." bo nie żyjesz.", "error")
		end
	end 
	
	addEventHandler("onPlayerWasted", root, HunterWar.onWasted)
	
	setTimer(HunterWar.finish, HunterWar.time, 1)
end 

function HunterWar.finish()
	Core.endAttraction(HunterWar)
	
	local players = getPlayersInTeam(HunterWar.team)
	for k,v in ipairs(players) do
		fadeCamera(v, false)
		removePedFromVehicle(v)
		setTimer(function(player)
			triggerEvent("stopAttractionMusic", player, player)
			setPlayerTeam(player, nil)
			exports["ms-gameplay"]:ms_spawnPlayer(player)
			fadeCamera(player, true)
		end, 1000, 1, v)
	end
	
	if #players == 1 then 
		local winner = players[1]
		if getElementData(winner, "player:premium") then
			triggerClientEvent(winner, "onClientAddNotification", winner, "Wygrałeś wojną hunterów! Otrzymujesz ".. math.floor(HunterWar.money + HunterWar.money * 0.3) .."$ oraz ".. math.floor(HunterWar.exp + HunterWar.exp * 0.3) .." exp", "success")
		else
			triggerClientEvent(winner, "onClientAddNotification", winner, "Wygrałeś wojną hunterów! Otrzymujesz ".. HunterWar.money .."$ oraz ".. HunterWar.exp .." exp", "success")
		end
		triggerEvent("addPlayerStats", winner, winner, "player:wh_wins", 1)
		exports["ms-gameplay"]:msGiveMoney(winner, HunterWar.money)
		exports["ms-gameplay"]:msGiveExp(winner, HunterWar.exp)
	end 
	
	setTimer(function()
		for k,v in ipairs(HunterWar.vehicles) do 
			destroyElement(v)
		end
		HunterWar.vehicles = {}
	end, 1000, 1)
	
	removeEventHandler("onPlayerWasted", root, HunterWar.onWasted)
	
	if isTimer(HunterWar.checkTimer) then 
		killTimer(HunterWar.checkTimer)
	end 
end

function HunterWar.checkWinner() 
	local players = getPlayersInTeam(HunterWar.team)
	if #players <= 1 then 
		HunterWar.finish()
	end
end 

function HunterWar.spawnPlayer(player)
	local vehX, vehY, vehZ = HunterWar.spawn.x, HunterWar.spawn.y, HunterWar.spawn.z+math.random(1,50)
			
	local offset = math.random(1, 2)
	if offset == 1 then 
		vehX, vehY = vehX+math.random(1,300), vehY+math.random(1,300)
	else 
		vehX, vehY = vehX-math.random(1,300), vehY-math.random(1,300)
	end
	
	
	fadeCamera(player, false)
	setTimer(function(player)
		triggerEvent("playAttractionMusic", player, player, "war")
		local vehicle = createVehicle(425, vehX, vehY, vehZ, 0, 0, math.random(1, 360))
		setElementDimension(vehicle, 69)
		warpPedIntoVehicle(player, vehicle)
		
		setElementDimension(player, 69)
		fadeCamera(player, true)
		table.insert(HunterWar.vehicles, vehicle)
		
		triggerClientEvent(player, "onClientStartHunterWar", player, HunterWar.time, HunterWar.spawn)
	end, 1000, 1, player)
end 

function HunterWar.onWasted(totalAmmo, killer)
	if getPlayerTeam(source) == HunterWar.team then 
		setPlayerTeam(source, nil)
		fadeCamera(source, false)
		triggerEvent("stopAttractionMusic", source, source)
		triggerClientEvent(source, "onClientAddNotification", source, "Przegrałeś wojnę hunterów.", "error", 10000)
		HunterWar.checkWinner()
	end
end 

function HunterWar.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..HunterWar.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= HunterWar.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..HunterWar.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(HunterWar) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..HunterWar.cmd, attractionStart)
	setElementData(player, "player:attraction", HunterWar.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..HunterWar.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == HunterWar.minPlayers then 
		Core.initAttraction(HunterWar)
	end
end 
