if getPlayerName(localPlayer) ~= "brzysiu" then return end 
local screenW, screenH = guiGetScreenSize()
local zoom = 1
local bgPos = {x=0, y=0, w=0, h=0}
font = false 

local function render()
	local medieval = getElementData(localPlayer, "player:medieval")
	if medieval then 
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(200, 200, 200, 255), true)
		dxDrawRectangle(bgPos.x, bgPos.y+bgPos.h, bgPos.w, 3/zoom, tocolor(100, 100, 100, 255), true)
		dxDrawRectangle(bgPos.x, bgPos.y+bgPos.h, bgPos.w*0.4, 3/zoom, tocolor(51, 102, 255, 255), true)
		dxDrawText("#FFFFFFLevel #3366FF1  #FFFFFF|  EXP: #3366FF20#FFFFFF/100", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+bgPos.h, tocolor(255, 255, 255, 255), 0.7, font, "center", "center", false, false, true, true)
	end
end 

local function onStart()
	setTimer(function()
		zoom = exports["ms-hud"]:getInterfaceZoom()
		local x, y, w, h = exports["ms-hud"]:getInterfacePosition()
		
		bgPos = {x=x, y=y+h+90/zoom, w=w, h=50/zoom}
		
		font = dxCreateFont("archivo_narrow.ttf", 27/zoom, false, "antialiased")
		addEventHandler("onClientRender", root, render)
	end, 3000, 1)
end 
addEventHandler("onClientResourceStart", resourceRoot, onStart)