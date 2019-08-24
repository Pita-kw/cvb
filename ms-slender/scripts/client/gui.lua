local zoom = 1 
local baseX = 1920
local minZoom = 2
local screenW, screenH = guiGetScreenSize()
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-600/zoom/2, y=screenH/2-650/zoom/2, w=600/zoom, h=650/zoom}
local slenderWindowData = false 
local myBestPlace = nil 
local selectedTab = 1 

function showSlenderWindow(b, data)
	if b then 
		if slenderWindowData then return end 
		
		slenderWindowData = data
		font = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 19/zoom) or "default-bold"
		addEventHandler("onClientRender", root, renderSlenderWindow)
		addEventHandler("onClientClick", root, clickSlenderWindow)
		showCursor(true)
		
		for k,v in ipairs(slenderWindowData.bestPlaces) do 
			if v.name == getPlayerName(localPlayer) then 
				myBestPlace = k
				break
			end
		end
	else 
		myBestPlace = nil 
		slenderWindowData = nil
				
		removeEventHandler("onClientRender", root, renderSlenderWindow)
		removeEventHandler("onClientClick", root, clickSlenderWindow)
		if isElement(font) then 
			destroyElement(font)
			font = nil 
		end
		showCursor(false)
	end
end 
addEvent("onClientSlenderWindow", true)
addEventHandler("onClientSlenderWindow", root, showSlenderWindow)

function clickSlenderWindow(key, state)
	if key == "left" and state == "up" then 
		if isCursorOnElement(bgPos.x+100/zoom/2, 160/zoom+bgPos.y, 160/zoom, 40/zoom) then 
			selectedTab = 1 
		elseif isCursorOnElement(bgPos.x+100/zoom/2+160/zoom, 160/zoom+bgPos.y, 160/zoom, 40/zoom) then 
			selectedTab = 2 
		end
		
		if isCursorOnElement(bgPos.x+100/zoom/2, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom) then -- rozpoczecie wyzwania 
			startSlender()
			showSlenderWindow(false)
		elseif isCursorOnElement(bgPos.x+bgPos.w-210/zoom, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom) then -- anulowanie 
			showSlenderWindow(false)
		end 
	end
end 

