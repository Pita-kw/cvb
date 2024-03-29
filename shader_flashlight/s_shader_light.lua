--
--s_shader_light.lua
-- 

local isFlon = {}
local isFlen = {}

function remotePlayerJoin()
	isFlon[client] = false
	isFlen[client] = false
	for _,thisPlayer in ipairs(getElementsByType("player")) do		
		triggerClientEvent(client,"flashOnPlayerEnable", resourceRoot, isFlen[thisPlayer], thisPlayer)
		triggerClientEvent(client,"flashOnPlayerSwitch", resourceRoot, isFlon[thisPlayer], thisPlayer)
	end		
end

function remotePlayerQuit()
	if getElementType ( source ) == "player" then
		isFlon[source] = false
		isFlen[source] = false
		triggerClientEvent ("flashOnPlayerQuit", resourceRoot, source)
	end
end

function remoteSwitch(isON)
	isFlon[client] = isON 
	triggerClientEvent ("flashOnPlayerSwitch", resourceRoot, isFlon[client], client)
end

function remoteEnable(isEN)
	isFlen[client] = isEN 
	triggerClientEvent ("flashOnPlayerEnable", resourceRoot, isFlen[client], client)
end
 
function getPlayerInterior(thisPlayer)
	if getElementType (client) == "player" then
		local interior = getElementInterior(thisPlayer)
		local dim = getElementDimension(thisPlayer)
		triggerClientEvent (client, "flashOnPlayerInter", resourceRoot, thisPlayer, interior, dim)
	end
end 
 
addEventHandler("onPlayerQuit", root, remotePlayerQuit)

addEvent("onPlayerGetInter",true)
addEventHandler("onPlayerGetInter", resourceRoot, getPlayerInterior)

addEvent("onPlayerStartRes",true)
addEventHandler("onPlayerStartRes", resourceRoot, remotePlayerJoin)

addEvent("onSwitchLight",true)
addEventHandler("onSwitchLight", resourceRoot, remoteSwitch)

addEvent("onSwitchEffect",true)
addEventHandler("onSwitchEffect", resourceRoot, remoteEnable)