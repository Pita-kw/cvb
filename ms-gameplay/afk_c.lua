function updateAFK()
	local now=getTickCount()
	if now-lastTickAFKLU>=45000 then
		if getElementData(localPlayer, 'player:afk')==false then
			local hp=getElementHealth(localPlayer)
			if hp>0 then
				setElementData(localPlayer, 'player:afk', true)
				setElementData(localPlayer, 'player:god', true)
				setElementFrozen(localPlayer, true)
				end
		end
	end
	
	if isChatBoxInputActive() then
		if getElementData(localPlayer, 'player:chat_typing')==false then
			setElementData(localPlayer, 'player:chat_typing', true)
		end
	else
		if getElementData(localPlayer, 'player:chat_typing')==true then
			setElementData(localPlayer, 'player:chat_typing', false)
		end
	end
end

function onAFKStart()
	lastTickAFKLU=getTickCount()
	lastTickChatLU=getTickCount()
	
	setTimer(updateAFK, 50, 0)
	addEventHandler('onClientRestore', localPlayer, function()
		lastTickAFKLU=getTickCount()
		setElementData(localPlayer, 'player:afk', false)
		
		if isChatBoxInputActive() then
			if getElementData(localPlayer, 'player:chat_typing')==false then
				setElementData(localPlayer, 'player:chat_typing', true)
			end
		else
			if getElementData(localPlayer, 'player:chat_typing')==true then
				setElementData(localPlayer, 'player:chat_typing', false)
			end
		end
	end)
	addEventHandler('onClientMinimize', root, function()
		setElementData(localPlayer, 'player:afk', true)
		setElementData(localPlayer, 'player:god', true)
		setElementFrozen(localPlayer, true)
		if isChatBoxInputActive() then
			if getElementData(localPlayer, 'player:chat_typing')==false then
				setElementData(localPlayer, 'player:chat_typing', true)
			end
		else
			if getElementData(localPlayer, 'player:chat_typing')==true then
				setElementData(localPlayer, 'player:chat_typing', false)
			end
		end
	end)
	addEventHandler('onClientCursorMove', root, function()
		lastTickAFKLU=getTickCount()
		if getElementData(localPlayer, 'player:afk')==true then
			setElementData(localPlayer, 'player:afk', false)
			setElementData(localPlayer, 'player:god', false)
			setElementFrozen(localPlayer, false)
		end
	end)
	addEventHandler('onClientKey', root, function()
		lastTickAFKLU=getTickCount()
		if getElementData(localPlayer, 'player:afk')==true then
			setElementData(localPlayer, 'player:afk', false)
			setElementData(localPlayer, 'player:god', false)
			setElementFrozen(localPlayer, false)
		end
		
		if isChatBoxInputActive() then
			if getElementData(localPlayer, 'player:chat_typing')==false then
				setElementData(localPlayer, 'player:chat_typing', true)
			end
		else
			if getElementData(localPlayer, 'player:chat_typing')==true then
				setElementData(localPlayer, 'player:chat_typing', false)
			end
		end
	end)
end

onAFKStart()