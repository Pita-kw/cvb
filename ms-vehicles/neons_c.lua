local neonDrawDistance = 100 
local neonSizeX, neonSizeY = 2, 2
local nearbyVehicles = {}
local neonLights = {}
local neonTexture = dxCreateTexture("i/neon.png", "dxt5")

function renderNeons()
	local cx, cy, cz = getCameraMatrix()
	
	for k, v in ipairs(nearbyVehicles) do
		if isElement(v) then 
			local x, y, z = getElementPosition(v)
			local rx, ry, rz = getElementRotation(v)
			local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
			
			local neonDisabled= getElementData(v, "vehicle:neonDisabled") or false
			if dist < neonDrawDistance and not neonDisabled then
				local neon = getElementData(v, "vehicle:neon") or {255, 255, 255, 255}
				local color = {neon[1], neon[2], neon[3], neon[4]}
				
				--local centreDist = getElementDistanceFromCentreOfMassToBaseOfModel(v)*0.8

				local hit, hitX, hitY, hitZ = processLineOfSight(x, y, z, x, y, z-1, true, false, false, true, true, false, false, false, v)
				if hit then
					centreDist = getDistanceBetweenPoints3D(x, y, z, hitX, hitY, hitZ)*0.9
					
					drawTransformedMaterial(neonTexture, x, y, z-centreDist, rx, ry, rz, neonSizeX, neonSizeY, color, 1, 0, 0, v)
					drawTransformedMaterial(neonTexture, x, y, z-centreDist, rx, ry, rz, neonSizeX, neonSizeY, color, -1, 0, 0, v)
					drawTransformedMaterial(neonTexture, x, y, z-centreDist, -ry, rx, rz-90, neonSizeX, neonSizeY, color, 2, 0, 0, v)
					drawTransformedMaterial(neonTexture, x, y, z-centreDist, -ry, rx, rz-90, neonSizeX, neonSizeY, color, -2, 0, 0, v)
				end
				
				if neonLights[v] then 
					for k, v in ipairs(neonLights[v]) do 
						destroyElement(v)
					end
				end 
				
				neonLights[v] = {}
				neonLights[v][1] = createLight(0, x, y, z, 1, color[1], color[2], color[3], 0, 0, 0, false)
				attachElements(neonLights[v][1], v, 0.1, 0, -0.5)
					
				neonLights[v][2] = createLight(0, x, y, z, 1, color[1], color[2], color[3], 0, 0, 0, false)
				attachElements(neonLights[v][2], v, -0.1, 0, -0.5)
					
				neonLights[v][3] = createLight(0, x, y, z, 1, color[1], color[2], color[3], 0, 0, 0, false)
				attachElements(neonLights[v][3], v, 0, 0.1, -0.5)
					
				neonLights[v][4] = createLight(0, x, y, z, 1, color[1], color[2], color[3], 0, 0, 0, false)
				attachElements(neonLights[v][4], v, 0, -0.1, -0.5)
					
				local int, dim = getElementInterior(v), getElementDimension(v)
				for _, light in ipairs(neonLights[v]) do 
					setElementInterior(light, int)
					setElementDimension(light, dim)
				end
			else 
				if neonLights[v] then 
					for k, v in ipairs(neonLights[v]) do 
						destroyElement(v)
					end
					neonLights[v] = nil
				end
			end
		end
	end
end 
addEventHandler("onClientPreRender", root, renderNeons)

local function getNearbyVehicles()
	nearbyVehicles = {} 
	
	local pint, pdim = getElementInterior(localPlayer), getElementDimension(localPlayer)
	local cx, cy, cz = getCameraMatrix()
	
	for k, v in ipairs(getElementsByType("vehicle")) do 
		local x, y, z = getElementPosition(v)
		local int, dim = getElementInterior(v), getElementDimension(v)
		local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
		if dist < neonDrawDistance*2 and int == pint and dim == pdim then 
			local neon = getElementData(v, "vehicle:neon") or false
			if neon then
				table.insert(nearbyVehicles, v)
			else 
				if neonLights[v] then 
					for k, v in ipairs(neonLights[v]) do 
						destroyElement(v)
					end
					neonLights[v] = nil
				end
			end
		end
	end
	
	for vehicle, lights in pairs(neonLights) do 
		if not isElement(vehicle) then 
			if #lights > 0 then
				for k, v in ipairs(lights) do
					destroyElement(v)
				end
				
				neonLights[vehicle] = nil
			end
		end
	end
end 
setTimer(getNearbyVehicles, 3000, 0)

local function isOnScreen(x, y, z, s)
	if not x or not y or not z then return end 
	
	local sx, sy = getScreenFromWorldPosition(x, y, z, s or 0.2) 
	
	return type(sx) == "number" and type(sy) == "number"
end 

function drawTransformedMaterial( texture, posX, posY, posZ, dirX, dirY, dirZ, sizeX, sizeY, color, offsetX, offsetY, offsetZ, vehicle)
	local mat = createElementMatrix({posX, posY, posZ}, {dirX, dirY, dirZ})
	posX, posY, posZ = getPositionFromMatrixOffset(mat, {offsetX, offsetY, offsetZ})
	if isOnScreen(posX, posY, posZ) then
		local elMat =  createElementMatrix({posX, posY, posZ}, {dirX, dirY, dirZ})
		
		local v1x,v1y,v1z = getPositionFromMatrixOffset(elMat, {0,-sizeY/2,0})
		local v2x,v2y,v2z = getPositionFromMatrixOffset(elMat, {0,sizeY/2,0})
		local vUx,vUy,vUz = getPositionFromMatrixOffset(elMat, {0,0,1})		
		dxDrawMaterialLine3D ( v1x,v1y,v1z,v2x,v2y,v2z, texture, sizeX, tocolor(color[1], color[2], color[3], color[4]), vUx,vUy,vUz)
	end
end

local mathRad = math.rad 
local mathCos = math.cos 
local mathSin = math.sin 
function createElementMatrix(pos, rot)
	local rx, ry, rz = mathRad(rot[1]), mathRad(rot[2]), mathRad(rot[3])
	return {{ mathCos(rz) * mathCos(ry) - mathSin(rz) * mathSin(rx) * mathSin(ry), 
			mathCos(ry) * mathSin(rz) + mathCos(rz) * mathSin(rx) * mathSin(ry), -mathCos(rx) * mathSin(ry), 0},
			{ -mathCos(rx) * mathSin(rz), mathCos(rz) * mathCos(rx), mathSin(rx), 0},
			{mathCos(rz) * mathSin(ry) + mathCos(ry) * mathSin(rz) * mathSin(rx), mathSin(rz) * mathSin(ry) - 
				mathCos(rz) * mathCos(ry) * mathSin(rx), mathCos(rx) * mathCos(ry), 0},
			{pos[1], pos[2], pos[3], 1 }}
end

function getPositionFromMatrixOffset(mat, pos)
	return (pos[1] * mat[1][1] + pos[2] * mat[2][1] + pos[3] * mat[3][1] + mat[4][1]), 
		(pos[1] * mat[1][2] + pos[2] * mat[2][2] + pos[3] * mat[3][2] + mat[4][2]),
		(pos[1] * mat[1][3] + pos[2] * mat[2][3] + pos[3] * mat[3][3] + mat[4][3])
end