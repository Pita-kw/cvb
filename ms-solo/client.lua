screenW, screenH = guiGetScreenSize()

local MAX_VISIBLE_ROWS = 9
local selectedRow = 1
local visibleRows = MAX_VISIBLE_ROWS

local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end

local bgPos = {x=screenW/2-350/zoom/2, y=screenH/2-500/zoom/2, w=340/zoom, h=510/zoom}
local bgRow = {x=bgPos.x+25/zoom, w=bgPos.w-100/zoom, h=30/zoom}

local showing = false 
local soloPlayer = false

local highlightedWeapon = false 
local selectedWeapon = false 
local glitchesEnabled = false 
local weaponStatsEnabled = false 

local weapons = {12, 22, 23, 24, 25, 26, 27, 28, 29, 32, 30, 31, 33, 34}
local weaponNames = {} 
for k,v in ipairs(weapons) do 
	table.insert(weaponNames, getWeaponNameFromID(v))
end 
table.sort(weaponNames)

function renderSoloWindow()
	if not isElement(soloPlayer) then 
		triggerEvent("onClientAddNotification", localPlayer, "Gracz z którym chciałeś podjąć wyzwanie wyszedł z gry.", "error")
		hideSoloWindow()
		return
	end 
	
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(30, 30, 30, 150), true)
	dxDrawRectangle(bgPos.x, bgPos.y+bgPos.h, bgPos.w, 3/zoom, tocolor(51, 102, 255, 255), true)
	dxDrawText("Wyzwij gracza "..getPlayerName(soloPlayer), bgPos.x, bgPos.y + 10/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.85, font, "center", "top", false, true, true)
	
	local scrollH = 296/zoom
	dxDrawRectangle(bgPos.x + bgPos.w - 30/zoom, bgPos.y + 60/zoom, 10/zoom, scrollH, tocolor(30, 30, 30, 150), true)
		
	local scrollPos = 60/zoom
	if #weapons > MAX_VISIBLE_ROWS then 
		scrollPos = (((selectedRow-1)/(#weaponNames-MAX_VISIBLE_ROWS)) * (scrollH-scrollPos+20/zoom)) + scrollPos
	end 	
	dxDrawRectangle(bgPos.x + bgPos.w - 30/zoom, scrollPos + bgPos.y, 10/zoom, 40/zoom, tocolor(51, 102, 255, 255), true)
	
	local n = 0
	for k,v in ipairs(weaponNames) do 
		if k >= selectedRow and k <= visibleRows then 
			n = n+1
			local offsetY = 60/zoom + (n-1)*(3/zoom+bgRow.h)
			
			if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h) then 
				dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h, tocolor(100, 100, 100, 150), true)
				highlightedWeapon = {k, n}
			elseif selectedWeapon == k then 
				dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h, tocolor(100, 100, 100, 100), true)
			else 
				dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h, tocolor(30, 30, 30, 100), true)
			end
			
			if selectedWeapon == k then 
				dxDrawRectangle(bgRow.x, bgPos.y+offsetY, 3/zoom, bgRow.h, tocolor(51, 102, 255, 255), true)
			end 
			
			dxDrawText(v, bgRow.x + 35/zoom, offsetY + bgPos.y + 3/zoom, bgRow.w+bgRow.x, offsetY + bgPos.y + 3/zoom + bgRow.h, tocolor(210, 210, 210, 210), 0.7, font, "left", "center", false, true, true)
		end 
	end
	
	dxDrawRectangle(bgRow.x, bgPos.y+380/zoom, 80/zoom, 20/zoom, tocolor(30, 30, 30, 150), true)
	if glitchesEnabled then 
		dxDrawRectangle(bgRow.x+80/zoom/2, bgPos.y+380/zoom, 80/zoom/2, 20/zoom, tocolor(51, 102, 255, 255), true)
	else 
		dxDrawRectangle(bgRow.x, bgPos.y+380/zoom, 80/zoom/2, 20/zoom, tocolor(150, 150, 150, 150), true)
	end
	dxDrawText("Umiejętności broni na 100%", bgRow.x+90/zoom, bgPos.y+380/zoom, 0, bgPos.y+380/zoom+20/zoom, tocolor(230, 230, 230, 230), 0.65, font, "left", "center", false, true, true)
	
	dxDrawRectangle(bgRow.x, bgPos.y+415/zoom, 80/zoom, 20/zoom, tocolor(30, 30, 30, 150), true)
	if weaponStatsEnabled then 
		dxDrawRectangle(bgRow.x+80/zoom/2, bgPos.y+415/zoom, 80/zoom/2, 20/zoom, tocolor(51, 102, 255, 255), true)
	else 
		dxDrawRectangle(bgRow.x, bgPos.y+415/zoom, 80/zoom/2, 20/zoom, tocolor(150, 150, 150, 150), true)
	end
	dxDrawText("Armor", bgRow.x+90/zoom, bgPos.y+415/zoom, 0, bgPos.y+415/zoom+20/zoom, tocolor(230, 230, 230, 230), 0.65, font, "left", "center", false, true, true)
	
	local x, y, w, h = bgPos.x+25/zoom, bgPos.y+bgPos.h-50/zoom, 125/zoom, 40/zoom
	if isCursorOnElement(x, y, w, h) then 
		dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 200), true)
		dxDrawText("Wyzwij", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.75, font, "center", "center", false, true, true)
	else 
		dxDrawRectangle(x, y, w, h, tocolor(51*0.8, 102*0.8, 255*0.8, 200), true)
		dxDrawText("Wyzwij", x, y, x+w, y+h, tocolor(200, 200, 200, 200), 0.75, font, "center", "center", false, true, true)
	end 
	
	local x, y, w, h = bgPos.x+bgPos.w-150/zoom, bgPos.y+bgPos.h-50/zoom, 125/zoom, 40/zoom
	if isCursorOnElement(x, y, w, h) then 
		dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 200), true)
		dxDrawText("Anuluj", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.75, font, "center", "center", false, true, true)
		if getKeyState("mouse1") then hideSoloWindow() end
	else 
		dxDrawRectangle(x, y, w, h, tocolor(231*0.8, 76*0.8, 60*0.8, 200), true)
		dxDrawText("Anuluj", x, y, x+w, y+h, tocolor(200, 200, 200, 200), 0.75, font, "center", "center", false, true, true)
	end
