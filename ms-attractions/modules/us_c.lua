US = {} 

function US.load()
	US.cmd = "us"
	US.team = getTeamFromName("Uważaj, spadasz!")
end 

function US.stop()
end 

function US.shakeObject(object)
	local target = object 
	local startTick = getTickCount() 
	
	local function updateShake()
		local currentTick = getTickCount()
	    local tickDifference = currentTick - startTick
	    if tickDifference > 2400 then
			removeEventHandler("onClientRender", root, updateShake)
	        else
	        local newx = tickDifference/125 * 1
			local newy = tickDifference/125 * 1
			if isElement ( target ) then
				setElementRotation ( target, math.deg( 0.555 ), 3 * math.cos(newy + 1), 3 * math.sin(newx + 1) )
			else 
				removeEventHandler("onClientRender", root, updateShake)
	        end
		end
	end 
	addEventHandler("onClientRender", root, updateShake)
end 
addEvent("onClientShakeBoard", true)
addEventHandler("onClientShakeBoard", root, US.shakeObject)

function US.onClientStop()
	toggleControl("fire", true)
	toggleControl("aim_weapon", true)
	removeEventHandler("onClientRender", root, US.renderHUD)
end 
addEvent("onClientStopUS", true)
addEventHandler("onClientStopUS", root, US.onClientStop)

function US.onClientStart()
	addEventHandler("onClientRender", root, US.renderHUD)
	toggleControl("fire", false)
	toggleControl("aim_weapon", false)
end 
addEvent("onClientStartUS", true)
addEventHandler("onClientStartUS", root, US.onClientStart)

local screenW, screenH = guiGetScreenSize() 

local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function US.renderHUD()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	
	dxDrawText("Nie spadnij!", bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.8, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(#getPlayersInTeam(getTeamFromName("Uważaj, spadasz!"))), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("graczy", bgPos.x, bgPos.y + 60/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(getElementData(resourceRoot, "us:objects_count")), bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("platform", bgPos.x+bgPos.w-90/zoom, bgPos.y + 60/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
	
end 
