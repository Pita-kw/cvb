--[[
	MultiServer 
	Zasób: ms-teleports/c.lua
	Opis: Panel wyboru teleportów pod F3. Tak, nie mam pojęcia jak działa scroll w tym skrypcie XD
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]
local MAX_VISIBLE_ROWS = 9

local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 1.6
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+200)/screenW)
end 

local teleportsCategories = {"Podstawowe", "Atrakcje", "Tory", "Stunt", "Prace", "Specjalne"}
local teleportsData = {} 
local teleportsCategory = false 

local showTeleports = false
local selectedCategory = false
local selectedTeleport = false  
local selectedRow = 1
local visibleRows = MAX_VISIBLE_ROWS
local bgPos = {x=(screenW/2)-(350/zoom/2), y=(screenH/2)-(500/zoom/2), w=350/zoom, h=500/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}
local bgRow = {x=bgPos.x+20/zoom, w=bgPos.w-75/zoom, h=45/zoom}
local bgRowLine = {x=bgRow.x, w=5/zoom, h=bgRow.h}

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

function renderTeleports()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255))
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	dxDrawText("Dostępne teleporty", bgPos.x, bgPos.y + 10/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.75, font, "center", "top", false, true, true)
	
	if not teleportsCategory then 
		exports["ms-gui"]:renderList(list1)
		local selected = exports["ms-gui"]:getSelectedListItemsIndex(list1)
		if #selected > 0 then 
			teleportsCategory = selected[1]
			if teleportsCategory == 6 then 
				triggerEvent("onClientAddNotification", localPlayer, "Teleporty z tej kategorii wymagają pobrania dodatkowych plików w tle.", "info")
			end 
			
			exports["ms-gui"]:setListActive(list1, false)
			
			list2 = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-70/zoom, tocolor(20, 20, 20, 150), font, 0.65, 20/zoom)
			exports["ms-gui"]:addListColumn(list2, "Nazwa komendy", 0.95)
			for k,v in ipairs(teleportsData[teleportsCategory]) do 
				exports["ms-gui"]:addListItem(list2, "Nazwa komendy", "/"..v.cmd)
			end
			exports["ms-gui"]:reloadListRT(list2)
			exports["ms-gui"]:setListActive(list2, true)
		end
	else 
		if list2 then 
			exports["ms-gui"]:renderList(list2)
			local selected = exports["ms-gui"]:getSelectedListItemsIndex(list2)
			if selected and #selected > 0 then 
				local teleport = teleportsData[teleportsCategory][selected[1]] 
				if teleport then
					toggleAllControls(false)
					triggerServerEvent("onPlayerTeleport", localPlayer, teleport.x, teleport.y, teleport.z, teleport.interior, teleport.dimension, teleport.rot, teleport.type, teleport.cmd)
					toggleTeleports()
					setTimer(toggleAllControls, 100, 1, true)
				end
			end
		end
	end 
	
	--[[
	selectedCategory = false 
	if not teleportsCategory then 
		for k,v in ipairs(teleportsCategories) do 
			local offsetY = 60/zoom + (k-1)*(3/zoom+bgRow.h)
			
			dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h, tocolor(30, 30, 30, 100), true)
			dxDrawText(v, bgRow.x + 35/zoom, offsetY + bgPos.y + 3/zoom, bgRow.w+bgRow.x, offsetY + bgPos.y + 3/zoom + bgRow.h, tocolor(210, 210, 210, 210), 0.7, font, "left", "center", false, true, true)
			
			if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w+30/zoom, bgRow.h) then 
				dxDrawRectangle(bgRowLine.x, bgPos.y+offsetY, bgRowLine.w, bgRowLine.h, tocolor(51, 102, 255, 255), true)
				selectedCategory = k
			end
		end
	else
		local scrollH = bgPos.h - 70/zoom
		dxDrawRectangle(bgPos.x + bgPos.w - 40/zoom, bgPos.y + 60/zoom, 20/zoom, scrollH, tocolor(30, 30, 30, 150), true)
		
		local scrollPos = 45/zoom
		if #teleportsData[teleportsCategory] > MAX_VISIBLE_ROWS then 
			scrollPos = (((selectedRow-1)/(#teleportsData[teleportsCategory]-MAX_VISIBLE_ROWS)) * (scrollH-40/zoom)) + 45/zoom
		end 
		
		dxDrawRectangle(bgPos.x + bgPos.w - 40/zoom, scrollPos + bgPos.y + 13/zoom, 20/zoom, 40/zoom, tocolor(51, 102, 255, 255), true)
		
		selectedTeleport = false 
		local n = 0 
		for k,v in ipairs(teleportsData[teleportsCategory]) do 
			if k >= selectedRow and k <= visibleRows then 
				n = n+1 
				
				local offsetY = 60/zoom + (n-1)*(3/zoom+bgRow.h)
				dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h, tocolor(30, 30, 30, 100), true)
				dxDrawText("/"..v.cmd, bgRow.x + 35/zoom, offsetY + bgPos.y + 3/zoom, bgRow.w+bgRow.x, (offsetY + bgPos.y)+bgRow.h, tocolor(210, 210, 210, 210), 0.7, font, "left", "center", false, true, true)
			
				if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h) then 
					dxDrawRectangle(bgRowLine.x, bgPos.y+offsetY, bgRowLine.w, bgRowLine.h, tocolor(51, 102, 255, 255), true)
					selectedTeleport = k
				end
			end
		end
	end
	--]]
end 

function toggleTeleports(teleports)
	if not getElementData(localPlayer, "player:spawned") then return end	
	if not showTeleports and isCursorShowing() then return end -- inne okno musi być otwarte 
	
	showTeleports = not showTeleports
	if showTeleports then 
		for k,v in ipairs(teleportsCategories) do 
			teleportsData[k] = {}
		end 
		
		for k,v in ipairs(teleports) do 
			table.insert(teleportsData[v.type], v)
		end 
		
		teleportsCategory = false 
		
		font = dxCreateFont("archivo_narrow.ttf", 24/zoom) or "default-bold"
				
		list1 = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-70/zoom, tocolor(20, 20, 20, 150), font, 0.65, 20/zoom)
		exports["ms-gui"]:addListColumn(list1, "Kategoria", 0.95)
		exports["ms-gui"]:setListActive(list1, true)
		for k,v in ipairs(teleportsCategories) do 
			exports["ms-gui"]:addListItem(list1, "Kategoria", v)
		end
		exports["ms-gui"]:reloadListRT(list1)
		
		addEventHandler("onClientRender", root, renderTeleports)
		showCursor(true)
		guiSetInputMode("no_binds")
	else 
		if isElement(font) then 
			destroyElement(font)
		end
		exports["ms-gui"]:setListActive(list1, false)
		exports["ms-gui"]:setListActive(list2, false)
		exports["ms-gui"]:destroyList(list1)
		exports["ms-gui"]:destroyList(list2)
		removeEventHandler("onClientRender", root, renderTeleports)
		showCursor(false)
		guiSetInputMode("allow_binds")
	end
end 
addEvent("onClientShowTeleportWindow", true)
addEventHandler("onClientShowTeleportWindow", root, toggleTeleports)

function onClientResourceStop()
	if showTeleports then 
		toggleTeleports()
	end
end 
addEventHandler("onClientResourceStop", resourceRoot, onClientResourceStop)