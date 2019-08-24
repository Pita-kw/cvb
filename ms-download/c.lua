TAB_TIME = 10000
ANIM_TIME = 3000 
FADE_TIME = 1000 

local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 


local bgPos = {x=screenW/2-1366/zoom/2, y=screenH/2-768/zoom/2, w=1366/zoom, h=768/zoom}
local logoPos = {x=screenW/2-((210/zoom)*1.5)/2, y=20/zoom, w=(210/zoom)*1.5, h=(150/zoom)*1.5}
local downloadPos = {x=screenW-450/zoom, y=70/zoom, w=408/zoom, h=86/zoom}

local tabs = {
	{"i/objects.png", "Teleporty", 
	[[Na naszym serwerze znajdziesz sporą ilość teleportów.
	  Są to teleporty o tematyce stunt, wszelakie tory, 
	  oraz różne atrakcje np zombie czy minecraft. 
	  Aby otworzyć menu z teleportami, wystarczy że 
	  podczas gry naciśniesz F3.]]},
	{"i/help.png", "Pomoc",
	[[Wszelkie informacje przedstawiane na tym ekranie 
	  są skrótowe, jeżeli chcesz w pełni zapoznać się z naszymi 
	  systemami naciśnij F9 podczas gry aby otworzyć panel 
	  pomocy. Pomoc możesz uzyskać również od administracji 
	  kontaktując się z jednym z administratorów. 
	  Aby sprawdzić dostępnych administratorów wpisz 
	  komendę /admins.]]},
	 {"i/vehicles.png", "Pojazdy",
	  [[Na serwerze możesz zespawnować pojazd otwierając 
	  panel spawnu pojazdów, znajdujący się pod F2. 
	  Jednak aby tuningować i w pełni modernizować pojazd 
	  należy kupić prywatne auto w salonie. 
	  Salon oznaczony jest na mapie ikoną pojazdu.]]},
	  {"i/dashboard.png", "Dashboard",
	  [[Aby otworzyć Dashboard na naszym serwerze 
	  wystarczy, że podczas gry naciśniesz F1. Znajdziesz 
	  tam najpotrzebniejsze rzeczy takie jak ustawienia konta, 
	  ustawienia graficzne czy personalne, oraz będziesz 
	  mógł sprawdzić swoje statystyki czy osiągnięcia.]]},
	  {"i/order.png", "Zlecenia",
	  [[Wszelkie zlecenia które możesz wykonać są oznaczone 
	  na mapie ikonką dolara. Dzięki zleceniom będziesz 
	  mógł zarobić gotówkę i kupić swój 
	  prywatny pojazd lub dom.]]},
	  {"i/join_us.png", "Dołącz do nas", 
	  [[Jeżeli chcesz być na bieżąco z serwerem zapraszamy 
	  do rejestracji na naszym forum które znajduje się 
	  pod adresem www.multiserver.pl.]]}
}
local currentTab = 1 
local nextTab = false

local tick = 0 
local nextTick = 0 

local hiding = false 
local hideTick = 0 

function changeTab() 
	tick = getTickCount()+TAB_TIME+ANIM_TIME
	nextTick = getTickCount()+ANIM_TIME
	
	nextTab = currentTab+1
	if nextTab > #tabs then 
		nextTab = 1 
	end
end 

function fadeSound() 
	if isElement(sound) then
		local vol = getSoundVolume(sound)
		vol = vol-0.05 
		if vol < 0 then 
			destroyElement(sound)
		else 
			setSoundVolume(sound, vol)
			setTimer(fadeSound, 100, 1)
		end 
	end
end 
addEvent("fadeLoginSound", true)
addEventHandler("fadeLoginSound", root, fadeSound)

function hideDownloadScreen()
	removeEventHandler("onClientRender", root, renderDownloadScreen)
	if isElement(font1) then destroyElement(font1) end 
	if isElement(font2) then destroyElement(font2) end 
end

