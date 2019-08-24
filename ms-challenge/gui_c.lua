local zoom = 1 
local baseX = 1920
local minZoom = 2
local screenW, screenH = guiGetScreenSize()
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-500/zoom/2, y=screenH/2-650/zoom/2, w=500/zoom, h=650/zoom}
local challengeWindowData = false 
local myBestPlace = nil 
local selectedTab = 1 

function showChallengeWindow(b, data)
	if b then 
		if challengeWindowData then return end 
		
		challengeWindowData = data
		font = dxCreateFont("f/archivo_narrow.ttf", 19/zoom) or "default-bold"
		addEventHandler("onClientRender", root, renderChallengeWindow)
		addEventHandler("onClientClick", root, clickChallengeWindow)
		showCursor(true)
		
		for k,v in ipairs(challengeWindowData.bestPlaces) do 
			if v[1] == getPlayerName(localPlayer) then 
				myBestPlace = k
				break
			end
		end
	else 
		myBestPlace = nil 
		challengeWindowData = nil
				
		removeEventHandler("onClientRender", root, renderChallengeWindow)
		removeEventHandler("onClientClick", root, clickChallengeWindow)
		if isElement(font) then 
			destroyElement(font)
			font = nil 
		end
		showCursor(false)
	end
end 

function clickChallengeWindow(key, state)
	if key == "left" and state == "up" then 
		if isCursorOnElement(bgPos.x+100/zoom/2, 160/zoom+bgPos.y, 160/zoom, 40/zoom) then 
			selectedTab = 1 
		elseif isCursorOnElement(bgPos.x+100/zoom/2+160/zoom, 160/zoom+bgPos.y, 160/zoom, 40/zoom) then 
			selectedTab = 2 
		end
		
		if isCursorOnElement(bgPos.x+100/zoom/2, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom) then -- rozpoczecie wyzwania 
			triggerServerEvent("onChallengeStart", localPlayer, challengeWindowData.title)
			showChallengeWindow(false)
		elseif isCursorOnElement(bgPos.x+bgPos.w-210/zoom, bgPos.y+bgPos.h-90/zoom, 160/zoom, 50/zoom) then -- anulowanie 
			showChallengeWindow(false)
		end 
	end
end 

function renderChallengeWindow()
	if challengeWindowData then 
		local places = challengeWindowData.bestPlaces 
				
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(220, 220, 220, 255))
		dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 50/zoom, tocolor(30, 30, 30, 150), true)
		dxDrawText("Próba czasowa: "..tostring(challengeWindowData.title), bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+50/zoom, tocolor(240, 240, 240, 240), 0.9, font, "center", "center", false, false, true)
		
		dxDrawText("W tym miejscu możesz wykonać próbę czasową.\nSkończ w wyznaczonym czasie i zdobądź pieniądze i EXP.\nPoniżej znajdziesz listę najlepszych statystyk.", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+bgPos.h-450/zoom, tocolor(240, 240, 240, 240), 0.7, font, "center", "center", false, false, true)
		
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
			places = challengeWindowData.lastPlaces
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
				dxDrawText(tostring(places[myBestPlace][1]), bgPos.x+201/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
					
				local m, s, cs = msToTimeStr(places[myBestPlace][2])
				local str = m..":"..s..":"..cs
				dxDrawText(str, bgPos.x+630/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
			else 
				local place = places[i] or {"Brak!", "---"} 
				
				dxDrawRectangle(bgPos.x+100/zoom/2, 200/zoom+bgPos.y+offsetY, bgPos.w-100/zoom, 30/zoom, tocolor(r, g, b, 200), true)
				dxDrawText(tostring(i)..")", bgPos.x+120/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
				dxDrawText(tostring(place[1]), bgPos.x+201/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
					
				if place then 
					local str = "" 
					if type(place[2]) == "string" then 
						str = place[2] 
					else 
						local m, s, cs = msToTimeStr(place[2])
						str = m..":"..s..":"..cs
					end 
					
					dxDrawText(str, bgPos.x+630/zoom/2, 202/zoom+bgPos.y+offsetY, 0, 0, tocolor(240, 240, 240, a), 0.7, font, "left", "top", false, false, true)
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