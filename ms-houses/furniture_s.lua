local mysql = exports["ms-database"]

function loadFurnitureForPlayer(player, house) -- ladowanie obiektow 
	local query = mysql:getRows("SELECT * FROM `ms_furniture` WHERE `houseid`=?", house)
	triggerClientEvent(player, "onPlayerCreateFurniture", player, query)
end 

function deleteFurnitureForPlayer(player) -- wylaczenie z pamieci 
	triggerClientEvent(player, "onPlayerDeleteFurniture", player)
end 

function showFurnitureWindow(player)
	if getElementData(player, "player:houseOwner") then
		local query = mysql:getRows("SELECT * FROM `ms_furniture` WHERE `owner`=? AND `houseid`=?", getElementData(player, "player:uid"), -1)
		triggerClientEvent(player, "onPlayerShowFurnitureWindow", player, query)
	end 
end 

function takeAllFurniture(player, id)
	mysql:query("UPDATE `ms_furniture` SET `owner`=?, `houseid`=? WHERE `houseid`=?", getElementData(player, "player:uid"), -1, id)
	triggerClientEvent(player, "onClientAddNotification", player, "Schowałeś wszystkie meble pomyślnie.", "success")
end 
addEvent("onPlayerTakeFurniture", true)
addEventHandler("onPlayerTakeFurniture", root, takeAllFurniture)

function takeFurniture(player, id)
	mysql:query("UPDATE `ms_furniture` SET `owner`=?, `houseid`=? WHERE `id`=?", getElementData(player, "player:uid"), -1, id)
	triggerClientEvent(player, "onClientAddNotification", player, "Schowałeś mebel pomyślnie.", "success")
end 
addEvent( "deleteObjectHandler", true )
addEventHandler( "deleteObjectHandler", root, takeFurniture)


function onPlayerJoin()
	bindKey(source, "F6", "down", showFurnitureWindow)
end 
addEventHandler("onPlayerJoin", root, onPlayerJoin)

for k,v in ipairs(getElementsByType("player")) do 
	bindKey(v, "F6", "down", showFurnitureWindow)
end 
