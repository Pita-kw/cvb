local showing = false 

function showCountdown()
	if showing then return end 
	
	showing = true 
	
	local countdown = 5 
	
	local function render() 
		local screenW, screenH = guiGetScreenSize() 
		local text = tostring(countdown)
		if text == "0" then 
			text = "START!"
		end
		
		dxDrawText(text, (screenW/2)-1, (screenH/3)-1, (screenW/2)-1, (screenH/3)-1, tocolor(0, 0, 0, 255), 3.0, "default-bold", "center", "top", false, true, true)
		dxDrawText(text, screenW/2, screenH/3, screenW/2, screenH/3, tocolor(255, 255, 255, 255), 3.0, "default-bold", "center", "top", false, true, true)
	end 
	addEventHandler("onClientRender", root, render)
	
	setTimer(function()
		countdown = countdown-1 
		if countdown == 0 then 
			playSoundFrontEnd(45)
			setTimer(function()
				removeEventHandler("onClientRender", root, render)
				showing = false
			end, 1000, 1)
		else 
			playSoundFrontEnd(43)
		end
	end, 1000, countdown)
end 
addEvent("onClientShowCountdown", true)
addEventHandler("onClientShowCountdown", root, showCountdown)