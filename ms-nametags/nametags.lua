--[[
	@project: fullgaming
	@author: l0nger <l0nger.programmer@gmail.com>
	@filename: nametags.lua
	@desc: rendering nametagow
]]

local cFunc={}
local cSetting={}
ranks={
	{nazwa = "#B0B0B0Gracz#ffffff"},
	{nazwa =  "#179600Moderator#ffffff"},
	{nazwa =  "#ff0000Administrator#ffffff"},
	{nazwa =  "#BF0000Zarząd#ffffff"}
}

ranks2={
	{nazwa = "#000000Gracz#000000"},
	{nazwa =  "#000000Moderator#000000"},
	{nazwa =  "#000000Administrator#000000"},
	{nazwa =  "#000000Zarząd#000000"}
}

Nametags={}
Nametags.__index=Nametags

function Nametags:new(...)
	local obj=setmetatable({}, {__index=self})
	if obj.constructor then
		obj:constructor(...)
	end
	return obj
end

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function Nametags:render()
	if not self.enabled then return end
	if not getElementData(localPlayer, 'player:spawned') then return end
	
	local cx,cy,cz=getCameraMatrix()
	if not cx or not cy then return end
	
	for v,_ in pairs(self.nametags.players) do
		if getElementInterior(localPlayer)~=getElementInterior(v) then return end
		if getElementDimension(localPlayer)~=getElementDimension(v) then return end
		if isPlayerNametagShowing(v) then
			setPlayerNametagShowing(v, false)
		end
		
		local x,y,z=getElementPosition(v)
		local dist=getDistanceBetweenPoints3D(cx,cy,cz, x,y,z+1.0)
		local maxDist = 20 
		if getPedOccupiedVehicle(localPlayer) then 
			if getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Helicopter" then 
				maxDist = 200
			end 
		end 
		
		if dist<maxDist then
			dist = dist/35 
			local clear=isLineOfSightClear(cx,cy,cz, x,y,z, true, false, false, true, false, false, true, nil)
			if clear then 
			local hitman=getElementData(v, "player:hitman_cost")
			local nick=getPlayerName(v):gsub('_', ' ')
			local id=getElementData(v, 'player:id') or 0
			local factionName=getElementData(v, 'player:factionName') or ''
			local rankName=getElementData(v, 'player:rank')
			local howMuchToRender={}
			local isAFK=getElementData(v, 'player:afk') or false
			local isChatTyping=getElementData(v, 'player:chat_typing') or false
			local isVoiceSay=getElementData(v, 'player:voice') or false
			local czyPedMaPasy=getElementData(v, 'player:zapiete_pasy') or false
			local isPremium=getElementData(v, 'player:premium') or false
			if isAFK==true then
				table.insert(howMuchToRender, {path='afk_icon.png', priority=10})
			end
			
			if isVoiceSay==true then
				table.insert(howMuchToRender, {path='microphone.png', priority=10})
			end
			
			if isChatTyping==true then
				table.insert(howMuchToRender, {path='chat_icon.png', priority=10})
			end
			if isPremium then
				table.insert(howMuchToRender, {path='premium_icon.png', priority=50})
			end
			if tonumber(hitman) > 0 then
				table.insert(howMuchToRender, {path='skull_icon.png', priority=40})
			end
			
			if not getElementData(v, "player:invisible") then
				local bonex,boney,bonez=getPedBonePosition(v, 5)
				local sx,sy=getScreenFromWorldPosition(bonex,boney,bonez+0.35)
				if sx and sy then
					local fontHeight=dxGetFontHeight(0.8-dist, self.myriadPro)
					local r,g,b = getPlayerNametagColor(v)
					local hex = RGBToHex(r,g,b)
					local s1 = ('#000000%d  %s '):format(id, nick)  
					local s2 = ('#727272%d  '.. hex ..'%s'):format(id, nick)
					if rankName == 0 and getElementData(v, "player:premium") ~= false then
						s1 = ('#000000%d %s'):format(id, nick) 
						s2 = ('#727272%d '.. hex..'%s'):format(id, nick) 
					end
					
					dxDrawText(s1, sx+1, sy, sx, sy, tocolor(255, 255, 255, 255-150*dist), math.max(0.5, 0.7-dist), self.myriadPro, 'center', 'center', false, false, false, true)
					dxDrawText(s2, sx, sy, sx, sy, tocolor(255, 255, 255, 255-150*dist), math.max(0.5, 0.7-dist), self.myriadPro, 'center', 'center', false, false, false, true)
					if dist < 10 then 
						-- frakcja name
						local gang = getElementData(v, "player:gang")
						if gang then
							local name = gang.name
							local r, g, b = gang.color[1], gang.color[2], gang.color[3]
							local hex = string.format("#%02X%02X%02X", r, g, b)
							dxDrawText(('#000000%s'):format(name), sx+1, sy, sx+1, sy+36, tocolor(255, 255, 255, 255-150*dist), math.max(0.3, 0.575-dist), self.myriadPro, 'center', 'center', false, false, false, true)
							dxDrawText(hex..name, sx, sy, sx, sy+35, tocolor(255, 255, 255, 255-350*dist), math.max(0.3, 0.575-dist), self.myriadPro, 'center', 'center', false, false, false, true)
						end
					end 
					
					if dist*40<10 then
						if #howMuchToRender==1 then
							dxDrawImage(sx-25/2, sy-40, 30-dist, 30-dist, 'i/' ..howMuchToRender[1].path, 0, 0, 0, tocolor(255, 255, 255, 255))
						elseif #howMuchToRender==2 then
							table.sort(howMuchToRender, function(a,b) return a.priority>b.priority end)
							dxDrawImage(sx-60/2, sy-40, 30-dist, 30-dist, 'i/' ..howMuchToRender[1].path, 0, 0, 0, tocolor(255, 255, 255, 255))
							dxDrawImage(sx-1/2, sy-40, 30-dist, 30-dist, 'i/' ..howMuchToRender[2].path, 0, 0, 0, tocolor(255, 255, 255, 255))
						elseif #howMuchToRender==3 then
							table.sort(howMuchToRender, function(a,b) return a.priority>b.priority end)
							dxDrawImage(sx-80/2, sy-40, 30, 30, 'i/' ..howMuchToRender[1].path, 0, 0, 0, tocolor(255, 255, 255, 255))
							dxDrawImage(sx-20/2, sy-40, 30, 30, 'i/' ..howMuchToRender[2].path, 0, 0, 0, tocolor(255, 255, 255, 255))
							dxDrawImage(sx+40/2, sy-40, 30, 30, 'i/' ..howMuchToRender[3].path, 0, 0, 0, tocolor(255, 255, 255, 255))
						end
					end
					--dxDrawText(('(%s)'):format('3000j'), sx-2, sy+fontHeight, sx, sy+fontHeight, tocolor(0, 0, 0, 255-50*dist), 0.7-dist, self.myriadPro, 'center', 'center')
					--dxDrawText(('(%s)'):format('3000j'), sx, sy+fontHeight, sx, sy+fontHeight, tocolor(255, 255, 255, 255-50*dist), 0.7-dist, self.myriadPro, 'center', 'center')
				end
			end
			end 
		end
	end
