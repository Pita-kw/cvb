local tags = {} 
local tagSizeX, tagSizeY = 2, 2
local tagDrawDistance = 100 
local tagTex = dxCreateTexture("i/spray_tag.png", "dxt5")
local screenW, screenH = guiGetScreenSize()

local function isOnScreen(x, y, z, s)
	if not x or not y or not z then return end 
	
	local sx, sy = getScreenFromWorldPosition(x, y, z, s or 0.2) 
	
	return type(sx) == "number" and type(sy) == "number"
end 

function loadTags(data)
	tags = data
	for k, v in ipairs(tags) do 
		v.material = CMaterialMat:create(tagTex, v.x, v.y, v.z+0.5, -90, 0, v.rot-180, tagSizeX, tagSizeY)
		v.colshape = createColSphere(v.x, v.y, v.z, 2)
		v.requested = false -- czy gracz poprosil o obrazek bo nie ma
		v.texture = false
		v.state = 0
	end
end 
addEvent("onClientLoadTags", true)
addEventHandler("onClientLoadTags", root, loadTags)

function updateTag(id, data)
	tags[id] = data 
	tags[id].material = CMaterialMat:create(tagTex, data.x, data.y, data.z+0.5, -90, 0, data.rot-180, tagSizeX, tagSizeY)
	tags[id].colshape = createColSphere(data.x, data.y, data.z, 2)
	tags[id].requested = false 
	if isElement(tags[id].texture) then 
		destroyElement(tags[id].texture)
		tags[id].texture = false
	end
	tags[id].state = 0 
end
addEvent("onClientUpdateTag", true)
addEventHandler("onClientUpdateTag", root, updateTag)

function updateTagLogo(data)
	for k, id in ipairs(data) do
		tags[id].requested = false 
		if isElement(tags[id].texture) then 
			destroyElement(tags[id].texture)
			tags[id].texture = false
		end
	end
end 
addEvent("onClientUpdateTagLogo", true)
addEventHandler("onClientUpdateTagLogo", root, updateTagLogo)

local lastTickBlock = getTickCount()

local lastGangsUpdate = getTickCount()
local gangsOnlineData = {} 

function drawTags()
	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then return end 
	local now = getTickCount()
	if now > lastGangsUpdate then
		gangsOnlineData = {} 
		for k, v in ipairs(getElementsByType("player")) do 
			local gang = getElementData(v, "player:gang")
			if gang then 
				gangsOnlineData[gang.id] = true
			end
		end 
		
		lastGangsUpdate = lastGangsUpdate+30000
	end 
	
	local cx, cy, cz = getCameraMatrix() 
	local px, py, pz = getElementPosition(localPlayer)
	local _, _, prot = getElementRotation(localPlayer)
	
	local gang = getElementData(localPlayer, "player:gang")
	
	for k, v in ipairs(tags) do 
		local dist = getDistanceBetweenPoints3D(cx, cy, cz, v.x, v.y, v.z)
		if not v.blip and dist < 300 then 
			if gang then
				v.blip = createBlipAttachedTo(v.colshape, 52)
				setElementData(v.blip, 'blipIcon', 'spray')
				setElementData(v.blip, 'blipSize', 15)
			end
		else 
			if dist > 300 then 
				if isElement(v.blip) then destroyElement(v.blip) v.blip = nil end
			end
		end 
		
		if dist < tagDrawDistance then
			if isOnScreen(v.x, v.y, v.z) then
				if v.owner ~= -1 then
					if not GANG_LOGO_CACHE[v.owner] then
						if not v.requested then 
							triggerServerEvent("onPlayerRequestGangLogo", localPlayer, v.owner)
							v.requested = true
						end
					else
						if not v.texture then
							v.texture = dxCreateTexture(GANG_LOGO_CACHE[v.owner], "argb")
							v.material:setTexture(v.texture)
							if not v.texture then 
								v.material:setTexture(tagTex)
							end
						end
					end
				end 
				
				v.material:draw()
				
				-- chcemy rysować
				if isElementWithinColShape(localPlayer, v.colshape) and getPedWeapon(localPlayer) == 41 and getControlState("fire") and getDistanceBetweenPoints3D(px, py, pz, v.x, v.y, v.z) > 0.4 and isOnScreen(v.x, v.y, v.z, 0) then 
					if v.owner ~= gang.id then
						if v.state < 100 then 
							
							if now > lastTickBlock then 
								if v.state == 0 then 
									if v.owner ~= -1 and not gangsOnlineData[v.owner] then 
										lastTickBlock = now+20000
										triggerEvent("onClientAddNotification", localPlayer, "Nikt z tego gangu nie jest aktualnie aktywny, nie możesz przejąć tej strefy.", "info")
										return
									end 
									
									triggerEvent("onClientAddNotification", localPlayer, "Rozpoczęto przejmowanie terenu. Nie wychodź poza strefę ani nie wchodź w strefę Anty DM!", "info")
									triggerServerEvent("onPlayerStartSprayingTag", localPlayer, k)
								end 
								
								lastTickBlock = now+20
								v.state = v.state+0.1
							end
							
							local x, y = screenW/2, screenH/1.25
							local w, h = screenW/4, screenH*0.025
							x, y = x-w/2, y-h/2
							exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(230, 230, 230, 255))
							dxDrawRectangle(x, y, w * (v.state/100), h, tocolor(gang.color[1], gang.color[2], gang.color[3], 180), true)
						else 
							v.owner = gang.id
							triggerServerEvent("onPlayerChangeTag", localPlayer, k, gang.id)
						end
					end
				end
			end
		else 
			if v.texture then 
				destroyElement(v.texture)
				v.texture = false
			end
		end
	end
	
