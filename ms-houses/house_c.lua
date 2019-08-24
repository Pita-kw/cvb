local font = false
local currentHouse = false 
local tab = 1 
local defaultTab = 1 
local selectedOption = false
local options = {
	"Wejdź",
	"Otwórz dom",
	"Przedłuż ważność",
	"Dodaj lokatora",
	"Usuń lokatora",
	"Resetuj meble",
	"Sprzedaj dom",
}
local edit = false 
local isRoommate = false
local lastButtonPressTick = 0 
local screenW, screenH = guiGetScreenSize()
local zoom = 1 
local baseX = 2400
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-(900/zoom/2), y=(screenH/2)-(500/zoom/2), w=900/zoom, h=500/zoom}
local bgLinePos = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}

function showHouseWindow(house)
	if not font then 
		font = dxCreateFont("archivo_narrow.ttf", 30/zoom)
	end
	
	setElementData(localPlayer, "block:player_teleport", true)
	setElementData(localPlayer, "block:vehicle_spawn", true)
	
	currentHouse = house
	
	isRoommate = false 
	for k,v in ipairs(fromJSON(currentHouse["roommates"])) do 
		if v[2] == getElementData(localPlayer, "player:uid") then 
			isRoommate = true
		end
	end 
	
	if currentHouse["owner"] ~=  -1 then 
		if currentHouse["owner"] == getElementData(localPlayer, "player:uid") or isRoommate then -- nasza to dodatkowe opcje pokazujemy
			defaultTab = 3 
			tab = 3
		else  -- nie nasza chalupka 
			defaultTab = 1
			tab = 1
		end 
	else -- dom do kupna
		defaultTab = 0 
		tab = 0 
	end
	
	addEventHandler("onClientRender", root, renderHouseWindow)
	loadDXEdit()
	
	showCursor(true)
	toggleAllControls(false)
	setTimer(function() addEventHandler("onClientKey", root, clickHouseWindow) end, 300, 1)
end 
addEvent("onClientShowHouseWindow", true)
addEventHandler("onClientShowHouseWindow", root, showHouseWindow)

function destroyHouseWindow()
	if isElement(font) then 
		destroyElement(font)
		font = false
	end
	
	setElementData(localPlayer, "block:player_teleport", false)
	setElementData(localPlayer, "block:vehicle_spawn", false)

	unloadDXEdit()
	
	showCursor(false)
	setTimer(toggleAllControls, 100, 1, true)
	removeEventHandler("onClientRender", root, renderHouseWindow)
	removeEventHandler("onClientKey", root, clickHouseWindow)
end 

