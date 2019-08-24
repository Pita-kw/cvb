--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: tree_c.lua
	@desc: clientside code
]]

local tree_positions = {
{x = 1144.12, y = -2044.60, z = 69.00},
{x = 1144.20, y = -2050.99, z = 69.00},
{x = 1144.87, y = -2054.38, z = 69.00},
{x = 1148.19, y = -2057.32, z = 69.00},
{x = 1152.35, y = -2052.91, z = 69.00},
{x = 1156.36, y = -2051.33, z = 69.00},
{x = 1160.18, y = -2053.76, z = 69.01},
{x = 1161.82, y = -2058.97, z = 69.01},
{x = 1185.06, y = -2063.56, z = 69.00},
{x = 1186.48, y = -2060.17, z = 69.01},
{x = 1187.78, y = -2053.89, z = 69.01},
{x = 1189.64, y = -2051.10, z = 69.01},
{x = 1193.42, y = -2051.86, z = 69.01},
{x = 1194.67, y = -2054.87, z = 69.00},
{x = 1195.82, y = -2059.83, z = 69.00},
{x = 1198.86, y = -2062.91, z = 69.00},
{x = 1203.39, y = -2061.65, z = 69.00},
{x = 1204.66, y = -2058.21, z = 69.00},
{x = 1204.31, y = -2053.46, z = 69.00},
{x = 1203.77, y = -2050.28, z = 69.00},
{x = 1204.72, y = -2033.39, z = 69.01},
{x = 1205.84, y = -2028.77, z = 69.01},
{x = 1205.87, y = -2023.80, z = 69.01},
{x = 1205.59, y = -2017.70, z = 69.01},
{x = 1202.82, y = -2015.98, z = 69.01},
{x = 1202.27, y = -2020.95, z = 69.01},
{x = 1201.61, y = -2025.64, z = 69.01},
{x = 1198.16, y = -2028.36, z = 69.01},
{x = 1194.98, y = -2024.52, z = 69.01},
{x = 1194.04, y = -2019.91, z = 69.01},
{x = 1192.91, y = -2014.22, z = 69.01},
{x = 1190.96, y = -2010.94, z = 69.01},
{x = 1187.12, y = -2013.99, z = 69.01},
{x = 1186.81, y = -2019.90, z = 69.01},
{x = 1186.87, y = -2025.96, z = 69.01},
{x = 1165.41, y = -2030.91, z = 69.00},
{x = 1164.95, y = -2025.81, z = 69.00},
{x = 1164.48, y = -2021.42, z = 69.00},
{x = 1163.97, y = -2016.56, z = 69.00},
{x = 1162.90, y = -2011.46, z = 69.01},
{x = 1159.36, y = -2012.95, z = 69.01},
{x = 1158.90, y = -2018.11, z = 69.00},
{x = 1157.78, y = -2023.15, z = 69.00},
{x = 1157.08, y = -2028.21, z = 69.00},
{x = 1154.25, y = -2031.12, z = 69.00},
{x = 1151.10, y = -2027.66, z = 69.00},
{x = 1151.34, y = -2022.42, z = 69.00},
{x = 1151.30, y = -2017.29, z = 69.01},
{x = 1150.47, y = -2012.13, z = 69.01},
{x = 1147.46, y = -2010.43, z = 69.01},
{x = 1146.53, y = -2016.24, z = 69.01},
{x = 1145.49, y = -2023.20, z = 69.01},
{x = 1143.94, y = -2027.54, z = 69.01},
}

local tree_count = 0  -- ilość skoszonej trawy
local tree_cost = 60 -- wartość trawy
local exp_cost = 3 -- ilość skoszonej trawy aby otrzymać 1 exp
local dimension = 1001

local work_area=createColSphere(1174.9445800781,-2037.10, 69.141265869141, 55.0)
setElementDimension(work_area, dimension)

function removeVehicleCollisions()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local vehicles = getElementsWithinColShape ( work_area, "vehicle" )
	local index = 0
	
	if not vehicle then return end
		
	if getElementDimension(vehicle) ~= dimension then 
		return 
	end
	
	for k,v in ipairs(vehicles) do  
		setElementCollidableWith(v, vehicle, false)
		index = index + 1
	end
end
setTimer(removeVehicleCollisions, 5000, 0)



