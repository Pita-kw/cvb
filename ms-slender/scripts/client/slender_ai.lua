--[[
	##########################################################################
	##                                                                      ##
	## Project: 'MTA Slender' - Gamemode for MTA: San Andreas               ##
	##                      Developer: Noneatme                             ##
	##           License: See LICENSE in the top level directory            ##
	##                                                                      ##
	##########################################################################
	[C] Copyright 2013-2014, Noneatme
]]

ai_data = {}

ai_data["lastpos"] = {}
ai_data["lastpos"]["x"] = false
ai_data["lastpos"]["y"] = false
ai_data["lastpos"]["z"] = false

ai_data["positions"] = {}
last_ai = 1
ai_data["timer"] = false

ai_data["slender"] = false -- :D -> Ich hab schon jetzt schiss
slendy = false

ai_data["mindistance"] = 500
 
fertig = false

local min_slender_distance = {
	[1] = 35,
	[2] = 30,
	[3] = 25,
	[4] = 20,
	[5] = 15,
	[6] = 10,
	[7] = 5
}

local slender_wait_data = {
	[1] = 6500,
	[2] = 5000,
	[3] = 4500,
	[4] = 4000,
	[5] = 3500,
	[6] = 2000,
	[7] = 1000,
}
function slender_ai_new_pos()
	if(taschenlampstate == true) then
		local x, y, z = getElementPosition(localPlayer)
		if(ai_data["lastpos"]["x"] ~= false) then
			-- SLENDY POS --
			-- STILLSTANDING CHECK --
			local x2, y2, z2 = ai_data["lastpos"]["x"], ai_data["lastpos"]["y"], ai_data["lastpos"]["z"]
			local dis = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			local slx, sly, slz = getElementPosition(slendy)
			-- SLENDER CHECK --
			if(x ~= x2) and (y ~= y2) and (z ~= z2) and (isElementOnScreen(slendy) ~= true) then
				-- LAST DISTANCE CHECK --
				local using_last = false
				local last_distance = 99999999
				local lastx, lasty, lastz
				for i = 2, last_ai, 1 do
					if(ai_data["positions"][i]) then
						local mx, my, mz = ai_data["positions"][i]["x"], ai_data["positions"][i]["y"], ai_data["positions"][i]["z"]
						if(getDistanceBetweenPoints3D(mx, my, mz, x, y, z) > min_slender_distance[pages]/2) and(getDistanceBetweenPoints3D(mx, my, mz, x, y, z) < last_distance) then
							if(isLineOfSightClear(mx, my, mz, x, y, z, true, true, true, true, true, true) == false) then
								last_distance = getDistanceBetweenPoints3D(mx, my, mz, x, y, z)
								lastx, lasty, lastz = mx, my, mz
								using_last = true
							end
						end
					end
				end
				if(last_distance ~= 0) and (using_last == true) then
					setElementPosition(slendy, lastx, lasty, lastz)
					local x3, y3, z3 = getElementPosition(slendy)
					local x4, y4, z4 = getElementPosition(localPlayer)
					local rot = math.atan2(y4 - y3, x4 - x3) * 180 / math.pi
					rot = rot-90
					setPedRotation(slendy, rot)
				else
					local sx, sy, sz = ai_data["lastpos"]["x"], ai_data["lastpos"]["y"], ai_data["lastpos"]["z"]
					sx = sx+math.random(1, 5)
					setElementPosition(slendy, sx, sy, sz)
					-- ROT --
					local x3, y3, z3 = getElementPosition(slendy)
					local x4, y4, z4 = getElementPosition(localPlayer)
					local rot = math.atan2(y4 - y3, x4 - x3) * 180 / math.pi
					rot = rot-90
					setPedRotation(slendy, rot)
				end
			end
			-- CHECK --
			x, y, z = getElementPosition(localPlayer)
			x2, y2, z2 = getElementPosition(slendy)
		--	if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 5) and (isElementOnScreen(slendy)) then
		--		playSound("data/sounds/bum.mp3", false)
		--	end
			-- SET NEW SLENDY DATA --
			ai_data["lastpos"]["x"] = x
			ai_data["lastpos"]["y"] = y
			ai_data["lastpos"]["z"] = z
			
			ai_data["positions"][last_ai] = {}
			ai_data["positions"][last_ai]["x"] = x
			ai_data["positions"][last_ai]["y"] = y
			ai_data["positions"][last_ai]["z"] = z
			last_ai = last_ai+1
		else
			ai_data["lastpos"]["x"] = x
			ai_data["lastpos"]["y"] = y
			ai_data["lastpos"]["z"] = z
		end
	else
		local r = math.random(0, 1)
		if(r == 1) then
			slender_ai_new_pos()
		end
	end
end




function refresh_slender_ai(id)
	if(isTimer(ai_data["timer"])) then
		killTimer(ai_data["timer"])
	end
	if(isElement(ai_data["slender"])) then else
		ai_data["slender"] = createPed(100, 0, 0, 0)
		setElementDimension(ai_data["slender"], getElementData(localPlayer, "player:id"))
		slendy = ai_data["slender"]
		setElementAlpha(ai_data["slender"], 200)
	end
	if(id ~= 8) then
		ai_data["mindistance"] = min_slender_distance[id]
		ai_data["timer"] = setTimer(slender_ai_new_pos, slender_wait_data[id], 0)
	else
		setElementPosition(slendy, 0, 0, 0)
		for index, s in next, sound do
			if(isElement(s)) then
				destroyElement(s)
			end
		end
		if(isTimer(ai_data["timer"])) then
			killTimer(ai_data["timer"])
		end
		setTimer(function()
			playSlenderSound("bum.mp3", false)
			local x, y, z = getElementPosition(localPlayer)
			local x2, y2, z2 = getElementPosition(slendy)
			x2, y2 = getPointFromDistanceRotation(x, y, 50, getPedRotation(localPlayer)-90)
			setElementPosition(slendy, x2, y2, z2)
			-- Don't work until now --
			setTimer(function()
				wasted = true
				destroyElement(slendy)
				setTimer(function()
					wasted = false
					resetFarClipDistance()
					resetFogDistance()
					fertig = true
					resetSkyGradient()
					exports.dynamic_lighting:setShaderForcedOn(false)
					exports.dynamic_lighting:setShaderNightMod(false)
					exports.dynamic_lighting:setTextureBrightness(1)
					setTimer(endSlender, 5000, 1, true)
				end, 3000, 1)
			end, 1000, 1)
		end, 5000, 1)
	end
end
