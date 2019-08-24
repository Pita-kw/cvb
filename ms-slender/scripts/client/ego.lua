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

-------------------------
------- (c) 2010 --------
------- by Zipper -------
-- and Vio MTA:RL Crew --
-------------------------

local lp = getLocalPlayer()

addEvent("onSlenderEgoEnable", true)

local rotX, rotY = 0, 0
local camVehRot = 0
local rot = 0

local curVehRot = 0
local oldVehRot = 0

egoEnabled = false

local mouseSensitivity = 0.1

local delay = 0

local PI = math.pi

function freecamFrame ( slice )


    local camPosX, camPosY, camPosZ = getPedBonePosition ( lp, 8 )
	
	local angleZ = math.sin(rotY)
    local angleY = math.cos(rotY) * math.cos(rotX)
    local angleX = math.cos(rotY) * math.sin(rotX)
	
	local camTargetX = camPosX + ( angleX ) * 100
    local camTargetY = camPosY + angleY * 100
    local camTargetZ = camPosZ + angleZ * 100
	
	local veh = getPedOccupiedVehicle ( lp )
	if veh then
		local rx, ry, curVehRot = getElementRotation ( veh )
		local changedRotation = oldVehRot - curVehRot
		
		oldVehRot = curVehRot
		
		if not totalRot then
			totalRot = curVehRot
		end
		
		totalRot = changedRotation * 2 + totalRot
		
		local rotX = ( ( rotX * 360 / PI ) + totalRot ) / 360 * PI
		if rotX > PI then
			rotX = rotX - 2 * PI
		elseif rotX < -PI then
			rotX = rotX + 2 * PI
		end
		
		camTargetX = camPosX + ( math.cos(rotY) * math.sin(rotX) ) * 100
		camTargetY = camPosY + ( math.cos(rotY) * math.cos(rotX) ) * 100
	end
	
    setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ )
end

function freecamMouse (cX,cY,aX,aY)

	if isCursorShowing() or isMTAWindowActive() then
		delay = 5
		return
	elseif delay > 0 then
		delay = delay - 1
		return
	end
	
    local width, height = guiGetScreenSize()
    aX = aX - width / 2 
    aY = aY - height / 2
	
    rotX = rotX + aX * mouseSensitivity * 0.01745
    rotY = rotY - aY * mouseSensitivity * 0.01745

	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
	
    if rotY < -PI / 2.05 then
       rotY = -PI / 2.05
    elseif rotY > PI / 2.05 then
        rotY = PI / 2.05
    end
end

function setEgoEnabled (x, y, z)
	if egoEnabled then
		setEgoDisabled()
	end
	addEventHandler("onClientPreRender", getRootElement(), freecamFrame)
	addEventHandler("onClientCursorMove",getRootElement(), freecamMouse)
	egoEnabled = true
end

function setEgoDisabled()
	if egoEnabled then
		egoEnabled = false
		removeEventHandler("onClientPreRender", getRootElement(), freecamFrame)
		removeEventHandler("onClientCursorMove",getRootElement(), freecamMouse)
		setTimer(setCameraTarget, 50, 1, lp)
	end
end

addEventHandler("onSlenderEgoEnable", getLocalPlayer(), function()
	local x, y, z = getElementPosition ( getLocalPlayer() )
	setEgoEnabled ( x, y, z )
end)