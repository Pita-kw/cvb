local loaded = false 

function loadZombieWorld() 
	setWeather(7)
	setFarClipDistance(400)
	setFogDistance(-100)
	setElementData(localPlayer, "zombie_world", true)
	exports.dynamic_lighting:setLightsEffectRange(400)
	exports.dynamic_lighting:setShaderForcedOn(true)
	exports.dynamic_lighting:setShaderNightMod(true)
	exports.dynamic_lighting:setTextureBrightness(0.08)
	
	setElementData(localPlayer, "player:flashlight", true)
	loaded = true 
	
	background_sound = playSound("files/sounds/background.mp3", true)
	setSoundVolume(background_sound, 0.15)
	
	addEventHandler("onClientRender", root, updateTime)
	
	triggerEvent("onClientAddNotification", localPlayer, "By włączyć latarkę wciśnij klawisz L.", "info", 10000)
end 

function updateTime() 
	setTime(9, 0)
	setSkyGradient(30, 30, 30, 30, 30, 30)
end 

function unloadZombieWorld() 
	if loaded then 
		removeEventHandler("onClientRender", root, updateTime)
		setWeather(0)
		resetFarClipDistance()
		resetSkyGradient()
		resetFogDistance()
		loaded = false 
		exports.dynamic_lighting:setShaderForcedOn(false)
		exports.dynamic_lighting:setShaderNightMod(false)
		exports.dynamic_lighting:setTextureBrightness(1)
		exports.dynamic_lighting:setLightsEffectRange(100)
		setElementData(localPlayer, "player:flashlight", false)
		setElementData(localPlayer, "zombie_world", false)
		stopSound(background_sound)
		--destroyElement(background_sound)
	end
end 

function isInZombieWorld() 
	local dim = getElementDimension(localPlayer)
	if dim == 666 and not loaded then 
		loadZombieWorld()
	elseif dim ~= 666 and loaded then 
		unloadZombieWorld()
	end
end 
setTimer(isInZombieWorld, 500, 0)
addEventHandler("onClientResourceStop", resourceRoot, unloadZombieWorld)

function antyDMZombie ( attacker, weapon, bodypart )
	if source == getElementType(source) == "player" and getElementData(source, "zombie_world") then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", root, antyDMZombie )