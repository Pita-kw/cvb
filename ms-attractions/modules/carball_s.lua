Carball = {} 

function Carball.load()
	Carball.name = "Carball"
	Carball.team = createTeam(Carball.name, 255, 255, 255)
	Carball.cmd = "cb"
	Carball.entriesTime = 30000 -- czas zapisów w milisekundach
	Carball.money = 1200
	Carball.exp = 12
	
	Carball.minPlayers = 6
	Carball.maxPlayers = 18
	Carball.time = 60000*5 -- czas maks
	
	Carball.waitTimeout = 8000 
	
	Carball.balls = {}
	Carball.lastHit =  0
	Carball.lastGoal = 0 
	Carball.lastHop = 0
	
	Carball.spawns = {
		["red"] = {
			{-3542.0634765625, -1133.7451171875, 501.0390625, 164.31677246094},
			{-3518.3525390625, -1141.0458984375, 501.0390625, 162.80065917969},
			{-3565.1875, -1128.955078125, 501.0390625, 163.93774414062},
			{-3560.515625, -1113.7412109375, 501.0390625, 165.45385742188},
			{-3537.638671875, -1118.9716796875, 501.0390625, 163.55871582031},
			{-3513.443359375, -1125.611328125, 501.0390625, 161.66351318359},
			{-3508.603515625, -1111.0126953125, 501.0390625, 162.80065917969},
			{-3532.9814453125, -1103.94140625, 501.0390625, 164.69580078125},
			{-3555.9775390625, -1098.0947265625, 501.0390625, 163.55871582031},
		},
		
		["blue"] = {
			{-3558.47265625, -1189.419921875, 501.0390625, 343.65484619141},
			{-3580.853515625, -1183.0322265625, 501.0390625, 344.03936767578},
			{-3535.048828125, -1195.669921875, 501.0390625, 344.03387451172},
			{-3538.9912109375, -1209.34375, 501.0390625, 343.65484619141},
			{-3562.5908203125, -1203.2333984375, 501.0390625, 343.27581787109},
			{-3585.4013671875, -1198.0869140625, 501.0390625, 342.8967590332},
			{-3590.3359375, -1212.9404296875, 501.0390625, 344.41839599609},
			{-3567.052734375, -1218.0625, 501.0390625, 344.41839599609},
			{-3543.5947265625, -1225.2109375, 501.0390625, 344.41839599609},
		},
	}
	
	Carball.vehicles = {} 
	
	Carball.redCol = createColPolygon(-3513.48,-1024.61, -3497.23,-1021.0, -3500.72,-1032.75, -3527.51,-1025.82, -3524.83,-1013.92)
	setElementDimension(Carball.redCol, 69)
	
	Carball.blueCol =  createColPolygon(-3587.20,-1299.69, -3602.23,-1302.88, -3598.98,-1290.63, -3571.33,-1298.16, -3574.64,-1310.07)
	setElementDimension(Carball.blueCol, 69)
	
	addEvent("onPlayerHitCarball", true)
	addEventHandler("onPlayerHitCarball", root, Carball.onHit)
	
	addEvent("onPlayerSyncCarball", true)
	addEventHandler("onPlayerSyncCarball", root, Carball.onSyncerUpdate)
	
	addEvent("onCarballGoal", true)
	addEventHandler("onCarballGoal", root, Carball.goal)
	
	addEvent("onCarballVehicleJump", true)
	addEventHandler("onCarballVehicleJump", root, Carball.onVehicleJump)
	
	addCommandHandler(Carball.cmd, Carball.entry)
end 

function Carball.stop()

end 

function Carball.onHit(hitElement, x, y, z, nx, ny, nz)
	setElementPosition(hitElement, x, y, z)
	setElementVelocity(hitElement, nx, ny, nz)
	
	Carball.lastHit = getTickCount()
end 

function Carball.onSyncerUpdate(ball, x, y, z)
	setElementPosition(ball, x, y, z)
end 

function Carball.onVehicleJump(x, y, z)
	setElementVelocity(source, x, y, z)
