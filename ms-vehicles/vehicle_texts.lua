local archivo_narrow = dxCreateFont( "f/archivo_narrow.ttf", 20 )
local vehicles_table = {}


addEventHandler( "onClientRender", getRootElement( ),
	function( )
		local cx, cy, cz = getCameraMatrix( )
		local dimension = getElementDimension( localPlayer )
		local interior = getElementInterior( localPlayer )

		local dimension = getElementDimension( localPlayer )

		for k,v in ipairs (vehicles_table) do
			if isElement(v) and getElementData(v, 'vehicle:id') and not getVehicleController(v) then
				if getElementDimension( v ) == dimension and getElementInterior( v ) == interior then
					if getElementData(v, "vehicle:exchange") then
						local text = getElementData(v, "vehicle:text") or ""
						local vehx, vehy, vehz = getElementPosition(v)
						local distance = getDistanceBetweenPoints3D(vehx,vehy,vehz,cx,cy,cz)
						if distance <= 10 then
							local sx, sy = getScreenFromWorldPosition(vehx,vehy,vehz+1)
							if sx and sy then
								dxDrawText(text, sx,sy,sx,sy,tocolor(255,255,255,255), 0.6, archivo_narrow, "center", "top", false, false, false, true)
							end
						end
					else
						local addons = getElementData(v, "vehicle:upgrade_addons") or {engine=0, jump=0, hp=0}
						local px, py, pz = getElementPosition( v )
						local distance = getDistanceBetweenPoints3D( px, py, pz, cx, cy, cz )
					
						local text = "ID: #86BFFF".. getElementData(v, 'vehicle:id') .."\n#ffffffWłaściciel: #86BFFF".. getElementData(v, 'vehicle:owner_name') .."\n#ffffffPrzebieg: #86BFFF".. tostring(math.floor(tonumber(getElementData(v, 'vehicle:mileage')/1000))) .." km\n#ffffffModyfikatory: #86BFFFE".. addons.engine ..", J" .. addons.jump ..", H".. addons.hp ..""
						local text2 = "ID: ".. getElementData(v, 'vehicle:id') .."\nWłaściciel: ".. getElementData(v, 'vehicle:owner_name') .."\nPrzebieg: ".. tostring(math.floor(tonumber(getElementData(v, 'vehicle:mileage')/1000))) .." km\nModyfikatory: E".. addons.engine ..", J" .. addons.jump ..", H".. addons.hp ..""

						if distance <= 10.0 and text then
								local sx, sy = getScreenFromWorldPosition( px, py, pz + 0.5 )
								if sx and sy then
									--dxDrawRectangle(sx-40, sy+2, 200,30, tocolor(0, 0, 0, 150), false)
									--dxDrawImage(sx-40, sy, 30, 30, exports["ms-dashboard"]:loadAvatar(getElementData(v, "vehicle:owner") or false), 0, 0, 0, tocolor(255, 255, 255, 255), true)
									dxDrawText( tostring( text2 ), sx+2, sy+2, sx, sy, tocolor( 0, 0, 0, 255 ), 0.5, archivo_narrow, "center", "top", false, false, false, false)
									dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 0.5, archivo_narrow, "center", "top", false, false, false, true )
								end
						end
					end
				end
			end
		end
end)

function updateVehiclesTable()
	vehicles_table = {}
	for k,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:owner") then
			local px,py,pz = getElementPosition(localPlayer)
			local vx,vy,vz = getElementPosition(v)
			local distance = getDistanceBetweenPoints3D (px, py, pz, vx, vy, vz)
			if distance < 50 then
				table.insert(vehicles_table, v)
			end
		end
	end
end
updateVehiclesTable()
setTimer(updateVehiclesTable, 2000, 0)
