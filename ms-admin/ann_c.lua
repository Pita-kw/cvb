local font, fontScale = "default-bold", 1
local showTime, fadeTime = 60000, 1000
local scrollTime = 20
-----------------------------------------------------------------
local showing = false 
local started = 0
local offset, offsetTick = 0, 0
local msg, msgWidth = "", 0
local x, y, w, h = 0, 0, 0, 0
local screenW, screenH = guiGetScreenSize()
local scrollOffset = screenW*0.0009

addEvent("onClientShowRCONAnn", true)
addEventHandler("onClientShowRCONAnn", root, function(text)
	if showing then return end
	
	x = 0
	y = 0
	w = screenW
	h = dxGetFontHeight(fontScale+0.2, font)
	
	msg = text
	msgWidth = dxGetTextWidth(msg, fontScale, font)
	offset = screenW - msgWidth/2
	
	started = getTickCount()
	setTimer(playSound, showTime/3, 2, "http://translate.google.com/translate_tts?tl=pl&q="..tostring(text).."&client=tw-ob")
	setSoundVolume(playSound("alert.mp3"), 1)
	
	showing = true
end)


local function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,postGUI, alpha) 
    for oX = -1, 1 do -- Border size is 1 
        for oY = -1, 1 do -- Border size is 1 
                dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak,postGUI) 
        end 
    end 
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI) 
end 

addEventHandler("onClientRender", root, function()
	if showing then 
		local now = getTickCount()
		
		if now > offsetTick then 
			offset = offset-scrollOffset
			offsetTick = offsetTick+scrollTime
			
			if x+offset < -msgWidth then 
				offset = screenW
			end
		end 
		
		local alpha = 0
		if now < started+showTime then 
			local progress = (now-started) / fadeTime 
			alpha = interpolateBetween(0, 0, 0, 255, 0, 0, math.min(1, progress), "InQuad")
		else 
			local progress = (now-started-showTime) / fadeTime 
			alpha = interpolateBetween(255, 0, 0, 0, 0, 0, math.min(1, progress), "InQuad")
			if progress >= 1 then 
				showing = false
			end
		end 
		
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(255, 255, 255, alpha))
		dxDrawBorderedText(msg, math.floor(x+offset), y, x+w, y+h, tocolor(231, 76, 60, alpha), 1, "default-bold", "left", "center", false, false, true, alpha)
	end 
end)

addEvent("onClientGetTextToSpeech", true)
addEventHandler("onClientGetTextToSpeech", root, function(text)
	playSound("http://translate.google.com/translate_tts?tl=pl&q="..tostring(text).."&client=tw-ob")
end)