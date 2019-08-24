--[[
	MultiServer 
	Zasób: ms-vehicles_spawn/c.lua
	Opis: Panel spawnu darmowych pojazdów pod F2. Tak, nie mam pojęcia jak działa scroll w tym skrypcie XD
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]
local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 1.6
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+200)/screenW)
end 


local vehiclePanelData = {}
local lastPanelData = {}

local showVehiclePanel = false
local bgPos = {x=(screenW/2)-(400/zoom/2), y=(screenH/2)-(610/zoom/2), w=400/zoom, h=620/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}

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

local lastPanelData = vehiclePanelData
function searchVehicle(name)
	if #name == 0 then 
		vehiclePanelData = defaultVehiclePanelData
	else 
		if tonumber(name) ~= nil and name ~= "inf" and name ~= "Inf" then 
			name = getVehicleNameFromModel(tonumber(name)) or ""
		end 
		
		name = name:gsub("^%l", string.upper) -- zaczyna sie od duzej litery :E

		vehiclePanelData = {} 
		for k, group in ipairs(defaultVehiclePanelData) do
			for i, vehicle in ipairs(group.groupVehicles) do
				if #vehicle.name > 0 and vehicle.name:find(name, 1, true) then 
					table.insert(vehiclePanelData, vehicle)
				end
			end
		end
	end
	
	if #vehiclePanelData ~= #lastPanelData then 
		if not list2 and list then 
			exports["ms-gui"]:destroyList(list)
			exports["ms-gui"]:setListActive(list, false)
			list = nil 
			
			list2 = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-120/zoom, tocolor(20, 20, 20, 150), font, 0.65, 20/zoom)
			exports["ms-gui"]:addListColumn(list2, "Nazwa pojazdu", 0.7)
			exports["ms-gui"]:addListColumn(list2, "ID", 0.3)
			exports["ms-gui"]:setListActive(list2, true)
		end 
		
		exports["ms-gui"]:clearList(list2)
		for k,v in ipairs(vehiclePanelData) do 
			exports["ms-gui"]:addListItem(list2, "Nazwa pojazdu", v.name)
			exports["ms-gui"]:addListItem(list2, "ID", v.id)
		end 
		exports["ms-gui"]:reloadListRT(list2)
	end
	lastPanelData = vehiclePanelData
	return #name > 0
end 

function renderVehiclePanel()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255))
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	dxDrawText("Spawn pojazdów", bgPos.x, bgPos.y + 10/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true)
	
	local text = exports["ms-gui"]:getEditBoxText(edit)
	local searching = searchVehicle(text)
	
	if list then
		exports["ms-gui"]:renderList(list)
		local selected = exports["ms-gui"]:getSelectedListItemsIndex(list)
		if #selected > 0 then 
			selectedGroup = selected[1]
			
			exports["ms-gui"]:setListActive(list, false)
			exports["ms-gui"]:destroyList(list)
			list = nil 
			
			list2 = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-120/zoom, tocolor(20, 20, 20, 150), font, 0.65, 20/zoom)
			exports["ms-gui"]:addListColumn(list2, "Nazwa pojazdu", 0.7)
			exports["ms-gui"]:addListColumn(list2, "ID", 0.3)
			
			vehiclePanelData = getXMLVehicles()
			lastPanelData = vehiclePanelData
			
			table.insert(vehiclePanelData[selectedGroup].groupVehicles, 1, {name="...", id=" "})
			for k,v in ipairs(vehiclePanelData[selectedGroup].groupVehicles) do
				exports["ms-gui"]:addListItem(list2, "Nazwa pojazdu", v.name)
				exports["ms-gui"]:addListItem(list2, "ID", tostring(v.id))
			end 
			exports["ms-gui"]:reloadListRT(list2)
			exports["ms-gui"]:setListActive(list2, true)
		end
	elseif list2 then 
		exports["ms-gui"]:renderList(list2)
		local selected = exports["ms-gui"]:getSelectedListItemsIndex(list2)
		if #selected > 0 then 
			-- powrót do przeglądu kategorii
			if searching then 
				triggerServerEvent("onClientVehicleSpawn", localPlayer, getVehicleNameFromModel(vehiclePanelData[selected[1]].id))
				toggleVehiclePanel()
				return
			else
				if selected[1] == 1 then 
					if list2 then 
						exports["ms-gui"]:setListActive(list2, false)
						exports["ms-gui"]:destroyList(list2)
						list2 = nil
					end
					
					vehiclePanelData = getXMLVehicles()
					lastPanelData = vehiclePanelData
					
					list = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-120/zoom, tocolor(20, 20, 20, 150), font, 0.65, 20/zoom)
					exports["ms-gui"]:addListColumn(list, "Kategoria", 0.8)
					for k,v in ipairs(vehiclePanelData) do
						exports["ms-gui"]:addListItem(list, "Kategoria", "+ "..v.groupName)
					end 
					exports["ms-gui"]:reloadListRT(list)
					exports["ms-gui"]:setListActive(list, true)
				else -- spawn pojazdu
					triggerServerEvent("onClientVehicleSpawn", localPlayer, getVehicleNameFromModel(vehiclePanelData[selectedGroup].groupVehicles[selected[1]-1].id))
					toggleVehiclePanel()
					return
				end
			end
		end
	end
	
	-- szukajka 
	dxDrawRectangle(bgPos.x+20/zoom, bgPos.y+bgPos.h-65/zoom, bgPos.w-40/zoom, 50/zoom, tocolor(20, 20, 20, 150), true)
	exports["ms-gui"]:renderEditBox(edit)
