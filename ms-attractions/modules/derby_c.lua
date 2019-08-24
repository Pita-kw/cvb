Derby = {}

function Derby.load()
	Derby.cmd = "db"
	Derby.team = getTeamFromName("Derby")
end 

function Derby.stop()

end 

function Derby.finish()	
	removeEventHandler("onClientRender", root, Derby.renderHUD)
	removeEventHandler("onClientVehicleDamage", root, Derby.damage)
	
	Derby.endTick = nil 
	
	Core.unloadCustomScript()
end 
addEvent("onClientFinishDerby", true)
addEventHandler("onClientFinishDerby", root, Derby.finish)

function Derby.onPreLoad(script) 
	if script then 
		setTimer(Core.loadCustomScript, 2000, 1, script)
	end
end 
addEvent("onClientDerbyPreLoad", true)
addEventHandler("onClientDerbyPreLoad", root, Derby.onPreLoad)

function Derby.onStart(time)
	if not getPlayerTeam(localPlayer) then return end 
	
	Derby.countdown = 5 
	Derby.endTick = getTickCount()+time 
	
	playSoundFrontEnd(43)
	
	setTimer(function()
		Derby.countdown = Derby.countdown-1 
		if Derby.countdown == 0 then 
			playSoundFrontEnd(45)
			setTimer(function()
				if getPlayerTeam(localPlayer) then addEventHandler("onClientRender", root, Derby.renderHUD) end
				removeEventHandler("onClientRender", root, Derby.renderCountdown)
			end, 1000, 1)
		else 
			playSoundFrontEnd(43)
		end
	end, 1000, Derby.countdown)

	addEventHandler("onClientRender", root, Derby.renderCountdown)
	addEventHandler("onClientVehicleDamage", root, Derby.damage)
end 
addEvent("onClientDerbyStart", true)
addEventHandler("onClientDerbyStart", root, Derby.onStart)

function Derby.damage(attacker)
	if isElement(attacker) and getElementType(attacker) == "object" and getElementData(attacker, "derby") and source == getPedOccupiedVehicle(localPlayer) then 
		cancelEvent()
	end
end 

local screenW, screenH = guiGetScreenSize() 
function Derby.renderCountdown()
	local text = tostring(Derby.countdown)
	if text == "0" then 
		text = "START!"
	end
	
	dxDrawText(text, (screenW/2)-1, (screenH/3)-1, (screenW/2)-1, (screenH/3)-1, tocolor(0, 0, 0, 255), 3.0, "default-bold", "center", "top", false, true, true)
	dxDrawText(text, screenW/2, screenH/3, screenW/2, screenH/3, tocolor(236, 240, 241, 255), 3.0, "default-bold", "center", "top", false, true, true)
end 

local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function Derby.renderHUD()
	local time = math.floor((Derby.endTick-getTickCount())/1000)
		
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
	dxDrawText("Zepchnij graczy!", bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.8, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(#getPlayersInTeam(getTeamFromName("Derby"))), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("graczy", bgPos.x, bgPos.y + 60/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(time), bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	
	dxDrawText("czas", bgPos.x+bgPos.w-90/zoom, bgPos.y + 60/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
end 

