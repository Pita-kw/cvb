Core = {} 
Core.attractions = {
	Carball,
	CTF,
	Derby, 
	Race,
	HideNSeek,
	US,
	TDM,
	Berek,
}

function Core.load()
	for k,attraction in ipairs(Core.attractions) do 
		attraction.load()
	end
	
	local screenW, screenH = guiGetScreenSize()
	zoom = exports["ms-hud"]:getInterfaceZoom()
	bgPos = {x=screenW-25/zoom-275/zoom, y=screenH-50/zoom-320/zoom, w=275/zoom, h=320/zoom}
	bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom} 
	
	Core.font = dxCreateFont("archivo_narrow.ttf", 27/zoom, false, "antialiased")
end 
addEventHandler("onClientResourceStart", resourceRoot, Core.load)

function Core.stop()
	if Core.entriesBlur then 
		exports["ms-blur"]:destroyBlurBox(Core.entriesBlur)
	end
	
	for k,attraction in ipairs(Core.attractions) do 
		attraction.stop()
	end
end 
addEventHandler("onClientResourceStop", resourceRoot, Core.stop)

function Core.loadEntries(entryInfo)
	if not entryInfo then return end 
	Core.entriesEndTick = getTickCount()+entryInfo.time
	Core.entriesName = entryInfo.name
	Core.entriesTeam =  getTeamFromName(Core.entriesName)
	Core.entriesCMD = entryInfo.cmd
end 
addEvent("onClientLoadEntries", true)
addEventHandler("onClientLoadEntries", root, Core.loadEntries)

function Core.renderEntries()
	if getElementData(localPlayer, "player:spawned") and (getCameraTarget() and (getCameraTarget() == localPlayer or getCameraTarget() == getPedOccupiedVehicle(localPlayer))) and not getElementData(localPlayer, "player:solo") then 
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(220, 220, 220, 255))
		dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
		local states =  getElementData(resourceRoot, "attraction:states")
		local starting = states["starting"]
		local started = states["started"]
	
		for k, attraction in ipairs(Core.attractions) do 			
			local offsetY = (k-1)*(40/zoom)
			local x, y, w, h = bgPos.x, bgPos.y+offsetY, bgPos.w, 40/zoom
			if started[attraction.cmd] then
				dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 75), true)
				dxDrawText("TRWA", x, y, x+w-15/zoom, y+h, tocolor(230, 230, 230, 255), 0.7, Core.font, "right", "center", false, true, true)
			elseif starting[attraction.cmd] then 
				dxDrawRectangle(x, y, w, h, tocolor(52, 152, 219, 75), true)
				dxDrawText("STARTUJE", x, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.5, Core.font, "center", "center", false, true, true)
				dxDrawText(tostring(#getElementData(resourceRoot, "attraction:start_players_"..attraction.cmd)).."/"..tostring(getElementData(resourceRoot, "attraction:min_players_"..attraction.cmd)), x, y, x+w-15/zoom, y+h, tocolor(230, 230, 230, 255), 0.7, Core.font, "right", "center", false, true, true)
			else 
				if k % 2 == 0 then
					dxDrawRectangle(x, y, w, h, tocolor(40, 40, 40, 150), true)
				else 
					dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 150), true)
				end
				
				dxDrawText(tostring(#getElementData(resourceRoot, "attraction:start_players_"..attraction.cmd)).."/"..tostring(getElementData(resourceRoot, "attraction:min_players_"..attraction.cmd)), x, y, x+w-15/zoom, y+h, tocolor(230, 230, 230, 255), 0.7, Core.font, "right", "center", false, true, true)
			end
			dxDrawText("/"..attraction.cmd, x+15/zoom, y, x+w, y+h, tocolor(230, 230, 230, 255), 0.7, Core.font, "left", "center", false, true, true)
		end 
		
		--[[
		local time = math.floor((Core.entriesEndTick-getTickCount())/1000)
		if time < 1 then 
			Core.entriesEndTick = false
			Core.entriesName = false
			Core.entriesTeam =  false
			Core.entriesCMD = false
			return 
		end 
		
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(220, 220, 220, 255))
		dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
		dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
		dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
		dxDrawText(Core.entriesName, bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, Core.font, "center", "top", false, true, true)
		if getPlayerTeam(localPlayer) == Core.entriesTeam then 
			dxDrawText("By się wypisać wpisz komendę /wypisz.", bgPos.x, bgPos.y + 50/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.55, Core.font, "center", "top", false, true, true)
		else 
			dxDrawText("By dołączyć wpisz komendę /"..Core.entriesCMD, bgPos.x, bgPos.y + 50/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.55, Core.font, "center", "top", false, true, true)
		end 
		
		dxDrawText(tostring(#(getElementData(resourceRoot, "attraction:start_players") or {})), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
		dxDrawText("zapisanych", bgPos.x, bgPos.y + 55/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
		
		dxDrawText(tostring(time),bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
		dxDrawText("czas", bgPos.x+bgPos.w-90/zoom, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
		--]]
	end
end 
addEventHandler("onClientRender", root, Core.renderEntries)

function Core.loadCustomScript(path)
	if not fileExists(path) then 
		outputDebugString("Skrypt "..tostring(path).." nie istnieje", 1)
		return 
	end 
	
	local file = fileOpen(path, true)
	local size = fileGetSize(file)
	local data = fileRead(file, size)
	local luaData = loadstring(data)
	pcall(luaData)
	loadResources()
	loadResources = nil
	fileClose(file)
	
	outputDebugString("Załadowano niestandardowy skrypt "..tostring(path)..".", 3)
end 

function Core.unloadCustomScript()
	if unloadResources then 
		unloadResources()
		unloadResources = nil
		outputDebugString("Odładowano niestandardowy skrypt.", 3)
	end
end

function getInterfacePosition()
	return bgPos.x, bgPos.y, bgPos.w, bgPos.h
end 

function getInterfaceZoom()
	return zoom
end
