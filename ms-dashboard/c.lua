local tabs = {
	{"Ustawienia", "icons/settings.png", 52, 152, 219},
	{"Sklep", "icons/shop.png", 241, 196, 15},
	{"Pojazdy", "icons/vehicles.png", 230, 126, 34},
	{"Osiągnięcia", "icons/achievements.png", 155, 89, 182},
	{"Statystyki", "icons/stats.png", 46, 204, 113},
}

local tabData = {
	[1] = {
		title="Ustawienia",
		tabs={
					{"Zmień nick", "Znudził ci się twój nick? Zmień go na dowolny dostępny.", "icons/nickname.png"},
					{"Zmień hasło", "Twoje hasło już nie jest bezpieczne? Możesz je tutaj zmienić.", "icons/password.png"},
					{"Zmień email", "Zaktualizuj swój nieaktualny email.", "icons/email.png"},
					{"Zarządzaj avatarem", "Pokaż czym się interesujesz. Wyraź siebie.", "icons/avatar.png"},
					{"Ustawienia graficzne", "Dostosuj grafikę do twojego komputera.", "icons/graphic_settings.png"},
					{"Ustawienia personalne", "Dodatkowe opcje związane z rozgrywką.", "icons/personal_settings.png"},
				}
	},
	[2] = {
		title="Sklep",
		tabs={{7, 250}, {14, 500}, {30, 1000}, {0, 1000}}
	},
	[3] = {
		title="Posiadane pojazdy",
		options={"Spawn", "Teleportuj", "Zamknij"}
	},
	[4] = {
		title="Zdobyte osiągnięcia",
		tabs={}
	},
	[5] = {
		title="Twoje statystyki",
		tabs={}
	},
}

local shaders = {
	{"player:shader_sky", "enableDynamicSky()", "Dynamiczne niebo"},
	{"player:shader_dof", "enableDOF()", "Głębia ostrości"},
	{"player:shader_palette", "enablePalette()", "Paleta kolorów"},
	{"player:shader_carpaint", "enableCarpaint()", "Błyszczący lakier"},
	{"player:shader_water", "enableWater()", "Woda"},
	{"player:shader_detail", "enableDetail()", "Detale tekstur"},
	{"player:shader_roadshine", "enableRoadshine()", "Przebłysk dróg"},
	{"player:shader_snow", "enableSnow()", "Śnieg"}
}

local personal =  {
	{"player:pwDisabled", "enablePrivateMessages()", "Prywatne wiadomości"},
	{"player:eventMusicDisabled", "enableEventMusic()", "Muzyka eventowa"}
}
function enablePrivateMessages()
	local data = getElementData(localPlayer, "player:pwDisabled") or false
	setElementData(localPlayer, "player:pwDisabled", not data)
end 

function enableEventMusic()
	local data = getElementData(localPlayer, "player:eventMusicDisabled") or false
	setElementData(localPlayer, "player:eventMusicDisabled", not data)
end

local screenW, screenH = guiGetScreenSize()
local baseX = 1800
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-(800/zoom)/2, y=screenH/2-(500/zoom)/2, w=800/zoom, h=500/zoom}	
local tabWidth = math.floor(bgPos.w*0.175)
local tabHeight = 100/zoom 

local showing = false

local hoveredTab = 1 
local selectedTab = 1 

local hoveredTabOption = false 
local selectedTabOption = false 
local selectedVehicleOption = false 

local hoveredSwitch = false 

local dashboardVehicles = {} 
local dashboardAchievements = {} 
local dashboardAchievementList = {} 
local dashboardStatistics = {} 
local statisticsList = {} 

local MAX_VISIBLE_ROWS = 4
local selectedRow = 1
local visibleRows = MAX_VISIBLE_ROWS

