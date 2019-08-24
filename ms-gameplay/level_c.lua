addEvent("onClientGetEXP", true)

local LEVEL_MULTIPLIER = 24

function msGetTotalExp(player)
	if player and isElement(player) then 
		local playerLevel = getElementData(player, "player:level") or 1
		local playerTotalEXP = getElementData(player, "player:totalEXP") or 0
		
		return playerTotalEXP
	end
end 