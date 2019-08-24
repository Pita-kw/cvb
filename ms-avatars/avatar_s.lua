local mysql = exports["ms-database"]
local cache = {} 

function onDownloadAvatar(data, errno, player, uid)
	if errno == 0 then 
		if getElementData(player, "player:avatar") and #getElementData(player, "player:avatar") > 0 then 
			triggerClientEvent(player, "onClientGetAvatar", player, data, uid)
			cache[uid] = data 
		end 
	end 
end 

function onClientRequestAvatar(uid)
	local query = mysql:getSingleRow("SELECT `avatar`, `login` FROM `ms_accounts` WHERE `id`=?", uid)
	if not query then return end 
	
	local url = query["avatar"]
	local login = query["login"]
	if #url > 0 and #url < 200 then
		if getPlayerFromName(login) then 
			setElementData(getPlayerFromName(login), "player:avatar", url)
		end 
		
		if not cache[uid] then
			fetchRemote(url, 1, onDownloadAvatar, "", false, client, uid)
		else 
			triggerClientEvent(client, "onClientGetAvatar", client, cache[uid], uid)
		end 
	end 
end 
addEvent("onClientRequestAvatar", true)
addEventHandler("onClientRequestAvatar", root, onClientRequestAvatar)

function onPlayerResetAvatar(uid) -- aktualizacja u wszystkich 
	triggerClientEvent(root, "onClientResetAvatar", root, uid)
	cache[uid] = false 
end 
addEvent("onPlayerResetAvatar", true)
addEventHandler("onPlayerResetAvatar", root, onPlayerResetAvatar)

function onPlayerDeleteAvatar(uid) -- aktualizacja u wszystkich 
	local query = mysql:query("UPDATE `ms_accounts` SET `avatar`=? WHERE `id`=?", "", uid)
end 
addEvent("onPlayerDeleteAvatar", true)
addEventHandler("onPlayerDeleteAvatar", root, onPlayerDeleteAvatar)