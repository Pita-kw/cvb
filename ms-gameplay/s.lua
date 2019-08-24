
-- bind z naprawą pojazdu
local repairDelay = 60 -- ile sekund do nastepnej naprawy
local repairCost = 200 -- koszt naprawy
local healCost = 500 -- koszt uleczenia
local armorCost = 2500 -- koszt armora
local allowedSkins =  {0, 1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 184, 185, 186, 187, 188, 189, 200, 202, 203, 206, 209, 212, 217, 223, 230, 234, 239, 240, 241, 242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 3129, 10, 11, 12, 13, 31, 40, 41, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304, 204, 290, 252, 236, 235, 229, 228, 227, 222, 221, 220, 213, 210, 182, 183, 38, 39, 53, 139}
local vipSkins = {[204] = true, [290] = true, [252] = true, [236] = true, [235] = true, [229] = true, [228] = true, [227] = true, [222] = true, [221] = true, [220] = true, [213] = true, [210] = true, [182] = true, [183] = true, [38] = true, [39] = true, [53] = true, [139] = true, [62] = true, [127] = true, [121] = true, [72] = true, [311] = true} 
local planes = {592, 577, 511, 548, 512, 593, 425, 520, 417, 487, 553, 488, 497, 563, 476, 447, 519, 460, 469, 513}

function flipVehicle(player)
	if not getElementData(player, "player:spawned") then return end
	if getPlayerTeam(player) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz obracać pojazdu na atrakcjach!", "warning", 2500)
		return
	end
	
	local vehicle = getPedOccupiedVehicle (player) 
	
	if not vehicle then 
		triggerClientEvent(player, "onClientAddNotification", player, "Musisz być w pojeździe aby obrócić pojazd!", "warning", 2500)
		return
	end
	
   if (vehicle and getVehicleController (vehicle) == player) then 
		local rx, ry, rz = getVehicleRotation (vehicle) 
       if ( rx > 110 ) and ( rx < 250 ) then 
			local x, y, z = getElementPosition (vehicle) 
          setVehicleRotation (vehicle, rx + 180, ry, rz) 
			triggerClientEvent(player, "onClientAddNotification", player, "Pojazd odwrócony!", "success", 2500)
      else
			triggerClientEvent(player, "onClientAddNotification", player, "Twój pojazd nie potrzebuje odwrócenia!", "error", 2500)
		end
	end 
end
addCommandHandler("flip", flipVehicle)

function repairVehicle(player)
	if getPedOccupiedVehicle(player) and getPedOccupiedVehicleSeat(player) == 0 then 
		
		if getElementData(player, "player:job") then 
			return
		end 		
		
		if getPlayerTeam(player) and getTeamName(getPlayerTeam(player)) ~= "Race" then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz naprawiać pojazdu na atrakcjach.", "warning", 2500)
			return
		end 
		
		if getElementData(getPedOccupiedVehicle(player), "vehicle:exchange") then 
			triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz naprawiać pojazdów giełdowych.", "warning", 2500)
			return
		end 
		
		local now = getTickCount()
		
		local lastRepair = getElementData(player, "player:lastRepair") or 0 
		if lastRepair > now then 
			local time = math.ceil(((lastRepair-now)/1000))
			triggerClientEvent(player, "onClientAddNotification", player, "Naprawa pojazdu dostępna za "..tostring(time).."s.", "warning", 2500)
			return 
		end 
		
		if not getElementData(player, "player:premium") then 
			local money = getElementData(player, "player:money") or 0 
			if money < repairCost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Nie stać cię na naprawę pojazdu.", "error", 5000)
				return
			else 
				exports["ms-gameplay"]:msTakeMoney(player, repairCost)
			end 
		end 
		
		setElementData(player, "player:lastRepair", now+repairDelay*1000)
		
		local vehicle = getPedOccupiedVehicle(player)
		fixVehicle(vehicle)
		
		local addons = getElementData(vehicle, "vehicle:upgrade_addons") or {hp=0}
		setElementData(vehicle, "vehicle:extraHP", 250*addons.hp)
		
		playSoundFrontEnd(player, 46)
		
		if not getElementData(player, "player:premium") then  
			triggerClientEvent(player, "onClientAddNotification", player, "Naprawiono pojazd. Koszt: $"..tostring(repairCost), "success", 3000, false)
		else 
			triggerClientEvent(player, "onClientAddNotification", player, "Naprawiono pojazd pojazd za darmo dzięki posiadaniu konta premium.", "success", 3000, false)
		end
	end
