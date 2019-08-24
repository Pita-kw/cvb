local mysql=exports['ms-database']
local players_takes = {}
local allow_gifts = true


function getPlayersList()
	local query = mysql:getRows("SELECT `accountid` FROM `ms_players` WHERE `take_reward`=1")
	local marker = createMarker(-2348.81,-1632.55,489.03-1, "cylinder", 0.8, 255, 0, 0, 255)
	local gift_sphere = createColSphere(-2348.81,-1632.55,489.03, 1.5)
	addEventHandler ("onColShapeHit", gift_sphere, giveGiftForPlayer)
	
	for k,v in ipairs(query) do
		table.insert(players_takes, tonumber(v.accountid))
		outputDebugString("[ms-christmas] Wczytano gracza o UID: ".. v.accountid ..".")
	end
	
	outputDebugString("[ms-christmas] Wczytano ".. #query .." graczy.")
end
addEventHandler("onResourceStart", getResourceRootElement(), getPlayersList)


function updatePlayersList(player)
	local uid = getElementData(player, "player:uid")
	
	if uid then 
		local query=mysql:query("UPDATE `ms_players` SET `take_reward`=1 WHERE `accountid`=?", uid)
		table.insert(players_takes, tonumber(uid))
		outputDebugString("[ms-christmas] Dodano ".. getPlayerName(player) .." do listy.")
	end
end


function giveGiftForPlayer(player, md)
		local uid = getElementData(player, "player:uid")
		local take = false
		local time = getRealTime()
		
		if not allow_gifts then
			triggerClientEvent(player, "onClientAddNotification", player, "Mikołaj pakuje prezenty!", "error")
			return
		end
		
		for k,v in ipairs(players_takes) do 
			if tonumber(v) == tonumber(uid) then
				take = true
				break
			else
				take = false
			end
		end
		
		
		if take == true then
			triggerClientEvent(player, "onClientAddNotification", player, "Już otrzymałeś prezent!", "error")
		else
			triggerClientEvent(player, "onClientAddNotification", player, "Otrzymałeś prezent od mikołaja! A w nim znajduje się konto premium na 7 dni, 50,000$ oraz 100 exp! Wesołych Świąt!", {type="error", custom="image", x=0, y=0, w=40, h=40, image=":ms-christmas/gift.png"}, 30000, false)
			updatePlayersList(player)
			triggerEvent("onPlayerBuyPremium", player, player, 7, 250, true)
			exports["ms-gameplay"]:msGiveMoney(player, 50000)
			exports["ms-gameplay"]:msGiveExp(player, 100)
		end
end


function allowGifts(player)
	if tonumber(getElementData(player, "player:rank")) ~= 3 then return end
	
	if allow_gifts == false then
		allow_gifts = true
		triggerClientEvent(player, "onClientAddNotification", player, "Odblokowano prezenty!", "success")
	else
		allow_gifts = false
		triggerClientEvent(player, "onClientAddNotification", player, "Zablokowano prezenty!", "info")
	end
end
addCommandHandler("allowgifts", allowGifts)
