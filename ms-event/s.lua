local eventDimension = 100 
local eventEnabled = false 
local eventTeleportEnabled = false
local eventPos = {}

local eventGhostmode = false

addCommandHandler("ev", function(player)
	if getElementData(player, "player:rank") > 0 then 
		eventEnabled = not eventEnabled
		if eventEnabled then 
			eventTeleportEnabled = true
			setElementData(resourceRoot, "event:dimension", eventDimension)
			triggerClientEvent(player, "onClientAddNotification", player, "Włączono event.", "info")
		else 
			setElementData(resourceRoot, "event:ghostmode", false)
			eventGhostmode = false 
			
			triggerClientEvent(player, "onClientAddNotification", player, "Wyłączono event.", "info")
			for k, v in ipairs(getElementsByType("player")) do 
				if getElementDimension(v) == eventDimension then 
					setElementDimension(v, 0)
				end
			end
		end
	end
end)

 
addCommandHandler("ev-setdim", function(player, cmd, dim)
	if getElementData(player, "player:rank") > 0 then 
		if not eventEnabled then triggerClientEvent(player, "onClientAddNotification", player, "Event nie jest włączony.", "error") return end
		if not tonumber(dim) then return end 
		
		dim = tonumber(dim)
		if dim == 0 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz ustawić tego dimensiona.", "error")
			return
		end 
		
		eventDimension = dim
		setElementData(resourceRoot, "event:dimension", eventDimension)
		setElementDimension(player, dim)
		triggerClientEvent(player, "onClientAddNotification", player, "Ustawiono dimension "..tostring(dim).." na event.", "info")
	end
 end)
 
addCommandHandler("ev-settp", function(player)
	if getElementData(player, "player:rank") > 0 then 
		if not eventEnabled then triggerClientEvent(player, "onClientAddNotification", player, "Event nie jest włączony.", "error") return end
		
		local x, y, z = getElementPosition(player)
		eventPos = Vector3(x, y, z)
		
		setElementDimension(player, eventDimension)
		triggerClientEvent(player, "onClientAddNotification", player, "Ustawiono teleport na event.", "info")
	end
end)
 
 addCommandHandler("ev-blocktp", function(player)
 	if getElementData(player, "player:rank") > 0 then 
		if not eventEnabled then triggerClientEvent(player, "onClientAddNotification", player, "Event nie jest włączony.", "error") return end
		eventTeleportEnabled = not eventTeleportEnabled 
		if eventTeleportEnabled then 
			triggerClientEvent(player, "onClientAddNotification", player, "Odblokowano teleport na event.", "info")
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Zablokowano teleport na event.", "info")
		end 
	end
 end)
 
addCommandHandler("ev-tp", function(player)
	if getElementData(player, "player:spawned") then 
		if not eventEnabled or not eventTeleportEnabled then triggerClientEvent(player, "onClientAddNotification", player, "Żaden event nie jest włączony.", "error") return end
		if not eventPos then 
			triggerClientEvent(player, "onClientAddNotification", player, "Pozycja eventu nie jest ustalona.", "error") 
			return
		end 
		
		removePedFromVehicle(player)
		setElementPosition(player, eventPos.x, eventPos.y, eventPos.z)
		setElementDimension(player, eventDimension)
		triggerClientEvent(player, "onClientAddNotification", player, "Teleportowałeś się na event.", "info")
	end
end)

addCommandHandler("ev-ghostmode", function(player)
	if getElementData(player, "player:rank") > 0 then 
		if not eventEnabled then triggerClientEvent(player, "onClientAddNotification", player, "Event nie jest włączony.", "error") return end
		
		eventGhostmode = not eventGhostmode
		setElementData(resourceRoot, "event:ghostmode", eventGhostmode)
		
		if eventGhostmode then 
			triggerClientEvent(player, "onClientAddNotification", player, "Włączono ghostmode.", "info")
		else
			triggerClientEvent(player, "onClientAddNotification", player, "Wyłączono ghostmode.", "info")
		end 
	end
end)

addCommandHandler("ev-antydm", function(player, cmd, radius)
	if getElementData(player, "player:rank") > 0 then 
		if isElement(eventAntyDM) then 
			destroyElement(eventAntyDM)
			eventAntyDM = nil
		end 
		
		if not tonumber(radius) or tonumber(radius) == 0 then 
			return
		end
		
		local x, y, z = getElementPosition(player)
		local dim = getElementDimension(player)
		
		eventAntyDM = createElement("antydm")
		setElementPosition(eventAntyDM, x, y, z)
		setElementDimension(eventAntyDM, dim)
		setElementData(eventAntyDM, "radius", tonumber(radius))
		
		triggerClientEvent(player, "onClientAddNotification", player, "Stworzono strefę anty DM.", "info")
	end
end)