function renderDownloadScreen()
	local now = getTickCount()
	if now > tick then 
		changeTab()
	end 
	
	local alpha = 255
	
	if getElementData(localPlayer, "player:downloaded") and not hiding then 
		hiding = true
		hideTick = getTickCount()+FADE_TIME
	end 
	
	if hiding then 
		local progress = (now-hideTick+FADE_TIME) / FADE_TIME
		alpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "InQuad")
		if progress >= 1 then 
			hideDownloadScreen()
			return 
		end
	end 
	
	dxDrawImage(0, 0, screenW, screenH, "i/background.jpg", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawImage(logoPos.x, logoPos.y, logoPos.w, logoPos.h, "i/logo.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawImage(downloadPos.x, downloadPos.y, downloadPos.w, downloadPos.h, "i/download_back.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawText("Pobieranie zasobów serwera", downloadPos.x+55/zoom, downloadPos.y, downloadPos.w, downloadPos.y+downloadPos.h, tocolor(255, 255, 255, alpha), 0.6, font1, "left", "center", false, true, true)
	exports["ms-gui"]:renderLoading(downloadPos.x+downloadPos.w-90/zoom, downloadPos.y+41/zoom/2, 40/zoom, 40/zoom)

	local offsetX = 0 
	if nextTab then 
		local progress = (now-nextTick+ANIM_TIME) / ANIM_TIME

		offsetX = interpolateBetween(0, 0, 0, screenW, 0, 0, progress, "InOutQuad")
		
		local offsetX2 = 0 
		offsetX2 = interpolateBetween(-screenW, 0, 0, 0, 0, 0, progress, "InOutQuad")
		
		local tabData = tabs[nextTab]
		if tabData then 
			dxDrawImage(bgPos.x+offsetX2, bgPos.y, bgPos.w, bgPos.h, "i/info_back.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
			dxDrawImage(bgPos.x+80/zoom+offsetX2, bgPos.y+bgPos.h/2-500/zoom/2, 656/zoom, 500/zoom, tabData[1], 0, 0, 0, tocolor(255, 255, 255, alpha), false)
			dxDrawText(tabData[2], bgPos.x+offsetX2, bgPos.y+bgPos.h/4, bgPos.x+bgPos.w+635/zoom+offsetX2, bgPos.h, tocolor(230, 230, 230, math.max(0, alpha-30)), 1, font1, "center", "top", false, true, true)
			dxDrawText(tabData[3], bgPos.x+offsetX2, bgPos.y+bgPos.h/3, bgPos.x+bgPos.w+635/zoom+offsetX2, bgPos.h, tocolor(200, 200, 200, math.max(0, alpha-30)), 1, font2, "center", "top", false, true, true)
		end
		
		if progress > 1 then 
			currentTab = nextTab
			nextTab = false
		end
	end
	
	local tabData = tabs[currentTab]
	dxDrawImage(bgPos.x+offsetX, bgPos.y, bgPos.w, bgPos.h, "i/info_back.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawImage(bgPos.x+80/zoom+offsetX, bgPos.y+bgPos.h/2-500/zoom/2, 656/zoom, 500/zoom, tabData[1], 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawText(tabData[2], bgPos.x+offsetX, bgPos.y+bgPos.h/4, bgPos.x+bgPos.w+635/zoom+offsetX, bgPos.h, tocolor(230, 230, 230, math.max(0, alpha-30)), 1, font1, "center", "top", false, true, true)
	dxDrawText(tabData[3], bgPos.x+offsetX, bgPos.y+bgPos.h/3, bgPos.x+bgPos.w+635/zoom+offsetX, bgPos.h, tocolor(200, 200, 200, math.max(0, alpha-30)), 1, font2, "center", "top", false, true, true)
end 

function onClientResourceStart()
	if not getElementData(localPlayer, "player:downloaded") then 
		sound = playSound("http://multiserver.pl/audio/race/ctc.mp3", true)
		setSoundVolume(sound, 0.8)
		
		fadeCamera(false)
	end
	
	setTimer(function() 
		if getElementData(localPlayer, "player:downloaded") then return end 
		
		showChat(false)
		
		font1 = dxCreateFont("BebasNeue.otf", 29/zoom) or "default-bold"
		font2 = dxCreateFont("archivo_narrow.ttf", 19/zoom) or "default-bold"
		
		addEventHandler("onClientRender", root, renderDownloadScreen)
		tick = getTickCount()+TAB_TIME
	end, 3000, 1)
end 
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)