end 
addCommandHandler("fix", repairVehicle)
addCommandHandler("rp", repairVehicle)

function bindKeys(player)
	unbindKey(player, "2", "down", repairVehicle)
	bindKey(player, "2", "down", repairVehicle)
	unbindKey(player, "1", "down", flipVehicle)
	bindKey(player, "1", "down", flipVehicle)
end 

function onPlayerEnterGame(player)
	bindKeys(source)
end 
addEventHandler("onPlayerJoin", root, onPlayerEnterGame)

function updateServerTime()
	local time = getRealTime()
	setTime(time.hour, math.max(0, time.minute-3)) -- Czas serwera śpieszy o 2 minuty :/
end

local gotBonus = {}
function checkPlaytime() 
	for k,v in ipairs(getElementsByType("player")) do 
		local playtime = getElementData(v, "player:session_time") or 0
		if not gotBonus[v] and playtime/3600 >= 1 and playtime/3600 == math.ceil(playtime/3600) then 
			exports["ms-gameplay"]:msGiveExp(v, 10)
			exports["ms-gameplay"]:msGiveMoney(v, 1000)
			
			local exp = 10
			local money = 1000 
			if getElementData(v, "player:premium") then 
				exp = math.floor(exp + exp*0.3)
				money = math.floor(money + money*0.3)
			end
			
			gotBonus[v] = true
			setTimer(function(player) if player then gotBonus[player] = false end end, 2000, 1, v)
			
			triggerClientEvent(v, "onClientAddNotification", v, "Za godzinę grania otrzymujesz "..tostring(exp).." exp i $"..tostring(money).."!", "success")
		end
	end
end 

function onResourceStart()	
	setJetpackMaxHeight(101.82230377197)
    setWaveHeight(0)
    setFPSLimit(60)
	
	for k,v in ipairs(getElementsByType("player")) do
		bindKeys(v)
	end 
	
	setTimer(checkPlaytime, 500, 0)
	--setTimer(updateServerTime, 60000, 0)
	setMinuteDuration(60000)
	--updateServerTime()
end 
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function onPlayerWasted(totalAmmo, killer) 
	if killer and getElementType(killer) == "player" and killer ~= source then
		local lastKiller = getElementData(source, "player:lastKiller") or false 
		if lastKiller ~= killer then 
			setElementData(source, "player:lastKiller", killer)
			msGiveExp(killer, 1)
		end
	end
end 
addEventHandler("onPlayerWasted", root, onPlayerWasted)

function antyEscape ( attacker, weapon, bodypart, loss )
	if isElement(attacker) and getElementType(attacker) == "player" then
		setElementData(source, 'player:lastDamage', getTickCount()+15000)
	end
end
addEventHandler ( "onPlayerDamage", getRootElement (), antyEscape )

function givePlayerHealth(player)
	local money = getElementData(player, "player:money")
	local now = getTickCount()
	local health_time = getElementData(player, "player:lastHealth") or 0
	if getElementData(player, "player:arena") or getPlayerTeam(player) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz używać tej komendy na arenach i atrakcjach.", "error")
		return
	end 
	
	local lastDamage = getElementData(player, "player:lastDamage") or 0 
	
	if lastDamage > now then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś niedawno postrzelony! Poczekaj chwilę", "error")
		return
	end
	
	if not getElementData(player, "player:premium") then 
			local money = getElementData(player, "player:money") or 0 
			if money < healCost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Uleczenie kosztuje 500$", "error", 5000)
				return
			else 
				exports["ms-gameplay"]:msTakeMoney(player, healCost)
			end 
	end 
	
	if health_time > now then
		local time = math.ceil((health_time-now)/1000)  
		triggerClientEvent(player, "onClientAddNotification", player, 'Odczekaj jeszcze '..tostring(time)..' sekund przed kolejnym uleczeniem się.', "error")
		return
	end	
	
	setElementHealth(player, 100)
	if not getElementData(player, "player:premium") then
		triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś uleczony. Koszt ".. tostring(healCost) .."$", "success", 2500)
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś uleczony za darmo dzięki posiadaniu konta premium.", "success", 2500)
	end
	setElementData(player, 'player:lastHealth', getTickCount()+60000)
