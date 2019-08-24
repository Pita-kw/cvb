local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 


local bgPos = {x=(screenW/2)-450/zoom/2, y=screenH-250/zoom, w=450/zoom, h=64/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.y+bgPos.h, w=bgPos.w, h=2/zoom} 

local damagePos = {x=(screenW/2)-450/zoom/2, y=screenH-175/zoom, w=450/zoom, h=64/zoom}
local damagePosLine = {x=damagePos.x, y=damagePos.y+damagePos.h, w=damagePos.w, h=2/zoom} 

local killcamWeapon, killcamDamage, killcamBodypart, killcamKiller, killcamKillerName = false, false, false, false, false
local killcamAutoRespawn = false 

local bodypartToFriendlyName = {
	[3] = "tors",
	[4] = "tyłek",
	[5] = "lewą rękę",
	[6] = "prawą rękę",
	[7] = "lewą nogę",
	[8] = "prawą nogę",
	[9] = "głowę"
}

function onClientShowKillcam(killer, killerWeapon, bodypart, damageInfo)
	font = dxCreateFont("archivo_narrow.ttf", 25/zoom) 
	
	if isElement(killer) and getElementType(killer) == "player" and killer ~= localPlayer then 
		killerWeapon = getWeaponNameFromID(killerWeapon):gsub("^%l", string.upper)
		bodypart = bodypartToFriendlyName[bodypart] or "???"
		killcamKiller, killcamWeapon, killcamDamage, killcamBodypart, killcamKillerName = killer, killerWeapon, damageInfo, bodypart, getPlayerName(killer)
	end
	
	fadeCamera(false, 0.5)
	setTimer(function()
		fadeCamera(true, 0.5)
		
		if getPlayerTeam(localPlayer) and killcamKiller then -- automatyczny respawn bo gracz jest na atrakcji i ktos go zabil
			killcamAutoRespawn = true
			setTimer(onClientRequestSpawn, 5000, 1)
			addEventHandler("onClientRender", root, renderKillcam)
		elseif getPlayerTeam(localPlayer) and not killcamKiller then -- nie ma sensu marnowac czasu na killcam jak sam sie zabil zjeb
			setTimer(onClientRequestSpawn, 500, 1) 
		else 
			addEventHandler("onClientRender", root, renderKillcam)
		end
	end, 1000, 1)
end 
addEvent("onClientShowKillcam", true)
addEventHandler("onClientShowKillcam", root, onClientShowKillcam)

function onClientRequestSpawn()
	removeEventHandler("onClientRender", root, renderKillcam)
	if isElement(font) then 
		destroyElement(font)
	end 
	
	if killcamBlur then 
		exports["ms-blur"]:destroyBlurBox(killcamBlur)
	end
	
	if killcamBlur2 then 
		exports["ms-blur"]:destroyBlurBox(killcamBlur2)
	end
	
	killcamWeapon, killcamDamage, killcamBodypart, killcamKiller, killcamKillerName = false, false, false, false, false
	killcamAutoRespawn = false 
	
	fadeCamera(false, 0.5)
	setTimer(triggerServerEvent, 500, 1, "onPlayerRequestSpawn", localPlayer) 
end 


function renderKillcam()
	if not isPedDead(localPlayer) then 
		removeEventHandler("onClientRender", root, renderKillcam)
		if isElement(font) then 
			destroyElement(font)
		end 
		
		return
	end 
	
	if getKeyState("space") and not killcamAutoRespawn then 
		onClientRequestSpawn()
		return
	end 
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(230, 230, 230, 255), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
	if killcamKiller and isElement(killcamKiller) then 
		dxDrawImage(bgPos.x, bgPos.y, 64/zoom, 64/zoom, exports["ms-avatars"]:loadAvatar(getElementData(killcamKiller, "player:uid") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(killcamKillerName, bgPos.x+80/zoom, bgPos.y+5/zoom, 0, 0, tocolor(210, 210, 210, 210), 0.8, font, "left", "top", false, true, true)
		dxDrawText("zabił cię z "..killcamWeapon, bgPos.x+80/zoom, bgPos.y+37/zoom, 0, 0, tocolor(180, 180, 180, 180), 0.5, font, "left", "top", false, true, true)
		
		exports["ms-gui"]:dxDrawBluredRectangle(damagePos.x, damagePos.y, damagePos.w, damagePos.h, tocolor(230, 230, 230, 255), true)
		dxDrawRectangle(damagePosLine.x, damagePosLine.y, damagePosLine.w, damagePosLine.h, tocolor(51, 102, 255, 255), true)
		dxDrawText("#A8A8A8Otrzymane obrażenia: #E6E6E6"..tostring(killcamDamage.lost).."#A8A8A8, śmierć przez strzał w #E6E6E6"..killcamBodypart.."#A8A8A8.\nZadane obrażenia: #E6E6E6"..tostring(killcamDamage.given), damagePos.x+10/zoom, damagePos.y+10/zoom, damagePos.w, damagePos.h, tocolor(210, 210, 210, 255), 0.5, font, "left", "top", false, true, true, true)
		
		if killcamAutoRespawn then
			dxDrawText("Automatyczny respawn za moment...", (screenW/2)+1, screenH-96/zoom, (screenW/2)+1, screenH-96/zoom, tocolor(0, 0, 0, 230), 0.7, font, "center", "top", false, true, true, true)
			dxDrawText("Automatyczny respawn za moment...", screenW/2, screenH-95/zoom, screenW/2, screenH-95/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true, true)
		else 
			dxDrawText("Naciśnij SPACJĘ by się zrespawnować.", (screenW/2)+1, screenH-96/zoom, (screenW/2)+1, screenH-96/zoom, tocolor(0, 0, 0, 230), 0.7, font, "center", "top", false, true, true, true)
			dxDrawText("Naciśnij SPACJĘ by się zrespawnować.", screenW/2, screenH-95/zoom, screenW/2, screenH-95/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true, true)
		end
	else 
		dxDrawImage(bgPos.x, bgPos.y, 64/zoom, 64/zoom, exports["ms-avatars"]:loadAvatar(getElementData(localPlayer, "player:uid") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(getPlayerName(localPlayer), bgPos.x+80/zoom, bgPos.y+5/zoom, 0, 0, tocolor(210, 210, 210, 210), 0.8, font, "left", "top", false, true, true)
		dxDrawText("Zabiłeś się!", bgPos.x+80/zoom, bgPos.y+37/zoom, 0, 0, tocolor(180, 180, 180, 180), 0.5, font, "left", "top", false, true, true)
		
		if killcamAutoRespawn then
			dxDrawText("Automatyczny respawn za moment...", (screenW/2)+1, screenH-96/zoom, (screenW/2)+1, screenH-96/zoom, tocolor(0, 0, 0, 230), 0.7, font, "center", "top", false, true, true, true)
			dxDrawText("Automatyczny respawn za moment...", screenW/2, screenH-95/zoom, screenW/2, screenH-95/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true, true)
		else 
			dxDrawText("Naciśnij SPACJĘ by się zrespawnować.", (screenW/2)+1, screenH-96/zoom, (screenW/2)+1, screenH-96/zoom, tocolor(0, 0, 0, 230), 0.7, font, "center", "top", false, true, true, true)
			dxDrawText("Naciśnij SPACJĘ by się zrespawnować.", screenW/2, screenH-95/zoom, screenW/2, screenH-95/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true, true)
		end
	end
end 