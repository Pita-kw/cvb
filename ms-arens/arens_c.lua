addEventHandler("onClientResourceStop", resourceRoot, function()
	showArenaHUD(false)
end)

function showArenaHUD(force)
	if force == true then
		bgX, bgY,bgW, bgH = exports["ms-hud"]:getInterfacePosition()
		zoom = exports["ms-hud"]:getInterfaceZoom()
		bgPos = {x=bgX, y=bgY+230/zoom, w=bgW, h=bgH-30/zoom}
		bgPlayers={x=bgPos.x-210/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgPlayersCount={x=bgPos.x-210/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		bgArenaName={x=bgPos.x, y=bgPos.y+35/zoom, w=bgPos.w, h=bgPos.h}
		bgPlayerFrags={x=bgPos.x+210/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgPlayerFragsCount={x=bgPos.x+210/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		
		font = dxCreateFont( "f/archivo_narrow.ttf", 30/zoom)
		addEventHandler("onClientRender", getRootElement(), drawArenaStats) 
	end

	if force == false then
		exports["ms-blur"]:destroyBlurBox(arena_stats)
		if isElement(font) then 
			destroyElement(font)
		end 
		
		removeEventHandler("onClientRender", getRootElement(), drawArenaStats) 
		
		arena_stats = nil
	end
end
addEvent("arenaHudTrigger", true)
addEventHandler("arenaHudTrigger", localPlayer,  showArenaHUD)


function drawArenaStats()
	local arena_name = getElementData(localPlayer, "player:arena") or "Nieznana"
	local players_count = getElementData(resourceRoot, "".. arena_name ..":players") or "?"
	local player_frags = getElementData(localPlayer, "".. arena_name ..":kills") or "0"
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor (170, 170, 170, 255), true)
	dxDrawRectangle (bgPos.x, bgPos.y+100/zoom, bgPos.w, 5/zoom, tocolor ( 51, 102, 255, 255 ), true)
	dxDrawRectangle (bgPos.x, bgPos.y, 120/zoom, 100/zoom, tocolor ( 20, 20, 20, 50 ), true)
	dxDrawRectangle (bgPos.x+bgPos.w-120/zoom, bgPos.y, 120/zoom, 100/zoom, tocolor ( 20, 20, 20, 50 ), true)
	dxDrawText ("Gracze", bgPlayers.x, bgPlayers.y, bgPlayers.x+bgPlayers.w, bgPlayers.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText ("Fragi", bgPlayerFrags.x, bgPlayerFrags.y, bgPlayerFrags.x+bgPlayerFrags.w, bgPlayerFrags.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText (players_count, bgPlayersCount.x, bgPlayersCount.y, bgPlayersCount.x+bgPlayersCount.w, bgPlayersCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	dxDrawText (player_frags, bgPlayerFragsCount.x, bgPlayerFragsCount.y, bgPlayerFragsCount.x+bgPlayerFragsCount.w, bgPlayerFragsCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	dxDrawText (string.upper(arena_name), bgArenaName.x, bgArenaName.y-10/zoom, bgArenaName.x+bgArenaName.w, bgArenaName.y, tocolor (255, 255, 255, 255), 0.8, font, "center", "top", false,false, true )
	dxDrawText ("By opuścić arenę wpisz /ae", bgArenaName.x, bgArenaName.y+25/zoom, bgArenaName.x+bgArenaName.w, bgArenaName.y, tocolor ( 200, 200, 200, 220 ), 0.55, font, "center", "top", false,false, true )
end

local arenas = {
	"onede",
	"dust",
	"sniper",
	"bazooka",
	"minigun",
}

local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local arenaZoom = 1.0
local minZoom = 1.6
if screenW < baseX then
	arenaZoom = math.min(minZoom, (baseX+200)/screenW)
end 

local bgPos = {x=(screenW/2)-(350/arenaZoom/2), y=(screenH/2)-(380/arenaZoom/2), w=350/arenaZoom, h=380/arenaZoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/arenaZoom}
local bgRow = {x=bgPos.x+20/arenaZoom, w=bgPos.w-75/arenaZoom, h=45/arenaZoom}
local bgRowLine = {x=bgRow.x, w=5/arenaZoom, h=bgRow.h}

local showing = false 

function showArenaWindow()
	if arena_stats then return end 
	if not getElementData(localPlayer, "player:spawned") then return end	
	if not showing and isCursorShowing() then return end -- inne okno musi być otwarte 
	
	showing = not showing
	if showing then 
		font2 = dxCreateFont("f/archivo_narrow.ttf", 24/arenaZoom)
		list = exports["ms-gui"]:createList(bgPos.x+15/arenaZoom, bgPos.y+50/arenaZoom, bgPos.w-30/arenaZoom, bgPos.h-60/arenaZoom, tocolor(20, 20, 20, 150), font2, 0.7, 15/arenaZoom)
		exports["ms-gui"]:addListColumn(list, "Nazwa areny", 0.5)
		exports["ms-gui"]:addListColumn(list, "Liczba graczy", 0.2)
		
		for k,v in ipairs(arenas) do 
			exports["ms-gui"]:addListItem(list, "Nazwa areny", "/"..v)
			exports["ms-gui"]:addListItem(list, "Liczba graczy", tostring(getElementData(resourceRoot, v..":players") or 0))
		end 
		exports["ms-gui"]:reloadListRT(list)
		exports["ms-gui"]:setListActive(list, true)
		
		addEventHandler("onClientRender", root, renderArenaWindow)
		showCursor(true)
		guiSetInputMode("no_binds")
	else 
		if isElement(font2) then 
			destroyElement(font2)
		end
		exports["ms-gui"]:setListActive(list, false)
		exports["ms-gui"]:destroyList(list)
		removeEventHandler("onClientRender", root, renderArenaWindow)
		showCursor(false)
		guiSetInputMode("allow_binds")
	end
end 
bindKey("f5", "down", showArenaWindow)
addEventHandler("onClientResourceStop", resourceRoot, function() if showing then showArenaWindow() end end) 

function renderArenaWindow()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(220, 220, 220, 255))
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	dxDrawText("Dostępne areny", bgPos.x, bgPos.y + 10/arenaZoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.75, font2, "center", "top", false, true, true)
	
	exports["ms-gui"]:renderList(list)
	local selected = exports["ms-gui"]:getSelectedListItemsIndex(list)
	if #selected > 0 then
		triggerServerEvent("onPlayerEnterArena", localPlayer, arenas[selected[1]])
		showArenaWindow()
		return
	end
	--dxDrawText("Kolor wskazuje poziom trudności.", bgPos.x, bgPos.y + bgPos.h-40/arenaZoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.6, font, "center", "top", false, true, true)
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

local marker = createMarker(72.58,2563.69,210.55, "checkpoint", 4.0, 255,255,255,0)
function teleportDown(player)
	if getElementData(player, "player:arena") == "dust" then
		setElementPosition(player, 70.44,2558.58,206.98)
	end
end
addEventHandler("onClientMarkerHit", marker, teleportDown)