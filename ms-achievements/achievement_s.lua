local mysql = exports["ms-database"]

function hasPlayerAchievement(player, title)
	if player and getElementData(player, "player:uid") and title then
		local query = mysql:getRows("SELECT * FROM `ms_achievements` WHERE `accountid`=?", getElementData(player, "player:uid"))
		for _, row in ipairs(query) do
			local achievements = fromJSON(row["achievements"])
			for k, v in ipairs(achievements) do
				if v[1] == title then
					return true
				end
			end
		end
	end
	return false
end

function addAchievement(player, title)
	if player and title then
		local accid = getElementData(player, "player:uid")
		if accid and not hasPlayerAchievement(player, title) then
		
			setTimer ( function()
				exports["ms-gameplay"]:msGiveExp(player, gAchievements[title][2])
				exports["ms-gameplay"]:msGiveMoney(player, gAchievements[title][3])
			end, 500, 1 )

			triggerClientEvent(player, "onClientAddNotification", player, ""..title.."!\nEXP: "..tostring(gAchievements[title][2]).."\nPieniądze: $"..tostring(gAchievements[title][3]), {type="success", custom="image", x=0, y=0, w=40, h=40, image=":ms-achievements/"..gAchievements[title][1]}, 15000)
			local query = mysql:getRows("SELECT * FROM `ms_achievements` WHERE `accountid`=?", accid)
			if #query > 0 then
				local achievements = fromJSON(query[1]["achievements"])
				table.insert(achievements, {title, getRealTime().timestamp})
				mysql:query("UPDATE `ms_achievements` SET `achievements`=? WHERE `accountid`=?", toJSON(achievements), accid)
			else
				mysql:query("INSERT INTO `ms_achievements` VALUES (?, ?, ?)", nil, accid, toJSON({{title, getRealTime().timestamp}}))
			end
		end
	end
end
addEvent("onPlayerAddAchievement", true)
addEventHandler("onPlayerAddAchievement", root, addAchievement)

function getPlayerAchievements(player)
	if player then
		local uid = getElementData(player, "player:uid")
		if uid then
			local query = mysql:getRows("SELECT * FROM `ms_achievements` WHERE `accountid`=?", uid)
			if #query > 0 then
				return fromJSON(query[1]["achievements"])
			else
				return {}
			end
		end
	end
end

-- oskryptowanie osiągnięć
function onPlayerDamage(attacker)
	if attacker and getElementType(attacker) == "player" then addAchievement(source, "Pierwsza krew") end
end
addEventHandler("onPlayerDamage", root, onPlayerDamage)

function onPlayerWasted(totalAmmo, killer)
	if killer then
		addAchievement(source, "Pierwszy zgon")
	end
end
addEventHandler("onPlayerWasted", root, onPlayerWasted)


function nightPlayer()
	local players = getElementsByType("player")
	local time = getRealTime()
	local hour = time.hour
	
	if hour == 3 or hour == 4 or hour == 5 then
		for k,v in ipairs(players) do
			addAchievement(v, "Nocny gracz")
		end
	end
end
setTimer(nightPlayer, 60000, 0)

function sniperAchievement(ammo, killer, weapon, bodypart, stealth)
	if killer and source then
		if getElementType(killer) == "player" then
			local k_x, k_y, k_z = getElementPosition(killer)
			local p_x, p_y, p_z = getElementPosition(source)
			local distance = getDistanceBetweenPoints2D(k_x, k_y, p_x, p_y)
			
			if getElementHealth(killer) < 5 then
				addAchievement(killer, "Farciarz")
			end
			
			if distance > 25 and weapon == 34 then
				addAchievement(killer, "Snajper")
			end
			
			if stealth then 
				addAchievement(killer, "Ninja")
			end
		end
	end
end
addEventHandler("onPlayerWasted", getRootElement(), sniperAchievement)