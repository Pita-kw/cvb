local LOADING_SPEED_DELAY = 10

local loadingRot = 0 
local lastTick = 0
function renderLoading(x, y, w, h)
	local now = getTickCount() 
	if now > lastTick then 
		lastTick = now+LOADING_SPEED_DELAY 
		loadingRot = loadingRot+6
		if loadingRot == 360 then loadingRot = 0 end 
	end 
	
	dxDrawImage(x, y, w, h, "img/loading.png", loadingRot, 0, 0, tocolor(255, 255, 255, 255), true)
end 
