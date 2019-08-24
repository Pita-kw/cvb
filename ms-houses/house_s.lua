local mysql = exports["ms-database"]
local houses = {} 

function isElementWithinPickup(theElement, thePickup)
	if (isElement(theElement) and getElementType(thePickup) == "pickup") then
		local x, y, z = getElementPosition(theElement)
		local x2, y2, z2 = getElementPosition(thePickup)
		if (getDistanceBetweenPoints3D(x2, y2, z2, x, y, z) <= 1) then
			return true
		end
	end
	return false
end

class "CHouse"
{
	__init__ = function(self, data)
		self.id = data["id"]
		self.data = data 
		self.enterX, self.enterY, self.enterZ = data["enterX"], data["enterY"], data["enterZ"]
		self.locked = data["locked"] == 1
		self.pickup = createPickup(self.enterX, self.enterY, self.enterZ, 3, 1272, 1)
		setElementData(self.pickup, "house", true)
		if self.data["owner"] == -1 then 
			setElementData(self.pickup, "house:ownerName", self.data["name"])
			setPickupType(self.pickup, 3, 1273, 1)
		else 
			setElementData(self.pickup, "house:ownerName", "Dom gracza #3498db"..self.data["ownerName"])
			setPickupType(self.pickup, 3, 1272, 1)
		end 
		addEventHandler("onPickupHit", self.pickup, function(player) if isPedInVehicle(player) then return end triggerClientEvent(player, "onClientShowHouseWindow", player, self.data) end)
		
		self.text = createElement("3dtext")
		setElementPosition(self.text, self.enterX, self.enterY, self.enterZ+0.5)
		setElementData(self.text, "text", getElementData(self.pickup, "house:ownerName"))
		
		self.interiorid = data["interiorid"]
		self.exitX, self.exitY, self.exitZ = getTeleportPosition(self.interiorid)
		self.exitpickup = createPickup(self.exitX, self.exitY, self.exitZ, 3, 1318, 100)
		setElementInterior(self.exitpickup, isFurnitureDisabled(self.interiorid) and 200 or getInteriorObjects(self.interiorid))
		setElementDimension(self.exitpickup, self.id)
		addEventHandler("onPickupHit", self.exitpickup, function(player) triggerClientEvent(player, "onClientAddNotification", player, "By wyjść, kliknij klawisz 'E'.", "info") end)
		
		self:refresh()
	end, 
	
	refresh = function(self, ignoreSQL)
		if not ignoreSQL then
			self.data = mysql:getRows("SELECT * FROM `ms_houses` WHERE `id`=?", self.id)[1]
		end 
		
		if self.data["owner"] ~= -1 then 
			local now = getRealTime().timestamp 
			if now > self.data["timestamp"] then 
				self.data["owner"] = -1 
				self.data["ownerName"] = ""
				self.data["roommates"] = toJSON({}) 
				self.data["locked"] = 0 
				self.data["timestamp"] = 0 
				
				mysql:query("UPDATE `ms_houses` SET `owner`=?, `ownerName`=?, `roommates`=?, `locked`=?, `timestamp`=? WHERE `id`=?", -1, "", toJSON({}), 0, 0, self.id)
				mysql:query("DELETE FROM `ms_furniture` WHERE `houseid`=?", self.id)
				outputDebugString("usuwam domek "..tostring(self.id))
			end 
		end
		
		if self.data["owner"] ~= -1 then 
			setElementData(self.pickup, "house:ownerName", "Dom gracza #0099FF"..self.data["ownerName"])
			setPickupType(self.pickup, 3, 1272, 1)
			setElementData(self.pickup, "house:owner", self.data["owner"])
			setElementData(self.text, "text", getElementData(self.pickup, "house:ownerName"))
		else 
			setElementData(self.pickup, "house:ownerName", self.data["name"])
			setPickupType(self.pickup, 3, 1273, 1)
			setElementData(self.pickup, "house:owner", self.data["owner"])
			setElementData(self.text, "text", self.data["name"])
			mysql:query("DELETE FROM `ms_furniture` WHERE `houseid`=?", self.id)
		end 
		
		self.data["disabledFurniture"] = isFurnitureDisabled(self.data["interiorid"])
	end, 
	
	isRoommate = function(self, player)
		for k,v in ipairs(fromJSON(self.data["roommates"])) do 
			if v[2] == getElementData(player, "player:uid") then 
				return true 
			end 
		end 
		
		return false 
	end, 
	
