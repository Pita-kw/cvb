local boomboxes = {} 

function createBoombox(player, create)
	if create then 
		local x,y,z = getElementPosition(player)
		boomboxes[player] = {}
		boomboxes[player].object = createObject(2226, x, y, z) 
		setElementInterior(boomboxes[player].object, getElementInterior(player))
		setElementDimension(boomboxes[player].object, getElementDimension(player))
		setObjectScale(boomboxes[player].object, 0.7)
		exports["bone_attach"]:attachElementToBone(boomboxes[player].object,player,11,0.05,0,0.32,0,180,0)
	else 
		if boomboxes[player] then 
			exports["bone_attach"]:detachElementFromBone(boomboxes[player].object)
			triggerClientEvent(root, "onClientDeleteBoombox", root, player)
			if isElement(boomboxes[player].object) then
				destroyElement(boomboxes[player].object)
				boomboxes[player] = false 
			else
				boomboxes[player] = false 
			end
		end 
	end 
end 

function onQuit()
	createBoombox(source, false)
end 
addEventHandler("onPlayerQuit", root, onQuit)

function onPlayerBoomboxToggle(player, title, url)
	if not url and not getElementData(player, "player:boombox") then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie podałeś linku odtwarzania!", "error")
		return
	end
	
	if getPedOccupiedVehicle(player) then
		triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz używać boomboxa w pojeździe!", "error")
		return 
	end
	
	if not getElementData(player, "player:boombox") then
		setElementData(player, "player:boombox", url)
		
		if url:find("youtube") then 
			url = "http://www.youtubeinmp3.com/fetch/?video=".. url .."" 
		end 
		
		triggerClientEvent(root, "onClientPlayBoombox", root, player, url)
		triggerClientEvent(player, "onClientAddNotification", player, "Zacząłeś odtwarzanie na boomboxie: "..tostring(title)..".", "info", 5000, false)
		createBoombox(player, true)
		if not getElementData(player, "player:zone") then
			toggleControl(player,"fire", false)
			toggleControl(player,"aim_weapon", false)
		end
	else
		triggerClientEvent(root, "onClientDeleteBoombox", root, player)
		createBoombox(player, false)
		setElementData(player, "player:boombox", false)
		if not getElementData(player, "player:zone") then
			toggleControl(player,"fire", true)
			toggleControl(player,"aim_weapon", true)
		end
	end
end
addEvent("onPlayerBoomboxToggle", true)
addEventHandler("onPlayerBoomboxToggle", root, onPlayerBoomboxToggle)

function destroyBoomboxOnVehicle(player)
	if getElementData(player, "player:boombox") then
		triggerClientEvent(root, "onClientDeleteBoombox", root, player)
		createBoombox(player, false)
		setElementData(player, "player:boombox", false)
		toggleControl(player,"fire", true)
		toggleControl(player,"aim_weapon", true)
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), destroyBoomboxOnVehicle)
addEventHandler("onVehicleEnter", getRootElement(), destroyBoomboxOnVehicle)