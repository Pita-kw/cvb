local disabled = false

local places = {
	{ -1954.21, -757.29, 41.83},
	{-2524.76, -654.15, 147.91},
	{-2683.68,-127.93,13.12},
	{ -2889.68, 997.20, 50.24},
	{-1349.54, 491.08, 34.74},
	{-688.06, 931.43, 23.51},
	{ -60.29, 969.11, 23.14},
	{211.64, 1811.32, 25.12},
	{1083.58, 1968.07, 16.06},
	{1464.24, 1888.16, 16.05},
	{1973.66, 1623.07, 12.86},
	{2652.25, 2251.10, 18.14},
	{2065.61, 650.41, 15.26},
	{2479.83, 89.21, 30.74},
	{2156.53, -104.04, 2.70},
	{1288.95, 171.88, 20.46},
	{318.53, -42.55, 4.46},
	{-92.98, -87.58, 3.12},
	{ -90.73, -1168.83, 7.74},
	{578.09, -2097.62, 18.05},
	{1334.97, -638.67, 114.03},
	{1496.45, -664.80, 95.60},
	{2251.80, -1284.15, 25.37},
	{2490.46, -1681.02, 13.34},
	{2757.51, -1933.04, 13.54}
}

local presentObjects = {} 
local dimension = 1009

local function createPresentDrop(x, y, z)
	z = z+30 
	local marker = createMarker(x, y, z, "checkpoint", 10, 255, 0, 0, 155)
	setElementDimension(marker, dimension)
	
	local blip = createBlipAttachedTo(marker, 52)
	setElementDimension(blip, dimension)
	setElementData(blip, 'blipIcon', 'mission_target')
	setElementData(blip, "blipSize", 16)
	setElementData(blip, "exclusiveBlip", true)
	setElementData(marker, "blip", blip)
	
	addEventHandler("onClientMarkerHit", marker, function(hitElement)
		if hitElement == localPlayer and isPedInVehicle(hitElement) then
			local mx, my, mz = getElementPosition(source)
			
			local vehicle = getPedOccupiedVehicle(localPlayer)
			local x, y, z =  getPositionFromElementOffset(vehicle, 0, -1, -0.3)
			
			destroyElement(getElementData(marker, "blip"))
			destroyElement(marker)
			
			local object = createObject(3092, x, y, z)
			setElementCollisionsEnabled(object, false)
			setElementDimension(object, dimension)
			moveObject(object, 4000, mx, my, mz-29.5, 0, 720, 1080, "InQuad")
			table.insert(presentObjects, object)
			
			triggerEvent("onClientAddNotification", localPlayer, "Prezent zrzucony!", "info")
		end
	end)
end 

