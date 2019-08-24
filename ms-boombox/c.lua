local boomboxes = {} 

function onClientPlayBoombox(player, url)
	local x,y,z = getElementPosition(player)
	if isElement(boomboxes[player]) then destroyElement(boomboxes[player]) end 
	
	boomboxes[player] = playSound3D(url, x, y, z)
	if boomboxes[player] then 
		setElementInterior(boomboxes[player], getElementInterior(player))
		setElementDimension(boomboxes[player], getElementDimension(player))
		attachElements(boomboxes[player], player)
		setSoundMaxDistance(boomboxes[player], 20)
		setSoundVolume(boomboxes[player], 0.7)
	end 
end 
addEvent("onClientPlayBoombox", true)
addEventHandler("onClientPlayBoombox", root, onClientPlayBoombox)

function onClientDeleteBoombox(player)
	if boomboxes[player] then 
		if isElement(boomboxes[player]) then destroyElement(boomboxes[player]) end 
	end 
end 
addEvent("onClientDeleteBoombox", true)
addEventHandler("onClientDeleteBoombox", root, onClientDeleteBoombox)