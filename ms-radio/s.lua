DEFAULT_VEHICLE_RADIOS = {
	{name="RMF FM", url="http://www.rmfon.pl/n/rmffm.pls"},
	{name="Eska", url="http://acdn.smcloud.net/t046-1.mp3.pls"},
	{name="Eska Rock", url="http://acdn.smcloud.net/t041-1.mp3.pls"},
	{name="Radio Zet", url="http://zet-net-01.cdn.eurozet.pl:8400/listen.pls"},
	{name="RMF MAXX", url="http://www.rmfon.pl/n/rmfmaxxx.pls"},
	{name="Antyradio", url="http://ant-waw-01.cdn.eurozet.pl:8602/listen.pls"},
}

function onPlayerRequestRadios()
	if client then 
		local query = exports["ms-database"]:getRows("SELECT * FROM ms_radio WHERE uid=?", getElementData(client, "player:uid"))
		triggerClientEvent(client, "onClientLoadRadios", client, query)
	end
end 
addEvent("onPlayerRequestRadios", true)
addEventHandler("onPlayerRequestRadios", root, onPlayerRequestRadios)

function onPlayerSaveRadio(name, url)
	if client and name and url then 
		exports["ms-database"]:query("INSERT INTO ms_radio VALUES (?, ?, ?, ?, ?)", nil, getElementData(client, "player:uid"), name, url, 0)
		triggerClientEvent(client, "onClientAddNotification", client, "Dodano utwór: "..tostring(name)..".", "success")
	end
end 
addEvent("onPlayerSaveRadio", true)
addEventHandler("onPlayerSaveRadio", root, onPlayerSaveRadio)

function onPlayerDeleteRadio(id, name)
	if client and id and name then 
		if id ~= -1 then exports["ms-database"]:query("DELETE FROM ms_radio WHERE `id`=?", id) end
		triggerClientEvent(client, "onClientAddNotification", client, "Usunąłeś utwór: "..tostring(name)..".", "info")
	end 
end
addEvent("onPlayerDeleteRadio", true)
addEventHandler("onPlayerDeleteRadio", root, onPlayerDeleteRadio)

function onPlayerUseVehicleRadio(name, url)
	if client and name and url then 
		local vehicle = getPedOccupiedVehicle(source)
		if vehicle then 
			for k, player in pairs(getVehicleOccupants(vehicle)) do 
				triggerClientEvent(player, "onClientUpdateVehicleRadio", player, name, url)
			end
		end
	end
end 
addEvent("onPlayerUseVehicleRadio", true)
addEventHandler("onPlayerUseVehicleRadio", root, onPlayerUseVehicleRadio)

function onPlayerUpdateVehicleRadio(id, state)
	if client and id and state then 
		exports["ms-database"]:query("UPDATE ms_radio SET `vehicle`=? WHERE `id`=?", state, id)
	end
end 
addEvent("onPlayerUpdateVehicleRadio", true)
addEventHandler("onPlayerUpdateVehicleRadio", root, onPlayerUpdateVehicleRadio)

-- robimy domyślne radia dla gracza, który założył konto

-- COŚ UID NIE WCZYTUJE

--function onPlayerCreateAccount()
	--for k,v in ipairs(DEFAULT_VEHICLE_RADIOS) do
		--exports["ms-database"]:query("INSERT INTO ms_radio VALUES (?, ?, ?, ?, ?)", nil, getElementData(source, "player:uid"), v.name, v.url, 1)
	--end
--end 
--addEventHandler("onPlayerCreateAccount", root, onPlayerCreateAccount)


function onVehicleEnter(player, seat)
	if player and seat ~= 0 then 
		local radio = getElementData(source, "vehicle:current_radio") or {name=-1, url=-1}
		triggerClientEvent(player, "onClientUpdateVehicleRadio", player, radio.name, radio.url)
	end
end 
addEventHandler("onVehicleEnter", root, onVehicleEnter)


function knockTroll(player, cmd, arg1)
	if getElementData(player, "player:rank") ~= 3 then return end
	
	if arg1 then
		for k,v in pairs(getElementsByType("player")) do 
			if getElementData(v, "player:id") == tonumber(arg1) then 
				triggerClientEvent(v, "playKnockSound", v)
			end
		end
	end
end
addCommandHandler("kkt", knockTroll)

function knockTroll(player, cmd, arg1)
	if getElementData(player, "player:rank") ~= 3 then return end
	
	if arg1 then
		for k,v in pairs(getElementsByType("player")) do 
			if getElementData(v, "player:id") == tonumber(arg1) then 
				triggerClientEvent(v, "playKnockSound2", v)
			end
		end
	end
end
addCommandHandler("ort", knockTroll)