local tree_ped = createPed(309,1130.16,-2032.48,69.01,269.56, false)
addEventHandler('onClientPedDamage', tree_ped, cancelEvent)
setElementFrozen(tree_ped, true)

local tree_pickup = createPickup(1130.16+1,-2032.48,69.01-0.5, 3, 1274, 2, 255, 0, 0, 255, 0, 1337)

local tree_blip = createBlipAttachedTo(tree_pickup, 52)
setElementData(tree_blip, 'blipIcon', 'job')


addEventHandler('onClientPickupHit', tree_pickup, function(el, md)
	if not md or getElementType(el)~='player' or getPedOccupiedVehicle(el) then return end
	if el==localPlayer and md then
		if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job')~='job_tree' then 
			triggerEvent('onClientAddNotification', localPlayer, 'Posiadasz już aktywną prace!', 'error')
			return
		end
		
		if getElementData(localPlayer, 'player:job') == "job_tree" then
			if tree_count == 0 and not isElement(tree_vehicle) then 
				triggerEvent('onClientAddNotification', localPlayer, 'Praca została zakończona jednak nie otrzymujesz wynagrodzenia ponieważ nic nie skosiłeś!', 'info')
				endJob()
				return
			end
			if tree_count == 0 or false then 
				triggerEvent('onClientAddNotification', localPlayer, 'Jeszcze nic nie skosiłeś!', 'error')
				return
			else
				wyplata=tree_count*tree_cost
				wyplata_exp=tree_count/exp_cost
				if math.floor(wyplata_exp) > 0 then
					triggerServerEvent("giveTreeReward", localPlayer, localPlayer, wyplata_exp, 0)
				end
				triggerServerEvent("giveTreeReward", localPlayer, localPlayer, 0, wyplata)
				triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "player:did_jobs", 1)
				if getElementData(localPlayer, "player:premium") then
					triggerEvent('onClientAddNotification', localPlayer, "Praca zakończona!\nZarobiłeś ".. math.floor(wyplata + wyplata * 0.3) .."$ oraz ".. math.floor(wyplata_exp + wyplata_exp * 0.3) .." exp", 'success')
				else
					triggerEvent('onClientAddNotification', localPlayer, "Praca zakończona!\nZarobiłeś ".. math.floor(wyplata) .."$ oraz ".. math.floor(wyplata_exp) .." exp", 'success')
				end
				endJob()
				return
			end
		end
		GUIClass:setEnable(true)
	end
end)


function startTreeJob(tree_vehicles)
   tree_vehicle = tree_vehicles
	tree_count = 0
	generateTree()
	removeVehicleCollisions()
	triggerEvent('onClientAddNotification', localPlayer, 'Skoś wyznaczone krzaki na trawniku. Jeżeli będziesz chciał zakończyć pracę opuść pojazd.', 'info')
	showTreeHUD(true)
end
addEvent("startTreeJob", true)
addEventHandler("startTreeJob", localPlayer, startTreeJob)


function endJob()
	if isElement(objectTree) then destroyElement(objectTree) end
	if isElement(objectLight) then destroyElement(objectLight) end
	if isElement(objectMarker) then destroyElement(objectMarker) end
	if isElement(objectBlip) then destroyElement(objectBlip) end
	tree_count = 0
	setElementData(localPlayer, 'player:job', false)
	setElementDimension(localPlayer, 0)
	setElementData(localPlayer, "player:status", "W grze")
	triggerServerEvent("giveLevelWeapons", localPlayer, localPlayer)
	showTreeHUD(false)
end
addEvent("endWorkServer", true)
addEventHandler("endWorkServer", localPlayer, endJob)

