local radios = {}
local server_music = {
	-- url, x, y, z, distance, volume
	{"http://polskastacja.pl/play/aac_djtop50.pls", 284.03,-2026.51,2.50, 150, 1.0},
	{"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://174.37.16.73:5709/listen.pls?sid=1&t=.pls", 1790.71,-1910.54,13.40, 100, 1.0}
}

for k,v in ipairs(server_music) do
	local sound = playSound3D(v[1], v[2], v[3], v[4], true)
	setSoundMaxDistance(sound, v[5])
	setSoundVolume(sound, v[6])
end

PANEL_SHOWING = false
local blur = false
local adding = false 
local nameEdit = false
local urlEdit = false 

MAX_VISIBLE_ROWS = 5
local selectedRow = 1 
local visibleRows = MAX_VISIBLE_ROWS
local buttons = {"Usuń", "Boombox", "Pojazd"}
local selectedRadio = false 
local selectedRadioButton = false 

local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-850/zoom/2, y=screenH/2-500/zoom/2, w=850/zoom, h=500/zoom}
local bgRow = {x=bgPos.x+30/zoom, y=bgPos.y+85/zoom, w=bgPos.w-100/zoom, h=75/zoom}

function renderRadioWindow()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(235, 235, 235, 255))
	
	if adding then 
		dxDrawText("RADIO", bgPos.x, bgPos.y+50/zoom, bgPos.x+bgPos.w, 0, tocolor(190, 190, 190, 190), 1, font, "center", "top", false, false, true)
		dxDrawText("Wpisz poniżej adres URL do utworu na YouTube lub bezpośredni link do pliku dźwiękowego. Obsługiwane formaty to: MP3, PLS, WAV, M3U.\nNa naszej stronie znajduje się lista stacji radiowych:\nwww.multiserver.pl/radia", bgPos.x, bgPos.y+100/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 0.9, font, "center", "top", false, true, true) 
		
		local x, y, w, h = bgPos.x+100/zoom, bgPos.y+bgPos.h-240/zoom, bgPos.w-200/zoom, 45/zoom
		dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 200), true)
		local text = guiGetText(nameEdit)
		if #text > 70 then 
			text = text:sub(#text-70)
		end
		if #text == 0 then 
			dxDrawText("Wprowadź nazwę utworu", x+15/zoom, y, x+w+15/zoom, y+h, tocolor(200, 200, 200, 255), 0.7, font, "left", "center", false, false, true)
		else 
			dxDrawText(text, x+15/zoom, y, x+w+15/zoom, y+h, tocolor(255, 255, 255, 255), 0.7, font, "left", "center", false, false, true)
		end 
		
		local x, y, w, h = bgPos.x+100/zoom, bgPos.y+bgPos.h-180/zoom, bgPos.w-200/zoom, 45/zoom
		dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 200), true)
		local text = guiGetText(urlEdit)
		if #text > 70 then 
			text = text:sub(#text-70)
		end
		if #text == 0 then 
			dxDrawText("Wprowadź URL utworu", x+15/zoom, y, x+w+15/zoom, y+h, tocolor(200, 200, 200, 255), 0.7, font, "left", "center", false, false, true)
		else 
			dxDrawText(text, x+15/zoom, y, x+w+15/zoom, y+h, tocolor(255, 255, 255, 255), 0.7, font, "left", "center", false, false, true)
		end 
		
		if isCursorOnElement(bgPos.x+150/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom) then 
			dxDrawRectangle(bgPos.x+150/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom, tocolor(10, 10, 10, 150), true)
			dxDrawText("Dodaj", bgPos.x+150/zoom, bgPos.y+bgPos.h-100/zoom, bgPos.x+150/zoom+200/zoom, bgPos.y+bgPos.h-100/zoom+65/zoom, tocolor(51, 102, 255, 220), 0.85, font, "center", "center", false, false, true)
		else 
			dxDrawRectangle(bgPos.x+150/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom, tocolor(10, 10, 10, 100), true)
			dxDrawText("Dodaj", bgPos.x+150/zoom, bgPos.y+bgPos.h-100/zoom, bgPos.x+150/zoom+200/zoom, bgPos.y+bgPos.h-100/zoom+65/zoom, tocolor(220, 220, 220, 220), 0.85, font, "center", "center", false, false, true)
		end 
		
		if isCursorOnElement(bgPos.x+bgPos.w-350/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom) then 
			dxDrawRectangle(bgPos.x+bgPos.w-350/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom, tocolor(10, 10, 10, 150), true)
			dxDrawText("Wróć", bgPos.x+bgPos.w-350/zoom, bgPos.y+bgPos.h-100/zoom, bgPos.x+bgPos.w-350/zoom+200/zoom, bgPos.y+bgPos.h-100/zoom+65/zoom, tocolor(51, 102, 255, 220), 0.85, font, "center", "center", false, false, true)
		else 
			dxDrawRectangle(bgPos.x+bgPos.w-350/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom, tocolor(10, 10, 10, 100), true)
			dxDrawText("Wróć", bgPos.x+bgPos.w-350/zoom, bgPos.y+bgPos.h-100/zoom, bgPos.x+bgPos.w-350/zoom+200/zoom, bgPos.y+bgPos.h-100/zoom+65/zoom, tocolor(220, 220, 220, 220), 0.85, font, "center", "center", false, false, true)
		end 
		
		return 
	end 
	
	if isCursorOnElement(bgPos.x+30/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom) then 
		dxDrawRectangle(bgPos.x+30/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom, tocolor(10, 10, 10, 150), true) 
		dxDrawText("Dodaj", bgPos.x+30/zoom, bgPos.y+20/zoom, bgPos.x+30/zoom+160/zoom, bgPos.y+20/zoom+50/zoom, tocolor(51, 102, 255, 220), 0.8, font, "center", "center", false, false, true) 
	else 
		dxDrawRectangle(bgPos.x+30/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom, tocolor(10, 10, 10, 100), true) 
		dxDrawText("Dodaj", bgPos.x+30/zoom, bgPos.y+20/zoom, bgPos.x+30/zoom+160/zoom, bgPos.y+20/zoom+50/zoom, tocolor(220, 220, 220, 220), 0.8, font, "center", "center", false, false, true) 
	end 
	
	if isCursorOnElement(bgPos.x+200/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom) then 
		dxDrawRectangle(bgPos.x+200/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom, tocolor(10, 10, 10, 150), true) 
		dxDrawText("Wyjdź", bgPos.x+200/zoom, bgPos.y+20/zoom, bgPos.x+200/zoom+160/zoom, bgPos.y+20/zoom+50/zoom, tocolor(51, 102, 255, 220), 0.8, font, "center", "center", false, false, true) 
	else 
		dxDrawRectangle(bgPos.x+200/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom, tocolor(10, 10, 10, 100), true) 
		dxDrawText("Wyjdź", bgPos.x+200/zoom, bgPos.y+20/zoom, bgPos.x+200/zoom+160/zoom, bgPos.y+20/zoom+50/zoom, tocolor(220, 220, 220, 220), 0.8, font, "center", "center", false, false, true) 
	end 
	
	dxDrawText("LISTA AUDIO ("..tostring(#radios)..")", bgPos.x+bgPos.w-350/zoom, bgPos.y+30/zoom, 0, 0, tocolor(220, 220, 220, 220), 1, font, "left", "top", false, false, true) 
	
	local scrollEnabled = #radios
	dxDrawRectangle(bgPos.x+bgPos.w-40/zoom, bgPos.y+80/zoom, 20/zoom, 400/zoom, tocolor(10, 10, 10, 150), true)
		
	local scrollPos = 0
	if scrollEnabled > MAX_VISIBLE_ROWS then 
		scrollPos = (((selectedRow-1)/(scrollEnabled-MAX_VISIBLE_ROWS)) * (400/zoom-40/zoom))
	end 
	dxDrawRectangle(bgPos.x+bgPos.w-40/zoom, scrollPos+bgPos.y+80/zoom, 20/zoom, 40/zoom, tocolor(51, 102, 255, 255), true)

	local n = 0 
	for k,v in ipairs(radios) do 
		radios[k].usingBoombox = getElementData(localPlayer, "player:boombox") == radios[k].url
		
		if k >= selectedRow and k <= visibleRows then 
			n = n+1 
			local offsetY = (n-1)*(bgRow.h+5/zoom)
			if isCursorOnElement(bgRow.x, bgRow.y+offsetY, bgRow.w, bgRow.h) then 
				dxDrawRectangle(bgRow.x, bgRow.y+offsetY, bgRow.w, bgRow.h, tocolor(10, 10, 10, 150), true)
				selectedRadio = {k, n}
			else 
				dxDrawRectangle(bgRow.x, bgRow.y+offsetY, bgRow.w, bgRow.h, tocolor(10, 10, 10, 100), true)
			end 
			
			dxDrawText(v.name, bgRow.x+20/zoom, bgRow.y+offsetY, bgRow.w, bgRow.y+offsetY+bgRow.h, tocolor(235, 235, 235, 235), 0.9, font, "left", "center", false, false, true) 
			
			for i=1, 3 do 
				local title = buttons[i]
				local offsetX = (i-1)*(130/zoom)
				local x, y, w, h = bgRow.x+340/zoom+offsetX, bgRow.y+offsetY+30/zoom/2, 125/zoom, bgRow.h-30/zoom
				local bgR, bgG, bgB = 10, 10, 10
				if i == 1 then 
					bgR, bgG, bgB = 231, 76, 60
				elseif i == 2 then 
					if radios[k].usingBoombox then 
						bgR, bgG, bgB = 39, 174, 96
					end
				elseif i == 3 then 
					if radios[k].vehicle == 1 then 
						bgR, bgG, bgB = 39, 174, 96
					end
				end 
				
				if isCursorOnElement(x, y, w, h) then 
					dxDrawRectangle(x, y, w, h, tocolor(bgR, bgG, bgB, 150), true)
					if bgR == 30 and bgG == 30 and bgB == 30 then 
						dxDrawText(title, x, y, x+w, y+h, tocolor(51, 102, 255, 210), 0.75, font, "center", "center", false, false, true) 
					else 
						dxDrawText(title, x, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.75, font, "center", "center", false, false, true) 
					end 
					
					selectedRadioButton = i 
				else 
					dxDrawRectangle(x, y, w, h, tocolor(bgR, bgG, bgB, 100), true)
					dxDrawText(title, x, y, x+w, y+h, tocolor(210, 210, 210, 210), 0.75, font, "center", "center", false, false, true) 
				end
			end
		end
	end
end 

function onClick(key, state) 
	if key == "left" and state == "up" then 
		if isCursorOnElement(bgPos.x+30/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom) and not adding then 
			nameEdit = guiCreateEdit(bgPos.x+100/zoom, bgPos.y+bgPos.h-240/zoom, bgPos.w-200/zoom, 45/zoom, "", false)
			urlEdit = guiCreateEdit(bgPos.x+100/zoom, bgPos.y+bgPos.h-180/zoom, bgPos.w-200/zoom, 45/zoom, "", false)
			guiSetInputMode("no_binds")
			adding = true 
			return
		end
		
		if isCursorOnElement(bgPos.x+200/zoom, bgPos.y+20/zoom, 160/zoom, 50/zoom) and not adding then 
			showRadioWindow()
			return 
		end 
		
		if adding and isCursorOnElement(bgPos.x+bgPos.w-350/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom) then 
			adding = false
			destroyElement(nameEdit)
			destroyElement(urlEdit)
			guiSetInputMode("allow_binds")
		end
		
		if adding and isCursorOnElement(bgPos.x+150/zoom, bgPos.y+bgPos.h-100/zoom, 200/zoom, 65/zoom) then 
			local name = guiGetText(nameEdit)
			local url = guiGetText(urlEdit)
			if #name < 5 and #name < 25 then 
				triggerEvent("onClientAddNotification", localPlayer, "Nazwa utworu musi mieć conajmniej 5 znaków i mniej niż 25 znaków.", "error")
				return
			end 
			
			if #url < 10 then 
				triggerEvent("onClientAddNotification", localPlayer, "URL musi mieć conajmniej 10 znaków.", "error")
				return
			end 
			
			adding = false 
			destroyElement(nameEdit)
			destroyElement(urlEdit)
			guiSetInputMode("allow_binds")
			table.insert(radios, {id=-1, name=name, url=url})
			
			triggerServerEvent("onPlayerSaveRadio", localPlayer, name, url)
		end
		
		if not adding and selectedRadio then 
			local offsetY = (selectedRadio[2]-1)*(bgRow.h+5/zoom)
			local x, y, w, h = bgRow.x, bgRow.y+offsetY, bgRow.w, bgRow.h
			if isCursorOnElement(x, y, w, h) and selectedRadioButton then 
				local offsetX = (selectedRadioButton-1)*(130/zoom)
				local x, y, w, h = bgRow.x+340/zoom+offsetX, bgRow.y+offsetY+30/zoom/2, 125/zoom, bgRow.h-30/zoom
				if isCursorOnElement(x, y, w, h) then 
					if selectedRadioButton == 1 then 
						if radios[selectedRadio[1]].usingBoombox then 
							triggerServerEvent("onPlayerBoomboxToggle", localPlayer, localPlayer, radios[selectedRadio[1]].name, radios[selectedRadio[1]].url)
						end 
						
						if VEHICLE_RADIOS then 
							for k,v in ipairs(VEHICLE_RADIOS) do 
								if v.id == radios[selectedRadio[1]].id then 
									if RADIO_SOUND_URL == v.url then -- gracz odtwarza radio i je usuwa 
										triggerServerEvent("onPlayerUseVehicleRadio", localPlayer, -1, -1, true)
									end
											
									table.remove(VEHICLE_RADIOS, k)
								end
							end 
						end 

						triggerServerEvent("onPlayerDeleteRadio", localPlayer, radios[selectedRadio[1]].id, radios[selectedRadio[1]].name)
						table.remove(radios, selectedRadio[1])
					elseif selectedRadioButton == 2 then 
						if not getElementData(localPlayer, "player:premium") then 
							triggerEvent("onClientAddNotification", localPlayer, "Funkcja tylko dla graczy VIP.", "error")
							return
						end 
						
						if getElementData(localPlayer, "player:boombox") then
							for k,v in ipairs(radios) do 
								if v.usingBoombox and k ~= selectedRadio[1] then 					
									triggerEvent("onClientAddNotification", localPlayer, "Używasz już boomboxa!", "error")
									return
								end
							end 
						end 
						
						triggerServerEvent("onPlayerBoomboxToggle", localPlayer, localPlayer, radios[selectedRadio[1]].name, radios[selectedRadio[1]].url)
					elseif selectedRadioButton == 3 then 
						if radios[selectedRadio[1]].vehicle == 1 then
							
							if VEHICLE_RADIOS then 
								for k,v in ipairs(VEHICLE_RADIOS) do 
									if v.id == radios[selectedRadio[1]].id then 
										if RADIO_SOUND_URL == v.url then -- gracz odtwarza radio i je usuwa 
											triggerServerEvent("onPlayerUseVehicleRadio", localPlayer, -1, -1, true)
										end
											
										table.remove(VEHICLE_RADIOS, k)
									end
								end 
							end 
							
							radios[selectedRadio[1]].vehicle = 0 
						else 
							radios[selectedRadio[1]].vehicle = 1 
							if not VEHICLE_RADIOS then VEHICLE_RADIOS = {} end 
							table.insert(VEHICLE_RADIOS, radios[selectedRadio[1]])
						end 
						SAVED_STATION_INDEX = false
						triggerServerEvent("onPlayerUpdateVehicleRadio", localPlayer, radios[selectedRadio[1]].id, radios[selectedRadio[1]].vehicle)
					end
				end
			end
		end
	end
end 

function onKey(key, state) 
	if not PANEL_SHOWING then return end 
	if key == "mouse_wheel_up" then 
		selectedRow = math.max(1, selectedRow-1)
		visibleRows = math.max(MAX_VISIBLE_ROWS, visibleRows-1)
		
		if visibleRows < MAX_VISIBLE_ROWS then visibleRows = MAX_VISIBLE_ROWS end 
	elseif key == "mouse_wheel_down" then 
		local plrs = #radios
		if selectedRow > plrs-MAX_VISIBLE_ROWS then return end 
			
		selectedRow = selectedRow+1
		visibleRows = visibleRows+1
		if selectedRow > plrs then selectedRow = plrs end
		if visibleRows > plrs then visibleRows = plrs-MAX_VISIBLE_ROWS end 
	end
end 

function showRadioWindow() 
	if not getElementData(localPlayer, "player:spawned") then return end	
	if not PANEL_SHOWING and isCursorShowing() then return end -- blokada innych okien 
	
	PANEL_SHOWING = not PANEL_SHOWING 
	if PANEL_SHOWING then 
		if not font then font = dxCreateFont("BebasNeue.otf", 23/zoom) or "default-bold" end
		addEventHandler("onClientRender", root, renderRadioWindow)
		addEventHandler("onClientClick", root, onClick)
		addEventHandler("onClientKey", root, onKey)
		showCursor(true)
		
		triggerServerEvent("onPlayerRequestRadios", localPlayer)
	else 
		if isElement(font) and not RADIO_INFO_SHOW then 
			destroyElement(font)
			font = nil
		end
		if isElement(nameEdit) then destroyElement(nameEdit) end 
		if isElement(urlEdit) then destroyElement(urlEdit) end 
		removeEventHandler("onClientRender", root, renderRadioWindow)
		removeEventHandler("onClientClick", root, onClick)
		removeEventHandler("onClientKey", root, onKey)
		showCursor(false)
		guiSetInputMode("allow_binds")
	end
end 

function onClientLoadRadios(rd)
	if #radios ~= #rd then 
		radios = rd
		
		VEHICLE_RADIOS = {}
		for k,v in ipairs(radios) do 
			if v.vehicle == 1 then 
				table.insert(VEHICLE_RADIOS, v)
			end
		end
	end
end 
addEvent("onClientLoadRadios", true)
addEventHandler("onClientLoadRadios", root, onClientLoadRadios)

function radio()
	showRadioWindow()
	if adding == true then adding = false end
end 
addCommandHandler("radio", radio)
bindKey("F4", "down", radio)

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

addEvent("playKnockSound", true)
addEvent("playKnockSound2", true)

function playKnockSound()
	playSound("k.mp3")
end
addEventHandler("playKnockSound", root, playKnockSound)

function playKnockSound2()
	local snd = playSound("http://www.youtubeinmp3.com/fetch/?video=https://www.youtube.com/watch?v=IbxH4LTairQ")
	setSoundVolume(snd, 0.5)
	setTimer(setSoundVolume, 5000, 1, snd, 1)
	setTimer(stopSound, 20000, 1, snd)
end
addEventHandler("playKnockSound2", root, playKnockSound2)