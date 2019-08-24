CTF = {} 

function CTF.load()
	CTF.cmd = "ctf"
	CTF.team = getTeamFromName("Capture The Flag")
end

function CTF.stop()

end 

function CTF.finish()
	for k,v in ipairs(CTF.enemyMarkers) do 
		destroyElement(v)
	end 
	
	removeEventHandler("onClientRender", root, CTF.onRender)
	removeEventHandler("onClientPlayerDamage", root, CTF.onDamage)
end 

function CTF.onClientStart(time)
	CTF.endTick = getTickCount()+time-1000
	CTF.enemyMarkers = {} 
	for k,v in ipairs(getPlayersInTeam(getPlayerTeam(localPlayer))) do 
		if getElementData(v, "player:CTF_team") ~= getElementData(localPlayer, "player:CTF_team") then 
			local x,y,z = getElementPosition(v)
			local marker = createMarker(x, y, z, "arrow", 0.5, 255, 0, 0, 200)
			attachElements(marker, v, 0, 0, 1.5)
			table.insert(CTF.enemyMarkers, marker)
		end
	end
	
	local team = "czerwonej"
	if getElementData(localPlayer, "player:CTF_team") ~= "red" then 
		team = "niebieskiej"
	end 
	
	triggerEvent("onClientAddNotification", localPlayer, "Należysz do drużyny "..team..".", "info", 10000)
	addEventHandler("onClientRender", root, CTF.onRender)
	addEventHandler("onClientPlayerDamage", root, CTF.onDamage)
end 
addEvent("onClientStartCTF", true)
addEventHandler("onClientStartCTF", root, CTF.onClientStart)

function CTF.onDamage(attacker)
	local team = getElementData(localPlayer, "player:CTF_team")
	if attacker then 
		local attackerTeam = getElementData(attacker, "player:CTF_team")
		if team == attackerTeam then 
			cancelEvent()
		end
	end
end 

local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function CTF.onRender()
	local team = getElementData(localPlayer, "player:CTF_team")
	if team then 
		local time = (CTF.endTick-getTickCount())/1000
		if time < 0 then 
			CTF.finish()
			return
		end 
		
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
		dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
		dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
		dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
		dxDrawText("Zdobądź flagę!", bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, Core.font, "center", "top", false, true, true)
		
		local m = getRealTime(time).minute
		local s = getRealTime(time).second 
		
		dxDrawText(string.format("%.2d:%.2d", m, s), bgPos.x, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.55, Core.font, "center", "top", false, true, true)
		
		dxDrawText(tostring(getElementData(resourceRoot, "CTF:points_red")), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(231, 76, 60, 230), 1, Core.font, "center", "top", false, true, true)
		dxDrawText("Czerwoni", bgPos.x, bgPos.y + 55/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
		
		dxDrawText(tostring(getElementData(resourceRoot, "CTF:points_blue")),bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(51, 102, 255, 230), 1, Core.font, "center", "top", false, true, true)
		dxDrawText("Niebiescy", bgPos.x+bgPos.w-90/zoom, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
	end
end 
