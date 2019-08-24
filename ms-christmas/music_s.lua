function changeRadio(player, cmd, url)
	if tonumber(getElementData(player, "player:rank")) ~= 3 then return end
	
	if url then
		for k,v in ipairs(getElementsByType("player")) do
			triggerClientEvent(v, "updateRadioForPlayers", v, v, url)
		end
		triggerClientEvent(player, "onClientAddNotification", player, "Zmieniono stream!", "info")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Nie podałeś adresu URL!", "error")
	end
end
addCommandHandler("churl", changeRadio)
