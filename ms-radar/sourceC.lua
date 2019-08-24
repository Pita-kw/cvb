local mathDeg = math.deg; 
local mathFloor = math.floor;
local mathAbs = math.abs;
local mathMin = math.min;
local mathMax = math.max; 

Display = {};
Display.Width, Display.Height = guiGetScreenSize(); 
Display.zoom = 1.0
Display.minZoom = 2
if Display.Width < 1920 then
	Display.zoom = mathMin(Display.minZoom, (1920+200)/Display.Width)
end 

Minimap = {};
Minimap.Width = mathFloor(400/Display.zoom);
Minimap.Height = mathFloor(220/Display.zoom);

Minimap.PosX = 20;
Minimap.PosY = (Display.Height - 20) - Minimap.Height;

Minimap.IsVisible = true;
Minimap.TextureSize = radarSettings['mapTextureSize'];
Minimap.NormalTargetSize, Minimap.BiggerTargetSize = Minimap.Width, Minimap.Width * 2;
Minimap.MapTarget = dxCreateRenderTarget(Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, true);
Minimap.RenderTarget = dxCreateRenderTarget(Minimap.NormalTargetSize * 3, Minimap.NormalTargetSize * 3, true);
Minimap.MapTexture = dxCreateTexture(radarSettings['mapTexture'], 'dxt1');

Minimap.CurrentZoom = 5;
Minimap.MaximumZoom = 8;
Minimap.MinimumZoom = 3;

Minimap.WaterColor = radarSettings['mapWaterColor'];
Minimap.Alpha = radarSettings['alpha'];
Minimap.PlayerInVehicle = false;
Minimap.LostRotation = 0;
Minimap.MapUnit = Minimap.TextureSize / 6000;

Bigmap = {};
Bigmap.Width, Bigmap.Height = Display.Width - 40, Display.Height - 40;
Bigmap.PosX, Bigmap.PosY = 20, 20;
Bigmap.IsVisible = false;
Bigmap.CurrentZoom = 2;
Bigmap.MinimumZoom = 1.5;
Bigmap.MaximumZoom = 5;

Fonts = {};
Fonts.Roboto = dxCreateFont('files/fonts/roboto.ttf', 25);
Fonts.Icons = dxCreateFont('files/fonts/icons.ttf', 25);

Stats = {};
Stats.Bar = {};
Stats.Bar.Width = Minimap.Width;
Stats.Bar.Height = 10;

playersData = {}
blipData = {}

local playerX, playerY, playerZ = 0, 0, 0;
local mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false;
local sectorSize = 6000 / 143

function getRadarPosition()
	return Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height
end 

function getInterfaceZoom()
	return Display.zoom;
end 

function showRadar(b)
	Minimap.IsVisible = b
end

addCommandHandler("hidehud",
	function()
		Minimap.IsVisible = not Minimap.IsVisible;
	end
)

addEvent("onClientShowRadar", true)
addEventHandler("onClientShowRadar", root,
	function(b)
		Minimap.IsVisible = b;
	end
)

addEventHandler('onClientResourceStart', resourceRoot,
	function()
		setPlayerHudComponentVisible('radar', false);
		if (Minimap.MapTexture) then
			dxSetTextureEdge(Minimap.MapTexture, 'border', tocolor(Minimap.WaterColor[1], Minimap.WaterColor[2], Minimap.WaterColor[3], 255));
		end
		
		-- refresh co sekunde waznych danych na minimapke
		setTimer(function()
			playersData = {}
			for k, v in ipairs(getElementsByType('player')) do 
				table.insert(playersData, v)
			end
			
			blipData = {}
			for k, v in ipairs(getElementsByType('blip')) do 
				table.insert(blipData, v)
			end
		end, 1000, 0)
	end
);

addEventHandler('onClientKey', root,
	function(key, state) 
		if (state) then
			if (key == 'F11') then
				if isPlayerHudComponentVisible("radar") then 
					return
				end 
				
				cancelEvent();
				Bigmap.IsVisible = not Bigmap.IsVisible;
				showCursor(false);
				
				if (Bigmap.IsVisible) then
					triggerEvent("onClientShowHUD", localPlayer, false);
					showChat(false);
					playSoundFrontEnd(1);
					Minimap.IsVisible = false;
				else
					triggerEvent("onClientShowHUD", localPlayer, true);
					showChat(true);
					playSoundFrontEnd(2);
					Minimap.IsVisible = true;
					mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false;
				end
			elseif (key == 'mouse_wheel_down' and Bigmap.IsVisible) then
				Bigmap.CurrentZoom = mathMin(Bigmap.CurrentZoom + 0.5, Bigmap.MaximumZoom);
			elseif (key == 'mouse_wheel_up' and Bigmap.IsVisible) then
				Bigmap.CurrentZoom = mathMax(Bigmap.CurrentZoom - 0.5, Bigmap.MinimumZoom);
			elseif (key == 'lctrl' and Bigmap.IsVisible) then
				showCursor(not isCursorShowing());
			end
		end
	end
);

