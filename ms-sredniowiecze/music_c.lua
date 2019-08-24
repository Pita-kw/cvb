local music = {
	["explore"] = {
		"http://multiserver.pl/audio/medieval/explore/geldern.mp3",
		"http://multiserver.pl/audio/medieval/explore/myrtana.mp3",
		"http://multiserver.pl/audio/medieval/explore/vista.mp3",
	},
	
	["fight"] = {
		"http://multiserver.pl/audio/medieval/fight/fight1.mp3",
		"http://multiserver.pl/audio/medieval/fight/fight2.mp3",
		"http://multiserver.pl/audio/medieval/fight/fight3.mp3",
		"http://multiserver.pl/audio/medieval/fight/fight4.mp3",
	},
}

local sound = false 

function playMedievalMusic(type)
	if type then 
		if not sound then 
			local rand = math.random(1, #music[type])
			local url = music[type][rand]
			sound = playSound(url, false)
			setSoundVolume(sound, 0.5)
			
			local type = type
			addEventHandler("onClientSoundStopped", sound, function(reason)
				if reason == "finished" then 
					sound = nil 
					playMedievalMusic(type)
				end
			end)
		end
	end
end 

function stopMedievalMusic()
	if sound then 
		local vol = getSoundVolume(sound)
		vol = vol-0.05 
		if vol < 0 then 
			destroyElement(sound)
			sound = nil
		else
			setSoundVolume(sound, vol)
		end
	end
end

local function checkStatus()
	local medieval = getElementData(localPlayer, "player:medieval")
	if medieval then 
		playMedievalMusic("explore")
	else 
		stopMedievalMusic()
	end
end 
setTimer(checkStatus, 1000, 0)