function clickHouseWindow(key, state)
	if key == "mouse1" and state then 
		if isCursorOnElement(bgPos.x+bgPos.w-50/zoom, bgPos.y, 50/zoom, 50/zoom) then 
			if tab == defaultTab then 
				destroyHouseWindow() 
			else
				if edit then deleteEditBox("1") edit = false end 
				tab = defaultTab
			end 
			
			return 
		end 
		
		if lastButtonPressTick > getTickCount() then 
			return
		end 
		lastButtonPressTick = getTickCount()+200 
		
		if tab == 0 then -- kupno domu 
			if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then -- kup 
				tab = 2 
			elseif isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom) then -- wejdź
				triggerServerEvent("onPlayerEnterHouse", localPlayer, currentHouse["id"])
				destroyHouseWindow()
			end
		elseif tab == 1 then 
			if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then 
				triggerServerEvent("onPlayerKnock", localPlayer, currentHouse["id"])
				lastButtonPressTick = getTickCount()+1500 
			elseif isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom) then
				triggerServerEvent("onPlayerEnterHouse", localPlayer, currentHouse["id"])
				destroyHouseWindow()
			end
		elseif tab == 2 then -- płatność
			if isCursorOnElement(bgPos.x+(bgPos.w/2)-327/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then -- diamenty
				week = (((7)*24)*60)*60
				if currentHouse["owner"] == -1 then 
					triggerServerEvent("onPlayerBuyHouse", localPlayer, currentHouse["id"], 2, week)
				else 
					triggerServerEvent("onPlayerExtendHouse", localPlayer, currentHouse["id"], 2, week)
				end 
				
			elseif isCursorOnElement(bgPos.x+(bgPos.w/2)+150/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then  -- kasa
				week = (((7)*24)*60)*60
				if currentHouse["owner"] == -1 then 
					triggerServerEvent("onPlayerBuyHouse", localPlayer, currentHouse["id"], 1, week)
				else 
					triggerServerEvent("onPlayerExtendHouse", localPlayer, currentHouse["id"], 1, week)
				end 
			end
		elseif tab == 3 then 
			if selectedOption then 
				if isCursorOnElement(bgPos.x, bgPos.y + (selectedOption-1)*(70/zoom), bgPos.w*0.26, 70/zoom) then 
					if edit then deleteEditBox("1") edit = false end 
					
					if selectedOption == 1 then 
						triggerServerEvent("onPlayerEnterHouse", localPlayer, currentHouse["id"])
						destroyHouseWindow()
					elseif selectedOption == 2 then 
						triggerServerEvent("onPlayerLockHouse", localPlayer, currentHouse["id"])
						if currentHouse["locked"] == 1 then currentHouse["locked"] = 0 else currentHouse["locked"] = 1 end 
					elseif selectedOption == 3 then 
						tab = 2
					elseif selectedOption == 4 then 
						if isRoommate then 
							triggerEvent("onClientAddNotification", localPlayer, "Nie masz dostępu do tej opcji.", "error", 4000)
							return 
						end 
						
						tab = 4
						
						edit = true 
						--createEditBox( "1", (bgPos.x)/screenW, (bgPos.y+bgPos.h-145/zoom)/screenH, (bgPos.w)/screenW, (50/zoom)/screenH, true, "", false, 20, font, false, 0, { 255, 255, 255, 255 }, true, { 0, 0, 0, 0 }, 0.9/zoom, true, 60, true, "Wprowadź dane", { 255, 255, 255, 255 }, true, 0.8/zoom, font, true, true, {0, 114, 210}, true)
						add_lokator_edit = exports["ms-gui"]:createEditBox("", bgPos.x+300/zoom, bgPos.y+350/zoom, 300/zoom, 50/zoom, tocolor(230, 230, 230, 230), font, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(add_lokator_edit, "Wprowadź nick gracza")
					elseif selectedOption == 5 then 
						if isRoommate then 
							triggerEvent("onClientAddNotification", localPlayer, "Nie masz dostępu do tej opcji.", "error", 4000)
							return 
						end 
						tab = 5 
						edit = true
						--createEditBox( "1", (bgPos.x)/screenW, (bgPos.y+bgPos.h-145/zoom)/screenH, (bgPos.w)/screenW, (50/zoom)/screenH, true, "", false, 20, font, false, 0, { 255, 255, 255, 255 }, true, { 0, 0, 0, 0 }, 0.9/zoom, true, 60, true, "Wprowadź dane", { 255, 255, 255, 255 }, true, 0.8/zoom, font, true, true, {0, 114, 210}, true)
						delete_lokator_edit = exports["ms-gui"]:createEditBox("", bgPos.x+300/zoom, bgPos.y+350/zoom, 300/zoom, 50/zoom, tocolor(230, 230, 230, 230), font, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(delete_lokator_edit, "Wprowadź nick gracza")
					elseif selectedOption == 6 then 
						if isRoommate then 
							triggerEvent("onClientAddNotification", localPlayer, "Nie masz dostępu do tej opcji.", "error", 4000)
							return 
						end 
						triggerServerEvent("onPlayerTakeFurniture", localPlayer, localPlayer, currentHouse["id"])
					elseif selectedOption == 7 then 
						if isRoommate then 
							triggerEvent("onClientAddNotification", localPlayer, "Nie masz dostępu do tej opcji.", "error", 4000)
							return 
						end 
						
						tab = 6
					end
				end
			end
		elseif tab == 4 then 
			if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom) then 
				local text = exports["ms-gui"]:getEditBoxText(add_lokator_edit)
				triggerServerEvent("onPlayerAddRoommate", localPlayer, currentHouse["id"], text)
			end
		elseif tab == 5 then 
			if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom) then 
				local text = exports["ms-gui"]:getEditBoxText(delete_lokator_edit)
				triggerServerEvent("onPlayerDeleteRoommate", localPlayer, currentHouse["id"], text)
			end
		elseif tab == 6 then 
			if isCursorOnElement(bgPos.x+bgPos.w/2-170/zoom/2, bgPos.y+bgPos.h-150/zoom, 170/zoom, 50/zoom) then 
				local time = currentHouse["timestamp"]-getRealTime().timestamp
				time = time/60
				time = time/60 
				time = time/24 
				time = math.floor(time/7)
				
				local price = (currentHouse["price"]/2)*math.max(1, time)
				triggerServerEvent("onPlayerSellHouse", localPlayer, currentHouse["id"], price)
				destroyHouseWindow()
				return
			end
		end
	elseif key == "escape" and state then 
		destroyHouseWindow()
		cancelEvent()
	end
end 

function renderHouseWindow()
	if not currentHouse then return end 

	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(200, 200, 200, 255), true)
	dxDrawRectangle(bgLinePos.x, bgLinePos.y, bgLinePos.w, bgLinePos.h, tocolor(51, 102, 255, 255), true)
	if tab == 0 then 
		local diamonds = math.floor(currentHouse["price"]*0.005)
		
		dxDrawImage(bgPos.x+(bgPos.w/2)-(220/zoom)/2, bgPos.y+(bgPos.h/2)-220/zoom, 220/zoom, 220/zoom, "i/house_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(currentHouse["name"].." (ID: "..tostring(currentHouse["id"])..")", bgPos.x, bgPos.y+250/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		dxDrawText("Cena: $"..tostring(currentHouse["price"]).." lub "..tostring(diamonds).." diamentów | Meble GTA: "..tostring(currentHouse["disabledFurniture"] and "wyłączone" or "włączone"), bgPos.x, bgPos.y+300/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
		
		if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		
		if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		
		dxDrawText("Kup", bgPos.x+(bgPos.w/2)-22/zoom, bgPos.y+(bgPos.h/2)+108/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
		dxDrawText("Wejdź", bgPos.x+(bgPos.w/2)-33/zoom, bgPos.y+(bgPos.h/2)+168/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
	elseif tab == 1 then -- dom kupiony ale nie nasz
		dxDrawImage(bgPos.x+(bgPos.w/2)-(220/zoom)/2, bgPos.y+(bgPos.h/2)-220/zoom, 220/zoom, 220/zoom, "i/house_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(currentHouse["name"].." (ID: "..tostring(currentHouse["id"])..")", bgPos.x, bgPos.y+250/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		dxDrawText("Właściciel: "..currentHouse["ownerName"], bgPos.x, bgPos.y+300/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
		
		if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		
		if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+160/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		
		dxDrawText("Zapukaj", bgPos.x+(bgPos.w/2)-42/zoom, bgPos.y+(bgPos.h/2)+108/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
		dxDrawText("Wejdź", bgPos.x+(bgPos.w/2)-33/zoom, bgPos.y+(bgPos.h/2)+168/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
	elseif tab == 2 then -- kupno domu / przedłużenie  
		dxDrawText("Wybór płatności", bgPos.x, bgPos.y+30/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		dxDrawImage(bgPos.x+100/zoom, bgPos.y+(bgPos.h/2)-150/zoom, 220/zoom, 220/zoom, "i/diamonds_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawImage(bgPos.x+bgPos.w-340/zoom, bgPos.y+(bgPos.h/2)-150/zoom, 220/zoom, 220/zoom, "i/money_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
		if isCursorOnElement(bgPos.x+(bgPos.w/2)-327/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-327/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-327/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		
		if isCursorOnElement(bgPos.x+(bgPos.w/2)+150/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)+150/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)+150/zoom, bgPos.y+(bgPos.h/2)+100/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		
		local price = currentHouse["price"]
		local diamonds = math.floor(currentHouse["price"]*0.005)
		dxDrawText(tostring(diamonds), bgPos.x+(bgPos.w/2)-327/zoom, bgPos.y+(bgPos.h/2)+108/zoom, bgPos.x+(bgPos.w/2)-327/zoom+(170/zoom), 50/zoom, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
		dxDrawText("$"..tostring(price), bgPos.x+(bgPos.w/2)+150/zoom, bgPos.y+(bgPos.h/2)+108/zoom, bgPos.x+(bgPos.w/2)+150/zoom+(170/zoom), 50/zoom, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
	elseif tab == 3 then -- panel obslugi domku
		dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w*0.26, bgPos.h, tocolor(30, 30, 30, 100), true)
		dxDrawImage(bgPos.x+bgPos.w-(bgPos.w*0.26)-200/zoom, bgPos.y+(bgPos.h/2)-220/zoom, 220/zoom, 220/zoom, "i/house_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(currentHouse["name"].." (ID: "..tostring(currentHouse["id"])..")", (bgPos.w*0.26)+bgPos.x, bgPos.y+250/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		local roommates = fromJSON(currentHouse["roommates"])
		local txt = "brak"
		for k,v in ipairs(roommates) do 
			if txt == "brak" then txt = "" end 
			if #txt == 0 then 
				txt = v[1]  
				else 
				txt = txt..", "..v[1] 
			end 
		end 
		dxDrawText("Lokatorzy: "..txt.."\nWażny do: "..formatDate("h:i d/m/y", "'", currentHouse["timestamp"]), (bgPos.w*0.26)+bgPos.x, bgPos.y+300/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
		
		for k,v in ipairs(options) do 
			dxDrawRectangle(bgPos.x, bgPos.y + (k-1)*(70/zoom), bgPos.w*0.26, 70/zoom, tocolor(30, 30, 30, 100), true)
			if isCursorOnElement(bgPos.x, bgPos.y + (k-1)*(70/zoom), bgPos.w*0.26, 70/zoom) then 
				selectedOption = k
				dxDrawRectangle(bgPos.x, bgPos.y + (k-1)*(70/zoom), 5/zoom, 70/zoom, tocolor(51, 102, 255, 255), true)
			end
			
			if k == 2 then 
				if currentHouse["locked"] == 1 then 
					dxDrawText(v, bgPos.x, 20/zoom + bgPos.y + (k-1)*(70/zoom), bgPos.x+(bgPos.w*0.26), bgPos.h, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
				else 
					dxDrawText("Zamknij dom", bgPos.x, 20/zoom + bgPos.y + (k-1)*(70/zoom), bgPos.x+(bgPos.w*0.26), bgPos.h, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
				end
			else 
				dxDrawText(v, bgPos.x, 20/zoom + bgPos.y + (k-1)*(70/zoom), bgPos.x+(bgPos.w*0.26), bgPos.h, tocolor(200, 200, 200, 250), 0.6, font, "center", "top", false, false, true)
			end 
		end
	elseif tab == 4 then 
		dxDrawImage(bgPos.x+(bgPos.w/2)-(220/zoom)/2, bgPos.y+(bgPos.h/2)-220/zoom, 220/zoom, 220/zoom, "i/house_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText("Wprowadź dokładną nick gracza do dodania\n jako współlokator.", bgPos.x, bgPos.y+250/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		

		if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		dxDrawRectangle(bgPos.x+300/zoom, bgPos.y+350/zoom, 300/zoom, 50/zoom,  tocolor(30, 30, 30, 200), true)
		dxDrawText("Dodaj", bgPos.x+(bgPos.w/2)-28/zoom, bgPos.y+(bgPos.h/2)+177/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
		exports["ms-gui"]:renderEditBox(add_lokator_edit)
	elseif tab == 5 then 
		dxDrawImage(bgPos.x+(bgPos.w/2)-(220/zoom)/2, bgPos.y+(bgPos.h/2)-220/zoom, 220/zoom, 220/zoom, "i/house_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText("Wpisz dokładny nick współlokatora\ndo usunięcia.", bgPos.x, bgPos.y+250/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		

		if isCursorOnElement(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(bgPos.x+(bgPos.w/2)-(170/zoom)/2, bgPos.y+(bgPos.h/2)+170/zoom, 170/zoom, 50/zoom, tocolor(90, 90, 90, 120), true)
		end 
		dxDrawRectangle(bgPos.x+300/zoom, bgPos.y+350/zoom, 300/zoom, 50/zoom,  tocolor(30, 30, 30, 200), true)
		dxDrawText("Usuń", bgPos.x+(bgPos.w/2)-28/zoom, bgPos.y+(bgPos.h/2)+177/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
		
		exports["ms-gui"]:renderEditBox(delete_lokator_edit)
	elseif tab == 6 then -- sprzedaż
		dxDrawText("Sprzedaż domu", bgPos.x, bgPos.y+30/zoom, bgPos.w+bgPos.x, bgPos.h+bgPos.y, tocolor(200, 200, 200, 250), 0.9, font, "center", "top", false, false, true)
		local x, y, w, h = bgPos.x+bgPos.w/2-220/zoom/2, bgPos.y+(bgPos.h/2)-150/zoom, 220/zoom, 220/zoom
		dxDrawImage(x, y, w, h, "i/money_icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
		local x, y, w, h = bgPos.x+bgPos.w/2-170/zoom/2, bgPos.y+bgPos.h-150/zoom, 170/zoom, 50/zoom
		if isCursorOnElement(x, y, w, h) then 
			dxDrawRectangle(x, y, w, h, tocolor(90, 90, 90, 200), true)
		else 
			dxDrawRectangle(x, y, w, h, tocolor(90, 90, 90, 120), true)
		end 
		
		local time = currentHouse["timestamp"]-getRealTime().timestamp
		time = time/60
		time = time/60 
		time = time/24 
		time = math.floor(time/7)
		
		local price = (currentHouse["price"]/2)*math.max(1, time)
		dxDrawText("$"..tostring(price), x, y, x+w, y+h, tocolor(200, 200, 200, 250), 0.6, font, "center", "center", false, false, true)
	end
	
	if isCursorOnElement(bgPos.x+bgPos.w-50/zoom, bgPos.y, 50/zoom, 50/zoom) then 
		dxDrawRectangle(bgPos.x+bgPos.w-50/zoom, bgPos.y, 50/zoom, 50/zoom, tocolor(100, 100, 100, 150), true)
	end 
	dxDrawText("X", bgPos.x+bgPos.w-32/zoom, bgPos.y+10/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
end 

addEvent("onClientUpdateHouseWindowData", true)
addEventHandler("onClientUpdateHouseWindowData", root, function(house)
	currentHouse = house
	if house["owner"] == getElementData(localPlayer, "player:uid") then 
		if edit then deleteEditBox("1") edit = false end
		defaultTab = 3 
		tab = 3 
	end
end)

addEvent("onClientKnockRequest", true)
addEventHandler("onClientKnockRequest", root, 
	function()
		local snd = playSound("knock.wav", false)
		setSoundVolume(snd, 0.7)
	end 
)

local houseBlips = {} 
function housePreview(key, state)
	if state == "down" then 
		for k, v in ipairs(getElementsByType("pickup")) do 
			if getElementData(v, "house") then 
				local blip = createBlipAttachedTo(v, 31, 2, 255, 0, 0, 255, 0, 50)
				setElementData(blip, 'blipIcon', 'house')
				if getElementData(v, "house:owner") == -1 then 
					setElementData(blip, 'blipColor', {100,255,100,255})
				else 
					setElementData(blip, 'blipColor', {255,100,100,255})
				end
				
				table.insert(houseBlips, blip)
			end
		end
	elseif state == "up" then 
		for k, v in ipairs(houseBlips) do
			if isElement(v) then 
				destroyElement(v)
			end
		end
		
		houseBlips = {}
	end
end 
bindKey("k", "both", housePreview)

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

local function isCursorOnElement(x,y,w,h)
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

local function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	for i = 0, 4 do
		setInteriorFurnitureEnabled(i, true)
	end
end)

fileDelete("house_c.lua")