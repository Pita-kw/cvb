Core = {} 
Core.attractions = {
	Carball,
	CTF,
	Derby, 
	Race,
	HideNSeek,
	US,
	TDM,
	Berek,
}

function Core.load()
	for k,attraction in ipairs(Core.attractions) do 
		attraction.load()
	end 
	
	addEventHandler("onPlayerQuit", root, function() 
		local states = getElementData(resourceRoot, "attraction:states")
		
		for k, attraction in ipairs(Core.attractions) do 
			local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..attraction.cmd) or {} 
			for i, player in ipairs(attractionStart) do 
				if source == player then 
					table.remove(attractionStart, i)
					setElementData(resourceRoot,  "attraction:start_players_"..attraction.cmd, attractionStart)
					
					if states["starting"][attraction.cmd] and #attractionStart < attraction.minPlayers then 
						states["starting"][attraction.cmd] = false
						setElementData(resourceRoot, "attraction:states", states)
					end 
		
					break
				end
			end 
		end
	end) 
	
	for k,v in ipairs(Core.attractions) do
		setElementData(resourceRoot, "attraction:start_players_"..v.cmd, {})
		setElementData(resourceRoot, "attraction:min_players_"..v.cmd, v.minPlayers)
	end 
	
	for k,v in ipairs(getElementsByType("player")) do 
		setElementData(v, "player:attraction", false)
	end 
	
	setElementData(resourceRoot, "attraction:states", {
		["starting"] = {},
		["started"] = {}
	})
	
	setTimer(Core.updateAttractions, 2000, 0)
end 
addEventHandler("onResourceStart", resourceRoot, Core.load)

function Core.stop()
	for k,v in ipairs(getElementsByType("player")) do 
		if getPlayerTeam(v) then 
			exports["ms-gameplay"]:ms_spawnPlayer(v)
			triggerEvent("stopAttractionMusic", v, v)
		end
	end
	
	for k,attraction in ipairs(Core.attractions) do 
		attraction.stop()
	end
end 
addEventHandler("onResourceStop", resourceRoot, Core.stop)

function Core.initAttraction(attraction)
	local states = getElementData(resourceRoot, "attraction:states") 
	states["starting"][attraction.cmd] = true 
	setElementData(resourceRoot, "attraction:states", states)
	
	setTimer(Core.stopEntries, 15000, 1, attraction)
end

function Core.updateAttractions()
	local states = getElementData(resourceRoot, "attraction:states") 
	
	for k, v in ipairs(Core.attractions) do 
		if states["started"][v.cmd] and #getPlayersInTeam(v.team) == 0 then 
			v.finish()
		end
	end
end 

function Core.endAttraction(attraction)
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:attraction") == attraction.name then 
			setElementData(v, "player:attraction", false)
		end
	end 
	
	local states = getElementData(resourceRoot, "attraction:states") 
	states["started"][attraction.cmd] = nil
	setElementData(resourceRoot, "attraction:states", states)
end

function Core.stopEntries(attraction)
	local states = getElementData(resourceRoot, "attraction:states") 
	if attraction and states["starting"][attraction.cmd] and not states["started"][attraction.cmd] then 
		local attractionStart = getElementData(resourceRoot, "attraction:start_players_"..attraction.cmd) or {} 
		if #attractionStart >= attraction.minPlayers then 
			-- przeniesieni z zapisów do atrakcji
			for k,v in ipairs(attractionStart) do 
				if isElement(v) then 
					setElementData(v, "player:attraction", false)
					
					if isPedDead(v) then 
						triggerClientEvent(v, "onClientAddNotification", v, "Nie zostajesz przeniesiony na atrakcję bo nie żyjesz.", "error")
					elseif getElementData(v, "player:inTuneShop") then 
						triggerClientEvent(v, "onClientAddNotification", v, "Nie zostajesz przeniesiony na atrakcję bo znajdujesz się w tuning shopie.", "error")
					elseif getElementData(v, "player:solo") then 
						triggerClientEvent(v, "onClientAddNotification", v, "Nie zostajesz przeniesiony na atrakcję bo masz solówe gościu. Miej honor.", "error")
					else
						if getElementData(v, "player:arena") then 
							executeCommandHandler("ae", v)
						end 
					
						if getElementData(v, "player:glue") then
							detachElements(v)
							setElementData(v, "player:glue", false)
						end
						
						if getElementData(v, "player:job") then 
							executeCommandHandler("endwork", v)
						end 
					
						setPlayerTeam(v, attraction.team)
						setCameraTarget(v, v)
						setElementInterior(v, 0)
						setElementDimension(v, 0)
						removePedFromVehicle(v)
						setElementVelocity(v, 0, 0, 0)
						setElementData(v, "player:status", "W grze")
						setElementData(v, "player:god", true)
						setElementData(v, "player:zone", false)
						toggleControl(v, "fire", true)
						setTimer(setElementData, 1000, 1, v, "player:god", false)
					end 
				end
			end
			setElementData(resourceRoot, "attraction:start_players_"..attraction.cmd, {})
			
			for k,v in ipairs(Core.attractions) do 
				if v.cmd == attraction.cmd then 
					local states = getElementData(resourceRoot, "attraction:states") 
					states["starting"][attraction.cmd] = nil
					states["started"][attraction.cmd] = true
					setElementData(resourceRoot, "attraction:states", states)
					
					v.start()
					break
				end
			end
		end
	end 
end 

function Core.deleteEntry(player)
	local attractionName = getElementData(player, "player:attraction")
	if not attractionName then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie jesteś zapisany/a na żadną atrakcję!", "error")
		return
	end 
	
	if getPlayerTeam(player) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz zrobić tego podczas atrakcji.", "error")
		return
	end 
	
	local attraction = false 
	for k,v in ipairs(Core.attractions) do 
		if attractionName == v.name then 
			attraction = v
		end
	end 
	
	local players = getElementData(resourceRoot, "attraction:start_players_"..attraction.cmd) or {} 
	
	local states = getElementData(resourceRoot, "attraction:states") 
	if states["starting"][attraction.cmd] and #players-1 < attraction.minPlayers then 
		states["starting"][attraction.cmd] = false
		setElementData(resourceRoot, "attraction:states", states)
	end 
	
	for k,v in ipairs(players) do 
		if v == player then 
			table.remove(players, k)
			triggerClientEvent(player, "onClientAddNotification", player, "Wypisałeś/aś się z atrakcji "..attraction.name.." pomyślnie.", "success")
			
			setElementData(player, "player:attraction", false)
			setElementData(resourceRoot, "attraction:start_players_"..attraction.cmd, players)
			return
		end
	end
end 
addCommandHandler("wypisz", Core.deleteEntry)

function Core.isAttractionRunning(attraction)
	local states = getElementData(resourceRoot, "attraction:states")
	local cmd = attraction.cmd 
	return states["started"][cmd]
end

function Core.respawnPlayerOnAttraction(player, teamName)
	if teamName == "Capture The Flag" or teamName == "Team Deathmatch" then else 
		return false
	end 
	
	local team = getTeamFromName(teamName)
	if team then 
		for k,v in ipairs(Core.attractions) do 
			-- respawn tylko dla wyznaczonych atrakcji
			if v.team == team then 
				v.spawnPlayer(player)
				return true
			end
		end
		outputChatBox("ni ma teamu w pentli")
		return false
	else 
		outputChatBox("ni ma teamu z getTeamFromName")
		return false
	end
end 
respawnPlayerOnAttraction = Core.respawnPlayerOnAttraction -- eksport