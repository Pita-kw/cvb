local rockPrice = 10
local copperPrice = 50
local goldPrice = 100
local diamondPrice = 500

function onPlayerDropRock()
	if client then
		-- 40% skała 
		-- 20% miedź
		-- 20% złoto
		-- 20% diament
		local rand = math.random(1, 100)
		if rand <= 80 and rand >= 100 then 
			local player_diamond = getElementData(client, "mine:diamond") or 0
			local diamond = player_diamond + 1
			setElementData(client, "mine:diamond", diamonds)		
		end 
		if rand >= 60 and rand <= 80 then 
			local player_gold = getElementData(client, "mine:gold") or 0
			local gold = player_gold + 1
			setElementData(client, "mine:gold", gold)
		end 
		
		if rand >= 40 and rand <= 60 then 
			local player_copper = getElementData(client, "mine:copper") or 0
			local copper = player_copper + 1
			setElementData(client, "mine:copper", copper)
		end 
		
		if rand <= 40 then 
			local player_rock = getElementData(client, "mine:rock") or 0
			local rock = player_rock + 1
			setElementData(client, "mine:rock", rock)
		end 
	end
end
addEvent("onPlayerDropRock", true)
addEventHandler("onPlayerDropRock", root, onPlayerDropRock)

function onClientSellRocks()
	if client then
		local rockAmount = getElementData(client, "mine:rock") or 0
		local copperAmount = getElementData(client, "mine:copper") or 0
		local goldAmount = getElementData(client, "mine:gold") or 0
		local diamondAmount = getElementData(client, "mine:diamond") or 0 
		

		if rockAmount == 0 and copperAmount == 0 and goldAmount == 0 and diamondAmount == 0 then
			triggerClientEvent(client, "onClientAddNotification", client, "Nie masz żadnych kamieni na sprzedaż!", "error")
		else
			if rockAmount > 0 then setElementData(client, "mine:rock", 0) end 
			if copperAmount > 0 then setElementData(client, "mine:copper", 0) end 
			if goldAmount > 0 then setElementData(client, "mine:gold", 0) end 
			if diamondAmount > 0 then setElementData(client, "mine:diamond", 0) end 
			
			local totalMoney = (rockAmount*rockPrice)+(copperAmount*copperPrice)+(goldAmount*goldPrice)+(diamondAmount*diamondPrice)
			exports["ms-gameplay"]:msGiveMoney(client, totalMoney)
			local totalExp = math.floor(totalMoney/200)
			exports["ms-gameplay"]:msGiveExp(client, totalExp)
			
			if getElementData(client, "player:premium") then
				triggerClientEvent(client, "onClientAddNotification", client, "Za wydobyte kamienie otrzymujesz $"..math.floor(totalMoney + totalMoney * 0.3).." oraz ".. math.floor(totalExp + totalExp * 0.3) .." exp", "success")
			else
				triggerClientEvent(client, "onClientAddNotification", client, "Za wydobyte kamienie otrzymujesz $".. totalMoney .." oraz ".. totalExp .." exp", "success")
			end
			
		end
	end
end
addEvent("onClientSellRocks", true)
addEventHandler("onClientSellRocks", root, onClientSellRocks)

local giveEquipmentCol = createColSphere(2062.51,-491.09,72.28, 10)
function giveEquipment(hitElement)
	if getElementType(hitElement) == "player" and not getElementData(hitElement, "entrance:moving") then 
		if not getElementData(hitElement, "player:spawned") then return end 
		
		takeAllWeapons(hitElement)
		giveWeapon(hitElement, 8, 1)
		setPedWeaponSlot(hitElement, 1)
		
		setElementData(hitElement, "player:job", "job_mine")
		setElementModel(hitElement, 260)
		triggerClientEvent(hitElement, "toggleMineHUDTrigger", hitElement, true)
		setElementData(hitElement, "player:flashlight", true)
		triggerClientEvent(hitElement, "onClientAddNotification", hitElement, "Dodano tobie ekwipunek górnika. Jeżeli chcesz włączyć laterkę naciśnij klawisz L", "info")
		
		setElementData(hitElement, "player:god", true)
	end
end
addEventHandler("onColShapeHit", giveEquipmentCol, giveEquipment)

function removeEquipment(leaveElement)
	if getElementType(leaveElement) == "player" and not getElementData(leaveElement, "entrance:moving") then

		setElementData(leaveElement, "player:job", false)
		setElementData(leaveElement, "player:work", false)
		if not getElementData(leaveElement, "player:skin") then 
			setElementModel(leaveElement, 0)
		else 
			setElementModel(leaveElement, getElementData(leaveElement, "player:skin"))
		end 
		triggerClientEvent(leaveElement, "toggleMineHUDTrigger", leaveElement, false)
		triggerClientEvent(leaveElement, "onClientAddNotification", leaveElement, "Zabrano tobie ekwipunek górnika.", "info")
		setElementData(leaveElement, "player:flashlight", false)
		exports["ms-gameplay"]:givePlayerWeaponLevel(leaveElement)
		
		setElementData(leaveElement, "player:god", false)
	end
end
addEventHandler("onColShapeLeave", giveEquipmentCol, removeEquipment)

function endMineJob(leaveElement)
	if getElementType(leaveElement) == "player" and not getElementData(leaveElement, "entrance:moving") then

		setElementData(leaveElement, "player:job", false)
		setElementData(leaveElement, "player:work", false)
		if not getElementData(leaveElement, "player:skin") then 
			setElementModel(leaveElement, 0)
		else 
			setElementModel(leaveElement, getElementData(leaveElement, "player:skin"))
		end 
		triggerClientEvent(leaveElement, "toggleMineHUDTrigger", leaveElement, false)
		setElementData(leaveElement, "player:flashlight", false)
		exports["ms-gameplay"]:givePlayerWeaponLevel(leaveElement)
		setElementPosition(leaveElement, 2050.48,-491.48,72.3)
		setElementRotation(leaveElement, 122.01)
		setElementData(leaveElement, "player:god", false)
		setElementData(leaveElement, "player:entrance", false)
	end
end
addEvent("endMineJob", true)
addEventHandler("endMineJob", getRootElement(), endMineJob)
