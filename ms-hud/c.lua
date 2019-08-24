--[[
	MultiServer 
	Zasób: ms-hud/c.lua
	Opis: HUD.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]
local screenW, screenH = guiGetScreenSize() 
local zoom = 1.0
local weapon_alpha= 0
--[[
local zoomTable = 
{
	[{1366, 768}] = 1.425,
	[{1280, 720}] = 1.35,
	[{1152, 864}] = 1.3,
}
for k,v in pairs(zoomTable) do 
	if k[1] == screenW and k[2] == screenH then 
		zoom = v
	end 
end 
--]] 
local baseX = 2300
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 


local show = false 
function loadHUD()
	font = dxCreateFont("img/archivo_narrow.ttf", 27/zoom, false, "antialiased")
	
	bgPos = {x=screenW-(560/zoom), y=50/zoom, w=535/zoom, h=130/zoom}
	bgLinePos = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=4/zoom}
	
	-- avatar 
	avatarPos = {x=screenW-(530/zoom), y=bgPos.y+20/zoom, w=95/zoom, h=95/zoom}
	
	-- level 
	bgLevelPos = {x=screenW-(160/zoom), y=bgPos.y+8/zoom, w=120/zoom, h=119/zoom}
	textLevel = {x=screenW-(160/zoom), y=bgPos.y+8/zoom, w=120/zoom, h=119/zoom}
	
	-- nazwa gracza 
	textName = {x=screenW-(415/zoom), y=bgPos.y+18/zoom, w=120/zoom, h=119/zoom}
	
	-- nazwa pojazdu
	
	textVehicleName = {x=screenW-(530/zoom), y=bgPos.y+10/zoom, w=120/zoom, h=119/zoom}
	
	-- przebieg pojazdu
	
	textVehicleMileage = {x=screenW-(530/zoom), y=bgPos.y+50/zoom, w=120/zoom, h=119/zoom}
	
	-- ikonki
	
	nitroIcon = {x=screenW-(540/zoom), y=bgPos.y+78/zoom, w=45/zoom, h=45/zoom}
	jumpIcon = {x=screenW-(465/zoom), y=bgPos.y+80/zoom, w=40/zoom, h=45/zoom}
	engineIcon = {x=screenW-(400/zoom), y=bgPos.y+78/zoom, w=45/zoom, h=45/zoom}
	hpIcon = {x=screenW-(330/zoom), y=bgPos.y+78/zoom, w=45/zoom, h=45/zoom}
	
	-- teksty do ikonek
	
	nitroText = {x=screenW-(495/zoom), y=bgPos.y+90/zoom, w=120/zoom, h=119/zoom}
	jumpText = {x=screenW-(430/zoom), y=bgPos.y+90/zoom, w=120/zoom, h=119/zoom}
	engineText = {x=screenW-(355/zoom), y=bgPos.y+90/zoom, w=120/zoom, h=119/zoom}
	hpText = {x=screenW-(285/zoom), y=bgPos.y+90/zoom, w=120/zoom, h=119/zoom} 
	
	-- czas 
	timeBgPos = {x=bgPos.x, y=200/zoom, w=bgPos.w, h=50/zoom}
	timeBgLinePos = {x=timeBgPos.x, y=timeBgPos.y+timeBgPos.h, w=timeBgPos.w, h=4/zoom}
	textTime = {x=timeBgPos.x, y=timeBgPos.y, w=180/zoom, h=timeBgPos.h}
	
	-- diamenty 
	textDiamonds = {x=bgPos.x, y=200/zoom, w=bgPos.w-50/zoom, h=50/zoom}
	
	-- kasa 
	textMoney = {x=bgPos.x, y=200/zoom, w=bgPos.w+330/zoom, h=50/zoom}
	
	-- bronie 
	weaponBgPos = {x=screenW-(410/zoom), y=100/zoom, w=256/zoom, h=128/zoom}
	textAmmoBig = {x=screenW-(415/zoom), y=bgPos.y+83/zoom, w=120/zoom, h=119/zoom}
	textAmmoSmall = {x=screenW-(365/zoom), y=bgPos.y+89/zoom, w=120/zoom, h=119/zoom}
	textAntyDM = {x=screenW-(415/zoom), y=bgPos.y+89/zoom, w=120/zoom, h=119/zoom}
	
	showEXPEffect = false
	showEXPEffectTick = false
	
	local frames = 0
	local fps = 0 
	local FPSTime = 0 

	gamemodeVersion = getElementData(root, "version")
	addEventHandler("onClientRender", root, function()
		if ( getTickCount() < FPSTime ) then
			frames = frames+1 
		else 
			fps = frames
			frames = 0 
			FPSTime = getTickCount() + 1000
		end 
		
		-- info o wersji	
		dxDrawText("UID: "..tostring(getElementData(localPlayer, "player:uid") or "-").." | FPS: "..tostring(math.floor(fps)).." |", screenW, screenH-14, screenW-85, screenH, tocolor(240, 240, 240, 140), 1, "default", "right", "top", false, false, true)
		dxDrawText("MultiServer "..gamemodeVersion, screenW, screenH-27, screenW-4, screenH, tocolor(240, 240, 240, 140), 1, "default", "right", "top", false, false, true)
	end)
