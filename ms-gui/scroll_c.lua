local scrolls = {}
local activeScroll = false
local oldMousePosition = {0, 0}
local lastButtonMove = 0 

MINIMAL_GRIP_SIZE = 25 
SCROLL_BUTTON_SIZE = 20 
SCROLL_BUTTON_MOVE_TIME = 10 -- w milisekundach

function createScroll(x, y, w, h, bgColor, windowSize, contentSize, scrollColor)
	if x and y and w and h and bgColor and windowSize and contentSize then 
		scrollColor = scrollColor or {51, 102, 255, 255}
		local r, g, b = scrollColor[1], scrollColor[2], scrollColor[3] 
		
		table.insert(scrolls, {x=x, y=y, w=w, h=h, r=r, g=g, b=b, bgColor=bgColor, windowSize=windowSize, contentSize=contentSize, gripPosition=y+SCROLL_BUTTON_SIZE, minGripSize=MINIMAL_GRIP_SIZE, maxGripSize=h - SCROLL_BUTTON_SIZE*2 - 5})
		return #scrolls
	end
end

function destroyScroll(scroll)
	if scrolls[scroll] then 
		if scroll == activeScroll then 
			activeScroll = false 
		end 
		
		table.remove(scrolls, scroll)
	end
end 

function getGripSize(contentSize, windowSize, trackSize, minGripSize, maxGripSize)
	if contentSize and windowSize and trackSize then 
		local ratio = windowSize / contentSize
		local gripSize = trackSize * ratio
		gripSize = math.max(minGripSize, gripSize)
		gripSize = math.min(maxGripSize, gripSize)
		return gripSize 
	end
	
	return 0
end 

