STAT_PER_PLAYERSHOT = 0.5
STAT_HEADSHOT_BONUS = 1 

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

local statMultiplier = {
	-- [id broni] = mnożnik playershotu i headshotu 
	-- tylko wyjątki
	[22] = 1.75,
	[23] = 2,
	[24] = 2,
	[25] = 2,
	[26] = 2,
	[27] = 2,
	[34] = 3,
}

local notificationThresholds = {
	[100] = true,
	[250] = true, 
	[500] = true,
	[750] = true,
	[999] = true,
}

addEvent("onPlayerUpdateWeaponStat", true)
addEventHandler("onPlayerUpdateWeaponStat", root, function(weapon, stat, headshot)
	if client and weapon and stat then 
		local weapons_skills = getElementData(client, "player:weapons_stats")
		local pStat = weapons_skills[stat]
		if pStat >= 1000 then return end
		
		local multiplier = statMultiplier[weapon] or 1
		pStat = pStat+STAT_PER_PLAYERSHOT*multiplier
		if headshot then 
			pStat = pStat+STAT_HEADSHOT_BONUS*multiplier
		end 
		
		weapons_skills[stat] = pStat
		setElementData(client, "player:weapons_stats", weapons_skills)
		
		if not getElementData(client, "player:arena") and not getElementData(client, "player:solo") then 
			setPedStat(client, stat, pStat)
		end 
		
		if math.random(1, 50) == 1 or notificationThresholds[pStat] then 
			triggerClientEvent(client, "onClientAddNotification", client, "Umiejętności "..getWeaponNameFromID(weapon)..": "..math.floor((pStat/1000)*100).."%", {type="info", custom="progress", value=pStat/1000}, 10000)
		end
	end
end)

function restoreWeaponsSkills(player)
	if not isElement(player) then return end
	
	local weapons_skills = getElementData(player, "player:weapons_stats")
	
	for k,v in pairs(weapons_skills) do
		setPedStat(player, k, v)
	end
end
