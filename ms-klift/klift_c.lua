--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: klift_c.lua
	@desc: praca "widlarza" ?
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

addEvent("startJobKlift2", true)

local klift_ped = createPed(309, 2775.38,-2469.76,13.64, 87.88)
setElementFrozen(klift_ped, true)
addEventHandler('onClientPedDamage', klift_ped, cancelEvent)
local klift_pickup = createPickup(2775.38-0.7,-2469.76,13.64-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
local klift_blip = createBlipAttachedTo(klift_pickup, 52)
setElementData(klift_blip, 'blipIcon', 'job')

local jobDataKlift={}
jobDataKlift.isWorking=false
jobDataKlift.iloscZamowien=false
jobDataKlift.wyplata = 85
jobDataKlift.vehicle = false
jobDataKlift.boxesPos={
	{x = 2776.41, y = -2478.23, z = 13.64},
	{x = 2776.78, y = -2476.70, z = 13.64},
	{x = 2777.19, y = -2474.91, z = 13.64},
	{x = 2777.55, y = -2473.35, z = 13.64},
	{x = 2778.03, y = -2471.83, z = 13.64},
}
boxes = {}

local dimension = 1003
local money = 600
local exp = 6

-- ROZPOCZYNAMY PRACE
function startJobKlift2Handler(klift_vehicle)
	jobDataKlift.vehicle = klift_vehicle
	jobDataKlift.isWorking = true
	jobDataKlift.iloscZamowien = 5
	setElementData(localPlayer, 'player:job', 'job_klift')
	source_marker = createMarker( 2795.26,-2456.00,13.63-1, "cylinder", 3.0, 255,0,0, 255)
	setElementDimension(source_marker, dimension)
	addEventHandler ("onClientMarkerHit", source_marker, callToCheck)
	createBoxes()
	triggerEvent('onClientAddNotification', localPlayer, 'Za tobą znajdują się skrzynie.\nZawieź je do magazynu obok.', 'info')
	setElementData(localPlayer, "player:status", "Praca: Widlak")
end
addEventHandler("startJobKlift2", localPlayer, startJobKlift2Handler)


-- TWORZYMY SKRZYNKI
function createBoxes()
    for i = 1,5 do
        local object = createObject(1558,  jobDataKlift.boxesPos[i].x,jobDataKlift.boxesPos[i].y,jobDataKlift.boxesPos[i].z)
		setElementDimension(object, dimension)
		setElementCollidableWith(object, jobDataKlift.vehicle, true)
		setObjectBreakable(object, false)
        table.insert(boxes, object)
    end
end

 -- USUWAMY WSZYSTKIE SKRZYNKI JEŻELI PRACA ZOSTAŁA ZAKOŃCZONA Z POWODU OPUSZCZENIA POJAZDU
 function deleteBoxes()
 		for k,object in pairs(boxes) do
			destroyElement(object)
		 end
		 boxes = {}
 end



 -- SPRAWDZAMY CZY GRACZ MA SKRZYNKE
function checkBoxes()
    for k,object in pairs(boxes) do
        if isElementWithinMarker(object, source_marker) then
            jobDataKlift.iloscZamowien  = jobDataKlift.iloscZamowien - 1
			if jobDataKlift.iloscZamowien == 0 then endWork(1) end
            destroyElement(object)
			table.remove(boxes, k)
			if jobDataKlift.iloscZamowien >0 then triggerEvent('onClientAddNotification', localPlayer, 'Dowiozłeś skrzynię\nPozostało ci jeszcze '.. jobDataKlift.iloscZamowien .. ' skrzynek', 'info') end
        end
    end
end

function callToCheck ( hitPlayer, matchingDimension )
	checkBoxes()
end


function endWork(end_type)
	if end_type == 1 then -- PO DOWIEZIENIU ZAMÓWIEŃ
		if isTimer(vehicle_timer) then killTimer(vehicle_timer) end
		if isElement(source_marker) then destroyElement(source_marker) end
		triggerServerEvent("removeKliftVehicle", localPlayer)
		triggerEvent('onClientAddNotification', localPlayer, 'Świetnie się spisałeś, wróć teraz do bota i odbierz swoją wypłatę', 'info')
		setElementDimension(localPlayer, 0)
	end

	if end_type == 2 then -- PO ODEBRANIU WYPŁATY
		jobDataKlift.isWorking=false
		setElementData(localPlayer, 'player:job', nil)
		jobDataKlift.iloscZamowien = false
		setElementDimension(localPlayer, 0)
		setElementData(localPlayer, "player:status", "W grze")
	end

	if end_type == 3 then -- PO ANULOWANIU PRACY
		if isTimer(vehicle_timer) then killTimer(vehicle_timer) end
		jobDataKlift.iloscZamowien = false
		if isElement(source_marker) then destroyElement(source_marker) end
		jobDataKlift.isWorking=false
		setElementData(localPlayer, 'player:job', nil)
		triggerServerEvent("removeKliftVehicle", localPlayer)
		setElementDimension(localPlayer, 0)
		deleteBoxes()
		triggerServerEvent("giveLevelWeapons", localPlayer, localPlayer)
		setElementData(localPlayer, "player:status", "W grze")
	end
end

-- USUWAMY POJAZD JEŻELI GRACZ DŁUGO POZA NIM PRZEBYWAŁ
function removeWorkVehicle()
		triggerEvent('onClientAddNotification', localPlayer, 'Praca została zakończona\nZ powodu długiego przebywania poza pojazdem!', 'error')
		endWork(3)
end

-- USUWAMY TIMER JEŻELI GRACZ WEJDZIE DO POJAZDU
addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
		if source == jobDataKlift.vehicle  then
			if isTimer(vehicle_timer) then
				killTimer(vehicle_timer)
			end
		end
    end
)

 -- URUCHAMIAMY TIMER JEŻELI GRACZ WYJDZIE Z POJAZDU
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
		if source == jobDataKlift.vehicle then
				vehicle_timer=setTimer(removeWorkVehicle, 10000, 1)
		end
    end
)


