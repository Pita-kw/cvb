local sx, sy = guiGetScreenSize()

local MARKER = false
local BLIP = false 
local OBJECTS = {} 

local bestPlacesTable = {}
local challengeDimension = 0 
local challengeTime = 0 
local countdown = 5 

function msToTimeStr(ms)
	if not ms then
		return ''
	end

	if ms < 0 then
		return "0","00","00"
	end

	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))

	return minutes, seconds, centiseconds
end

addEvent("onDatabaseRequest", true)
addEventHandler("onDatabaseRequest", resourceRoot, function(query, array)
	query = query or {} 
	array = array or {}
	challengeDimension = getElementData(localPlayer, "player:id")
	
	table.sort(query, function(x,y)
	  return x[2] < y[2]
	end)
	bestPlacesTable = query
	showChallengeWindow(true, {title=getElementData(localPlayer, "actual:challenge"), bestPlaces=query, lastPlaces=array})
end)

function getChallengePositionFromTime(time)
	local pos = 1 
	for k, v in ipairs(bestPlacesTable) do 
		if time > v[2] then 
			pos = pos+1 
		end
	end
	
	return pos 
end 

function drawPlayerTime()
	local st_tick = getElementData(localPlayer, "challenge:tick") or 0
	if st_tick then
		local lu_tick = getTickCount()
		local diff = lu_tick-st_tick
		local m, s, cs = msToTimeStr(diff)
		
		local x, y, w, h = exports["ms-hud"]:getInterfacePosition()
		local zoom = exports["ms-hud"]:getInterfaceZoom() 
		
		if not timeFont then 
			timeFont = dxCreateFont("f/archivo_narrow.ttf", 27/zoom) or "default-bold"
		end 
		
		exports["ms-gui"]:dxDrawBluredRectangle(x, y+220/zoom, w, 50/zoom, tocolor(220, 220, 220, 220, 255), true)
		dxDrawRectangle(x, y+270/zoom, w, 5/zoom, tocolor(51, 102, 255, 255), true)

		dxDrawImage(x, y+221/zoom, 45/zoom, 45/zoom, ":ms-hud/img/time.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)

		dxDrawText(m..":"..s..":"..cs, x+60/zoom, y+220/zoom, w, y+270/zoom, tocolor(255, 255, 255, 255), 0.73, timeFont, "left", "center", false, false, true)
		
		local rest = challengeTime - (getTickCount() - st_tick)
		local m, s, cs = msToTimeStr(rest)
		if rest <= 0 then 
			triggerEvent("onClientChallengeDone", localPlayer)
			triggerServerEvent("onChallengeFail", localPlayer)
			return 
		end 
		
		dxDrawText("| "..m..":"..s..":"..cs, x+150/zoom, y+220/zoom, w, y+270/zoom, tocolor(255, 255, 255, 255), 0.73, timeFont, "left", "center", false, false, true)
		
		dxDrawText("Pozycja: "..tostring(getChallengePositionFromTime(diff)), x+380/zoom, y+220/zoom, w, y+270/zoom, tocolor(255, 255, 255, 255), 0.73, timeFont, "left", "center", false, false, true)
	end
end

function renderCountdown()
	local screenW, screenH = sx, sy
	local text = tostring(countdown)
	if text == "0" then 
		text = "START!"
	end
	
	local height = dxGetFontHeight(3, "default-bold")
	dxDrawText(text, (screenW/2)-1, (screenH/2)-1-height, (screenW/2)-1, (screenH/2)-1-height, tocolor(0, 0, 0, 255), 3.0, "default-bold", "center", "top", false, true, true)
	dxDrawText(text, screenW/2, screenH/2-height, screenW/2, screenH/2-height, tocolor(236, 240, 241, 255), 3.0, "default-bold", "center", "top", false, true, true)
end 

currentCheckpoint = 0 
function createNextCheckpoint(el, dim)
	if el ~= localPlayer or not dim then return end 
	local x, y, z = getElementPosition(source)
	local px, py, pz = getElementPosition(el)
	if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 10 then return end 
	
	currentCheckpoint = currentCheckpoint+1 
	
	if isElement(MARKER) then 
		destroyElement(MARKER)
		MARKER = nil
	end 
	
	if isElement(BLIP) then 
		destroyElement(BLIP)
		BLIP = nil 
	end 
	
	if currentCheckpoint > #checkpoints then 
		onChallengeFinish(localPlayer)
		playSoundFrontEnd(45)
	else 
		MARKER = createMarker(checkpoints[currentCheckpoint][1], checkpoints[currentCheckpoint][2], checkpoints[currentCheckpoint][3], "checkpoint", 4.5, 128, 0, 0, 255)
		BLIP = createBlipAttachedTo(MARKER, 0)
	
		setElementData(BLIP, "blipIcon", "mission_target")
		setElementData(BLIP, "exclusiveBlip", true)
		
		setElementDimension(MARKER, challengeDimension)
		setElementDimension(BLIP, challengeDimension)
		addEventHandler("onClientMarkerHit", MARKER, createNextCheckpoint)
		playSoundFrontEnd(43)
	end
end 

addEvent("onTimeChallengeStart", true)
addEventHandler("onTimeChallengeStart", resourceRoot, function(cp, objects, passTime)
  if cp and objects and passTime then
	for k,v in ipairs(objects) do 
		local obj = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
		if obj then
			setElementDimension(obj, challengeDimension)
			table.insert(OBJECTS, obj)
		end
	end 
	
	setElementFrozen(localPlayer, true)
	
	challengeTime = passTime
	
    if not MARKER and not isElement(MARKER) then
		checkpoints = cp
		currentCheckpoint = 2 
		countdown = 5 
		addEventHandler("onClientRender", root, renderCountdown)

		setTimer(function()
			countdown = countdown-1 
			if countdown == 0 then 
				playSoundFrontEnd(45)
		
				MARKER = createMarker(checkpoints[currentCheckpoint][1], checkpoints[currentCheckpoint][2], checkpoints[currentCheckpoint][3], "checkpoint", 4.5, 128, 0, 0, 255)
				setElementDimension(MARKER, challengeDimension)
				
				BLIP = createBlipAttachedTo(MARKER, 0)
				setElementDimension(BLIP, challengeDimension)
				setElementData(BLIP, "blipIcon", "mission_target")
				setElementData(BLIP, "exclusiveBlip", true)
				
				setElementData(localPlayer, "challenge:tick", getTickCount())
				addEventHandler("onClientMarkerHit", MARKER, createNextCheckpoint)
				addEventHandler("onClientRender", root, drawPlayerTime)
				setTimer(function() removeEventHandler("onClientRender", root, renderCountdown) end, 1000, 1)
				if isPedInVehicle(localPlayer) then 
					setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
				end 
				setElementFrozen(localPlayer, false)
			else 
				playSoundFrontEnd(43)
			end
		end, 1000, countdown)
    end
  end
end)

function onChallengeFinish(el)
  if el == localPlayer then
    local veh = getPedOccupiedVehicle(el)
    if (veh and getElementData(veh, "challenge:vehicle")) or getElementData(localPlayer, "challenge:ped") then
      local lu_tick = getTickCount()
      local st_tick = getElementData(el, "challenge:tick")
      local diff = lu_tick - st_tick

      setElementData(localPlayer, "challenge:tick", 0)
	  if timeFont then 
		destroyElement(timeFont)
		timeFont = nil 
	  end 
	  if timeBlur then 
		exports["ms-blur"]:destroyBlurBox(timeBlur)
		timeBlur = nil
	  end 
	  removeEventHandler("onClientRender", root, drawPlayerTime)
	  
	  local m, s, cs = msToTimeStr(diff)
	  triggerEvent("onClientAddNotification", localPlayer, "Twój czas: "..m..":"..s..":"..cs..".\nPozycja: "..tostring(getChallengePositionFromTime(diff))..".", "info", 8000)
      triggerServerEvent("onChallengeDoneRequest", resourceRoot, diff) 
    end
  end
end

addEvent("onClientChallengeDone", true)
addEventHandler("onClientChallengeDone", root, function()
	if MARKER and isElement(MARKER) then
		destroyElement(MARKER)
		MARKER = false
	end
	if isElement(BLIP) then 
		destroyElement(BLIP)
		BLIP = nil 
	end 
	if timeFont then 
		destroyElement(timeFont)
		timeFont = nil 
	end 
	if timeBlur then 
		exports["ms-blur"]:destroyBlurBox(timeBlur)
		timeBlur = nil
	end 
	for k,v in ipairs(OBJECTS) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end 
	OBJECTS = {}
	removeEventHandler("onClientRender", root, drawPlayerTime)
	setElementData(localPlayer, "challenge:tick", 0)
	setElementData(localPlayer, "player:status", "W grze")
	setElementData(localPlayer, "block:player_teleport", false) 
	setElementData(localPlayer, "block:vehicle_spawn", false)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if timeBlur then 
		exports["ms-blur"]:destroyBlurBox(timeBlur)
		timeBlur = nil
	end 
end)