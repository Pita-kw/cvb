function getObjectMatrix(element)
    local rx, ry, rz = getElementRotation(element, "ZXY")
    rx, ry, rz = 0, 0, 0
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1
 
    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1
 
    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1
 
    matrix[4] = {}
    matrix[4][1], matrix[4][2], matrix[4][3] = getElementPosition(element)
    matrix[4][4] = 1
 
    return matrix
end

function getPositionFromElementAtOffset(element,x,y,z)
   if not x or not y or not z then
      return false
   end
		local ox,oy,oz = getElementPosition(element)
        local matrix = getObjectMatrix ( element )
		if not matrix then return ox+x,oy+y,oz+z end
        local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
        local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
        local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
        return offX, offY, offZ
end

function drawLine(vecOrigin, vecTarget,color,thickness)
	local startX,startY = getScreenFromWorldPosition(vecOrigin[1],vecOrigin[2],vecOrigin[3],10)
	if (not vecTarget[1]) then return false end
	local endX,endY = getScreenFromWorldPosition(vecTarget[1],vecTarget[2],vecTarget[3],10)
	if not startX or not startY or not endX or not endY then 
		return false
	end
	
	return dxDrawLine ( startX,startY,endX,endY,color,thickness, false)
end

function isCursorInArea( cursorX, cursorY, minX, minY, maxX, maxY )
	if cursorX < minX or cursorX > maxX or
		cursorY < minY or cursorY > maxY
	then
		return false
	end
	return true
end

local screenW, screenH = guiGetScreenSize()
class "CObjectEditor"
{
	__init__ = function(self, object, x, y, z, int, dim, isFurniture)
		self.object = createObject(object, x, y, z)
		if not self.object then 
			outputChatBox("* Podałeś złe ID obiektu.", 255, 0, 0)
			return
		end 
		
		if int then 
			setElementInterior(self.object, int)
		end
		
		if dim then 
			setElementDimension(self.object, dim)
		end
		
		setElementCollisionsEnabled(self.object, false)
		
		self.isFurniture = isFurniture
		setElementData(localPlayer, "player:inEditor", true)
		
		self.renderFunc = function() self:render() end 
		addEventHandler("onClientRender", root, self.renderFunc)
		
		self.positionChange = false 
		self.positionBtnAlpha = 155 
		self.positionXBtnAlpha = 155 
		self.positionYBtnAlpha = 155 
		self.positionZBtnAlpha = 155 
		self.positionXChange = false
		self.positionYChange = false 
		self.positionZChange = false 
		
		self.rotationChange = false 
		self.rotationBtnAlpha = 155 
		self.rotationXBtnAlpha = 155 
		self.rotationYBtnAlpha = 155 
		self.rotationZBtnAlpha = 155 
		self.rotationXChange = false
		self.rotationYChange = false 
		self.rotationZChange = false 
		
		self.attachBtnAlpha = 155 
		self.attached = false 
		
		self.showedHelp = false 
		
		self.lastClick = 0 
		
		self.saveBtnAlpha = 155 
		
		self.closeBtnAlpha = 155 
		
		self.clickFunc = function(button, state) 
			if button == "left" then 
				self:checkClicks(state)
			end
		end 
		
		self.keyFunc = function(key, state) 
			if key == "mouse2" and state then 
			showCursor(not isCursorShowing())
				if isCursorShowing() == false then 
					self.positionXChange = false
					self.positionYChange = false 
					self.positionZChange = false 
					self.rotationXChange = false
					self.rotationYChange = false 
					self.rotationZChange = false 
				end
			end 
		end
		
		addEventHandler("onClientKey", root, self.keyFunc)
		addEventHandler("onClientClick", root, self.clickFunc)
		
		self.previousMoveX = 0
		self.previousMoveY = 0 
		self.moveFunc = function(a, b, c, d, e, f, g) self:checkMoves(a, b, c, d, e, f, g) end
		addEventHandler("onClientCursorMove", root, self.moveFunc)
		
		triggerEvent("onClientAddNotification", localPlayer, "Obsługę edytora wyświetlono w konsoli F8", "info")
		outputConsole(" ")
		outputConsole(" ")
		outputConsole("Prawy przycisk myszy - wyłączanie/włączanie kursora")
		outputConsole("Jeśli włączysz tryb zmiany rotacji/pozycji, by z niego wyjść kliknij na dowolne miejsce poza przyciskami.")
		outputConsole("Opcja Przyczep przyczepia obiekt do ciebie, dzięki czemu obiekt porusza się razem z tobą.")
		outputConsole("Opcja Zapisz zapisze twój edytowany obiekt.")
		outputConsole("Opcja Zamknij wyłącza edytor i niweluje zmiany.")
		outputConsole("Staraj trzymać się blisko obiektu by zmaksymalizować dokładność.")
		outputConsole(" ")
		outputConsole(" ")
	end,
	
