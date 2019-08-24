local mysql = exports["ms-database"]
entrances = {}

class "CEntrance"
{
	__init__ = function(self, data, id)
		self.id = id
		self.name = data["name"]
		self.description = data["opis"]
		self.locked = data["locked"] == 1
		self.admin = data["admin"] == 1
		self.pickupid = data["pickupid"]
		self.enterPos = fromJSON(data["pk_pos"])
		self.enterInterior = data["pki"]
		self.enterDimension = data["pkv"]
		self.exitPos = fromJSON(data["pk_tel"])
		self.exitInterior = data["teli"]
		self.exitDimension = data["telv"]
		self.image = false
		self.music = data["music"]
		self.musicVolume = data["music_volume"]
		self.icon = data["icon"]

		self.enterPickup = createPickup(self.enterPos[1], self.enterPos[2], self.enterPos[3], 3, 1318, 1)
		if data["blip"] ~= -1 then 
			self.blip = createBlipAttachedTo(self.enterPickup, data["blip"], 2, 255, 255, 255, 255, 0, 300, root) 
			setElementData(self.blip, "blipIcon", self.icon)
		end 
		self.enterCol = createColSphere(self.enterPos[1], self.enterPos[2], self.enterPos[3], 2)
		setElementData(self.enterPickup, "entrance", true)
		setElementData(self.enterPickup, "entrance:description", self.name)
		setElementInterior(self.enterPickup, self.enterInterior)
		setElementDimension(self.enterPickup, self.enterDimension)
		setElementInterior(self.enterCol, self.enterInterior)
		setElementDimension(self.enterCol, self.enterDimension)
		addEventHandler("onColShapeHit", self.enterCol, function(a, md) if md then self:onEnter(a) end end)
		addEventHandler("onColShapeLeave", self.enterCol, function(a, md) if md then self:onLeaveEnterPickup(a) end end)

		self.exitPickup = createPickup(self.exitPos[1], self.exitPos[2], self.exitPos[3], 3, self.pickupid, 1)
		self.exitCol = createColSphere(self.exitPos[1], self.exitPos[2], self.exitPos[3], 2)
		setElementInterior(self.exitPickup, self.exitInterior)
		setElementDimension(self.exitPickup, self.exitDimension)
		setElementInterior(self.exitCol, self.exitInterior)
		setElementDimension(self.exitCol, self.exitDimension)
		addEventHandler("onColShapeHit", self.exitCol, function(a, md) if md then triggerClientEvent(a, "onClientAddNotification", a, "By wyjść kliknij klawisz `E`.", "info", 3000) self:onEnterExit(a) end end)
		addEventHandler("onColShapeLeave", self.exitCol, function(a, md) if md then setElementData(a, "player:entrance_state", false) end end)
		if #self.music > 0 then
			triggerClientEvent(root, "onPlayerLoadEntranceMusic", root, self.music, self.enterPos[1], self.enterPos[2], self.enterPos[3], 15, true, self.musicVolume)
		end
		
		-- 3d text 
		local text3d = createElement("3dtext")
		setElementPosition(text3d, self.enterPos[1], self.enterPos[2], self.enterPos[3]+0.6)
		setElementInterior(text3d, self.enterInterior)
		setElementDimension(text3d, self.enterDimension)
		setElementData(text3d, "text", self.name)
		
		local text3d = createElement("3dtext")
		setElementPosition(text3d, self.exitPos[1], self.exitPos[2], self.exitPos[3]+0.6)
		setElementInterior(text3d, self.exitInterior)
		setElementDimension(text3d, self.exitDimension)
		setElementData(text3d, "text", "Wyjście")
	end,

	onEnter = function(self, player)
		if getElementType(player) ~= "player" then return end
		if isPedInVehicle(player) then return end 
		setElementData(player, "player:inEntrance", self.id)
		setElementData(player, "player:entrance_state", "in")
		triggerClientEvent(player, "onPlayerGetEntranceInfo", player, {self.name, self.description})
	end,

	onEnterExit = function(self, player)
		setElementData(player, "player:inEntrance", self.id)
		setElementData(player, "player:entrance_state", "out")
	end,

	onTeleport = function(self, player)
		if isPedInVehicle(player) then return end
		
		local plr = player
		fadeCamera(plr, false, 0.5)
		setTimer(
			function()
				if self.blip ~= -1 then setElementData(plr, "player:entrance", "inside") else setElementData(plr, "player:entrance", "outside") end 
				setElementPosition(plr, self.exitPos[1], self.exitPos[2], self.exitPos[3])
				setElementInterior(plr, self.exitInterior)
				setElementDimension(plr, self.exitDimension)
				if #self.music > 0 then triggerClientEvent(plr, "onPlayerLoadEntranceMusic", plr, self.music, self.exitPos[1], self.exitPos[2], self.exitPos[3], -1, false, self.musicVolume) end
				--if self.blip ~= -1 then setElementData(plr, "block:player_teleport", true) end
				fadeCamera(plr, true, 0.5)
			end, 500, 1
		)
	end,

	onLeaveEnterPickup = function(self, player)
		triggerClientEvent(player, "onPlayerHideEntranceInfo", player)
		setElementData(player, "player:entrance_state", false)
	end,

	onExit = function(self, player)
		local plr = player
		if getElementData(plr, "entrance:moving") then return end
		if not isElementWithinColShape(plr, self.exitCol) then return end

		fadeCamera(plr, false, 0.5)
		setTimer(
			function()
				if #self.music > 0 then triggerClientEvent(plr, "onPlayerLoadEntranceMusic", plr, false) end
				setElementPosition(plr, self.enterPos[1], self.enterPos[2], self.enterPos[3])
				setElementInterior(plr, self.enterInterior)
				setElementDimension(plr, self.enterDimension)
				--setElementData(plr, "block:player_teleport", false)
				setElementData(plr, "player:entrance", "outside")
				fadeCamera(plr, true, 0.5)
			end, 500, 1
		)
	end,

	loadImage = function(self, data)
		self.image = data
	end,

	setLocked = function(self, locked)
		self.locked = locked
	end,
}

function onPlayerMoveToEntrance(entranceid, type)
	if not entrances[entranceid] then return end
	if type == "in" then
		entrances[entranceid]:onTeleport(client)
	elseif type == "out" then
		entrances[entranceid]:onExit(client)
	end
end
addEvent("onPlayerMoveToEntrance", true)
addEventHandler("onPlayerMoveToEntrance", root, onPlayerMoveToEntrance)

function loadEntrances()
	setTimer(function() 
		local query = mysql:getRows("SELECT * FROM `ms_entrances`")
		for k,v in ipairs(query) do
			local entrance = CEntrance(v, #entrances+1)
			table.insert(entrances, entrance)
		end
	end, 200, 1)
end
addEventHandler("onResourceStart", resourceRoot, loadEntrances)

function onPlayerJoin()
	for k,v in ipairs(entrances) do
		if #v.music > 0 then 
			triggerClientEvent(source, "onPlayerLoadEntranceMusic", source, v.music, v.enterPos[1], v.enterPos[2], v.enterPos[3], 15, true, v.musicVolume)
		end
	end
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)
