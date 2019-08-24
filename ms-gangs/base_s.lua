local bases = {} 

function loadBases()
	setTimer(function()
		local query = exports["ms-database"]:getRows("SELECT * FROM ms_gangs_bases")
		for k, v in ipairs(query) do
			bases[k] = {} 
			local textData = fromJSON(v.text)
			bases[k].text = createElement("3dtext")
			setElementPosition(bases[k].text, textData.x, textData.y, textData.z)
			setElementData(bases[k].text, "font", 1.3)
			setElementData(bases[k].text, "dd", 100)
			
			local radarAreaData = fromJSON(v.radararea)
			bases[k].radarArea = createRadarArea(radarAreaData.x, radarAreaData.y, radarAreaData.w, radarAreaData.h, 150, 150, 150, 150)
			
			local gangAreaData = fromJSON(v.gangarea)
			bases[k].gangArea = createElement("gangarea")
			setElementPosition(bases[k].gangArea, gangAreaData.x, gangAreaData.y, gangAreaData.z)
			setElementData(bases[k].gangArea, "distance", gangAreaData.radius)
			setElementData(bases[k].gangArea, "owner", v.owner)

			if v.owner ~= -1 then
				local gangIndex = getGangIndexFromID(v.owner)
				setElementData(bases[k].gangArea, "name", gangData[gangIndex].name)
				
				local color = fromJSON(gangData[gangIndex].color)
				setElementData(bases[k].gangArea, "color", {color[1], color[2], color[3]})
			else 
				setElementData(bases[k].gangArea, "name", "Baza do wynajęcia")
				setElementData(bases[k].gangArea, "color", {255, 255, 255})
			end 
			
			bases[k].col = createColCircle(gangAreaData.x, gangAreaData.y, gangAreaData.radius)
			setElementData(bases[k].col, "base:id", k)
			
			addEventHandler("onColShapeHit", bases[k].col, function(hitElement, md)
				if getElementType(hitElement) == "player" and md then 
					local gang = getElementData(hitElement, "player:gang")
					local baseID = getElementData(source, "base:id")
					if bases[baseID].owner ~= -1 then
						if gang and gang.id ~= bases[baseID].owner then 
							if bases[baseID].antitheft == 1 then 
								activeBaseAntiTheft(baseID)
							end
						end
					end
				end 
				
				if getElementType(hitElement) == "vehicle" and md then 
					if getVehicleType(hitElement) == "Plane" or getVehicleType(hitElement) == "Helicopter" then 
						local player = getVehicleController(hitElement)
						if player then
							local gang = getElementData(player, "player:gang")
							local baseID = getElementData(source, "base:id")
							if bases[baseID].owner ~= -1 then
								if gang and gang.id ~= bases[baseID].owner then 
									if bases[baseID].airprotection.installed == true then 
										triggerClientEvent(player, "onClientEnableBaseAirProtection", player, bases[baseID].airprotection, source)
									end
								end
							end
						end
					end
				end
			end)
			
			local pickupData = fromJSON(v.pickup)
			bases[k].pickup = createPickup(pickupData.x, pickupData.y, pickupData.z, 3, 1274, 1000)
			
			local blip = createBlipAttachedTo(bases[k].pickup, 1)
			setElementData(blip, "blipIcon", "house")
			setElementData(blip, "blipColor", {230, 126, 34})
			
			bases[k].col = createColSphere(pickupData.x, pickupData.y, pickupData.z, 2)
			setElementData(bases[k].col, "baseID", k)
			
			bases[k].diamonds = v.price_diamonds 
			bases[k].dollars = v.price_dollars
			bases[k].expires = v.expires 
			bases[k].antitheft = v.antitheft
			bases[k].airprotection = fromJSON(v.airprotection) 
			bases[k].owner = v.owner 

			bases[k].gates = fromJSON(v.gates)
			local baseid = k
			for i, gate in ipairs(bases[k].gates) do	
				createGangGate(baseid, gate.x, gate.y, gate.z, gate.rx, gate.ry, gate.rz)
			end 
			
			addEventHandler("onColShapeHit", bases[k].col, function(hitElement, md)
				if getElementType(hitElement) == "player" and md then 
					local baseData = {id=getElementData(source, "baseID")}
					baseData.owner = bases[baseData.id].owner 
					baseData.diamonds = bases[baseData.id].diamonds 
					baseData.dollars = bases[baseData.id].dollars 
					baseData.expires = bases[baseData.id].expires 
					baseData.antitheft = bases[baseData.id].antitheft 
					baseData.airprotection = bases[baseData.id].airprotection
					
					triggerClientEvent(hitElement, "onClientShowBaseWindow", hitElement, baseData)
				end
			end)
			
			addEventHandler("onColShapeLeave", bases[k].col, function(hitElement, md)
				if getElementType(hitElement) == "player" and md then 
					triggerClientEvent(hitElement, "onClientHideBaseWindow", hitElement)
				end
			end)
			
			if v.owner ~= -1 then 
				local gangIndex = getGangIndexFromID(v.owner)
				if gangData[gangIndex] then				
					local color = fromJSON(gangData[gangIndex].color)
					setRadarAreaColor(bases[k].radarArea, color[1], color[2], color[3], 150)
					
					setElementData(bases[k].text, "text", "#FFFFFFBaza gangu "..string.format("#%02X%02X%02X", color[1], color[2], color[3])..gangData[gangIndex].name)
					
					setElementData(bases[k].gangArea, "owner", v.owner)
				end
			else 
				setElementData(bases[k].text, "text", "Baza dla gangu do wykupienia")
			end
			
			updateBases()
			setTimer(updateBases, 60000*10, 0)
		end
		
		setTimer(updateAntiTheft, 2000, 0)
	end, 2000, 1)
