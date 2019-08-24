local player1 = false
local player2 = false

function sendFightingPlayers(p1, p2)
	player1 = p1
	player2 = p2
end
addEvent("sendFightingPlayers", true)
addEventHandler("sendFightingPlayers", getRootElement(), sendFightingPlayers)


function checkKSWDamages ( attacker, weapon, bodypart )
	if source == player1 or source == player2 then
		if attacker ~= player1 and attacker ~= player2 then 
			cancelEvent()
			return
		end
	end	
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), checkKSWDamages)