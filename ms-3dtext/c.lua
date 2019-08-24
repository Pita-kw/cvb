--[[
Autorzy kodu:
	- Jurandovsky
	- Brzysiek

Zasób odpowiadający za 3d texty.

Dziękujemy za mile spędzony z Wami czas, zapraszamy ponownie do skorzystania z naszych linii lotniczych.
--]]

MAX_DRAW_DISTANCE = 30
FONT = dxCreateFont("BebasNeue.otf", 25)

function dxDrawBorderedText(text, left, top, right, bottom, r, g, b, a, scale, font, alignX, alignY, clip, wordBreak,postGUI) 
	for oX = -1, 1 do
		for oY = -1, 1 do
			dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, a), scale, font, alignX, alignY, clip, wordBreak,postGUI) 
		end 
     end 
	 
    dxDrawText(text, left, top, right, bottom, tocolor(r, g, b, a), scale, font, alignX, alignY, clip, wordBreak, postGUI, true) 
end 

local texts = {} 
function refreshNearbyTexts() 
	texts = {} 
	
	local cx, cy, cz = getCameraMatrix()
	for k,v in ipairs(getElementsByType("3dtext")) do 
		local x, y, z = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
		local drawDistance = getElementData(v, "dd") or MAX_DRAW_DISTANCE 
		
		if dist < drawDistance then 
			table.insert(texts, v)
		end
	end
end 
setTimer(refreshNearbyTexts, 250, 0)

local mathMin = math.min 
local mathMax = math.max
function render3DText()
	local cx, cy, cz = getCameraMatrix()
	
	for k,v in ipairs(texts) do 
		if isElement(v) and getElementDimension(localPlayer) == getElementDimension(v) then 
			local x, y, z = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
			
			local drawDistance = getElementData(v, "dd") or MAX_DRAW_DISTANCE 
			local fadeDistance = drawDistance*0.6 
			
			if dist < drawDistance then 
				if isLineOfSightClear(cx, cy, cz, x, y, z, true, true, false, true, true, true) then 
					local sx, sy = getScreenFromWorldPosition(x, y, z, 0.1)
					if sx and sy then 
						local text = getElementData(v, "text") or "" 
						local alpha = mathMin( mathMax(0, (255 * ( (fadeDistance - dist) /  fadeDistance))+200), 255)
						if alpha > 0 then 
							if getElementData(v, "border_disable") then
								dxDrawText(text, sx, sy, sx, sy, tocolor(230, 230, 230, alpha), (getElementData(v, "font") or 0.45) * ( (drawDistance - dist) / drawDistance ), FONT, "center", "center", false, false, false, true)
							else 
								dxDrawBorderedText(text, sx, sy, sx, sy, 230, 230, 230, alpha, (getElementData(v, "font") or 0.45) * ( (drawDistance - dist) / drawDistance ), FONT, "center", "center", false, false, false)
							end
						end
					end
				end
			end
		end
	end
	
end 
addEventHandler("onClientRender", root, render3DText)