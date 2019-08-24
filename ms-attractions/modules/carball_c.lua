Carball = {} 

function Carball.load()
	Carball.team = getTeamFromName("Carball")
	Carball.cmd = "cb"
	
	addEvent("onClientLoadCarball", true)
	addEvent("onClientStartCarball", true)
	addEvent("onClientSyncCarball", true)
	addEvent("onClientGetGoalCarball", true)
	
	addEventHandler("onClientLoadCarball", root, Carball.preStart)
	addEventHandler("onClientStartCarball", root, Carball.start)
	addEventHandler("onClientSyncCarball", root, Carball.syncBall)
	addEventHandler("onClientGetGoalCarball", root, Carball.onGoal)
	
	Carball.balls = {}
	Carball.objects = {} 
	
	Carball.throws = {}
	Carball.throwTimer = {}
	
	Carball.endTick = 0
	Carball.countdown = 5
	
	Carball.wasOnGround = false
	Carball.ball = false
	Carball.ballTick = 0
end 

function Carball.stop()

end 

function Carball.preStart(time)
	Carball.endTick = getTickCount()+time 
	
	local txd = engineLoadTXD("modules/files/balltexture1.txd")
	engineImportTXD(txd, 2912)
	
	local dff = engineLoadDFF("modules/files/balltexture.dff")
	engineReplaceModel(dff, 2912)
	-- sciany kolizyjne 
	engineReplaceModel(dff, 10871)
	
	local col = engineLoadDFF("modules/files/ballcollision.dff")
	engineReplaceModel(col, 457)
	
	local txd = engineLoadTXD("maps/carball-sandy/sandy.txd")
	engineImportTXD(txd, 2802)
	
	local dff = engineLoadDFF("maps/carball-sandy/sandy.dff")
	engineReplaceModel(dff, 2802)
	
	local col = engineLoadCOL("maps/carball-sandy/sandy.col")
	engineReplaceCOL(col, 2802)
	
	engineSetModelLODDistance(2912, 300)
	engineSetModelLODDistance(2802, 300)
	
	Carball.createObject(2802,-3500.0000000,-1000.0000000,500.0000000,0.0000000,0.0000000,0.0000000) -- mamy jedną mapkę na carball
	Carball.createObject(2802,-3599.3000000,-1323.30000,500.0000000,0.0000000,0.0000000,180.0000000) -- mamy jedną mapkę na carball
	
	-- bariery
	for i=1, 6 do
		Carball.createObject(10871, -3695.41 - (-16)*(i-1) ,-1284.80 - (-60)*(i-1),580.00, 0, 0, 15, 140)
	end 
	
	for i=1, 6 do
		Carball.createObject(10871, -3485.41 - (-16)*(i-1) ,-1340.80 - (-60)*(i-1),580.00, 0, 0, 180+15, 140)
	end 
	
	for i=1, 3 do
		Carball.createObject(10871, -3695.41+(60)*i ,-1315.80-(16)*(i),580.00, 0, 0, 90+15, 140)
	end 
	
	for i=1, 3 do
		Carball.createObject(10871, -3615.41+(60)*i ,-950.80-(16)*(i),580.00, 0, 0, -90+15, 140)
	end 
	
	addEventHandler("onClientRender", root, Carball.renderBalls)
	
	triggerEvent("onClientAddNotification", localPlayer, "Pod przyciskiem Lewy ALT możesz skakać pojazdem.", "info", 10000)
end 

function Carball.start()
	Carball.countdown = 5 
	
	playSoundFrontEnd(43)
	addEventHandler("onClientRender", root, Carball.renderCountdown)
		
	setTimer(function()
		Carball.countdown = Carball.countdown-1 
		if Carball.countdown == 0 then 
			setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
			bindKey("lalt", "down", Carball.jumpVehicle)
				
			playSoundFrontEnd(45)
			setTimer(function()
				addEventHandler("onClientHUDRender", root, Carball.renderHUD)
				removeEventHandler("onClientRender", root, Carball.renderCountdown)
			end, 1000, 1)
		else 
			playSoundFrontEnd(43)
		end
	end, 1000, Carball.countdown)
	
	--addEventHandler("onClientElementDataChange", root, Carball.changeBallState)
	addEventHandler("onClientVehicleDamage", root, Carball.cancelVehicleDamage)
	addEventHandler("onClientVehicleCollision", root, Carball.hitBall)
end 

