screenW, screenH = guiGetScreenSize()
local sx,sy = (screenW/1366), (screenH/768)

local dxfont0_archivo_narrow = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 16*sx)
local dxfont1_archivo_narrow = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 12*sx)

function isCursorOnElement(x,y,w,h)
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

local inviter = false -- inviter? XDDDD
function showInvitationWindow(whoInvites)
	inviter = getPlayerFromName(whoInvites)
	addEventHandler("onClientRender", root, renderInvitationWindow)
	setElementData(localPlayer, "friends:acceptingInvite", true)
	showCursor(true)
end
addEvent("onClientShowInvitationWindow", true)
addEventHandler("onClientShowInvitationWindow", root, showInvitationWindow)

function renderInvitationWindow()
        if not isElement(inviter) then 
			showCursor(false)
			setElementData(localPlayer, "friends:acceptingInvite", false)
			removeEventHandler("onClientRender", root, renderInvitationWindow)
		end 
		
		dxDrawImage(432*sx, 288*sy, 502*sx, 188*sy, "i/window.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText("Zaproszenie do znajomych", (560 + 1)*sx, (307 + 1)*sy, (808 + 1)*sx, (344 + 1)*sy, tocolor(0, 0, 0, 255), 1.00, dxfont0_archivo_narrow, "left", "top", false, false, false, false, false)
        dxDrawText("Zaproszenie do znajomych", 560*sx, 307*sy, 808*sx, 344*sy, tocolor(28, 117, 226, 255), 1.00, dxfont0_archivo_narrow, "left", "top", false, false, false, false, false)
        dxDrawText("Gracz "..getPlayerName(inviter).." zaprasza cię do znajomych. \nCzy chcesz przyjąć zaproszenie?", 461*sx, 342*sy, 911*sx, 389*sy, tocolor(255, 255, 255, 255), 1.00, dxfont1_archivo_narrow, "center", "top", false, false, false, true, false)
        dxDrawImage(530*sx, 407*sy, 127*sx, 48*sy, "i/button_blue.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(706*sx, 408*sy, 127*sx, 48*sy, "i/button_red.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText("Akceptuj", 561*sx, 421*sy, 624*sx, 441*sy, tocolor(255, 255, 255, 255), 1.00, dxfont1_archivo_narrow, "left", "top", false, false, false, false, false)
        dxDrawText("Anuluj", 746*sx, 421*sy, 809*sx, 441*sy, tocolor(255, 255, 255, 255), 1.00, dxfont1_archivo_narrow, "left", "top", false, false, false, false, false)
		
		if getKeyState("mouse1") then 
			if isCursorOnElement(530*sx, 407*sy, 127*sx, 48*sy) then 
				triggerServerEvent("onPlayerAcceptInvite", localPlayer, getElementData(inviter, "player:uid"))
				showCursor(false)
				setElementData(localPlayer, "friends:acceptingInvite", false)
				removeEventHandler("onClientRender", root, renderInvitationWindow)
			elseif isCursorOnElement(706*sx, 408*sy, 127*sx, 48*sy) then  
				showCursor(false)
				setElementData(localPlayer, "friends:acceptingInvite", false)
				removeEventHandler("onClientRender", root, renderInvitationWindow)
			end
		end
end