addEventHandler('onClientClick', root,
	function(button, state, cursorX, cursorY)
		if (not Minimap.IsVisible and Bigmap.IsVisible) then
			if (button == 'left' and state == 'down') then
				if (cursorX >= Bigmap.PosX and cursorX <= Bigmap.PosX + Bigmap.Width) then
					if (cursorY >= Bigmap.PosY and cursorY <= Bigmap.PosY + Bigmap.Height) then
						mapOffsetX = cursorX * Bigmap.CurrentZoom + playerX;
						mapOffsetY = cursorY * Bigmap.CurrentZoom - playerY;
						mapIsMoving = true;
					end
				end
			elseif (button == 'left' and state == 'up') then
				mapIsMoving = false;
			end
		end
	end
);

local radarTextures = {}
addEventHandler('onClientRender', root,
	function()
		if not getElementData(localPlayer, "player:spawned") then return end 
		
		if (not Minimap.IsVisible and Bigmap.IsVisible) then
			dxDrawBorder(Bigmap.PosX, Bigmap.PosY, Bigmap.Width, Bigmap.Height, 2, tocolor(30, 30, 30, 200));
			
			local absoluteX, absoluteY = 0, 0;
			local zoneName = 'Lokalizacja nieznana';
			
			if (getElementInterior(localPlayer) == 0) then
				if (isCursorShowing()) then
					local cursorX, cursorY = getCursorPosition();
					local mapX, mapY = getWorldFromMapPosition(cursorX, cursorY);
					
					absoluteX = cursorX * Display.Width;
					absoluteY = cursorY * Display.Height;
					
					if (getKeyState('mouse1') and mapIsMoving) then
						playerX = -(absoluteX * Bigmap.CurrentZoom - mapOffsetX);
						playerY = absoluteY * Bigmap.CurrentZoom - mapOffsetY;
						
						playerX = mathMax(-3000, mathMin(3000, playerX));
						playerY = mathMax(-3000, mathMin(3000, playerY));
					end
					
					if (not mapIsMoving) then
						if (Bigmap.PosX <= absoluteX and Bigmap.PosY <= absoluteY and Bigmap.PosX + Bigmap.Width >= absoluteX and Bigmap.PosY + Bigmap.Height >= absoluteY) then
							zoneName = getZoneName(mapX, mapY, 0);
							if zoneName == "Unknown" then zoneName = "Lokalizacja nieznana" end
						else
							zoneName = 'Lokalizacja nieznana';
						end
					else
						zoneName = 'Puść mapę aby ustalić lokalizację';
					end
				else
					playerX, playerY, playerZ = getElementPosition(localPlayer);
					local zone_name = getZoneName(playerX, playerY, playerZ)
					if zone_name == "Unknown" then zone_name = "nieznanej lokalizacji" end
					zoneName = "Jesteś obecnie w ".. zone_name .." aby przesuwać mape kliknij LCTRL i przeciągnij"
				end
				
				local playerRotation = getPedRotation(localPlayer);
				local mapX = (((3000 + playerX) * Minimap.MapUnit) - (Bigmap.Width / 2) * Bigmap.CurrentZoom);
				local mapY = (((3000 - playerY) * Minimap.MapUnit) - (Bigmap.Height / 2) * Bigmap.CurrentZoom);
				local mapWidth, mapHeight = Bigmap.Width * Bigmap.CurrentZoom, Bigmap.Height * Bigmap.CurrentZoom;

				dxDrawImageSection(Bigmap.PosX, Bigmap.PosY, Bigmap.Width, Bigmap.Height, mapX, mapY, mapWidth, mapHeight, Minimap.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Minimap.Alpha));
				
				--> Radar area
				for _, area in ipairs(getElementsByType('radararea')) do
					local areaX, areaY = getElementPosition(area);
					local areaWidth, areaHeight = getRadarAreaSize(area);
					local areaR, areaG, areaB, areaA = getRadarAreaColor(area);
						
					if (isRadarAreaFlashing(area)) then
						areaA = areaA * mathAbs(getTickCount() % 1000 - 500) / 500;
					end
					
					local areaX, areaY = getMapFromWorldPosition(areaX, areaY + areaHeight);
					local areaWidth, areaHeight = areaWidth / Bigmap.CurrentZoom * Minimap.MapUnit, areaHeight / Bigmap.CurrentZoom * Minimap.MapUnit;

					--** Width
					if (areaX < Bigmap.PosX) then
						areaWidth = areaWidth - mathAbs((Bigmap.PosX) - (areaX));
						areaX = areaX + mathAbs((Bigmap.PosX) - (areaX));
					end
					
					if (areaX + areaWidth > Bigmap.PosX + Bigmap.Width) then
						areaWidth = areaWidth - mathAbs((Bigmap.PosX + Bigmap.Width) - (areaX + areaWidth));
					end
					
					if (areaX > Bigmap.PosX + Bigmap.Width) then
						areaWidth = areaWidth + mathAbs((Bigmap.PosX + Bigmap.Width) - (areaX));
						areaX = areaX - mathAbs((Bigmap.PosX + Bigmap.Width) - (areaX));
					end
					
					if (areaX + areaWidth < Bigmap.PosX) then
						areaWidth = areaWidth + mathAbs((Bigmap.PosX) - (areaX + areaWidth));
						areaX = areaX - mathAbs((Bigmap.PosX) - (areaX + areaWidth));
					end
					
					--** Height
					if (areaY < Bigmap.PosY) then
						areaHeight = areaHeight - mathAbs((Bigmap.PosY) - (areaY));
						areaY = areaY + mathAbs((Bigmap.PosY) - (areaY));
					end
					
					if (areaY + areaHeight > Bigmap.PosY + Bigmap.Height) then
						areaHeight = areaHeight - mathAbs((Bigmap.PosY + Bigmap.Height) - (areaY + areaHeight));
					end
					
					if (areaY + areaHeight < Bigmap.PosY) then
						areaHeight = areaHeight + mathAbs((Bigmap.PosY) - (areaY + areaHeight));
						areaY = areaY - mathAbs((Bigmap.PosY) - (areaY + areaHeight));
					end
					
					if (areaY > Bigmap.PosY + Bigmap.Height) then
						areaHeight = areaHeight + mathAbs((Bigmap.PosY + Bigmap.Height) - (areaY));
						areaY = areaY - mathAbs((Bigmap.PosY + Bigmap.Height) - (areaY));
					end
					
					--** Draw
					dxDrawRectangle(areaX, areaY, areaWidth, areaHeight, tocolor(areaR, areaG, areaB, areaA), false);
				end
				
				--> Blips
				for _, blip in ipairs(blipData) do
					if isElement(blip) and getElementInterior(blip) == getElementInterior(localPlayer) and getElementDimension(blip) == getElementDimension(localPlayer) then 
						local blipX, blipY, blipZ = getElementPosition(blip);

						if (localPlayer ~= getElementAttachedTo(blip)) then
							local blipSettings = {
								['color'] = {255, 255, 255, 255},
								['size'] = getElementData(blip, 'blipSize') or 20,
								['icon'] = getElementData(blip, 'blipIcon') or 'unknown',
								['exclusive'] = getElementData(blip, 'exclusiveBlip') or false
							};
							
							if (blipSettings['icon'] == 'target' or blipSettings['icon'] == 'waypoint' or blipSettings['icon'] == 'house') then
								blipSettings['color'] = getElementData(blip, 'blipColor') or {255, 255, 255, 255};
							end
							
							local centerX, centerY = (Bigmap.PosX + (Bigmap.Width / 2)), (Bigmap.PosY + (Bigmap.Height / 2));
							local leftFrame = (centerX - Bigmap.Width / 2) + (blipSettings['size'] / 2);
							local rightFrame = (centerX + Bigmap.Width / 2) - (blipSettings['size'] / 2);
							local topFrame = (centerY - Bigmap.Height / 2) + (blipSettings['size'] / 2);
							local bottomFrame = (centerY + Bigmap.Height / 2) - (blipSettings['size'] / 2);
							local blipX, blipY = getMapFromWorldPosition(blipX, blipY);
							
							centerX = mathMax(leftFrame, mathMin(rightFrame, blipX));
							centerY = mathMax(topFrame, mathMin(bottomFrame, blipY));

							dxDrawImage(centerX - (blipSettings['size'] / 2), centerY - (blipSettings['size'] / 2), blipSettings['size'], blipSettings['size'], 'files/images/blips/' .. blipSettings['icon'] .. '.png', 0, 0, 0, tocolor(blipSettings['color'][1], blipSettings['color'][2], blipSettings['color'][3], blipSettings['color'][4]));
						end
					end
				end
				
				for _, player in ipairs(playersData) do -- cipsko
					if isElement(player) then
						local otherPlayerX, otherPlayerY, otherPlayerZ = getElementPosition(player);
							
						if (localPlayer ~= player) then
							local playerIsVisible = false;
							local blipSettings = {
								['color'] = {255, 255, 255, 255},
								['size'] = 25,
								['icon'] = 'player'
							};
							
							blipSettings['color'] = {getPlayerNametagColor(player)};

							local blipX, blipY = getMapFromWorldPosition(otherPlayerX, otherPlayerY);
							
							if (blipX >= Bigmap.PosX and blipX <= Bigmap.PosX + Bigmap.Width) then
								if (blipY >= Bigmap.PosY and blipY <= Bigmap.PosY + Bigmap.Height) then
									if getElementData(player, "player:hide_blip") == false and getElementDimension(player) == getElementDimension(localPlayer) and getElementInterior(player) == getElementInterior(localPlayer) then
										dxDrawImage(blipX - (blipSettings['size'] / 2), blipY - (blipSettings['size'] / 2), blipSettings['size'], blipSettings['size'], 'files/images/blips/' .. blipSettings['icon'] .. '.png', 0, 0, 0, tocolor(blipSettings['color'][1], blipSettings['color'][2], blipSettings['color'][3], blipSettings['color'][4]));
									end
								end
							end
						end
					end
				end
				
				--> Local player
				local localX, localY, localZ = getElementPosition(localPlayer);
				local blipX, blipY = getMapFromWorldPosition(localX, localY);
						
				if (blipX >= Bigmap.PosX and blipX <= Bigmap.PosX + Bigmap.Width) then
					if (blipY >= Bigmap.PosY and blipY <= Bigmap.PosY + Bigmap.Height) then
						dxDrawImage(blipX - 10, blipY - 10, 20, 20, 'files/images/arrow.png', 360 - playerRotation);
					end
				end
				
				--> GPS Location
				dxDrawRectangle(Bigmap.PosX, (Bigmap.PosY + Bigmap.Height) - 25, Bigmap.Width, 25, tocolor(30, 30, 30, 200));
				dxDrawText(zoneName, Bigmap.PosX + 10, (Bigmap.PosY + Bigmap.Height) - 25, Bigmap.PosX + 10 + Bigmap.Width - 20, (Bigmap.PosY + Bigmap.Height), tocolor(255, 255, 255, 255), 0.50, Fonts.Roboto, 'center', 'center');
			else
				dxDrawRectangle(Bigmap.PosX, Bigmap.PosY, Bigmap.Width, Bigmap.Height, tocolor(30, 30, 30, 150));
				dxDrawText('Nieznana lokalizacja', Bigmap.PosX, Bigmap.PosY + 20, Bigmap.PosX + Bigmap.Width, Bigmap.PosY + 20 + Bigmap.Height, tocolor(255, 255, 255, 255 * mathAbs(getTickCount() % 2000 - 1000) / 1000), 0.40, Fonts.Roboto, 'center', 'center', false, false, false, true, true);
				dxDrawText('', Bigmap.PosX, Bigmap.PosY - 20, Bigmap.PosX + Bigmap.Width, Bigmap.PosY - 20 + Bigmap.Height, tocolor(255, 255, 255, 255 * mathAbs(getTickCount() % 2000 - 1000) / 1000), 1.00, Fonts.Icons, 'center', 'center', false, false, false, true, true);
				
				if (Minimap.LostRotation > 360) then
					Minimap.LostRotation = 0;
				end
				
				dxDrawText('', (Bigmap.PosX + Bigmap.Width - 25), Bigmap.PosY, (Bigmap.PosX + Bigmap.Width - 25) + 25, Bigmap.PosY + 25, tocolor(255, 255, 255, 100), 0.50, Fonts.Icons, 'center', 'center', false, false, false, true, true, Minimap.LostRotation);
				Minimap.LostRotation = Minimap.LostRotation + 1;
			end
		elseif (Minimap.IsVisible and not Bigmap.IsVisible) then
			if (radarSettings['showStats']) then
				Minimap.PosY = ((Display.Height - 20) - Stats.Bar.Height) - Minimap.Height;
			else
				Minimap.PosY = (Display.Height - 20) - Minimap.Height;
			end
			
			dxDrawBorder(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, 2, tocolor(30, 30, 30, 200));
			
			if (getElementInterior(localPlayer) == 0) then
				Minimap.PlayerInVehicle = getPedOccupiedVehicle(localPlayer);
				playerX, playerY, playerZ = getElementPosition(localPlayer);
				
				--> Calculate positions
				local playerRotation = getPedRotation(localPlayer);
				local playerMapX, playerMapY = (3000 + playerX) / 6000 * Minimap.TextureSize, (3000 - playerY) / 6000 * Minimap.TextureSize;
				local streamDistance, pRotation = getRadarRadius(), getRotation();
				local mapRadius = streamDistance / 6000 * Minimap.TextureSize * Minimap.CurrentZoom;
				local mapX, mapY, mapWidth, mapHeight = playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2;
				
				--> Set world
				dxSetRenderTarget(Minimap.MapTarget, true);
				dxDrawRectangle(0, 0, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, tocolor(Minimap.WaterColor[1], Minimap.WaterColor[2], Minimap.WaterColor[3], Minimap.Alpha), false);
				
				dxDrawImageSection(0, 0, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, mapX, mapY, mapWidth, mapHeight, Minimap.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Minimap.Alpha), false);

				--> Draw radar areas
				for _, area in pairs(getElementsByType('radararea')) do
					local areaX, areaY = getElementPosition(area);
					local areaWidth, areaHeight = getRadarAreaSize(area);
					local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (3000 + areaX) / 6000 * Minimap.TextureSize, (3000 - areaY) / 6000 * Minimap.TextureSize, areaWidth / 6000 * Minimap.TextureSize, -(areaHeight / 6000 * Minimap.TextureSize);
					
					if (doesCollide(playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2, areaMapX, areaMapY, areaMapWidth, areaMapHeight)) then
						local areaR, areaG, areaB, areaA = getRadarAreaColor(area);
						
						if (isRadarAreaFlashing(area)) then
							areaA = areaA * mathAbs(getTickCount() % 1000 - 500) / 500;
						end
						
						local mapRatio = Minimap.BiggerTargetSize / (mapRadius * 2);
						local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (areaMapX - (playerMapX - mapRadius)) * mapRatio, (areaMapY - (playerMapY - mapRadius)) * mapRatio, areaMapWidth * mapRatio, areaMapHeight * mapRatio;
						
						dxSetBlendMode('modulate_add');
						dxDrawRectangle(areaMapX, areaMapY, areaMapWidth, areaMapHeight, tocolor(areaR, areaG, areaB, areaA), false);
						dxSetBlendMode('blend');
					end
				end
				
				--> Draw blip
				dxSetRenderTarget(Minimap.RenderTarget, true);
				dxDrawImage(Minimap.NormalTargetSize / 2, Minimap.NormalTargetSize / 2, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, Minimap.MapTarget, mathDeg(-pRotation), 0, 0, tocolor(255, 255, 255, 255), false);
				
				serverBlips = blipData
				for _, blip in pairs(serverBlips) do
					if isElement(blip) then 
						if (localPlayer ~= getElementAttachedTo(blip) and getElementInterior(localPlayer) == getElementInterior(blip) and getElementDimension(localPlayer) == getElementDimension(blip)) then 
							local blipX, blipY, blipZ = getElementPosition(blip);
						
							local blipSettings = {
								['color'] = {255, 255, 255, 255},
								['size'] = getElementData(blip, 'blipSize') or 20,
								['exclusive'] = getElementData(blip, 'exclusiveBlip') or false,
								['icon'] = getElementData(blip, 'blipIcon') or 'unknown'
							};
							local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY);
							local blipRotation = mathDeg(-getVectorRotation(playerX, playerY, blipX, blipY) - (-pRotation)) - 180;
							local blipRadius = mathMin((blipDistance / (streamDistance * Minimap.CurrentZoom)) * Minimap.NormalTargetSize, Minimap.NormalTargetSize);
							local distanceX, distanceY = getPointFromDistanceRotation(0, 0, blipRadius, blipRotation);
							
							local blipX, blipY = Minimap.NormalTargetSize * 1.5 + (distanceX - (blipSettings['size'] / 2)), Minimap.NormalTargetSize * 1.5 + (distanceY - (blipSettings['size'] / 2));
							local calculatedX, calculatedY = ((Minimap.PosX + (Minimap.Width / 2)) - (blipSettings['size'] / 2)) + (blipX - (Minimap.NormalTargetSize * 1.5) + (blipSettings['size'] / 2)), (((Minimap.PosY + (Minimap.Height / 2)) - (blipSettings['size'] / 2)) + (blipY - (Minimap.NormalTargetSize * 1.5) + (blipSettings['size'] / 2)));
							
							if (blipSettings['icon'] == 'target' or blipSettings['icon'] == 'waypoint' or blipSettings['icon'] == 'house') then
								blipSettings['color'] = getElementData(blip, 'blipColor') or {255, 255, 255, 255};
							end
							
							local pass = true

							if (blipSettings['exclusive'] == true) then
								blipX = mathMax(blipX + (Minimap.PosX - calculatedX), mathMin(blipX + (Minimap.PosX + Minimap.Width - blipSettings['size'] - calculatedX), blipX));
								blipY = mathMax(blipY + (Minimap.PosY - calculatedY), mathMin(blipY + (Minimap.PosY + Minimap.Height - blipSettings['size'] - calculatedY), blipY));
							else 
								pass = calculatedX+blipSettings["size"] > Minimap.PosX and calculatedX-blipSettings["size"] < Minimap.PosX+Minimap.Width and calculatedY+blipSettings["size"] > Minimap.PosY and calculatedY-blipSettings["size"] < Minimap.PosY+Minimap.Height
							end
							
							if pass then
								dxSetBlendMode('modulate_add');
								dxDrawImage(blipX, blipY, blipSettings['size'], blipSettings['size'], 'files/images/blips/' .. blipSettings['icon'] .. '.png', 0, 0, 0, tocolor(blipSettings['color'][1], blipSettings['color'][2], blipSettings['color'][3], blipSettings['color'][4]), false);
								dxSetBlendMode('blend');
							end
						end
					end
				end
				
				
				for _, player in pairs(playersData) do
					if isElement(player) then
						local otherPlayerX, otherPlayerY, otherPlayerZ = getElementPosition(player);
						
						if (localPlayer ~= player and streamDistance * Minimap.CurrentZoom) then
							local playerDistance = getDistanceBetweenPoints2D(otherPlayerX, otherPlayerY, playerX, playerY);
							if playerDistance < 300 then 
								local playerRotation = mathDeg(-getVectorRotation(playerX, playerY, otherPlayerX, otherPlayerY) - (-pRotation)) - 180;
								local playerRadius = mathMin((playerDistance / (streamDistance * Minimap.CurrentZoom)) * Minimap.NormalTargetSize, Minimap.NormalTargetSize);
								local distanceX, distanceY = getPointFromDistanceRotation(0, 0, playerRadius, playerRotation);
								
								local otherPlayerX, otherPlayerY = Minimap.NormalTargetSize * 1.5 + (distanceX - 10), Minimap.NormalTargetSize * 1.5 + (distanceY - 10);
								local calculatedX, calculatedY = ((Minimap.PosX + (Minimap.Width / 2)) - 10) + (otherPlayerX - (Minimap.NormalTargetSize * 1.5) + 10), (((Minimap.PosY + (Minimap.Height / 2)) - 10) + (otherPlayerY - (Minimap.NormalTargetSize * 1.5) + 10));
								local playerR, playerG, playerB = getPlayerNametagColor(player);
								
								otherPlayerX = mathMax(otherPlayerX + (Minimap.PosX - calculatedX), mathMin(otherPlayerX + (Minimap.PosX + Minimap.Width - 20 - calculatedX), otherPlayerX));
								otherPlayerY = mathMax(otherPlayerY + (Minimap.PosY - calculatedY), mathMin(otherPlayerY + (Minimap.PosY + Minimap.Height - 20 - calculatedY), otherPlayerY));
								
								dxSetBlendMode('modulate_add');
								if getElementData(player, "player:hide_blip") == false and getElementDimension(player) == getElementDimension(localPlayer) and getElementInterior(player) == getElementInterior(localPlayer) then
									dxDrawImage(otherPlayerX, otherPlayerY, 20, 20, 'files/images/blips/player.png', 0, 0, 0, tocolor(playerR, playerG, playerB, 255), false);
								end
								dxSetBlendMode('blend');
							end
						end
					end
				end
				
				--> Draw fully minimap
				dxSetRenderTarget();
				dxDrawImageSection(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Width / 2), Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Height / 2), Minimap.Width, Minimap.Height, Minimap.RenderTarget, 0, -90, 0, tocolor(255, 255, 255, 255));
				
				--> Local player
				dxDrawImage((Minimap.PosX + (Minimap.Width / 2)) - 10, (Minimap.PosY + (Minimap.Height / 2)) - 10, 20, 20, 'files/images/arrow.png', mathDeg(-pRotation) - playerRotation);
			
				--> GPS
				--dxDrawRectangle(Minimap.PosX, Minimap.PosY + Minimap.Height - 20, Minimap.Width, 20, tocolor(0, 0, 0, 150));
				--dxDrawText(zone_name, Minimap.PosX + 5, (Minimap.PosY + Minimap.Height - 25), Minimap.PosX + 5 + Minimap.Width - 10, Minimap.PosY + Minimap.Height, tocolor(255, 255, 255, 255), 0.4, Fonts.Roboto, 'center', 'center', true, false, false, true, true);
				
				
				--> Zoom
				if (getKeyState('num_add') or getKeyState('num_sub')) then
					Minimap.CurrentZoom = mathMax(Minimap.MinimumZoom, mathMin(Minimap.MaximumZoom, Minimap.CurrentZoom + ((getKeyState('num_sub') and -1 or 1) * (getTickCount() - (getTickCount() + 50)) / 100)));
				end
			else
				dxDrawRectangle(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, tocolor(30, 30, 30, 150));
				dxDrawText('Nieznana lokalizacja', Minimap.PosX, Minimap.PosY + 20, Minimap.PosX + Minimap.Width, Minimap.PosY + 20 + Minimap.Height, tocolor(255, 255, 255, 255 * mathAbs(getTickCount() % 2000 - 1000) / 1000), 0.40, Fonts.Roboto, 'center', 'center', false, false, false, true, true);
				dxDrawText('', Minimap.PosX, Minimap.PosY - 20, Minimap.PosX + Minimap.Width, Minimap.PosY - 20 + Minimap.Height, tocolor(255, 255, 255, 255 * mathAbs(getTickCount() % 2000 - 1000) / 1000), 1.00, Fonts.Icons, 'center', 'center', false, false, false, true, true);
				
				if (Minimap.LostRotation > 360) then
					Minimap.LostRotation = 0;
				end
				
				dxDrawText('', (Minimap.PosX + Minimap.Width - 25), Minimap.PosY, (Minimap.PosX + Minimap.Width - 25) + 25, Minimap.PosY + 25, tocolor(255, 255, 255, 100), 0.50, Fonts.Icons, 'center', 'center', false, false, false, true, true, Minimap.LostRotation);
				Minimap.LostRotation = Minimap.LostRotation + 1;
			end
			
			--> Stats
			if (radarSettings['showStats']) then
				if (isElementInWater(localPlayer)) then
					Stats.Bar.Width = (Minimap.Width / 3);
				else
					Stats.Bar.Width = (Minimap.Width / 2);
				end
				
				local healthColor;
		
				if (getElementHealth(localPlayer) <= 20) then
					local healthPulseTick = getTickCount() % 600;
					healthColor = {healthPulseTick <= 300 and 255 or 200, healthPulseTick <= 300 and 100 or 100, healthPulseTick <= 300 and 100 or 100};
				end
				
				dxDrawBorder(Minimap.PosX, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width, Stats.Bar.Height, 2, tocolor(30, 30, 30, 200));
				dxDrawBorder(Minimap.PosX + Stats.Bar.Width + 2, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width - 2, Stats.Bar.Height, 2, tocolor(30, 30, 30, 200));
				dxDrawRectangle(Minimap.PosX, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width, Stats.Bar.Height, tocolor(30, 30, 30, 140)); -- 51, 102, 255
				dxDrawRectangle(Minimap.PosX + Stats.Bar.Width + 2, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width - 2, Stats.Bar.Height, tocolor(30, 30, 30, 140));
				--dxDrawRectangle(Minimap.PosX - 2, Minimap.PosY + Minimap.Height + 13, Stats.Bar.Width+146.5, 4, tocolor(51, 102, 255, 255));
				
				dxDrawRectangle(Minimap.PosX, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width / 100 * getElementHealth(localPlayer), Stats.Bar.Height, tocolor(171, 46, 30, 255));
				dxDrawRectangle(Minimap.PosX + Stats.Bar.Width + 2, Minimap.PosY + Minimap.Height + 2, (Stats.Bar.Width - 2) / 100 * getPedArmor(localPlayer), Stats.Bar.Height, tocolor(180, 180, 180, 200));
			
				if (isElementInWater(localPlayer)) then
					dxDrawBorder(Minimap.PosX + (Stats.Bar.Width * 2) + 2, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width - 2, Stats.Bar.Height, 2, tocolor(30, 30, 30, 200));
					dxDrawRectangle(Minimap.PosX + (Stats.Bar.Width * 2) + 2, Minimap.PosY + Minimap.Height + 2, Stats.Bar.Width - 2, Stats.Bar.Height, tocolor(30, 30, 30, 140));
					dxDrawRectangle(Minimap.PosX + (Stats.Bar.Width * 2) + 2, Minimap.PosY + Minimap.Height + 2, (Stats.Bar.Width - 2) / 1000 * getPedOxygenLevel(localPlayer), Stats.Bar.Height, tocolor(230, 230, 30, 200));
				end
			end
		end
	end
);

function doesCollide(x1, y1, w1, h1, x2, y2, w2, h2)
	local horizontal = (x1 < x2) ~= (x1 + w1 < x2) or (x1 > x2) ~= (x1 > x2 + w2);
	local vertical = (y1 < y2) ~= (y1 + h1 < y2) or (y1 > y2) ~= (y1 > y2 + h2);
	
	return (horizontal and vertical);
end

function getRadarRadius()
	if (not Minimap.PlayerInVehicle) then
		return 180;
	else
		local vehicleX, vehicleY, vehicleZ = getElementVelocity(Minimap.PlayerInVehicle);
		local currentSpeed = (1 + (vehicleX ^ 2 + vehicleY ^ 2 + vehicleZ ^ 2) ^ (0.5)) / 2;
	
		if (currentSpeed <= 0.5) then
			return 180;
		elseif (currentSpeed >= 1) then
			return 360;
		end
		
		local distance = currentSpeed - 0.5;
		local ratio = 180 / 0.5;
		
		return math.ceil((distance * ratio) + 180);
	end
end

local mathRad, mathCos, mathSin = math.rad, math.cos, math.sin
function getPointFromDistanceRotation(x, y, dist, angle)
	local a = mathRad(90 - angle);
	local dx = mathCos(a) * dist;
	local dy = mathSin(a) * dist;
	
	return x + dx, y + dy;
