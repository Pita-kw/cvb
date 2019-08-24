hitInfo = {} 
hitInfoTime = 60000 -- skrypt bierze pod uwage obrazenia zadane w ostatnim wyznaczonym okresie milisekund

-- zapis wszystkich info o hitach na graczu
function onPlayerDamage(attacker, attackerWeapon, bodypart, loss)
	if attacker then 
		if not hitInfo[source] then 
			hitInfo[source] = {}
		end 
		
		table.insert(hitInfo[source], {attacker=attacker, damage=loss, tick=getTickCount()})
	end 
end 
addEventHandler("onPlayerDamage", root, onPlayerDamage)

function onPlayerWasted(totalAmmo, killer, killerWeapon, bodypart, stealth)	

	if stealth then
		fadeCamera(source, false, 1)
		setTimer(
		function(source)
			exports["ms-gameplay"]:ms_spawnPlayer(source)
			fadeCamera(source, true, 1)
		end, 5000, 1, source)		
		return
	end
	
	if killer and getElementType(killer) == "player" and killer ~= source then 
		local now = getTickCount()
		local dmgLost = getElementHealth(source)
		local dmgGiven = 0 
		if hitInfo[source] then 
			for k,v in ipairs(hitInfo[source]) do 
				if v.attacker == killer then 
					if now < v.tick+hitInfoTime then 
						dmgLost = dmgLost+v.damage
					end
				end
			end
			
			hitInfo[source] = {} -- oczyszczamy dmg
		end 
		
		if hitInfo[killer] then 
			for k,v in ipairs(hitInfo[killer]) do 
				if v.attacker == source then 
					if now < v.tick+hitInfoTime then 
						dmgGiven = dmgGiven+v.damage
					end
				end
			end
		end 
		if getElementData(source, "player:solo") then return end 
		
		local damageInfo = {lost=dmgLost, given=dmgGiven}
		
		setCameraTarget(source, killer)
		triggerClientEvent(source, "onClientShowKillcam", source, killer, killerWeapon, bodypart, damageInfo, stealth)
	else 
		if getElementData(source, "player:solo") then return end 
		
		triggerClientEvent(source, "onClientShowKillcam", source)
	end
end 
addEventHandler("onPlayerWasted", root, onPlayerWasted)

-- spawn na ENTER po killcamie
function onPlayerRequestSpawn()
	if client then 
		setCameraTarget(client, client)
		
		if getPlayerTeam(client) then 
			if exports["ms-attractions"]:respawnPlayerOnAttraction(client, getTeamName(getPlayerTeam(client))) then 
				return
			end 
		end 
		
		local onArena = getElementData(client, "player:arena") 
		if onArena then 
			exports["ms-arens"]:joinArena(client, onArena, true)
			return
		end 
		
		exports["ms-gameplay"]:ms_spawnPlayer(client)
	end 
end 
addEvent("onPlayerRequestSpawn", true)
addEventHandler("onPlayerRequestSpawn", root, onPlayerRequestSpawn)

-- oczyszczanie pamięci
function refreshHitInfo()
	local now = getTickCount() 
	
	local k = 0
	for i, v in pairs(hitInfo) do 
		k = k+1 
		
		if not isElement(i) then 
			hitInfo[i] = nil 
		else 
			for z, tbl in ipairs(hitInfo[i]) do 
				if now > tbl.tick+hitInfoTime then 
					table.remove(hitInfo[i], z)
				end
			end
		end
	end
	
	collectgarbage("collect")
end 
setTimer(refreshHitInfo, 60000*5, 0)