local maxDist = 30
local defaultR, defaultG, defaultB = 240, 240, 240
local screenW, screenH = guiGetScreenSize()

local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+150)/screenW)
end 

local font = dxCreateFont("font.ttf", 20, false, "antialiased")

-- interfejs celowania 
local targetBg = {x=screenW-(800/zoom), y=screenH-(600/zoom), w=345/zoom, h=100/zoom}
local targetBgLine = {x=targetBg.x, y=targetBg.y+targetBg.h, w=targetBg.w, h=4/zoom}

function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function updateNametags()
	local players = getElementsByType("player")

	if isPedAiming(localPlayer) then 
		local target = getPedTarget(localPlayer)
		if target and getElementType(target) == "player" and target ~= localPlayer then 
			if not blur then 
				blur = exports["ms-blur"]:createBlurBox(targetBg.x, targetBg.y, targetBg.w, targetBg.h, 255, 255, 255, 255, false)
			end 
			
			dxDrawRectangle(targetBg.x, targetBg.y, targetBg.w, targetBg.h, tocolor(30, 30, 30, 150), true)
			dxDrawRectangle(targetBgLine.x, targetBgLine.y, targetBgLine.w, targetBgLine.h, tocolor(51, 102, 255, 255), true)
			
			-- nick 
			dxDrawImage(targetBg.x + 20/zoom, targetBg.y + 15/zoom, 70/zoom, 70/zoom, exports["ms-avatars"]:loadAvatar(getElementData(target, "player:uid") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
			dxDrawText(getPlayerName(target), targetBg.x + 100/zoom, targetBg.y + 15/zoom, 70/zoom, 70/zoom, tocolor(220, 220, 220, 220), 0.55, font, "left", "top", false, false, true, false, false)
			
			-- hp i armor 
			local hp = getElementHealth(target)/100
			local armor = getPedArmor(target)/100
			
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 45/zoom, 150/zoom, 15/zoom, tocolor(60, 60, 60, 200), true)
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 65/zoom, 150/zoom, 15/zoom, tocolor(60, 60, 60, 200), true)
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 45/zoom, (150/zoom)*hp, 15/zoom, tocolor(231, 76, 60, 200), true)
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 65/zoom, (150/zoom)*armor, 15/zoom, tocolor(149, 165, 166, 200), true)
			
			-- level
			dxDrawImage(targetBg.x+targetBg.w-80/zoom, targetBg.y + 15/zoom, 70/zoom, 70/zoom, "circle.png", 0, 0, 0, tocolor(149, 165, 166, 200), true)
			dxDrawText(tostring(getElementData(target, "player:level") or 1), targetBg.x + 100/zoom, targetBg.y + 35/zoom, targetBg.x+targetBg.w+155/zoom, 70/zoom, tocolor(220, 220, 220, 220), 0.6, font, "center", "top", false, false, true, false, false)
		else 
			if blur then 
				exports["ms-blur"]:destroyBlurBox(blur)
				blur = false 
			end
		end
	else 
		if blur then 
			exports["ms-blur"]:destroyBlurBox(blur)
			blur = false 
		end
	end
end
addEventHandler("onClientRender", root, updateNametags)

setPedTargetingMarkerEnabled(false)