end
addCommandHandler("health", givePlayerHealth)
addCommandHandler("hp", givePlayerHealth)

function givePlayerArmor(player)
	local money = getElementData(player, "player:money")
	local now = getTickCount()
	local armor_time = getElementData(player, "player:lastArmor") or 0
	if getElementData(player, "player:arena") or getPlayerTeam(player) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz używać tej komendy na arenach i atrakcjach.", "error")
		return
	end 

	local lastDamage = getElementData(player, "player:lastDamage") or 0 
	
	if lastDamage > now then 
		triggerClientEvent(player, "onClientAddNotification", player, "Zostałeś niedawno postrzelony! Poczekaj chwilę", "error")
		return
	end
	
	if not getElementData(player, "player:premium") then 
			local money = getElementData(player, "player:money") or 0 
			if money < armorCost then 
				triggerClientEvent(player, "onClientAddNotification", player, "Uleczenie kosztuje 5000$", "error", 5000)
				return
			else 
				exports["ms-gameplay"]:msTakeMoney(player, armorCost)
			end 
	end 

	
	if armor_time > now then
		local time = math.ceil((armor_time-now)/1000)  
		triggerClientEvent(player, "onClientAddNotification", player, 'Odczekaj jeszcze '..tostring(time)..' sekund przed kolejnym kupnem kamizelki.', "error")
		return
	end	
	
	setPedArmor(player, 100)
	if not getElementData(player, "player:premium") then
		triggerClientEvent(player, "onClientAddNotification", player, "Kupiłeś kamizelkę. Koszt ".. tostring(healCost) .."$", "success", 2500)
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Dostałeś kamizelkę za darmo dzięki posiadaniu konta premium.", "success", 2500)
	end
	setElementData(player, 'player:lastArmor', getTickCount()+60000)
end
addCommandHandler("armor", givePlayerArmor)
addCommandHandler("ar", givePlayerArmor)

function setPlayerSkin(player, cmd, skin)
	local skin_id = tonumber(skin)
	local found = false
	local now = getTickCount()
	local skinchange_time = getElementData(player, "player:lastChangeSkin") or 0
	
	if skin_id == getElementData(player, "player:skin") then triggerClientEvent(player, "onClientAddNotification", player, "Ten model skinu masz właśnie ustawiony.", "warning", 2500) return end
	
	if skinchange_time > now  and getElementData(player, "player:rank") ~= 3 then
		local time = math.ceil((skinchange_time-now)/1000)  
		triggerClientEvent(player, "onClientAddNotification", player, 'Odczekaj jeszcze '..tostring(time)..' sekund przed kolejną zmianą skinu.', "error")
		return
	end	
	
	if not skin_id then triggerClientEvent(player, "onClientAddNotification", player, "Nie podałeś numeru skinu.", "error", 2500) return end
	
	for k,v in ipairs(allowedSkins) do
		if v == skin_id then
			found = true
		end
	end
	
	if vipSkins[skin_id] == true and not getElementData(player, "player:premium") and getElementData(player, "player:rank") ~= 3 then
		triggerClientEvent(player, "onClientAddNotification", player, "Ten skin jest tylko dla graczy z kontem premium!", "warning", 2500)
		return
	end
	
	if found == false then
		triggerClientEvent(player, "onClientAddNotification", player, "Podałeś nieprawidłowy model skinu!", "error", 2500)
	else
		setElementModel(player, skin_id)
		setElementData(player, "player:skin", skin_id)
		setElementData(player, 'player:lastChangeSkin', getTickCount()+60000)
		triggerClientEvent(player, "onClientAddNotification", player, "Skin zmieniony pomyślnie!", "success", 2500)
	end
end
addCommandHandler("skin", setPlayerSkin)

function secondsToClock(seconds)
  seconds = seconds or 0 

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	 return "".. hours .." godzin ".. mins .." minut ".. secs .." sekund"
  end
end

function getSessionTime(player)
	local session_time = getElementData(player, "player:session_time")
	triggerClientEvent(player, "onClientAddNotification", player, "Grasz już od ".. secondsToClock(session_time) .."", "info", 5000)
