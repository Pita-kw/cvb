local sellMarker = createMarker(2395.22, -2062.22, 13.52-1.2, "cylinder", 3, 50, 20, 200, 200)
local blip = createBlipAttachedTo(sellMarker, 1)
setElementData(blip, "blipIcon", "vehicle_shop")

local text = createElement("3dtext")
setElementPosition(text, 2395.22, -2062.22, 13.52)
setElementData(text, "text", "W tym miejscu możesz sprzedać swój prywatny pojazd.\nWpisz #3366FF/wystaw <cena> #FFFFFFbędąc w swoim pojeździe by wystawić pojazd na giełdę.\n\nJeśli chcesz kupić jakiś giełdowy pojazd: podejdź przed niego dla szczegółowych opcji.")
-- lubie swiat w kolorowych barwach, stad te math random do kolorku

local places = {}


addEventHandler("onResourceStart", resourceRoot, function()
  places = {}
  exchangeVehicles = {} 
  for k,v in ipairs(getElementsByType("vehicle")) do 
	if getElementData(v, "vehicle:exchange") then 
		table.insert(exchangeVehicles, v)
	end
  end 
  
  for i=1, 24 do -- pierwsza strona
	-- x, y, z, rot, isPlaceFree, 3dtext, kolizja
	table.insert(places, {2400,-2068.6 - 3.1*i,13.54, 90, true})
  end

  for i=1, 27 do -- druga strona (gora)
	-- 2386.66,-2062.29,13.48
	table.insert(places, {2386.66,-2062.29 - 3*i,13.54, 270, true})
   end
   
   for k, pojazd in ipairs(exchangeVehicles) do 
	local miejsce = getElementData(pojazd, "vehicle:exchange:miejsce") 
	if miejsce then 
		places[miejsce][5] = false
	    places[miejsce][6] = createElement("3dtext")
		local x, y, z, rot = places[miejsce][1], places[miejsce][2], places[miejsce][3], places[miejsce][4]
	   setElementPosition(pojazd, x, y, z)
		setElementRotation(pojazd, 0, 0, rot)
		fixVehicle(pojazd)
		setElementFrozen(pojazd, true)
		setVehicleOverrideLights ( pojazd, 2 ) 
		
		setElementPosition(places[miejsce][6], x, y, z+1.5)
	    setElementData(places[miejsce][6], "text", "#3366ff"..getVehicleNameFromModel(getElementModel(pojazd)).."\n#2ecc71$"..getElementData(pojazd, "vehicle:exchange:cena"))
	
		local x, y, z = getPositionFromElementOffset(pojazd, 0, 4, 0)
		places[miejsce][7] = createColSphere(x, y, z, 1.1)
		addEventHandler("onColShapeHit", places[miejsce][7], function(el, md)
			if getElementType(el) == "player" and md and not isPedInVehicle(el) then 
				triggerClientEvent(el, "onClientShowExchangeWindow", el, pojazd)
			end
		end)
		addEventHandler("onColShapeLeave", places[miejsce][7], function(el, md)
			if getElementType(el) == "player" and md then 
				triggerClientEvent(el, "onClientHideExchangeWindow", el, pojazd)
			end
		end)
	end
   end
end)

function znajdzMiejsce()
  local znalezione = nil
  for k, v in pairs(places) do
    if v[5] == true then
      znalezione = k
      break
    end
  end
return znalezione
end

