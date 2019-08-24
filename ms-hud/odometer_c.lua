local timerIntervall = 100
function initiateOdometer()
	setTimer(calculateDistance,timerIntervall,0)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),initiateOdometer)


local prevX, prevY, prevZ = 0
local maxDistance = 1000 / (1000 / timerIntervall)
function calculateDistance()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not isPedInVehicle(localPlayer) then return end
	if localPlayer ~= getVehicleController(getPedOccupiedVehicle(localPlayer)) then return end 

	local x,y,z = getElementPosition(localPlayer)
	local g_pos = getGroundPosition(x,y,z)
	local distance = getDistanceBetweenPoints3D(x,y,z,x,y,g_pos)
	
	
	-- dont save anything if..
	-- # player..
	--    is dead
	--    is not in a vehicle
	--    is in a frozen vehicle
	--    cannot move forward
	if isLocalPlayerDead or not vehicle or isElementFrozen(vehicle) or not isControlEnabled("forwards") then
		return
	end

	-- only after all that, count any distance
	local x,y,z = getElementPosition(vehicle)
	if prevX ~= 0 then
		local distanceSinceLast = ((x-prevX)^2 + (y-prevY)^2 + (z-prevZ)^2)^(0.5)

		-- Only save if distance is small enough to have been achieved by legal means
		if distanceSinceLast < maxDistance and distance < 2 then
			setElementData(vehicle, "vehicle:mileage", (getElementData(vehicle, "vehicle:mileage") or 0) + distanceSinceLast)
		end
	end
	prevX = x
	prevY = y
	prevZ = z
end