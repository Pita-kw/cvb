local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 1.6
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+200)/screenW)
end

local nickColors = {
	{26, 188, 156},
	{46, 204, 113},
	{52, 152, 219},
	{155, 89, 182},
	{52, 73, 94},
	{22, 160, 133},
	{39, 174, 96},
	{41, 128, 185},
	{142, 68, 173},
	{44, 62, 80},
	{241, 196, 15},
	{230, 126, 34},
	{231, 76, 60},
	{236, 240, 241},
	{149, 165, 166},
	{243, 156, 18},
	{211, 84, 0},
	{192, 57, 43},
	{189, 195, 199},
	{127, 140, 141},
}
local selectedColorIndex = false
local showColorPanel = false
local bgPos = {x=(screenW/2)-(400/zoom/2), y=(screenH/2)-(610/zoom/2), w=400/zoom, h=620/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}

function toggleColorList()
	if not getElementData(localPlayer, "player:spawned") then return end	
	if not showColorPanel and isCursorShowing() then return end -- blokada innych okien 
	
	showColorPanel = not showColorPanel
	if showColorPanel then 
		font = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 24/zoom) or "default-bold"
		addEventHandler("onClientRender", root, renderColorList)
		showCursor(true)
		guiSetInputMode("no_binds")
		
		list = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-120/zoom, tocolor(20, 20, 20, 150), font, 0.7, 20/zoom)
		exports["ms-gui"]:addListColumn(list, "Kolor", 0.8)
		for k,v in ipairs(nickColors) do
			local item = exports["ms-gui"]:addListItem(list, "Kolor", "Kolor "..tostring(k))
			exports["ms-gui"]:setListItemColor(list, item, v[1], v[2], v[3])
		end 
		exports["ms-gui"]:reloadListRT(list)
		exports["ms-gui"]:setListActive(list, true)
	else 
		removeEventHandler("onClientRender", root, renderColorList)
		if isElement(font) then 
			destroyElement(font)
		end
		showCursor(false)
		guiSetInputMode("allow_binds")
		
		if list then
			exports["ms-gui"]:setListActive(list, false)
			exports["ms-gui"]:destroyList(list)
			list = nil
		end 
	end
end 
addCommandHandler("kolor", toggleColorList)

function renderColorList()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255))
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	dxDrawText("Wybierz swój kolor na czacie", bgPos.x, bgPos.y + 10/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true)
	
	if list then 
		exports["ms-gui"]:renderList(list)
	end
	
	local selected = exports["ms-gui"]:getSelectedListItemsIndex(list)
	if #selected > 0 then 
		selectedColorIndex = selected[1]
	end 
	
	local x, y, w, h = bgPos.x+bgPos.w/2-150/zoom/2, bgPos.y+bgPos.h-55/zoom, 150/zoom, 40/zoom
	if isCursorOnElement(x, y, w, h) then
		local r, g, b = 51, 102, 255
		if nickColors[selectedColorIndex] then 
			r, g, b = nickColors[selectedColorIndex][1], nickColors[selectedColorIndex][2], nickColors[selectedColorIndex][3]
		end 
		
		dxDrawRectangle(x, y, w, h, tocolor(40, 40, 40, 200), true)
		dxDrawText("Akceptuj", x, y, x+w, y+h, tocolor(r, g, b, 250), 0.675, font, "center", "center", false, false, true)
		
		if getKeyState("mouse1") then
			if selectedColorIndex then 
				local hex = string.format("#%02X%02X%02X", r, g, b)
				setElementData(localPlayer, "player:nickColor", hex)
				
				triggerEvent("onClientAddNotification", localPlayer, "Zmieniłeś swój kolor nicku na czacie.", "info")
				toggleColorList()
				return
			end
		end
	else 
		dxDrawRectangle(x, y, w, h, tocolor(60, 60, 60, 150), true)
		dxDrawText("Akceptuj", x, y, x+w, y+h, tocolor(230, 230, 230, 250), 0.675, font, "center", "center", false, false, true)
	end 
	
	if isCursorOnElement(bgPos.x+bgPos.w-40/zoom, bgPos.y, 40/zoom, 40/zoom) then 
		dxDrawRectangle(bgPos.x+bgPos.w-40/zoom, bgPos.y, 40/zoom, 40/zoom, tocolor(50, 50, 50, 150), true)
		if getKeyState("mouse1") then 
			toggleColorList()
			return
		end
	end 
	
	dxDrawText("X", bgPos.x+bgPos.w-26/zoom, bgPos.y+10/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
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