local MAX_VISIBLE_ROWS = 9

local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+350)/screenW)
end 
local selectedRow = 1
local visibleRows = MAX_VISIBLE_ROWS
local furnitureData = {} 
local showing = false 

local bgPos = {x=screenW-400/zoom, y=screenH-550/zoom, w=350/zoom, h=500/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}
local bgRow = {x=bgPos.x+20/zoom, w=bgPos.w-75/zoom, h=45/zoom}
local bgRowLine = {x=bgRow.x, w=10/zoom, h=bgRow.h}

local furnitureBlur = false 

function showFurnitureList(data)
	if getElementData(localPlayer, "player:inFurnitureShop") == true then return end
	if showing then destroyFurnitureList() return end
	if getElementData(localPlayer, "player:inEditor") then return end 
	
	showing = true 
	setElementData(localPlayer, "player:inFurnitureMenu", true)
	font = dxCreateFont("archivo_narrow.ttf", math.floor(20/zoom), false, "cleartype_natural")
	addEventHandler("onClientRender", root, renderFurnitureList)
	addEventHandler("onClientRender", root, renderFurnitureIDs)
	addEventHandler("onClientKey", root, keyFurnitureList)
	showCursor(true)
	guiSetInputMode("no_binds")
	selectedFurniture = false 
	furnitureData = data 
	scrollY = 0 
	maxScroll = 0 
	selectedRow = 1
	visibleRows = MAX_VISIBLE_ROWS
	furnitureBlur = exports["ms-blur"]:createBlurBox(bgPos.x, bgPos.y, bgPos.w, bgPos.h, 255, 255, 255, 255, false) 
end 
addEvent("onPlayerShowFurnitureWindow", true)
addEventHandler("onPlayerShowFurnitureWindow", root, showFurnitureList)

function destroyFurnitureList()
	showing = false 
	setElementData(localPlayer, "player:inFurnitureMenu", false)
	removeEventHandler("onClientRender", root, renderFurnitureList)
	removeEventHandler("onClientRender", root, renderFurnitureIDs)
	removeEventHandler("onClientKey", root, keyFurnitureList)
	showCursor(false)
	guiSetInputMode("allow_binds")
	if isElement(font) then destroyElement(font) end
	if furnitureBlur then exports["ms-blur"]:destroyBlurBox(furnitureBlur) end
end 

function keyFurnitureList(key, press)
	if key == "mouse1" and press then 
		if selectedFurniture then 
			if furnitureData[selectedFurniture] then 
				triggerEvent("onPlayerShowObjectEditor", localPlayer, furnitureData[selectedFurniture]["objectid"], furnitureData[selectedFurniture]["id"])
				destroyFurnitureList()
			end 
		end
	elseif key == "mouse_wheel_up" then 
		selectedRow = math.max(1, selectedRow-1)
		visibleRows = math.max(MAX_VISIBLE_ROWS, visibleRows-1)
		
		if visibleRows < MAX_VISIBLE_ROWS then visibleRows = MAX_VISIBLE_ROWS end 
	elseif key == "mouse_wheel_down" then 
		local plrs = #furnitureData
		if selectedRow > plrs-MAX_VISIBLE_ROWS then return end 
			
		selectedRow = selectedRow+1
		visibleRows = visibleRows+1
		if selectedRow > plrs then selectedRow = plrs end
		if visibleRows > plrs then visibleRows = plrs-MAX_VISIBLE_ROWS end 
	end 
end 

