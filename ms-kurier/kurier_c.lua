--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: kurier_c.lua
	@desc: praca kuriera
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

addEvent('startJobKurier2', true)
addEvent('playBoomboxMusic', true)

local kurier_ped = createPed(309,  -63.46,-1128.88,1.08, 73.57)
setElementFrozen(kurier_ped, true)
local kurier_pickup = createPickup(-64.07,-1128.72,1.08-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
local kurier_blip = createBlipAttachedTo(kurier_pickup, 52)
setElementData(kurier_blip, 'blipIcon', 'job')

local jobDataKurier={}
jobDataKurier.isWorking=false
jobDataKurier.iloscZamowien=false
jobDataKurier.wyplata = {100,150}
jobDataKurier.vehicle = false
jobDataKurier.blip = false
jobDataKurier.zlecenieMarker = false
jobDataKurier.vehicleMarker = false
jobDataKurier.wearsBox = false
jobDataKurier.points={
	{x = 2007.03, y = -1282.50, z = 23.97},
	{x = 1808.14, y = -1435.38, z = 13.43},
	{x = 1774.65, y = -1704.70, z = 13.52},
	{x = 1321.26, y = -1652.14, z = 13.55},
	{x = 1124.07, y = -1333.15, z = 12.89},
	{x = 831.19, y = -1202.83, z = 16.98},
	{x = 1048.04, y = -1549.66, z = 13.55},
	{x = 1163.66, y = -1202.31, z = 19.82},
	{x = 1359.13, y = -1635.63, z = 13.49},
	{x = 1442.89, y = -1468.43, z = 13.44},
}

local money = 1200
local exp = 12
local dimension = 1004

addEventHandler('onClientPedDamage', kurier_ped, cancelEvent)


addEventHandler('onClientPickupHit', kurier_pickup, function(el, md)
	if not md or getElementType(el)~='player' or getPedOccupiedVehicle(el) then return end
	if el==localPlayer and md then
		if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job')~='job_kurier' then
			triggerEvent('onClientAddNotification', localPlayer, 'Posiadasz już aktywną prace!', 'error') 
			return
		end
		if jobDataKurier.iloscZamowien==0 then
			if getElementData(localPlayer, 'player:premium') then
				triggerEvent('onClientAddNotification', localPlayer, 'Praca zakończona - otrzymujesz '.. money + money * 0.3 ..'$ oraz '.. math.floor(exp + exp * 0.3) ..' exp', 'success')
			else
				triggerEvent('onClientAddNotification', localPlayer, 'Praca zakończona - otrzymujesz '.. money ..'$ oraz '.. exp ..' exp', 'success')
			end
			triggerServerEvent("giveKurierReward", localPlayer, localPlayer, exp, money)
			triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "player:did_jobs", 1)
			triggerServerEvent("removeKurierVehicle", localPlayer)
			triggerServerEvent("giveLevelWeapons", localPlayer, localPlayer)
			endKurierJob(2)
		else
			if jobDataKurier.iloscZamowien and jobDataKurier.iloscZamowien>0 then
				triggerEvent('onClientAddNotification', localPlayer, 'Najpierw zawieź obecny towar', 'error')
				return
			end
			GUIClass:setEnable(true)
		end
	end
end)


function blockPlayerSprint()
	if getControlState("walk") == false then
		setControlState("walk", true)
	end
	
	toggleControl("sprint", false)
	toggleControl("jump", false) 
	toggleControl("crouch", false)
	toggleControl("fire", false) 
	toggleControl("walk", false) 
end

function startJob2Handler(kurier_vehicle)
	jobDataKurier.vehicle = kurier_vehicle
	jobDataKurier.isWorking = true
	jobDataKurier.iloscZamowien = 1
	setElementData(localPlayer, 'player:job', 'job_kurier')
	generateOrderPos()
	triggerEvent('onClientAddNotification', localPlayer, 'Zawieź przesyłkę do punktu zaznaczonego na mapie.', 'info')
	setElementData(localPlayer, "player:status", "Praca: Kurier")
end
addEventHandler("startJobKurier2", localPlayer, startJob2Handler)


addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
		if source == jobDataKurier.vehicle and seat == 0 then
			if isElement(jobDataKurier.vehicleMarker) then destroyElement(jobDataKurier.vehicleMarker) end
			if isTimer(vehicle_timer) then killTimer(vehicle_timer) end
			jobDataKurier.wearsBox = false
			triggerServerEvent("removeKurierObjects", localPlayer)
		end
    end
)
 
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
		if source == jobDataKurier.vehicle and jobDataKurier.iloscZamowien > 0 and seat == 0 then
			local x,y,z = getElementPosition(source)
			jobDataKurier.vehicleMarker = createMarker(x,y,z, "cylinder", 1.0,  255,0,0, 255)
			setElementDimension(jobDataKurier.vehicleMarker, dimension)
			attachElements(jobDataKurier.vehicleMarker, jobDataKurier.vehicle, 0,-6,-1)
			addEventHandler("onClientMarkerHit", jobDataKurier.vehicleMarker, takeBoxFromCar)
		end
		
		if source == jobDataKurier.vehicle and seat == 0 then
			vehicle_timer=setTimer(removeWorkVehicle, 120000, 1)
		end
    end
)

