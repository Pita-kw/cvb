--[[
	MultiServer 
	Zasób: ms-scoreboard/c.lua
	Opis: Scoreboard.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]
local REFRESH_RATE = 500
local MAX_VISIBLE_ROWS = 8 

local LINE_COLORS = 
{
	-- [ranga] = {r, g, b}
	[0] = {240, 240, 240},
	[1] = {46, 204, 113},
	[2] = {51, 102, 255},
	[3] = {231, 76, 60},
}

local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 2300
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local showScoreboard = false 
local scoreboardData = {} 
local selectedRow = 1 
local visibleRows = MAX_VISIBLE_ROWS
local bgPos = {x=(screenW/2)-(750/zoom/2), y=(screenH/2)-(745/zoom/2), w=750/zoom, h=745/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}
local bgRow = {x=bgPos.x, w=bgPos.w, h=80/zoom}
local bgRowLine = {x=bgRow.x, w=6/zoom, h=bgRow.h}

function refreshScoreboardData()
	scoreboardData={}
	
	local players = getElementsByType("player")
	for k,v in ipairs(players) do 
		if v ~= localPlayer then 
			local status = getElementData(v, "player:status") or "Panel logowania"
			
			if getPlayerTeam(v) then 
				status = "Na atrakcji: "..getTeamName(getPlayerTeam(v))
			elseif getElementData(v, "player:afk") then 
				status = "AFK"
			end 
			
			table.insert(scoreboardData, {uid=getElementData(v, "player:uid") or false, id=getElementData(v, "player:id") or "", name=getPlayerName(v), rank=getElementData(v, "player:rank") or 0, ping=getPlayerPing(v), level=getElementData(v, "player:level") or 1, 
															exp=exports["ms-gameplay"]:msGetTotalExp(v), status=status, avatar=getElementData(v, "player:avatar"), premium=getElementData(v, "player:premium"), color=getElementData(v, "player:nickColor") or "#BFBFBF", gang=getElementData(v, "player:gang") or {tag="---"} })
		end
	end
	
	table.sort(scoreboardData, function(a, b)
		return a.id < b.id
	end)
	
	local status = getElementData(localPlayer, "player:status") or "Panel logowania"
			
	if getPlayerTeam(localPlayer) then 
		status = "Na atrakcji: "..getTeamName(getPlayerTeam(localPlayer))
	elseif getElementData(localPlayer, "player:afk") then 
		status = "AFK"
	end 
	table.insert(scoreboardData, 1, {uid=getElementData(localPlayer, "player:uid") or false, id=getElementData(localPlayer, "player:id") or "", name=getPlayerName(localPlayer), rank=getElementData(localPlayer, "player:rank") or 0, ping=getPlayerPing(localPlayer), level=getElementData(localPlayer, "player:level") or 1, 
													exp=exports["ms-gameplay"]:msGetTotalExp(localPlayer), status=status, avatar=getElementData(localPlayer, "player:avatar"), premium=getElementData(localPlayer, "player:premium"), color=getElementData(localPlayer, "player:nickColor") or "#BFBFBF", gang=getElementData(localPlayer, "player:gang") or {tag="---"}})
end 

function scrollScoreboard(key, press)
	if key == "tab" then
		if not getElementData(localPlayer, "player:spawned") then return end 
		
		toggleScoreboard(press)
	elseif key == "mouse_wheel_up" and showScoreboard then 
		selectedRow = math.max(1, selectedRow-1)
		visibleRows = visibleRows-1 
		if visibleRows < MAX_VISIBLE_ROWS then visibleRows = MAX_VISIBLE_ROWS end 
	elseif key == "mouse_wheel_down" and showScoreboard then 
		local plrs = #scoreboardData
		if selectedRow-1 >= plrs-MAX_VISIBLE_ROWS then return end 
			
		selectedRow = selectedRow+1 
		visibleRows = visibleRows+1 
		if selectedRow > plrs then selectedRow = plrs end
		if visibleRows > plrs then visibleRows = plrs-MAX_VISIBLE_ROWS end 
	end
end 
addEventHandler("onClientKey", root, scrollScoreboard)

function renderScoreboard()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(170, 170, 170, 255))
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 60/zoom, tocolor(10, 10, 10, 150), true)
	dxDrawText("multiServer.pl - Jesteśmy Dla Ciebie", bgPos.x + 15/zoom, bgPos.y+15/zoom, 300/zoom, 10/zoom, tocolor(250, 250, 250, 250), 0.7, font, "left", "top", false, false, true, false, false)
	dxDrawText("Graczy: "..tostring(#scoreboardData).."/100", bgPos.x, bgPos.y+15/zoom, bgPos.w+bgPos.x-20/zoom, bgPos.h+bgPos.y, tocolor(250, 250, 250, 250), 0.7, font, "right", "top", false, false, true, false, false)
	
	local n = 0 
	for k,v in ipairs(scoreboardData) do
		if k >= selectedRow and k <= visibleRows then 
			n = n+1 
			
			local hex = v.color
			local r, g, b = hex2rgb(hex)
			
			local offsetY = 60/zoom + (n-1)*(5/zoom+bgRow.h)
			dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h, tocolor(40, 40, 40, 40), true)
			dxDrawRectangle(bgRowLine.x, bgPos.y+offsetY, bgRowLine.w, bgRowLine.h, tocolor(r, g, b, 255), true)
			
			dxDrawText(tostring(v.id), bgRow.x-50/zoom, bgPos.y+offsetY+25/zoom, bgRow.w+bgRow.x-610/zoom, 50/zoom, tocolor(250, 250, 250, 250), 0.7, font, "center", "top", false, false, true, false, false)
			
			dxDrawImage(math.floor(bgRow.x+80/zoom), math.floor(bgPos.y+offsetY+10/zoom), math.floor(60/zoom), math.floor(60/zoom), exports["ms-avatars"]:loadAvatar(v.uid), 0, 0, 0, tocolor(255, 255, 255, 255), true)
			dxDrawImage(math.floor(bgRow.x+80/zoom), math.floor(bgPos.y+offsetY+10/zoom), math.floor(60/zoom), math.floor(60/zoom), "img/border.png", 0, 0, 0, tocolor(r, g, b, 205), true)
			
			dxDrawText(v.name, bgRow.x-20/zoom, bgPos.y+offsetY+15/zoom, bgRow.w+bgRow.x-140/zoom, 50/zoom, tocolor(250, 250, 250, 250), 0.7, font, "center", "top", false, true, true, false, false)
			dxDrawText(v.status, bgRow.x-20/zoom, bgPos.y+offsetY+45/zoom, bgRow.w+bgRow.x-140/zoom, 50/zoom, tocolor(220, 220, 220, 220), 0.5, font, "center", "top", false, true, true, false, false)
			
			dxDrawText("Ping", bgRow.x+430/zoom, bgPos.y+offsetY+10/zoom, bgRow.w+bgRow.x-240/zoom, 50/zoom, tocolor(250, 250, 250, 250), 0.6, font, "left", "top", false, false, true, false, false)
			dxDrawText(tostring(math.min(999,v.ping)), bgRow.x+390/zoom, bgPos.y+offsetY+40/zoom, bgRow.w+bgRow.x-239/zoom, 50/zoom, tocolor(220, 220, 220, 250), 0.6, font, "center", "top", false, false, true, false, false)
			
			dxDrawText("Exp", bgRow.x+510/zoom, bgPos.y+offsetY+10/zoom, 0, 0, tocolor(250, 250, 250, 250), 0.6, font, "left", "top", false, false, true, false, false)
			dxDrawText(tostring(v.exp), bgRow.x+370/zoom, bgPos.y+offsetY+40/zoom, bgRow.w+bgRow.x-60/zoom, 50/zoom, tocolor(220, 220, 220, 250), 0.6, font, "center", "top", false, false, true, false, false)
			
			dxDrawText("Gang", bgRow.x+580/zoom, bgPos.y+offsetY+10/zoom, 0, 0, tocolor(250, 250, 250, 250), 0.6, font, "left", "top", false, false, true, false, false)
			dxDrawText(tostring(v.gang.tag), bgRow.x+580/zoom, bgPos.y+offsetY+40/zoom, bgRow.w+bgRow.x-120/zoom, 50/zoom, tocolor(220, 220, 220, 250), 0.6, font, "center", "top", false, false, true, false, false)
			
			dxDrawImage(bgRow.x+bgRow.w-80/zoom, bgPos.y+offsetY+10/zoom, 60/zoom, 60/zoom, "img/circle.png", 0, 0, 0, tocolor(r, g, b, 255), true)
			dxDrawText(tostring(v.level), bgRow.x+bgRow.w-270/zoom, bgPos.y+offsetY+24/zoom, bgRow.w+bgRow.x+170/zoom, 0, tocolor(220, 220, 220, 250), 0.7, font, "center", "top", false, false, true, false, false)
		end
	end
	
end 

function toggleScoreboard(bool)
	if not showScoreboard and (guiGetInputMode() == "no_binds" or guiGetInputMode() == "no_binds_when_editing") then return end 
	
	showScoreboard = bool
	if bool then 
		font = dxCreateFont("archivo_narrow.ttf", 27/zoom) or "default-bold"
		refreshTimer = setTimer(refreshScoreboardData, REFRESH_RATE, 0)
		refreshScoreboardData()
		addEventHandler("onClientRender", root, renderScoreboard)
	else 
		if isElement(font) then 
			destroyElement(font)
		end
		if isTimer(refreshTimer) then 
			killTimer(refreshTimer)
		end
		removeEventHandler("onClientRender", root, renderScoreboard)
	end
end 

function onClientResourceStop()
	if showScoreboard then 
		toggleScoreboard()
	end
end 
addEventHandler("onClientResourceStop", resourceRoot, onClientResourceStop)

function isScoreboardShowing() return showScoreboard end 

addEventHandler("onClientPlayerWeaponSwitch", root, function()
	if showScoreboard then 
		cancelEvent()
	end
end)

function hex2rgb(hex) 
  hex = hex:gsub("#","") 
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
end 