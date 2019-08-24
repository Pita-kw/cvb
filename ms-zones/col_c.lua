addEventHandler("onClientPlayerDamage", localPlayer, function(attacker)
	if source == localPlayer and isElement(attacker) then
		local zone = getElementData(localPlayer, "player:zone")
		if zone == "antydm" then
			cancelEvent()
		end 
		
		if zone == "gang" then 
			local gang = getElementData(localPlayer, "player:gang") or {id=-3}
			local zoneOwner = getElementData(localPlayer, "player:zone_owner")
			if zoneOwner == gang.id then -- jeśli strefa należy do mojego gangu to anuluje damage
				cancelEvent()
			end
		end
	end
end)

function enableZone(type, arg1, arg2, arg3)
	if type == "antydm" then 
		toggleControl("fire", false)
		toggleControl("aim_weapon", false)
		setElementData(localPlayer, "player:zone", "antydm")
	elseif type == "gang" then 
		setElementData(localPlayer, "player:zone", "gang")
		setElementData(localPlayer, "player:zone_name", arg1)
		setElementData(localPlayer, "player:zone_color", arg2)
		setElementData(localPlayer, "player:zone_owner", arg3)
	end
end 

function disableZone(type)
	if type == "antydm" then 
		if not getElementData(localPlayer, "player:boombox") and getElementData(localPlayer, "player:zone") == "antydm" then
			toggleControl("fire", true)
			toggleControl("aim_weapon", true)
		end
		setElementData(localPlayer, "player:zone", false)
	elseif type == "gang" then 
		if getElementData(localPlayer, "player:zone") == "gang" then 
			setElementData(localPlayer, "player:zone", false)
			setElementData(localPlayer, "player:zone_name", false)
			setElementData(localPlayer, "player:zone_color", false)
			setElementData(localPlayer, "player:zone_owner", false)
		end
	end
end 

function checkZones()
	local x, y, z = getElementPosition(localPlayer)
	local int = getElementInterior(localPlayer)
	local dim = getElementDimension(localPlayer)
	
	local foundZone = false
	for k,v in ipairs(getElementsByType("antydm")) do
		local x2, y2, z2 = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		local maxDist = getElementData(v, "distance") or 50 
		local aInt, aDim = getElementInterior(v), getElementDimension(v)
		
		if dist < maxDist and aInt == int and aDim == dim then
			foundZone = true
			break
		end
	end
	
	if foundZone then 
		enableZone("antydm")
	else 
		disableZone("antydm")
	end
	
	local foundZone = false
	for k,v in ipairs(getElementsByType("gangarea")) do
		local x2, y2, z2 = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		local maxDist = getElementData(v, "distance") or 50 
		local aInt, aDim = getElementInterior(v), getElementDimension(v)
		
		if dist < maxDist and aInt == int and aDim == dim then
			foundZone = {getElementData(v, "name"), getElementData(v, "color"), getElementData(v, "owner")}
			break
		end
	end
	
	if foundZone then 
		enableZone("gang", foundZone[1], foundZone[2], foundZone[3])
	else 
		disableZone("gang")
	end
end 
setTimer(checkZones, 100, 0)