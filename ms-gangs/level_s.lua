LEVEL_MULTIPLIER = 48
KILL_EXP = 1
TAG_EXP = 2
WAR_EXP = 5
 
function giveGangExp(id, exp)
	local gang = getGangIndexFromID(id)
	if gang then
		local gangEXP = gangData[gang].exp
		local gangLevel = gangData[gang].level
		local gangTotalEXP = gangData[gang].totalexp
			
			
		gangEXP = gangEXP+exp
		gangTotalEXP = gangTotalEXP+exp
		if gangEXP >= gangLevel * LEVEL_MULTIPLIER then 
			gangEXP = gangEXP-(gangLevel * LEVEL_MULTIPLIER)
			gangLevel = gangLevel+1 
		end 
			
		gangData[gang].exp = gangEXP
		gangData[gang].totalexp = gangTotalEXP
		gangData[gang].level = gangLevel
	end
end

function addGangKill(id)
	local gang = getGangIndexFromID(id)
	if gang then 
		gangData[gang].kills = gangData[gang].kills+1
	end
end

function addGangDeath(id)
	local gang = getGangIndexFromID(id)
	if gang then 
		gangData[gang].deaths = gangData[gang].deaths+1
	end
end

addEventHandler("onPlayerWasted", root, function(totalAmmo, killer)
	if killer then 
		local gang = getElementData(source, "player:gang")
		local killerGang = getElementData(killer, "player:gang")
		if gang and killerGang then
			if killerGang.id ~= gang.id then 
				addGangDeath(gang.id)
				addGangKill(killerGang.id)
				giveGangExp(killerGang.id, KILL_EXP)
			end
		end
	end
end)