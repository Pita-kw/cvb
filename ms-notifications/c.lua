--[[
	MultiServer 
	Zasób: ms-notifications/c.lua
	Opis: System notyfikacji nad radarem.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

notifications = {}
notificationID = 0 
notificationTime = 7500  -- czas podstawowy widzenia (dolicza jeszcze troche w zaleznosci od dlugosci tekstu)
notificationLimit = 7 -- maksymalna ilość notyfikacji 

notificationsTypes = 
{
	["info"] = {51, 102, 255},
	["error"] = {231, 76, 60},
	["warning"] = {243, 156, 18},
	["success"] = {46, 204, 113},
	["message"] = {154, 0, 255},
}

notificationsQueue = {} 
notificationQueueDelayTick = 0 

local _type = type 

function addNotification(text, type, time, allowSound) 
	if text and type then
		
		local soundPath = "s/"..tostring(type)..".mp3"
		if _type(type) == "table" then 
			soundPath = "s/"..tostring(type.type)..".mp3"
		else 
			if not notificationsTypes[type] then 
				outputDebugString("Nie znaleziono typu notyfikacji "..tostring(type), 1)
				return
			end 
		end 
	
		--metoda z usuwaniem 
		-- ograniczanie notyfikacji
		if #notifications >= notificationLimit then
			local notOffY = notifications[1].offsetY
			if notifications[1].blur then 
				exports["ms-blur"]:destroyBlurBox(notifications[1].blur)
			end 
			
			table.remove(notifications, 1)
			for k,v in ipairs(notifications) do 
				v.offsetY = v.offsetY-notOffY
			end
		end
		
		--[[
		-- metoda z kolejkowaniem 
		if #notifications+1 > notificationLimit and not ignoreQueue then 
			table.insert(notificationsQueue, {text, type, math.max(3000, (time or notificationTime)/2), allowSound})
			return
		end
		--]] 
		
		if allowSound ~= false then 
			setSoundVolume(playSound(soundPath, false), 0.5)
		end 
		
		radarX, radarY, radarW, radarH = exports["ms-radar"]:getRadarPosition()
		bgPos = {x=radarX-2, w=radarW+4, h=0}
		bgLinePos = {x=bgPos.x, w=3, h=bgPos.h}
		fontHeight = 10
		if not font then 
			font = dxCreateFont("archivo_narrow.ttf", fontHeight, false, "antialiased")
		end 
		
		-- liczenie offsetu
		local offsetY = 0 
		local wordWrapText, returnLines = "", 0
		if _type(type) == "table" then 
			if type.image then 
				wordWrapText, returnLines = fWordWrap(text, bgPos.w*(7*(bgPos.w/300)), fontHeight, 1.0, font, true)
			else 
				wordWrapText, returnLines = fWordWrap(text, bgPos.w*(8*(bgPos.w/300)), fontHeight, 1.0, font, true)
			end
		else
			wordWrapText, returnLines = fWordWrap(text, bgPos.w*(8*(bgPos.w/300)), fontHeight, 1.0, font, true)
			outputConsole("[".. string.upper(type) .. "]: ".. text .."")
		end
		local textHeight = 15 + ((fontHeight+7.5) * returnLines)
		
		local previousNotification = notifications[#notifications]
		if previousNotification then 
			offsetY = 10 + previousNotification.offsetY + textHeight
		else 
			offsetY = 15 + textHeight
		end 
		
		notificationID = notificationID+1
		table.insert(notifications, {id=notificationID, offsetX=100, offsetY=offsetY, text=wordWrapText, textHeight=textHeight, type=type, created=getTickCount(), time=time or notificationTime})
	end
end 
addEvent("onClientAddNotification", true)
addEventHandler("onClientAddNotification", root, addNotification)

local function recalcOffsets()
	for k,v in ipairs(notifications) do 
		local previousNotification = notifications[k-1]
		if previousNotification then 
			v.offsetY = 10 + previousNotification.offsetY + v.textHeight
		else 
			v.offsetY = 15 + v.textHeight
		end 
	end
end 

function renderNotifications()
	local now = getTickCount() 
	
	-- kolejka notyfikacji 
	--[[
	if #notifications < notificationLimit and now > notificationQueueDelayTick then 
		local queue = notificationsQueue[1]
		if queue then 
			notificationQueueDelayTick = getTickCount()+200
			
			table.remove(notificationsQueue, 1)
			addNotification(queue[1], queue[2], queue[3], queue[4])
		end
	end
	--]] 
	
	for k,v in ipairs(notifications) do 
		local bgX, bgY, bgW, bgH = bgPos.x-v.offsetX, radarY-v.offsetY, bgPos.w, v.textHeight
		local barR, barG, barB = 255, 255, 255 -- kolor paska
		local imagePath, imageX, imageY, imageW, imageH, imageR, imageG, imageB = false, false, false, false, false, false, false, false -- dodatkowy obrazek
		local progressX, progressY, progressW, progressH, progressValue = false, false, false, false
		if _type(v.type) == "table" then 
			if v.type.custom == "image" then -- dodatkowa tabelka z obrazkami / progress barami
				imageX = bgX+v.type.x+v.type.w/2  -- offset
				imageY = v.type.y -- offset
				imageW = v.type.w 
				imageH = v.type.h 
				imageR, imageG, imageB = v.type.r or notificationsTypes[v.type.type][1], v.type.g or notificationsTypes[v.type.type][2], v.type.b or notificationsTypes[v.type.type][3]
				imagePath = v.type.image 
				
				if bgH < imageH then 
					bgH = imageH+10
					v.textHeight = bgH -- trick xd
					recalcOffsets()
				end
						
				-- wysrodkowanie obrazka 
				imageY = imageY + bgY + bgH/2 - imageH/2
			elseif v.type.custom == "progress" then 
				progressW = bgW
				progressH = bgH
				progressX = bgX
				progressY = bgY
				progressValue = v.type.value
			end
			
			barR, barG, barB = notificationsTypes[v.type.type][1], notificationsTypes[v.type.type][2], notificationsTypes[v.type.type][3] 
		else
			barR, barG, barB = notificationsTypes[v.type][1], notificationsTypes[v.type][2], notificationsTypes[v.type][3]
		end
		
		if now >= v.created+v.time and v.destroy then 
			if v.blur then 
				exports["ms-blur"]:destroyBlurBox(v.blur)
			end 
			
			table.remove(notifications, k)
			recalcOffsets()
		else
			local alpha = 0 
			if now >= v.created+v.time then
				if not v.delete then 
					v.delete = getTickCount()
				end 
				
				local progress = (now - v.delete) / 350
				alpha = interpolateBetween(255, 0, 0, 0, 0, 0, math.min(progress, 1), "InOutQuad")
				
				local progress = (now - v.delete) / 500
				v.offsetX =  interpolateBetween(v.offsetX, 0, 0, 100, 0, 0, math.min(progress, 1), "InOutQuad")
				if progress > 0.8 then 
					v.destroy = true 
				end 
			else 
				local progress = (now - v.created) / 400
				alpha = interpolateBetween(0, 0, 0, 255, 0, 0, math.min(progress, 1), "InOutQuad")
				v.offsetX =  interpolateBetween(v.offsetX, 0, 0, 0, 0, 0, math.min(progress, 1), "InOutQuad")
			end 
			
			exports["ms-gui"]:dxDrawBluredRectangle(bgX, bgY, bgW, bgH, tocolor(200, 200, 200, alpha))
			dxDrawRectangle(bgLinePos.x-v.offsetX, radarY-bgLinePos.h-v.offsetY, bgLinePos.w, bgH, tocolor(barR, barG, barB, alpha), true)
			if imageX and imageY and imageW and imageH then 
				dxDrawImage(imageX, imageY, imageW, imageH, imagePath, 0, 0, 0, tocolor(imageR, imageG, imageB, alpha), true)
				dxDrawText(v.text, imageX+imageW+16, bgY, bgW, bgY+bgH, tocolor(230, 230, 230, math.max(0, alpha-30)), 1, font, "left", "center", false, false, true)
			elseif progressX and progressY and progressW and progressH then 
				--dxDrawRectangle(progressX, progressY, progressW, progressH, tocolor(100, 100, 100, math.max(0, alpha-100)), true)
				dxDrawRectangle(progressX, progressY, progressW * progressValue, progressH, tocolor(barR, barG, barB, math.max(0, alpha-90)), true)
				dxDrawText(v.text, progressX, progressY, progressX+progressW, progressY+progressH, tocolor(230, 230, 230, math.max(0, alpha-30)), 1, font, "center", "center", false, false, true)
			else
				dxDrawText(v.text, bgX+16, bgY, bgW, bgY+bgH, tocolor(230, 230, 230, math.max(0, alpha-30)), 1, font, "left", "center", false, false, true)
			end
		end 
	end
end 

function onClientResourceStart()
	addEventHandler("onClientRender", root, renderNotifications)
end 
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)
