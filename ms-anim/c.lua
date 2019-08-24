pee_sounds  = {}

addEvent("playPeeSound", true)
addEvent("stopPeeSound", true)

function playPeeSound(player, x, y, z, dim, int)
	pee_sounds[player] = playSound3D("pee.mp3", x,y,z, true)
	setElementDimension(pee_sounds[player], dim)
	setElementInterior(pee_sounds[player], int)
end
addEventHandler("playPeeSound", getRootElement(), playPeeSound)

function stopPeeSound(player)
	destroyElement(pee_sounds[player])
end
addEventHandler("stopPeeSound", getRootElement(), stopPeeSound)