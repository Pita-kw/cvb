-- id do podmianek jeśli nie istnieje obiekt o danym id 
--[[
ALLOWED_MODELS_POOL = {
	9129, 9126, 5990, 5992, 7072, 5059, 7331, 9127,
	7944, 7332, 7943, 9123, 9277, 9159, 9125, 4213,
	4216, 5662, 4750, 4740, 4212, 4745, 4214, 4215,
	4219, 4217, 4723, 7097, 4744, 5991, 9278, 5665, 
	4749, 4739, 4748, 9281, 9283, 4218, 9279, 4741
}
--]]

function updateMaps()
	--
	if getElementData(localPlayer, "player:ghostisland_downloaded") then 
		updateGhostIslandMap()
	end
	
	if getElementData(localPlayer, "player:china_downloaded") then 
		updateChinaMap()
	end
end 
setTimer(updateMaps, 100, 0)