function wystawPojazd(gracz, pojazd, cena)
  if pojazd and tonumber(cena) then
    local miejsce = znajdzMiejsce()
    if miejsce ~= nil then
      local x,y,z,rot = places[miejsce][1], places[miejsce][2], places[miejsce][3], places[miejsce][4]
      places[miejsce][5] = false
      setElementPosition(pojazd, x,y,z)
      local rx, ry, _ = getElementRotation(pojazd)
      setElementRotation(pojazd, rx, ry, rot)
      setVehicleEngineState(pojazd, false)
      setElementFrozen(pojazd, true)
	  local id =  getElementData(pojazd, "vehicle:id")
      setElementData(pojazd, "vehicle:exchange", true)
      setElementData(pojazd, "vehicle:exchange:cena", tonumber(cena))
      setElementData(pojazd, "vehicle:exchange:miejsce", miejsce)
		setVehicleOverrideLights ( pojazd, 2 ) 
		
	  places[miejsce][6] = createElement("3dtext")
	  setElementPosition(places[miejsce][6], x, y, z+1.5)
	  setElementData(places[miejsce][6], "text", "#3366ff"..getVehicleNameFromModel(getElementModel(pojazd)).."\n#2ecc71$"..cena)

	  local x, y, z = getPositionFromElementOffset(pojazd, 0, 3, 0)
	  places[miejsce][7] = createColSphere(x, y, z, 1)
	  addEventHandler("onColShapeHit", places[miejsce][7], function(el, md)
			if getElementType(el) == "player" and md and not isPedInVehicle(el) then 
				triggerClientEvent(el, "onClientShowExchangeWindow", el, pojazd)
			end
		end)
	  addEventHandler("onColShapeLeave", places[miejsce][7], function(el, md)
			if getElementType(el) == "player" and md then 
				triggerClientEvent(el, "onClientHideExchangeWindow", el, pojazd)
			end
		end)
		
	   exports["ms-database"]:query("UPDATE ms_vehicles SET gielda=?, gieldaCena=?, gieldaMiejsce=? WHERE id=?", 1, tonumber(cena), miejsce, getElementData(pojazd, "vehicle:id"))
	else
      if isElement(gracz) then 
		triggerClientEvent(gracz, "onClientAddNotification", gracz, "Na giełdzie nie ma wolnych miejsc", "error")
	  end
	end
 end
end

addEvent("onPlayerTakeExchangeVehicle", true)
addEventHandler("onPlayerTakeExchangeVehicle", root, function(v)
  local p = client 
 
  local px,py,pz = getElementPosition(p)
  local vehx, vehy, vehz = getElementPosition(v)
  local x,y,z = getElementPosition(p)
  setElementPosition(v, 2454.42+math.random(1,30),-2113.62, 14)
  warpPedIntoVehicle(p, v)
  setElementData(v, "vehicle:exchange", false)
  setElementData(v, "vehicle:exchange:cena", false)
  local data = getElementData(v, "vehicle:exchange:miejsce") or 0
  places[data][5] = true
  destroyElement(places[data][6])
  destroyElement(places[data][7])
  setElementData(v, "vehicle:exchange:miejsce", false)
  setElementFrozen(v, false)
  setElementData(v, "vehicle:text", "")
  exports["ms-database"]:query("UPDATE ms_vehicles SET gielda=?, gieldaCena=?, gieldaMiejsce=? WHERE id=?", 0, 0, 0, getElementData(v, "vehicle:id"))
  triggerClientEvent(p, "onClientAddNotification", p, "Pojazd zabrany z giełdy.", "success")
end)

addCommandHandler("wystaw", function(plr, cmd, cena)
 -- if getElementData(plr, "player:rank") ~= 3 then 
	-- triggerClientEvent(plr, "onClientAddNotification", plr, "Skrypt wyłączony.", "error")
	 --return 
  --end 
  
  if isPedInVehicle(plr) then
    if isElementWithinMarker(plr, sellMarker) then
      if tonumber(cena) and tonumber(cena) >= 10000 and tonumber(cena) <= 1999999 then
        local veh = getPedOccupiedVehicle(plr)
        local vehOwnerID = getElementData(veh, "vehicle:owner")
        local playerUID = getElementData(plr, "player:uid")
        if getElementData(veh, "vehicle:id") then
          if vehOwnerID == playerUID then
            if not getElementData(veh, "vehicle:exchange") then
              removePedFromVehicle(plr)
              wystawPojazd(plr, veh, cena)
              triggerClientEvent(plr, "onClientAddNotification", plr, "Wystawiłeś na sprzedaż pojazd marki "..getVehicleNameFromModel(getElementModel(veh)), "info")
            end
          else
            triggerClientEvent(plr, "onClientAddNotification", plr, "Nie jesteś właścicielem tego pojazdu.", "error")
          end
        else
          triggerClientEvent(plr, "onClientAddNotification", plr, "Ten pojazd nie jest prywatnym pojazdem!", "error")
        end
      else
        triggerClientEvent(plr, "onClientAddNotification", plr, "Poprawna komenda: /wystaw <cena>\nPamiętaj, że cena musi być większa od $10000 i mniejsza niż 2 miliony!", "info")
      end
    end
  else
    triggerClientEvent(plr, "onClientAddNotification", plr, "Aby użyć tej komendy, musisz przebywać w pojeździe.", "info")
  end
end)

