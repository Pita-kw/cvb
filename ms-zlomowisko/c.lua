screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgWindow = {x=screenW/2-500/zoom/2, y=screenH/2-200/zoom/2, w=500/zoom, h=200/zoom}

local price = 0 
local vehicleid = 0 

local function isCursorOnElement(x,y,w,h)
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function showConfirmationWindow(carprice, id)
	if confirm_window then return end 
	
	price = carprice
	vehicleid = id 	
	toggleConfirmWindow(true)
end
addEvent("onPlayerSellVehicle", true)
addEventHandler("onPlayerSellVehicle", root, showConfirmationWindow)

function onWindowConfirmClick(button, state)
	if button == "left" and state == "up" then 
		local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
		x = x+bgWindow.w/2-w/2-100/zoom
		if isCursorOnElement(x, y, w, h) then
			triggerServerEvent("onPlayerSoldVehicle", localPlayer, price, vehicleid)
			toggleConfirmWindow(false)
			return
		end
		
		local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
		x = x+bgWindow.w/2-w/2+100/zoom
		if isCursorOnElement(x, y, w, h) then
			toggleConfirmWindow(false)
			return
		end
	end
end

function toggleConfirmWindow(toggle)
	if toggle == true then
		if confirm_window then return end 
		addEventHandler("onClientRender", getRootElement(), renderToggleWindow)
		addEventHandler("onClientClick", getRootElement(), onWindowConfirmClick)
		window_font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		window_font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
		showCursor(true)
		guiSetInputMode("no_binds")
		confirm_window = true
	else
		removeEventHandler("onClientRender", getRootElement(), renderToggleWindow)
		removeEventHandler("onClientClick", getRootElement(), onWindowConfirmClick)
		if window_font then destroyElement(window_font) end
		if window_font2 then destroyElement(window_font2) end
		showCursor(false)
		guiSetInputMode("allow_binds")
		confirm_window = false
	end
end

function renderToggleWindow()
	exports["ms-gui"]:dxDrawBluredRectangle(bgWindow.x, bgWindow.y, bgWindow.w, bgWindow.h, tocolor(170, 170, 170, 255), false)
	dxDrawRectangle(bgWindow.x, bgWindow.y, bgWindow.w, bgWindow.h-150/zoom, tocolor(30, 30, 30, 100), true) 
	dxDrawText("Potwierdzenie", bgWindow.x, bgWindow.y+10/zoom, bgWindow.x+bgWindow.w, bgWindow.x+bgWindow.y, tocolor(230, 230, 230, 230), 0.6, window_font2, "center", "top", false, true, true)
	dxDrawText("Czy chcesz zezłomować "..tostring(getVehicleName(getPedOccupiedVehicle(localPlayer)) or "...").." za "..tostring(price).."$?", bgWindow.x+45/zoom, bgWindow.y+70/zoom, bgWindow.x+bgWindow.w-50/zoom, bgWindow.x+bgWindow.y-50/zoom, tocolor(230, 230, 230, 230), 0.5, window_font2, "center", "top", false, true, true)
	local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
	x = x+bgWindow.w/2-w/2-100/zoom
	if isCursorOnElement(x, y, w, h) then
		dxDrawRectangle(x, y, w, h, tocolor(30, 255, 30, 100), true) 
	else
		dxDrawRectangle(x, y, w, h, tocolor(30, 255, 30, 50), true) 
	end
	dxDrawText("ZEZŁOMUJ", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.7, window_font, "center", "center", false, true, true)
	
	local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
	x = x+bgWindow.w/2-w/2+100/zoom
	if isCursorOnElement(x, y, w, h) then
		dxDrawRectangle(x, y, w, h, tocolor(255, 30, 30, 100), true) 
	else
		dxDrawRectangle(x, y, w, h, tocolor(255, 30, 30, 50), true) 
	end
	
	dxDrawText("ANULUJ", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.7, window_font, "center", "center", false, true, true)
end