end 

function showHUD(b)
	if not show and b then 
		--blur = exports["ms-blur"]:createBlurBox(bgPos.x, bgPos.y, bgPos.w, bgPos.h, 255, 255, 255, 255, false)
		--blurTime = exports["ms-blur"]:createBlurBox(timeBgPos.x, timeBgPos.y, timeBgPos.w, timeBgPos.h, 255, 255, 255, 255, false)
		addEventHandler("onClientRender", root, onRenderHUD)
	elseif show and not b then
		onClientResourceStop()
	end 
	
	show = b
end 
addEvent("onClientShowHUD", true)
addEventHandler("onClientShowHUD", root, showHUD) 

function onRenderHUD()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(170, 170, 170, 255))
	dxDrawRectangle(bgLinePos.x, bgLinePos.y, bgLinePos.w, bgLinePos.h, tocolor(51, 102, 255, 255), true)
	
		
	-- pasek 2 
	-- czas
	exports["ms-gui"]:dxDrawBluredRectangle(timeBgPos.x, timeBgPos.y, timeBgPos.w, timeBgPos.h, tocolor(170, 170, 170, 255))
	dxDrawRectangle(timeBgLinePos.x, timeBgLinePos.y, timeBgLinePos.w, timeBgLinePos.h, tocolor(51, 102, 255, 255), true)
		
	dxDrawImage(timeBgPos.x, timeBgPos.y + 3/zoom, 45/zoom, 45/zoom, "img/time.png", 0, 0, 0, tocolor(20, 128, 255, 255), true)
		
	-- diamenty 
	dxDrawImage(timeBgPos.x+141/zoom, timeBgPos.y + 3/zoom, 45/zoom, 45/zoom, "img/diamonds.png", 0, 0, 0, tocolor(0, 108, 255, 255), true)
		
	-- kasa 
	dxDrawImage(timeBgPos.x+300/zoom, timeBgPos.y + 3/zoom, 45/zoom, 45/zoom, "img/money.png", 0, 0, 0, tocolor(0, 108, 255, 255), true)
		
	-- teksty
	dxDrawText("$"..comma_value(tostring(getElementData(localPlayer, "player:money") or 0)), textMoney.x, textMoney.y, textMoney.w+textMoney.x, textMoney.y+textMoney.h, tocolor(240, 240, 240, 240), 0.73, font, "center", "center", false, false, true)
			
	local h,m = getTime()
	dxDrawText(string.format("%.02d:%02d", h, m), textTime.x, textTime.y, textTime.w+textTime.x, textTime.y+textTime.h, tocolor(240, 240, 240, 240), 0.73, font, "center", "center", false, false, true)
	dxDrawText(tostring(getElementData(localPlayer, "player:sp") or 0), textDiamonds.x, textDiamonds.y, textDiamonds.w+textDiamonds.x, textDiamonds.y+textDiamonds.h, tocolor(240, 240, 240, 240), 0.73, font, "center", "center", false, false, true)
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then 
		local weapon = getPedWeapon(localPlayer)
		local ammo = getPedTotalAmmo(localPlayer)
		local clip = getPedAmmoInClip(localPlayer)
		ammo = ammo-clip
		-- W JEDYNM WARUNKU I CHUJ NIE CHCIALO MI SIE TABLICY ROBIC XD
		if getElementData(localPlayer, "player:zone") == "antydm" then
			dxDrawText("Anty-DM", textAntyDM.x, textAntyDM.y, textAntyDM.w, textAntyDM.h, tocolor(200, 200, 200, weapon_alpha), 0.65, font, "left", "top", false, false, true)
		else
			if weapon == 16 or weapon == 34 or weapon == 35 or weapon == 36 or weapon == 18 or weapon == 39 or weapon == 17 then
				dxDrawText(string.format("%.02d", ammo), textAmmoBig.x, textAmmoBig.y, textAmmoBig.w, textAmmoBig.h, tocolor(255, 255, 255, 255), 0.9, font, "left", "top", false, false, true)
			else
				if weapon ~= 0 and weapon ~= 1 and weapon ~= 2 and weapon ~= 3 and weapon ~= 4 and weapon ~= 5 and weapon ~= 6 and weapon ~= 7 and weapon ~= 8 and weapon ~= 9 and weapon ~= 11 and weapon ~= 37 and weapon ~= 42 and weapon ~= 10 and weapon ~= 12 and weapon ~= 14 and weapon ~= 15 and weapon ~= 38 and weapon ~= 45 and weapon ~= 46 and weapon ~=  40 and weapon ~= 41 then 
					dxDrawText(string.format("%.02d", clip), textAmmoBig.x, textAmmoBig.y, textAmmoBig.w, textAmmoBig.h, tocolor(255, 255, 255, 255), 0.9, font, "left", "top", false, false, true)
					if weapon ~= 16 and weapon ~= 17 and weapon ~= 18 and weapon ~= 39 and weapon ~= 43 then 
						if #string.format("%.02d", clip) > 2 then
							dxDrawText(string.format("%.02d", ammo), textAmmoSmall.x, textAmmoSmall.y, textAmmoSmall.w, textAmmoSmall.h, tocolor(240, 240, 240, 240), 0.65, font, "left", "top", false, false, true)
						else 
							dxDrawText(string.format("%.02d", ammo), textAmmoSmall.x-15/zoom, textAmmoSmall.y, textAmmoSmall.w, textAmmoSmall.h, tocolor(240, 240, 240, 240), 0.65, font, "left", "top", false, false, true)
						end
					end 
				end 
			end
		end
		
		local weapon = getPedWeapon(localPlayer)
		

		if getElementData(localPlayer, "player:zone") == "gang" then 
			local color = getElementData(localPlayer, "player:zone_color")
			local r, g, b = color[1], color[2], color[3]
			dxDrawImage(weaponBgPos.x, weaponBgPos.y, weaponBgPos.w, weaponBgPos.h, "img/weapons/"..tostring(weapon)..".png", 0, 0, 0, tocolor(r, g, b, weapon_alpha), true)
		elseif getElementData(localPlayer, "player:zone") == "antydm" then
			dxDrawImage(weaponBgPos.x, weaponBgPos.y, weaponBgPos.w, weaponBgPos.h, "img/weapons/"..tostring(weapon)..".png", 0, 0, 0, tocolor(255, 100, 100, 255), true)
		else
			dxDrawImage(weaponBgPos.x, weaponBgPos.y, weaponBgPos.w, weaponBgPos.h, "img/weapons/"..tostring(weapon)..".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		end
		
		local nickColor = getElementData(localPlayer, "player:nickColor") or "#ffffff"
		dxDrawText(nickColor..getPlayerName(localPlayer), textName.x, textName.y, textName.w, textName.h, tocolor(255, 255, 255, 255), 0.73, font, "left", "top", false, false, true, true)
		dxDrawImage(avatarPos.x, avatarPos.y, avatarPos.w, avatarPos.h, exports["ms-avatars"]:loadAvatar(getElementData(localPlayer, "player:uid") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
		local levelAlpha = 240
		local levelText = tostring(getElementData(localPlayer, "player:level") or 1) 
		local levelDesc = "Level"
		local state = "ok"

		-- level 
		local level = getElementData(localPlayer, "player:level") or 1 
			
		local exp = getElementData(localPlayer, "player:exp") or 0 
		local maxEXP = level * 24
		
		local progress = exp / maxEXP
		
		--expMask:draw(bgLevelPos.x, bgLevelPos.y, bgLevelPos.w, bgLevelPos.h)
		--dxDrawImage(bgLevelPos.x, bgLevelPos.y, bgLevelPos.w, bgLevelPos.h, "img/exp_circle.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
		if showEXPEffect then 
			local now = getTickCount() 
			if now >= showEXPEffectTick+5500 then -- pokazanie LVL 
				local progress = ((now-5500) - showEXPEffectTick) / 500
				levelAlpha = interpolateBetween(0, 0, 0, 240, 0, 0, math.min(progress, 1), "OutQuad")
				if progress >= 1 then 
					showEXPEffect = false 
					showEXPEffectTick = false
				end
			elseif now >= showEXPEffectTick+5000 then -- schowanie EXP 
				local progress = ((now-5000) - showEXPEffectTick) / 500
				levelAlpha = interpolateBetween(levelAlpha, 0, 0, 0, 0, 0, math.min(progress, 1), "OutQuad")
				levelText = "+"..tostring(showEXPEffect)
				levelDesc = "Exp"
			elseif now >= showEXPEffectTick+500 then -- pokazywanie EXP
				local progress = ((now-500) - showEXPEffectTick) / 500
				levelAlpha = interpolateBetween(0, 0, 0, 240, 0, 0, math.min(progress, 1), "OutQuad")
				levelText = "+"..tostring(showEXPEffect)
				levelDesc = "Exp"
			else -- schowanie LVL
				local progress = (now - showEXPEffectTick) / 500
				levelAlpha = interpolateBetween(240, 0, 0, 0, 0, 0, math.min(progress, 1), "OutQuad")
			end
		end 
		
		dxDrawImage(math.floor(bgLevelPos.x+3/zoom), math.floor(bgLevelPos.y+5/zoom), math.floor(115/zoom), math.floor(115/zoom), getCircleImage(progress*360), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(levelText, textLevel.x, textLevel.y - 10/zoom, textLevel.w+textLevel.x, textLevel.y+textLevel.h, tocolor(240, 240, 240, levelAlpha), 1, font, "center", "center", false, false, true)
		dxDrawText(levelDesc, textLevel.x - 1/zoom, textLevel.y + 40/zoom, textLevel.w+textLevel.x, textLevel.y+textLevel.h, tocolor(240, 240, 240, levelAlpha), 0.55, font, "center", "center", false, false, true)
	else 
		local vehicleName = getVehicleName(vehicle)
		local mileage = getElementData(vehicle, "vehicle:mileage") or 0
		local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {engine=0, jump=0, hp=0}
		
		
		if getVehicleNitroLevel(vehicle) then
			dxDrawImage(nitroIcon.x, nitroIcon.y, nitroIcon.w, nitroIcon.h, "i/veh/nitro.png", 0, 0, 0, tocolor(66, 182, 244, 255), true)
		else
			dxDrawImage(nitroIcon.x, nitroIcon.y, nitroIcon.w, nitroIcon.h, "i/veh/nitro.png", 0, 0, 0, tocolor(66, 182, 244, 155), true)
		end
		
		
		if getVehicleNitroLevel(vehicle) then
			local nitro = math.floor(100 * getVehicleNitroLevel(vehicle))
			dxDrawText(nitro, nitroText.x, nitroText.y, nitroText.w, nitroText.h, tocolor(240, 240, 240, 240), 0.73, font, "left", "top", false, false, true)
		else
			dxDrawText("0", nitroText.x, nitroText.y, nitroText.w, nitroText.h, tocolor(240, 240, 240, 240), 0.73, font, "left", "top", false, false, true)
		end
		
		if addons.jump == 0 then
			dxDrawImage(jumpIcon.x, jumpIcon.y, jumpIcon.w, jumpIcon.h, "i/veh/jump.png", 0, 0, 0, tocolor(255, 165, 0, 155), true)
		else
			if blink_status_jump == true then
				if jump_blink == false then
					dxDrawImage(jumpIcon.x, jumpIcon.y, jumpIcon.w, jumpIcon.h, "i/veh/jump.png", 0, 0, 0, tocolor(255, 165, 0, 255), true)
				else
					dxDrawImage(jumpIcon.x, jumpIcon.y, jumpIcon.w, jumpIcon.h, "i/veh/jump.png", 0, 0, 0, tocolor(255, 165, 0, 155), true)
				end
			else
				dxDrawImage(jumpIcon.x, jumpIcon.y, jumpIcon.w, jumpIcon.h, "i/veh/jump.png", 0, 0, 0, tocolor(255, 165, 0, 255), true)
			end
		end
		dxDrawText(addons.jump, jumpText.x, jumpText.y, jumpText.w, jumpText.h, tocolor(240, 240, 240, 240), 0.73, font, "left", "top", false, false, true)
		
		if addons.engine == 0 then
			dxDrawImage(engineIcon.x, engineIcon.y, engineIcon.w, engineIcon.h, "i/veh/engine.png", 0, 0, 0, tocolor(0, 255, 4, 155), true)
		else
			dxDrawImage(engineIcon.x, engineIcon.y, engineIcon.w, engineIcon.h, "i/veh/engine.png", 0, 0, 0, tocolor(0, 255, 4, 255), true)
		end
		dxDrawText(addons.engine, engineText.x, engineText.y, engineText.w, engineText.h, tocolor(240, 240, 240, 240), 0.73, font, "left", "top", false, false, true)
		
		if addons.hp == 0 then
			dxDrawImage(hpIcon.x, hpIcon.y, hpIcon.w, hpIcon.h, "i/veh/hp.png", 0, 0, 0, tocolor(255, 238, 0, 155), true)
		else
			dxDrawImage(hpIcon.x, hpIcon.y, hpIcon.w, hpIcon.h, "i/veh/hp.png", 0, 0, 0, tocolor(255, 238, 0, 255), true)
		end
		dxDrawText(addons.hp, hpText.x, hpText.y, hpText.w, hpText.h, tocolor(240, 240, 240, 240), 0.73, font, "left", "top", false, false, true)
		
		local mileage = tostring(math.floor(mileage/1000))
		
		dxDrawText(vehicleName, textVehicleName.x, textVehicleName.y, textVehicleName.w, textVehicleName.h, tocolor(240, 240, 240, 240), 1, font, "left", "top", false, false, true)
		dxDrawText("Przebieg: ".. mileage .." km", textVehicleMileage.x, textVehicleMileage.y, textVehicleMileage.w, textVehicleMileage.h, tocolor(240, 240, 240, 240), 0.65, font, "left", "top", false, false, true)
		local extraHP = getElementData(vehicle, "vehicle:extraHP") or 0 
		local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {hp=0}
		local maxExtraHP = addons.hp*250
		local hp = math.max(0, (getElementHealth(vehicle)-250+extraHP)/(750+maxExtraHP))
		
		dxDrawImage(math.floor(bgLevelPos.x+3/zoom), math.floor(bgLevelPos.y+5/zoom), math.floor(115/zoom), math.floor(115/zoom), getCircleImage(hp*360), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
		dxDrawText(tostring(math.floor(getElementSpeed(vehicle, "km/h"))), textLevel.x, textLevel.y - 10/zoom, textLevel.w+textLevel.x, textLevel.y+textLevel.h, tocolor(240, 240, 240, 255), 1, font, "center", "center", false, false, true)
		dxDrawText("km/h", textLevel.x - 1/zoom, textLevel.y + 40/zoom, textLevel.w+textLevel.x, textLevel.y+textLevel.h, tocolor(240, 240, 240, 255), 0.55, font, "center", "center", false, false, true)
	end
end 


function getInterfacePosition()
	return bgPos.x, bgPos.y, bgPos.w, bgPos.h
end

function getInterfaceZoom()
	return zoom
end 

function onClientGetEXP(exp)
	if showEXPEffect then showEXPEffect = false end 
	
	showEXPEffect = exp
	showEXPEffectTick = getTickCount()
end 
addEventHandler("onClientGetEXP", root, onClientGetEXP)

addCommandHandler("hidehud",
	function()
		showHUD(not show)
	end
)

function onClientResourceStart()
	loadHUD()
	if getElementData(localPlayer, "player:spawned") then 
		showHUD(true)
	end
	
	setPlayerHudComponentVisible("all", false)
	setPlayerHudComponentVisible("crosshair", true)
end 
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)

function onClientResourceStop()
	removeEventHandler("onClientRender", root, onRenderHUD)
end 
addEventHandler("onClientResourceStop", resourceRoot, onClientResourceStop)

function blinkWeapon()
	if weapon_alpha == 0 then
		weapon_alpha = 255 
	else
		weapon_alpha = 0 
	end
end
setTimer (blinkWeapon, 300, 0)

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function blinkVehicleHUD()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local now = getTickCount() 
		local lastUse = getElementData(vehicle, "vehicle:jump_delay_client") or 0 
		
		if lastUse > now then
			blink_status_jump = true
		else
			blink_status_jump = false
		end
		
	end
	
	if blink_status_jump == true then jump_blink = not jump_blink end
end
setTimer(blinkVehicleHUD, 500, 0)