function renderChristmasWork()
	local bgX, bgY,bgW, bgH = exports["ms-hud"]:getInterfacePosition()
	local zoom = exports["ms-hud"]:getInterfaceZoom()
	local bgPos = {x=bgX, y=bgY+230/zoom, w=bgW, h=bgH-30/zoom}
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(170, 170, 170, 255), true)
	dxDrawRectangle (bgPos.x, bgPos.y+100/zoom, bgPos.w, 5/zoom, tocolor ( 51, 102, 255, 255 ), true)
	dxDrawRectangle (bgPos.x, bgPos.y, 120/zoom, 100/zoom, tocolor ( 50, 50, 50, 50 ), true)
	dxDrawRectangle (bgPos.x+bgPos.w-120/zoom, bgPos.y, 120/zoom, 100/zoom, tocolor ( 50, 50, 50, 50 ), true)
	
	dxDrawText("Zrzuć jak najwięcej prezentów\n do północy!", bgPos.x, bgPos.y, bgPos.x+bgPos.w, bgPos.y+bgPos.h, tocolor(220, 220, 220, 220), 0.5, GUIClass.font1, 'center', 'center', false, false, true)
	dxDrawText(tostring(#presentObjects), bgPos.x, bgPos.y, bgPos.x+120/zoom, bgPos.y+80/zoom, tocolor(255, 255, 255, 255), 0.8, GUIClass.font1, 'center', 'center', false, false, true)
	dxDrawText("Zrzucone", bgPos.x, bgPos.y, bgPos.x+120/zoom, bgPos.y+150/zoom, tocolor(220, 220, 220, 220), 0.5, GUIClass.font1, 'center', 'center', false, false, true)
	
	dxDrawText("$"..tostring(#presentObjects*200), bgPos.x+bgPos.w-120/zoom, bgPos.y, bgPos.x+bgPos.w, bgPos.y+80/zoom, tocolor(255, 255, 255, 255), 0.8, GUIClass.font1, 'center', 'center', false, false, true)
	dxDrawText("Zarobek", bgPos.x+bgPos.w-120/zoom, bgPos.y, bgPos.x+bgPos.w, bgPos.y+150/zoom, tocolor(220, 220, 220, 220), 0.5, GUIClass.font1, 'center', 'center', false, false, true)
end 

function onClientStartChristmasWork()
	engineReplaceCOL(engineLoadCOL("present.col"), 3092)
	engineImportTXD(engineLoadTXD("present.txd"), 3092)
	engineReplaceModel(engineLoadDFF("present.dff"), 3092)
	
	setFarClipDistance(1500)
	
	setTime(23, 55)
	timeTimer = setTimer(function()
		if getTime() == 0 then 
			onClientEndChristmasWork()
		end
	end, 1000, 0)
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	for k,v in ipairs(getElementsByType("vehicle")) do 
		setElementCollidableWith(vehicle, v, false)
	end
	addEventHandler("onClientVehicleDamage", vehicle, function() cancelEvent() end)
	
	triggerEvent("onClientAddNotification", localPlayer, "Rozrzuć jak nawięcej prezentów po San Andreas! Masz czas do północy. By sterować saniami w locie użyj strzałek. Na radarze zaznaczono miejsca zrzutów prezentów. Powodzenia.", "info", 10000)
	for k,v in ipairs(places) do
		createPresentDrop(v[1], v[2], v[3])
	end 
	
	addEventHandler("onClientRender", root, renderChristmasWork)
end 
addEvent("onClientStartChristmasWork", true)
addEventHandler("onClientStartChristmasWork", root, onClientStartChristmasWork)

function onClientEndChristmasWork()
	for k,v in ipairs(getElementsByType("marker", resourceRoot)) do 
		destroyElement(v)
	end
	
	for k,v in ipairs(getElementsByType("blip", resourceRoot)) do 
		destroyElement(v)
	end
	
	if isTimer(timeTimer) then 
		killTimer(timeTimer)
		timeTimer = nil
	end 
	
	triggerServerEvent("onPlayerEndChristmasWork", localPlayer, #presentObjects)
		
	for k,v in ipairs(presentObjects) do 
		destroyElement(v)
	end 
	presentObjects = {}
	
	resetFarClipDistance()
	engineRestoreModel(3092)
	
	removeEventHandler("onClientRender", root, renderChristmasWork)
end 

addEventHandler("onClientPlayerWasted", root, function()
	if source == localPlayer then 
		if getElementData(source, "player:job") == "christmas" then 
			onClientEndChristmasWork()
		end
	end
end)

local ped = createPed(239,-2343.93,-1621.65, 489.03, 0, false)
addEventHandler('onClientPedDamage', ped, cancelEvent)
setElementFrozen(ped, true)

local pickup = createPickup(-2343.93,-1621.65+1,489.03-0.5, 3, 1274, 2, 255, 0, 0, 255, 0, 1337)
addEventHandler("onClientPickupHit", pickup, function(hitElement) 
	if hitElement == localPlayer then 
		if disabled then 
			triggerEvent("onClientAddNotification", localPlayer, "Sanie nie są jeszcze rozgrzane...", "info")
			return
		end 
		
		GUIClass:setEnable(true) 
	end
end)

local blip = createBlipAttachedTo(pickup, 52)
setElementData(blip, 'blipIcon', 'job')

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end
