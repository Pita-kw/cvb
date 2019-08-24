-- kupno baz
local screenW, screenH = guiGetScreenSize() 

local zoom = 1.0
local baseX = 2048
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 
bgPos = {x=screenW/2-500/zoom/2, y=screenH/2-440/zoom/2, w=500/zoom, h=440/zoom}

local base = false 

function showBaseWindow(baseData)
	showCursor(true, false)
	font = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 23/zoom, false, "antialiased") or "default-bold"
	addEventHandler("onClientRender", root, renderBaseWindow)
	
	base = baseData
end 
addEvent("onClientShowBaseWindow", true)
addEventHandler("onClientShowBaseWindow", root, showBaseWindow)

function hideBaseWindow()
	setTimer(showCursor, 100, 1, false)
	if font then destroyElement(font) font = nil end
	removeEventHandler("onClientRender", root, renderBaseWindow)
	
	base = false
end 
addEvent("onClientHideBaseWindow", true)
addEventHandler("onClientHideBaseWindow", root, hideBaseWindow)

function renderBaseWindow()
	if not base then 
		hideBaseWindow()
		return
	end 
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 50/zoom, tocolor(0, 0, 0, 150), true)
	dxDrawText("Baza", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+50/zoom, tocolor(255, 255, 255, 255), 0.7, font, "center", "center", false, false, true)
	
	local descText = "#FFFFFFBaza gangowa zapewni twojemu gangowi specjalną\nstrefę, w której DM jest tylko dostępny dla was.\n\nBrama do bazy jest otwierana tylko dla\nczłonków gangu, który posiada bazę."
	if base.owner == -1 then 
		descText = descText.."\n\nKwota zakupu: #3498db"..tostring(base.diamonds).." #FFFFFFdiamentów.\nBaza jest zakupiona na tydzień. Po upływie terminu\ntrzeba ją przedłużać za #2ecc71$"..tostring(base.dollars).."#FFFFFF co tydzień."
	else 
		descText = descText.."\n\nKwota przedłużenia: #2ecc71$"..tostring(base.dollars).."#FFFFFF.\nBaza ważna do: "..formatDate("h:i d.m.Y", "'", base.expires)
	end
	
	dxDrawText(descText, bgPos.x, bgPos.y+70/zoom, bgPos.x+bgPos.w, 0, tocolor(255, 255, 255, 255), 0.65, font, "center", "top", false, false, true, true)
	
	local x, y, w, h = bgPos.x+bgPos.w/2-150/zoom/2, bgPos.y+bgPos.h-130/zoom, 150/zoom, 45/zoom
	if base.owner == -1 then 
		local x, y, w, h = bgPos.x+bgPos.w/2-150/zoom/2, bgPos.y+bgPos.h-80/zoom, 150/zoom, 45/zoom
		if isCursorOnElement(x, y, w, h) then 
			dxDrawRectangle(x, y, w, h, tocolor(52, 152, 219, 200), true)
			if getKeyState("mouse1") then 
				triggerServerEvent("onPlayerBuyBase", localPlayer, base.id)
				hideBaseWindow()
				return
			end
		else 
			dxDrawRectangle(x, y, w, h, tocolor(52, 152, 219, 100), true)
		end
		
		dxDrawText("Kup", x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.7, font, "center", "center", false, false, true)
	else 
		if isCursorOnElement(x, y, w, h) then 
			dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 200), true)
			if getKeyState("mouse1") then 
				triggerServerEvent("onPlayerExtendBase", localPlayer, base.id)
				hideBaseWindow()
				return
			end
		else 
			dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 100), true)
		end
		
		dxDrawText("Przedłuż", x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.65, font, "center", "center", false, false, true)
		
		local x, y, w, h = bgPos.x+25/zoom, bgPos.y+bgPos.h-60/zoom, 210/zoom, 45/zoom
		if isCursorOnElement(x, y, w, h) then 
			if base.antitheft == 0 then dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 200), true) else dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 200), true) end
			if getKeyState("mouse1") then 
				if base.antitheft == 0 then
					triggerServerEvent("onPlayerInstallBaseUpgrade", localPlayer, base.id, "antitheft")
					hideBaseWindow()
					return
				end
			end
		else 
			if base.antitheft == 0 then dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 100), true) else dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 100), true) end
		end
			
		dxDrawText("System antywłamaniowy \n"..(base.antitheft == 1 and "zainstalowany" or "$25000 i 5 LVL gangu"), x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.6, font, "center", "center", false, false, true)
		
		local x, y, w, h = bgPos.x+bgPos.w-235/zoom, bgPos.y+bgPos.h-60/zoom, 210/zoom, 45/zoom
		if isCursorOnElement(x, y, w, h) then 
			if not base.airprotection.installed then dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 200), true) else dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 200), true) end
			if getKeyState("mouse1") then 
				if not base.airprotection.installed then 
					triggerServerEvent("onPlayerInstallBaseUpgrade", localPlayer, base.id, "airprotection")
					hideBaseWindow()
					return
				end
			end
		else 
			if not base.airprotection.installed then dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 100), true) else dxDrawRectangle(x, y, w, h, tocolor(46, 204, 113, 100), true) end
		end
		
		local installed = base.airprotection.installed == true and 1 or 0
		dxDrawText("Ochrona przeciwlotnicza\n"..(installed == 1 and "zainstalowana" or "$50000 i 12 LVL gangu"), x, y, x+w, y+h, tocolor(240, 240, 240, 240), 0.6, font, "center", "center", false, false, true)
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

-- bazy 
addEvent("onClientEnableBaseAirProtection", true)
addEventHandler("onClientEnableBaseAirProtection", root, function(protectionData, colshape)
	local x, y, z = protectionData.x, protectionData.y, protectionData.z
	for i=1,3 do 
		local projectile = createProjectile(localPlayer, 20, x+math.random(-20, 20)*i, y, z, 1, getPedOccupiedVehicle(localPlayer))
	end
end)