function Carball.finish()
	for k, v in ipairs(Carball.objects) do 
		destroyElement(v)
	end
	Carball.objects = {}

	for k, v in ipairs(Carball.balls) do 
		local obj = setElementData(v, "carball:ball_object")
		if isElement(obj) then 
			destroyElement(obj)
		end
	end 
	Carball.balls = {}
	
	unbindKey("lalt", "down", Carball.jumpVehicle)
	
	--removeEventHandler("onClientElementDataChange", root, Carball.changeBallState)
	removeEventHandler("onClientHUDRender", root, Carball.renderHUD)
	removeEventHandler("onClientVehicleDamage", root, Carball.cancelVehicleDamage)
	removeEventHandler("onClientVehicleCollision", root, Carball.hitBall)
	removeEventHandler("onClientRender", root, Carball.renderBalls)
	
	engineRestoreModel(2912)
	engineRestoreModel(10871)
	engineRestoreModel(2802)
	engineRestoreModel(457)
	
	Carball.throws = {}
	Carball.throwTimer = {}
end 
 
function Carball.cancelVehicleDamage()
	cancelEvent()
end 

function Carball.jumpVehicle()
	if Carball.jumpTimer then 
		triggerEvent("onClientAddNotification", localPlayer, "Możesz skakać raz na 3 sekundy.", "warning")
		return
	end 
	
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then 
		local x, y, z = getElementVelocity(veh)
		z = z+0.4
		triggerServerEvent("onCarballVehicleJump", veh, x, y, z)
		
		Carball.jumpTimer = setTimer(function() Carball.jumpTimer = nil end, 3000, 1)
	end
end 

function Carball.createObject(model, x, y, z, rx, ry, rz, alpha)
	local obj = createObject(model, x, y, z, rx, ry, rz)
	setElementDimension(obj, 69)
	setElementAlpha(obj, alpha or 255)
	
	local shader = false
	if model == 2802 then 
		shader = dxCreateShader("modules/files/terrain.fx", 0, 0, false, "object")
	end 
	
	local obj2 = createObject(model, x, y, z, rx, ry, rz, true)
	setElementDimension(obj2, 69)
	setLowLODElement(obj, obj2)
	setElementAlpha(obj2, alpha or 255)
	
	table.insert(Carball.objects, obj)
	table.insert(Carball.objects, obj2)
	if shader then 
		engineApplyShaderToWorldTexture(shader, "*", obj)
		engineApplyShaderToWorldTexture(shader, "*", obj2)
		table.insert(Carball.objects, shader)
	end 
	
	engineSetModelLODDistance(model, 300)
end 

function Carball.renderBalls()
	for ball, _ in pairs(Carball.throws) do 
		local hitX, hitY, hitZ = getElementPosition(ball)
		for i = 1, 5, 1 do
			fxAddPunchImpact(hitX, hitY, hitZ, 0, 0, 0)
			fxAddSparks(hitX, hitY, hitZ, 0, 0, 0, 1, 15, 0, 0, 0, true, 3, 10)
		end
	end
	
	if #Carball.balls == 0 then 
		for k, v in ipairs(getElementsByType("vehicle", resourceRoot)) do 
			if getElementData(v, "carball:ball") then 
				local x, y, z = getElementPosition(v)
				local obj = createObject(2912, x, y, z)
				setElementDimension(obj, 69)
				setElementData(v, "carball:ball_object", obj, false)
				table.insert(Carball.balls, v)
			end
		end
	else 
		for k, v in ipairs(Carball.balls) do 
			local obj = getElementData(v, "carball:ball_object")
			if obj then 
				local x, y, z = getElementPosition(v)
				local rx, ry, rz = getElementRotation(v)
				setElementPosition(obj, x, y, z)
				setElementRotation(obj, rx, ry, rz)
			end
		end
	end
end 

function Carball.changeBallState(dataName, oldValue)
	if dataName == "ball:onGround" and oldValue == false then 
		if getElementData(source, "syncer") == localPlayer then
			local x, y, z = getElementPosition(source)
			--triggerServerEvent("onPlayerSyncCarball", localPlayer, source, x, y, z)
		end
	end
end 

function Carball.onGoal()
	local snd = playSound("modules/files/goal.mp3", false)
	setSoundVolume(snd, 0.7)
end 

local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=(screenW/2)-500/zoom/2, y=47/zoom, w=500/zoom, h=100/zoom}
local bgPosLine = {x=bgPos.x, y=bgPos.h+43/zoom, w=bgPos.w, h=4/zoom} 

