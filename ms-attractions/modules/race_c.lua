Race = {} 

function Race.load()
	Race.checkpoints = {}
	Race.players = {}
	
	addEventHandler("onClientPlayerWasted", localPlayer, function() 
		if getPlayerTeam(localPlayer) == getTeamFromName("Race") then 
			if #Race.checkpoints > 0 then 
				Race.finish(true)
			end
		end
	end)
	
	addEvent("onClientFinishRace", true)
	addEventHandler("onClientFinishRace", root, function(isDead)
		Race.finish(isDead)
	end)
	
	Race.cmd = "rc"
	Race.team = getTeamFromName("Race")
end

function Race.stop()
end 

function Race.updateRank()
	local players = #Race.players
	
	local rank = 1 
	local myCP = getElementData(localPlayer, "player:race_checkpoint") or 0 
	
	for k,v in ipairs(Race.players) do
		if isElement(v) then 
			if v ~= localPlayer then 
				local enemyCP = getElementData(v, "player:race_checkpoint") or 0 
				if enemyCP > myCP then -- gracz skonczyl albo wiekszy checkpoint 
					rank = rank+1
				elseif enemyCP == myCP then 
					local checkpointMarker = Race.checkpoints[enemyCP] or Race.checkpoints[#Race.checkpoints]
					local x,y,z = checkpointMarker.x, checkpointMarker.y, checkpointMarker.z
					local myX, myY, myZ = getElementPosition(localPlayer)
					local enemyX, enemyY, enemyZ = getElementPosition(v)
					if (getPlayerTeam(v) and getDistanceBetweenPoints3D(x, y, z, enemyX, enemyY, enemyZ) < getDistanceBetweenPoints3D(x, y, z, myX, myY, myZ)) then 
						rank = rank+1
					end
				end
			end
		else 
			table.remove(Race.players, k)
		end
	end 
	
	rank = rank
	setElementData(localPlayer, "player:race_rank", rank)
end 

function Race.createNextCheckpoint() 
	Race.currentCheckpoint = Race.currentCheckpoint+1
	if isElement(Race.marker) then 
		destroyElement(Race.marker)
	end 
	
	if isElement(Race.blip) then 
		destroyElement(Race.blip)
	end 
	
	setElementData(localPlayer, "player:race_checkpoint", Race.currentCheckpoint)
	
	local checkpoint = Race.checkpoints[Race.currentCheckpoint]
	if checkpoint then 
		local rx, ry, rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
		Race.checkpoints[Race.currentCheckpoint].rotation = rz 
		
		Race.marker = createMarker(checkpoint.x, checkpoint.y, checkpoint.z, "checkpoint", 8, 52, 152, 219, 120)
		Race.blip = createBlip(checkpoint.x, checkpoint.y, checkpoint.z, 19, 2, 52, 152, 219, 255)
		setElementData(Race.blip, "blipIcon", "mission_target")
		setElementData(Race.blip, "blipSize", 20)
		setElementData(Race.blip, "exclusiveBlip", true)
		
		local nextCheckpoint = Race.checkpoints[Race.currentCheckpoint+1]
		if nextCheckpoint then 
			setMarkerTarget(Race.marker, nextCheckpoint.x, nextCheckpoint.y, nextCheckpoint.z)
			setMarkerIcon(Race.marker, "arrow")
		else 
			setMarkerIcon(Race.marker, "finish")
			setElementData(Race.blip, "blipIcon", "flag")
		end 
		
		setElementDimension(Race.marker, 69)
		setElementDimension(Race.blip, 69)
		addEventHandler("onClientMarkerHit", Race.marker, function(hitPlayer, matchingDimension)
			if hitPlayer == localPlayer and source == Race.marker and matchingDimension then 
				Race.createNextCheckpoint()
			end
		end)
		
		playSoundFrontEnd(43)
	else 
		playSoundFrontEnd(45)
		Race.finish()
	end
end 

function Race.respawn()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end 
	
	if Race.respawnTick > getTickCount() then 
		local time = math.ceil(((Race.respawnTick-getTickCount())/1000))
		triggerEvent("onClientAddNotification", localPlayer, "Następny respawn dostępny za "..tostring(time).."s.", "warning", 2500)
		return 
	end 
	
	local checkpoint = Race.checkpoints[Race.currentCheckpoint-1]
	if not checkpoint then return end 
	
	setElementVelocity(veh, 0, 0, 0)
	setElementPosition(veh, checkpoint.x, checkpoint.y, checkpoint.z+1)
	setElementRotation(veh, 0, 0, checkpoint.rotation)
	
	triggerServerEvent("onPlayerRaceRespawn", localPlayer)
	
	triggerEvent("onClientAddNotification", localPlayer, "Zrespawnowałeś się pomyślnie.", "info")
	Race.respawnTick = getTickCount()+30000
end 

function Race.finish(isDead)
	if Race.checkpoints == nil then return end 
	
	if isElement(Race.marker) then 
		destroyElement(Race.marker)
	end 
	
	if isElement(Race.blip) then 
		destroyElement(Race.blip)
	end 
	
	removeEventHandler("onClientRender", root, Race.renderHUD)
	Race.players = {}
	Race.countdown = nil 
	Race.checkpoints = nil
	Race.currentCheckpoint = nil 
	Race.godModeEnabled = nil
	Race.ghostModeEnabled = nil
	Race.countdown = nil
	Race.startTick = nil 
	Race.respawnTick = nil 
	
	unbindKey("enter", "down", Race.respawn)
	
	setTimer(Core.unloadCustomScript, 1000, 1)
	
	fadeCamera(false, 1)
	setTimer(triggerServerEvent, 1200, 1, "onPlayerFinishRace", localPlayer, isDead)
end 

function Race.godMode(vehicle)
	addEventHandler("onClientVehicleDamage", vehicle, 
		function()
			cancelEvent()
		end)
end 

function Race.ghostMode(vehicle, toggle)
	if not vehicle then return end 
	
	for k, teamVehicle in ipairs(getElementsByType("vehicle", resourceRoot)) do 
		setElementCollidableWith(vehicle, teamVehicle, not toggle)
		if vehicle ~= teamVehicle then 
			setElementAlpha(teamVehicle, 200)
		else 
			setElementAlpha(teamVehicle, 255)
		end
	end
end 
addEvent("onClientRaceSetGhostmode", true)
addEventHandler("onClientRaceSetGhostmode", root, Race.ghostMode)

function Race.respawnGhostMode()
	if isElement(source) then 
		local requestedVehicle = getPedOccupiedVehicle(source)
		setTimer(function() 
			local alpha = getElementAlpha(requestedVehicle)
			if alpha == 180 then 
				setElementAlpha(requestedVehicle, 255)
			else 
				setElementAlpha(requestedVehicle, 180)
			end
		end, 300, 10)
	end
end
addEvent("onClientRaceRespawn", true)
addEventHandler("onClientRaceRespawn", root, Race.respawnGhostMode)

function Race.onPreLoad(script) 
	if script then 
		setTimer(Core.loadCustomScript, 1000, 1, script)
		Race.ghostMode(getPedOccupiedVehicle(localPlayer), true)
	end
end 
addEvent("onClientRacePreLoad", true)
addEventHandler("onClientRacePreLoad", root, Race.onPreLoad)

function Race.onStart(checkpoints, godMode, ghostMode)
	Race.countdown = 5 
	Race.checkpoints = checkpoints
	Race.currentCheckpoint = 0 
	Race.godModeEnabled = godMode
	Race.ghostModeEnabled = ghostMode 
	Race.players = getPlayersInTeam(getTeamFromName("Race"))
	Race.respawnTick = 0 
	
	playSoundFrontEnd(43)
	
	setTimer(function()
		Race.countdown = Race.countdown-1 
		if Race.countdown == 0 then 
			Race.createNextCheckpoint()
			
			playSoundFrontEnd(45)
			setTimer(function()
				Race.startTick = getTickCount()
				addEventHandler("onClientRender", root, Race.renderHUD)
				removeEventHandler("onClientRender", root, Race.renderCountdown)
				
				setTimer(function() bindKey("enter", "down", Race.respawn) end, 10000, 1)
			end, 1000, 1)
		else 
			playSoundFrontEnd(43)
		end
	end, 1000, Race.countdown)
	
	if Race.godModeEnabled then 
		local vehicle = getPedOccupiedVehicle(localPlayer)
		Race.godMode(vehicle)
	end 
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	Race.ghostMode(vehicle, ghostMode)
	
	triggerEvent("onClientAddNotification", localPlayer, "By się respawnować wciśnij ENTER.\n(dostępne po 10 sekundach od startu)", "info")
	addEventHandler("onClientRender", root, Race.renderCountdown)
end 
addEvent("onClientRaceStart", true)
addEventHandler("onClientRaceStart", root, Race.onStart)

local screenW, screenH = guiGetScreenSize() 
function Race.renderCountdown()
	local text = tostring(Race.countdown)
	if text == "0" then 
		text = "START!"
	end
	
	dxDrawText(text, (screenW/2)-1, (screenH/3)-1, (screenW/2)-1, (screenH/3)-1, tocolor(0, 0, 0, 255), 3.0, "default-bold", "center", "top", false, true, true)
	dxDrawText(text, screenW/2, screenH/3, screenW/2, screenH/3, tocolor(236, 240, 241, 255), 3.0, "default-bold", "center", "top", false, true, true)
end 

local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function Race.renderHUD()
	Race.updateRank()
	
	local time = getTickCount()-Race.startTick
		
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
	
	local min, sec, ms = msToTimeStr(time)
	if tonumber(min) > 10 then 
		Race.finish()
		triggerEvent("onClientAddNotification", localPlayer, "Czas na ukończenie wyścigu skończył się.", "info")
	end 
	
	dxDrawText(min..":"..sec.."."..ms, bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.9, Core.font, "center", "top", false, true, true)
	dxDrawText("Czas", bgPos.x, bgPos.y + 60/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.6, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(getElementData(localPlayer, "player:race_rank") or "?").."/"..tostring(#Race.players), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("pozycja", bgPos.x, bgPos.y + 60/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.45, Core.font, "center", "top", false, true, true)
	
	if Race.currentCheckpoint == #Race.checkpoints then 
		dxDrawText("Meta", bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	else 
		dxDrawText(tostring(Race.currentCheckpoint).."/"..tostring(#Race.checkpoints), bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	end 
	dxDrawText("punktów\nkontrolnych", bgPos.x+bgPos.w-90/zoom, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.4, Core.font, "center", "top", false, true, true)
end 

