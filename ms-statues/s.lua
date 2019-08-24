local STATUE_MONEY = 2000
local STATUE_EXP = 20

local mysql=exports['ms-database']

function loadStatues()
	local statues=mysql:getRows("SELECT * FROM `ms_statues`")
	local statues_count = 0
	
	for k,v in ipairs(statues) do
		local statue = createPickup(v.x, v.y, v.z, 3, 1276)
		setElementInterior(statue, v.interior)
		setElementDimension(statue, v.dimension)
		setElementData(statue, "statue:id", v.id)
		addEventHandler("onPickupHit", statue, giveRewardForStatue)
		statues_count = statues_count + 1
	end
	
	outputDebugString("[ms-statues] Wczytano ".. statues_count .." figurek")
end
addEventHandler("onResourceStart", resourceRoot, loadStatues)

function giveRewardForStatue(player)
	local statue_id = getElementData(source, "statue:id")
	
	if statue_id then
		local query=mysql:query("DELETE FROM `ms_statues` WHERE `id`=?", statue_id)
		destroyElement(source)
		exports["ms-gameplay"]:msGiveMoney(player, STATUE_MONEY)
		exports["ms-gameplay"]:msGiveExp(player, STATUE_EXP)
		
		if getElementData(player, "player:premium") then
			triggerClientEvent(player, "onClientAddNotification", player, "Znalazłeś figurkę! Otrzymujesz ".. math.floor(STATUE_MONEY + STATUE_MONEY * 0.3) .."$ oraz ".. math.floor(STATUE_EXP + STATUE_EXP * 0.3) .." exp ", "info")
		else
			triggerClientEvent(player, "onClientAddNotification", player, "Znalazłeś figurkę! Otrzymujesz ".. STATUE_MONEY .."$ oraz ".. STATUE_EXP .." exp ", "info")
		end
	end
end


function createStatue(player)
	if getElementData(player, "player:rank") ~= 3 then return end
	
	local x,y,z = getElementPosition(player)
	local interior = getElementInterior(player)
	local dimension = getElementDimension(player)
	
	local query=mysql:query("INSERT INTO `ms_statues` (`id`, `x`, `y`, `z`, `interior`, `dimension`) VALUES (?, '?', '?', '?', '?', '?')", nil, x, y, z, interior, dimension)
	triggerClientEvent(player, "onClientAddNotification", player, "Dodałeś figurkę, będzie ona widoczna po restarcie skryptu.", "info")
end
addCommandHandler("addstatue", createStatue)