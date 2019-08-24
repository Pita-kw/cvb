screenW, screenH = guiGetScreenSize()
local sx,sy = (screenW/1366), (screenH/768)
local dxfont0_archivo_narrow 
local dimension = 1002

local schemes = 
{
	{
		0, 2, -1, -1,
		-1, 0, 2, -1,
		-1, 1, 3, -1,
		-1, 0, 2, -1,
	},
	
	{
		-1,-1,1,3,
		-1,1,3,-1,
		1,3,-1,-1,
		-1,-1,-1,-1,
	},
	
	{
		0, 2, -1, -1,
		1, 3, -1, -1,
		0, 2, -1, -1, 
		1, 3, -1, -1, 
	},
	
	{
		1, 3, -1, -1, 
		0, 2, -1, -1,
		-1, 0, 2, -1,
		-1, -1, 0, 2, 
	},
}

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

local repairTime = 25 -- czas do naprawy 
local repaired = 0 -- naprawione punkty 
local pointsToRepair = 3 -- ilosc punktow do naprawy 
local repairPoints = 
{
	{1907.55,-1783.82,13.55},
	{2786.23,-1960.88,17.31},
	{1111.93,-1803.86,16.59},
	{2353.33,-1357.12,24.40},
	{1813.89,-2076.13,13.52},
	{2245.39,-1942.65,13.55},
	{2481.01,-1958.14,13.59},
	{2445.42,-1758.87,13.59},
	{2540.98,-1193.79,59.90},
	{1788.15,-1369.13,15.76},
	{1495.37,-1749.31,15.45},
	{1726.65,-1615.24,13.55},
	{2143.97,-2265.42,13.30},
	{2523.67,-2017.82,14.07},
	{2325.88,-1647.23,14.83},
	{2095.54,-1276.61,25.49},
	{1690.49,-1510.11,13.55},
	{951.21,-958.39,39.49},
	{388.03,-2028.48,7.93},
	{388.87,-2072.72,7.84},
	{658.77,-1864.13,5.46},
	{1000.10,-1850.02,12.81},
	{1575.40,-1897.94,13.56},
	{1729.85,-1944.58,13.57},
	{1757.07,-1943.77,13.57},
	{2059.45,-1830.61,22.45},
}
local wyplata = 1200
local exp = 12
local jobEnd = false 
local blip, sound, marker = false, false, false
local blipEnd = false 

class "CElectricScheme"
{
	__init__ = function(self)
		if qte then return end 
		if not dxfont0_archivo_narrow then dxfont0_archivo_narrow = dxCreateFont("f/archivo_narrow.ttf", 14*sx) end 
		
		self.scheme = 
		{
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0
		}
		
		self.correctScheme = {} 
		
		self.images = 
		{
			-- 0 |__
			-- 1 |- 
			-- 2 -| 
			-- 3 __|
			
			[0] = {0, 0, 0}, 
			[1] = {90, 0, 0},
			[2] = {180, 0, 0},
			[3] = {270, 0, 0},
		}
		
		self:generateScheme()
		self.failed = true 
		
		self.timer = repairTime
		self.tick = getTickCount()+1000 
		self.chances = 3 
		
		self.firstIndex = false 
		self.lastIndex = false 
		
		self.renderFunc = function() self:onRender() end 
		addEventHandler("onClientRender", root, self.renderFunc)
		
		self.keyFunc = function(a, b) self:onKey(a, b) end 
		addEventHandler("onClientKey", root, self.keyFunc)
		
		showCursor(true)
	end,

	destroy = function(self)
		if isElement(sound) then 
			destroyElement(sound)
		end 
		
		removeEventHandler("onClientRender", root, self.renderFunc)
		removeEventHandler("onClientKey", root, self.keyFunc)
		showCursor(false)
		setPedAnimation(localPlayer)
		
		qte = false 
	end, 
	
