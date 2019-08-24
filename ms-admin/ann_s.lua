local MESSAGE_MINIMUM = 5 
local MESSAGE_MAXIMUM = 120

function og(player, cmd, ...)
	if not getElementData(player, "player:spawned") then return end 
	local rank = getElementData(player, "player:rank") or 0 
	if rank < 3 then return end 
	
	local message=table.concat({ ... }, ' ')
	if #message > MESSAGE_MINIMUM and #message < MESSAGE_MAXIMUM then 
		outputServerLog("[LOG] Administrator "..getPlayerName(player).." włączył rann o treści "..message..".")
		gameView_add("[LOG] Administrator "..getPlayerName(player).." włączył rann o treści "..message..".")
		
		triggerClientEvent(root, "onClientShowRCONAnn", root, message)
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Twoja wiadomość musi mieć conajmniej "..tostring(MESSAGE_MINIMUM).." i maksimum "..tostring(MESSAGE_MAXIMUM).." znaków.", "error")
	end
end 
addCommandHandler("rann", og)

addCommandHandler("tts", function(player, cmd, ...)
	if not getElementData(player, "player:spawned") then return end 
	local rank = getElementData(player, "player:rank") or 0 
	if rank < 3 then return end 
	
	local message=table.concat({ ... }, ' ')
	triggerClientEvent(root, "onClientGetTextToSpeech", root, message)
end)