	onEnter = function(self, player)
		if self.locked then 
			triggerClientEvent(player, "onClientAddNotification", player, "Ten dom jest zamknięty.", "error")
			return 
		end 
		
		fadeCamera(player, false)
		if getElementData(player, "player:uid") == self.data["owner"] or self:isRoommate(player) then 
			setElementData(player, "player:houseOwner", self.id)
			triggerClientEvent(player, "onClientAddNotification", player, "Edycja mebli: F6\nZamawianie mebli: F7", "info", 5000)
			bindKey(player, "F7", "down", toggleFurnitureShop)
		end
		
		triggerEvent("onAuthLoadHouse", source, self.id)
		triggerClientEvent(player, "onCreateInteriorObjects", player, getInteriorObjects(self.data["interiorid"]), self.id)
		
		setElementData(player, "block:player_teleport", true)
		setTimer(
			function(player)
				setElementData(player, "player:inHouse", self.id)
				fadeCamera(player, true)
			end, 1000, 1, player)
	end, 
	
	onExit = function(self, player)
		if not isElementWithinPickup(player, self.exitpickup) then return end 
		
		fadeCamera(player, false)
		setElementData(player, "player:houseOwner", false)
		setElementData(player, "player:inHouse", false)
		deleteFurnitureForPlayer(player)
		unbindKey(player, "F7", "down", toggleFurnitureShop)
		
		setTimer(
			function(player)
				setElementData(player, "block:player_teleport", false)
				setElementPosition(player, self.enterX, self.enterY, self.enterZ)
				setElementDimension(player, 0)
				setElementInterior(player, 0)
				fadeCamera(player, true)
				triggerClientEvent(player, "onDeleteInteriorObjects", player)
			end, 1000, 1, player)
	end,
	
	onBuy = function(self, player, type, length)
		local check = mysql:getSingleRow("SELECT `owner` FROM `ms_houses` WHERE `id`=?", self.data["id"])
		if check then 
			if check["owner"] ~= -1 then 
				triggerClientEvent(player, "onClientAddNotification", player, "Ten dom jest już wykupiony.", "error", 4000)
				return 
			end 
		end 
		
		if getElementData(player, "player:level") < 10 then 
			triggerClientEvent(player, "onClientAddNotification", player, "By kupić dom musisz mieć conajmniej 10 level.", "error")
			return
		end 
		
		local uid = getElementData(player, "player:uid")
		local owning = 0 
		for k, v in ipairs(houses) do 
			if v.data.owner == uid then 
				owning = owning+1 
			end
		end 
		
		if owning >= 5 then 
			triggerClientEvent(player, "onClientAddNotification", player, "Możesz posiadać maksymalnie 5 domków.", "error")
			return
		end
		
		if type == 1 then -- kasa  
			local cost = self.data["price"]
			local money = getElementData(player, "player:money") or 0
			if money < cost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie stać cię na kupno tego domu.", "error", 4000)
				return 
			end 
			exports["ms-gameplay"]:msTakeMoney(player, cost)
			self.data["owner"] = getElementData(player, "player:uid")
			self.data["ownerName"] = getPlayerName(player)
			self.data["timestamp"] = getRealTime().timestamp+length
			mysql:query("UPDATE `ms_houses` SET `owner`=?, `ownerName`=?, `timestamp`=? WHERE `id`=?", self.data["owner"], self.data["ownerName"], getRealTime().timestamp+length, self.data["id"])
			triggerClientEvent(player, "onClientUpdateHouseWindowData", player, self.data)
			triggerClientEvent(player, "onClientAddNotification", player, "Zakupiłeś dom pomyślnie.", "success")
			exports["ms-achievements"]:addAchievement(player, "Mój pierwszy dom")
			setPickupType(self.pickup, 3, 1272, 1)
			
		elseif type == 2 then -- diamenty 
			local cost = math.floor(self.data["price"]*0.005)
			local diamonds = getElementData(player, "player:sp") or 0 
			if diamonds < cost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie stać cię na kupno tego domu.", "error", 4000)
				return 
			end 
			setElementData(player, "player:sp", diamonds-cost)
			
			self.data["owner"] = getElementData(player, "player:uid")
			self.data["ownerName"] = getPlayerName(player)
			self.data["timestamp"] = getRealTime().timestamp+length
			mysql:query("UPDATE `ms_houses` SET `owner`=?, `ownerName`=?, `timestamp`=? WHERE `id`=?", self.data["owner"], self.data["ownerName"], getRealTime().timestamp+length, self.data["id"])
			triggerClientEvent(player, "onClientUpdateHouseWindowData", player, self.data)
			triggerClientEvent(player, "onClientAddNotification", player, "Zakupiłeś dom pomyślnie.", "success")
			setPickupType(self.pickup, 3, 1272, 1)
		end 
		
