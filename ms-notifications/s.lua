--[[
	MultiServer 
	Zasób: ms-notifications/s.lua
	Opis: Pokazywanie notyfikacji w pierdołowatych sytuacjach.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

function onPlayerChangeNick(oldNick, newNick, changedByUser)
	if not getElementData(source, "change:allow") then 
		cancelEvent() 
		return
	else
		setElementData(source, "change:allow", false)
	end
	
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:spawned") then 
			triggerClientEvent(v, "onClientAddNotification", v, oldNick.." zmienił nick na "..newNick..".", "info", 4000, false)
		end
	end
end 
addEventHandler("onPlayerChangeNick", root, onPlayerChangeNick)

function onPlayerEnterGame()
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:spawned") then 
			triggerClientEvent(v, "onClientAddNotification", v, getPlayerName(source).. " dołączył do gry.", "info", 3000, false)
		end
	end
end 
addEventHandler("onPlayerEnterGame", root, onPlayerEnterGame)

local polish = {
	["Timed out"] = "Crash",
	["Quit"] = "Wyjście",
}

function quitPlayer ( quitType )
for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:spawned") then 
			triggerClientEvent(v, "onClientAddNotification", v, getPlayerName(source).. " opuścił serwer. (" .. (polish[quitType] or quitType) .. ")", "error", 3000, false)
		end
	end	
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )

