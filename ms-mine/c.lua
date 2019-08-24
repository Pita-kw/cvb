local screenW, screenH = guiGetScreenSize()
local miningPlaces =
{
	{ amount=100, x=-3476.32, y=740.52, z=36.87, col=false },
	{ amount=100, x=-3466.40, y=734.15, z=36.87, col=false },
	{ amount=100, x=-3480, y=721, z=36.87, col=false },
	{ amount=100, x=-3516.52, y=722.79, z=36.87, col=false},
	{ amount=100, x=-3526.45, y=722.83, z=36.87, col=false},
	{ amount=100, x=-3517.68, y=732.75, z=36.87, col=false},
	{ amount=100, x=-3491.90, y=712.20, z=36.87, col=false},
	{ amount=100, x=-3505.20, y=707.43, z=36.87, col=false},
	{ amount=100, x=-3466.38, y=693.54, z=36.87, col=false},
	{ amount=100, x=-3481.03, y=699.80, z=36.87, col=false},
}

function renderMineHUD()
	local rocks = getElementData(localPlayer, "mine:rock") or 0
	local copper = getElementData(localPlayer, "mine:copper") or 0
	local gold = getElementData(localPlayer, "mine:gold") or 0
	local diamond = getElementData(localPlayer, "mine:diamond") or 0
	
	exports["ms-gui"]:dxDrawBluredRectangle (bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor (255, 255, 255, 255), true)
	dxDrawText ("Skała", bgRock.x, bgRock.y, bgRock.x+bgRock.w, bgRock.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText (rocks, bgRockCount.x, bgRockCount.y, bgRockCount.x+bgRockCount.w, bgRockCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	
	dxDrawText ("Miedź", bgCopper.x, bgCopper.y, bgCopper.x+bgCopper.w, bgCopper.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText (copper, bgCopperCount.x, bgCopperCount.y, bgCopperCount.x+bgCopperCount.w, bgCopperCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	
	dxDrawText ("Złoto", bgGold.x, bgGold.y, bgGold.x+bgGold.w, bgGold.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText (gold, bgGoldCount.x, bgGoldCount.y, bgGoldCount.x+bgGoldCount.w, bgGoldCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	
	dxDrawText ("Diament", bgDiamond.x, bgDiamond.y, bgDiamond.x+bgDiamond.w, bgDiamond.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText (diamond, bgDiamondCount.x, bgDiamondCount.y, bgDiamondCount.x+bgDiamondCount.w, bgDiamondCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
end

function toggleMineHUD(toggle)
	if toggle == true then
		bgX, bgY,bgW, bgH = exports["ms-hud"]:getInterfacePosition()
		zoom = exports["ms-hud"]:getInterfaceZoom()
		bgPos = {x=bgX, y=bgY+230/zoom, w=bgW, h=bgH-30/zoom}
		 
		bgRock={x=bgPos.x-210/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgRockCount={x=bgPos.x-210/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		
		bgCopper={x=bgPos.x-70/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgCopperCount={x=bgPos.x-70/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		 
		bgGold={x=bgPos.x+70/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgGoldCount={x=bgPos.x+70/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		 
		bgDiamond={x=bgPos.x+210/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgDiamondCount={x=bgPos.x+210/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		font = dxCreateFont( ":ms-arens/f/archivo_narrow.ttf", 30/zoom)
		addEventHandler("onClientRender", getRootElement(), renderMineHUD)
	else
		destroyElement(mine_blur)
		destroyElement(font)
		removeEventHandler("onClientRender", getRootElement(), renderMineHUD)
	end
end
addEvent("toggleMineHUDTrigger", true)
addEventHandler("toggleMineHUDTrigger", localPlayer, toggleMineHUD)

function addMiningPlaces()
	for k,v in ipairs(miningPlaces) do
		if v.col == false then
			v.col = createColSphere(v.x, v.y, v.z, 2)
		end
	end
end

local lastHit = 0
function onRenderMiningPlaces()
	local fightTask = getPedTask ( localPlayer, "secondary", 0 )
	if getControlState("fire") and fightTask == "TASK_SIMPLE_FIGHT" and not getControlState("aim_weapon") then
		local now = getTickCount()

		if getPedWeapon(localPlayer) == 8 and now >= lastHit then
			for k,v in ipairs(miningPlaces) do
				if isElementWithinColShape(localPlayer, v.col) then
					v.amount = v.amount-5
					if v.amount < 0 then
						v.amount = 0
					elseif v.amount > 0 then
						triggerServerEvent("onPlayerDropRock", localPlayer)
					end

					lastHit = getTickCount()+2500 
				end
			end
		end
	end

	for k,v in ipairs(miningPlaces) do
		local x1,y1,z1 = getElementPosition (getLocalPlayer())
		local visibleto = getDistanceBetweenPoints3D(x1, y1, z1,v.x, v.y, v.z)
		if visibleto < 7 then
			local sx,sy = getScreenFromWorldPosition ( v.x, v.y, v.z )
			if sx and sy then
				dxDrawRectangle(sx, sy, screenW*0.1, screenH*0.03, tocolor(0, 0, 0, 200), false)
				dxDrawRectangle(sx+screenW*0.002, sy+screenH*0.005, screenW*(0.00095*v.amount), screenH*0.02, tocolor(0, 102, 255, 200), false)
			end
		end
    end
	
	local x,y,z = 2050.42,-495.90,72.75
	z = z+1.2
	local x2, y2, z2 = getElementPosition(localPlayer)
	local distance = getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 )
	if distance <= 6 then
		local x, y = getScreenFromWorldPosition( x, y, z )
		if x and y then
			if not getElementData(localPlayer, "player:premium") then 
				dxDrawText("Cena za sztukę:\nSkała wapienna: $20\nMiedź: $40\nZłoto: $80\nDiament: $500", x+1.5, y+1.5, _, _, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
				dxDrawText("Cena za sztukę:\nSkała wapienna: $20\nMiedź: $40\nZłoto: $80\nDiament: $500", x, y, _, _, tocolor( 50, 180, 50, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
			else 
				dxDrawText("Cena za sztukę:\nSkała wapienna: $26\nMiedź: $52\nZłoto: $104\nDiament: $650", x+1.5, y+1.5, _, _, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
				dxDrawText("Cena za sztukę:\nSkała wapienna: $26\nMiedź: $52\nZłoto: $104\nDiament: $650", x, y, _, _, tocolor( 255, 204, 0, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
			end 
		end
	end 
end
addEventHandler("onClientRender", root, onRenderMiningPlaces)

function regenerateMiningPlaces()
	for k,v in ipairs(miningPlaces) do
		v.amount = v.amount+5 
		if v.amount > 100 then v.amount = 100 end 
	end
end
setTimer(regenerateMiningPlaces, 20000, 0)

function sellRocks(hitElement)
	if hitElement == localPlayer then 
		triggerServerEvent("onClientSellRocks", hitElement) 
	end 
end
--------------------------------------------------------------
local lights =
{
	{-3498.12,740.74,36.87},
	{-3485.09,728.04,36.87},
	{-3510.81,728.55,36.87},
	{-3498.12,715.93,36.87},
	{-3474.08,721.13,36.87},
	{-3474.35,709.53,36.87},
	{-3503.06,755.82,36.87}
}
local dynamicLights = {}

local nightModeLoaded = false 

function nightModeCheck() 
	if getElementData(localPlayer, "player:job") ~= "job_mine" then return end 
	
	local x,y,z = getCameraMatrix() 
	local x2,y2,z2 = 2062.51,-491.09,72.28
	if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) > 50 and not nightModeLoaded then 
		nightModeLoaded = true
		exports.dynamic_lighting:setShaderNightMod(true)
		exports.dynamic_lighting:setTextureBrightness(0.08)
	elseif getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 50 and nightModeLoaded then
		nightModeLoaded = false
		exports.dynamic_lighting:setShaderNightMod(false)
		exports.dynamic_lighting:setTextureBrightness(1)
	end
end 
setTimer(nightModeCheck, 500, 0)

function onStart()
	local texture = engineImportTXD(engineLoadTXD("m/katana.txd"), 339)
	local model = engineReplaceModel(engineLoadDFF("m/katana.dff"), 339)
	local int = 0
	local dim = 0 
	
	for k,v in ipairs(lights) do
		table.insert(dynamicLights, exports.dynamic_lighting:createPointLight(v[1], v[2], v[3], 255/255, 153/255, 0/255, 200/255, 5, false))
	end

	addMiningPlaces()


	local sellPed = createPed(1, 2050.42,-495.90,72.75, 36)
	setElementFrozen(sellPed, true)
	addEventHandler('onClientPedDamage', sellPed, cancelEvent)

	local sellPickup = createPickup(2050.32,-495.50,72.75-0.6,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
	addEventHandler('onClientPickupHit', sellPickup, sellRocks) 
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)

function onStop()
	for k,v in ipairs(dynamicLights) do
		exports.dynamic_lighting:destroyLight(v)
	end
end
addEventHandler("onClientResourceStop", resourceRoot, onStop)

fileDelete("c.lua")
