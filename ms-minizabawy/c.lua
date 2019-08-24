--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: c.lua
	@desc: minieventy 
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]



local pos = 0
local type_text = false
local event_text = false
local text_style = false
local sound = false

local screenW, screenH = guiGetScreenSize() 
local zoom = 1.0

local baseX = 2300
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

function drawMiniEventHUD()
		local now = getTickCount()
		exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(170, 170, 170, 255))
		
		
		if text_style == "quiz" then
			dxDrawBorderedText (type_text, bgPos2.x+20/zoom, bgPos2.y+10/zoom, bgPos2.w, bgPos2.y+bgPos2.h, tocolor ( 52, 152, 219, 255 ), 1, font, "left", "top", false, true, true)
			dxDrawBorderedText (event_text, bgPos2.x+20/zoom, bgPos2.y+40/zoom, bgPos2.x+bgPos2.w, bgPos2.y+bgPos2.h, tocolor ( 255, 255, 255, 255 ), 1, font, "left", "top", false, true, true)
			dxDrawText(math.floor(math.ceil((event_time-now)/1000)) , bgPos.x+bgPos.w*0.8, bgPos.y-140/zoom,  AtX+bgPos.w*0.2, AtY+bgPos.h, tocolor(52, 152, 219, 255), 1, font2, "left", "center", false, false, true, true)
		end
		
		if text_style == "bad_answer" then
			dxDrawBorderedText (type_text, bgPos2.x+20/zoom, bgPos2.y+10/zoom, bgPos2.w, bgPos2.y+bgPos2.h, tocolor ( 255, 0, 0, 255 ), 1, font, "left", "top", false, true, true)
			dxDrawBorderedText (event_text, bgPos2.x+20/zoom, bgPos2.y+40/zoom, bgPos2.x+bgPos2.w, bgPos2.y+bgPos2.h, tocolor ( 255, 255, 255, 255 ), 1, font, "left", "top", false, true, true)		
		end
		
		if text_style == "good_answer" then
			dxDrawBorderedText (type_text, bgPos.x+135/zoom, bgPos.y+10/zoom, bgPos.w, bgPos.y+bgPos.h, tocolor ( 0, 255, 0, 255 ), 1, font, "left", "top", false, true, true)
			dxDrawBorderedText (event_text, bgPos.x+135/zoom, bgPos.y+40/zoom, bgPos.x+bgPos.w, bgPos.y+bgPos.h, tocolor ( 255, 255, 255, 255 ), 1, font, "left", "top", false, true, true)
			dxDrawImage(bgPos.x, bgPos.y, 120/zoom, 120/zoom, exports["ms-avatars"]:loadAvatar(getElementData(win_player, "player:uid") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		end
		
end



function showMiniEventHUD(force, type, text, style, time, time2, player)
	if not getElementData(localPlayer, "player:spawned") then return end 

	
	if force == true then
		if time then 
			setTimer ( function()
				showMiniEventHUD(false)
			end, time, 1 )
		end
		
		text_style = style
		type_text = type
		event_text = text
		if time2 then
			event_time = getTickCount()+time2
		end
		
		if player then
			win_player = player
		end
		
		AtX, AtY, AtW, AtH = exports["ms-attractions"]:getInterfacePosition()
		
		bgPos = {x=screenW-(560/zoom), y=800/zoom, w=535/zoom, h=120/zoom}
		bgPos.y = AtY-130/zoom
		bgPos2 = {x=screenW-(560/zoom), y=800/zoom, w=410/zoom, h=120/zoom}
		bgPos2.y = AtY-130/zoom
		font = dxCreateFont( ":ms-hud/f/archivo_narrow.ttf", 20/zoom, false, "antialiased")
		font2 = dxCreateFont( ":ms-hud/f/archivo_narrow.ttf", 50/zoom, false, "antialiased")
		
		if not time then
			addEventHandler("onClientRender", getRootElement(), drawMiniEventHUD) 
		end
	end

	if force == false then
		if isElement(font) then 
			destroyElement(font)
		end 
		
		removeEventHandler("onClientRender", getRootElement(), drawMiniEventHUD) 
		
		minievent_box = nil
	end
end
addEvent("showMiniEventHUD", true)
addEventHandler("showMiniEventHUD", getRootElement(), showMiniEventHUD)

function playMiniEventSound(type)
	if not getElementData(localPlayer, "player:spawned") then return end 
	
	if type == "good" then
		sound = playSound("s/good.wav")
	else
		sound = playSound("s/wrong.wav")
	end
	
	setSoundVolume(sound, 0.5)
end
addEvent("playMiniEventSound", true)
addEventHandler("playMiniEventSound", getRootElement(), playMiniEventSound)


function checkPlayerCrouch()
	local crouch = getPedTask(localPlayer, "secondary", 1)
	
	if crouch then
		triggerServerEvent("giveRewardForChallange", localPlayer, localPlayer, 1)
	end
end
addEvent("checkPlayerCrouch", true)
addEventHandler("checkPlayerCrouch", getRootElement(), checkPlayerCrouch)


function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,postGUI) 
    for oX = -1, 1 do -- Border size is 1 
        for oY = -1, 1 do -- Border size is 1 
                dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak,postGUI) 
        end 
    end 
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI) 
end 