function showDashboard()
	if not getElementData(localPlayer, "player:spawned") then return end	
	if not showing and isCursorShowing() then return end -- blokada innych okien 
	
	showing = not showing 
	showCursor(showing)
	
	if showing then 
		font = dxCreateFont("fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		font_edit = dxCreateFont("fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
		guiSetInputMode("no_binds")
		
		MAX_VISIBLE_ROWS = 4
		selectedRow = 1
		visibleRows = MAX_VISIBLE_ROWS
		
		selectedTab = 1 
		hoveredTab = 1
		requestDashboardData()
	else 
		if font then destroyElement(font) font = nil end
		if font_edit then destroyElement(font_edit) font_edit = nil end
		selectedTabOption = false 
		hoveredTabOption = false
		selectedVehicleOption = false 
		
		if edit1 then 
			exports["ms-gui"]:destroyEditBox(edit1)
			edit1 = nil 
		end 
		
		if edit2 then 
			exports["ms-gui"]:destroyEditBox(edit2)
			edit2 = nil 
		end 
		
		if isElement(avatarEdit) then destroyElement(avatarEdit) end

		guiSetInputMode("allow_binds")
	end
end
bindKey("f1", "down", showDashboard)

function onClick(button, state)
	if button == "left" and state == "up" then 
		if hoveredTab then 
			if isCursorOnElement(bgPos.x, bgPos.y + (100/zoom)*(hoveredTab-1), tabWidth, tabHeight) then 
				selectedTab = hoveredTab
				selectedTabOption = false 
				hoveredTabOption = false
				selectedVehicleOption = false 
				
				if isElement(avatarEdit) then destroyElement(avatarEdit) end
				if edit1 then 
					exports["ms-gui"]:destroyEditBox(edit1)
					edit1 = nil 
				end 
		
				if edit2 then 
					exports["ms-gui"]:destroyEditBox(edit2)
					edit2 = nil 
				end 
		
				if selectedTab == 5 then -- statystyki 
					statisticsList = prepareStatistics()
					MAX_VISIBLE_ROWS = 11 
				else 
					MAX_VISIBLE_ROWS = 4
				end
				
				selectedRow = 1
				visibleRows = MAX_VISIBLE_ROWS
			else 
				selectedTab = false 
				selectedTabOption = false 
				selectedVehicleOption = false
			end
		end
		
		if hoveredTabOption then 
			local tab 
			local tabIndex 
			if type(hoveredTabOption) == "table" then 
				tab = hoveredTabOption[2]
				tabIndex = hoveredTabOption[1]
			else 
				tab = hoveredTabOption
				tabIndex = hoveredTabOption
			end
			
			if isCursorOnElement(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+90/zoom*(tab-1), bgPos.w-tabWidth-(50/zoom)*2, 80/zoom) and selectedTabOption ~=  tabIndex then 
				selectedTabOption = tabIndex
				if selectedTab == 1 then -- konto  
					if selectedTabOption == 1 then -- zmiana nicku  
						edit1 = exports["ms-gui"]:createEditBox("", bgPos.x+tabWidth+295/zoom/2, bgPos.y+bgPos.h/2-200/zoom/2, 400/zoom, 50/zoom, tocolor(230, 230, 230, 230), font_edit, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(edit1, "Wprowadź dane")
						exports["ms-gui"]:setEditBoxMaxLength(passInput, 22)
					elseif selectedTabOption == 2 then -- zmiana hasla 
						edit1 = exports["ms-gui"]:createEditBox("", bgPos.x+tabWidth+190/zoom, bgPos.y+bgPos.h/2-200/zoom/2, 350/zoom, 50/zoom, tocolor(230, 230, 230, 230), font_edit, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(edit1, "Wprowadź dane")
						edit2 = exports["ms-gui"]:createEditBox("", bgPos.x+tabWidth+190/zoom, bgPos.y+bgPos.h/2-80/zoom/2, 350/zoom, 50/zoom, tocolor(230, 230, 230, 230), font_edit, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(edit2, "Wprowadź dane")
						exports["ms-gui"]:setEditBoxMaxLength(edit1, 22)
						exports["ms-gui"]:setEditBoxMaxLength(edit2, 22)
						exports["ms-gui"]:setEditBoxMasked(edit1, true)
						exports["ms-gui"]:setEditBoxMasked(edit2, true)
					elseif selectedTabOption == 3 then -- zmiana email 
						edit1 = exports["ms-gui"]:createEditBox("", bgPos.x+tabWidth+190/zoom, bgPos.y+bgPos.h/2-200/zoom/2, 350/zoom, 50/zoom, tocolor(230, 230, 230, 230), font_edit, 0.6)
						exports["ms-gui"]:setEditBoxMasked(edit1, true)
						exports["ms-gui"]:setEditBoxHelperText(edit1, "Wprowadź dane")
						edit2 = exports["ms-gui"]:createEditBox("", bgPos.x+tabWidth+190/zoom, bgPos.y+bgPos.h/2-80/zoom/2, 350/zoom, 50/zoom, tocolor(230, 230, 230, 230), font_edit, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(edit2, "Wprowadź dane")
						return
					elseif selectedTabOption == 4 then 
						avatarEdit = guiCreateEdit((bgPos.x+tabWidth+275/zoom/2)/screenW, (bgPos.y+bgPos.h/2-200/zoom/2)/screenH, (400/zoom)/screenW, (50/zoom)/screenH, "", true)
					end
				end
			end
		end
		
		if selectedTab == 1 then -- konto 
			if selectedTabOption == 1 then -- zmiana nicku 
				if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then -- zmiana 
					local text = exports["ms-gui"]:getEditBoxText(edit1)
					if #text > 3 and #text < 22 then
						triggerServerEvent("onPlayerChangeNickname", localPlayer, text)
					else
						triggerEvent("onClientAddNotification", localPlayer, "Nick musi się składać od 4 do 22 znaków!", "error", 5000)
					end
				elseif isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then -- cancel 
					selectedTab = 1 
					selectedTabOption = false 
					hoveredTabOption = false 
					if edit1 then 
						exports["ms-gui"]:destroyEditBox(edit1)
						edit1 = nil 
					end 
				end
			elseif selectedTabOption == 2 then -- zmiana hasla
				if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then -- zmiana 
					local cur_pass = exports["ms-gui"]:getEditBoxText(edit1)
					local new_pass = exports["ms-gui"]:getEditBoxText(edit2)
					
					if #cur_pass > 0 and #new_pass > 0 then
						triggerServerEvent("onPlayerChangePassword", localPlayer, cur_pass, new_pass)
					else
						triggerEvent("onClientAddNotification", localPlayer, "Uzupełnij pola!", "error", 5000)
					end
					
				elseif isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then -- cancel 
					selectedTab = 1 
					selectedTabOption = false 
					hoveredTabOption = false 
					if edit1 then 
						exports["ms-gui"]:destroyEditBox(edit1)
						edit1 = nil 
					end
					if edit2 then 
						exports["ms-gui"]:destroyEditBox(edit2)
						edit2 = nil 
					end 
				end
			elseif selectedTabOption == 3 then -- zmiana mejla 
				if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then -- zmiana 
					local cur_pass = exports["ms-gui"]:getEditBoxText(edit1)
					local new_email = exports["ms-gui"]:getEditBoxText(edit2)
					
					if #cur_pass > 0 and #new_email > 0 then
						triggerServerEvent("onPlayerChangeMail", localPlayer, cur_pass, new_email)
					else
						triggerEvent("onClientAddNotification", localPlayer, "Uzupełnij pola!", "error", 5000)
					end
					
				elseif isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then -- cancel 
					selectedTab = 1 
					selectedTabOption = false 
					hoveredTabOption = false 
					if edit1 then 
						exports["ms-gui"]:destroyEditBox(edit1)
						edit1 = nil 
					end
					if edit2 then 
						exports["ms-gui"]:destroyEditBox(edit2)
						edit2 = nil 
					end 
				end
			elseif selectedTabOption == 4 then -- zmiana avatara 
				if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then -- zmiana 
					local text = guiGetText(avatarEdit)
					if #text > 0 then
						if (text:find("http://") or text:find("https://")) and text:find(".png") or text:find(".jpg") or text:find(".jpeg") then
							triggerEvent("onClientAddNotification", localPlayer, "Avatar zmieniony pomyślnie!", "success", 5000)
							triggerServerEvent("onPlayerChangeAvatar", localPlayer, guiGetText(avatarEdit))
						else
							triggerEvent("onClientAddNotification", localPlayer, "Wpisałeś nieprawidłowy URL. Musi to być bezpośredni link do obrazka z końcówką .jpg, .jpeg albo .png.", "error", 5000)
						end
					else
						triggerEvent("onClientAddNotification", localPlayer, "Podaj URL do avatara", "error", 5000)
					end
				elseif isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then -- cancel 
					selectedTab = 1 
					selectedTabOption = false 
					hoveredTabOption = false 
					if edit1 then 
						exports["ms-gui"]:destroyEditBox(edit1)
						edit1 = nil 
					end
					if isElement(avatarEdit) then destroyElement(avatarEdit) end
				end
			elseif selectedTabOption == 5 then 
				if hoveredSwitch then 
					local offsetY = (50/zoom)*(hoveredSwitch-1) + 100/zoom
					local switchWidth = 75/zoom
					
					if isCursorOnElement(bgPos.x+tabWidth+30/zoom, bgPos.y+offsetY+5/zoom, switchWidth, 25/zoom) then 
						local shader = shaders[hoveredSwitch]
						local func = shader[2]
						local str = loadstring(func)
						pcall(str)
					end
				end
			elseif selectedTabOption == 6 then 
				if hoveredSwitch then 
					local offsetY = (50/zoom)*(hoveredSwitch-1) + 100/zoom
					local switchWidth = 75/zoom
					
					if isCursorOnElement(bgPos.x+tabWidth+30/zoom, bgPos.y+offsetY+5/zoom, switchWidth, 25/zoom) then 
						local setting = personal[hoveredSwitch]
						local func = setting[2]
						local str = loadstring(func)
						pcall(str)
					end
				end
			end
		elseif selectedTab == 2 then -- sklep 
			if hoveredTabOption then 
				local offsetY = 90/zoom*(hoveredTabOption-1)
				if isCursorOnElement(bgPos.x+bgPos.w-250/zoom, 95/zoom+bgPos.y+offsetY, 130/zoom, 50/zoom) then 
					local selectedTabData = tabData[selectedTab].tabs
					if hoveredTabOption == 4 then 
						triggerServerEvent("onPlayerBuyGang", localPlayer, localPlayer, selectedTabData[hoveredTabOption][2])
					else
						triggerServerEvent("onPlayerBuyPremium", localPlayer, localPlayer, selectedTabData[hoveredTabOption][1], selectedTabData[hoveredTabOption][2])
					end
				end
			end
		elseif selectedTab == 3 then -- pojazdy 
			-- opcje pojazdow 
			if selectedVehicleOption and selectedTabOption then 
				local offsetX = 110/zoom*(selectedVehicleOption[1]-1)
				local offsetY = 90/zoom*(selectedVehicleOption[2]-1) -- indeks ze scrolla
				local x, y, w, h = bgPos.x+tabWidth+240/zoom+offsetX, 98/zoom+bgPos.y+offsetY, 100/zoom, 40/zoom
				if isCursorOnElement(x, y, w, h) then 
					local vehicle = dashboardVehicles[selectedTabOption]
					if selectedVehicleOption[1] == 1 then 
						triggerServerEvent("onPlayerSpawnVehicle", localPlayer, vehicle)
					elseif selectedVehicleOption[1] == 2 then 
						if vehicle.spawned == 0 then 
							triggerEvent("onClientAddNotification", localPlayer, "Najpierw zespawnuj pojazd.", "warning", 5000)
							return 
						end 
						
						triggerServerEvent("onPlayerTeleportVehicle", localPlayer, vehicle)
					elseif selectedVehicleOption[1] == 3 then 
						if vehicle.spawned == 0 then 
							triggerEvent("onClientAddNotification", localPlayer, "Najpierw zespawnuj pojazd.", "warning", 5000)
							return 
						end 
						
						triggerServerEvent("onPlayerLockVehicle", localPlayer, vehicle)
						if vehicle.locked == 0 then 
							dashboardVehicles[selectedTabOption].locked = 1 
							triggerEvent("onClientAddNotification", localPlayer, "Pojazd zamknięty pomyślnie.", "success", 5000)
						else 
							dashboardVehicles[selectedTabOption].locked = 0 
							triggerEvent("onClientAddNotification", localPlayer, "Pojazd otwarty pomyślnie.", "info", 5000)
						end
					end
				end
				
				selectedTabOption = false
				selectedVehicleOption = false
			end
		end
	end
end 
addEventHandler("onClientClick", root, onClick)

function onKey(key, state)
	if not showing then return end 
	if key == "mouse_wheel_up" and scrollEnabled then 
		selectedRow = math.max(1, selectedRow-1)
		visibleRows = math.max(MAX_VISIBLE_ROWS, visibleRows-1)
		
		if visibleRows < MAX_VISIBLE_ROWS then visibleRows = MAX_VISIBLE_ROWS end 
	elseif key == "mouse_wheel_down" and scrollEnabled then 
		local plrs = scrollEnabled
		if selectedRow > plrs-MAX_VISIBLE_ROWS then return end 
			
		selectedRow = selectedRow+1
		visibleRows = visibleRows+1
		if selectedRow > plrs then selectedRow = plrs end
		if visibleRows > plrs then visibleRows = plrs-MAX_VISIBLE_ROWS end 
	end
end 
addEventHandler("onClientKey", root, onKey)

function renderDashboard()
	if not showing then return end
	-- bg
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), false)
	
	-- zakladki z boku 
	hoveredTab = false 

	for k,v in ipairs(tabs) do 
		if isCursorOnElement(bgPos.x, bgPos.y + (100/zoom)*(k-1), tabWidth, tabHeight) then 
			hoveredTab = k 
		end 
		
		if k == hoveredTab or k == selectedTab then 
			dxDrawRectangle(bgPos.x, bgPos.y + (100/zoom)*(k-1), tabWidth, tabHeight, tocolor(30, 30, 30, 150), true) 
		else 
			dxDrawRectangle(bgPos.x, bgPos.y + (100/zoom)*(k-1), tabWidth, tabHeight, tocolor(10, 10, 10, 150), true) 
		end 
		
		if k == selectedTab then 
			dxDrawRectangle(bgPos.x+tabWidth-5/zoom, bgPos.y + (100/zoom)*(k-1), 5/zoom, tabHeight, tocolor(v[3], v[4], v[5], 255), true)
		end 
		
		dxDrawImage(bgPos.x + 70/zoom/2, bgPos.y + (100/zoom)*(k-1), 70/zoom, 70/zoom, v[2], 0, 0, 0, tocolor(v[3], v[4], v[5], 230), true)
		dxDrawText(v[1], bgPos.x, bgPos.y + (100/zoom)*(k-1) + tabHeight-33/zoom, bgPos.x+tabWidth, bgPos.y+tabHeight, tocolor(230, 230, 230, 230), 0.55, font, "center", "top", false, true, true)
	end
	
	-- zawartosc
	local tabR, tabG, tabB = tabs[selectedTab][3], tabs[selectedTab][4], tabs[selectedTab][5]
	local selectedTabData = tabData[selectedTab]
	if selectedTab ~= 5 then -- tytuł nie w statystykach
		dxDrawText(selectedTabData.title, bgPos.x, bgPos.y+20/zoom, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.9, font, "center", "top", false, true, true)
	end 
	
	if selectedTab == 1 then -- konto 
		if selectedTabOption == 1 then -- zmiana nicku 
			dxDrawText("Nowy nick", bgPos.x+tabWidth+20/zoom, bgPos.y+bgPos.h/2-180/zoom/2, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
			dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-200/zoom/2, 400/zoom, 50/zoom, tocolor(10, 10, 10, 50), true)
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 200), true)
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 100), true)
			end 
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(231, 76, 60, 200), true) 
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(231, 76, 60, 100), true) 
			end 
			
			dxDrawText("Akceptuj", bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, (bgPos.x+tabWidth+275/zoom/2)+150/zoom, (bgPos.y+bgPos.h/2-70/zoom/2)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
			dxDrawText("Wróć", bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, (bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom)+150/zoom, (bgPos.y+bgPos.h/2-70/zoom/2)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
			
		elseif selectedTabOption == 2 then -- zmiana hasla
			dxDrawText("Aktualne hasło", bgPos.x+tabWidth+20/zoom, bgPos.y+bgPos.h/2-180/zoom/2, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
			dxDrawRectangle(bgPos.x+tabWidth+180/zoom, bgPos.y+bgPos.h/2-200/zoom/2, 350/zoom, 50/zoom, tocolor(10, 10, 10, 50), true)
			
			dxDrawText("Nowe hasło", bgPos.x+tabWidth+20/zoom, bgPos.y+bgPos.h/2-60/zoom/2, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
			dxDrawRectangle(bgPos.x+tabWidth+180/zoom, bgPos.y+bgPos.h/2-80/zoom/2, 350/zoom, 50/zoom, tocolor(10, 10, 10, 50), true)
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 200), true)
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 100), true)
			end 
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(231, 76, 60, 200), true) 
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(231, 76, 60, 100), true) 
			end 
			
			dxDrawText("Akceptuj", bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, (bgPos.x+tabWidth+275/zoom/2)+150/zoom, (bgPos.y+bgPos.h/2+30/zoom)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
			dxDrawText("Wróć", bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, (bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom)+150/zoom, (bgPos.y+bgPos.h/2+30/zoom)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
		elseif selectedTabOption == 3 then -- zmiana mejla
			dxDrawText("Aktualne hasło", bgPos.x+tabWidth+20/zoom, bgPos.y+bgPos.h/2-180/zoom/2, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
			dxDrawRectangle(bgPos.x+tabWidth+180/zoom, bgPos.y+bgPos.h/2-200/zoom/2, 350/zoom, 50/zoom, tocolor(10, 10, 10, 50), true)
			
			dxDrawText("Nowy e-mail", bgPos.x+tabWidth+20/zoom, bgPos.y+bgPos.h/2-60/zoom/2, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
			dxDrawRectangle(bgPos.x+tabWidth+180/zoom, bgPos.y+bgPos.h/2-80/zoom/2, 350/zoom, 50/zoom, tocolor(10, 10, 10, 50), true)
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 200), true)
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 100), true)
			end 
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(231, 76, 60, 200), true) 
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, 150/zoom, 50/zoom, tocolor(231, 76, 60, 100), true) 
			end 
			
			dxDrawText("Akceptuj", bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2+30/zoom, (bgPos.x+tabWidth+275/zoom/2)+150/zoom, (bgPos.y+bgPos.h/2+30/zoom)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
			dxDrawText("Wróć", bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2+30/zoom, (bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom)+150/zoom, (bgPos.y+bgPos.h/2+30/zoom)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
		elseif selectedTabOption == 4 then -- zmiana avatara 
			dxDrawText("URL", bgPos.x+tabWidth+20/zoom, bgPos.y+bgPos.h/2-180/zoom/2, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
			dxDrawImage(bgPos.x+tabWidth+300/zoom, 70/zoom+bgPos.y, 70/zoom, 70/zoom, exports["ms-avatars"]:loadAvatar(getElementData(localPlayer, "player:uid")), 0, 0, 0, tocolor(255, 255, 255, 255), true)
			
			local x, y, w, h = (bgPos.x+tabWidth+275/zoom/2), (bgPos.y+bgPos.h/2-200/zoom/2), (400/zoom), (50/zoom)
			dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 150), true)
			local text = guiGetText(avatarEdit)
			if #text > 40 then 
				text = text:sub(#text-40)
			end
			dxDrawText(text, x+10/zoom, y, x+w-10/zoom, y+h, tocolor(230, 230, 230, 230), 0.6, font, "left", "center", false, false, true)
			if #text == 0 then 
				dxDrawText("Wklej tutaj link do avatara", x+10/zoom, y, x+w-10/zoom, y+h, tocolor(150, 150, 150, 230), 0.6, font, "left", "center", false, false, true)
			end 
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 200), true)
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(tabR, tabG, tabB, 100), true)
			end 
			
			if isCursorOnElement(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(231, 76, 60, 200), true) 
			else 
				dxDrawRectangle(bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, 150/zoom, 50/zoom, tocolor(231, 76, 60, 100), true) 
			end 
			
			dxDrawText("Wyślij", bgPos.x+tabWidth+275/zoom/2, bgPos.y+bgPos.h/2-70/zoom/2, (bgPos.x+tabWidth+275/zoom/2)+150/zoom, (bgPos.y+bgPos.h/2-70/zoom/2)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
			dxDrawText("Wróć", bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom, bgPos.y+bgPos.h/2-70/zoom/2, (bgPos.x+tabWidth+275/zoom/2+400/zoom-150/zoom)+150/zoom, (bgPos.y+bgPos.h/2-70/zoom/2)+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
		
			dxDrawText("Wklej URL z obrazkiem o rozszerzeniu (końcówce) .jpg lub .png na końcu linku.\nAvatar nie może mieć większych rozmiarów niż 256x256.\nWulgarne treści przedstawione na avatarze będą ukarane.", bgPos.x, bgPos.y+bgPos.h-200/zoom, bgPos.x+bgPos.w+tabWidth, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.625, font, "center", "top", false, true, true)
		elseif selectedTabOption == 5 then -- grafika 
			for k,v in ipairs(shaders) do 
				local switchWidth = 75/zoom 
				local switchR, switchG, switchB, switchA = tabR, tabG, tabB, 255 
			
				local offsetY = (50/zoom)*(k-1) + 100/zoom
				local isEnabled = getElementData(localPlayer, v[1])
				local switchX = bgPos.x+tabWidth+30/zoom
				if isEnabled then 
					switchX = switchX+switchWidth/2
				else 
					switchR, switchG, switchB, switchA = 100, 100, 100, 200
				end 
				
				dxDrawRectangle(bgPos.x+tabWidth+30/zoom, bgPos.y+offsetY+5/zoom, switchWidth, 25/zoom, tocolor(10, 10, 10, 150), true)
				dxDrawRectangle(switchX, bgPos.y+offsetY+5/zoom, switchWidth/2, 25/zoom, tocolor(switchR, switchG, switchB, switchA), true)
				if isCursorOnElement(bgPos.x+tabWidth+30/zoom, bgPos.y+offsetY+5/zoom, switchWidth, 25/zoom) then 
					hoveredSwitch = k
				end
				
				dxDrawText(v[3], bgPos.x+tabWidth+132/zoom, bgPos.y+offsetY, 0, 0, tocolor(250, 250, 250, 250), 0.7, font, "left", "top", false, true, true)
			end
		
		elseif selectedTabOption == 6 then 
			for k,v in ipairs(personal) do 
				local switchWidth = 75/zoom 
				local switchR, switchG, switchB, switchA = tabR, tabG, tabB, 255 
			
				local offsetY = (50/zoom)*(k-1) + 100/zoom
				local isEnabled = not (getElementData(localPlayer, v[1]) or false)
				local switchX = bgPos.x+tabWidth+30/zoom
				if isEnabled then 
					switchX = switchX+switchWidth/2
				else 
					switchR, switchG, switchB, switchA = 100, 100, 100, 200
				end 
				
				dxDrawRectangle(bgPos.x+tabWidth+30/zoom, bgPos.y+offsetY+5/zoom, switchWidth, 25/zoom, tocolor(10, 10, 10, 150), true)
				dxDrawRectangle(switchX, bgPos.y+offsetY+5/zoom, switchWidth/2, 25/zoom, tocolor(switchR, switchG, switchB, switchA), true)
				if isCursorOnElement(bgPos.x+tabWidth+30/zoom, bgPos.y+offsetY+5/zoom, switchWidth, 25/zoom) then 
					hoveredSwitch = k
				end
				
				dxDrawText(v[3], bgPos.x+tabWidth+132/zoom, bgPos.y+offsetY, 0, 0, tocolor(250, 250, 250, 250), 0.7, font, "left", "top", false, true, true)
			end
		else
			-- ustawienia
			scrollEnabled = #selectedTabData.tabs
			dxDrawRectangle(bgPos.x+bgPos.w-30/zoom, bgPos.y+80/zoom, 10/zoom, (88/zoom)*4, tocolor(10, 10, 10, 150), true)
		
			local scrollPos = 0
			if scrollEnabled > MAX_VISIBLE_ROWS then 
				scrollPos = (((selectedRow-1)/(scrollEnabled-MAX_VISIBLE_ROWS)) * ((88/zoom)*4-40/zoom))
			end 
			dxDrawRectangle(bgPos.x+bgPos.w-30/zoom, scrollPos+bgPos.y+80/zoom, 10/zoom, 40/zoom, tocolor(tabR, tabG, tabB, 255), true)
			
			local n = 0 	
			for k,v in ipairs(selectedTabData.tabs) do 
				if k >= selectedRow and k <= visibleRows then 
					n = n+1 
					
					local offsetY = 90/zoom*(n-1)
					
					if isCursorOnElement(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom) then 
						hoveredTabOption = {k, n}
						dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 200), true)
						dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY+75/zoom, bgPos.w-tabWidth-(50/zoom)*2, 5/zoom, tocolor(tabR, tabG, tabB, 255), true)
					else 
						dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 125), true)
					end 
					
					dxDrawText(v[1], bgPos.x+tabWidth+150/zoom, 90/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(tabR, tabG, tabB, 255), 0.65, font, "left", "top", false, true, true)
					dxDrawText(v[2], bgPos.x+tabWidth+150/zoom, 120/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(200, 200, 200, 200), 0.5, font, "left", "top", false, true, true)
					
					dxDrawImage(bgPos.x+tabWidth+60/zoom, 80/zoom+bgPos.y+offsetY, 80/zoom, 80/zoom, v[3], 0, 0, 0, tocolor(tabR, tabG, tabB, 230), true)
				end
			end 
		end
	elseif selectedTab == 2 then -- sklep 
		for k,v in ipairs(selectedTabData.tabs) do 
			local offsetY = 90/zoom*(k-1)
				
			if isCursorOnElement(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom) then 
				hoveredTabOption = k
				dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 200), true)
				dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY+75/zoom, bgPos.w-tabWidth-(50/zoom)*2, 5/zoom, tocolor(tabR, tabG, tabB, 255), true)
			else
				dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 125), true)
			end 
			
			if k == 4 then 
				dxDrawText("Własny gang", bgPos.x+tabWidth+150/zoom, 90/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(230, 230, 230, 255), 0.65, font, "left", "top", false, true, true)
				dxDrawImage(bgPos.x+tabWidth+60/zoom, 80/zoom+bgPos.y+offsetY, 80/zoom, 80/zoom, "icons/gang.png", 0, 0, 0, tocolor(tabR, tabG, tabB, 230), true)
			else
				dxDrawText("Premium: "..tostring(v[1]).." dni", bgPos.x+tabWidth+150/zoom, 90/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(230, 230, 230, 255), 0.65, font, "left", "top", false, true, true)
				dxDrawImage(bgPos.x+tabWidth+60/zoom, 80/zoom+bgPos.y+offsetY, 80/zoom, 80/zoom, "icons/vip.png", 0, 0, 0, tocolor(tabR, tabG, tabB, 230), true)
			end
			
			dxDrawText(tostring(v[2]).." diamentów", bgPos.x+tabWidth+150/zoom, 120/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(200, 200, 200, 200), 0.5, font, "left", "top", false, true, true)
			
			if isCursorOnElement(bgPos.x+bgPos.w-250/zoom, 95/zoom+bgPos.y+offsetY, 130/zoom, 50/zoom) then 
				dxDrawRectangle(bgPos.x+bgPos.w-250/zoom, 95/zoom+bgPos.y+offsetY, 130/zoom, 50/zoom, tocolor(50, 50, 50, 100), true)
				dxDrawText("Zakup", bgPos.x+bgPos.w-250/zoom, 95/zoom+bgPos.y+offsetY, bgPos.x+bgPos.w-250/zoom+130/zoom, 95/zoom+bgPos.y+offsetY+50/zoom, tocolor(tabR, tabG, tabB, 230), 0.7, font, "center", "center", false, true, true)
			else 
				dxDrawRectangle(bgPos.x+bgPos.w-250/zoom, 95/zoom+bgPos.y+offsetY, 130/zoom, 50/zoom, tocolor(40, 40, 40, 100), true)
				dxDrawText("Zakup", bgPos.x+bgPos.w-250/zoom, 95/zoom+bgPos.y+offsetY, bgPos.x+bgPos.w-250/zoom+130/zoom, 95/zoom+bgPos.y+offsetY+50/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
			end
		end
	elseif selectedTab == 3 then -- pojazdy
		scrollEnabled = #dashboardVehicles
		dxDrawRectangle(bgPos.x+bgPos.w-30/zoom, bgPos.y+80/zoom, 10/zoom, (88/zoom)*4, tocolor(10, 10, 10, 150), true)
		
		local scrollPos = 0
		if scrollEnabled > MAX_VISIBLE_ROWS then 
			scrollPos = (((selectedRow-1)/(scrollEnabled-MAX_VISIBLE_ROWS)) * ((88/zoom)*4-40/zoom))
		end 
		dxDrawRectangle(bgPos.x+bgPos.w-30/zoom, scrollPos+bgPos.y+80/zoom, 10/zoom, 40/zoom, tocolor(tabR, tabG, tabB, 255), true)
		
		local n = 0 
		for k,v in ipairs(dashboardVehicles) do 
			if k >= selectedRow and k <= visibleRows then 
				n = n+1 
				
				local offsetY = 90/zoom*(n-1)
					
				if isCursorOnElement(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom) or selectedTabOption == k then 
					hoveredTabOption = {k, n}
					dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 200), true)				
					dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY+75/zoom, bgPos.w-tabWidth-(50/zoom)*2, 5/zoom, tocolor(tabR, tabG, tabB, 255), true)
				else 
					dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 125), true)
				end 
					
				dxDrawText(getVehicleNameFromModel(v.model), bgPos.x+tabWidth+70/zoom, 105/zoom+bgPos.y+offsetY, bgPos.x+tabWidth+250/zoom, 80/zoom, tocolor(240, 240, 240, 240), 0.7, font, "center", "top", false, true, true)
				
				if selectedTabOption == k then 
					for i=1, 3 do 
						local offsetX = 110/zoom*(i-1)
						local x, y, w, h = bgPos.x+tabWidth+240/zoom+offsetX, 98/zoom+bgPos.y+offsetY, 100/zoom, 40/zoom
						local text = selectedTabData.options[i] 
						if i == 1 then 
							if v.spawned == 0 then text = "Spawn" else text = "Unspawn" end 
						elseif i == 3 then 
							if v.locked == 0 then text = "Zamknij" else text = "Otwórz" end 
						end
						
						if isCursorOnElement(x, y, w, h) then 
							selectedVehicleOption = {i, n}
							dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 150), true)
							dxDrawText(text, x, y, x+w, y+h, tocolor(tabR, tabG, tabB, 240), 0.5, font, "center", "center", false, true, true)
						else
							dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 100), true)
							dxDrawText(text, x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.5, font, "center", "center", false, true, true)
						end
					end
				else 
					dxDrawImage(bgPos.x+tabWidth+270/zoom, 80/zoom+bgPos.y+offsetY, 50/zoom, 50/zoom, "icons/stable.png", 0, 0, 0, tocolor(tabR, tabG, tabB, 230), true)
					
					local hp = math.floor((v.health/1000)*100)
					local components=fromJSON(v.components)
					local addons = {engine=0, jump=0, hp=0}
					for i,v in pairs(components) do
						if type(v) ~= "number" then 
							addons = v
						end
					end
					
					dxDrawText(tostring(hp).."%", bgPos.x+tabWidth+270/zoom, 125/zoom+bgPos.y+offsetY, bgPos.x+tabWidth+270/zoom+50/zoom, 80/zoom, tocolor(240, 240, 240, 240), 0.5, font, "center", "top", false, true, true)
					
					dxDrawImage(bgPos.x+tabWidth+340/zoom, 80/zoom+bgPos.y+offsetY, 50/zoom, 50/zoom, "icons/max_speed.png", 0, 0, 0, tocolor(tabR, tabG, tabB, 230), true)
					dxDrawText(tostring(math.floor(v.max_speed*0.8)), bgPos.x+tabWidth+340/zoom, 125/zoom+bgPos.y+offsetY, bgPos.x+tabWidth+340/zoom+50/zoom, 80/zoom, tocolor(240, 240, 240, 240), 0.5, font, "center", "top", false, true, true)
					
					dxDrawText("Przebieg: "..tostring(round(v.mileage/1000, 1)).."km\nE".. addons.engine ..", J".. addons.jump ..", H".. addons.hp .."", bgPos.x+tabWidth+420/zoom, 95/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(240, 240, 240, 240), 0.5, font, "left", "top", false, true, true)
				end
			end
		end 
		
	elseif selectedTab == 4 then -- osiągnięcia
		scrollEnabled = #dashboardAchievements
		dxDrawRectangle(bgPos.x+bgPos.w-30/zoom, bgPos.y+80/zoom, 10/zoom, (88/zoom)*4, tocolor(10, 10, 10, 150), true)
		
		local scrollPos = 0
		if scrollEnabled > MAX_VISIBLE_ROWS then 
			scrollPos = (((selectedRow-1)/(scrollEnabled-MAX_VISIBLE_ROWS)) * ((88/zoom)*4-40/zoom))
		end 
		dxDrawRectangle(bgPos.x+bgPos.w-30/zoom, scrollPos+bgPos.y+80/zoom, 10/zoom, 40/zoom, tocolor(tabR, tabG, tabB, 255), true)
		
		local n = 0 
		for k,v in ipairs(dashboardAchievements) do 
			if k >= selectedRow and k <= visibleRows then 
				n = n+1 
				
				local achievement = dashboardAchievementList[v[1]]
				local offsetY = 90/zoom*(n-1)
				
				dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(10, 10, 10, 150), true)
				--dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 80/zoom+bgPos.y+offsetY+75/zoom, bgPos.w-tabWidth-(70/zoom)*2, 5/zoom, tocolor(tabR, tabG, tabB, 255), true)
				
				if achievement then
					dxDrawImage(bgPos.x+tabWidth+65/zoom, 84/zoom+bgPos.y+offsetY, 65/zoom, 65/zoom, ":ms-achievements/"..achievement[1], 0, 0, 0, tocolor(tabR, tabG, tabB, 230), true)
					dxDrawText(v[1], bgPos.x+tabWidth+150/zoom, 90/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(tabR, tabG, tabB, 255), 0.65, font, "left", "top", false, true, true)
					dxDrawText(achievement[4], bgPos.x+tabWidth+150/zoom, 120/zoom+bgPos.y+offsetY, bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(230, 230, 230, 230), 0.5, font, "left", "top", false, true, true)
					
					
					dxDrawText("Zdobyto: "..formatDate("h:i, d.m.y", "'", v[2]), bgPos.x+tabWidth+150/zoom, 94/zoom+bgPos.y+offsetY, 140/zoom+bgPos.x+bgPos.w-tabWidth-(50/zoom)*2, 80/zoom, tocolor(180, 180, 180, 180), 0.5, font, "right", "top", false, true, true)
				end
			end
		end 
	elseif selectedTab == 5 then -- statystyki 
		dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 30/zoom+bgPos.y, bgPos.w-tabWidth-(50/zoom)*2, 100/zoom, tocolor(10, 10, 10, 125), true)
		dxDrawImage(bgPos.x+tabWidth+50/zoom, 30/zoom+bgPos.y, 100/zoom, 100/zoom, exports["ms-avatars"]:loadAvatar(getElementData(localPlayer, "player:uid")), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
		dxDrawText(getPlayerName(localPlayer), bgPos.x+tabWidth+170/zoom, 40/zoom+bgPos.y, 0, 0, tocolor(tabR, tabG, tabB, 255), 0.65, font, "left", "top", false, true, true)
		dxDrawText("#BFBFBFData rejestracji: #FFFFFF"..tostring(getElementData(localPlayer, "player:registered")).."\n#BFBFBFPrzegrany czas: #FFFFFF"..secondsToClock(getElementData(localPlayer, "player:playtime")), bgPos.x+tabWidth+170/zoom, 70/zoom+bgPos.y, 0, 0, tocolor(240, 240, 240, 240), 0.45, font, "left", "top", false, true, true, true)
		dxDrawImage(bgPos.x+tabWidth+500/zoom, 40/zoom+bgPos.y, 80/zoom, 80/zoom, ":ms-scoreboard/img/circle.png", 0, 0, 0, tocolor(tabR, tabG, tabB, 255), true)
		dxDrawText(tostring(getElementData(localPlayer, "player:level") or 1), bgPos.x+tabWidth+500/zoom, 40/zoom+bgPos.y, bgPos.x+tabWidth+580/zoom, 40/zoom+bgPos.y+80/zoom, tocolor(240, 240, 240, 240), 0.8, font, "center", "center", false, true, true)
	
		dxDrawRectangle(bgPos.x+tabWidth+50/zoom, 140/zoom+bgPos.y, bgPos.w-tabWidth-(50/zoom)*2, 340/zoom, tocolor(10, 10, 10, 125), true)
		
		scrollEnabled = #statisticsList
		dxDrawRectangle(bgPos.x+bgPos.w-tabWidth/2-10/zoom, 150/zoom+bgPos.y, 10/zoom, 320/zoom, tocolor(10, 10, 10, 150), true)
		
		local scrollPos = 0
		if scrollEnabled > MAX_VISIBLE_ROWS then 
			scrollPos = (((selectedRow-1)/(scrollEnabled-MAX_VISIBLE_ROWS)) * (320/zoom-40/zoom))
		end 
		dxDrawRectangle(bgPos.x+bgPos.w-tabWidth/2-10/zoom, 150/zoom+bgPos.y+scrollPos, 10/zoom, 40/zoom, tocolor(tabR, tabG, tabB, 255), true)
		
		local n = 0 
		for k,v in ipairs(statisticsList) do 
			if k >= selectedRow and k <= visibleRows then 
				n = n+1 
				
				local offsetY = (n-1)*(30/zoom)
				if v[2] then -- sekcja 			
					dxDrawText(v[1], bgPos.x+tabWidth+50/zoom, 150/zoom+bgPos.y+offsetY, bgPos.x+tabWidth+50/zoom+bgPos.w-tabWidth-(50/zoom)*2, 340/zoom, tocolor(tabR, tabG, tabB, 240), 0.6, font, "center", "top", false, true, true)
				else 
					dxDrawText(v[1], bgPos.x+tabWidth+70/zoom, 150/zoom+bgPos.y+offsetY, bgPos.x+tabWidth+50/zoom+bgPos.w-tabWidth-(50/zoom)*2, 340/zoom, tocolor(210, 210, 210, 240), 0.55, font, "left", "top", false, true, true)
				end
			end
		end
	end
	
	if edit1 then 
		exports["ms-gui"]:renderEditBox(edit1)
	end 
	
	if edit2 then 
		exports["ms-gui"]:renderEditBox(edit2)
	end
end
addEventHandler("onClientRender", root, renderDashboard)

function requestDashboardData()
	triggerServerEvent("onPlayerRequestDashboardData", localPlayer)
end 

function loadDashboardData(vehicles, achievements)
	if vehicles then
		dashboardVehicles = vehicles
		for k,v in ipairs(dashboardVehicles) do 
			if v.gielda > 0 then 
				table.remove(dashboardVehicles, k)
			end
		end 
	end
	
	if achievements then 
		dashboardAchievements = achievements
		table.sort(dashboardAchievements, function(a, b)
			return a[2] > b[2]
		end)
		
		local toRemove = {} 
		
		dashboardAchievementList = exports["ms-achievements"]:getAchievementTable()
		for k, v in ipairs(dashboardAchievements) do 
			if not dashboardAchievementList[v[1]] then
				outputDebugString(v[1])
				table.insert(toRemove, k)
			end
		end
		
		for k, v in ipairs(toRemove) do 
			table.remove(dashboardAchievements, v)
		end
	end
end 
addEvent("onClientGetDashboardData", true)
addEventHandler("onClientGetDashboardData", root, loadDashboardData)

function prepareStatistics()
	local houses = 0 
	for k, v in ipairs(getElementsByType("pickup")) do 
		if getElementData(v, "house") then 
			if getElementData(v, "house:owner") == getElementData(localPlayer, "player:uid") then 
				houses = houses+1
			end
		end
	end 

	local tbl = {
		-- tekst, sekcja (true/false)
		{"Statystyki ogólne", true},
		{"Ostrzeżenia:"..tostring(getElementData(localPlayer, "player:warns") or 0).."/5", false},
		{"EXP: "..tostring(exports["ms-gameplay"]:msGetTotalExp(localPlayer)), false},
		{"Zabicia: "..tostring(getElementData(localPlayer, "player:kills") or 0), false},
		{"Śmierci: "..tostring(getElementData(localPlayer, "player:deaths") or 0), false},
		{"Wykonanych prac: "..tostring(getElementData(localPlayer, "player:did_jobs") or 0), false},
		{"Posiadane pojazdy: "..tostring(#dashboardVehicles), false},
		{"Posiadane nieruchomości: "..tostring(houses), false},
		{"Statystyki aren", true},
		{"Onede: "..tostring(getElementData(localPlayer, "onede:kills") or 0), false},
		{"Dust: "..tostring(getElementData(localPlayer, "dust:kills") or 0), false},
		{"Minigun: "..tostring(getElementData(localPlayer, "minigun:kills") or 0), false},
		{"Bazooka: "..tostring(getElementData(localPlayer, "bazooka:kills") or 0), false},
		{"Sniper: "..tostring(getElementData(localPlayer, "sniper:kills") or 0), false},
		{"Zabite zombie: "..tostring(getElementData(localPlayer, "player:zombie_kills") or 0), false},
		{"Wygrane solo: "..tostring(getElementData(localPlayer, "player:solo_wins") or 0), false},
		{"Statystyki eventów", true},
		{"Wygrane CTF: "..tostring(getElementData(localPlayer, "player:ctf_wins") or 0), false},
		{"Wygrane Derby: "..tostring(getElementData(localPlayer, "player:derby_wins") or 0), false},
		{"Wygrane Race: "..tostring(getElementData(localPlayer, "player:race_wins") or 0), false},
		{"Wygranych Chowanych: "..tostring(getElementData(localPlayer, "player:hide_wins") or 0), false},
		{"Wygrane Uważaj, Spadasz!: "..tostring(getElementData(localPlayer, "player:us_wins") or 0), false},
		{"Wygrane TDM: "..tostring(getElementData(localPlayer, "player:tdm_wins") or 0), false},
		{"Wygrane Berek: "..tostring(getElementData(localPlayer, "player:bk_wins") or 0), false},
		{"Wygranych Wojen Hyder: "..tostring(getElementData(localPlayer, "player:wh_wins") or 0), false},
	}
	
	return tbl
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

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
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

function secondsToClock(seconds)
  seconds = seconds or 0 

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end