end 

function getXMLGroupVehicles(xmlGroup)
	if xmlGroup then
		local vehicles = {} 
		local child = false 
		local index = 0 
		
		repeat 
			child = xmlFindChild(xmlGroup, "vehicle", index)
			index = index+1
			if child then
				table.insert(vehicles, {name=xmlNodeGetAttribute(child, "name"), id=tonumber(xmlNodeGetAttribute(child, "id"))})
			end
		until child == false
		
		table.sort(vehicles, function(a, b) return a.name < b.name end)
		return vehicles
	end
	
	return {}
end 

function getXMLVehicles()
	local vehicles = {}
	local xml = xmlLoadFile("vehicles.xml")
	if xml then
		local groupIndex = 0 
		local groupChild = false
		repeat 
			-- grupy 
			groupChild = xmlFindChild(xml, "group", groupIndex)
			if groupChild then 
				local groupName = xmlNodeGetAttribute(groupChild, "name")
				local groupVehicles = getXMLGroupVehicles(groupChild)
				table.insert(vehicles, {groupName=groupName, groupVehicles=groupVehicles})
			end
			
			groupIndex = groupIndex+1
		until groupChild == false
	end
	xmlUnloadFile(xml)
	
	return vehicles
end 

function toggleVehiclePanel()
	if not getElementData(localPlayer, "player:spawned") then return end	
	if not showVehiclePanel and isCursorShowing() then return end -- blokada innych okien 
	
	showVehiclePanel = not showVehiclePanel
	if showVehiclePanel then 
		selectedGroup = false 
		
		font = dxCreateFont("archivo_narrow.ttf", 24/zoom) or "default-bold"
		addEventHandler("onClientRender", root, renderVehiclePanel)
		showCursor(true)
		guiSetInputMode("no_binds")
				
		vehiclePanelData = getXMLVehicles()
		lastPanelData = vehiclePanelData
		defaultVehiclePanelData = vehiclePanelData
		
		list = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+50/zoom, bgPos.w-30/zoom, bgPos.h-120/zoom, tocolor(20, 20, 20, 150), font, 0.65, 20/zoom)
		exports["ms-gui"]:addListColumn(list, "Kategoria", 0.8)
		for k,v in ipairs(vehiclePanelData) do
			exports["ms-gui"]:addListItem(list, "Kategoria", "+ "..v.groupName)
		end 
		exports["ms-gui"]:reloadListRT(list)
		exports["ms-gui"]:setListActive(list, true)
		
		edit = exports["ms-gui"]:createEditBox("", bgPos.x+30/zoom, bgPos.y+bgPos.h-65/zoom, bgPos.w-40/zoom, 50/zoom, tocolor(230, 230, 230, 230), font, 0.6)
		exports["ms-gui"]:setEditBoxHelperText(edit, "Wprowadź nazwę lub ID pojazdu")
	else 
		removeEventHandler("onClientRender", root, renderVehiclePanel)
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
		
		if list2 then 
			exports["ms-gui"]:setListActive(list2, false)
			exports["ms-gui"]:destroyList(list2)
			list2 = nil
		end
		
		exports["ms-gui"]:destroyEditBox(edit)
	end
end 
bindKey("f2", "down", toggleVehiclePanel)

function onClientResourceStop()
	if showVehiclePanel then 
		toggleVehiclePanel()
	end
end 
addEventHandler("onClientResourceStop", resourceRoot, onClientResourceStop)