	checkMoves = function(self, cursorX, cursorY, absoluteX, absoluteY, worldX, worldY, worldZ)	
		if self.positionXChange then 
			local px, py, pz = getElementPosition(localPlayer)
			local x, y, z = getElementPosition(self.object)
			local x, _, _ = getWorldFromScreenPosition ( absoluteX, absoluteY, 4.5)
			setElementPosition(self.object, x, y, z)
		end
		
		if self.positionYChange then 
			local _, y, _ = getWorldFromScreenPosition ( absoluteX, absoluteY, 4.5)
			local x, _, z = getElementPosition(self.object)
			setElementPosition(self.object, x, y, z)
		end
		
		if self.positionZChange then 
			local _, _, z = getWorldFromScreenPosition ( absoluteX, absoluteY, 4.5)
			local x, y, _ = getElementPosition(self.object)
			setElementPosition(self.object, x, y, z)
		end
		
		if self.rotationXChange then 
			local rx, ry, rz = getElementRotation(self.object)
			if absoluteX > self.previousMoveX then 
				setElementRotation(self.object, rx+3, ry, rz)
			else
				setElementRotation(self.object, rx-3, ry, rz)
			end
			
			self.previousMoveX, self.previousMoveY = absoluteX, absoluteY
		end
		
		if self.rotationYChange then 
			local rx, ry, rz = getElementRotation(self.object)
			if absoluteY > self.previousMoveY then 
				setElementRotation(self.object, rx, ry+3, rz)
			else
				setElementRotation(self.object, rx, ry-3, rz)
			end
			
			self.previousMoveX, self.previousMoveY = absoluteX, absoluteY
		end
		
		if self.rotationZChange then 
			local rx, ry, rz = getElementRotation(self.object)
			if absoluteX > self.previousMoveX then 
				setElementRotation(self.object, rx, ry, rz-3)
			else
				setElementRotation(self.object, rx, ry, rz+3)
			end
			
			self.previousMoveX, self.previousMoveY = absoluteX, absoluteY
		end
	end,
	
	checkClicks = function(self, state)
		local now = getTickCount() 
		
		if state == "down" and self.positionBtnAlpha == 255 and not self.rotationChange and now >= self.lastClick then
			self.positionChange = true 
			self.lastClick = now+100
			if not self.showedHelp then triggerEvent("onClientAddNotification", localPlayer, "Do kontroli możesz również użyć strzałek na klawiaturze.", "info") self.showedHelp = true end 
		else 
			if state == "down" then 
				if self.positionXBtnAlpha == 155 and self.positionYBtnAlpha == 155 and self.positionZBtnAlpha == 155 then 
					if self.positionChange then self.lastClick = now+100 end 
					self.positionChange = false 
				end
			end
		end
		if self.positionXBtnAlpha == 255 and state == "down" then self.positionXChange = true else self.positionXChange = false end
		if self.positionYBtnAlpha == 255 and state == "down" then self.positionYChange = true else self.positionYChange = false end
		if self.positionZBtnAlpha == 255 and state == "down" then self.positionZChange = true else self.positionZChange = false end
		
		if (state == "down" and self.rotationBtnAlpha == 255 and not self.positionChange and not self.rotationChange and now >= self.lastClick) then
			self.lastClick = now+100
			self.rotationChange = true 
		else 
			if state == "down" then 
				if self.rotationXBtnAlpha == 155 and self.rotationYBtnAlpha == 155 and self.rotationZBtnAlpha == 155 then 
					self.rotationChange = false 
					self.lastClick = now+100
				end
			end
		end
		if self.rotationXBtnAlpha == 255 and state == "down" then self.rotationXChange = true else self.rotationXChange = false end
		if self.rotationYBtnAlpha == 255 and state == "down" then self.rotationYChange = true else self.rotationYChange = false end
		if self.rotationZBtnAlpha == 255 and state == "down" then self.rotationZChange = true else self.rotationZChange = false end
		