end 

function Carball.goal(team)
	local now = getTickCount() 
	if Carball.lastGoal+10000 > now then 
		return
	end 
	
	Carball.lastGoal = now
	
	local players = getPlayersInTeam(Carball.team)
	for k, v in ipairs(players) do 
		triggerClientEvent(v, "onClientAddNotification", v, "Drużyna "..(team == "red" and "czerwonych" or "niebieskich").." zdobywa bramkę! Respawn za moment.", {type=(team == "red" and "error" or "info"), custom="image", x=0, y=0, w=40, h=40, image=":ms-attractions/modules/files/ball.png"}, 8000, false)
	end 
	
	local points = getElementData(resourceRoot, "carball:points_"..team)
	setElementData(resourceRoot, "carball:points_"..team, points+1)
	
	setTimer(function()
		for k, v in ipairs(getPlayersInTeam(Carball.team)) do 
			local veh = getPedOccupiedVehicle(v)
			if veh then
				setElementFrozen(veh, true)
				setTimer(setElementFrozen, 2000, 1, veh, false)
				respawnVehicle(veh)
			end
		end
			
		setElementPosition(Carball.balls[1].object, -3549.65,-1161.76,504)
	end, 4000, 1)
	
	for k, v in ipairs(getPlayersInTeam(Carball.team)) do 
		triggerClientEvent(v, "onClientGetGoalCarball", v)
	end
end 

function Carball.spawnPlayer(player)
	local team = getElementData(player, "player:carball_team") 
	if team == "red" then 
		local x, y, z = Carball.spawns["red"][Carball.redCount][1], Carball.spawns["red"][Carball.redCount][2], Carball.spawns["red"][Carball.redCount][3]
		local rot = Carball.spawns["red"][Carball.redCount][4] 
			
		local vehicle = createVehicle(495, x, y, z+0.5)
		addEventHandler("onVehicleStartExit", vehicle, function() cancelEvent() end)
		setTimer(setElementData, 100, 1, vehicle, "vehicle:job", "carball")
		setElementDimension(vehicle, 69)
		setElementRotation(vehicle, 0, 0, rot)
		setElementFrozen(vehicle, true)
		setVehicleColor(vehicle, 231, 76, 60, 231, 76, 60)
		warpPedIntoVehicle(player, vehicle)
		
		setVehicleRespawnPosition(vehicle, x, y, z+0.5, 0, 0, rot)
		
		table.insert(Carball.vehicles, vehicle)
	elseif team == "blue" then 
		local x, y, z = Carball.spawns["blue"][Carball.blueCount][1], Carball.spawns["blue"][Carball.blueCount][2], Carball.spawns["blue"][Carball.blueCount][3]
		local rot = Carball.spawns["blue"][Carball.blueCount][4]
			
		local vehicle = createVehicle(495, x, y, z+0.5)
		addEventHandler("onVehicleStartExit", vehicle, function() cancelEvent() end)
		setElementDimension(vehicle, 69)
		setTimer(setElementData, 100, 1, vehicle, "vehicle:job", "carball")
		setElementRotation(vehicle, 0, 0, rot)
		setElementFrozen(vehicle, true)
		setVehicleColor(vehicle, 52, 152, 219, 52, 152, 219)
		warpPedIntoVehicle(player, vehicle)
		
		setVehicleRespawnPosition(vehicle, x, y, z+0.5, 0, 0, rot)
		
		table.insert(Carball.vehicles, vehicle)
	end 
	
	setTimer(fadeCamera, 100, 1, player, true)
	setElementDimension(player, 69)
	triggerClientEvent(player, "onClientLoadCarball", player, Carball.time)
	
	setTimer(function(player)
		triggerClientEvent(player, "onClientStartCarball", player)
	end, Carball.waitTimeout, 1, player)
end 

