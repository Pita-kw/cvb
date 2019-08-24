local disallowedVehicles = {
	[539] = true,
}

addEvent( "onClientVehicleStartDrift" );
addEvent( "onClientVehicleEndDrift" );
addEvent( "onClientVehicleDrift" );
addEvent( "onClientVehicleDriftCombo" );

g_Me = localPlayer;
screenSize = { guiGetScreenSize( ) };

local bIfDrifting = false;
local iStartDriftTick = 0;
local iCurrentTick = 0;
local iDriftTime = 0;
local iEndDriftTick = 0;
local iBackToDriftMS = 2000;
local iLastFrameTick = 0;

iMinDriftAngle = 10;
iMaxDriftAngle = 85;

local sDriftDir = "";
local bContinuosDrift = false;
local iDriftCombo = 1;
local iMaxCombo = 20;

local mMeterMat = dxCreateTexture( "images/drift_gauge.png" );
local mNeedleMat = dxCreateTexture( "images/needle.png" );
local vMeterSize = Vector2: new( dxGetMaterialSize( mMeterMat ) );
local vNeedleSize = Vector2: new( dxGetMaterialSize( mNeedleMat ) );
local vMeterPos = Vector2:new( screenSize[ 1 ] / 2 - vMeterSize.x/2, screenSize[ 2 ] - 150 );


function getPlayerSpeed( )
	local veh = getPedOccupiedVehicle( g_Me );
	local x, y, z = getElementVelocity( veh and veh or g_Me );
	return math.sqrt( x^2 + y^2 + z^2 ) * 160;
end

addCommandHandler( "showdriftmeter", 
	function( _, show )
		--gShowMeter = show and show == "true" and true or false
	end
)


