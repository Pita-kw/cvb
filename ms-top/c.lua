local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 1.7
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local tabs = {"Eventy", "Areny", "Inne"}
local tabsCategories = {
	["Eventy"] = {
		"Wygrane w Uważaj, Spadasz!",
		"Wygrane w Berka",
		"Wygrane w Race",
		"Wygrane w Derby",
		"Wygrane w Wojnach Hunterów",
		"Wygrane w TDM",
		"Wygrane w CTF",
	},
	
	["Areny"] = {
		"Fragi na Dust",
		"Fragi na Onede",
		"Fragi na Bazooka",
		"Fragi na Minigun",
		"Fragi na Sniper",
	},
	
	["Inne"] = {
		"EXP",
		"Kasa",
		"Zabicia",
		"Śmierci",
		"Wykonanych prac",
		"Zabitych zombie",
		"Wygranych solo",
		"Przegrany czas",
		"Najlepszy drift",
		"Największy przebieg",
	},
}

local topData = {} 
local topDataLoaded = false 

local hoveredTab = false
local selectedTab = 1 
local selectedCategory = false 

local bgPos = {x=(screenW/2)-(650/zoom/2), y=(screenH/2)-(550/zoom/2), w=650/zoom, h=550/zoom}

local showing = false

function showTopWindow()
	showing = not showing
	
	if showing then 
		showCursor(true)
		topDataLoaded = false 
		selectedTab = 1
		selectedCategory = false 
		 
		font = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 20/zoom)
		list = exports["ms-gui"]:createList(bgPos.x+51/zoom, bgPos.y+120/zoom, bgPos.w-100/zoom, bgPos.h-180/zoom, tocolor(20, 20, 20, 150), font, 0.8, 20/zoom)
		exports["ms-gui"]:addListColumn(list, "Kategoria", 1)
		
		for k,v in ipairs(tabsCategories[tabs[selectedTab]]) do 
			exports["ms-gui"]:addListItem(list, "Kategoria", v)
		end
		exports["ms-gui"]:reloadListRT(list)
		exports["ms-gui"]:setListActive(list, true)
		
		addEventHandler("onClientRender", root, renderTopWindow)
		addEventHandler("onClientKey", root, keyTopWindow)
		triggerServerEvent("onPlayerRequestTopData", localPlayer)
	else 
		setTimer(showCursor, 50, 1, false)
		if isElement(font) then destroyElement(font) font = nil end 
		exports["ms-gui"]:setListActive(list, false)
		exports["ms-gui"]:destroyList(list)
		
		removeEventHandler("onClientRender", root, renderTopWindow)
		removeEventHandler("onClientKey", root, keyTopWindow)
 	end
end 
addCommandHandler("top", showTopWindow)

function keyTopWindow(key, press)
	if key == "mouse1" and press then 
		if hoveredTab then 
			local offsetX = 100/zoom * (hoveredTab-1)
			local x, y, w, h = bgPos.x+50/zoom+offsetX, bgPos.y+120/zoom-50/zoom, 100/zoom, 50/zoom
			if isCursorOnElement(x, y, w, h) then 
				selectedTab = hoveredTab 
				hoveredTab = false
				selectedCategory = false 
				
				exports["ms-gui"]:setListActive(list, false)
				exports["ms-gui"]:destroyList(list)
				
				list = exports["ms-gui"]:createList(bgPos.x+51/zoom, bgPos.y+120/zoom, bgPos.w-100/zoom, bgPos.h-180/zoom, tocolor(20, 20, 20, 150), font, 0.8, 20/zoom)
				exports["ms-gui"]:addListColumn(list, "Kategoria", 1)
				
				for k,v in ipairs(tabsCategories[tabs[selectedTab]]) do 
					exports["ms-gui"]:addListItem(list, "Kategoria", v)
				end
				exports["ms-gui"]:reloadListRT(list)
				exports["ms-gui"]:setListActive(list, true)
			end
		end 
		
		if isCursorOnElement(bgPos.x+bgPos.w-50/zoom, bgPos.y, 50/zoom, 50/zoom) then 
			if selectedCategory then 
				selectedCategory = false 
				exports["ms-gui"]:setListActive(list, false)
				exports["ms-gui"]:destroyList(list)
				
				list = exports["ms-gui"]:createList(bgPos.x+51/zoom, bgPos.y+120/zoom, bgPos.w-100/zoom, bgPos.h-180/zoom, tocolor(20, 20, 20, 150), font, 0.8, 20/zoom)
				exports["ms-gui"]:addListColumn(list, "Kategoria", 1)
				
				for k,v in ipairs(tabsCategories[tabs[selectedTab]]) do 
					exports["ms-gui"]:addListItem(list, "Kategoria", v)
				end
				exports["ms-gui"]:reloadListRT(list)
				exports["ms-gui"]:setListActive(list, true)
			else
				showTopWindow()
			end
		end
	end
end 

function onClientGetTopData(data)
	topData = data
	topDataLoaded = true
end 
addEvent("onClientGetTopData", true)
addEventHandler("onClientGetTopData", root, onClientGetTopData)

