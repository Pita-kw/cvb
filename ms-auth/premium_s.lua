function updatePremiumState()
	for k,v in ipairs(getElementsByType("player")) do 
		local premium = getElementData(v, "player:premium") or false
		if premium then 
			local now = getRealTime().timestamp 
			if now > premium then 
				triggerClientEvent(v, "onClientAddNotification", v, "Twoje konto premium straciło ważność.", "warning", 15000)
				setElementData(v, "player:premium", false)
			end
		end
	end
end 
setTimer(updatePremiumState, 60000, 0)