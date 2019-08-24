local LEVEL_MULTIPLIER = 24

addEvent("onPlayerGetEXP", true)

function msGiveExp(player, exp)
	if not exp or not player then return false end
	if getElementData(player, 'player:premium') then
		procent = 0.3 * exp
		exp = math.floor(exp + procent)
	end
	
	if isElement(player) and getElementType(player) == "player" and type(exp) == "number" then 
		local playerEXP = getElementData(player, "player:exp") or 0
		local playerLevel = getElementData(player, "player:level") or 1 
		local playerTotalEXP = getElementData(player, "player:totalEXP") or 0
		
		
		playerEXP = playerEXP+exp 
		playerTotalEXP = playerTotalEXP+exp
		if playerEXP >= playerLevel * LEVEL_MULTIPLIER then 
			playerEXP = playerEXP-(playerLevel * LEVEL_MULTIPLIER)
			playerLevel = playerLevel+1 
		end 
		
		setElementData(player, "player:exp", math.ceil(playerEXP))
		setElementData(player, "player:level", playerLevel)
		setElementData(player, "player:totalEXP", math.ceil(playerTotalEXP))

		triggerClientEvent(player, "onClientGetEXP", player, math.ceil(exp))
	end
end 

function msGetTotalExp(player)
	if player and isElement(player) then 
		local playerEXP = getElementData(player, "player:exp") or 0 
		local playerLevel = getElementData(player, "player:level") or 1 
		local playerTotalEXP = getElementData(player, "player:totalEXP") or LEVEL_MULTIPLIER*playerLevel
		
		return playerTotalEXP - playerEXP
	end
end 

function msGiveMoney(player, money, ignore_vip)
	if not money or not player then return false end
	current_money = getElementData(player, "player:money") or 0
	
	if getElementData(player, 'player:premium') and not ignore_vip then
		procent = 0.3 * money
		give_money = current_money + money + procent
		setElementData(player, "player:money", math.ceil(give_money))
	else
		give_money = current_money + money
		setElementData(player, "player:money", math.ceil(give_money))
	end	
	
	if give_money >= 1000000 then
		exports["ms-achievements"]:addAchievement(player, "Milioner")
	elseif give_money >= 500000 then
		exports["ms-achievements"]:addAchievement(player, "Biznesman III")
		exports["ms-achievements"]:addAchievement(player, "Biznesman II")
		exports["ms-achievements"]:addAchievement(player, "Biznesman I")
	elseif give_money >= 250000 then
		exports["ms-achievements"]:addAchievement(player, "Biznesman II")
		exports["ms-achievements"]:addAchievement(player, "Biznesman I")
	elseif give_money >= 100000 then
		exports["ms-achievements"]:addAchievement(player, "Biznesman I")
	end
end

function msTakeMoney(player, money)
	if not money or not player then return false end
	current_money = getElementData(player, "player:money")
	if current_money == 0 or money < 0 then return end
	take_money = math.max(0, current_money - money)
	setElementData(player, "player:money", math.floor(take_money))
end