		if state == "down" and self.attachBtnAlpha == 255 and not self.rotationChange and not self.positionChange then 
			if self.attached then 
				detachElements(self.object, localPlayer)
				self.attached = false
				triggerEvent("onClientAddNotification", localPlayer, "Odczepiłeś obiekt od siebie.", "info")
			else
				local rx, ry, rz = getElementRotation(self.object)
				attachElements(self.object, localPlayer, 0.6, 0.1, 0, rx, ry, rz)
				self.attached = true 
				triggerEvent("onClientAddNotification", localPlayer, "Przyczepiłeś obiekt do siebie.", "info")
			end	
		end
		
		if state == "down" and self.closeBtnAlpha == 255 and not self.rotationChange and not self.positionChange then 
			self:delete()
		end
		
		if state == "down" and self.saveBtnAlpha == 255 and not self.rotationChange and not self.positionChange then 
			self:save()
		end
		
		if self.positionXChange or self.positionYChange or self.positionZChange then 
			local ox, oy, oz  = getElementPosition(self.object)
			local x,y = getScreenFromWorldPosition(ox, oy, oz)
			if x and y then setCursorPosition(x, y) end
		end
	end,
	
	render = function(self)
		if not self.object then return end 
		if self.isFurniture and not getElementData(localPlayer, "player:houseOwner") then self:delete() return end 
		
		if getElementDimension(self.object) ~= getElementDimension(localPlayer) then return end
		local radius = 2
		local x,y,z = getElementPosition(self.object)
		local xx,xy,xz = getPositionFromElementAtOffset(self.object,radius,0,0)
		local yx,yy,yz = getPositionFromElementAtOffset(self.object,0,radius,0)
		local zx,zy,zz = getPositionFromElementAtOffset(self.object,0,0,radius)
		
		-- linie xyz
		drawLine({x,y,z},{xx,xy,xz},tocolor(200,0,0,200), 2)
		drawLine({x,y,z},{yx,yy,yz},tocolor(0,200,0,200), 2)
		drawLine({x,y,z},{zx,zy,zz},tocolor(0,0,200,200), 2)
		
		if not isCursorShowing() then return end 
		
		local cursorX, cursorY, worldX, worldY, worldZ = getCursorPosition() 
		cursorX = cursorX*screenW 
		cursorY = cursorY*screenH
		
