HideNSeek = {}

function HideNSeek.load()
	HideNSeek.cmd = "ch"
	HideNSeek.team = getTeamFromName("Chowany")
end 

function HideNSeek.stop()

end 

function HideNSeek.finish()	
	removeEventHandler("onClientRender", root, HideNSeek.renderHUD)
	removeEventHandler("onClientPlayerDamage", localPlayer, HideNSeek.checkDamage)
	
	for k,v in ipairs(HideNSeek.markers) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end 
	
	HideNSeek.seekers = nil
	HideNSeek.markers = nil 
	
	HideNSeek.endTick = nil 
end 
addEvent("onClientFinishHideNSeek", true)
addEventHandler("onClientFinishHideNSeek", root, HideNSeek.finish)

function HideNSeek.checkDamage(attacker)
	if source ~= localPlayer then return end 
	
	for k,v in ipairs(HideNSeek.seekers) do 
		if localPlayer == v then 
			cancelEvent()
		end
	end
	
	for k,v in ipairs(getPlayersInTeam(getTeamFromName("Chowany"))) do 
		local isSeeker = false 
		for _, seeker in ipairs(HideNSeek.seekers) do 
			if attacker == seeker then 
				isSeeker = true 
			end
		end
		
		if not isSeeker then 
			cancelEvent()
		end
	end
end 

function HideNSeek.onStart(time, isSeeker, seekers)
	if not getPlayerTeam(localPlayer) then return end 
	
	HideNSeek.endTick = getTickCount()+time 
	HideNSeek.isSeeker = isSeeker
	HideNSeek.seekers = seekers 
	HideNSeek.markers = {}
	setTimer(function() 
		for k,v in ipairs(HideNSeek.seekers) do 
			if isElement(v) then 
				local x,y,z = getElementPosition(v)
				local marker = createMarker(x, y, z, "arrow", 0.5, 255, 0, 0, 200)
				attachElements(marker, v, 0, 0, 1.5)
				setElementDimension(marker, getElementDimension(v))
				setElementInterior(marker, getElementInterior(v))
				table.insert(HideNSeek.markers, marker)
			end
		end 
	end, 4000, 1)
	
	addEventHandler("onClientPlayerDamage", root, HideNSeek.checkDamage)
	addEventHandler("onClientRender", root, HideNSeek.renderHUD)
end 
addEvent("onClientHideNSeekStart", true)
addEventHandler("onClientHideNSeekStart", root, HideNSeek.onStart)

local screenW, screenH = guiGetScreenSize() 

local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function HideNSeek.renderHUD()
	local time = math.floor((HideNSeek.endTick-getTickCount())/1000)
		
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	
	
	if HideNSeek.isSeeker then 
		dxDrawText("Znajdź i zabij graczy!", bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.8, Core.font, "center", "top", false, true, true)
	else 
		dxDrawText("Chowaj się przed szukającym!", bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.8, Core.font, "center", "top", false, true, true)
	end 
	
	dxDrawText(tostring(#getPlayersInTeam(getTeamFromName("Chowany"))), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("graczy", bgPos.x, bgPos.y + 60/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
	
	dxDrawText(tostring(time), bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 1, Core.font, "center", "top", false, true, true)
	
	dxDrawText("czas", bgPos.x+bgPos.w-90/zoom, bgPos.y + 60/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
end 

