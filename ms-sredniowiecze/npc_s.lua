function createNPC(type, model, x, y, z)
	local ped = createPed(model, x, y, z)
	if not ped then return end 
	setElementData(ped, "npc", type)
	
	exports.npc_hlc:enableHLCForNPC(ped, "walk", 1, 40/180)
	
	doNPCIdleMovement(ped)
end

function doNPCIdleMovement(ped)
	local x, y, z = getPositionInFrontOf(ped, 1.5, math.random(0, 360))
	
	exports.npc_hlc:setNPCTask(ped, {"walkToPos", x, y, z, 1})
	
	setTimer(doNPCIdleMovement, 2000*math.random(1,5), 1, ped)
end 

function getPositionInFrontOf( element, distance, rotation )
	local x, y, z = getElementPosition( element )
	rz = 0
	if getElementType( element ) == "vehicle" then
		_, _, rz = getElementRotation( element )
	elseif getElementType( element ) == "player" then
		rz = getPedRotation( element )
	end
	rz = rz + ( rotation or 90 )
	return x + ( ( math.cos ( math.rad ( rz ) ) ) * ( distance or 3 ) ), y + ( ( math.sin ( math.rad ( rz ) ) ) * ( distance or 3 ) ), z, rz
end


createNPC("wolf", 28, 1828.50,-4208.83,4.75)