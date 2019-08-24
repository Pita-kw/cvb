----------------------------------------------
--Resource: dynamic_lighting flashlight     --
--Author: Ren712                            --
--Contact: knoblauch700@o2.pl               --
----------------------------------------------

local flashLiTable = {flModel={}, shLight={}, shLiBul={}, shLiRay={}, isFlon={} ,isFLen={}, fLInID={}, flDimID={}}
local isLightOn = false

---------------------------------------------------------------------------------------------------
-- editable variables
---------------------------------------------------------------------------------------------------

local disableFLTex = false -- true=makes the flashlight body not visible (useful for alter attach)
local autoEnableFL = true -- true=the player gets the flashlight without writing commands
-- light settings for other players
local gLightTheta = math.rad(6) -- Theta is the inner cone angle
local gLightPhi = math.rad(18) -- Phi is the outer cone angle
local gLightFalloff = 1.5 -- light intensity attenuation between the phi and theta areas
local gAttenuation = 15 -- light attenuation (max radius)
-- light settings for localPlayer
local gLocLightTheta = math.rad(6) -- Theta is the inner cone angle
local gLocLightPhi = math.rad(45) -- Phi is the outer cone angle
local gLocLightFalloff = 1.5 -- light intensity attenuation between the phi and theta areas
local gLocAttenuation = 25 -- light attenuation (max radius)
-- for all
local gWorldSelfShadow = false -- enables object self shadowing ( may be bugged for rotated objects on a custom map)
local gLightColor = {0.9,0.9,0.65,1.0} -- rgba color of the projected light, light rays and the lightbulb
local switch_key = 'l' -- define the key that switches the light effect
local objID = 15060  -- the object we are going to replace (interior building shadow in this case)

local theTikGap = 0.5 -- here you set how many seconds to wait after switching the flashlight on/off
local flTimerUpdate = 200 -- the effect update time interval 

local getLastTack = getTickCount ( )-(theTikGap*1000)
local shTeNul = dxCreateShader ( "shaders/shader_null.fx",0,0,false )

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

---------------------------------------------------------------------------------------------------
-- update the existing lights
---------------------------------------------------------------------------------------------------
addEventHandler("onClientPreRender", root, function()
	for index,this in ipairs(getElementsByType("player")) do
		if flashLiTable.shLight[this] then
			local x1, y1, z1 = getPedBonePosition ( this, 3)
			--local lx1, ly1, lz1 = getPedBonePosition ( this, 2 )
			local lx1, ly1, lz1 = getPositionFromElementOffset(this, 0, 10, 0)
			exports.dynamic_lighting:setLightDirection(flashLiTable.shLight[this],lx1-x1,ly1-y1,lz1-z1,false)
			exports.dynamic_lighting:setLightPosition(flashLiTable.shLight[this],x1,y1,z1)
			exports.dynamic_lighting:setLightInterior(flashLiTable.shLight[this], getElementInterior(this))
			exports.dynamic_lighting:setLightDimension(flashLiTable.shLight[this], getElementDimension(this))
		end
	end
end
)

---------------------------------------------------------------------------------------------------
-- create/destroy the effects for flashlight model
---------------------------------------------------------------------------------------------------

function createFlashlightModel(thisPed)
	if not flashLiTable.flModel[thisPed] then	
		flashLiTable.flModel[thisPed] = createObject(objID,0,0,0,0,0,0,true)
		if disableFLTex and shTeNul then
			engineApplyShaderToWorldTexture ( shTeNul, "flashlight_COLOR", flashLiTable.flModel[thisPed] )	
			engineApplyShaderToWorldTexture ( shTeNul, "flashlight_L", flashLiTable.flModel[thisPed] )	
		end
		setElementAlpha(flashLiTable.flModel[thisPed],254)
		exports.bone_attach:attachElementToBone(flashLiTable.flModel[thisPed],thisPed,1,0,0.1,0.18,-90,0,0)
	end
end

function destroyFlashlightModel(thisPed)
	if flashLiTable.flModel[thisPed] then			
		exports.bone_attach:detachElementFromBone(flashLiTable.flModel[thisPed])
		if disableFLTex and shTeNul then
			engineRemoveShaderFromWorldTexture ( shTeNul, "*", flashLiTable.flModel[thisPed] )
		end
		destroyElement(flashLiTable.flModel[thisPed])
		flashLiTable.flModel[thisPed]=nil
	end
end

---------------------------------------------------------------------------------------------------
-- Creates / destroys  spot light
---------------------------------------------------------------------------------------------------

