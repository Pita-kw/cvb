VEHICLE_RADIOS = false
SAVED_STATION_INDEX = false 
RADIO_FADE_TIME = 1500 
SCROLL_DELAY = 300 

local currentStation = 0
local sound = false 
RADIO_SOUND_URL = false -- do usuwania gdy gracz nie ma żadnych stacji 

local lastScrollTick = 0 

function changeStation(next)
	if not VEHICLE_RADIOS or #VEHICLE_RADIOS < 1 then return end
	if isCursorShowing() then return end 
	if exports["ms-vehicles"]:isInteractionEnabled() then return end 
	if exports["ms-scoreboard"]:isScoreboardShowing() then return end 
	if getTickCount() < lastScrollTick+SCROLL_DELAY then return end 
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then 
		if getElementData(vehicle, "piano") then return end 
		if getVehicleController(vehicle) ~= localPlayer then return end 
		if next then 
			currentStation = currentStation+1
			if currentStation > #VEHICLE_RADIOS then 
				currentStation = 0
			end
		else 
			currentStation = currentStation-1 
			if currentStation < 0 then 
				currentStation = #VEHICLE_RADIOS
			end
		end 
		
		if VEHICLE_RADIOS[currentStation] then 
			triggerServerEvent("onPlayerUseVehicleRadio", localPlayer, VEHICLE_RADIOS[currentStation].name, VEHICLE_RADIOS[currentStation].url)
			setElementData(vehicle, "vehicle:current_radio", {name=VEHICLE_RADIOS[currentStation].name, url=VEHICLE_RADIOS[currentStation].url})
		else -- stacja zerowa
			triggerServerEvent("onPlayerUseVehicleRadio", localPlayer, -1, -1)
			setElementData(vehicle, "vehicle:current_radio", {name=-1, url=-1})
		end
		
		SAVED_STATION_INDEX = currentStation
		
		lastScrollTick = getTickCount()
	end
end 

function scrollStation(key)
	if PANEL_SHOWING then return end 

	if key == "mouse_wheel_up" then 
		changeStation(true)
	elseif key == "mouse_wheel_down" then 
		changeStation(false)
	end
end 

local trackName = ""
RADIO_INFO_SHOW = false 
function showRadioInfo(name) 
	zoom = exports["ms-radar"]:getInterfaceZoom()
	local x, y, w, h = exports["ms-radar"]:getRadarPosition()
	bgPos = {x=x, y=y+h-50/zoom, w=w, h=50/zoom}
	
	if not font then font = dxCreateFont("BebasNeue.otf", 23/zoom) or "default-bold" end
	if RADIO_INFO_SHOW then 
		removeEventHandler("onClientRender", root, renderRadioInfo)
	end 
	if name == -1 then 
		trackName = "Radio wyłączone"
	else 
		trackName = name
	end 
	
	RADIO_INFO_SHOW = getTickCount()+RADIO_FADE_TIME
	addEventHandler("onClientRender", root, renderRadioInfo)
end 

function renderRadioInfo()
	local now = getTickCount() 
	local alpha = 255 
	if now > RADIO_INFO_SHOW then 
		local progress = (now-RADIO_INFO_SHOW) / RADIO_FADE_TIME

		alpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "InQuad")
		if progress >= 1 then 
			removeEventHandler("onClientRender", root, renderRadioInfo)
			if isElement(font) and not PANEL_SHOWING then destroyElement(font) font = nil end 
			RADIO_INFO_SHOW = false
			trackName = ""
			return
		end
	end 
	
	local x, y, w, h = bgPos.x, bgPos.y, bgPos.w, bgPos.h
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, math.max(0, alpha-100)), true)
	
	dxDrawText(trackName, x+1, y+1, x+w+1, y+h+1, tocolor(0, 0, 0, alpha), 0.85, font, "center", "center", false, false, true) 
	dxDrawText(trackName, x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 0.85, font, "center", "center", false, false, true)
	
	local offsetX = bgPos.w/2 - 40/zoom - dxGetTextWidth(trackName, 0.85, font)/2
	local x, y, w, h = x+offsetX, y+h/2-40/zoom/2, 40/zoom, 40/zoom
	dxDrawImage(x+1, y+1, w+1, h+1, "tone_icon.png", 0, 0, 0, tocolor(0, 0, 0, alpha), true)
	dxDrawImage(x, y, w, h, "tone_icon.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
end

function onClientUpdateVehicleRadio(name, url)
	showRadioInfo(name) 
	
	if isElement(sound) then destroyElement(sound) sound = nil RADIO_SOUND_URL = nil end 
	if name == -1 and url == -1 then -- stacja zerowa 
		return
	end 
	
	if url:find("youtube") then 
		sound = playSound("http://www.youtubeinmp3.com/fetch/?video=".. url, false)
	else 
		sound = playSound(url, false)
	end 
	
	RADIO_SOUND_URL = url
	setSoundVolume(sound, 0.6)
end 
addEvent("onClientUpdateVehicleRadio", true)
addEventHandler("onClientUpdateVehicleRadio", root, onClientUpdateVehicleRadio)

function onClientResourceStart()
	local sw, sh = guiGetScreenSize()
	
	setRadioChannel(0)
	addEventHandler('onClientPlayerRadioSwitch', localPlayer, cancelEvent)
	bindKey("mouse_wheel_up", "both", scrollStation)
	bindKey("mouse_wheel_down", "both", scrollStation)
	bindKey("4", "down", function() changeStation(true) end)
	bindKey("r", "down", function() changeStation(false) end)
	
	setTimer(function() 
		if not isPedInVehicle(localPlayer) and isElement(sound) then 
			onClientVehicleExit(localPlayer)
		end
	end, 2000, 0)
	
end 
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)

function onClientVehicleEnter(player, seat)
	if player == localPlayer and seat == 0 then 
		if getPlayerTeam(player) then return end
		if getElementData(source, "piano") then return end
		if not VEHICLE_RADIOS then 
			triggerServerEvent("onPlayerRequestRadios", localPlayer)
		end
		
		local station = SAVED_STATION_INDEX or -1
		if station == -1 then 
			triggerServerEvent("onPlayerUseVehicleRadio", localPlayer, -1, -1)
		else 
			if VEHICLE_RADIOS[station] then 
				triggerServerEvent("onPlayerUseVehicleRadio", localPlayer, VEHICLE_RADIOS[station].name, VEHICLE_RADIOS[station].url)
			end
		end
	end 
end 
addEventHandler("onClientVehicleEnter", root, onClientVehicleEnter)

function onClientVehicleExit(player)
	if player == localPlayer then 
		if isElement(sound) then 
			destroyElement(sound)
			sound = nil 
			RADIO_SOUND_URL = nil
		end
		
		if RADIO_INFO_SHOW then 
			removeEventHandler("onClientRender", root, renderRadioInfo)
			if isElement(font) and not PANEL_SHOWING then destroyElement(font) font = nil end 
			RADIO_INFO_SHOW = false
			trackName = ""
		end
	end
end
addEventHandler("onClientVehicleExit", root, onClientVehicleExit)