function Carball.createBall(x, y, z)
	local obj = createVehicle(457, x, y, z)
	setVehicleHandling(obj, "mass", 250)
	setVehicleHandling(obj, "maxVelocity", 2000)
	setVehicleHandling(obj, "brakeDeceleration", 0)
	setVehicleHandling(obj, "brakeBias", 0)
	setVehicleHandling(obj, "tractionMultiplier", 100)
	setVehicleHandling(obj, "suspensionDamping", 100)
	setVehicleHandling(obj, "suspensionForceLevel", 0)
	setVehicleHandling(obj, "turnMass", 250)
	setVehicleHandling(obj, "tractionLoss", 0)
	setElementAlpha(obj, 0)
	setVehicleDamageProof(obj, true)
	setElementDimension(obj, 69)
	setElementData(obj, "carball:ball", true)
	setElementVelocity(obj, 0, 0, 0)
	
	local ball = createBlipAttachedTo(obj, 1)
	setElementData(ball, "blipIcon", "ball")
	setElementData(ball, "exclusive", true)
	table.insert(Carball.balls, {object=obj, blip=ball})
end 

function Carball.update()
	if not Carball.balls[1] then return end 
	local now = getTickCount()
	if now > Carball.lastHit+10000 then 
		setElementPosition(Carball.balls[1].object, -3549.65,-1161.76,504)
		Carball.lastHit = now+60000*100
	end
	
	local x, y, z = getElementPosition(Carball.balls[1].object)
	if z < 509 then
		-- był gol?
		if isElementWithinColShape(Carball.balls[1].object, Carball.blueCol) then 
			Carball.goal("red")
		end
				
		if isElementWithinColShape(Carball.balls[1].object, Carball.redCol) then 
			Carball.goal("blue")
		end
	end 
	
	setElementData(Carball.balls[1].object, "ball:syncer", getElementSyncer(Carball.balls[1].object))
end

function Carball.start()
	Carball.redCount = 0 
	Carball.blueCount = 0 
	
	local players = getPlayersInTeam(Carball.team)
	local lastSpawnedTeam = "red"
	for k,v in ipairs(players) do 
		if not isPedDead(v) then 
			if lastSpawnedTeam == "blue" then 
				setElementData(v, "player:carball_team", "red")
				setPlayerNametagColor(v, 231, 76, 60)
				lastSpawnedTeam = "red"
				Carball.redCount = Carball.redCount+1
			elseif lastSpawnedTeam == "red" then 
				setElementData(v, "player:carball_team", "blue")
				setPlayerNametagColor(v, 52, 152, 219)
				lastSpawnedTeam = "blue"
				Carball.blueCount = Carball.blueCount+1
			end
			
			fadeCamera(v, false, 1)
			Carball.spawnPlayer(v)
			
			setTimer(function(player)
				triggerEvent("playAttractionMusic", player, player, "derby")
			end, 1000, 1, v)
		else 
			setPlayerTeam(v, nil)
			triggerClientEvent(v, "onClientAddNotification", v, "Nie zostałeś przeniesiony na atrakcję "..Carball.name..", bo nie żyjesz.", "error")
		end
	end
	
	setElementData(resourceRoot, "carball:points_red", 0)
	setElementData(resourceRoot, "carball:points_blue", 0)
	
	Carball.redBlip = createBlip(-3513.48,-1024.61, 500)
	setElementDimension(Carball.redBlip, 69)
	setElementData(Carball.redBlip, "blipIcon", "target")
	setElementData(Carball.redBlip, "blipSize", 10)
	setElementData(Carball.redBlip, "blipColor", {231, 76, 60})
	
	Carball.blueBlip = createBlip(-3587.20,-1299.69, 500)
	setElementDimension(Carball.blueBlip, 69)
	setElementData(Carball.blueBlip, "blipIcon", "target")
	setElementData(Carball.blueBlip, "blipSize", 10)
	setElementData(Carball.blueBlip, "blipColor", {52, 152, 219})
	
	Carball.createBall(-3549.65,-1161.76,504)
		
	setTimer(Carball.finish, Carball.time, 1)
	
	Carball.updateTimer = setTimer(Carball.update, 50, 0)
end  