end

function getRotation()
	local cameraX, cameraY, _, rotateX, rotateY = getCameraMatrix();
	local camRotation = getVectorRotation(cameraX, cameraY, rotateX, rotateY);
	
	return camRotation;
end

local mathAtan2 = math.atan2
function getVectorRotation(X, Y, X2, Y2)
	local rotation = 6.2831853071796 - mathAtan2(X2 - X, Y2 - Y) % 6.2831853071796;
	
	return -rotation;
end

function dxDrawBorder(x, y, w, h, size, color, postGUI)
	size = size or 2;
	
	dxDrawRectangle(x - size, y, size, h, color or tocolor(20, 20, 20, 180), postGUI);
	dxDrawRectangle(x + w, y, size, h, color or tocolor(20, 20, 20, 180), postGUI);
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color or tocolor(20, 20, 20, 180), postGUI);
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color or tocolor(20, 20, 20, 180), postGUI);
end

function getMinimapState()
	return Minimap.IsVisible;
end

function getBigmapState()
	return Bigmap.IsVisible;
end

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (Bigmap.PosX + (Bigmap.Width / 2)), (Bigmap.PosY + (Bigmap.Height / 2));
	local mapLeftFrame = centerX - ((playerX - worldX) / Bigmap.CurrentZoom * Minimap.MapUnit);
	local mapRightFrame = centerX + ((worldX - playerX) / Bigmap.CurrentZoom * Minimap.MapUnit);
	local mapTopFrame = centerY - ((worldY - playerY) / Bigmap.CurrentZoom * Minimap.MapUnit);
	local mapBottomFrame = centerY + ((playerY - worldY) / Bigmap.CurrentZoom * Minimap.MapUnit);
	
	centerX = mathMax(mapLeftFrame, mathMin(mapRightFrame, centerX));
	centerY = mathMax(mapTopFrame, mathMin(mapBottomFrame, centerY));
	
	return centerX, centerY;
end

function getWorldFromMapPosition(mapX, mapY)
	local worldX = playerX + ((mapX * ((Bigmap.Width * Bigmap.CurrentZoom) * 2)) - (Bigmap.Width * Bigmap.CurrentZoom));
	local worldY = playerY + ((mapY * ((Bigmap.Height * Bigmap.CurrentZoom) * 2)) - (Bigmap.Height * Bigmap.CurrentZoom)) * -1;
	
	return worldX, worldY;
end