		self:refresh()
	end,
	
	onExtend = function(self, player, type, length)
		if type == 1 then -- kasa  
			local cost = self.data["price"]
			local money = getElementData(player, "player:money") or 0
			if money < cost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie stać cię na przedłużenie tego domu.", "error", 4000)
				return 
			end 
			exports["ms-gameplay"]:msTakeMoney(player, cost)
			
			self.data["timestamp"] = self.data["timestamp"]+length
			mysql:query("UPDATE `ms_houses` SET `owner`=?, `ownerName`=?, `timestamp`=? WHERE `id`=?", self.data["owner"], self.data["ownerName"], self.data["timestamp"]+length, self.data["id"])
			triggerClientEvent(player, "onClientUpdateHouseWindowData", player, self.data)
			triggerClientEvent(player, "onClientAddNotification", player, "Przedłużyłeś dom pomyślnie.", "success", 4000)
		elseif type == 2 then -- diamenty 
			local cost = math.floor(self.data["price"]*0.005)
			local diamonds = getElementData(player, "player:sp") or 0 
			if diamonds < cost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie stać cię na przedłużenie tego domu.", "error", 4000)
				return 
			end 
			setElementData(player, "player:sp", diamonds-cost)
			
			self.data["timestamp"] = self.data["timestamp"]+length
			mysql:query("UPDATE `ms_houses` SET `owner`=?, `ownerName`=?, `timestamp`=? WHERE `id`=?", self.data["owner"], self.data["ownerName"], self.data["timestamp"]+length, self.data["id"])
			triggerClientEvent(player, "onClientUpdateHouseWindowData", player, self.data)
			triggerClientEvent(player, "onClientAddNotification", player, "Przedłużyłeś dom pomyślnie.", "success", 4000)
		end 
		
		self:refresh()
	end, 
	
	onLock = function(self, player)
		if self.locked then 
			self.locked = false 
			mysql:query("UPDATE `ms_houses` SET `locked`=? WHERE `id`=?", 0, self.data["id"])
			triggerClientEvent(player, "onClientAddNotification", player, "Otworzyłeś dom.", "info", 4000)
		else 
			self.locked = true 
			mysql:query("UPDATE `ms_houses` SET `locked`=? WHERE `id`=?", 1, self.data["id"])
			triggerClientEvent(player, "onClientAddNotification", player, "Zamknąłeś dom.", "info", 4000)
		end 
	end,
	
	onAddRoommate = function(self, player, name)
		local target = getPlayerFromName(name)  
		if target then 
			if target == player then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz ustawić siebie jako współlokatora...", "error", 4000)
				return 
			end 
			
			local roommates = fromJSON(self.data["roommates"])
			if #roommates == 3 then 
				triggerClientEvent(player, "onClientAddNotification", player, "Możesz mieć maksymalnie 3 współlokatorów.", "error", 4000)
				return 
			end 
			
			for k,v in ipairs(roommates) do 
				if v[1] == name then 
					triggerClientEvent(player, "onClientAddNotification", player, name.." jest już twoim współlokatorem!", "error", 4000)
					return 
				end 
			end 
			
			table.insert(roommates, {name, getElementData(target, "player:uid")})
			self.data["roommates"] = toJSON(roommates)
			mysql:query("UPDATE `ms_houses` SET `roommates`=? WHERE `id`=?", self.data["roommates"], self.id)
			
			triggerClientEvent(player, "onClientAddNotification", player, "Dodano gracza "..name.." do współlokatorów.", "success", 4000)
			triggerClientEvent(player, "onClientUpdateHouseWindowData", player, self.data)
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie znaleziono takiego gracza na serwerze.", "error", 4000)
		end 
	end, 
	
	onDeleteRoommate = function(self, player, name)
		local target = false
		local roommates = fromJSON(self.data["roommates"])
		for k,v in ipairs(roommates) do 
			if v[1] == name then 
				target = v[2]
				table.remove(roommates, k)
			end 
		end 
		
