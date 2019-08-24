local sound_position = { -2323.04,-1597.73,485.32}


function updateRadioForPlayers(player, url)
	if isElement(radio) then destroyElement(radio) end
	radio = playSound3D(url, sound_position[1], sound_position[2], sound_position[3], true)
	setSoundMaxDistance(radio, 200)
end
addEvent("updateRadioForPlayers", true)
addEventHandler("updateRadioForPlayers", localPlayer, updateRadioForPlayers)

function playSantaSound()
	playSound("merry_christmas.mp3")
end
addEvent("playSantaSound", true)
addEventHandler("playSantaSound", localPlayer, playSantaSound)

countdown_timer = setTimer(countDownChristmas, 500, 0)