-- PICKUP PRZY BOCIE I RÓŻNE INTERAKCJE
addEventHandler('onClientPickupHit', klift_pickup, function(el, md)
	if not md or getElementType(el)~='player' or getPedOccupiedVehicle(el) then return end
	if el==localPlayer and md then
		if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job')~='job_klift' then
			triggerEvent('onClientAddNotification', localPlayer, 'Posiadasz już aktywną prace!', 'error')
			return
		end
		if jobDataKlift.iloscZamowien==0 then
			if getElementData(localPlayer, "player:premium") then 
				triggerEvent('onClientAddNotification', localPlayer, 'Praca zakończona - otrzymujesz '.. money + money * 0.3 .. '$ oraz '.. math.floor(exp + exp * 0.3) ..' exp', 'success')
			else
				triggerEvent('onClientAddNotification', localPlayer, 'Praca zakończona - otrzymujesz '.. money .. '$ oraz '.. exp ..' exp', 'success')
			end
			triggerServerEvent("giveKliftReward", localPlayer, localPlayer, exp, money)
			triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "player:did_jobs", 1)
			endWork(2)
		else
			if jobDataKlift.iloscZamowien and jobDataKlift.iloscZamowien>0 then
				triggerEvent('onClientAddNotification', localPlayer, 'Najpierw zawieź obecny towar', 'error')
				return
			end
			GUIClass:setEnable(true)
		end
	end
end)



addEventHandler ( "onClientPlayerWasted", getLocalPlayer(),
	function()
		if getElementData(source, 'player:job') == 'job_klift' then
			endWork(3)
		end
	end
)



addEventHandler( "onClientResourceStart", getRootElement( ),
    function()
		if getElementData(source, 'player:job') == 'job_klift' then
			endWork(3)
		end
	end
);

fileDelete("klift_c.lua")