		if target then 
			self.data["roommates"] = toJSON(roommates)
			mysql:query("UPDATE `ms_houses` SET `roommates`=? WHERE `id`=?", self.data["roommates"], self.id)
			triggerClientEvent(player, "onClientAddNotification", player, "Usunięto gracza "..name.." ze współlokatorów.", "success", 4000)
			triggerClientEvent(player, "onClientUpdateHouseWindowData", player, self.data)
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Ten gracz nie jest twoim współlokatorem.", "error", 4000)
		end 
	end,
	
	onKnock = function(self, player)
		for k,v in ipairs(getElementsByType("player")) do 
			if getElementData(v, "player:inHouse") == self.id then 
				triggerClientEvent(v, "onClientKnockRequest", v)
			end
		end
		triggerClientEvent(player, "onClientKnockRequest", player)
	end,
	
	onSell = function(self, player, price)
		local money = getElementData(player, "player:money") or 0 
		money = money+price 
		setElementData(player, "player:money", money)
		
		self.data["timestamp"] = 0 
		self:refresh(true)
		
		triggerClientEvent(player, "onClientAddNotification", player, "Sprzedałeś ten dom za $"..tostring(price)..".", "success")
	end,
}

function getHouseByID(id)
	for k,v in ipairs(houses) do 
		if v.id == id then 
			return v 
		end 
	end 
	
	return false 
end 

function onPlayerEnterHouse(id)
	local house = getHouseByID(id)
	if house then 
		house:onEnter(client)
	end 
end 
addEvent("onPlayerEnterHouse", true)
addEventHandler("onPlayerEnterHouse", root, onPlayerEnterHouse)

function onPlayerBuyHouse(id, type, length)
	local house = getHouseByID(id)
	if house then 
		house:onBuy(client, type, length)
	end 
end 
addEvent("onPlayerBuyHouse", true)
addEventHandler("onPlayerBuyHouse", root, onPlayerBuyHouse)

function onPlayerLockHouse(id)
	local house = getHouseByID(id)
	if house then 
		house:onLock(client)
	end 
end 
addEvent("onPlayerLockHouse", true)
addEventHandler("onPlayerLockHouse", root, onPlayerLockHouse)

function onPlayerExtendHouse(id, type, length)
	local house = getHouseByID(id)
	if house then 
		house:onExtend(client, type, length)
	end 
end 
addEvent("onPlayerExtendHouse", true)
addEventHandler("onPlayerExtendHouse", root, onPlayerExtendHouse)

function onPlayerAddRoommate(id, name)
	local house = getHouseByID(id)
	if house then 
		house:onAddRoommate(client, name)
	end 
end 
addEvent("onPlayerAddRoommate", true)
addEventHandler("onPlayerAddRoommate", root, onPlayerAddRoommate)

function onPlayerDeleteRoommate(id, name)
	local house = getHouseByID(id)
	if house then 
		house:onDeleteRoommate(client, name)
	end
end 
addEvent("onPlayerDeleteRoommate", true)
addEventHandler("onPlayerDeleteRoommate", root, onPlayerDeleteRoommate)

function onPlayerKnock(id)
	local house = getHouseByID(id)
	if house then 
		house:onKnock(client)
	end
end 
addEvent("onPlayerKnock", true)
addEventHandler("onPlayerKnock", root, onPlayerKnock)

function onPlayerSellHouse(id, price)
	local house = getHouseByID(id)
	if house then 
		house:onSell(client, price)
	end
end 
addEvent("onPlayerSellHouse", true)
addEventHandler("onPlayerSellHouse", root, onPlayerSellHouse)

function refreshHouses()
	for k,v in ipairs(houses) do 
		v:refresh(true)
	end 
end 
setTimer(refreshHouses, 60000*5, 0)

function loadHouses()
	local query = mysql:getRows("SELECT * FROM `ms_houses")
	for k,v in ipairs(query) do
		local house = CHouse(v)
		table.insert(houses, house)
	end 
end 
addEventHandler("onResourceStart", resourceRoot, loadHouses)

function exitHouse(player)
	local id = getElementData(player, "player:inHouse")
	if id then 
		local house = getHouseByID(id)
		if house then 
			house:onExit(player)
		end 
	end 
end 

for k,v in ipairs(getElementsByType("player")) do 
	bindKey(v, "e", "down", exitHouse)
end 

addEventHandler("onPlayerJoin", root, function() bindKey(source, "e", "down", exitHouse) end)

