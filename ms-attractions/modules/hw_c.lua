HunterWar = {} 

function HunterWar.load()
	HunterWar.cmd = "hw"
	HunterWar.team = getTeamFromName("Wojna Hunterów")
end

function HunterWar.stop()
end 

function HunterWar.finish()
	removeEventHandler("onClientRender", root, HunterWar.onRender)
end 

function HunterWar.onClientStart(time, spawn)
	HunterWar.steeringHelp = true
	HunterWar.endTick = getTickCount()+time-1000
	HunterWar.spawn = spawn 
	
	setTimer(function() HunterWar.steeringHelp = false end, 5000, 1)
	
	addEventHandler("onClientRender", root, HunterWar.onRender)
end 
addEvent("onClientStartHunterWar", true)
addEventHandler("onClientStartHunterWar", root, HunterWar.onClientStart)

local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function HunterWar.onRender() 
	local team = getPlayerTeam(localPlayer)
	if not team then HunterWar.finish() return end 
	
	local time = math.floor((HunterWar.endTick-getTickCount())/1000)
	if time < 0 then 
		HunterWar.finish()
		return
	end 
	
	if HunterWar.steeringHelp then 
		setAnalogControlState("accelerate", 1)
	end 
	
	local x,y,z = getElementPosition(localPlayer)
	local x2,y2,z2 = HunterWar.spawn.x, HunterWar.spawn.y, HunterWar.spawn.z 
	local dist = getDistanceBetweenPoints2D(x, y, x2, y2)
	
	--[[
	if dist > 1300 then 
		setElementHealth(localPlayer, 0)
		HunterWar.finish()
		return
	elseif dist > 1100 then 
		dxDrawText("Wróć na pole bitwy!", (screenW/2)-1, (screenH/2)-1, (screenW/2)-1, (screenH/2)-1, tocolor(0, 0, 0, 255), 2.0, "default-bold", "center", "top", false, true, true)
		dxDrawText("Wróć na pole bitwy!", screenW/2, screenH/2, screenW/2, screenH/2, tocolor(255, 0, 0, 255), 2.0, "default-bold", "center", "top", false, true, true)
	end 
	--]]
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
	dxDrawText("Zniszcz huntery!", bgPos.x, bgPos.y + 30/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, Core.font, "center", "top", false, true, true)
		
	dxDrawText(tostring(#getPlayersInTeam(team)), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("Pozostali", bgPos.x, bgPos.y + 55/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
		
	dxDrawText(tostring(time),bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("Czas", bgPos.x+bgPos.w-90/zoom, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
end 