addEventHandler( "onClientRender", root, 
	function( )
		local eVeh = getPedOccupiedVehicle( g_Me );
		
		iCurrentTick = getTickCount( );
		
		if eVeh then			
			if getVehicleController(eVeh) ~= localPlayer then return end 
			if getElementData(eVeh, "vehicle:glue") then return end
			if disallowedVehicles[getElementModel(eVeh)] or getVehicleType(eVeh) ~= "Automobile" then return end 
			
			local vVel = Vector3: new( getElementVelocity( eVeh ) );
			local fVelocity = vVel:length( ) * 160;
			local vVel2 = vVel:mul( 2 );
			
			local vVehPos = Vector3: new( getElementPosition( eVeh ) );
			local fDriveDir = vVel:direction2D( );
			local vRot = Vector3: new( getElementRotation( eVeh ) );
			local fRot = vRot.z;
			
			local vOffset = Vector3: elementOffsetPosition( eVeh, Vector3: new( 0, 5, 0 ) );
			vOffset = vOffset:sub( vVehPos );
			
			local vCross = vOffset:cross( vVel2 );
			local fNormal = vCross:dot( Vector3: new( 0,0, 4 ) );
			if fNormal > 0 then
				sDriftDir = "right";
			elseif fNormal < 0 then
				sDriftDir = "left";
			end
			
			if fDriveDir < 0 then -- NORTH -> TO WEST -> TO SOUTH
				fDriveDir = fDriveDir * -1;
			elseif fDriveDir > 0 then -- NORTH -> TO EAST -> TO SOUTH
				fDriveDir = 360 - fDriveDir;
			end
			
			fDriftAng = math.abs( fRot - fDriveDir );
			if fDriftAng > 140 then
				if fRot < 360 and fRot > 180 and fDriveDir > 0 and fDriveDir < 180 then
					fDriftAng = 360 - fRot + fDriveDir;
				elseif fRot < 180 and fRot > 0 and fDriveDir > 180 and fDriveDir < 360 then
					fDriftAng = ( 360 - fDriveDir ) + fRot;
				end
			end
			
			if fVelocity < 1 or fDriftAng < 1 then
				sDriftDir = "";
				fDriftAng = 0;
			end
			
			--[[
			dxDrawText( "VEH ROT: " .. tostring( fRot ), 10, 300 );
			dxDrawText( "DRIVE DIR: " .. tostring( fDriveDir ), 10, 320 );
			dxDrawText( "VELOCITY DIR: " .. tostring( vVel:direction2D( ) ), 250, 320 );
			dxDrawText( "DRIFT angle: " .. tostring( fDriftAng ), 10, 350 );
			dxDrawText( "VELOCITY: " .. tostring( fVelocity ), 10, 380 );
			dxDrawText( "DRIFT DIR: " .. sDriftDir, 10, 400 );			
			--]]
			
			--[[
			local r, g, b = 0, 255, 0;
			local fAngPercent = ( fDriftAng / iMaxDriftAngle ) * 4;
			if fAngPercent > 0 and fAngPercent < 1 then
				r = 0;
				g = 255;
			elseif fAngPercent > 1 and fAngPercent < 2 then
				r = 255 * (2 - fAngPercent);
				g = 255;
			elseif fAngPercent > 2 and fAngPercent < 3 then
				r = 255 * (1 - (4 - fAngPercent));
				g = 255 * (3 - fAngPercent);
			elseif fAngPercent > 3 and fAngPercent < 4 then
				r = 255;
				g = 255 * (5 - fAngPercent);
			end
			
			cDriftColour = tocolor( r, g, b );
			--]]
			
			if gShowMeter then
				local progress = (getTickCount()-startDriftTick) / 500 
				local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, math.min(progress, 1), "InQuad")
				
				dxDrawImage(bgPos.x, bgPos.y, bgPos.w, bgPos.h, "images/drift_gauge.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
				
				local needleAngle = fDriftAng < iMaxDriftAngle and fDriftAng or iMaxDriftAngle
				needleAngle = sDriftDir == "right" and needleAngle or needleAngle * -1
				
				local needleOffset = math.floor(needleAngle * (2.4/zoom))
				
				for oX = -1, 1 do 
					for oY = -1, 1 do
						dxDrawImage(math.floor(bgPos.x+bgPos.w/2-39/zoom/2-needleOffset+oX), bgPos.y+oY, 39/zoom, 53/zoom, "images/needle.png", 0, 0, 0, tocolor(0, 0, 0, alpha), true)
					end 
				end 
				dxDrawImage(math.floor(bgPos.x+bgPos.w/2-39/zoom/2-needleOffset), bgPos.y, 39/zoom, 53/zoom, "images/needle.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
				
				dxDrawBorderedText(tostring(driftScore), bgPos.x, bgPos.y+bgPos.h+10/zoom, bgPos.x+bgPos.w, bgPos.h, tocolor(255, 255, 255, alpha), 1, font, "center", "top", false, false, true, alpha)
				if driftCombo > 1 then 
					dxDrawBorderedText("x"..tostring(driftCombo), bgPos.x, bgPos.y+bgPos.h+50/zoom, bgPos.x+bgPos.w, bgPos.h, tocolor(52, 152, 219, alpha), 1, font, "center", "top", false, false, true, alpha)
				end
			end
			
			
			if fVelocity > 50 and fDriftAng > iMinDriftAngle and not bContinuosDrift and not bIsDrifting and isVehicleOnGround( eVeh ) and not getControlState("brake_reverse") then -- start DRIFT
				bIsDrifting = true;
				bContinuosDrift = true;
				triggerEvent( "onClientVehicleStartDrift", eVeh, fVelocity );
				triggerEvent( "onVehicleDrift", eVeh, fVelocity );
				iStartDriftTick = iCurrentTick;
				iDriftTime = 0;
			elseif ( ( fVelocity < 50 and fVelocity ~= 0 ) or fDriftAng < iMinDriftAngle ) and bIsDrifting or not isVehicleOnGround( eVeh ) then -- valid when stopped meeting requirements (still in drift)
				bIsDrifting = false;
				iEndDriftTick = iCurrentTick;
			elseif fVelocity > 50 and fDriftAng > iMinDriftAngle and bContinuosDrift and not bIsDrifting and not getControlState("brake_reverse") then -- triggered to back on drift (+1 combo)
				bIsDrifting = true;
				iStartDriftTick = iCurrentTick;
				if iDriftCombo < iMaxCombo then
					iDriftCombo = iDriftCombo + 1;
					triggerEvent( "onClientVehicleDriftCombo", eVeh, iDriftCombo );
				end
			elseif not bIsDrifting and bContinuosDrift then -- called when stopped 1 drift but has chance for combo
				if iCurrentTick - iEndDriftTick >= iBackToDriftMS then
					triggerEvent( "onClientVehicleEndDrift", eVeh, iDriftTime, iDriftCombo );
					triggerEvent( "onVehicleEndDrift", eVeh, iDriftTime, iDriftCombo );
					bContinuosDrift = false;
					bIsDrifting = false;
					iEndDriftTick = 0;
					iDriftTime = 0;
					iDriftCombo = 1;
				end
			elseif bIsDrifting and bContinuosDrift and not getControlState("brake_reverse") then
				iDriftTime = iDriftTime + (iCurrentTick - iLastFrameTick);
				triggerEvent( "onClientVehicleDrift", eVeh, fDriftAng, fVelocity, sDriftDir, iDriftTime );
			end
			
		end
		iLastFrameTick = iCurrentTick;
	end
)

