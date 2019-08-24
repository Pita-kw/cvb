Berek = {}

function Berek.load()
	Berek.cmd = "br"
	Berek.team = getTeamFromName("Berek")
	Berek.minHitDist = 1
end 

function Berek.stop()
	
end 

function Berek.finish()	
	removeEventHandler("onClientRender", root, Berek.renderHUD)
	removeEventHandler("onClientKey", root, Berek.push)
	
	Berek.endTick = nil 
end 
addEvent("onClientFinishBerek", true)
addEventHandler("onClientFinishBerek", root, Berek.finish)

function Berek.onStart(time)
	if not getPlayerTeam(localPlayer) then return end 
	
	Berek.endTick = getTickCount()+time 
	
	addEventHandler("onClientRender", root, Berek.renderHUD)
	addEventHandler("onClientKey", root, Berek.push)
end 
addEvent("onClientBerekStart", true)
addEventHandler("onClientBerekStart", root, Berek.onStart)

function Berek.push(key, state)
	if key == "mouse1" and state then 
		local players = getPlayersInTeam(getTeamFromName("Berek"))
		if getElementData(resourceRoot, "berek:player") == localPlayer then
			local px, py, pz = getElementPosition(localPlayer)
			
			for k, v in ipairs(players) do 
				local ex, ey, ez = getElementPosition(v)
				local dist = getDistanceBetweenPoints3D(px, py, pz, ex, ey, ez)
				if dist < Berek.minHitDist and v ~= localPlayer then 
					Berek.damage(v)
					break
				end
			end 
		end 
	end
end 

function Berek.damage(who)
	triggerServerEvent("onPlayerBerekDamage", localPlayer, who)
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

function Berek.renderHUD()
	local time = math.floor((Berek.endTick-getTickCount())/1000)
		
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	
	local player = getElementData(resourceRoot, "berek:player") 
	if player == localPlayer then
		dxDrawText("Jesteś berkiem! Szukaj graczy!", bgPos.x, bgPos.y + 28/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, Core.font, "center", "top", false, true, true)
	else 
		local name = "?"
		if isElement(player) then 
			name = getPlayerName(player)
		end
		
		dxDrawText("Berkiem jest "..name.."!", bgPos.x, bgPos.y + 28/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, Core.font, "center", "top", false, true, true)
		
	end 
	
	local players = getPlayersInTeam(getTeamFromName("Berek"))
	dxDrawText(tostring(#players), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("graczy", bgPos.x, bgPos.y + 60/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(time), bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	
	dxDrawText("czas", bgPos.x+bgPos.w-90/zoom, bgPos.y + 60/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
end 