function Carball.finish()
	Core.endAttraction(Carball)
	
	local redPoints = getElementData(resourceRoot, "carball:points_red") or 0 
	local bluePoints = getElementData(resourceRoot, "carball:points_blue") or 0 
	local winner = "draw"
	if redPoints > bluePoints then 
		winner = "red"
	elseif bluePoints > redPoints then
		winner = "blue"
	end 
	
	local players = getPlayersInTeam(Carball.team)
	for k, v in ipairs(players) do 
		exports["ms-auth"]:restorePlayerNametagColor(v)
		fadeCamera(v, false)
		
		local playerTeam = getElementData(v, "player:carball_team")
		if winner == "draw" then 
			triggerClientEvent(v, "onClientAddNotification", v, "Carball zakończony remisem.", "info")
		elseif winner == playerTeam then 
			if getElementData(v, "player:premium") then
				triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna wygrała Carball! Otrzymujesz ".. math.floor(Carball.money + Carball.money * 0.3) .."$ oraz ".. math.floor(Carball.exp + Carball.exp * 0.3) .." exp ", "success")
			else
				triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna wygrała Carball! Otrzymujesz ".. Carball.money .."$ oraz ".. Carball.exp .." exp ", "success")
			end
			
			triggerEvent("addPlayerStats", v, v, "player:cb_wins", 1)
			exports["ms-gameplay"]:msGiveMoney(v, Carball.money)
			exports["ms-gameplay"]:msGiveExp(v, Carball.exp)
			
		elseif winner ~= playerTeam then  
			triggerClientEvent(v, "onClientAddNotification", v, "Twoja drużyna przegrała Carball! Nie otrzymujesz żadnej nagrody.", "error")
		end 
		
		setTimer(function(v)
			setPlayerTeam(v, nil)
			triggerEvent("stopAttractionMusic", v, v)
			
			setElementDimension(v, 0)
			exports["ms-gameplay"]:ms_spawnPlayer(v)
		end, 1000, 1, v)
	end

	for k, v in ipairs(Carball.balls) do 
		destroyElement(v.object)
		destroyElement(v.blip)
	end
	Carball.balls = {}
	
	for k, v in ipairs(Carball.vehicles) do 
		destroyElement(v)
	end 
	Carball.vehicles = {} 
	
	if isTimer(Carball.updateTimer) then 
		killTimer(Carball.updateTimer)
	end
	
	destroyElement(Carball.redBlip)
	destroyElement(Carball.blueBlip)
end 

function Carball.entry(player)
	if true then 
		triggerClientEvent(player, "onClientAddNotification", player, "Trwają pracę techniczne nad tą zabawą.", "warning", 7000)
		return
	end 
	
	if not getElementData(player, "player:spawned") then return end 
	if getPlayerTeam(player) then return end 
	
	local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..Carball.cmd) or {} 
	local onAttraction = getElementData(player, "player:attraction")
	
	if onAttraction then
		triggerClientEvent(player, "onClientAddNotification", player, "Już jesteś zapisany/a na atrakcję "..onAttraction..". By się wypisać, wpisz /wypisz.", "warning", 10000)
		return 
	end
	
	if #attractionStart >= Carball.maxPlayers then 
		triggerClientEvent(player, "onClientAddNotification", player, "Niestety atrakcja "..Carball.name.." nie ma już wolnych miejsc.", "error", 10000)
		return
	end 
	
	if Core.isAttractionRunning(Carball) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zapisy na tą atrakcję są zamknięte.", "error", 5000)
		return
	end 
	
	table.insert(attractionStart, player)
	setElementData(resourceRoot, "attraction:start_players_"..Carball.cmd, attractionStart)
	setElementData(player, "player:attraction", Carball.name)
	
	triggerClientEvent(player, "onClientAddNotification", player, "Zapisałeś/aś się na atrakcję "..Carball.name.." pomyślnie. Czekaj na rozpoczęcie.", "success", 10000)
	
	if #attractionStart == Carball.minPlayers then 
		Core.initAttraction(Carball)
	end
end 