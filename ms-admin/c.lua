local maxDistance = 10
local toggle = false

local ajTick = 0 
local screenW, screenH = guiGetScreenSize()
local sx,sy = (screenW/1366), (screenH/768)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

addEventHandler( "onClientRender", root, function()
	if dxGetStatus().VideoMemoryFreeForMTA == 0 then 
	    dxDrawText("Twoja pamięć wideo wolna dla MTA jest równa 0\nNiektóre elementy mogą tobie się niepoprawnie wyświetlać", (20 + 1)*sx, (2 + 1)*sy, (639 + 1)*sx, (16 + 1)*sy, tocolor(0, 0, 0, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("Twoja pamięć wideo wolna dla MTA jest równa 0\nNiektóre elementy mogą tobie się niepoprawnie wyświetlać", 20*sx, 2*sy, 639*sx, 16*sy, tocolor(255, 0, 0, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
	end 
	
	local aj = getElementData(localPlayer, "player:aj") or false 
	if aj then 
		local now = getTickCount()
		local x,y,z = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints3D(x, y, z, 154.35,-1951.48,47.88)
		if dist > 4 then 
			setElementPosition(localPlayer, 154.35,-1951.48,47.88)
			setElementInterior(localPlayer, 0)
			setElementDimension(localPlayer, 0)
		end 
		
		local m, s = getRealTime(aj).minute, getRealTime(aj).second
		if m < 10 then m = "0"..tostring(m) end
		if s < 10 then s = "0"..tostring(s) end

		dxDrawText(tostring(m)..":"..tostring(s), 62*sx, 444*sy, 182*sx, 499*sy, tocolor(200, 0, 0, 255), 3*sx, "default-bold", "center", "top", false, false, false, false, false)
		
		if now >= ajTick then 
			ajTick = getTickCount()+1000 
			aj = aj-1 
			if aj > 0 then 
				setElementData(localPlayer, "player:aj", aj)
			else 
				setElementData(localPlayer, "player:aj", false)
				setElementPosition(localPlayer, 154.84,-1937.15,3.77)
			end 
		end 
	end 
	
	if not toggle then return end
	if getElementData(localPlayer, "player:rank") == 0 then return end
	if not getElementData(localPlayer, "player:uid") then return end

	for k,v in pairs(getElementsByType("player")) do
		if getElementDimension(localPlayer) == getElementDimension(v) and not isPedInVehicle(v) then
			local id = getElementData(v, "player:uid") or "niezalogowany"
			local x,y,z = getElementPosition(v)
			z = z+0.2
			local x2, y2, z2 = getElementPosition(localPlayer)
			local distance = getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 )
			if distance <= maxDistance then
				local x, y = getScreenFromWorldPosition( x, y, z )
				if x and y then
					local hp = getElementHealth(v)
					local god = getElementData(v, "player:god")
					local god_results = false
					
					if god then
						god_results = "tak"
					else
						god_results = "nie"
					end
					local plr = "UID: "..id.."\nHP: "..tostring(hp).."\nGOD: ".. god_results ..""
					dxDrawText(plr, x-1, y-1, _, _, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
					dxDrawText(plr, x, y, _, _, tocolor( 100, 100, 200, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
				end
			end
		end
	end

	for k,v in pairs(getElementsByType("vehicle")) do
		if getElementDimension(localPlayer) == getElementDimension(v) then
			local id = getElementData(v, "vehicle:id")

			if id then
				local x,y,z = getElementPosition(v)
				z = z+0.2
				local x2, y2, z2 = getElementPosition(localPlayer)
				local distance = getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 )
				if distance <= maxDistance then
					local x, y = getScreenFromWorldPosition( x, y, z )
					if x and y then
						local hp = getElementHealth(v)
						local owner = getElementData(v, "vehicle:owner")
						
						local locked = isVehicleLocked(v)
						if locked then locked = "tak" else locked = "nie" end
						local lastDriver = getElementData(v, "vehicle:lastDriver") or "brak"
						
						local veh = "Pojazd prywatny\nUID: "..tostring(id).."\nHP: "..tostring(hp).."\nUID Właściciela: "..tostring(owner).."\nZamknięty: "..locked.."\nOstatni kierowca: "..tostring(lastDriver)
						dxDrawText(veh, x-1, y-1, _, _, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
						dxDrawText(veh, x, y, _, _, tocolor( 100, 100, 200, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
					end
				end
			else
				local x,y,z = getElementPosition(v)
				local x2, y2, z2 = getElementPosition(localPlayer)
				local distance = getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 )
				if distance <= maxDistance then
					local x, y = getScreenFromWorldPosition( x, y, z )
				
					if x and y then
						local hp = getElementHealth(v)
						local locked = isVehicleLocked(v)
						if locked then locked = "tak" else locked = "nie" end
						local lastDriver = getElementData(v, "vehicle:lastDriver") or "brak"
						local spawner = getElementData(v, "vehicle:spawner") or "?"
						
						local veh = "Pojazd publiczny\nZespwanowany przez: ".. spawner .."\nOstatni kierowca: ".. lastDriver .."\nHP: ".. hp .."\nZamknięty: ".. locked ..""
						
						dxDrawText(veh, x-1, y-1, _, _, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "center", "center", false, false, false, true )
						dxDrawText(veh, x, y, _, _, tocolor( 100, 100, 200, 255 ), 1, "default-bold", "center", "center", false, false, false, true )						
					end
				end
			end
		end
	end
end)

addCommandHandler("aview",function()
	if getElementData(localPlayer, "player:rank") ~= 0 then
		toggle = not toggle
		if toggle then
			outputChatBox("* Tryb wyświetlania danych o elementach włączony.", 0, 255, 0)
		else
			outputChatBox("* Tryb wyświetlania danych o elementach włyączony.", 0, 255, 0) 
		end
	end
end)

addCommandHandler("ram", function()
	outputChatBox("* VideoMemoryFreeForMTA: "..tostring(dxGetStatus().VideoMemoryFreeForMTA))
	outputChatBox("* Video Card RAM: "..tostring(dxGetStatus().VideoCardRAM))
end)


local index = 0

function showRacePos()
	local occupied_vehicle = getPedOccupiedVehicle(localPlayer)
	if not occupied_vehicle then
		outputChatBox("Wsiądź do jakiegoś pojazdu")
		return
	end
	local occupied_id = getElementModel(occupied_vehicle)
	local x,y,z = getElementPosition(occupied_vehicle)
	local rx,ry,rz = getElementRotation(occupied_vehicle)
	local vehicle = createVehicle(occupied_id, x,y,z, rx,ry,rz)
	local vehicle_name = getVehicleName(vehicle)
	local dim = getElementDimension(localPlayer)
	setElementDimension(vehicle, dim)
	setElementCollidableWith(occupied_vehicle, vehicle, false)
	outputChatBox('<spawnpoint id="spawnpoint ('.. vehicle_name ..') ('.. index ..')" vehicle="496" alpha="255" interior="0" posX="'.. x ..'" posY="'.. y ..'" posZ="'.. z ..'" rotX="'.. rx ..'" rotY="'.. ry ..'" rotZ="'.. rz ..'"></spawnpoint>', player)
	index = index + 1
end
addCommandHandler("spawnpos", showRacePos)




function checkPlayerForGod ( attacker, weapon, bodypart )
	if getElementData(source, "player:god") then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", localPlayer, checkPlayerForGod )



local active_admin_unspawner = false
local unspawn_element = false

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

function toggleAdminUnspawnVehicle(button, press)
   if button == "h" and getElementData(localPlayer, "player:rank") > 0 and isPedAiming(localPlayer) then
		if press then
			if unspawn_element then
				if getElementData(unspawn_element, "vehicle:exchange") then
					triggerEvent("onClientAddNotification", localPlayer, "Nie możesz odspawnować pojazdu który jest na giełdzie!", "warning")
					return
				end

				if getElementData(unspawn_element, "vehicle:id") then
					triggerServerEvent("destroyVehicleOrRespawn", localPlayer, unspawn_element, "unspawn")
					triggerEvent("onClientAddNotification", localPlayer, "Pojazd został odspawnowany!", "success")
					return
				end
				
				if getElementData(unspawn_element, "vehicle:server") then
					triggerServerEvent("destroyVehicleOrRespawn", localPlayer, unspawn_element, "respawn")
					triggerEvent("onClientAddNotification", localPlayer, "Pojazd został zrespawnowany!", "respawn")
					return
				end
				
				triggerServerEvent("destroyVehicleOrRespawn", localPlayer, unspawn_element, "delete")
			else
				triggerEvent("onClientAddNotification", localPlayer, "Wyceluj w pojazd w który chcesz odspawnować!", "warning")
			end
		end
	end
end
addEventHandler("onClientKey", root, toggleAdminUnspawnVehicle)

function adminUnspawnVehicle ( target )
	if target and isPedAiming(localPlayer) then
		if getElementType(target) == "vehicle" then 
			unspawn_element = target
		end
	else
		unspawn_element = false
	end
end
addEventHandler ( "onClientPlayerTarget", getRootElement(), adminUnspawnVehicle )



function showVehiclesBlips()
	for k,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:id") then
			local x,y,z = getElementPosition(v)
			local blip = createBlip(x,y,z)
			setElementData(blip, 'blipIcon', 'mission_target')
			outputChatBox("Lokalizowanie pojazdu o ID: ".. getElementData(v, "vehicle:id") .."")
		end
	end
end
addCommandHandler("vehiclesblips", showVehiclesBlips)


function updateMuteTime()
	if not getElementData(localPlayer, "player:spawned") then return end
	
	local mute_time =  getElementData(localPlayer, "player:blockChat")
	
	if mute_time then
		if mute_time > 0 then
			mute_time = mute_time - 1000 
			setElementData(localPlayer, "player:blockChat", mute_time)
			outputChatBox(mute_time)
		end
	end
end
setTimer(updateMuteTime, 1000, 0)