function getScrollWindowSize(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		return scrollData.windowSize
	end
	
	return 0
end 

function setScrollWindowSize(scroll, size)
	local scrollData = scrolls[scroll]
	if scrollData and size then 
		scrollData.windowSize = size
	end
end 

function getScrollContentSize(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		return scrollData.contentSize
	end
	
	return 0
end 

function setScrollContentSize(scroll, size)
	local scrollData = scrolls[scroll]
	if scrollData and size then 
		scrollData.contentSize = size
	end
end 

function getScrollProgress(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		local grip = getGripSize(scrollData.contentSize, scrollData.windowSize, scrollData.maxGripSize, scrollData.minGripSize, scrollData.maxGripSize)
		local min = scrollData.y+SCROLL_BUTTON_SIZE
		local max = scrollData.gripPosition
		local change = max - min
		local sRatio = change / (scrollData.h-SCROLL_BUTTON_SIZE*2-grip) -- przesunięcie 0-1 scrolla 
		return sRatio
	end
end

function moveScroll(scroll, direction, value)
	local scrollData = scrolls[scroll]
	if scrollData and direction and value then 
		if direction == "up" then
			scrollData.gripPosition = scrollData.gripPosition - value
		elseif direction == "down" then
			scrollData.gripPosition = scrollData.gripPosition + value
		end
		
		local grip = getGripSize(scrollData.contentSize, scrollData.windowSize, scrollData.maxGripSize, scrollData.minGripSize, scrollData.maxGripSize)
		scrollData.gripPosition = math.max(scrollData.gripPosition, scrollData.y+SCROLL_BUTTON_SIZE)
		scrollData.gripPosition = math.min(scrollData.gripPosition, scrollData.y+scrollData.h-grip-SCROLL_BUTTON_SIZE)
	end
end

function resetScroll(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		activeScroll = false 
		
		scrollData.gripPosition = scrollData.y+SCROLL_BUTTON_SIZE
	end
end

local screenW, screenH = guiGetScreenSize()
function renderScroll(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		local now = getTickCount()
		
		-- aktualizacja myszki 
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*screenW, cursorY*screenH
		if oldMousePosition[1] == 0 and oldMousePosition[2] == 0 then 
			oldMousePosition = {cursorX, cursorY}
		end 
		
		dxDrawRectangle(scrollData.x, scrollData.y, scrollData.w, scrollData.h, scrollData.bgColor, true)
		
		local grip = getGripSize(scrollData.contentSize, scrollData.windowSize, scrollData.maxGripSize, scrollData.minGripSize, scrollData.maxGripSize)
		if isCursorOnElement(scrollData.x, scrollData.y, scrollData.w, SCROLL_BUTTON_SIZE) then 
			--dxDrawRectangle(scrollData.x, scrollData.y, scrollData.w, SCROLL_BUTTON_SIZE, tocolor(160, 160, 160, 230), true) -- strzalka do gory 
			dxDrawText("▲", scrollData.x, scrollData.y, scrollData.x+scrollData.w, scrollData.y+SCROLL_BUTTON_SIZE, tocolor(scrollData.r, scrollData.g, scrollData.b, 255), 1, "default", "center", "center", false, false, true)
			
			if getKeyState("mouse1") then 
				if now > lastButtonMove then 
					moveScroll(scroll, "up", grip*0.01)
					lastButtonMove = now+SCROLL_BUTTON_MOVE_TIME
				end
			end
		else 
			--dxDrawRectangle(scrollData.x, scrollData.y, scrollData.w, SCROLL_BUTTON_SIZE, tocolor(130, 130, 130, 230), true) -- strzalka do gory 
			dxDrawText("▲", scrollData.x, scrollData.y, scrollData.x+scrollData.w, scrollData.y+SCROLL_BUTTON_SIZE, tocolor(170, 170, 170, 255), 1, "default", "center", "center", false, false, true)
		end 
		
		if isCursorOnElement(scrollData.x, scrollData.y+scrollData.h-SCROLL_BUTTON_SIZE, scrollData.w, SCROLL_BUTTON_SIZE) then 
			--dxDrawRectangle(scrollData.x, scrollData.y+scrollData.h-SCROLL_BUTTON_SIZE, scrollData.w, SCROLL_BUTTON_SIZE, tocolor(160, 160, 160, 230), true) -- strzalka w dol 
			dxDrawText("▼", scrollData.x, scrollData.y+scrollData.h-SCROLL_BUTTON_SIZE, scrollData.x+scrollData.w, scrollData.y+scrollData.h, tocolor(scrollData.r, scrollData.g, scrollData.b, 255), 1, "default", "center", "center", false, false, true)
			
			if getKeyState("mouse1") then 
				if now > lastButtonMove then 
					moveScroll(scroll, "down", grip*0.01)
					lastButtonMove = now+SCROLL_BUTTON_MOVE_TIME
				end
			end
		else 
			--dxDrawRectangle(scrollData.x, scrollData.y+scrollData.h-SCROLL_BUTTON_SIZE, scrollData.w, SCROLL_BUTTON_SIZE, tocolor(130, 130, 130, 230), true) -- strzalka w dol 
			dxDrawText("▼", scrollData.x, scrollData.y+scrollData.h-SCROLL_BUTTON_SIZE, scrollData.x+scrollData.w, scrollData.y+scrollData.h, tocolor(170, 170, 170, 255), 1, "default", "center", "center", false, false, true)
		end 
		
		if scrollData.windowSize ~= 0 and scrollData.contentSize ~= 0 then 
			if activeScroll == scroll then 
				dxDrawRectangle(scrollData.x, scrollData.gripPosition, scrollData.w, grip, tocolor(scrollData.r*0.6, scrollData.g*0.6, scrollData.b*0.6, 230), true)
			else 
				if isCursorOnElement(scrollData.x, scrollData.gripPosition, scrollData.w, grip) then 
					dxDrawRectangle(scrollData.x, scrollData.gripPosition, scrollData.w, grip, tocolor(scrollData.r*0.8, scrollData.g*0.8, scrollData.b*0.8, 230), true)
				else 
					dxDrawRectangle(scrollData.x, scrollData.gripPosition, scrollData.w, grip, tocolor(scrollData.r, scrollData.g, scrollData.b, 230), true)
				end
			end
		end
		
		if activeScroll == scroll then 
			local delta = cursorY - oldMousePosition[2]
			oldMousePosition = {cursorX, cursorY}
			
			scrollData.gripPosition = scrollData.gripPosition + delta
			scrollData.gripPosition = math.max(scrollData.gripPosition, scrollData.y+SCROLL_BUTTON_SIZE)
			scrollData.gripPosition = math.min(scrollData.gripPosition, scrollData.y+scrollData.h-grip-SCROLL_BUTTON_SIZE)
		end
	end
end

function keyScroll(key, state)
	if key == "mouse1" and state then
		if #scrolls > 0 then 
			for k, v in ipairs(scrolls) do 
				if isCursorOnElement(v.x, v.y+SCROLL_BUTTON_SIZE, v.w, v.h-SCROLL_BUTTON_SIZE*2) then 
					activeScroll = k
					
					local cursorX, cursorY = getCursorPosition()
					cursorX, cursorY = cursorX*screenW, cursorY*screenH
					
					local grip = getGripSize(v.contentSize, v.windowSize, v.maxGripSize, v.minGripSize, v.maxGripSize)
					
					v.gripPosition = cursorY-grip/2
					v.gripPosition = math.max(v.gripPosition, v.y+SCROLL_BUTTON_SIZE)
					v.gripPosition = math.min(v.gripPosition, v.y+v.h-grip-SCROLL_BUTTON_SIZE)
					
					oldMousePosition = {cursorX, cursorY}
				end
			end
		end
	elseif key == "mouse1" and not state then 
		activeScroll = false
		oldMousePosition = {0, 0}
	end
end
addEventHandler("onClientKey", root, keyScroll)