function renderFurnitureList()
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(30, 30, 30, 150), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	dxDrawText("Dostępne meble", bgPos.x, bgPos.y + 10/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
	
	local scrollH = bgPos.h - 70/zoom
	dxDrawRectangle(bgPos.x + bgPos.w - 50/zoom, bgPos.y + 60/zoom, 30/zoom, scrollH, tocolor(30, 30, 30, 150), true)
		
	local scrollPos = 45/zoom
	if #furnitureData > MAX_VISIBLE_ROWS then 
		scrollPos = (((selectedRow-1)/(#furnitureData-MAX_VISIBLE_ROWS)) * (scrollH-40/zoom)) + 45/zoom
	end 
		
	dxDrawRectangle(bgPos.x + bgPos.w - 50/zoom, scrollPos + bgPos.y + 13/zoom, 30/zoom, 40/zoom, tocolor(51, 102, 255, 255), true)
	
	selectedFurniture = false
	local n = 0 
	for k,v in ipairs(furnitureData) do 
		if k >= selectedRow and k <= visibleRows then 
			n = n+1 
			local offsetY = 60/zoom + (n-1)*(3/zoom+bgRow.h)
			
			dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h, tocolor(30, 30, 30, 100), true)
			dxDrawText("ID "..tostring(v["objectid"]).." ("..tostring(v["type"])..")", math.floor(bgRow.x + 35/zoom), math.floor(offsetY + bgPos.y + 5/zoom), bgRow.w+bgRow.x, bgRow.h, tocolor(200, 200, 200, 200), 0.8, font, "left", "top", false, true, true)
			if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h) then 
				dxDrawRectangle(bgRowLine.x, bgPos.y+offsetY, bgRowLine.w, bgRowLine.h, tocolor(51, 102, 255, 255), true)
				selectedFurniture = k
			end
		end
	end
end 

local furnitureObjects = {} 
function onPlayerCreateFurniture(furniture)
	for k,v in ipairs(furniture) do 
		local model = v["objectid"]
		local pos = fromJSON(v["pos"])
		local rot = fromJSON(v["rot"])
		local int = v["interior"]
		local dim = v["dimension"]
		local obj = createObject(model, pos[1], pos[2], pos[3])
		setElementRotation(obj, rot[1], rot[2], rot[3])
		setElementInterior(obj, int)
		setElementDimension(obj, dim)
		if getElementData(localPlayer, "player:houseOwner") then 
			setElementData(obj, "furniture", v["id"])
		end 
		
		table.insert(furnitureObjects, obj)
	end 
end 
addEvent("onPlayerCreateFurniture", true)
addEventHandler("onPlayerCreateFurniture", root, onPlayerCreateFurniture)

function onPlayerDeleteFurniture()
	for k,v in ipairs(furnitureObjects) do 
		if isElement(v) then 
			destroyElement(v)
		end 
	end 
end 
addEvent("onPlayerDeleteFurniture", true)
addEventHandler("onPlayerDeleteFurniture", root, onPlayerDeleteFurniture)

function renderFurnitureIDs()
	local px,py,pz = getElementPosition(localPlayer)
	local cx,cy,cz = getCameraMatrix()
	for k,v in ipairs(furnitureObjects) do 
		local id = getElementData(v, "furniture")
		if id then 
			local vx, vy, vz = getElementPosition(v)
			dist = getDistanceBetweenPoints3D(vx,vy,vz,px,py,pz)
			if dist < 5 then 
				local sx,sy=getScreenFromWorldPosition(vx, vy, vz+0.6)
				if sx and sy then
					dxDrawText("Aby schować ten mebel do ekwipunku wpisz: /schowaj "..tostring(id).."", sx+1, sy+1, sx+1, sy+1, tocolor(0,0,0,200), 1.0, "default-bold", 'center', 'center', false, false, false, true)
					dxDrawText("Aby schować ten mebel do ekwipunku wpisz: /schowaj "..tostring(id).."", sx, sy, sx, sy, tocolor(255,255,255,200), 1.0, "default-bold", 'center', 'center', false, false, false, true)
				end
			end
		end
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


function deleteFurnitureObject(command, id)
	for k,v in ipairs(furnitureObjects) do
		if isElement(v) then
			if getElementData(v, "furniture") == tonumber(id) then
				triggerServerEvent ("deleteObjectHandler", localPlayer, localPlayer, getElementData(v, "furniture"))
				destroyElement(v)
				table.remove(furnitureObjects, k)
			end
		end
	end
end
addCommandHandler("schowaj", deleteFurnitureObject)

fileDelete("furniture_c.lua")