function generateTree()
	if isElement(objectTree) then destroyElement(objectTree) end
	if isElement(objectLight) then destroyElement(objectLight) end
	if isElement(objectMarker) then destroyElement(objectMarker) end
	if isElement(objectBlip) then destroyElement(objectBlip) end
	local tree_id = math.random(1, #tree_positions)
	objectTree = createObject(804, tree_positions[tree_id].x, tree_positions[tree_id].y, tree_positions[tree_id].z-0.5)
	setObjectScale(objectTree, 0.5)
	objectLight = createMarker(tree_positions[tree_id].x, tree_positions[tree_id].y, tree_positions[tree_id].z+1, "arrow", 0.6, 255,0,0,255)
	objectMarker = createMarker(tree_positions[tree_id].x, tree_positions[tree_id].y, tree_positions[tree_id].z-1, "cylinder", 1, 255,0,0,0)
	objectBlip = createBlip(tree_positions[tree_id].x, tree_positions[tree_id].y, tree_positions[tree_id].z, 44)
	setElementData(objectBlip, 'blipIcon', 'mission_target')
	setElementData(objectBlip, 'blipSize', 10)
	addEventHandler('onClientMarkerHit', objectMarker, checkPlayer)
	setElementDimension(objectTree, dimension)
	setElementDimension(objectLight, dimension)
	setElementDimension(objectMarker, dimension)
	setElementDimension(objectBlip, dimension)
end


function checkPlayer(player, md)
	if player ~= localPlayer then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then return end
	if getElementData(vehicle, "vehicle:job") == "job_tree" then
		generateTree()
		tree_count = tree_count + 1
	end
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	showTreeHUD(false)
end)

function drawTreeHUD()
	local money = tree_count * tree_cost
	local exp = math.floor(tree_count/exp_cost)
	local tree = tree_count
	dxDrawRectangle (bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor ( 30, 30, 30, 140 ), true)
	dxDrawRectangle (bgPos.x, bgPos.y+100/zoom, bgPos.w, 5/zoom, tocolor ( 51, 102, 255, 255 ), true)
	dxDrawRectangle (bgPos.x, bgPos.y, 120/zoom, 100/zoom, tocolor ( 20, 20, 20, 50 ), true)
	dxDrawRectangle (bgPos.x+bgPos.w-120/zoom, bgPos.y, 120/zoom, 100/zoom, tocolor ( 20, 20, 20, 50 ), true)
	dxDrawText ("Exp", bgPlayers.x, bgPlayers.y, bgPlayers.x+bgPlayers.w, bgPlayers.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText ("Ilość", bgTree.x, bgTree.y, bgTree.x+bgTree.w, bgTree.y, tocolor ( 255, 255, 255, 255 ), 0.6, font, "center", "top", false,false, true )
	dxDrawText (exp, bgExpCount.x, bgExpCount.y, bgExpCount.x+bgExpCount.w, bgExpCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	dxDrawText (tree, bgTreeCount.x, bgTreeCount.y, bgTreeCount.x+bgTreeCount.w, bgTreeCount.y, tocolor ( 200, 200, 200, 255 ), 1, font, "center", "top", false,false, true )
	dxDrawText ("".. money .."$", bgMoney.x, bgMoney.y-10/zoom, bgMoney.x+bgMoney.w, bgMoney.y, tocolor (255, 255, 255, 255), 0.8, font, "center", "top", false,false, true )
	dxDrawText ("Zarobione pieniądze", bgMoney.x, bgMoney.y+25/zoom, bgMoney.x+bgMoney.w, bgMoney.y, tocolor ( 200, 200, 200, 220 ), 0.55, font, "center", "top", false,false, true )
end

function showTreeHUD(force)
	if force == true then
		bgX, bgY,bgW, bgH = exports["ms-hud"]:getInterfacePosition()
		zoom = exports["ms-hud"]:getInterfaceZoom()
		bgPos = {x=bgX, y=bgY+230/zoom, w=bgW, h=bgH-30/zoom}
		bgPlayers={x=bgPos.x-210/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgExpCount={x=bgPos.x-210/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		bgMoney={x=bgPos.x, y=bgPos.y+35/zoom, w=bgPos.w, h=bgPos.h}
		bgTree={x=bgPos.x+210/zoom, y=bgPos.y+60/zoom, w=bgPos.w, h=bgPos.h}
		bgTreeCount={x=bgPos.x+210/zoom, y=bgPos.y+10/zoom, w=bgPos.w, h=bgPos.h}
		
		tree_hud = exports["ms-blur"]:createBlurBox(bgPos.x, bgPos.y, bgPos.w, bgPos.h, 255, 255, 255, 255, false)
		font = dxCreateFont( ":ms-arens/f/archivo_narrow.ttf", 30/zoom)
		addEventHandler("onClientRender", getRootElement(), drawTreeHUD) 
	end

	if force == false then
		exports["ms-blur"]:destroyBlurBox(tree_hud)
		if isElement(font) then 
			destroyElement(font)
		end 
		
		removeEventHandler("onClientRender", getRootElement(), drawTreeHUD) 
		
		tree_hud = nil
	end
end


fileDelete("tree_c.luac")