function Carball.renderCountdown()
	local text = tostring(Carball.countdown)
	if text == "0" then 
		text = "START!"
	end
	
	dxDrawText(text, (screenW/2)-1, (screenH/3)-1, (screenW/2)-1, (screenH/3)-1, tocolor(0, 0, 0, 255), 3.0, "default-bold", "center", "top", false, true, true)
	dxDrawText(text, screenW/2, screenH/3, screenW/2, screenH/3, tocolor(236, 240, 241, 255), 3.0, "default-bold", "center", "top", false, true, true)
end

function Carball.renderHUD()
	local time = (Carball.endTick-getTickCount())/1000
	if time < 0 then 
		Carball.finish()
		return
	end 
		
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPos.x+bgPos.w-90/zoom, bgPos.y, 90/zoom, bgPos.h, tocolor(30, 30, 30, 80), true)
	dxDrawRectangle(bgPosLine.x, bgPosLine.y, bgPosLine.w, bgPosLine.h, tocolor(51, 102, 255, 255), true)
		
	dxDrawText("Strzel bramkę drużynie "..(getElementData(localPlayer, "player:carball_team") == "red" and "niebieskiej" or "czerwonej")..".", bgPos.x, bgPos.y + 25/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.7, Core.font, "center", "top", false, true, true)
		
	local m = getRealTime(time).minute
	local s = getRealTime(time).second 
		
	dxDrawText(string.format("%.2d:%.2d", m, s), bgPos.x, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.55, Core.font, "center", "top", false, true, true)
		
	dxDrawText(tostring(getElementData(resourceRoot, "carball:points_red") or 0), bgPos.x, bgPos.y + 20/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(231, 76, 60, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("Czerwoni", bgPos.x, bgPos.y + 55/zoom, (90/zoom)+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
		
	dxDrawText(tostring(getElementData(resourceRoot, "carball:points_blue") or 0),bgPos.x+bgPos.w-90/zoom, bgPos.y + 20/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(51, 102, 255, 230), 1, Core.font, "center", "top", false, true, true)
	dxDrawText("Niebiescy", bgPos.x+bgPos.w-90/zoom, bgPos.y + 55/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(200, 200, 200, 200), 0.5, Core.font, "center", "top", false, true, true)
end 

function Carball.addBigThrow(ball)
	if Carball.throws[ball] ~= nil then
		killTimer(Carball.throwTimer[ball])
	end
	setElementData(ball, "carball:throw", true, false)
	Carball.throws[ball] = true
	Carball.throwTimer[ball] = setTimer(function(ball)
		Carball.throws[ball] = nil 
		setElementData(ball, "carball:throw", false, false)
	end, 1000, 1, ball)
end

function Carball.hitBall(hitElement, force)
	if isPedInVehicle(localPlayer) then
		setVehicleDamageProof(getPedOccupiedVehicle(localPlayer), true)
	end
	
	if hitElement and getElementDimension(hitElement) == getElementDimension(localPlayer) then
		if getElementData(hitElement, "carball:ball") then		
			if Carball.hitTimer then return end 
			
			force = math.min(force*3, 750)
			
			local x, y, z = getElementPosition(hitElement)
			if force > 100 then
				local s = playSound3D("modules/files/hit.wav", x, y, z, false)
				setElementDimension(s, getElementDimension(hitElement))
				setSoundMaxDistance(s, 100)
				setSoundVolume(s, 0.8)
			end 
			
			x, y, z = getElementVelocity(hitElement)
			if getElementData(hitElement, "carball:throw") == true then
				local x2, y2, z2 = getElementPosition(hitElement)
				createExplosion(x2, y2, z2, 7)
			end
	
			if force > 400 then
				Carball.addBigThrow(hitElement)
			end
			
			if force > 100 then
				force = 100
			end
			
			local veh = getPedOccupiedVehicle(localPlayer) 
			local nx, ny, nz = x*(force*0.016), y*(force*0.016), z+((force/250)*1.01)
			if source == veh then
				x, y, z = getElementPosition(hitElement)
				triggerServerEvent("onPlayerHitCarball", localPlayer, hitElement, x, y, z, nx, ny, nz)
				
				Carball.hitTimer = setTimer(function() Carball.ballTick = 0 Carball.hitTimer = nil end, 250, 1)
				
				setElementCollidableWith(veh, hitElement, false)
				setTimer(setElementCollidableWith, 200, 1, veh, hitElement, true)
			end
		end
	end
end 

function Carball.syncBall(ball, x, y, z, vx, vy, vz)
	setElementPosition(ball, x, y, z)
	setElementVelocity(ball, vx, vy, vz)
end 