-- /ahouse <id inta> <cena> 
addCommandHandler("ahouse",
	function(player, cmd, arg1, arg2)
		if getElementData(player, "player:rank") < 1 then 
			return 
		end 
		if not tonumber(arg1) or not tonumber(arg2) then 
			triggerClientEvent(player, "onClientAddNotification", player, "/ahouse <id interioru z /int> <cena>", "error", 4000)
			return 
		end 
		
		local x,y,z = getElementPosition(player)
		local zone = getZoneName(x,y,z)
		local city = getZoneName(x,y,z, true)
		local name = city..", "..zone
		
		mysql:query("INSERT INTO `ms_houses` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil, tonumber(arg1), x, y, z, name, tonumber(arg2), -1, "", "[[ ]]", 0, 0)
		triggerClientEvent(player, "onClientAddNotification", player, "Stworzyłeś dom pomyślnie.\n Pojawi się po restarcie skryptu.", "success")
	end 
)

local lastPos = {} 
addCommandHandler("int", 
	function(localPlayer, cmd, arg1)
		if getElementData(localPlayer, "player:rank") < 1 then return end 
		if not tonumber(arg1) then return end 
		local i = tonumber(arg1)
		local interior = getInteriorObjects(i)
		if i == 0 then 
			if not lastPos[localPlayer] then 
				local x,y,z = getElementPosition(localPlayer)
				lastPos[localPlayer] = {x,y,z}
			end 
			
			setElementPosition(localPlayer, lastPos[localPlayer][1], lastPos[localPlayer][2], lastPos[localPlayer][3])
			setElementInterior(localPlayer, 0)
			setElementDimension(localPlayer, 0)
			triggerClientEvent(localPlayer, "onDeleteInteriorObjects", localPlayer)
			
			local x,y,z = getElementPosition(localPlayer)
			lastPos[localPlayer] = {x,y,z}
			return
		end 
		
		local tx,ty,tz = getTeleportPosition(i)
		
		triggerClientEvent(localPlayer, "onDeleteInteriorObjects", localPlayer)
		if type(interior) == "table" then
			triggerClientEvent(localPlayer, "onCreateInteriorObjects", localPlayer, interior, getElementData(localPlayer, "player:id"))
			setElementInterior(localPlayer, 200)
		else 
			setElementInterior(localPlayer, interior)
		end 
		
		setElementDimension(localPlayer, getElementData(localPlayer, "player:id"))
		setElementPosition(localPlayer, tx, ty, tz)
	end 
)


function teleportPlayerToHouse(player, cmd, number)

	if getElementData(player, "block:player_teleport") then triggerClientEvent(player, "onClientAddNotification", player, "Masz zablokowaną możliwość teleportowania się!", "error") return end
	if getElementData(player, 'player:job') then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz teleportować się gdy wykonujesz pracę!", "error") return end
	if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Aby się teleportować najpierw wyjdź z areny wpisująć komendę /ae", "error") return end
	if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś na evencie!", "error") return end
	if isPedDead(player) then triggerClientEvent(player, "onClientAddNotification", player, "Jesteś martwy!", "error") return end 
	if isPedInVehicle(player) and int ~= 0 and dim ~= 0 then triggerClientEvent(player, "onClientAddNotification", player, "Najpierw wyjdź z pojazdu.", "warning") return end 
	local uid = getElementData(player, "player:uid")
	local player_houses = {}
	
	if number then
		house_id = tonumber(number)
	end
	
	for k,v in ipairs(houses) do
		if v.data.owner == uid then
			table.insert(player_houses, v)
		end
	end
	
	for k,v in ipairs(houses) do
		local roommates = fromJSON(v.data.roommates)
		local access_house = false
		
		for k,v in ipairs(roommates) do
			if v[2] == uid then
				access_house = true
			end
		end
		
		if access_house == true then
			table.insert(player_houses, v)
		end
		
	end
	
	if #player_houses > 0 then
		if #player_houses > 1 then
			if house_id and house_id <= #player_houses then
				setElementPosition(player, player_houses[house_id].data.enterX, player_houses[house_id].data.enterY, player_houses[house_id].data.enterZ)
				triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś przeteleportowany do domku!", "success")
			else
				triggerClientEvent(player, "onClientAddNotification", player, "Podaj slot domku od 1-".. #player_houses .."!", "error")
			end
		else
			setElementPosition(player, player_houses[1].data.enterX, player_houses[1].data.enterY, player_houses[1].data.enterZ)
			triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś przeteleportowany do domku!", "success")
		end
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Nie masz żadnego domku!", "error")
	end
end
addCommandHandler("housetp", teleportPlayerToHouse)