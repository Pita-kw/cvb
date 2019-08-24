local mysql = exports["ms-database"]

function toggleFurnitureShop(hitElement)
	if getElementData(hitElement, "player:inFurnitureMenu") == true then return end
	if hitElement then
		if getElementData(hitElement, "player:inFurnitureShop") then 
			triggerClientEvent(hitElement, "onPlayerEnterFurnitureShop", hitElement)
			return
		end 
		
		fadeCamera(hitElement, false, 0.5)
		setTimer(
		function()
			local query = mysql:getRows("SELECT * FROM `ms_furnitureshop`")
			triggerClientEvent(hitElement, "onPlayerEnterFurnitureShop", hitElement, query)
			fadeCamera(hitElement, true, 0.5)
			toggleAllControls(hitElement, false)
		end, 500, 1)
	end
end


function onPlayerBuyFurniture(object, price, type)
	if client and object and price and type then
		exports["ms-gameplay"]:msTakeMoney(client, price)
		mysql:query("INSERT INTO `ms_furniture` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", nil, object, type, -1, getElementData(client, "player:uid"), "[[ ]]", "[[ ]]", -1, -1)
		exports["ms-achievements"]:addAchievement(client, "Architekt")
		triggerClientEvent(client, "onClientAddNotification", client, "Zakupiłeś mebel za $"..tostring(price)..".\nZnajdziesz go w schowku na meble.", "success", 5000)
	end
end
addEvent("onPlayerBuyFurniture", true)
addEventHandler("onPlayerBuyFurniture", root, onPlayerBuyFurniture)