end 
addEventHandler("onResourceStart", resourceRoot, loadBases)

gateTimers = {}
function createGangGate(id, x, y, z, rx, ry, rz)
	local obj = createObject(980, x, y, z, rx, ry, rz)
	local startX, startY, startZ = x, y, z
	setElementData(obj, "gate:state", "closed")
	
	local function openGate()	
		if getElementData(obj, "gate:state") == "opened" then return end 
		
		moveObject(obj, 1500, startX, startY, startZ-5, 0, 0, 0, "InOutBack")
		setTimer(setElementData, 1500, 1, obj, "gate:state", "opened")
	end 
	
	local function closeGate()
		if getElementData(obj, "gate:state") == "closed" then return end 
			
		moveObject(obj, 1500, startX, startY, startZ, 0, 0, 0, "InOutBack")
		setTimer(setElementData, 1500, 1, obj, "gate:state", "closed")
	end 
	
	local x, y, z = getPositionFromElementOffset(obj, 0, -6, 0)
	local enterSphere = createColSphere(x, y, z, 6)
	setElementData(enterSphere, "baseID", id)
	addEventHandler("onColShapeHit", enterSphere, function(hitElement, md)
		if getElementType(hitElement) == "player" and md then 
			local player = hitElement
			local gateOwner = bases[getElementData(source, "baseID")].owner
			
			if player then 
				if gateOwner ~= -1 then 
					local gang = getElementData(player, "player:gang")
					if not gang or gang.id ~= gateOwner then 
						triggerClientEvent(player, "onClientAddNotification", player, "Ta baza należy do gangu w którym nie jesteś.", "error")
						return
					end
				end 
				
				openGate()
				if isTimer(gateTimers[obj]) then 
					killTimer(gateTimers[obj])
				end 
				
				gateTimers[obj] = setTimer(closeGate, 2500, 1)
			end
		end
	end)
	
	local x, y, z = getPositionFromElementOffset(obj, 0, 6, 0)
	local exitSphere = createColSphere(x, y, z, 6)
	setElementData(exitSphere, "baseID", id)
	addEventHandler("onColShapeHit", exitSphere, function(hitElement, md)
		if getElementType(hitElement) == "player" and md then 
			local player = hitElement
			local gateOwner = bases[getElementData(source, "baseID")].owner
			if player then 
				if gateOwner ~= -1 then 
					local gang = getElementData(player, "player:gang")
					if not gang or gang.id ~= gateOwner then 
						triggerClientEvent(player, "onClientAddNotification", player, "Ta baza należy do gangu w którym nie jesteś.", "error")
						return
					end
				end 
				
				openGate()	
				if isTimer(gateTimers[obj]) then 
					killTimer(gateTimers[obj])
				end 
				
				gateTimers[obj] = setTimer(closeGate, 2500, 1)
			end
		end
	end)
