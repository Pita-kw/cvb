local mysql = exports["db"]

function getPlayerFriends(player)
	local uid = getElementData(player, "player:uid") or false
	if uid then
		local friends = {}

		local query = mysql:getRows("SELECT * FROM `ms_friends` WHERE `playerid`=?", uid)
		if #query == 0 then return {} end
		local friendsuid = fromJSON(query[1]["friends"]) or {}
		for k,v in ipairs(friendsuid) do
			local query2 = mysql:getSingleRow("SELECT `login`, `ts_last` FROM `ms_accounts` WHERE `id`=?", v)
			if query2 == nil then return {} end 
			local isOnline = getPlayerFromName(query2["login"])
			table.insert(friends, {query2["login"], query, isElement(isOnline), query2["ts_last"], v})
			table.sort(friends, function(a, b) return a[1] < b[1] end)
		end

		return friends
	end

	return false
end

function getPlayerFriendsUID(player)
	local uid = getElementData(player, "player:uid") or false
	if uid then
		local query = mysql:getRows("SELECT * FROM `ms_friends` WHERE `playerid`=?", uid)
		if #query < 1 then return {} end
		local friends = fromJSON(query[1]["friends"]) or {}

		return friends
	end

	return false
end

function invitePlayerToFriends(player, targetPlayer)
	local uid = getElementData(player, "player:uid") or false
	if uid then
		local targetPlayerUID = getElementData(targetPlayer, "player:uid") or false
		if not targetPlayerUID then return false end

		local friends = getPlayerFriendsUID(player)
		for k,v in ipairs(friends) do
			if v == targetPlayerUID then
				triggerClientEvent(player, "onClientAddNotification", player, "Masz już tego gracza w znajomych!", "error")
				return
			end
		end

		local friends = getPlayerFriendsUID(targetPlayer)
		for k,v in ipairs(friends) do
			if v == uid then
				triggerClientEvent(player, "onClientAddNotification", player, "Masz już tego gracza w znajomych!", "error")
				return
			end
		end

		exports["ms-achievements"]:addAchievement(player, "Dusza towarzystwa")
		triggerClientEvent(targetPlayer, "onClientShowInvitationWindow", targetPlayer, getPlayerName(player))
		triggerClientEvent(player, "onClientAddNotification", player, "Wysłałeś zaproszenie do znajomych graczowi "..getPlayerName(targetPlayer).."!", "info")
		return true
	end

	return false
end

function addPlayerToFriends(player, targetuid)
	local uid = getElementData(player, "player:uid") or false
	if uid and targetuid then
		-- dodanie nam znajomego
		local query = mysql:getRows("SELECT * FROM `ms_friends` WHERE `playerid`=?", uid)
		local friends = {}
		if #query < 1 then
			mysql:query("INSERT INTO `ms_friends` VALUES (?, ?, ?)", nil, uid, toJSON({targetuid}))
			friends = {}
		else
			friends = fromJSON(query[1]["friends"]) or {}
		end

		for k,v in ipairs(friends) do
			if v == targetuid and #friends > 1 then
				triggerClientEvent(player, "onClientAddNotification", player, "Masz już tego gracza w znajomych!", "error")
				return
			end
		end

		table.insert(friends, targetuid)
		mysql:query("UPDATE `ms_friends` SET `friends`=? WHERE `playerid`=?", toJSON(friends), uid)

		-- dodanie drugiemu graczowi nas
		local query = mysql:getRows("SELECT * FROM `ms_friends` WHERE `playerid`=?", targetuid)
		local friends = {}
		if #query < 1 then
			mysql:query("INSERT INTO `ms_friends` VALUES (?, ?, ?)", nil, targetuid, toJSON({uid}))
			friends = {}
		else
			friends = fromJSON(query[1]["friends"]) or {}
		end

		table.insert(friends, uid)
		mysql:query("UPDATE `ms_friends` SET `friends`=? WHERE `playerid`=?", toJSON(friends), targetuid)
		return true
	end

	return false
end

function removePlayerFromFriends(player, targetuid)
	local uid = getElementData(player, "player:uid") or false
	if uid and targetuid then
		-- usunięcie nam znajomego
		local query = mysql:getRows("SELECT * FROM `ms_friends` WHERE `playerid`=?", uid) 
		local friends = fromJSON(query[1]["friends"])
		for k,v in ipairs(friends) do
			if v == targetuid then
				table.remove(friends, k)
			end
		end
		mysql:query("UPDATE `ms_friends SET `friends`=? WHERE `playerid`=?", toJSON(friends), uid)

		-- usunięcie nas drugiemu graczowi
		local query = mysql:getRows("SELECT * FROM `ms_friends` WHERE `playerid`=?", targetuid)
		local friends = fromJSON(query[1]["friends"])
		for k,v in ipairs(friends) do
			if v == uid then
				table.remove(friends, k)
			end
		end
		mysql:query("UPDATE `ms_friends SET `friends`=? WHERE `playerid`=?", toJSON(friends), targetuid)

		return true
	end

	return false
end

function onPlayerAcceptInvite(whoInvited)
	if client and whoInvited then
		local findPlayer = false
		for k,v in ipairs(getElementsByType("player")) do
			if getElementData(v, "player:uid") == whoInvited then
				findPlayer = v
			end
		end

		if findPlayer then
			addPlayerToFriends(client, whoInvited)
		end
	end
end
addEvent("onPlayerAcceptInvite", true)
addEventHandler("onPlayerAcceptInvite", root, onPlayerAcceptInvite)
