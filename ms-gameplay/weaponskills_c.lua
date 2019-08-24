local allowedWeapons = {
	[22] = 69, -- [id broni] = id ped statu
	[23] = 70,
	[24] = 71,
	[25] = 72,
	[26] = 73,
	[27] = 74,
	[28] = 75,
	[29] = 76,
	[30] = 77,
	[31] = 78,
	[34] = 79
}

function onClientWeaponFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if hitElement and getElementType(hitElement) == "player" then
		if isPedDead(hitElement) then return end 
		
		local stat = allowedWeapons[weapon]
		if stat then 
			local headX, headY, headZ = getPedBonePosition(hitElement, 6)
			local headshot = false
			if getDistanceBetweenPoints3D(hitX, hitY, hitZ, headX, headY, headZ) < 0.2 then 
				headshot = true 
			end 
			
			if getElementData(hitElement, "player:god") or getElementData(hitElement, "player:zone") == "antydm" then 
				return
			end 
			
			triggerServerEvent("onPlayerUpdateWeaponStat", localPlayer, weapon, stat, headshot)
		end
	end
end 
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), onClientWeaponFire)