end 
addEventHandler("onClientPreRender", root, drawTags)

CMaterialMat = { };
CMaterialMat.__index = CMaterialMat;
     
function CMaterialMat: create( texture, posX, posY, posZ, dirX, dirY, dirZ, sizeX, sizeY)
	local mat = createElementMatrix({posX, posY, posZ}, {dirX, dirY, dirZ})
	posX, posY, posZ = getPositionFromMatrixOffset(mat, {0, 0, -0.2})
	
	local cMatMat = {
		tex = texture,
		pos = {posX, posY, posZ}, 
		rot = {dirX, dirY, dirZ},
		elMat =  createElementMatrix({posX, posY, posZ}, {dirX, dirY, dirZ}),
		size = {sizeX, sizeY},
		color = tocolor(255, 255, 255, 255),
					}
		self.__index = self
		setmetatable( cMatMat, self )
		return cMatMat
end

function CMaterialMat:setColor(r, g, b, a)
	if self.tex then 
		self.color = tocolor(r, g, b, a)
	end
end 

function CMaterialMat:setTexture(tex)
	self.tex = tex 
end

function CMaterialMat: draw()
	if self.tex then
		local elMat = self.elMat
		local v1x,v1y,v1z = getPositionFromMatrixOffset(elMat, {0,-self.size[2]/2,0})
		local v2x,v2y,v2z = getPositionFromMatrixOffset(elMat, {0,self.size[2]/2,0})
		local vUx,vUy,vUz = getPositionFromMatrixOffset(elMat, {0,0,1})		
		dxDrawMaterialLine3D ( v1x,v1y,v1z,v2x,v2y,v2z, self.tex, self.size[1], self.color, 
			vUx,vUy,vUz  )
	end
end

function createElementMatrix(pos, rot)
	local rx, ry, rz = math.rad(rot[1]), math.rad(rot[2]), math.rad(rot[3])
	return {{ math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry), 
			math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry), -math.cos(rx) * math.sin(ry), 0},
			{ -math.cos(rx) * math.sin(rz), math.cos(rz) * math.cos(rx), math.sin(rx), 0},
			{math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx), math.sin(rz) * math.sin(ry) - 
				math.cos(rz) * math.cos(ry) * math.sin(rx), math.cos(rx) * math.cos(ry), 0},
			{pos[1], pos[2], pos[3], 1 }}
end

function getPositionFromMatrixOffset(mat, pos)
	return (pos[1] * mat[1][1] + pos[2] * mat[2][1] + pos[3] * mat[3][1] + mat[4][1]), 
		(pos[1] * mat[1][2] + pos[2] * mat[2][2] + pos[3] * mat[3][2] + mat[4][2]),
		(pos[1] * mat[1][3] + pos[2] * mat[2][3] + pos[3] * mat[3][3] + mat[4][3])
end