end 

function activeBaseAntiTheft(baseID)
	local base = bases[baseID]
	if base then 
		if not isRadarAreaFlashing(base.radarArea) then
			for k, v in ipairs(getElementsByType("player")) do 
				local gang = getElementData(v, "player:gang")
				if gang and gang.id == base.owner then 
					triggerClientEvent(v, "onClientAddNotification", v, "Baza twojego gangu jest atakowana!", "error")
				end
			end
			
			setRadarAreaFlashing(base.radarArea, true)
		end
	end
end 

function updateAntiTheft()
	for k, baseData in ipairs(bases) do 
		if isRadarAreaFlashing(baseData.radarArea) then 
			local counter = 0 
			for _, player in ipairs(getElementsByType("player")) do
				local gang = getElementData(player, "player:gang")
				local x, y = getElementPosition(player)
				if gang and gang.id ~= baseData.owner and getElementData(player, "player:zone") == "gang" then 
					counter = counter+1
				end
			end
			
			setRadarAreaFlashing(baseData.radarArea, counter > 0)
		end
	end
end 


function updateBases()
	for k, baseData in ipairs(bases) do 
		if baseData.owner ~= -1 then
			if getRealTime().timestamp > baseData.expires then 
				setRadarAreaColor(baseData.radarArea, 150, 150, 150, 150)
				setElementData(baseData.text, "text", "Baza dla gangu do wykupienia")
				setElementData(baseData.gangArea, "owner", -1)
				baseData.owner = -1 
				baseData.antitheft = 0
				baseData.airprotection.installed = false 
				
				exports["ms-database"]:query("UPDATE ms_gangs_bases SET owner=?, antitheft=?, airprotection=? WHERE id=?", -1, 0, toJSON(baseData.airprotection), baseData.uid)
			end
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, updateBases)

function onPlayerBuyBase(baseID)
	local gang = getElementData(client, "player:gang")
	if not gang or (gang and not gang.leader) then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie jesteś liderem żadnego gangu!", "error")
		return
	end 
	
		if bases[baseID].owner == gang.owner then 
			triggerClientEvent(client, "onClientAddNotification", client, "Twój gang posiada już jakąś bazę.", "error")
			return
		end
	
	local sp = getElementData(client, "player:sp") or 0
	sp = sp-bases[baseID].diamonds 
	if sp < 0 then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie starczy ci diamentów na kupno tej bazy.", "error")
		return
	end
	setElementData(client, "player:sp", sp)
	
	local week = (((7)*24)*60)*60
	exports["ms-database"]:query("UPDATE ms_gangs_bases SET owner=?, expires=? WHERE id=?", gang.id, getRealTime().timestamp+week, bases[baseID].uid)
	
	local gangIndex = getGangIndexFromID(gang.id)
	if gangData[gangIndex] then				
		local color = fromJSON(gangData[gangIndex].color)
		setRadarAreaColor(bases[baseID].radarArea, color[1], color[2], color[3], 150)
					
		setElementData(bases[baseID].text, "text", "#FFFFFFBaza gangu "..string.format("#%02X%02X%02X", color[1], color[2], color[3])..gangData[gangIndex].name)
					
		setElementData(bases[baseID].gangArea, "owner", gang.id)
		
		setElementData(bases[baseID].gangArea, "name", gangData[gangIndex].name)
		setElementData(bases[baseID].gangArea, "color", {color[1], color[2], color[3]})
	end
	
	bases[baseID].owner = gang.id
	bases[baseID].expires = getRealTime().timestamp+week
			
	triggerClientEvent(client, "onClientAddNotification", client, "Zakupiono bazę pomyślnie!", "success")