end

function Nametags:setEnabled(bool)
	if bool==nil then
		self.enabled=not self.enabled
	else
		self.enabled=bool
	end
end

function Nametags:constructor(...)
	local sx,sy=guiGetScreenSize()
	
	self.myriadPro=dxCreateFont('f/archivo_narrow.ttf', 20, false, "antialiased")
	self.nametags={
		players={}, vehicles={}, _3dtext={}
	}
	self.renderFunc=function() self:render() end
	addEventHandler('onClientRender', root, self.renderFunc)
	
	local playersOnTheServer=getElementsByType('player', root)
	for _,v in pairs(playersOnTheServer) do
		if v~=localPlayer then
			if isElementStreamedIn(v) then
				self.nametags.players[v]=true
				setPlayerNametagShowing(v, false)
			end
		end
	end
	
	local vehiclesOnTheServer=getElementsByType('vehicle', root)
	for _,v in pairs(vehiclesOnTheServer) do
		if isElementStreamedIn(v) then
			self.nametags.vehicles[v]=true
		end
	end
	
	addEventHandler('onClientElementStreamIn', root, function()
		if getElementType(source)=='player' and source~=localPlayer and not self.nametags.players[source] then
			self.nametags.players[source]=true
		end 
		if getElementType(source)=='vehicle' and not self.nametags.vehicles[source] then
			self.nametags.vehicles[source]=true
		end
	end)
	
	addEventHandler("onClientPlayerVoiceStart",root,function()
		setElementData(source, 'player:voice', true)
	end)

	addEventHandler("onClientPlayerVoiceStop",root,function()
		setElementData(source, 'player:voice', false)
	end)
	
	addEventHandler('onClientElementStreamOut', root, function()
		if self.nametags.players[source] and getElementType(source)=='player' then
			self.nametags.players[source]=nil
		end
		if getElementType(source)=='vehicle' and self.nametags.vehicles[source] then
			self.nametags.vehicles[source]=nil
		end
	end)

	addEventHandler('onClientPlayerQuit', root, function()
		if self.nametags.players[source] then
			self.nametags.players[source]=nil
		end
	end)