function renderSlenderWindow()
	if slenderWindowData then 
		local places = slenderWindowData.bestPlaces 
				
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(220, 220, 220, 255))
		dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 50/zoom, tocolor(30, 30, 30, 150), true)
		dxDrawText("Slender", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+50/zoom, tocolor(240, 240, 240, 240), 0.9, font, "center", "center", false, false, true)
		
		dxDrawText("Zbierz 8 kartek ukrytych w lesie.\nUważaj na niemiłego, wysokiego pana w garniturze.\nKonkuruj z innymi w zdobytych statystykach.\nJednorazowa nagroda za zdobycie 8 kartek: $15000 i 50 EXP.", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+bgPos.h-450/zoom, tocolor(240, 240, 240, 240), 0.7, font, "center", "center", false, false, true)
		
		if selectedTab == 1 then 
			dxDrawRectangle(bgPos.x+100/zoom/2, 160/zoom+bgPos.y, 160/zoom, 40/zoom, tocolor(51, 102, 255, 100), true)
			dxDrawText("Najlepsze przejścia", bgPos.x+100/zoom/2, 168/zoom+bgPos.y, bgPos.x+100/zoom/2+160/zoom, 40/zoom, tocolor(240, 240, 240, 240), 0.7, font, "center", "top", false, false, true)
		else 
			dxDrawRectangle(bgPos.x+100/zoom/2, 160/zoom+bgPos.y, 160/zoom, 40/zoom, tocolor(0, 0, 0, 100), true)
			dxDrawText("Najlepsze przejścia", bgPos.x+100/zoom/2, 168/zoom+bgPos.y, bgPos.x+100/zoom/2+160/zoom, 40/zoom, tocolor(200, 200, 200, 200), 0.7, font, "center", "top", false, false, true)
		end 
		
		if selectedTab == 2 then 
			dxDrawRectangle(bgPos.x+100/zoom/2+160/zoom, 160/zoom+bgPos.y, 160/zoom, 40/zoom, tocolor(51, 102, 255, 100), true)
			dxDrawText("Ostatnie przejścia", bgPos.x+100/zoom/2+320/zoom, 168/zoom+bgPos.y, bgPos.x+100/zoom/2+160/zoom, 40/zoom, tocolor(240, 240, 240, 240), 0.7, font, "center", "top", false, false, true)
			places = slenderWindowData.lastPlaces
		else 
			dxDrawRectangle(bgPos.x+100/zoom/2+160/zoom, 160/zoom+bgPos.y, 160/zoom, 40/zoom, tocolor(0, 0, 0, 100), true)
			dxDrawText("Ostatnie przejścia", bgPos.x+100/zoom/2+320/zoom, 168/zoom+bgPos.y, bgPos.x+100/zoom/2+160/zoom, 40/zoom, tocolor(200, 200, 200, 200), 0.7, font, "center", "top", false, false, true)
		end 
		
		
		for i=1, 11 do 
			local offsetY = (i-1)*(30/zoom)
			local r, g, b = 30, 30, 30 
			if i / 2 == math.floor(i / 2) then 
				r, g, b = 60, 60, 60 
			end 
			
			local a = 255 - (255*(i/11))*0.6
			
			if selectedTab == 1 and myBestPlace and ((myBestPlace >= 11 and i == 11) or (i == myBestPlace)) then -- moje miejsce 
				dxDrawRectangle(bgPos.x+100/zoom/2, 200/zoom+bgPos.y+offsetY, bgPos.w-100/zoom, 30/zoom, tocolor(51, 102, 255, 100), true)
				dxDrawText(tostring(myBestPlace)..")", bgPos.x+120/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
				dxDrawText(tostring(places[myBestPlace].name), bgPos.x+201/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
					
				local m, s, cs = msToTimeStr(places[myBestPlace].time)
				local str = m..":"..s..":"..cs
				dxDrawText(str, bgPos.x+700/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
				
				dxDrawText(tostring(places[myBestPlace].pages).. " zebranych", bgPos.x+bgPos.w-150/zoom, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
			else 
				local place = places[i] or {name="Brak!", time="---", pages="-"} 
				
				dxDrawRectangle(bgPos.x+100/zoom/2, 200/zoom+bgPos.y+offsetY, bgPos.w-100/zoom, 30/zoom, tocolor(r, g, b, 200), true)
				dxDrawText(tostring(i)..")", bgPos.x+120/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
				dxDrawText(tostring(place.name), bgPos.x+201/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
					
				if place then 
					local str = "" 
					if type(place.time) == "string" then 
						str = place.time
					else 
						local m, s, cs = msToTimeStr(place.time)
						str = m..":"..s..":"..cs
					end 
					
					dxDrawText(str, bgPos.x+700/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
					
					dxDrawText(tostring(place.pages).. " zebranych", bgPos.x+bgPos.w-150/zoom, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
				end
			end
		end
		
		if isCursorOnElement(bgPos.x+100/zoom/2, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+100/zoom/2, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom, tocolor(51, 102, 255, 200), true)
		else 
			dxDrawRectangle(bgPos.x+100/zoom/2, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom, tocolor(51, 102, 255, 100), true)
		end 
		dxDrawText("Rozpocznij", bgPos.x+100/zoom/2, bgPos.y+bgPos.h-90/zoom, bgPos.x+100/zoom/2+160/zoom, bgPos.y+bgPos.h-90/zoom+50/zoom, tocolor(240, 240, 240, 240), 0.8, font, "center", "center", false, false, true)
		
		if isCursorOnElement(bgPos.x+bgPos.w-210/zoom, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom) then 
			dxDrawRectangle(bgPos.x+bgPos.w-210/zoom, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom, tocolor(231, 76, 60, 200), true)
		else 
			dxDrawRectangle(bgPos.x+bgPos.w-210/zoom, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom, tocolor(231, 76, 60, 100), true)
		end 
		dxDrawText("Anuluj", bgPos.x+bgPos.w-210/zoom, bgPos.y+bgPos.h-90/zoom, bgPos.x+bgPos.w-210/zoom+160/zoom, bgPos.y+bgPos.h-90/zoom+50/zoom, tocolor(240, 240, 240, 240), 0.8, font, "center", "center", false, false, true)
	
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

function msToTimeStr(ms)
	if not ms then
		return ''
	end

	if ms < 0 then
		return "0","00","00"
	end

	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))

	return minutes, seconds, centiseconds
end

local ped = createPed(1, -1633.65,-2234.06,31.48, 180)
addEventHandler("onClientPedDamage", ped, cancelEvent)
setElementFrozen(ped, true)