addEvent("onPlayerBuyExchangeVehicle", true)
addEventHandler("onPlayerBuyExchangeVehicle", root, function(vehicle)
	local plr = client
	if getElementData(vehicle, "vehicle:exchange") then 
		if getElementData(plr, "player:level") < 5 then 
			triggerClientEvent(plr, "onClientAddNotification", plr, "Musisz mieć conajmniej 5 level by kupić prywatny pojazd.", "error")
			return
		end 

		local id = getElementData(vehicle, "vehicle:id")
		local price = getElementData(vehicle, "vehicle:exchange:cena")
		local place = getElementData(vehicle, "vehicle:exchange:miejsce")
		local money = getElementData(plr, "player:money")
		if not price or not place then 
			triggerClientEvent(plr, "onClientAddNotification", plr, "Wystąpił błąd. Napisz do administratora.", "error")
			return 
		end 
			
		if money < price then 
			triggerClientEvent(plr, "onClientAddNotification", plr, "Nie stać cię na ten pojazd.", "error")
			return
		end 
			
		local owner = getElementData(vehicle, "vehicle:owner")
		if owner == getElementData(plr, "player:uid") then 
			triggerClientEvent(plr, "onClientAddNotification", plr, "Nie możesz kupować swojego pojazdu.", "error")
			return
		end 
			
		-- dajemy wlascicielowi kase 
		local isOwnerOnServer = false 
		for k,v in ipairs(getElementsByType("player")) do 
			if getElementData(v, "player:uid") ==  owner then 
				isOwnerOnServer = v 
			end 
		end 
		
		if isOwnerOnServer then 
			local ownermoney = getElementData(isOwnerOnServer, "player:money") or 0 
			setElementData(isOwnerOnServer, "player:money", ownermoney+price)
				
			triggerClientEvent(isOwnerOnServer, "onClientAddNotification", isOwnerOnServer, getPlayerName(plr).." wykupił twój pojazd na giełdzie za $"..tostring(price).."!", "success", 30000)
		else 
			local mysql = exports["ms-database"]
			local ownermoney = mysql:getRows("SELECT `money` FROM `ms_players` WHERE `accountid`=?", owner)[1]["money"]
			mysql:query("UPDATE `ms_players` SET `money`=? WHERE `accountid`=?", ownermoney+price, owner)
		end 
			
		exports["ms-gameplay"]:msTakeMoney(plr, price)
			
		places[place][5] = true
		destroyElement(places[place][6])
		destroyElement(places[place][7])
		setElementData(vehicle, "vehicle:exchange", false)
		setElementData(vehicle, "vehicle:exchange:miejsce", false)
		setElementData(vehicle, "vehicle:exchange:cena", false)
			
		setElementData(vehicle, "vehicle:owner", getElementData(plr, "player:uid"))
		setElementData(vehicle, "vehicle:owner_name", getPlayerName(plr))
		
		setElementPosition(vehicle, 2454.42+math.random(1,30),-2113.62, 14)
		setElementFrozen(vehicle, false)
		setVehicleEngineState(vehicle, true)
		warpPedIntoVehicle(plr, vehicle)
		
		exports["ms-database"]:query("UPDATE ms_vehicles SET owner=?, ownerName=?, gielda=?, gieldaMiejsce=?, gieldaCena=? WHERE id=?", getElementData(plr, "player:uid"), getPlayerName(plr), 0, 0, 0, getElementData(vehicle, "vehicle:id"))
			
		triggerClientEvent(plr, "onClientAddNotification", plr, "Zakupiłeś pojazd pomyślnie!", "success")
	end
end)


function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end