end


addEventHandler("onClientPlayerQuit", root,
	function(r)
		local text = createElement("3dtext")
		local x,y,z = getElementPosition(source)
		setElementData(text, "3dtext:opis", "Gracz "..getPlayerName(source).." wyszedł z gry. ("..r..")")
		setElementPosition(text, x, y, z)
		setTimer(destroyElement, 60000, 1, text)
	end 
)
-- testowa komenda
addCommandHandler('vopis', function(cmd, ...)
	local vehicle=getPedOccupiedVehicle(localPlayer)
	if not vehicle then
		triggerEvent("onClientAddNotification", localPlayer, "Nie jesteś w pojeździe.", "error")
		return
	end
	
	local uid = getElementData(localPlayer, "player:uid") 
	if getElementData(vehicle, "vehicle:owner") ~= uid then 
		triggerEvent("onClientAddNotification", localPlayer, "Ten pojazd nie należy do ciebie.", "error")
		return
	end 
	
	local opis=table.concat({...}, ' ')
	triggerEvent("onClientAddNotification", localPlayer, "Zmieniłeś opis pojazdu pomyślnie.", "success")
	
	setElementData(vehicle, 'vehicle:desc', opis)
end)

nametags=Nametags:new()
nametags:setEnabled(true)

--function tagifunc()
	--setElementData(localPlayer, 'player:premium', true)
	--outputChatBox(tostring(getElementData(localPlayer, 'player:premium')))
	--outputChatBox(tostring(#howMuchToRender))
--end
--addCommandHandler("tagi", tagifunc)

local maxDist = 30
local defaultR, defaultG, defaultB = 240, 240, 240
local screenW, screenH = guiGetScreenSize()

local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+150)/screenW)
end 

local font = dxCreateFont("f/archivo_narrow.ttf", 20, false, "antialiased")

-- interfejs celowania 
local targetBg = {x=screenW-(800/zoom), y=screenH-(600/zoom), w=345/zoom, h=100/zoom}
local targetBgLine = {x=targetBg.x, y=targetBg.y+targetBg.h, w=targetBg.w, h=4/zoom}

function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function updateNametags()
	local players = getElementsByType("player")

	if isPedAiming(localPlayer) then 
		local target = getPedTarget(localPlayer)
		if target and getElementType(target) == "player" and target ~= localPlayer then 
			exports["ms-gui"]:dxDrawBluredRectangle(targetBg.x, targetBg.y, targetBg.w, targetBg.h, tocolor(255, 255, 255, 255), true)
			dxDrawRectangle(targetBgLine.x, targetBgLine.y, targetBgLine.w, targetBgLine.h, tocolor(51, 102, 255, 255), true)
			
			-- nick 
			dxDrawImage(targetBg.x + 20/zoom, targetBg.y + 15/zoom, 70/zoom, 70/zoom, exports["ms-avatars"]:loadAvatar(getElementData(target, "player:uid") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
			dxDrawText(getPlayerName(target), targetBg.x + 100/zoom, targetBg.y + 15/zoom, 70/zoom, 70/zoom, tocolor(220, 220, 220, 220), 0.55, font, "left", "top", false, false, true, false, false)
			
			-- hp i armor 
			local hp = getElementHealth(target)/100
			local armor = getPedArmor(target)/100
			
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 45/zoom, 150/zoom, 15/zoom, tocolor(60, 60, 60, 200), true)
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 65/zoom, 150/zoom, 15/zoom, tocolor(60, 60, 60, 200), true)
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 45/zoom, (150/zoom)*hp, 15/zoom, tocolor(231, 76, 60, 200), true)
			dxDrawRectangle(targetBg.x + 100/zoom, targetBg.y + 65/zoom, (150/zoom)*armor, 15/zoom, tocolor(149, 165, 166, 200), true)
			
			-- level
			dxDrawImage(targetBg.x+targetBg.w-80/zoom, targetBg.y + 15/zoom, 70/zoom, 70/zoom, "circle.png", 0, 0, 0, tocolor(149, 165, 166, 200), true)
			dxDrawText(tostring(getElementData(target, "player:level") or 1), targetBg.x + 100/zoom, targetBg.y + 35/zoom, targetBg.x+targetBg.w+155/zoom, 70/zoom, tocolor(220, 220, 220, 220), 0.6, font, "center", "top", false, false, true, false, false)
		end
	end
end
addEventHandler("onClientRender", root, updateNametags)

setPedTargetingMarkerEnabled(false)