driftScore = 0 
driftCombo = 1
gShowMeter = false 
startDriftTick = 0 

addEventHandler( "onClientResourceStart", resourceRoot,
	function(  )
		screenW, screenH = guiGetScreenSize()
		zoom = exports["ms-hud"]:getInterfaceZoom()
		
		font = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 24/zoom, false, "antialiased")
	end
)

addEventHandler( "onClientVehicleStartDrift", root,
	function( )
		startDriftTick = getTickCount() 
		driftScore = 0
		driftCombo = 1 
		
		addEventHandler( "onClientVehicleDrift", root, drift )

		bgPos = {x=screenW/2-431/zoom/2, y=screenH-300/zoom, w=431/zoom, h=53/zoom}
		gShowMeter = true
	end
)

addEventHandler( "onClientVehicleEndDrift", root,
	function( )
		if driftScore > 1 then 
			local finalScore = driftScore*driftCombo
			local start = getTickCount()
			local function renderDriftScore()
				local progress = ((start+3000)-getTickCount()) / 1000
				local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, math.min(progress, 1), "InQuad")
				dxDrawBorderedText(tostring(finalScore).."pkt", bgPos.x, bgPos.y+bgPos.h-100/zoom, bgPos.x+bgPos.w, bgPos.h, tocolor(52, 152, 219, alpha), 1, font, "center", "top", false, false, true, alpha)
			end 
			addEventHandler("onClientRender", root, renderDriftScore)
			
			setTimer(function() 
				removeEventHandler("onClientRender", root, renderDriftScore)
			end, 3000, 1)
			
			driftScore = 0
			driftCombo = 1 
			
			removeEventHandler( "onClientVehicleDrift", root, drift )
			
			if finalScore > 1000 then 
				triggerServerEvent("onPlayerUpdateDrift", localPlayer, finalScore)
			end 
		end 
		
		gShowMeter = false
	end
)

addEventHandler( "onClientVehicleDriftCombo", root, 
	function( iCombo )
		driftCombo = iCombo
	end
);

addEventHandler("onClientVehicleDamage", root, function()
	if source == getPedOccupiedVehicle(localPlayer) then 
		if driftScore > 0 then 
			triggerEvent("onClientVehicleEndDrift", source)
		end
	end
end)

function drift( fAngle, fSpeed, sSide, iDriftTime )
	driftScore = math.ceil( driftScore + (fAngle/50) * (fSpeed/30) )
	driftSide = sSide
end

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,postGUI, borderAlpha) 
    for oX = -1, 1 do -- Border size is 1 
        for oY = -1, 1 do -- Border size is 1 
                dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, borderAlpha), scale, font, alignX, alignY, clip, wordBreak,postGUI) 
        end 
    end 
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI) 
end 