function takeBoxFromCar(player, dim)
	if player ~= localPlayer then return end 
	
	if jobDataKurier.wearsBox == true then
		triggerServerEvent("removeKurierObjects", localPlayer)
		 jobDataKurier.wearsBox = false
		 if isTimer(block_timer) then killTimer(block_timer) end
	else
		triggerServerEvent("attachKurierObjects", localPlayer)
		jobDataKurier.wearsBox = true
		block_timer = setTimer(blockPlayerSprint, 100, 0)
	end
end

function generateOrderPos()
	losowe_zlecenie = math.random(1, 10)
	jobDataKurier.zlecenieMarker = createMarker(jobDataKurier.points[losowe_zlecenie].x,jobDataKurier.points[losowe_zlecenie].y,jobDataKurier.points[losowe_zlecenie].z, "checkpoint", 2.0,  255,0,0, 255)
	setElementDimension(jobDataKurier.zlecenieMarker, dimension)
	addEventHandler("onClientMarkerHit", jobDataKurier.zlecenieMarker, putBoxFromCar)
	jobDataKurier.blip=createBlip(jobDataKurier.points[losowe_zlecenie].x, jobDataKurier.points[losowe_zlecenie].y, jobDataKurier.points[losowe_zlecenie].z, 41)
	setElementData(jobDataKurier.blip, 'blipIcon', 'mission_target')
	setElementData(jobDataKurier.blip, 'exclusiveBlip', true)
	setElementDimension(jobDataKurier.blip, dimension)
end


function putBoxFromCar(hit, mat)
	if hit == localPlayer then
		if jobDataKurier.wearsBox == false then 
			triggerEvent('onClientAddNotification', localPlayer, 'Najpierw weź paczkę z pojazdu', 'error')
		else
			triggerEvent('onClientAddNotification', localPlayer, 'Dowiozłeś zamówienie! Wróć do bazy aby odebrać wypłatę', 'success')
			triggerServerEvent("removeKurierObjects", localPlayer)
			endKurierJob(1)
			jobDataKurier.blip=createBlip(-63.46,-1128.88,1.08, 41)
			setElementData(jobDataKurier.blip, 'blipIcon', 'mission_target')
			setElementData(jobDataKurier.blip, 'exclusiveBlip', true)
			setElementDimension(jobDataKurier.blip, dimension)
		end
	end
end


function removeWorkVehicle()
		triggerServerEvent("removeKurierVehicle", localPlayer)
		triggerServerEvent("removeKurierObjects", localPlayer)
		triggerEvent('onClientAddNotification', localPlayer, 'Praca została zakończona\nZ powodu długiego przebywania poza pojazdem!', 'error')
		endKurierJob(3)
end


function endKurierJob(end_type)
	if end_type == 1 then
		if isElement(jobDataKurier.vehicleMarker) then destroyElement(jobDataKurier.vehicleMarker) end
		if isElement(jobDataKurier.zlecenieMarker) then destroyElement(jobDataKurier.zlecenieMarker) end
		if isElement(jobDataKurier.blip) then destroyElement(jobDataKurier.blip) end
		jobDataKurier.iloscZamowien=0
		jobDataKurier.wearsBox = false
		if isTimer(block_timer) then killTimer(block_timer) end
		setElementDimension(kurier_ped, dimension)
		setElementDimension(kurier_pickup, dimension)
	end
	
	if end_type == 2 then
		if isTimer(vehicle_timer) then killTimer(vehicle_timer) end
		setElementData(localPlayer, 'player:job', nil)
		if isElement(jobDataKurier.vehicle) then destroyElement(jobDataKurier.vehicle) end
		jobDataKurier.iloscZamowien = false
		jobDataKurier.isWorking=false
		jobDataKurier.wearsBox = false
		if isElement(jobDataKurier.blip) then destroyElement(jobDataKurier.blip) end
		if isTimer(block_timer) then killTimer(block_timer) end
		setElementDimension(localPlayer, 0)
		setElementDimension(kurier_ped, 0)
		setElementDimension(kurier_pickup, 0)
		setElementData(localPlayer, "player:status", "W grze")
	end
	
	if end_type == 3 then
		if isElement(jobDataKurier.vehicleMarker) then destroyElement(jobDataKurier.vehicleMarker) end
		if isElement(jobDataKurier.zlecenieMarker) then destroyElement(jobDataKurier.zlecenieMarker) end
		if isElement(jobDataKurier.blip) then destroyElement(jobDataKurier.blip) end
		jobDataKurier.iloscZamowien=0
		if isTimer(vehicle_timer) then killTimer(vehicle_timer) end
		setElementData(localPlayer, 'player:job', nil)
		if isElement(jobDataKurier.vehicle) then destroyElement(jobDataKurier.vehicle) end
		jobDataKurier.iloscZamowien = false
		jobDataKurier.wearsBox = false
		if isElement(jobDataKurier.blip) then destroyElement(jobDataKurier.blip) end
		if isTimer(block_timer) then killTimer(block_timer) end
		setElementDimension(localPlayer, 0)
		triggerServerEvent("giveLevelWeapons", localPlayer, localPlayer)
		setElementData(localPlayer, "player:status", "W grze")
	end
end

-- ZAKAŃCZAMY PRACĘ 
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), 
	function()
		if getElementData(source, 'player:job') == 'job_kurier' then
			endKurierJob(3)
		end
	end
)

fileDelete("kurier_c.lua")