function createWorldLight(thisPed)
	if flashLiTable.shLight[thisPed] or ((isSynced==false) and (thisPed~=localPlayer)) then return end
	if (thisPed~=localPlayer) then
		flashLiTable.shLight[thisPed] = exports.dynamic_lighting:createSpotLight(0,0,3,gLightColor[1],gLightColor[2],gLightColor[3],gLightColor[4],0,0,0,flase,gLightFalloff,gLightTheta,gLightPhi,gAttenuation,gWorldSelfShadow)
	else
		flashLiTable.shLight[thisPed] = exports.dynamic_lighting:createSpotLight(0,0,3,gLightColor[1],gLightColor[2],gLightColor[3],gLightColor[4],0,0,0,flase,gLocLightFalloff,gLocLightTheta,gLocLightPhi,gLocAttenuation,gWorldSelfShadow)
	end
end

function destroyWorldLight(thisPed)
	if flashLiTable.shLight[thisPed] then
		flashLiTable.shLight[thisPed] = not exports.dynamic_lighting:destroyLight(flashLiTable.shLight[thisPed])
	end
end

---------------------------------------------------------------------------------------------------
-- Creates / destroys  light bulb and rays effects
---------------------------------------------------------------------------------------------------

function createFlashLightShader(thisPed)
	if not flashLiTable.flModel[thisPed] then return false end
	if not flashLiTable.shLiBul[thisPed] or flashLiTable.shLiRay[thisPed] then
		flashLiTable.shLiBul[thisPed]=dxCreateShader("shaders/shader_lightBulb.fx",1,0,false)
		flashLiTable.shLiRay[thisPed]=dxCreateShader("shaders/shader_lightRays.fx",1,0,true)
		if not flashLiTable.shLiBul[thisPed] or not flashLiTable.shLiRay[thisPed] then
			return
		end		
		engineApplyShaderToWorldTexture(flashLiTable.shLiBul[thisPed],"flashlight_L", flashLiTable.flModel[thisPed] )
		engineApplyShaderToWorldTexture(flashLiTable.shLiRay[thisPed], "flashlight_R", flashLiTable.flModel[thisPed] )	
		dxSetShaderValue (flashLiTable.shLiBul[thisPed],"gLightColor",gLightColor)
		dxSetShaderValue (flashLiTable.shLiRay[thisPed],"gLightColor",gLightColor)
	end
end

function destroyFlashLightShader(thisPed)
	if flashLiTable.shLiBul[thisPed] or flashLiTable.shLiRay[thisPed] then
		destroyElement(flashLiTable.shLiBul[thisPed])
		destroyElement(flashLiTable.shLiRay[thisPed])
		flashLiTable.shLiBul[thisPed]=nil
		flashLiTable.shLiRay[thisPed]=nil
	end
end

---------------------------------------------------------------------------------------------------
-- enabling and switching on the flashlight
---------------------------------------------------------------------------------------------------

function playSwitchSound(thisPed)
	pos_x,pos_y,pos_z=getElementPosition (thisPed)
	local flSound = playSound3D("sounds/switch.wav", pos_x, pos_y, pos_z, false) 
	setSoundMaxDistance(flSound,40)
	setSoundVolume(flSound,0.6)
end

function flashLightEnable(isEN,thisPed)
if isEN==true then
		flashLiTable.isFLen[thisPed]=isEN	
	else
		flashLiTable.isFLen[thisPed]=isEN	
	end
end

function flashLightSwitch(isON,thisPed)
	if isElementStreamedIn(thisPed) and flashLiTable.isFLen[thisPed] then  playSwitchSound(thisPed) end
	if isON then
		flashLiTable.isFlon[thisPed]=true
	else
		flashLiTable.isFlon[thisPed]=false
	end
end


function whenPlayerQuits(thisPed)
	destroyWorldLight(thisPed) 
	destroyFlashlightModel(thisPed) 
	destroyFlashLightShader(thisPed)  
end

---------------------------------------------------------------------------------------------------
-- streaming in/out the flashlight model
---------------------------------------------------------------------------------------------------

addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	if FLenTimer then return end
	FLenTimer = setTimer(	function()
		for index,thisPed in ipairs(getElementsByType("player")) do
			if flashLiTable.fLInID[thisPed]==nil then flashLiTable.fLInID[thisPed]=0 end
			if isElementStreamedIn(thisPed) and flashLiTable.isFLen[thisPed]==true and flashLiTable.fLInID[thisPed]~=getElementInterior(thisPed) then
			triggerServerEvent("onPlayerGetInter", resourceRoot, thisPed)
		end
		if  isElementStreamedIn(thisPed) and not flashLiTable.flModel[thisPed] and getElementData(thisPed, "player:flashlight") then
			createFlashlightModel(thisPed)
			if flashLiTable.fLInID[thisPed]~=nil then setElementInterior ( flashLiTable.flModel[thisPed], flashLiTable.fLInID[thisPed]) end
			if flashLiTable.flDimID[thisPed]~= nil then setElementDimension (flashLiTable.flModel[thisPed], flashLiTable.flDimID[thisPed]) end
			end
		if  isElementStreamedIn(thisPed) and flashLiTable.flModel[thisPed] and not getElementData(thisPed, "player:flashlight") then
			destroyFlashlightModel(thisPed)
			end
		if isElementStreamedIn(thisPed) and not flashLiTable.shLiRay[thisPed] and getElementData(thisPed, "player:flashlight") then 
			createFlashLightShader(thisPed) 
			createWorldLight(thisPed)
			end
		if (isElementStreamedIn(thisPed) or not isElementStreamedIn(thisPed)) and flashLiTable.shLiRay[thisPed] and not getElementData(thisPed, "player:flashlight") or flashLiTable.isFlon[thisPed] == false then 
			destroyFlashLightShader(thisPed) 
			destroyWorldLight(thisPed)			
			end
		end
	end
	,flTimerUpdate,0 )
end
)

function getPlayerInteriorFromServer(thisPed,interiorID, dim)
	if flashLiTable.flModel[thisPed] then
		flashLiTable.fLInID[thisPed]=interiorID
		flashLiTable.flDimID[thisPed]=dim
		if flashLiTable.flModel[thisPed] then setElementInterior ( flashLiTable.flModel[thisPed], flashLiTable.fLInID[thisPed]) setElementDimension( flashLiTable.flModel[thisPed], flashLiTable.flDimID[thisPed] )end
	end
end

---------------------------------------------------------------------------------------------------
-- switching on / off the flashlight
---------------------------------------------------------------------------------------------------

addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == localPlayer then
			if isLightOn then
				isLightOn = false
				triggerServerEvent("onSwitchLight", resourceRoot, isLightOn)
				triggerEvent("switchFlashLight", root, isLightOn)
			end
        end
    end
)

function toggleLight()
	if getPedOccupiedVehicle(localPlayer) then return end
	if (getTickCount ( ) - getLastTack < theTikGap*1000) then return end
	isLightOn = not isLightOn
	triggerServerEvent("onSwitchLight", resourceRoot, isLightOn)
	triggerEvent("switchFlashLight", root, isLightOn)
	getLastTack = getTickCount ( )
end
bindKey(switch_key, "down", toggleLight)

function toggleFlashLight()
if flashLiTable.flModel[localPlayer] then 
	triggerServerEvent("onSwitchLight", resourceRoot, false)
	triggerServerEvent("onSwitchEffect", resourceRoot, false)
	isLightOn = false
else
	triggerServerEvent("onSwitchLight", resourceRoot, false)
	triggerServerEvent("onSwitchEffect", resourceRoot, true)
	end
end

---------------------------------------------------------------------------------------------------
-- events
---------------------------------------------------------------------------------------------------
		
addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	engineImportTXD( engineLoadTXD( "objects/flashlight.txd" ), objID ) 
	engineReplaceModel ( engineLoadDFF( "objects/flashlight.dff", 0 ), objID,true)
	triggerServerEvent("onPlayerStartRes", resourceRoot)
	if autoEnableFL then 
		toggleFlashLight() 
	end
	exports.dynamic_lighting:setWorldNormalShading(false)
end
)

addEventHandler("onClientResourceStop", getResourceRootElement( getThisResource()), function()
	for index,this in ipairs(getElementsByType("player")) do
		if flashLiTable.shLight[this] then
			destroyWorldLight(this)
		end
	end
end
)

function setFlashlightEnabled(b)
	if getPedOccupiedVehicle(localPlayer) then return end
	if (getTickCount ( ) - getLastTack < theTikGap*1000) then return end
	isLightOn = b
	triggerServerEvent("onSwitchLight", resourceRoot, isLightOn)
	triggerEvent("switchFlashLight", root, isLightOn)
end

addEvent( "flashOnPlayerEnable", true )
addEvent( "flashOnPlayerQuit", true )
addEvent( "flashOnPlayerSwitch", true )
addEvent( "flashOnPlayerInter", true)
addEventHandler( "flashOnPlayerQuit", resourceRoot, whenPlayerQuits)
addEventHandler( "flashOnPlayerSwitch", resourceRoot, flashLightSwitch)
addEventHandler( "flashOnPlayerEnable", resourceRoot, flashLightEnable)
addEventHandler( "flashOnPlayerInter", resourceRoot, getPlayerInteriorFromServer)