end
addCommandHandler("sesja", getSessionTime)

function getAccountUID(player)
	local uid = getElementData(player, "player:uid")
	triggerClientEvent(player, "onClientAddNotification", player, "UID twojego konta to: ".. uid .."", "info", 10000)
end
addCommandHandler("uid", getAccountUID)

function forceSpawnPlayer(player)
	if isPedDead(player) then
		exports["ms-gameplay"]:ms_spawnPlayer(player)
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Jesteś zespawnowany!", "warning", 2500)
	end
end
addCommandHandler("spawn", forceSpawnPlayer)

function checkDistancePlayers(player, cmd, arg1)
	if not arg1 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Użyj\n/dystans [id gracza]", "error")
		return 
	end 
	
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			local x,y,z = getElementPosition(player)
			local x2,y2,z2 = getElementPosition(v)
			local distance = getDistanceBetweenPoints2D(x, y, x2, y2)
			triggerClientEvent(player, "onClientAddNotification", player, "Gracz ".. getPlayerName(v) .." jest od ciebie odległy o ".. math.floor(distance) .."m.", "info")
			return 
		end
	end 
end
addCommandHandler("dystans", checkDistancePlayers)

function addVehicleDamages ( player, seat, jacked )
	setVehicleDamageProof(source, false)
end
addEventHandler ( "onVehicleEnter", root, addVehicleDamages )

function removeFireFromVehicle ( player, seat, jacked )
	local model = getElementModel(source)
	
	for k,v in ipairs(planes) do
		if v ==  tonumber(model) then
			toggleControl(player, "vehicle_secondary_fire", false)
			toggleControl(player, "vehicle_fire", false)
		end
	end
end
addEventHandler ( "onVehicleStartEnter", root, removeFireFromVehicle )

function removeVehicleDamages ( player, seat, jacked )
	if source then 
		setVehicleDamageProof(source, true)
		local model = getElementModel(source)
		
		for k,v in ipairs(planes) do
			if v ==  tonumber(model) then
				toggleControl(player, "vehicle_secondary_fire", true)
				toggleControl(player, "vehicle_fire", true)
			end
		end
	end
end
addEventHandler ( "onVehicleExit", root, removeVehicleDamages )


function serverSyncToClient(player)
    triggerClientEvent(player, "onExitWeaponSync", root, player)
end
addEventHandler("onVehicleExit", root, serverSyncToClient)

function weaponSyncServer(player, slot, weap, ammo, clip)
    sl = (slot or 0)
    wp = (weap or 0)
    am = (ammo or 0)
    cl = (clip or 0)
    for slot=1,12 do
        if (wp > 0 and ((am > 1 and sl == 8) or am > 0)) then
            giveWeapon(player,wp,am)
            setWeaponAmmo(player,wp,am,cl)
        end
    end
end
addEvent("weaponSync",true)
addEventHandler("weaponSync", root, weaponSyncServer)


function checkPlayerWork(player)

	local player_job = getElementData(player, "player:job" )
	local found = false
	
	if player_job == "job_tree" then
		triggerEvent("endTreeJob", player, player)
		found = true
	end
	
	if player_job == "job_mine" then
		triggerEvent("endMineJob", player, player)
		found = true
	end
	
	if player_job == "air_spedition" then
		triggerClientEvent(player, "endAirJob", player, "failed")
		found = true
	end
	
	if player_job == "truck_spedition" then
		triggerClientEvent(player, "endTruckJob", player, true)
		found = true
	end
	
	if found == false then
		outputChatBox("Nie przebywasz w żadnej pracy", player)
		return false
	else
		return true
	end
end
addEvent("checkPlayerWork", true)
addEventHandler("checkPlayerWork", getRootElement(), checkPlayerWork)
addCommandHandler("endwork", checkPlayerWork)


function spadochron(player)
	giveWeapon(player, 46, 1, true)
	triggerClientEvent(player, "onClientAddNotification", player, "Otrzymałeś spadochron.", "success", 5000)
end 
addCommandHandler("spadochron", spadochron)

addEventHandler("onPlayerStealthKill", root, function(target)
	if getElementData(target, "player:afk") then cancelEvent() end
 end)
 
 addCommandHandler("kill", function(player)
	if not isPedDead(player) then 
		killPed(player)
	end
 end)


