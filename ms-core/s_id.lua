--[[
	@project: fullgaming
	@author: l0nger <l0nger.programmer@gmail.com>, Wielebny
	@filename: s_id.lua
	@desc: unique id
]]

function findPlayer(plr,cel)
	local target=nil
	if (tonumber(cel) ~= nil) then
		target=getElementByID('id'..cel)
	else -- podano fragment nicku
		for _,thePlayer in pairs(getElementsByType('player')) do
			if string.find(string.gsub(getPlayerName(thePlayer):lower(),'#%x%x%x%x%x%x', ''), cel:lower(), 1, true) then
				if (target) then
					outputChatBox('Znaleziono wiecej niz jednego gracza o pasujacym nicku, podaj wiecej liter.', plr)
					return nil
				end
				target=thePlayer
			end
		end
	end
	return target
end

local function findFreeValue(tablica_id)
	table.sort(tablica_id)
	local wolne_id=1
	for i,v in ipairs(tablica_id) do
		if (v==wolne_id) then wolne_id=wolne_id+1 end
		if (v>wolne_id) then return wolne_id end
	end
	return wolne_id
end

function assignPlayerID(plr)
	local gracze=getElementsByType('player')
	local tablica_id = {}
	for i,v in pairs(gracze) do
		local lid=getElementData(v, 'player:id')
		if (lid) then
			table.insert(tablica_id, tonumber(lid))
		end
	end
	local free_id=findFreeValue(tablica_id)
	
	setElementData(plr,'player:id', free_id)
	setElementID(plr, 'p' .. free_id)
	return free_id
end

function getPlayerID(plr)
	if not plr then return '' end
	local id=getElementData(plr,'player:id')
	if (id) then
		return id
	else
		return assignPlayerID(plr)
	end
	
end

addEventHandler('onResourceStart', resourceRoot, function()
	for i,v in pairs(getElementsByType('player')) do
		assignPlayerID(v)
	end
end)

addEventHandler('onPlayerJoin', root, function()
	assignPlayerID(source)
end)