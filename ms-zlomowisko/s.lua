local mysql = exports["ms-database"]
local places = {
	{2182.33,-1987.46,12.55},
	{-1904.75,-1717.79,20.75},
	{208.42,-257.95,0.58},
}

function onResourceStart()
	for k, v in ipairs(places) do 
		local marker = createMarker(v[1], v[2], v[3], "cylinder", 4, 0, 153, 255, 150)
		local blip = createBlipAttachedTo(marker, 34, 2, 255, 0, 0, 255, 0, 300)
		setElementData(blip, 'blipIcon', 'screap')
		local text = createElement("3dtext")
		setElementPosition(text, v[1], v[2], v[3]+2)
		setElementData(text, "text", "Złomowanie pojazdów\nprywatnych")
		addEventHandler("onMarkerHit", marker, onMarkerHit)
	end
end 
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function onMarkerHit(hitElement)
	if getElementType(hitElement) == "player" then 
		local veh = getPedOccupiedVehicle(hitElement)
		if veh then 
			if getElementData(veh, "vehicle:job") then return end 
			if not getElementData(veh, "vehicle:id") then return end 
			if getElementData(veh, "vehicle:owner") ~= getElementData(hitElement, "player:uid") then triggerClientEvent(hitElement, "onClientAddNotification", hitElement, "Ten pojazd nie należy do ciebie!", "error") return end 
			
			local model = getElementModel(veh)
			local query = mysql:getSingleRow("SELECT `price` FROM `ms_vehicleshop` WHERE `model`=?", model)
			local price = query["price"] 
			if not price then return end 
			
			price = price*0.3 
			
			local hp = getElementHealth(veh)/1000
			price = price*hp
			price = math.floor(price)
			
			local nos = getElementData(veh, "vehicle:hasNOS")
			if nos then 
				price = price+10000
			end
			
			local modifiers = getElementData(veh, "vehicle:upgrade_addons") or {engine=0, jump=0, hp=0}
			price = price+(10000*modifiers.engine)
			price = price+(10000*modifiers.jump)
			price = price+(10000*modifiers.hp)
			
			local neon = getElementData(veh, "vehicle:neon")
			if neon then 
				price = price+10000
			end 
			
			triggerClientEvent(hitElement, "onPlayerSellVehicle", hitElement, price, getElementData(veh, "vehicle:id"))
		else 
			triggerClientEvent(hitElement, "onClientAddNotification", hitElement, "Nie jesteś w pojeździe!", "error")
		end 
	end 
end 

function onPlayerSoldVehicle(price, vehicleid)
	if price and vehicleid then 
		for k,v in ipairs(getElementsByType("vehicle")) do 
			if getElementData(v, "vehicle:id") == vehicleid then 
				destroyElement(v)
			end 
		end 
		
		mysql:query("DELETE FROM `ms_vehicles` WHERE `id`=?", vehicleid)
		
		local cash = getElementData(client, "player:money") or 0
		cash = cash+price
		setElementData(client, "player:money", cash)
		
		triggerClientEvent(client, "onClientAddNotification", client, "Za zezłomowanie pojazdu otrzymujesz $"..tostring(price)..".", "success")
	end 
end 
addEvent("onPlayerSoldVehicle", true)
addEventHandler("onPlayerSoldVehicle", root, onPlayerSoldVehicle)