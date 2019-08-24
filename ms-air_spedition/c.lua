--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: strona klienta spedycji lotniczej
]]

-- zmienne interfejsu

local screenW, screenH = guiGetScreenSize()
local baseX = 2048
local zoom = 1.0
local minZoom = 2
local air_spedition_window_toggle = false
local window_type = false


if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-(800/zoom)/2, y=screenH/2-(500/zoom)/2, w=800/zoom, h=500/zoom}	
local bgPosHUD

-- zmienne pracy

local air_spedition_position_start = {1478.46,1814.56,13.83, -10.76,-0.01,182.1}

local air_spedition_positions = {
	-- x,y,z, punkty, mnożnik, nazwa
	{384.48,2506.99,16.48, 0, 1, "Stare lotnisko"}, -- Stare lotnisko
	{-1158.37,334.25,14.205, 50, 1.5, "San Fierro"}, -- lotnisko San Fierro
	{1934.16,-2493.80,13.54, 100, 2, "Los Santos"} -- lotnisko Los Santos
}

local air_spedition_checkpoint = false
local air_spedition_ped = false
local air_spedition_pickup = false
local air_spedition_blip = false
local air_spedition_mapicon = false
local air_spedition_dimension = 1010
local air_spedition_vehicle = false
local air_spedition_track = false

function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end


function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function airSpeditionPickupHit(player, dim)
	if player ~= localPlayer then return end
	toggleAirSpeditionWindow(true)
end

function airSpeditionLoad()
	air_spedition_ped = createPed(292, 1698.71,1645.77,10.7, 178.20)
	addEventHandler('onClientPedDamage', air_spedition_ped, cancelEvent)
	setElementFrozen(air_spedition_ped, true)
	air_spedition_pickup = createPickup(1698.78,1645.07,10.75-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
	air_spedition_blip = createBlipAttachedTo(air_spedition_pickup, 52)
	setElementData(air_spedition_blip, 'blipIcon', 'job')
	addEventHandler("onClientPickupHit", air_spedition_pickup, airSpeditionPickupHit)
	
	hudZoom = exports["ms-hud"]:getInterfaceZoom()
	bgPosHUD = {x=screenW-(560/hudZoom), y=50/hudZoom+220/hudZoom, w=535/hudZoom, h=120/hudZoom}
end
addEventHandler("onClientResourceStart", resourceRoot, airSpeditionLoad)

function toggleAirSpeditionWindow(toggle)
	if toggle == true then
		addEventHandler("onClientRender", getRootElement(), renderAirSpeditionWindow)
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "antialiased") or "default-bold"
		font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "antialiased") or "default-bold"
		air_spedition_window_toggle = true
		showCursor(true)
		window_type = "info"
		guiSetInputMode("no_binds")
	else
		removeEventHandler("onClientRender", getRootElement(), renderAirSpeditionWindow)
		if font then destroyElement(font) end
		if font2 then destroyElement(font2) end
		air_spedition_window_toggle = false
		showCursor(false)
		window_type = false
		guiSetInputMode("allow_binds")
	end
end

function renderAirSpeditionHUD()
	local vehicle_health = math.floor(getElementHealth(getPedOccupiedVehicle(localPlayer))/10)
	local x,y,z = getElementPosition(localPlayer)
	local distance = math.floor(getDistanceBetweenPoints2D(x, y, air_spedition_positions[air_spedition_track][1], air_spedition_positions[air_spedition_track][2]))
	exports["ms-gui"]:dxDrawBluredRectangle(bgPosHUD.x, bgPosHUD.y, bgPosHUD.w, bgPosHUD.h, tocolor(170, 170, 170, 255), false)
	dxDrawRectangle(bgPosHUD.x, bgPosHUD.y, bgPosHUD.w-400/hudZoom, bgPosHUD.h, tocolor(30, 30, 30, 100), true) 
	dxDrawRectangle(bgPosHUD.x+400/hudZoom, bgPosHUD.y, bgPosHUD.w-400/hudZoom, bgPosHUD.h, tocolor(30, 30, 30, 100), true) 
	dxDrawText(air_spedition_positions[air_spedition_track][6], bgPosHUD.x, bgPosHUD.y+40/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	dxDrawText(distance, bgPosHUD.x-390/hudZoom, bgPosHUD.y+30/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	dxDrawText("".. vehicle_health .."%", bgPosHUD.x+395/hudZoom, bgPosHUD.y+30/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	dxDrawText("Stan", bgPosHUD.x+395/hudZoom, bgPosHUD.y+65/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.5, font2, "center", "top", false, true, true)
	dxDrawText("Dystans", bgPosHUD.x-390/hudZoom, bgPosHUD.y+65/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.5, font2, "center", "top", false, true, true)
end

function toggleAirSpeditionHUD(toggle)
	if toggle == true then
		addEventHandler("onClientRender", getRootElement(), renderAirSpeditionHUD)
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
	else
		removeEventHandler("onClientRender", getRootElement(), renderAirSpeditionHUD)
		if font then destroyElement(font) end
		if font2 then destroyElement(font2) end
	end
end


function renderAirSpeditionWindow(type)
	if window_type == false then return end
	
	local points = getElementData(localPlayer, "job_points:air") or 0
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 60/zoom, tocolor(0, 0, 0, 100), true) 
	
	if window_type == "info" then
		dxDrawText("Spedycja lotnicza", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
		dxDrawText("Zlecenie polega na dostarczeniu towaru na jedno z wybranych lotnisk. W zależności od umiejętności w danym zleceniu wraz z postępem prac odblokują ci się nowe lotniska. Bądź ostrożny podczas lotu gdyż  zbyt duże uszkodzenie samolotu może przerwać zlecenie.", bgPos.x+30/zoom, bgPos.y+90/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 50), true) 
		end
		
		dxDrawText("Dalej", bgPos.x+260/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
		end
		
		dxDrawText("Anuluj", bgPos.x+510/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	end
	
	if window_type == "choose" then
		dxDrawText("Wybierz trasę", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
		dxDrawText("Obecnie posiadasz ".. points .." punktów", bgPos.x, bgPos.y+350/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "center", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x, bgPos.y+60/zoom, bgPos.w, bgPos.h-430/zoom) and points >= air_spedition_positions[1][4] then
			dxDrawRectangle(bgPos.x, bgPos.y+60/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(30, 70, 100, 150), true) 
		else
			if points >= air_spedition_positions[1][4] then
				dxDrawRectangle(bgPos.x, bgPos.y+60/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(30, 30, 30, 150), true) 
			else
				dxDrawRectangle(bgPos.x, bgPos.y+60/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(100, 30, 30, 150), true) 
			end
		end
		
		if isCursorOnElement(bgPos.x, bgPos.y+130/zoom, bgPos.w, bgPos.h-430/zoom) and points >= air_spedition_positions[2][4] then
			dxDrawRectangle(bgPos.x, bgPos.y+130/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(30, 70, 100, 150), true) 
		else
			if points >= air_spedition_positions[2][4] then
				dxDrawRectangle(bgPos.x, bgPos.y+130/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(30, 30, 30, 150), true) 
			else
				dxDrawRectangle(bgPos.x, bgPos.y+130/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(100, 30, 30, 150), true) 
			end
		end
		
		if isCursorOnElement(bgPos.x, bgPos.y+200/zoom, bgPos.w, bgPos.h-430/zoom) and points >= air_spedition_positions[3][4] then
			dxDrawRectangle(bgPos.x, bgPos.y+200/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(30, 70, 100, 1500), true) 
		else
			if points >= air_spedition_positions[3][4] then
				dxDrawRectangle(bgPos.x, bgPos.y+200/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(30, 30, 30, 150), true) 
			else
				dxDrawRectangle(bgPos.x, bgPos.y+200/zoom, bgPos.w, bgPos.h-430/zoom, tocolor(100, 30, 30, 150), true) 
			end
		end
		
		dxDrawText("Stare lotnisko", bgPos.x+150/zoom, bgPos.y+80/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "left", "top", false, true, true)
		dxDrawText("".. getAirSpeditionDistance(1) .."m", bgPos.x+450/zoom, bgPos.y+80/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		dxDrawText("".. getMoneyFromDistance(getAirSpeditionDistance(1), 1) .."$   ".. getExpFromDistance(getAirSpeditionDistance(1), 1) .." exp", bgPos.x+580/zoom, bgPos.y+80/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		
		dxDrawText("Lotnisko  San Fierro", bgPos.x+150/zoom, bgPos.y+150/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "left", "top", false, true, true)
		dxDrawText("".. getAirSpeditionDistance(2) .."m", bgPos.x+450/zoom, bgPos.y+150/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		dxDrawText("".. getMoneyFromDistance(getAirSpeditionDistance(2), 2) .."$   ".. getExpFromDistance(getAirSpeditionDistance(2), 2) .." exp", bgPos.x+580/zoom, bgPos.y+150/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		
		
		dxDrawText("Lotnisko Los Santos", bgPos.x+150/zoom, bgPos.y+220/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "left", "top", false, true, true)
		dxDrawText("".. getAirSpeditionDistance(3) .."m", bgPos.x+450/zoom, bgPos.y+220/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		dxDrawText("".. getMoneyFromDistance(getAirSpeditionDistance(3), 3) .."$   ".. getExpFromDistance(getAirSpeditionDistance(3), 3) .." exp", bgPos.x+580/zoom, bgPos.y+220/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		
		dxDrawImage(bgPos.x+40/zoom, bgPos.y+75/zoom, 40/zoom, 40/zoom, "air.png", 0, 0, 0, tocolor(255, 255, 255, 230), true)
		dxDrawImage(bgPos.x+40/zoom, bgPos.y+145/zoom, 40/zoom, 40/zoom, "air.png", 0, 0, 0, tocolor(255, 255, 255, 230), true)
		dxDrawImage(bgPos.x+40/zoom, bgPos.y+215/zoom, 40/zoom, 40/zoom, "air.png", 0, 0, 0, tocolor(255, 255, 255, 230), true)
		
		if isCursorOnElement(bgPos.x+300/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+300/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+300/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
		end
		
		dxDrawText("Anuluj", bgPos.x+370/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	end
end


function getAirSpeditionDistance(track_id)
	return math.floor(getDistanceBetweenPoints2D(air_spedition_position_start[1], air_spedition_position_start[2], air_spedition_positions[track_id][1], air_spedition_positions[track_id][2]))
end

function getMoneyFromDistance(distance, track_id)
	return math.floor((distance*air_spedition_positions[track_id][5]))
end

function getExpFromDistance(distance, track_id)
	return math.floor(distance/1000*air_spedition_positions[track_id][5])
end

function airSpeditionJobEnd(reason)
	if reason == "failed" then
		triggerEvent("onClientAddNotification", localPlayer, "Zlecenie nie zostało wykonane!", "warning")
	else
		local distance = getAirSpeditionDistance(air_spedition_track)
		local money = getMoneyFromDistance(distance, air_spedition_track)
		local exp = getExpFromDistance(distance, air_spedition_track)
		triggerServerEvent("giveRewardForAirSpedition", localPlayer, localPlayer, money, exp)
		triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "player:did_jobs", 1)
		triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "job_points:air", 1)
		
		if getElementData(localPlayer, "player:premium") then 
			triggerEvent("onClientAddNotification", localPlayer, "Dowiozłeś towar! Otrzymujesz ".. math.floor(money + money * 0.3) .."$ oraz ".. math.floor(exp + exp * 0.3) .." exp", "success")
		else
			triggerEvent("onClientAddNotification", localPlayer, "Dowiozłeś towar! Otrzymujesz ".. money .. "$ oraz ".. exp .. " exp", "success")
		end
	end
	
	destroyElement(air_spedition_vehicle)
	destroyElement(air_spedition_checkpoint)
	destroyElement(air_spedition_mapicon)
	air_spedition_vehicle = nil
	air_spedition_checkpoint = nil
	air_spedition_mapicon = nil
	air_spedition_track = nil
	triggerServerEvent("changeAirWorld", localPlayer, localPlayer, 0)
	toggleAirSpeditionHUD(false)
	setElementData(localPlayer, "player:status", "W grze")
	setElementData(localPlayer, "player:job", nil)
	triggerServerEvent("deleteAirSpeditionVehicle", localPlayer, localPlayer)
end
addEvent("endAirJob", true)
addEventHandler("endAirJob", getRootElement(), airSpeditionJobEnd)

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
   if source == air_spedition_vehicle and not attacker then
		local vehicle_health = getElementHealth(source)/10
		
		if vehicle_health < 80 then
			airSpeditionJobEnd("failed")
		end
   end
end
addEventHandler("onClientVehicleDamage", getRootElement(), handleVehicleDamage)

function airSpeditionTrackEnd(hit, dim)
	if hit ~= localPlayer then return end
	
	local vehicle = getPedOccupiedVehicle(hit)
	local speed = getElementSpeed(vehicle, "km/h")
	
	if speed > 50 then 
		triggerEvent("onClientAddNotification", localPlayer, "Zwolnij samolot!", "error")
		return 
	end
	
	if hit and vehicle == air_spedition_vehicle then
		airSpeditionJobEnd()
	else
		triggerEvent("onClientAddNotification", localPlayer, "Wyląduj tutaj samolotem!", "error")
	end
end

function airSpeditionStart(track_id, vehicle)
	air_spedition_vehicle = vehicle
	air_spedition_track = track_id
	air_spedition_checkpoint = createMarker(air_spedition_positions[track_id][1], air_spedition_positions[track_id][2], air_spedition_positions[track_id][3], "checkpoint", 8, 255, 0, 0, 255)
	air_spedition_mapicon = createBlip(air_spedition_positions[track_id][1], air_spedition_positions[track_id][2], air_spedition_positions[track_id][3], 41)
	setElementData(air_spedition_mapicon, 'blipIcon', 'mission_target')
	setElementData(air_spedition_mapicon, 'exclusiveBlip', true)
	setElementData(localPlayer, 'player:job', 'air_spedition')
	setElementData(localPlayer, "player:status", "Praca: Spedycja lotnicza")
	setElementDimension(air_spedition_mapicon, air_spedition_dimension)
	setElementDimension(air_spedition_checkpoint, air_spedition_dimension)
	addEventHandler ( "onClientMarkerHit", air_spedition_checkpoint, airSpeditionTrackEnd)
	toggleAirSpeditionHUD(true)
	addEventHandler("onClientVehicleExit", air_spedition_vehicle,
    function(thePlayer, seat)
		airSpeditionJobEnd("failed")
    end
	)
end
addEvent("airSpeditionStart", true)
addEventHandler("airSpeditionStart", getRootElement(), airSpeditionStart)

function airSpeditionWindowClick(button, state)
	if button == "left" and state == "up" then 
		if air_spedition_window_toggle then
		
			local points = getElementData(localPlayer, "job_points:air")
			
			if isCursorOnElement(bgPos.x, bgPos.y+60/zoom, bgPos.w, bgPos.h-430/zoom) and window_type == "choose" then
				if points >= air_spedition_positions[1][4] then
					triggerServerEvent("startAirSpeditionServer", localPlayer, localPlayer, 1)
					toggleAirSpeditionWindow(false)
				else
					triggerEvent("onClientAddNotification", localPlayer, "Aby odblokować to lotnisko potrzebujesz ".. air_spedition_positions[1][4] .." ukończonych spedycji lotniczych", "error")
				end
			end
			
			if isCursorOnElement(bgPos.x, bgPos.y+130/zoom, bgPos.w, bgPos.h-430/zoom) and window_type == "choose" then
				if points >= air_spedition_positions[2][4] then
					triggerServerEvent("startAirSpeditionServer", localPlayer, localPlayer, 2)
					toggleAirSpeditionWindow(false)
				else
					triggerEvent("onClientAddNotification", localPlayer, "Aby odblokować to lotnisko potrzebujesz ".. air_spedition_positions[2][4] .." ukończonych spedycji lotniczych", "error")
				end
			end
			
			if isCursorOnElement(bgPos.x, bgPos.y+200/zoom, bgPos.w, bgPos.h-430/zoom) and window_type == "choose" then
				if points >= air_spedition_positions[3][4] then
					triggerServerEvent("startAirSpeditionServer", localPlayer, localPlayer, 3)
					toggleAirSpeditionWindow(false)
				else
					triggerEvent("onClientAddNotification", localPlayer, "Aby odblokować to lotnisko potrzebujesz ".. air_spedition_positions[3][4] .." ukończonych spedycji lotniczych", "error")
				end
			end
			
			-- anulowanie pracy
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "info" then
				toggleAirSpeditionWindow(false)
			end
			
			if isCursorOnElement(bgPos.x+300/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "choose" then
				toggleAirSpeditionWindow(false)
			end
			
			-- przejście dalej i wyświetlanie wyboru trasy
			if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "info" then
				window_type = "choose"
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), airSpeditionWindowClick)

addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), 
	function()
		if getElementData(source, 'player:job') == 'air_spedition' then
			airSpeditionJobEnd("failed")
		end
	end
)





