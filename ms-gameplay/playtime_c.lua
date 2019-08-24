local function update()
	if not getElementData(localPlayer, "player:uid") then return end
	if getElementData(localPlayer, "player:afk") then return end

	local playtime = getElementData(localPlayer, "player:playtime") or 0
	playtime = playtime+1
	setElementData(localPlayer, "player:playtime", playtime)

	local session = getElementData(localPlayer, "player:session_time") or 0
	session = session+1
	setElementData(localPlayer, "player:session_time", session)
end
setTimer(update, 1000, 0)