end 
addEvent("onPlayerBuyBase", true)
addEventHandler("onPlayerBuyBase", root, onPlayerBuyBase)

function onPlayerExtendBase(baseID)
	local gang = getElementData(client, "player:gang")
	if not gang or (gang and not gang.leader) then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie jesteś liderem żadnego gangu!", "error")
		return
	end 
	
	local money = getElementData(client, "player:money") or 0
	money = money - bases[baseID].dollars
	if money < 0 then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie starczy ci pieniędzy na przedłużenie tej bazy.", "error")
		return
	end
	setElementData(client, "player:money", money)
	
	local week = (((7)*24)*60)*60
	exports["ms-database"]:query("UPDATE ms_gangs_bases SET owner=?, expires=? WHERE id=?", gang.id, bases[baseID].expires+week, bases[baseID].uid)
	
	bases[baseID].expires = bases[baseID].expires+week
	
	triggerClientEvent(client, "onClientAddNotification", client, "Przedłużono bazę pomyślnie!", "success")
end 
addEvent("onPlayerExtendBase", true)
addEventHandler("onPlayerExtendBase", root, onPlayerExtendBase)

function onPlayerInstallBaseUpgrade(baseID, type)
	local gang = getElementData(client, "player:gang")
	if not gang or (gang and not gang.leader) then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie jesteś liderem żadnego gangu!", "error")
		return
	end 
	
	if gang.id ~= bases[baseID].owner then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie jesteś członkiem gangu właściciela strefy!", "error")
		return
	end
	
	local gangIndex = getGangIndexFromID(gang.id)
	if type == "antitheft" then
		local level = gangData[gangIndex].level 
		if level < 5 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Twój gang ma zbyt niski level by kupić to ulepszenie.", "error")
			return
		end 
		
		local money = getElementData(client, "player:money") or 0
		money = money - 25000
		if money < 0 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Nie starczy ci pieniędzy na kupno tego ulepszenia.", "error")
			return
		end
		setElementData(client, "player:money", money)
		
		bases[baseID].antitheft = 1
		exports["ms-database"]:query("UPDATE ms_gangs_bases SET antitheft=? WHERE id=?", 1, bases[baseID].uid)
	elseif type == "airprotection" then 
		local level = gangData[gangIndex].level 
		if level < 12 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Twój gang ma zbyt niski level by kupić to ulepszenie.", "error")
			return
		end 
		
		local money = getElementData(client, "player:money") or 0
		money = money - 50000
		if money < 0 then 
			triggerClientEvent(client, "onClientAddNotification", client, "Nie starczy ci pieniędzy na kupno tego ulepszenia.", "error")
			return
		end
		setElementData(client, "player:money", money)
		
		bases[baseID].airprotection.installed = true
		exports["ms-database"]:query("UPDATE ms_gangs_bases SET airprotection=? WHERE id=?", toJSON(bases[baseID].airprotection), bases[baseID].uid)
	end
	
	triggerClientEvent(client, "onClientAddNotification", client, "Ulepszenie zainstalowane pomyślnie.", "success")
end 
addEvent("onPlayerInstallBaseUpgrade", true)
addEventHandler("onPlayerInstallBaseUpgrade", root, onPlayerInstallBaseUpgrade)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end