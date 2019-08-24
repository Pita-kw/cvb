US = {}  

-- load()
-- wykonuje sie w onResourceStart
function US.load()
	US.name = "Uważaj, spadasz!"
	US.team = createTeam(US.name, 255, 255, 255)
	US.cmd = "us"
	US.entriesTime = 30000 -- czas zapisów w milisekundach
	
	US.money = 1000
	US.exp = 10
	
	US.minPlayers = 4
	US.maxPlayers = 25
	
	US.waitTimeout = 7500 
	US.boardFallTime = 350 
	
	US.rows = 15 
	US.columns = 10
	
	US.platformCount = 0 
	US.objects = {} 
	
	setElementData(resourceRoot, "us:objects_count", 0)
	addCommandHandler(US.cmd, US.entry)

end

function US.stop()
	
end

function US.start()
	for i = 1,US.rows do 
		for j = 1, US.columns do
			local obj = createObject ( 1697, 1540.122926 + 4.466064 * j, -1317.568237 + 5.362793 * i, 603.105469, math.deg( 0.555 ), 0, 0 )
			setElementDimension(obj, 69)
			table.insert(US.objects, obj)
		end
	end
	
	US.platformCount = #US.objects
	setElementData(resourceRoot, "us:objects_count", US.platformCount)
	
	for k,v in ipairs(getPlayersInTeam(US.team)) do 
		fadeCamera(v, false)
		removePedFromVehicle(v)
		setTimer(US.spawnPlayer, 1500, 1, v) 
	end 
	
	setTimer(function()
		for k,v in ipairs(getPlayersInTeam(US.team)) do 
			setElementFrozen(v, false)
			triggerClientEvent(v, "onClientStartUS", v)
		end
		US.boardFall()
		
			
		US.checkTimer = setTimer(US.check, 200, 0)
	end, US.waitTimeout, 1)
	
	addEventHandler("onPlayerWasted", root, US.onWasted)
end 

function US.boardFall()
	if #US.objects > 0 then 
		local randomObject = math.random(1, #US.objects)
		local object = US.objects[randomObject]
		table.remove(US.objects, randomObject)
		
		for k,v in ipairs(getPlayersInTeam(US.team)) do 
			triggerClientEvent(v, "onClientShakeBoard", v, object)
		end 
		
		local x, y = getElementPosition (object)
	    local rx, ry, rz = math.random(0, 360), math.random(0, 360), math.random(0, 360)
		if rx < 245 then rx = -(rx + 245) end 
		if ry < 245 then ry = -(ry + 245) end
		if rz < 245 then rz = -(rz + 245) end
		setTimer(function() 
			moveObject(object, 10000, x, y, 404, rx, ry, rz)
			
			US.platformCount = US.platformCount-1
			setElementData(resourceRoot, "us:objects_count", US.platformCount)
		end, 2500, 1) 
		
		setTimer(destroyElement, 8000, 1, object)
		
		setTimer(US.boardFall, US.boardFallTime, 1)
	end
end 

function US.check()
	local players = getPlayersInTeam(US.team)
	for k,v in ipairs(players) do 
		local x,y,z = getElementPosition(v)
		if z < 590 then 
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientStopUS", v)
			fadeCamera(v, false)
			setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 1500, 1, v)
			triggerEvent("stopAttractionMusic", v, v)
		end
	end
	
	if #players <= 1 then 
		US.finish()
	end
end 

function US.onWasted()
	if getPlayerTeam(source) == US.team then 
		setPlayerTeam(source, nil)
		triggerClientEvent(source, "onClientStopUS", source)
		fadeCamera(source, false)
		triggerEvent("stopAttractionMusic", source, source)
		setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 1500, 1, source)
	end
end 

function US.spawnPlayer(player)
	fadeCamera(player, true)
	setElementFrozen(player, true)
	setElementDimension(player, 69)
	triggerEvent("playAttractionMusic", player, player, "fun")
	
	spawningBoard = math.random(1, #US.objects)
	local x, y, z = getElementPosition(US.objects[spawningBoard])
	changex = math.random (0,1)
	changey = math.random (0,1)
	if changex == 0 then
		x = x - math.random (0,200)/100
	elseif changex == 1 then
		x = x + math.random (0,200)/100
	end
	if changey == 0 then
		y = y - math.random (0,200)/100
	elseif changey == 1 then
		y = y + math.random (0,200)/100
	end				
	spawnAngle = 360 - math.deg( math.atan2 ( (1557.987182 - x), (-1290.754272 - y) ) )
	setElementPosition(player, x, y, 607.105469)
	setElementRotation(player, 0, 0, spawnAngle)
end 

function US.finish()
	Core.endAttraction(US)
	
	for k,v in ipairs(US.objects) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end
	US.objects = {} 
	
	local players = getPlayersInTeam(US.team)
	if #players == 1 then 
		local winner = players[1]
		if isElement(winner) then 
			triggerClientEvent(root, "onClientAddNotification", root, getPlayerName(winner).." wygrywa Uważaj Spadasz! (/us)", {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-attractions/cup.png"}, 15000)
			if getElementData(winner, "player:premium") then
				triggerClientEvent(winner, "onClientAddNotification", winner, "Wygrywasz Uważaj Spadasz! Otrzymujesz ".. math.floor(US.money + US.money * 0.3) .."$ oraz ".. math.floor(US.exp + US.exp * 0.3) .." exp", "success", 10000)
			else
				triggerClientEvent(winner, "onClientAddNotification", winner, "Wygrywasz Uważaj Spadasz! Otrzymujesz ".. US.money .."$ oraz ".. US.exp .." exp", "success", 10000)
			end
			triggerEvent("addPlayerStats", winner, winner, "player:us_wins", 1)
			exports["ms-gameplay"]:msGiveMoney(winner, US.money)
			exports["ms-gameplay"]:msGiveExp(winner, US.exp)
			triggerClientEvent(winner, "onClientStopUS", winner)
			setPlayerTeam(winner, nil)
			fadeCamera(winner, false)
			triggerEvent("stopAttractionMusic", winner, winner)
			setTimer(function(player) exports["ms-gameplay"]:ms_spawnPlayer(player) end, 1500, 1, winner)
		end 
	end 
	
	if isTimer(US.checkTimer) then 
		killTimer(US.checkTimer)
	end 
	
	removeEventHandler("onPlayerWasted", root, US.onWasted)
	
	US.platformCount = 0 
end

function US.entry(player)
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..US.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= US.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..US.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(US) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..US.cmd, attractionStart)
	setElementData(player, "player:attraction", US.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..US.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == US.minPlayers then 
		Core.initAttraction(US)
	end
end 