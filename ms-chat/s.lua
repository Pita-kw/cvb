-- chat MTA
function isIP(ip)
    if ip == nil or type(ip) ~= 'string' then
        return false
    end

    local chunks = {ip:match('(%d+)%.(%d+)%.(%d+)%.(%d+)')}
    if (#chunks == 4) then
        for _,v in pairs(chunks) do
            if (tonumber(v) < 0 or tonumber(v) > 255) then
                return false
            end
        end
        return true
    else
        return false
    end

	return false
end

function isColor(color)
	if color == nil or type(color) ~= 'string' then
        return false
    end
	
	if color:match('#%x%x%x%x%x%x') then 
		return true 
	end 
end
 
local rankTags = {
	["premium"] = "#FFD000V",
	[0] = "#FFFFFFG",
	[1] = "#00CC00M",
	[2] = "#0099FFA",
	[3] = "#990000HA",
}

local nickColors = {
	{26, 188, 156},
	{46, 204, 113},
	{52, 152, 219},
	{155, 89, 182},
	{52, 73, 94},
	{22, 160, 133},
	{39, 174, 96},
	{41, 128, 185},
	{142, 68, 173},
	{44, 62, 80},
	{241, 196, 15},
	{230, 126, 34},
	{231, 76, 60},
	{236, 240, 241},
	{149, 165, 166},
	{243, 156, 18},
	{211, 84, 0},
	{192, 57, 43},
	{189, 195, 199},
	{127, 140, 141},
}

function onPlayerChat(message, messageType)
	if not getElementData(source, 'player:spawned') then cancelEvent() return end
	
	local blockPlayerChat = getElementData(source, 'player:blockChat') or 0
	local time = math.ceil(blockPlayerChat/1000)  
	
	if blockPlayerChat > 0 then
		triggerClientEvent(source, "onClientAddNotification", source, "Jesteś uciszony! Będziesz mógł pisać za ".. time .." sekund", "warning")
		cancelEvent()
		return
	end
	
	if isIP(message) then
		outputChatBox('* Podawanie IP na czacie jest niedozwolone.', source, 255, 0, 0)
		triggerClientEvent(source, "onClientAddNotification", source, "Podawanie adresów IP nie jest dozwolone!", "error")
		setElementData(source, 'player:lastMessage', getTickCount()+3000)
		cancelEvent()
		return
	end

	if isColor(message) then 
		triggerClientEvent(source, "onClientAddNotification", source, "Kolorowanie wiadomości nie jest dozwolone!", "error")
		setElementData(source, 'player:lastMessage', getTickCount()+3000)
		cancelEvent()
		return
	end 
		
	
	if #message:gsub('%s+', '') == 0 then 
		cancelEvent()
		return 
	end 
	
	if (getElementData(source, 'player:rank') or 0)<3 then
		local now = getTickCount()
		local lastMessageTick = getElementData(source, 'player:lastMessage') or 0
		if lastMessageTick > now then
			local time = math.ceil((lastMessageTick-now)/1000)  
			outputChatBox('* Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', source, 255, 0, 0)
			triggerClientEvent(source, "onClientAddNotification", source, 'Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', "error")
			setElementData(source, 'player:lastMessage', lastMessageTick+400)
			cancelEvent()
			return
		end
	end
	
	local nickColor = getElementData(source, "player:nickColor")
	
	local name = getPlayerName(source)
	local gang = getElementData(source, "player:gang")
	local id = getElementData(source, 'player:id')
	
	if messageType == 0 then
		local logged = false 
		
		for k,v in pairs(getElementsByType('player')) do
			local x, y, z = getElementPosition(source)
			local x2, y2, z2 = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if string.find(message, '%$', 1)==1 and getElementData(source, 'player:premium') then
				local msg=string.sub(message, 2, #message)
				if getElementData(v, 'player:premium') then 
					outputChatBox('#FFD000VIPCHAT#999999 #BFBFBF'..tostring(id)..' #FFFFFF'..name..'#FFFFFF: '..string.gsub(msg, '#%x%x%x%x%x%x', ''), v, 255, 255, 255, true)
					cancelEvent()
					if not logged then 
						logged = true
						exports['ms-admin']:gameView_add('[VIPCHAT] ['..tostring(id)..'] '..name..': '..string.gsub(msg, '#%x%x%x%x%x%x', ''))
						outputServerLog('[VIPCHAT] ['..tostring(getElementData(source, "player:uid"))..'] '..name..': '..string.gsub(msg, '#%x%x%x%x%x%x', '')) 
					end 
				end  
			elseif string.find(message, '@', 1)==1 and getElementData(source, 'player:rank')>0 then 
				local msg = string.sub(message, 2, #message)
				local rank = getElementData(v, 'player:rank')
				if rank and rank>0 then 
					outputChatBox('#ff0000ACHAT #BFBFBF'..tostring(id)..' #FFFFFF'..name..'#FFFFFF: '..string.gsub(msg, '#%x%x%x%x%x%x', ''), v, 255, 255, 255, true)
					if not logged then 
						logged = true 
						outputServerLog('[ACHAT] ['.. tostring(getElementData(source, "player:uid")) ..'] '..name..': '..string.gsub(msg, '#%x%x%x%x%x%x', '')) 
					end 
					cancelEvent()
				end
			elseif string.find(message, '#', 1)==1 then 
				if gang then 
					local playerGang = getElementData(v, "player:gang")
					if playerGang and playerGang.id == gang.id then 
						local r, g, b = gang.color[1], gang.color[2], gang.color[3]
						local hex = string.format("#%02X%02X%02X", r, g, b)
						local msg = string.sub(message, 2, #message)
						outputChatBox(hex..'GANG #BFBFBF'..tostring(id)..' #BFBFBF(#FFFFFF'..gang.rank..'#BFBFBF) #FFFFFF'..name..'#FFFFFF: '..string.gsub(msg, '#%x%x%x%x%x%x', ''), v, 255, 255, 255, true)
						if not logged then 
							logged = true 
							outputServerLog('[GANG '..gang.name..'] ['.. tostring(getElementData(source, "player:uid")) ..' '..name..': '..string.gsub(msg, '#%x%x%x%x%x%x', ''))
							exports['ms-admin']:gameView_add('[GANG '..gang.name..'] ['..tostring(getElementData(source, "player:uid"))..'] '..name..': '..string.gsub(msg, '#%x%x%x%x%x%x', ''))
						end 
					end
				end
			else 
				local rank = getElementData(source, 'player:rank') or 0
				if rank == 0 then
					if getElementData(source, "player:premium") then 
						rank = "premium"
					end
				end 

				local info = '#BFBFBF('..rankTags[rank]..'#BFBFBF'
				if gang then 
					local tag = gang.tag
					local color = gang.color
					local r, g, b = color[1], color[2], color[3]
					local hex = string.format("#%02X%02X%02X", r, g, b)
					info = info..'|'..hex..tag..'#BFBFBF)#FFFFFF'
				else 
					info = info..')#FFFFFF'
				end
				
				outputChatBox('#BFBFBF'..tostring(id)..' '..nickColor..getPlayerName(source)..info..': '..string.gsub(message, '#%x%x%x%x%x%x', ''), v, 255, 255, 255, true)
				if not logged then 
					logged = true
					outputServerLog("[GŁÓWNY]: [".. getElementData(source, "player:uid") .."] ".. name ..": ".. message)
					exports['ms-admin']:gameView_add("[GŁÓWNY]: ".. name ..": ".. message)
				end
			end 
		end
		
		cancelEvent()
	elseif messageType == 1 then
		cancelEvent()
	elseif messageType == 2 then
		cancelEvent()
	end

	setElementData(source, 'player:lastMessage', getTickCount()+1000)
end
addEventHandler('onPlayerChat', root, onPlayerChat)

addEventHandler('onPlayerCommand', root,
	function(cmd)
		if cmd == 'msg' then 
			cancelEvent()
		end 
	end 
)
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == 'number' and type(y) == 'number' and type(z) == 'number' and type(range) == 'number' then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

function pw(player, cmd, toPlayer, ...)
	if not getElementData(player, 'player:uid') then return end 
	
	local now = getTickCount()
	local lastMessageTick = getElementData(player, 'player:lastMessage') or 0
	
	local blockPlayerChat = getElementData(player, 'player:blockChat') or 0
	local time = math.ceil(blockPlayerChat/1000)  
	
	if blockPlayerChat > 0 then
		triggerClientEvent(source, "onClientAddNotification", source, "Jesteś uciszony! Będziesz mógł pisać za ".. time .." sekund", "warning")
		cancelEvent()
		return
	end
	
	if lastMessageTick > now then
		local time = math.ceil((lastMessageTick-now)/1000)  
		outputChatBox('Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', player, 255, 0, 0)
		setElementData(player, 'player:lastMessage', lastMessageTick+400)
		cancelEvent()
		return
	end
	setElementData(player, 'player:lastMessage', getTickCount()+3000)
	
	local playerID = getElementData(player, 'player:id')
	local target = false 
	for k,v in pairs(getElementsByType('player')) do 
		if getElementData(v, 'player:id') == tonumber(toPlayer) then 
			target = v 
		end 
	end 
	
	local message = table.concat({ ... }, ' ')
	if isIP(message) then 
		outputChatBox('>> Podawanie IP na czacie jest niedozwolone.', player, 255, 0, 0)
		return 
	end 
	
	if playerID == tonumber(toPlayer) then triggerClientEvent(player, 'onClientAddNotification', player, 'Nie możesz wysyłać wiadomości do siebie', 'error') return end 
	if #message < 1 then triggerClientEvent(player, 'onClientAddNotification', player, 'Prawidłowe użycie: \n/pw/pm/w <id gracza> <wiadomość>', 'error') return end 
	if target and getElementType(target) == 'player' then 
		local pwDisabled = getElementData(target, 'player:pwDisabled') or false 
		
		if pwDisabled == true then  
			triggerClientEvent(player, 'onClientAddNotification', player, 'Ten gracz ma wyłączone prywatne wiadomości.', 'error') 
			return 
		end 
		
		if getElementData(target, 'player:afk') then 
			outputChatBox('>> [AFK] ['..toPlayer..'] '..getPlayerName(target)..': '..message, player, 255, 153, 51)
		else 
			outputChatBox('>> ['..toPlayer..'] '..getPlayerName(target)..': '..message, player, 255, 153, 51)
		end 
		
		outputChatBox('<< ['..tostring(playerID)..'] '..getPlayerName(player)..': '..message, target, 255, 153, 51)
		triggerClientEvent(target, "onClientAddNotification", target, "Otrzymałeś prywatną wiadomość!", {type="message", custom="image", x=0, y=0, w=40, h=40, image=":ms-chat/message.png"}, 3000)
		exports['ms-admin']:gameView_add('[PW] ['..tostring(playerID)..']'..getPlayerName(player)..' -> ['..tostring(toPlayer)..']'..getPlayerName(target)..': '..message)
		--triggerClientEvent(root, 'onInsertPreview', root, '[PW] ['..tostring(playerID)..']'..getPlayerName(player)..' -> ['..tostring(toPlayer)..']'..getPlayerName(target)..': '..message)
		outputServerLog('[PW] ['.. tostring(getElementData(player, "player:uid")) ..']'..getPlayerName(player)..' -> ['..tostring(getElementData(target, "player:uid"))..']'..getPlayerName(target)..': '..message)
		triggerClientEvent(target, "onClientCreateTrayNotification", target, "Otrzymałeś prywatną wiadomość od "..getPlayerName(player).."!", "default")
	else
		triggerClientEvent(player, 'onClientAddNotification', player, 'Nie znaleziono takiego gracza.', 'error') 
	end
end
addCommandHandler('pm', pw)
addCommandHandler('pw', pw)
addCommandHandler('w', pw)

-- voice chat
-- kanały:
-- 1 - lokalny czat
-- potem pomyślimy jak zrealizować resztę :P
function setPlayerVoiceChannel(player, voiceChannel)
	setElementData(player, 'voice:channel', voiceChannel)

	local players = {}
	for k,v in ipairs(getElementsByType('player')) do
		local playerVoiceChannel = getElementData(player, 'voice:channel') or -1
		if playerVoiceChannel == voiceChannel then
			table.insert(players, v)
		end
	end

	setPlayerVoiceBroadcastTo(player, players)
	setPlayerVoiceIgnoreFrom(player, nil)
end

function onPlayerJoin()
	setPlayerVoiceIgnoreFrom(source, getElementsByType('player'))
	
	local nickColor = getElementData(source, "player:nickColor") or false 
	if not nickColor then 
		local rand = math.random(1, #nickColors)
		local color = nickColors[rand]
		local r, g, b = color[1], color[2], color[3]
		local hex = string.format("#%02X%02X%02X", r, g, b)
		nickColor = hex 
		setElementData(source, "player:nickColor", hex)
	end

	bindKey(source,"U","down","chatbox","Lokalny") 	
end
addEventHandler('onPlayerJoin', root, onPlayerJoin)

setTimer(
	function()
		for k,v in ipairs(getElementsByType('player')) do
			if getElementData(v, 'player:uid') then 
				setPlayerVoiceChannel(v, 1)
			else 
				setPlayerVoiceIgnoreFrom(v, getElementsByType('player'))
			end 
		end
	end, 1000, 0)

-- local chat
chat_range=30 
  
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()), 
function () 
	for index, player in pairs(getElementsByType("player")) do 
		bindKey(player,"U","down","chatbox","Lokalny") 
	end 
end) 
  
function isPlayerInRangeOfPoint(player,x,y,z,range) 
   local px,py,pz=getElementPosition(player) 
   return ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5<=range 
end 

 
function onChat(player,_,...) 
	local px,py,pz=getElementPosition(player) 
	local msg = table.concat({...}, " ") 
	local nick=getPlayerName(player) 
	local now = getTickCount()
	local lastMessageTick = getElementData(player, "player:lastMessage") or 0
	
	local blockPlayerChat = getElementData(player, 'player:blockChat') or 0
	local time = math.ceil(blockPlayerChat/1000)  
	
	if blockPlayerChat > 0 then
		triggerClientEvent(source, "onClientAddNotification", source, "Jesteś uciszony! Będziesz mógł pisać za ".. time .." sekund", "warning")
		cancelEvent()
		return
	end
	
	if isColor(msg) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Kolorowanie wiadomości nie jest dozwolone!", "error")
		setElementData(player, 'player:lastMessage', getTickCount()+3000)
		cancelEvent()
		return
	end 
	
	if lastMessageTick > now then
			local time = math.ceil((lastMessageTick-now)/1000)  
			outputChatBox('* Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', player, 255, 0, 0)
			--triggerClientEvent(player, "onClientAddNotification", player, 'Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', "error")
			setElementData(player, 'player:lastMessage', lastMessageTick+400)
			cancelEvent()
			return
	end
	
	setElementData(player, 'player:lastMessage', getTickCount()+3000)
	
	for _,v in ipairs(getElementsByType("player")) do 
		if isPlayerInRangeOfPoint(v,px,py,pz,chat_range) then 
			if getElementData(player, 'player:rank')==3 then 
				outputChatBox("#9b9b9b[#3d87ffCzat lokalny#9b9b9b] [#BFBFBF"..tostring(getElementData(player, 'player:id')).."#999999]#990000"..nick..": #ffffff"..msg,v,30,30,200,true) 
			elseif getElementData(player, 'player:rank')==2 then 
				outputChatBox("#9b9b9b[#3d87ffCzat lokalny#9b9b9b]  [#BFBFBF"..tostring(getElementData(player, 'player:id')).."#999999]#179600"..nick..": #ffffff"..msg,v,30,30,200,true) 
			elseif getElementData(player, 'player:rank')==1 then 
				outputChatBox("#9b9b9b[#3d87ffCzat lokalny#9b9b9b]  [#BFBFBF"..tostring(getElementData(player, 'player:id')).."#999999]#74FF5C"..nick..": #ffffff"..msg,v,30,30,200,true) 
			else
				if getElementData(player, 'player:premium') then 
					outputChatBox("#9b9b9b[#3d87ffCzat lokalny#9b9b9b]  [#BFBFBF"..tostring(getElementData(player, 'player:id')).."#999999]#FFD000"..nick..": #ffffff"..msg,v,30,30,200,true) 
				else
					outputChatBox("#9b9b9b[#3d87ffCzat lokalny#9b9b9b]  [#BFBFBF"..tostring(getElementData(player, 'player:id')).."#999999]#FFFFFF"..nick..": #ffffff"..msg,v,30,30,200,true) 
				end
			end
		end 
	end 
	
	outputServerLog("[LOKALNY] ["..tostring(getElementData(player, "player:uid")).."] "..nick..": "..msg)
	exports["ms-admin"]:gameView_add("[LOCAL CHAT] ".. getPlayerName(player)..": ".. msg .."")
end 
addCommandHandler("Lokalny",onChat) 

function messageToPlayer(player, cmd, arg1, ...)
	
	local message = table.concat({...}, " ") 
	
	local now = getTickCount()
	local lastMessageTick = getElementData(player, "player:lastMessage") or 0
	
	local blockPlayerChat = getElementData(player, 'player:blockChat') or 0
	local time = math.ceil(blockPlayerChat/1000)  
	
	if blockPlayerChat > 0 then
		triggerClientEvent(source, "onClientAddNotification", source, "Jesteś uciszony! Będziesz mógł pisać za ".. time .." sekund", "warning")
		cancelEvent()
		return
	end
	
	if lastMessageTick > now then
			local time = math.ceil((lastMessageTick-now)/1000)  
			outputChatBox('* Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', player, 255, 0, 0)
			--triggerClientEvent(player, "onClientAddNotification", player, 'Odczekaj jeszcze '..tostring(time)..'s przed wysłaniem następnej wiadomości.', "error")
			setElementData(player, 'player:lastMessage', lastMessageTick+400)
			cancelEvent()
			return
	end
	
	if isColor(message) then 
		triggerClientEvent(player, "onClientAddNotification", player, "Kolorowanie wiadomości nie jest dozwolone!", "error")
		setElementData(player, 'player:lastMessage', getTickCount()+3000)
		cancelEvent()
		return
	end 
		
	if not arg1 or #message == 0 then 
		triggerClientEvent(player, "onClientAddNotification", player, "Wpisz /do [id gracza] [tekst].", "warning")
		return
	end
	
	setElementData(player, 'player:lastMessage', getTickCount()+3000)

	local targetPlayer = false 
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(arg1) then 
			targetPlayer = v
			break
		end
	end
	
	if not targetPlayer then 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie znaleziono takiego gracza.", "error")
		return
	end 
	
	local rank = getElementData(player, "player:rank") or 0
	if rank == 0 then
		if getElementData(player, "player:premium") then 
			rank = "premium"
		end
	end 

	local id = getElementData(player, "player:id")
	local gang = getElementData(player, "player:gang")
	local nickColor = getElementData(player, "player:nickColor")
	local targetNickColor = getElementData(targetPlayer, "player:nickColor")
	
	local info = '#BFBFBF('..rankTags[rank]..'#BFBFBF'
	if gang then 
		local tag = gang.tag
		local color = gang.color
		local r, g, b = color[1], color[2], color[3]
		local hex = string.format("#%02X%02X%02X", r, g, b)
		info = info..'|'..hex..tag..'#BFBFBF)#FFFFFF'
	else 
		info = info..')#FFFFFF'
	end
	
	outputChatBox('#BFBFBF'..tostring(id)..' '..nickColor..getPlayerName(player)..info..': '..targetNickColor..getPlayerName(targetPlayer)..'#FFFFFF, '..string.gsub(message, '#%x%x%x%x%x%x', ''), v, 255, 255, 255, true)
	outputServerLog("[GŁÓWNY]: [".. tostring(getElementData(player, "player:uid")) .."] ".. getPlayerName(player) ..": "..getPlayerName(targetPlayer)..", "..message)
	exports['ms-admin']:gameView_add("[GŁÓWNY]: ".. getPlayerName(player) ..": "..getPlayerName(targetPlayer)..", "..message)
end
addCommandHandler("do", messageToPlayer)