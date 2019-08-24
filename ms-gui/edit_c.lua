local BACKSPACE_DELAY = 70
local ARROW_DELAY = 90

local editboxes = {}
local backspaceTick = 0  
local arrowTick = 0
local activeEditBox = false 

function createEditBox(text, x, y, w, h, color, font, fontHeight)
	if text and x and y and w and h and color and font and fontHeight then 
		local editboxID = #editboxes+1 
		editboxes[editboxID] = {text=text, x=x, y=y, w=w, h=h, color=color, font=font, fontHeight=fontHeight, carretPos=1, helperText=false, maxLength=35, masked=false, ascii=true}
		return editboxID
	end 
	
	return false 
end 

function getEditBoxText(editboxID)
	local edit = editboxes[editboxID] 
	if edit then 
		return edit.text
	end 
	
	return "false"
end 

function isEditBoxActive(editboxID)
	return editboxID == activeEditBox
end 

function setEditBoxMasked(editboxID, bool)
	if editboxes[editboxID] and type(bool) == "boolean" then 
		editboxes[editboxID].masked = bool
		return true 
	end 
	
	return false
end 

function setEditBoxMaxLength(editboxID, length) 
	if editboxes[editboxID] and length then 
		editboxes[editboxID].maxLength = length
		return true 
	end 
	
	return false 
end 

function setEditBoxHelperText(editboxID, text)
	if editboxes[editboxID] and text then 
		editboxes[editboxID].helperText = text
		return true 
	end 
	
	return false
end 

function setEditBoxColor(editboxID, color)
	if editboxes[editboxID] and color then 
		editboxes[editboxID].color = color 
		return true 
	end 
	
	return false 
end 

function setEditBoxASCIIMode(editboxID, bool)
	if editboxes[editboxID] then 
		editboxes[editboxID].ascii = bool
		return true
	end
	
	return false
end 

function destroyEditBox(editboxID) 
	local edit = editboxes[editboxID]
	if edit then 
		editboxes[editboxID] = nil
		if activeEditBox == editboxID then activeEditBox = false end 
		return true 
	end
	
	return false 
end 


function changeEditBox(key, press) -- tabulator
	if key == "tab" and press then 
		if activeEditBox then
			activeEditBox = activeEditBox+1
			if activeEditBox > #editboxes then 
				activeEditBox = 1 
			end
		end
	end
end  
addEventHandler("onClientKey", root, changeEditBox)

function moveCarret(direction)
	if activeEditBox then 
		if direction == "left" then 
			editboxes[activeEditBox].carretPos = math.max(0, editboxes[activeEditBox].carretPos-1)
		elseif direction == "right" then 
			editboxes[activeEditBox].carretPos = math.min(editboxes[activeEditBox].carretPos+1, #editboxes[activeEditBox].text)
		end
	end
end 

function renderEditBox(editboxID)
	local editboxData = editboxes[editboxID]
	if editboxData then 
		if isElement(editboxData.font) then 
			local text = editboxData.text
		

			local carretText = utf8.sub(text, 1, editboxData.carretPos)
			local textWidth = dxGetTextWidth(carretText, editboxData.fontHeight, editboxData.font)
			--[[
			if textWidth > editboxData.w then 
				if not editboxData.maxViewLength then 
					editboxData.maxViewLength = #text-5
					editboxes[editboxID].maxViewLength = editboxData.maxViewLength
				end 
					
				local cuttedString = utf8.sub(text, #text-editboxData.maxViewLength)
				cuttedString = utf8.sub(cuttedString, 1, editboxData.carretPos)
				textWidth = dxGetTextWidth(cuttedString, editboxData.fontHeight, editboxData.font)
				
				text = cuttedString
			end
			--]]
			
			if editboxData.helperText and activeEditBox ~= editboxID and #editboxData.text == 0 then 
				text = editboxData.helperText
				dxDrawText(text, editboxData.x, editboxData.y, editboxData.x+editboxData.w, editboxData.y+editboxData.h, tocolor(160, 160, 160, 160), editboxData.fontHeight, editboxData.font, "left", "center", true, false, true)				
			elseif editboxData.masked then 
				text = utf8.gsub(editboxData.text, ".", "*")
				dxDrawText(text, editboxData.x, editboxData.y, editboxData.x+editboxData.w, editboxData.y+editboxData.h, editboxData.color, editboxData.fontHeight, editboxData.font, "left", "center", true, false, true)
				
				carretText = utf8.sub(text, 1, editboxData.carretPos)
				textWidth = dxGetTextWidth(carretText, editboxData.fontHeight, editboxData.font)
			else 
				dxDrawText(text, editboxData.x, editboxData.y, editboxData.x+editboxData.w, editboxData.y+editboxData.h, editboxData.color, editboxData.fontHeight, editboxData.font, "left", "center", true, false, true)
			end 
			
			if activeEditBox == editboxID then 
				-- backspace 
				if getKeyState("backspace") then 
					local now = getTickCount()
					if now > backspaceTick then 
						editboxData.text = utf8.sub(editboxData.text, 1, math.max(0, editboxData.carretPos-1))..utf8.sub(editboxData.text, editboxData.carretPos+1)
						editboxData.carretPos = math.max(0, editboxData.carretPos-1)
						backspaceTick = now+BACKSPACE_DELAY 
					end 
				elseif getKeyState("arrow_l") then 
					local now = getTickCount()
					if now > arrowTick then 
						moveCarret("left")
						arrowTick = now+ARROW_DELAY
					end
				elseif getKeyState("arrow_r") then 
					local now = getTickCount() 
					if now > arrowTick then 
						moveCarret("right")
						arrowTick = now+ARROW_DELAY
					end
				end
				
				-- kursor 
				local cursorW, cursorH = 1, editboxData.h-math.floor(editboxData.h*0.2)  
				local cursorX, cursorY = editboxData.x+textWidth+1, editboxData.y+math.floor(editboxData.h*0.1)
				dxDrawRectangle(cursorX, cursorY, cursorW, cursorH, tocolor(51, 102, 255, 200), true)
			end
		end 
	end 
end 

function onEditBoxClick(button, state, x, y)
	if button == "left" and state == "down" then 
		activeEditBox = false 
		for editboxID, editboxData in pairs(editboxes) do
			if isCursorOnElement(editboxData.x, editboxData.y, editboxData.w, editboxData.h) then 
				activeEditBox = editboxID
				editboxData.carretPos = #editboxData.text
			end 
		end 
	end
end
addEventHandler("onClientClick", root, onEditBoxClick)

function onEditBoxType(character)
	if activeEditBox and #editboxes[activeEditBox].text < editboxes[activeEditBox].maxLength then
		local check = true 
		if editboxes[activeEditBox].ascii then 
			check = isStringValid(character)
		end 
		
		if check then 
			editboxes[activeEditBox].text = utf8.sub(editboxes[activeEditBox].text, 1, editboxes[activeEditBox].carretPos)..character..utf8.sub(editboxes[activeEditBox].text, editboxes[activeEditBox].carretPos+1)
			editboxes[activeEditBox].carretPos = editboxes[activeEditBox].carretPos+1
		end
	end 
end 
addEventHandler("onClientCharacter", root, onEditBoxType)

function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function isStringValid(string)
   local length = string:len()
   for i=1,length do
          if string:byte(i) > 126 or string:byte(i) < 33 then return false end
   end
   return true
end