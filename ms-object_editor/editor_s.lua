local mysql = exports["ms-database"]

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function addObjectFromEditor(model, x, y, z, rx, ry, rz, int, dim, isFurniture)
	if isFurniture then 
		local checkFurnitureOwner = mysql:getSingleRow("SELECT `houseid` FROM `ms_furniture` WHERE `id`=?", isFurniture)["houseid"]
		if checkFurnitureOwner ~= -1 then -- kurwy spryciarze chca klonowac 
			triggerClientEvent(client, "onClientAddNotification", client, "O ty mały karakanie co chcesz klonować", "error")
			return 
		end 
		
		local pos = toJSON({round(x, 4), round(y, 4), round(z, 4)})
		local rot = toJSON({round(rx, 4), round(ry, 4), round(rz, 4)})
		mysql:query("UPDATE `ms_furniture` SET `pos`=?, `rot`=?, `interior`=?, `dimension`=?, `houseid`=?, `owner`=? WHERE `id`=?", pos, rot, int, dim, getElementData(client, "player:houseOwner"), getElementData(client, "player:uid"), isFurniture)
		exports["ms-houses"]:deleteFurnitureForPlayer(client)
		exports["ms-houses"]:loadFurnitureForPlayer(client, getElementData(client, "player:houseOwner"))
		triggerClientEvent(client, "onClientAddNotification", client, "Mebel postawiony pomyślnie.\nBy go schować, użyj interakcji.", "success")
	else 
		local xml = xmlLoadFile("objects.map")
		if xml == false then 
			xml = xmlCreateFile("objects.map", "map") 
		end
		
		local child = xmlCreateChild(xml, "object")
		xmlNodeSetAttribute(child, "id", "editor-object")
		xmlNodeSetAttribute(child, "model", model)
		xmlNodeSetAttribute(child, "posX", x)
		xmlNodeSetAttribute(child, "posY", y)
		xmlNodeSetAttribute(child, "posZ", z)
		xmlNodeSetAttribute(child, "rotX", rx)
		xmlNodeSetAttribute(child, "rotY", ry)
		xmlNodeSetAttribute(child, "rotZ", rz)
		xmlNodeSetAttribute(child, "interior", int)
		xmlNodeSetAttribute(child, "dimension", dim)
		xmlNodeSetAttribute(child, "collisions", "true")
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
		
		-- synchro
		local obj = createObject(model, x, y, z, rx, ry, rz)
		setElementInterior(obj, int)
		setElementDimension(obj, dim)
		setElementFrozen(obj, true)
		
		outputChatBox("* Obiekt został dodany do pliku objects.map.", client, 0, 255, 0)
	end 
end
addEvent("onEditorCreateObject", true)
addEventHandler("onEditorCreateObject", root, addObjectFromEditor)

local function checkSelect(button, state, clickedElement)
	if not getElementData(source, "player:selectingObject") then return end 
	
	if button == "left" and state == "down" then 
		if clickedElement and getElementType(clickedElement) == "object" then 
			triggerClientEvent(source, "onPlayerSelectNewObject", source, source, false, getElementModel(clickedElement))
			destroyElement(clickedElement) -- gracz edytuje obiekt 
		else
			setElementData(source, "player:selectingObject", false)
			triggerClientEvent(source, "onPlayerSelectNewObject", source, source, false)
			outputChatBox("* To nie jest prawidĹowy obiekt.", source, 0, 255, 0)
		end
	end
end
addEventHandler("onPlayerClick", root, checkSelect)

function osel(player, cmd)
	if getElementData(player, "player:rank") == 3 then 
		outputChatBox("* Wybierz obiekt ktĂłry chcesz zedytowaÄ lewym przyciskiem myszy.", player, 0, 255, 0)
		setElementData(player, "player:selectingObject", true)
		triggerClientEvent(player, "onPlayerSelectNewObject", player, player, true)
	end
end
addCommandHandler("osel", osel)

function onStart()
	for k,v in ipairs(getElementsByType("player")) do 
		setElementData(v, "player:selectingObject", false)
	end
end
addEventHandler("onResourceStart", resourceRoot, onStart)