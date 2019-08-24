local screenW, screenH = guiGetScreenSize()
local drawDist = 15 

function renderNPCInfo()
	local cx, cy, cz = getCameraMatrix()
	
	if getElementData(localPlayer, "player:medieval") then 
		for k, v in ipairs(getElementsByType("ped", resourceRoot)) do 
			if getElementData(v, "npc") then 
				local x, y, z = getElementPosition(v)
				local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
				if dist < drawDist then
					z = z+1.1
					
					local sx, sy = getScreenFromWorldPosition(x, y, z, 0.2)
					if sx and sy then 
						local w, h = screenW*0.05, screenH*0.0075
						exports["ms-gui"]:dxDrawBluredRectangle(sx-w/2, sy, w, h, tocolor(255, 255, 255, 255))
						
						local health = getElementHealth(v)/100
						dxDrawRectangle(sx-w/2, sy, w*health, h, tocolor(231, 76, 60, 200), true, true)
						
						if font then 
							local tx, ty, tw, th = sx, sy-h-35, sx, sy
							for ox=-1,1 do 
								for oy=-1,1 do 
									dxDrawText("LVL 1\nNPC", tx+ox, ty+oy, tw+ox, th+oy, tocolor(0, 0, 0, 255), 0.7, font, "center", "top", false, false, true, true, true)
								end
							end
							
							dxDrawText("#7f8c8dLVL #3366FF1\n#FFFFFFNPC", tx, ty, tw, th, tocolor(255, 255, 255, 255), 0.7, font, "center", "top", false, false, true, true, true)
						end
					end
				end
			end
		end
	end
end 
addEventHandler("onClientRender", root, renderNPCInfo)