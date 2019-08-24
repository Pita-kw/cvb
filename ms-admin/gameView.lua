--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>, l0nger <l0nger.programmer@gmail.com>
	@filename: gameView.lua
	@desc: czat administracyjny
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]


local gameView_td=textCreateDisplay()
local gameView_item=textCreateTextItem('', 0.01, 0.35, 'medium', 255, 255, 255, 255, 1.0, 'left', 'top', 255)
local gameView_contents={'Restart zasobu ms-admin'}
textDisplayAddText(gameView_td, gameView_item)

for i,v in pairs(getElementsByType('player')) do
	if getElementData(v, 'player:rank') and getElementData(v, 'player:rank')>2 then
		textDisplayAddObserver(gameView_td, v)
	end
end

local function refreshGameView()
	local txt=table.concat(gameView_contents, '\n')
	textItemSetText(gameView_item, txt)
end

function gameView_add(text)
	table.insert(gameView_contents, text)
	if #gameView_contents>10 then
		table.remove(gameView_contents, 1)
	end
	refreshGameView()
end

addCommandHandler('agv', function(plr, cmd)
	if getElementData(plr, 'player:rank') < 2 then return end 
	
	if (textDisplayIsObserver(gameView_td, plr)) then
		textDisplayRemoveObserver(gameView_td, plr)
	else
		textDisplayAddObserver(gameView_td, plr)
	end
	
	outputChatBox(textDisplayIsObserver(gameView_td, plr) and ('* Włączono gameView.') or ('* Wyłączono gameView.'), plr)
end)

addEventHandler('onPlayerQuit', root, function()
	if (textDisplayIsObserver(gameView_td, source)) then
		textDisplayRemoveObserver(gameView_td, source)
	end
end)

refreshGameView()