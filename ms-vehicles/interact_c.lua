
local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 2048
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local showInteraction = false 
local selectedInteraction = 0 

local interactions = {
	{"Zgaś", "Odpal", "silnik"},
	{"Zgaś", "Zapal", "światła"},
	{"Spuść", "Zaciągnij", "ręczny"},
	{"Zamknij", "Otwórz", "maskę",},
	{"Zamknij", "Otwórz", "bagażnik"},
	{"Zamknij", "Otwórz", "pojazd"},
	{"Wyłącz", "Włącz", "neony"},
}

local bgPos = {x=screenW-290/zoom, y=(screenH/2)-(200/zoom/2)-200/zoom, w=270/zoom, h=365/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}
local bgRow = {x=bgPos.x+20/zoom, w=bgPos.w-75/zoom, h=45/zoom}
local bgRowLine = {x=bgRow.x, w=5/zoom, h=bgRow.h}

function selectInteraction(interaction)
	if interaction ~= 0 then 
		triggerServerEvent("onPlayerChangeVehicleSetting", localPlayer, interaction)
	end
end 

function renderVehicleInteraction() 
	if isChatBoxInputActive() then selectedInteraction = 0 toggleVehicleInteraction() return end	
	if not isPedInVehicle(localPlayer) then return end 
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	for k,v in ipairs(interactions) do 
		local offsetY = 20/zoom + (k-1)*(3/zoom+bgRow.h)
			
		dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h, tocolor(30, 30, 30, 100), true)
		if selectedInteraction == k then 
			dxDrawRectangle(bgRowLine.x, bgPos.y+offsetY, bgRowLine.w, bgRowLine.h, tocolor(51, 102, 255, 255), true)
		end 
		
		local infoText = ""
		local passed = false 
		--[[
		loadstring("passed = "..v[4].."(getPedOccupiedVehicle(getLocalPlayer())")
		nie dziala:C
		--]] 
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if not vehicle then return end 
		
		if k == 1 then 
			passed = getVehicleEngineState(vehicle)
		elseif k == 2 then 
			passed = getVehicleOverrideLights(vehicle) == 2
		elseif k == 3 then 
			passed = isElementFrozen(vehicle)
		elseif k == 4 then 
			passed = getVehicleDoorOpenRatio(vehicle, 0) == 1 
		elseif k == 5 then 
			passed = getVehicleDoorOpenRatio(vehicle, 1) == 1 
		elseif k == 6 then 
			passed = not  isVehicleLocked(vehicle)
		elseif k == 7 then 
			passed = getElementData(vehicle, "vehicle:neonDisabled")
		end 
		
		if passed then 
			infoText = v[1].." "..v[3]
		else 
			infoText = v[2].." "..v[3]
		end
		
		dxDrawText(infoText, bgRow.x+35/zoom, offsetY + bgPos.y + 3/zoom, bgRow.w+bgRow.x, (offsetY + bgPos.y)+bgRow.h, tocolor(210, 210, 210, 210), 0.7, font, "center", "center", false, false, true)
	end
end 

function scrollVehicleInteraction(key, press)
	if not showInteraction then return end 
	
	if key == "mouse_wheel_down" or (key == "arrow_d" and press) then 
		selectedInteraction = selectedInteraction+1
		if selectedInteraction > #interactions then 
			selectedInteraction = 1
		end
	elseif key == "mouse_wheel_up" or (key == "arrow_u" and press) then 
		selectedInteraction = selectedInteraction-1
		if selectedInteraction < 1 then 
			selectedInteraction = #interactions
		end
	end
end 
addEventHandler("onClientKey", root, scrollVehicleInteraction)

function toggleVehicleInteraction()
	if not isPedInVehicle(localPlayer) then return end 
	if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end 
	if getPlayerTeam(localPlayer) then return end 
	
	showInteraction = not showInteraction
	
	if showInteraction then 
		selectedInteraction = 0 
		
		font = dxCreateFont("f/archivo_narrow.ttf", 23/zoom) or "default-bold"
		addEventHandler("onClientRender", root, renderVehicleInteraction)
	else 
		selectInteraction(selectedInteraction)
		
		if isElement(font) then 
			destroyElement(font)
		end
		removeEventHandler("onClientRender", root, renderVehicleInteraction)
	end
end
bindKey("lshift", "both", toggleVehicleInteraction)

function isInteractionEnabled()
	return showInteraction
end 

function onClientResourceStop()
	if showInteraction then 
		toggleVehicleInteraction()
	end
end 
addEventHandler("onClientResourceStop", resourceRoot, onClientResourceStop)

function removeInteractionOnExit()
	if isElement(font) then 
		destroyElement(font)
	end
	if blur then 
		exports["ms-blur"]:destroyBlurBox(blur)
	end
	removeEventHandler("onClientRender", root, renderVehicleInteraction)
end
addEventHandler("onClientVehicleExit", getRootElement(), removeInteractionOnExit)