		-- buttony
		local sX, sY = getScreenFromWorldPosition(x, y, z)
		if sX and sY then 
			if isCursorInArea(cursorX, cursorY, sX, sY, sX+48, sY+64) then self.positionBtnAlpha = 255 else	self.positionBtnAlpha = 155 end
			if not self.positionChange then 
				if not self.rotationChange then 
					dxDrawImage(sX, sY, 48, 64, "img/position.png", 0, 0, 0, tocolor(255, 255, 255, self.positionBtnAlpha), false)
					dxDrawText(" Pozycja", sX, sY + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.positionBtnAlpha), 1, "default-bold")
					self.positionXBtnAlpha = 155 
					self.positionYBtnAlpha = 155 
					self.positionZBtnAlpha = 155 
				end
			else
				if getKeyState("arrow_l") then 
					local x,y,z = getPositionFromElementAtOffset(self.object, 0,0.025,0)
					setElementPosition(self.object, x,y,z)
				elseif getKeyState("arrow_u") then
					local x,y,z = getPositionFromElementAtOffset(self.object,0.025,0,0)
					setElementPosition(self.object, x,y,z)
				elseif getKeyState("arrow_r") then 
					local x,y,z = getPositionFromElementAtOffset(self.object, 0,-0.025,0)
					setElementPosition(self.object, x,y,z)
				elseif getKeyState("arrow_d") then 
					local x,y,z = getPositionFromElementAtOffset(self.object, -0.025, 0,0)
					setElementPosition(self.object, x,y,z)
				end 
				
				self.rotationXBtnAlpha = 155 
				self.rotationYBtnAlpha = 155 
				self.rotationZBtnAlpha = 155 
				self.attachBtnAlpha = 155 
				self.saveBtnAlpha = 155 
				self.closeBtnAlpha = 155 
				
				local sX_x, sX_y = getScreenFromWorldPosition(xx, xy, xz)
				local sY_x, sY_y = getScreenFromWorldPosition(yx, yy, yz)
				local sZ_x, sZ_y = getScreenFromWorldPosition(zx, zy, zz)
				if sX_x then if isCursorInArea(cursorX, cursorY, sX_x, sX_y, sX_x+48, sX_y+64) then self.positionXBtnAlpha = 255 else	self.positionXBtnAlpha = 155 end end 
				if sY_x then if isCursorInArea(cursorX, cursorY, sY_x, sY_y, sY_x+48, sY_y+64) then self.positionYBtnAlpha = 255 else	self.positionYBtnAlpha = 155 end end 
				if sZ_x then if isCursorInArea(cursorX, cursorY, sZ_x, sZ_y, sZ_x+48, sZ_y+64) then self.positionZBtnAlpha = 255 else	self.positionZBtnAlpha = 155 end end 
				
				if sX_x then 
					dxDrawImage(sX_x, sX_y, 48, 64, "img/position.png", 0, 0, 0, tocolor(255, 255, 255, self.positionXBtnAlpha), false)
					dxDrawText("Pozycja X", sX_x, sX_y + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.positionXBtnAlpha), 1, "default-bold")
				end
				
				if sY_x then 
					dxDrawImage(sY_x, sY_y, 48, 64, "img/position.png", 0, 0, 0, tocolor(255, 255, 255, self.positionYBtnAlpha), false)
					dxDrawText("Pozycja Y", sY_x, sY_y + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.positionYBtnAlpha), 1, "default-bold")
				end
				
				if sZ_x then 
					dxDrawImage(sZ_x, sZ_y, 48, 64, "img/position.png", 0, 0, 0, tocolor(255, 255, 255, self.positionZBtnAlpha), false)
					dxDrawText("Pozycja Z", sZ_x, sZ_y + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.positionZBtnAlpha), 1, "default-bold")
				end 
			end
			
			if not self.rotationChange and not self.positionChange then 
				if isCursorInArea(cursorX, cursorY, sX + screenW*0.208, sY, sX + screenW*0.21 +64, sY+64) then self.closeBtnAlpha = 255 else	self.closeBtnAlpha = 155 end
				dxDrawImage(sX + screenW*0.208, sY, 64, 64, "img/close.png", 0, 0, 0, tocolor(255, 255, 255, self.closeBtnAlpha), false)
				dxDrawText(" Zamknij", sX + screenW*0.211, sY + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.closeBtnAlpha), 1, "default-bold")
				
				if isCursorInArea(cursorX, cursorY, sX + screenW*0.152, sY, sX + screenW*0.152 +64, sY+64) then self.saveBtnAlpha = 255 else	self.saveBtnAlpha = 155 end
				dxDrawImage(sX + screenW*0.152, sY, 64, 64, "img/save.png", 0, 0, 0, tocolor(255, 255, 255, self.saveBtnAlpha), false)
				dxDrawText(" Zapisz", sX + screenW*0.16, sY + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.saveBtnAlpha), 1, "default-bold")
			
				if isCursorInArea(cursorX, cursorY, sX + screenW*0.1, sY, sX + screenW*0.1 +64, sY+64) then self.attachBtnAlpha = 255 else	self.attachBtnAlpha = 155 end
				dxDrawImage(sX + screenW*0.1, sY, 64, 64, "img/attach.png", 0, 0, 0, tocolor(255, 255, 255, self.attachBtnAlpha), false)
				if self.attached then 
					dxDrawText(" Odczep", sX + screenW*0.1025, sY + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.attachBtnAlpha), 1, "default-bold")
				else
					dxDrawText(" Przyczep", sX + screenW*0.1025, sY + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.attachBtnAlpha), 1, "default-bold")
				end
			end
			
			if isCursorInArea(cursorX, cursorY, sX + screenW*0.045, sY, sX + screenW*0.045 +64, sY+64) then self.rotationBtnAlpha = 255 else	self.rotationBtnAlpha = 155 end
			if not self.rotationChange then 
				if not self.positionChange  then 
					dxDrawImage(sX + screenW*0.045, sY, 64, 64, "img/rotation.png", 0, 0, 0, tocolor(255, 255, 255, self.rotationBtnAlpha), false)
					dxDrawText(" Rotacja", sX + screenW*0.05, sY + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.rotationBtnAlpha), 1, "default-bold")
					self.rotationXBtnAlpha = 155 
					self.rotationYBtnAlpha = 155 
					self.rotationZBtnAlpha = 155 
				end
			else
				self.positionXBtnAlpha = 155 
				self.positionYBtnAlpha = 155 
				self.positionZBtnAlpha = 155 
				self.attachBtnAlpha = 155 
				self.saveBtnAlpha = 155
				self.closeBtnAlpha = 155 
				
				local sX_x, sX_y = getScreenFromWorldPosition(xx, xy, xz)
				local sY_x, sY_y = getScreenFromWorldPosition(yx, yy, yz)
				local sZ_x, sZ_y = getScreenFromWorldPosition(zx, zy, zz)
				if sX_x then if isCursorInArea(cursorX, cursorY, sX_x, sX_y, sX_x+64, sX_y+64) then self.rotationYBtnAlpha = 255 else	self.rotationYBtnAlpha = 155 end end 
				if sY_x then if isCursorInArea(cursorX, cursorY, sY_x, sY_y, sY_x+64, sY_y+64) then self.rotationXBtnAlpha = 255 else	self.rotationXBtnAlpha = 155 end end 
				if sZ_x then if isCursorInArea(cursorX, cursorY, sZ_x, sZ_y, sZ_x+64, sZ_y+64) then self.rotationZBtnAlpha = 255 else	self.rotationZBtnAlpha = 155 end end 
				
				if sX_x then 
					dxDrawImage(sX_x, sX_y, 64, 64, "img/rotation.png", 0, 0, 0, tocolor(255, 255, 255, self.rotationYBtnAlpha), false)
					dxDrawText("Rotacja Y", sX_x, sX_y + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.rotationYBtnAlpha), 1, "default-bold")
				end
				
				if sY_x then 
					dxDrawImage(sY_x, sY_y, 64, 64, "img/rotation.png", 0, 0, 0, tocolor(255, 255, 255, self.rotationXBtnAlpha), false)
					dxDrawText("Rotacja X", sY_x, sY_y + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.rotationXBtnAlpha), 1, "default-bold")
				end
				
				if sZ_x then 
					dxDrawImage(sZ_x, sZ_y, 64, 64, "img/rotation.png", 0, 0, 0, tocolor(255, 255, 255, self.rotationZBtnAlpha), false)
					dxDrawText("Rotacja Z", sZ_x, sZ_y + screenH*0.09, 48, 64, tocolor(255, 255, 255, self.rotationZBtnAlpha), 1, "default-bold")
				end
			end
		end
	end,
	
	save = function(self)
		if self.attached then 
			triggerEvent("onClientAddNotification", localPlayer, "Najpierw odczep od siebie obiekt!", "error")
			return
		end
		
		local model = getElementModel(self.object)
		local x,y,z = getElementPosition(self.object)
		local rx,ry,rz = getElementRotation(self.object)
		local int = getElementInterior(self.object)
		local dim = getElementDimension(self.object)
		
		triggerServerEvent("onEditorCreateObject", localPlayer, model, x, y, z, rx, ry, rz, int, dim, self.isFurniture)
		self:delete()
	end,
	
	delete = function(self)
		removeEventHandler("onClientRender", root, self.renderFunc)
		removeEventHandler("onClientKey", root, self.keyFunc)
		removeEventHandler("onClientClick", root, self.clickFunc)
		removeEventHandler("onClientCursorMove", root, self.moveFunc)
		
		setElementData(localPlayer, "player:inEditor", false)
		setElementData(localPlayer, "player:selectingObject", false)
		showCursor(false)
		destroyElement(self.object)
	end,
	
}

function oc(cmd, objectID)
	if getElementData(localPlayer, "player:rank") == 3 then 
		if objectID then 
			local x,y,z = getPositionFromElementAtOffset(localPlayer, 1, 0, 0)
			local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
			CObjectEditor(objectID, x, y, z, int, dim)
			outputChatBox("* Prawym przyciskiem myszy kontrolujesz kursor", 0, 255, 0)
		else
			outputChatBox("* /oc [objectID]", 0, 255, 0)
		end
	end
end
addCommandHandler("oc", oc)

function onPlayerShowObjectEditor(object, isFurniture)
	local x,y,z = getPositionFromElementAtOffset(localPlayer, 1, 0, 0)
	local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
	CObjectEditor(object, x, y, z, int, dim, isFurniture)
end 
addEvent("onPlayerShowObjectEditor", true)
addEventHandler("onPlayerShowObjectEditor", root, onPlayerShowObjectEditor)

function onSelectNewObject(player, b, object) 
	showCursor(b)
	
	if object then 
		local x,y,z = getElementPosition(player)
		CObjectEditor(object, x, y, z)
	end
end
addEvent("onPlayerSelectNewObject", true)
addEventHandler("onPlayerSelectNewObject", root, onSelectNewObject)

addEventHandler("onClientObjectBreak", root, function() 
	if getElementModel(source) == 2991 then 
		cancelEvent()
	end
end)

setElementData(localPlayer, "player:inEditor", false)