function renderTopWindow()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255))
	dxDrawText("Najlepsze statystyki", bgPos.x, bgPos.y+15/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(255, 255, 255, 255), 0.9, font, "center", "top", false, false, true)
	
	if not topDataLoaded then
		exports["ms-gui"]:renderLoading(bgPos.x+bgPos.w/2-128/zoom/2, bgPos.y+bgPos.h/2-128/zoom/2, 128/zoom, 128/zoom)
	else
		for k,v in ipairs(tabs) do 
			local offsetX = 100/zoom * (k-1)
			local x, y, w, h = bgPos.x+50/zoom+offsetX, bgPos.y+120/zoom-50/zoom, 100/zoom, 50/zoom
			
			if selectedTab == k then 
				dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 150), true)
				dxDrawText(v, x, y, x+w, y+h, tocolor(51, 102, 255, 255), 0.75, font, "center", "center", false, false, true)
			elseif isCursorOnElement(x, y, w, h) then
				dxDrawRectangle(x, y, w, h, tocolor(40, 40, 40, 150), true)
				dxDrawText(v, x, y, x+w, y+h, tocolor(51, 102, 255, 255), 0.75, font, "center", "center", false, false, true)
				hoveredTab = k
			else 
				dxDrawRectangle(x, y, w, h, tocolor(40, 40, 40, 150), true)
				dxDrawText(v, x, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.75, font, "center", "center", false, false, true)
			end
		end 
		
		--dxDrawRectangle(bgPos.x+50/zoom, bgPos.y+120/zoom, bgPos.w-100/zoom, bgPos.h-145/zoom, tocolor(20, 20, 20, 150), true)
		local selected = exports["ms-gui"]:getSelectedListItemsIndex(list)
		if #selected > 0 and not selectedCategory then 
			selectedCategory = selected[1]
			exports["ms-gui"]:setListActive(list, false)
			exports["ms-gui"]:destroyList(list)
		
			list = exports["ms-gui"]:createList(bgPos.x+51/zoom, bgPos.y+120/zoom, bgPos.w-100/zoom, bgPos.h-180/zoom, tocolor(20, 20, 20, 150), font, 0.8, 20/zoom)
			exports["ms-gui"]:addListColumn(list, "Lp", 0.1)
			exports["ms-gui"]:addListColumn(list, "Nazwa gracza", 0.55)
			exports["ms-gui"]:addListColumn(list, "Wartość", 0.25)
			
			local tabName = tabs[selectedTab]
			local categoryName = tabsCategories[tabName][selectedCategory]
			for k,v in ipairs(topData[categoryName]) do 
				exports["ms-gui"]:addListItem(list, "Lp", tostring(k)..".")
				exports["ms-gui"]:addListItem(list, "Nazwa gracza", v.name)
				if categoryName == "Największy przebieg" then 
					exports["ms-gui"]:addListItem(list, "Wartość", tostring(math.floor(v.value/1000)).."km")
				elseif categoryName == "Przegrany czas" then 
					exports["ms-gui"]:addListItem(list, "Wartość", (math.floor((v.value/60)/60)).."h")
				else
					exports["ms-gui"]:addListItem(list, "Wartość", v.value)
				end
			end
			exports["ms-gui"]:reloadListRT(list)
			exports["ms-gui"]:setListActive(list, true)
		end 
		
		exports["ms-gui"]:renderList(list)
	end 
	
	dxDrawText("Ostatnie odświeżenie: "..formatDate("h:i:s", "'", getElementData(resourceRoot, "top:last_refresh")).." (odswieżanie co godzinę)", bgPos.x, bgPos.y+bgPos.h-50/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(255, 255, 255, 255), 0.8, font, "center", "top", false, false, true)
	
	local x, y, w, h = bgPos.x+bgPos.w-50/zoom, bgPos.y, 50/zoom, 50/zoom
	if isCursorOnElement(x, y, w, h) then 
		dxDrawRectangle(x, y, w, h, tocolor(100, 100, 100, 150), true)
	end 
	
	if selectedCategory then 
		dxDrawText("➜", x, y, x+w, y+h, tocolor(250, 250, 250, 250), 0.9, font, "center", "center", false, false, true, false, false, 180)
	else 
		dxDrawText("X", x, y, x+w, y+h, tocolor(250, 250, 250, 250), 0.9, font, "center", "center", false, false, true)
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

function table.len(tbl)
	local n = 0 
	for key in pairs(tbl) do 
		n = n+1
	end
	
	return n
end 

local gWeekDays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
function formatDate(format, escaper, timestamp)
	escaper = (escaper or "'"):sub(1, 1)
	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false

	time.year = time.year + 1900
	time.month = time.month + 1
	
	local datetime = { d = ("%02d"):format(time.monthday), h = ("%02d"):format(time.hour), i = ("%02d"):format(time.minute), m = ("%02d"):format(time.month), s = ("%02d"):format(time.second), w = gWeekDays[time.weekday+1]:sub(1, 2), W = gWeekDays[time.weekday+1], y = tostring(time.year):sub(-2), Y = time.year }
	
	for char in format:gmatch(".") do
		if (char == escaper) then escaped = not escaped
		else formattedDate = formattedDate..(not escaped and datetime[char] or char) end
	end
	
	return formattedDate
end

addEventHandler("onClientResourceStop", resourceRoot, function() if showing then showTopWindow() end end)