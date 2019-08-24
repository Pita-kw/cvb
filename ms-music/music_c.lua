--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: music_s.lua
	@desc: odtwarzanie muzyki
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]


addEvent("playMusic", true)
addEvent("stopMusic", true)

sound_element = false
category_id = false

function playMusic(url, category)
		if getElementData(localPlayer, "player:eventMusicDisabled") then return end 
		if isElement(sound_element) then destroyElement(sound_element) end
		sound_element = playSound(url)
		setSoundVolume(sound_element, 0.35)
		category_id = category
		addEventHandler ( "onClientSoundStopped", sound_element, onSoundStopped )
end
addEventHandler("playMusic", root, playMusic)

function stopMusic()
	if isElement(sound_element) then
		local volume = getSoundVolume(sound_element)
		
		setTimer ( function()
			if volume <= 0.1 and isElement(sound_element) then
				stopSound(sound_element)
			else
				volume = volume - 0.05
				setSoundVolume(sound_element, volume)
			end
		end, 250, 10 )
	end
end
addEventHandler("stopMusic", root, stopMusic)

function onSoundStopped ( reason )
	if reason == "finished" then
		triggerServerEvent("playAttractionMusic", localPlayer, localPlayer, category_id)
	end
end