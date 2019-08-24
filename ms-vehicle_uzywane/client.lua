local screenW, screenH = guiGetScreenSize() 
local zoom = 1.0

local baseX = 2048
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

bgPos = {x=screenW/2-500/zoom/2, y=screenH/2-400/zoom/2, w=500/zoom, h=400/zoom}

local exchangeVehicle = false 

function showExchangeWindow(vehicle)
	showCursor(true, false)
	font = dxCreateFont("archivo_narrow.ttf", 22/zoom) or "default-bold"
	addEventHandler("onClientRender", root, renderExchangeWindow)
	
	exchangeVehicle = vehicle
end 
addEvent("onClientShowExchangeWindow", true)
addEventHandler("onClientShowExchangeWindow", root, showExchangeWindow)

function hideExchangeWindow()
	showCursor(false)
	if font then destroyElement(font) font = nil end
	removeEventHandler("onClientRender", root, renderExchangeWindow)
end 
addEvent("onClientHideExchangeWindow", true)
addEventHandler("onClientHideExchangeWindow", root, hideExchangeWindow)

function renderExchangeWindow()
	if not isElement(exchangeVehicle) then 
		hideExchangeWindow()
		return
	end 
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 50/zoom, tocolor(0, 0, 0, 150), true)
	dxDrawText("Szczegóły o pojeździe", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+50/zoom, tocolor(240, 240, 240, 240), 0.7, font, "center", "center", false, false, true)
	
	local nitro = getElementData(exchangeVehicle, "vehicle:hasNOS") and "tak" or "nie"
	local hydraulika = getVehicleUpgradeOnSlot(exchangeVehicle, 9) == 1087  and "tak" or "nie"
	
	local addons = getElementData(exchangeVehicle, "vehicle:upgrade_addons") or {engine=0, hp=0, jump=0}
	
	dxDrawText("Właściciel: "..tostring(getElementData(exchangeVehicle, "vehicle:owner_name")).."\nCena: $"..tostring(getElementData(exchangeVehicle, "vehicle:exchange:cena")).."\nPrzebieg: "..tostring(math.floor(getElementData(exchangeVehicle, "vehicle:mileage")/1000)).."km\nNitro: "..nitro.."\nHydraulika: "..hydraulika.."\nModyfikator silnika: "..tostring(addons.engine).." LVL\nModyfikator skoku: "..tostring(addons.jump).." LVL\nModyfikator HP: "..tostring(addons.hp).. " LVL", bgPos.x, bgPos.y+70/zoom, bgPos.x+bgPos.w, 0, tocolor(220, 220, 220, 220), 0.7, font, "center", "top", false, false, true)
	
	local x, y, w, h = bgPos.x+bgPos.w/2-150/zoom/2, bgPos.y+bgPos.h-80/zoom, 150/zoom, 45/zoom
	if getElementData(exchangeVehicle, "vehicle:owner") ~= getElementData(localPlayer, "player:uid") then 
		if isCursorOnElement(x, y, w, h) then 
			dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 200), true)
			if getKeyState("mouse1") then 
				triggerServerEvent("onPlayerBuyExchangeVehicle", localPlayer, exchangeVehicle)
				hideExchangeWindow()
				return
			end
		else 
			dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 100), true)
		end
		
		dxDrawText("Kup", x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.7, font, "center", "center", false, false, true)
	else 
		if isCursorOnElement(x, y, w, h) then 
			dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 200), true)
			if getKeyState("mouse1") then 
				triggerServerEvent("onPlayerTakeExchangeVehicle", localPlayer, exchangeVehicle)
				hideExchangeWindow()
				return
			end
		else 
			dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 100), true)
		end
		
		dxDrawText("Zabierz z giełdy", x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.65, font, "center", "center", false, false, true)
	end 
end

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

function cancelExchangeVehicleDamage()
	if getElementData(source, "vehicle:exchange") then
		cancelEvent()
	end
end
addEventHandler("onClientVehicleDamage", root, cancelExchangeVehicleDamage)
