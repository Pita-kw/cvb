-- ###############################
-- ## Name: CZombie.lua			##
-- ## Author: Noneatme			##
-- ## Version: 1.0				##
-- ## Lizenz: Freie Benutzung	##
-- ###############################

local cFunc = {}
local cSetting = {}

addEvent("onZombieAttack", true)
addEvent("onZombieSpawnPosGet", true)
addEvent("onZombieWall", true)
addEvent("doZombieCanSeeCheck", true)
addEvent("doZombieSound", true)

cSetting["zomb_jumping"] = {}
-- Functions --

cFunc["attack_zombie"] = function(zomb, bool, target)
	local s = setPedControlState(zomb, "fire", bool)
	setTimer(function()
		setPedControlState(zomb, "fire", false)
	end, 300, 1)
end

cFunc["zombie_wall"] = function(zomb, target)
	local x1, y1, z1 = getElementPosition(zomb)
	local x2, y2, z2 = getElementPosition(target)
	local hit, x3, y3, z3 = processLineOfSight(x1, y1, z1, x2, y2, z2, true, true, false, true, false)
	if(hit) and (cSetting["zomb_jumping"][zomb] ~= true) and (getDistanceBetweenPoints3D(x1, y1, z1, x3, y3, z3) < 2) then
		setPedAnimation(zomb)
		setPedControlState(zomb, "jump", true)
		
		if(getElementData(zomb, "target") == localPlayer) then
			setElementData(zomb, "jumping", true);
		end
		
		cSetting["zomb_jumping"][zomb] = true
		
		setTimer(function()
			setPedControlState(zomb, "jump", false)
			cSetting["zomb_jumping"][zomb] = false
			if(getElementData(zomb, "target") == localPlayer) then
				setElementData(zomb, "jumping", false);
			end
		end, 1500, 1)
	end
end

cFunc["zombie_damage"] = function(attacker, weapon, bodypart)
	if(getElementData(source, "zombie") == true) then
		if(attacker) then
			if(getElementType(attacker) == "player") then
				triggerServerEvent("onZombieHit", source, attacker)
			elseif(getElementType(attacker) == "vehicle") then
				if(getVehicleOccupant(attacker)) and (getElementType(getVehicleOccupant(attacker))) then
					triggerServerEvent("onZombieHit", source, getVehicleOccupant(attacker))
				end
			end
			if(bodypart == 9) then
				setPedHeadless(source, true)
			end
			if(attacker == localPlayer) then
				if(bodypart == 9) and (isShotgun(weapon)) then
					triggerServerEvent("doZombieWasted", localPlayer, source)
				end
			end
		end
	end
end

cFunc["zombie_spawnpos"] = function(x, y, a)
	local z = getGroundPosition(x, y, 100)+0.5
	triggerServerEvent("doSpawnZombie", getLocalPlayer(), x, y, z, a)
end


cFunc["check_if_can_see"] = function(zombie)
	setPedVoice(zombie, "PED_TYPE_DISABLED")

	local x1, y1, z1 = getElementPosition(getLocalPlayer())
	local x2, y2, z2 = getElementPosition(zombie)
	local hit, x3, y3, z3 = processLineOfSight(x1, y1, z1, x2, y2, z2, true, true, false, true, false)
	
	if(hit) then -- Nope
		triggerServerEvent("onZombieBigColHit", zombie, getLocalPlayer(), false)
		
	else
		local angle = ( 360 - math.deg ( math.atan2 ( ( x1 - x2 ), ( y1-y2 ) ) ) ) % 360
		
		angle = angle-getPedRotation(zombie)
		
		
		if((angle < 100 and angle > 0) or (angle > -100 and angle < 0)) then

			triggerServerEvent("onZombieBigColHit", zombie, getLocalPlayer(), true)
		else
			triggerServerEvent("onZombieBigColHit", zombie, getLocalPlayer(), false)
		end
	end

		
end
 
cFunc["play_zombie_sound"] = function(zombie, sound)
	local x1, y1, z1 = getElementPosition(zombie)
	local x2, y2, z2 = getElementPosition(localPlayer)
	
	if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 50) then
		local sound = playSound3D("files/sounds/"..sound..".mp3", x1, y1, z1);
		setSoundMaxDistance(sound, 50)
		setSoundVolume(sound, 0.5)
		attachElements(sound, zombie);
		setElementDimension(sound, 666)
	end
end

cFunc["play_wastedsound"] = function(killer)
	if(killer) and (getElementData(killer, "zombie") == true) then
 		cFunc["play_zombie_sound"](killer, "player_dead");
 	end
end
isShotgun = function(id)
	if(id == 25) or (id == 26) or (id == 27) then
		return true
	else
		return false
	end
end



-- Event Handler --

addEventHandler("onZombieAttack", getLocalPlayer(), cFunc["attack_zombie"])
addEventHandler("onZombieWall", getLocalPlayer(), cFunc["zombie_wall"])
addEventHandler("onClientPedDamage", getRootElement(), cFunc["zombie_damage"])
addEventHandler("onClientPlayerWasted", getRootElement(), cFunc["play_wastedsound"])
addEventHandler("onZombieSpawnPosGet", getLocalPlayer(), cFunc["zombie_spawnpos"])
addEventHandler("doZombieCanSeeCheck", getLocalPlayer(), cFunc["check_if_can_see"])
addEventHandler("doZombieSound", getLocalPlayer(), cFunc["play_zombie_sound"])