end 

function clickSoloWindow(key, state)
	if key == "mouse1" and state then 
		if highlightedWeapon then 
			local k, n = highlightedWeapon[1], highlightedWeapon[2]
			local offsetY = 60/zoom + (n-1)*(3/zoom+bgRow.h)
			if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h) then 
				selectedWeapon = k
			end
		end
		
		if isCursorOnElement(bgRow.x, bgPos.y+380/zoom, 80/zoom, 20/zoom) then 
			glitchesEnabled = not glitchesEnabled
		end 
		
		if isCursorOnElement(bgRow.x, bgPos.y+415/zoom, 80/zoom, 20/zoom) then 
			weaponStatsEnabled = not weaponStatsEnabled
		end
		
		if isCursorOnElement(bgPos.x+25/zoom, bgPos.y+bgPos.h-50/zoom, 125/zoom, 40/zoom) then 
			if not selectedWeapon then 
				triggerEvent("onClientAddNotification", localPlayer, "Wybierz broń.", "error")
				return
			end
			
			triggerServerEvent("onPlayerSendSoloRequest", localPlayer, soloPlayer, getWeaponIDFromName(weaponNames[selectedWeapon]), glitchesEnabled, weaponStatsEnabled)
			hideSoloWindow()
		end
	elseif key == "mouse_wheel_up" then 
		if selectedRow == 1 then return end 
		selectedRow = selectedRow-1 
		visibleRows = visibleRows-1
	elseif key == "mouse_wheel_down" then 
		if #weapons == visibleRows then return end 
		selectedRow = selectedRow+1
		visibleRows = visibleRows+1
	end
end 

function showSoloWindow()
	if showing then return end 
	if getElementData(localPlayer, "player:solo") then return end 
	
	font = dxCreateFont("archivo_narrow.ttf", 20/zoom)
	blur = exports["ms-blur"]:createBlurBox(bgPos.x, bgPos.y, bgPos.w, bgPos.h, 255, 255, 255, 255, false)
	showCursor(true)
	addEventHandler("onClientRender", root, renderSoloWindow)
	addEventHandler("onClientKey", root, clickSoloWindow)
	
	highlightedWeapon = false 
	selectedWeapon = false 
	glitchesEnabled = false 
	weaponStatsEnabled = false 
	
	showing = true
end 

function hideSoloWindow()
	if showing then 
		removeEventHandler("onClientRender", root, renderSoloWindow)
		removeEventHandler("onClientKey", root, clickSoloWindow)
		if blur then
			exports["ms-blur"]:destroyBlurBox(blur)
			blur = nil
		end
		if isElement(font) then 
			destroyElement(font)
			font = nil
		end
		
		setTimer(showCursor, 50, 1, false)
		
		showing = false
	end
end 

addCommandHandler("wyzwij", function(cmd, arg1)
	local targetPlayer = false 
	
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			targetPlayer = v
		end
	end
	
	if not targetPlayer then 
		triggerEvent("onClientAddNotification", localPlayer, "Nie znaleziono gracza o podanym ID.", "error")
		return
	end
	
	if targetPlayer == localPlayer then
		triggerEvent("onClientAddNotification", localPlayer, "Nie możesz wyzwać siebie.", "error")
		return
	end
	
	if getElementData(targetPlayer, "player:solo") then 
		triggerEvent("onClientAddNotification", localPlayer, "Ten gracz jest już na solo.", "error")
		return
	end
	
	soloPlayer = targetPlayer
	showSoloWindow()
end)

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
addEventHandler("onClientResourceStop", resourceRoot, hideSoloWindow)