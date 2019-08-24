local KEY = "e"

local screenW, screenH = guiGetScreenSize()
local zoom = 1
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-500/zoom/2, y=screenH-220/zoom, w=500/zoom, h=150/zoom}
local blur = nil 

local font = false
local data = {}
local sound2d

function drawEntranceDescription()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h*0.3, tocolor(0, 0, 0, 150), true)
	dxDrawRectangle(bgPos.x, bgPos.y+bgPos.h, bgPos.w, 3/zoom, tocolor(51, 102, 255, 255), true)
	dxDrawText(data[1], bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+bgPos.h*0.3, tocolor(240, 240, 240, 240), 1, font, "center", "center", false, false, true, false, false)
	dxDrawText(data[2], bgPos.x, math.floor(bgPos.y+60/zoom), math.floor(bgPos.x+bgPos.w), math.floor(bgPos.y+bgPos.h*0.7), tocolor(220, 220, 220, 220), 0.8, font, "center", "center", false, true, true, false, false)
	dxDrawText("#E6E6E6By wejść kliknij klawisz #3366FFE#E6E6E6.", bgPos.x, math.floor(bgPos.y+bgPos.h-35/zoom), math.floor(bgPos.x+bgPos.w), 0, tocolor(255, 255, 255, 255), 0.9, font, "center", "top", false, true, true, true, false)
end

function showNewEntranceInfo(nd)
	data = nd
	font = dxCreateFont("archivo_narrow.ttf", math.floor(17/zoom), false, "antialiased") or "default-bold"
	addEventHandler("onClientRender", root, drawEntranceDescription)
end
addEvent("onPlayerGetEntranceInfo", true)
addEventHandler("onPlayerGetEntranceInfo", root, showNewEntranceInfo)

function hideNewEntranceInfo()
	removeEventHandler("onClientRender", root, drawEntranceDescription)
	if isElement(font) then 
		destroyElement(font)
		font = nil
	end
end
addEvent("onPlayerHideEntranceInfo", true)
addEventHandler("onPlayerHideEntranceInfo", root, hideNewEntranceInfo)

function playEntranceMusic(url, x, y, z, distance, effect, volume)
	if url == false and sound2d then destroyElement(sound2d) return end
	if url and #url < 1  then return end

	if distance == -1 then
		sound2d = playSound(url, true, true)
		setSoundVolume(sound2d, volume)
	else
		sound = playSound3D(url, x, y, z, true, true)
		setSoundMaxDistance(sound, distance)
		setSoundVolume(sound, volume)
		setSoundEffectEnabled(sound, "i3dl2reverb", effect)
	end
end
addEvent("onPlayerLoadEntranceMusic", true)
addEventHandler("onPlayerLoadEntranceMusic", root, playEntranceMusic)

function movePlayerToEntrance(key, keyState)
	if keyState == "down" then
		if getElementData(localPlayer, "player:entrance_state") then
			triggerServerEvent("onPlayerMoveToEntrance", localPlayer, getElementData(localPlayer, "player:inEntrance"), getElementData(localPlayer, "player:entrance_state"))
			
			setElementData(localPlayer, "entrance:moving", true)
			setTimer(setElementData, 2000, 1, localPlayer, "entrance:moving", false)
			
			setTimer(function()
				if getElementData(localPlayer, "player:entrance") == "outside" then 
					for i = 0, 4 do
						setInteriorFurnitureEnabled(i, false)
					end
				end 
			end, 1000, 1)
		end
	end
end
bindKey(KEY, "down", movePlayerToEntrance)

fileDelete("entrance_c.lua")
