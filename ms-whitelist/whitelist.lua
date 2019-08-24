--[[
	@project: multiserver
	@author: l0nger <l0nger.programmer@gmail.com>
	@filename: whitelist.lua
	@desc: biala lista
]]

local WHITELIST_ENABLED=true

-- functions
function setWhitelistEnabled(bool)
	WHITELIST_ENABLED=bool

	if bool==true then
		outputDebugString('WHITELIST ENABLED')
	else
		outputDebugString('WHITELIST DISABLED')
	end
end

function existsPlayerInWhitelist(serial)
	if not WHITELIST_ENABLED then return end

	local results=exports['ms-database']:getSingleRow('SELECT id FROM ms_whitelist WHERE serial=? LIMIT 1;', serial)
	if not results or not results.id then
		return false
	end
	return true
end

function addPlayerToWhiteList(serial, data)
	if not WHITELIST_ENABLED then return end

	local results=exports['ms-database']:query('INSERT INTO ms_whitelist (serial, notes) VALUES (?, ?)', serial, data)
	if results then
		return true
	end
	return false
end

addCommandHandler('cipsko', function(plr, cmd, serial, nick)
	if not WHITELIST_ENABLED then return end
	if not serial then return end
	if not nick then return end
	if getElementData(plr, 'player:rank')~=3 then return end

	addPlayerToWhiteList(serial, ('NICK: %s'):format(nick))
	outputChatBox('Dodano do bialej listy ' ..nick, plr)
end)

-- events
addEventHandler('onPlayerConnect', root, function(nick, IP, user, serial, versionNumber, versionString)
	if not WHITELIST_ENABLED then return end
	if not existsPlayerInWhitelist(serial) then
		cancelEvent(true, 'ROZŁACZONO! INFO W KONSOLI (~)!')
		--kickPlayer(source, 'ROZŁACZONO! INFO W KONSOLI (~)!')

		outputServerLog('[WHITELIST]: FAIL - NICK: ' ..nick.. ' IP: ' ..IP)
		outputDebugString('[WHITELIST]: FAIL - NICK: ' ..nick.. ' IP: ' ..IP)
		return
	end
	outputServerLog('[WHITELIST]: SUCCESS - NICK: ' ..nick.. ' IP: ' ..IP)
end)