	generateScheme = function(self)
		local rand = math.random(1, #schemes)
		self.correctScheme = schemes[rand]
		
		local tbl = {} 
		for i=1,#self.correctScheme do 
			table.insert(tbl, self.correctScheme[i])
		end 
		
		for k,v in ipairs(tbl) do 
			if v ~= -1 then 
				tbl[k] = math.random(0,3)
			end
		end 
		
		self.scheme = tbl 
	end, 
		
	onKey = function(self, key, press)
		if key == "mouse1" and press then 
			if self.selectedLine then 
				local rows = -1 
				local column = 0 
				for i=1,self.selectedLine do 
					rows = rows+1
					if rows == 4 then
						column = column+1
						rows = 0
					end
				end 
				
				if isCursorOnElement((487 + 97*rows)*sx, (190 + 88*column)*sy, 98*sx, 98*sy) then 
					self.scheme[self.selectedLine] = self.scheme[self.selectedLine]+1 
					if self.scheme[self.selectedLine] > 3 then 
						self.scheme[self.selectedLine] = 0
					end 
					
					self.failed = false 
					for k,v in ipairs(self.scheme) do
						if self.images[v] then 
							if self.correctScheme[k] ~= v then 
								self.failed = true 
							end
						end 
					end 
				end 
			end 
		end 
	end, 
	
	onRender = function(self)
		
		dxDrawText("Ustaw linie w ciągłej kolejności.", 553*sx, 154*sy, 835*sx, 233*sy, tocolor(0, 0, 0, 255), 1.00, dxfont0_archivo_narrow, "left", "top", false, false, false, false, false)
        dxDrawText("Ustaw linie w ciągłej kolejności.", 552*sx, 153*sy, 834*sx, 232*sy, tocolor(255, 255, 255, 255), 1.00, dxfont0_archivo_narrow, "left", "top", false, false, false, false, false)
		dxDrawImage(482*sx, 181*sy, 403*sx, 380*sy, ":ms-elektryk/i/background.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		--dxDrawImage(482*sx, 181*sy, 403*sx, 403*sy, ":ms-elektryk/i/help_lines.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        --dxDrawImage(585*sx, 572*sy, 196*sx, 55*sy, ":ms-hydraulik/on_radar_back.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
		local m = getRealTime(self.timer).minute 
		local s = getRealTime(self.timer).second 
		if m < 10 then m = "0"..tostring(m) end 
		if s < 10 then s = "0"..tostring(s) end 
		
		local now = getTickCount() 
		if now >= self.tick then 
			self.timer = self.timer-1 
			self.tick = getTickCount()+1000 
		end 
		
		if self.timer == 0 then 
			setElementHealth(localPlayer, getElementHealth(localPlayer)-5)
			self.timer = repairTime
			self.chances = self.chances-1 
			playSound("s/shock.mp3", false)
			
			if self.chances <= 0 then 
				if isElement(blip) then destroyElement(blip) end 
				if isElement(marker) then destroyElement(marker) end 
				if isElement(sound) then destroyElement(sound) end 
				
				triggerEvent("onClientAddNotification", localPlayer, "Spaliłeś układ. Praca zakończona niepowodzeniem.", "error")
				triggerServerEvent("onPlayerStopElectrician", localPlayer)
				self:destroy()
			else 
				self:generateScheme()
				triggerEvent("onClientAddNotification", localPlayer, "Auć! Spróbuj jeszcze raz...", "error")
			end 
		end 
		
		dxDrawText(tostring(m)..":"..tostring(s), 654*sx, 587*sy, 712*sx, 573*sy, tocolor(255, 255, 255, 255), 1.80*sx, "default-bold", "left", "top", false, false, false, false, false)
		
		local rows = -1
		local column = 0 
		for k,v in ipairs(self.scheme) do 
			rows = rows+1
			if rows == 4 then
				column = column+1
				rows = 0
			end

			--dxDrawRectangle(462 + 110*rows, 235 + 72*column, 111, 75, tocolor(255, 255, 255, 255), false)
			  
			if self.images[v] then 
				if self.correctScheme[k] == v then 
					dxDrawImage((487 + 97*rows)*sx, (190 + 88*column)*sy, 98*sx, 98*sy, ":ms-elektryk/i/line.png", self.images[v][1], self.images[v][2], self.images[v][3], tocolor(0, 255, 0, 255), false)
				else 
					dxDrawImage((487 + 97*rows)*sx, (190 + 88*column)*sy, 98*sx, 98*sy, ":ms-elektryk/i/line.png", self.images[v][1], self.images[v][2], self.images[v][3], tocolor(255, 255, 255, 255), false)
				end 
				
				if isCursorOnElement((487 + 97*rows)*sx, (190 + 88*column)*sy, 98*sx, 98*sy) and k ~= self.firstIndex and k ~= self.lastIndex then 
					self.selectedLine = k 
				end 
			end 
		end
		
		if not self.failed then 
			self:destroy()
			
			repaired = repaired+1 
			if repaired == pointsToRepair then 
				if isElement(blip) then destroyElement(blip) end 
				if isElement(marker) then destroyElement(marker) end 
				if isElement(sound) then destroyElement(sound) end 
				
				blipEnd = createBlip(2003.72,-1070.19,24, 41)
				setElementData(blipEnd, 'blipIcon', 'mission_target')
				setElementData(blipEnd, 'exclusiveBlip', true)
				setElementDimension(blipEnd, dimension)
				
				triggerEvent("onClientAddNotification", localPlayer, "Naprawiłeś wszystkie awarie!\nUdaj się do bazy by odebrać wypłatę.", "success")				
			else 
				if isElement(blip) then 
					destroyElement(blip)
				end 
	
				if isElement(marker) then 
					destroyElement(marker)
				end 
				
				local rand = math.random(1, #repairPoints)
				local x,y,z = repairPoints[rand][1], repairPoints[rand][2], repairPoints[rand][3]
				marker = createMarker(x, y, z-0.6, "corona", 2, 0, 255, 255, 200)
				setElementDimension(marker, dimension)
				addEventHandler("onClientMarkerHit", marker, onMarkerHit)
				blip = createBlipAttachedTo(marker, 41)
				setElementData(blip, 'blipIcon', 'mission_target')
				setElementData(blip, 'exclusiveBlip', true)
				setElementDimension(blip, dimension)
				sound = playSound3D("s/sparks.mp3", x, y, z, true)
				setElementDimension(sound, dimension)
				setSoundMaxDistance(sound, 20)
				
				triggerEvent("onClientAddNotification", localPlayer, "Udało ci się naprawić układ scalony!\nUdaj się do następnego punktu.", "success")
			end 
		end 
	end, 
}

local jobEnd = false 
local blip = false 
local marker = false 

function onMarkerHit(hitElement)
	if hitElement ~= localPlayer then return end 
	if isPedInVehicle(localPlayer) then return end 
	
	if isElement(blip) then 
		destroyElement(blip)
	end 
	
	if isElement(marker) then 
		destroyElement(marker)
	end 
	
	qte = CElectricScheme()
	setPedAnimation(localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false, true)
end

function startElektryk()
	setElementData(localPlayer, "player:job", "job_elektryk")
	triggerEvent("onClientAddNotification", localPlayer, "Na twojej mapie zaznaczono punkt do którego masz się udać.", "info")
	local rand = math.random(1, #repairPoints)
	local x,y,z = repairPoints[rand][1], repairPoints[rand][2], repairPoints[rand][3]
	marker = createMarker(x, y, z-0.6, "corona", 2, 0, 255, 255, 200)
	setElementDimension(marker, dimension)
	addEventHandler("onClientMarkerHit", marker, onMarkerHit)
	blip = createBlipAttachedTo(marker, 41)
	setElementData(blip, 'blipIcon', 'mission_target')
	setElementData(blip, 'exclusiveBlip', true)
	setElementDimension(blip, dimension)
	sound = playSound3D("s/sparks.mp3", x, y, z, true)
	setElementDimension(sound, dimension)
	setSoundMaxDistance(sound, 20)
	setElementDimension(job_ped, dimension)
	setElementDimension(job_pickup, dimension)
	repaired = 0 
	jobEnd = false 
	setElementData(localPlayer, "player:status", "Praca: Elektryk")
end 
addEvent("onClientStartElectrician", true)
addEventHandler("onClientStartElectrician", root, startElektryk)

function stopElektryk()
	if qte then 
		qte:destroy() 
	end 
	
	if isElement(blip) then 
		destroyElement(blip)
	end 
	
	if isElement(marker) then 
		destroyElement(marker)
	end

	if isElement(sound) then 
		destroyElement(sound)
	end 
	
	setElementDimension(job_ped, 0)
	setElementDimension(job_pickup, 0)
	setElementData(localPlayer, "player:status", "W grze")
	triggerServerEvent("giveLevelWeapons", localPlayer, localPlayer)
end 
addEvent("onClientStopElectrician", true)
addEventHandler("onClientStopElectrician", root, stopElektryk)

job_ped = createPed(261, 2003.33,-1071.28,24.58, 340)
addEventHandler("onClientPedDamage", job_ped, cancelEvent)
setElementData(job_ped, "description", "Elektrwadyk")
setElementFrozen(job_ped, true)
job_blip = createBlipAttachedTo(job_ped, 52)
setElementData(job_blip, 'blipIcon', 'job')


job_pickup = createPickup(2003.72,-1070.19,24, 3, 1274)

addEventHandler("onClientPickupHit", job_pickup,
function(hitElement)
	if hitElement == localPlayer then
		if getElementData(localPlayer, "player:job") == "job_elektryk" then 
			if repaired == pointsToRepair then 
				destroyElement(blipEnd) 
				
				triggerServerEvent("onPlayerStopElectrician", localPlayer)
				triggerServerEvent("giveElectricReward", localPlayer, localPlayer, exp, wyplata)
				triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "player:did_jobs", 1)
				triggerServerEvent("giveLevelWeapons", localPlayer, localPlayer)

				if getElementData(localPlayer, "player:premium") then
					triggerEvent("onClientAddNotification", localPlayer, "Praca zakończona pomyślnie.\nOtrzymujesz $"..tostring(wyplata + wyplata * 0.3).." oraz ".. math.floor(exp + exp * 0.3) .." exp", "success")
				else
					triggerEvent("onClientAddNotification", localPlayer, "Praca zakończona pomyślnie.\nOtrzymujesz $"..tostring(wyplata).." oraz ".. exp .." exp", "success")
				end
				repaired = 0 
			end 
		else 
			GUIClass:setEnable(true) 
		end 
	end 
end)


fileDelete("c.lua")