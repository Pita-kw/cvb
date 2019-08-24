--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: kurier_s.lua
	@desc: praca kuriera
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

addEvent("startJobKurier", true)
addEvent("attachKurierObjects", true)
addEvent("removeKurierObjects", true)
addEvent("removeKurierVehicle", true)

local dimension = 1004

skrzynka={}
kurier_vehicle={}
boombox={}

function giveWorkReward(player, exp, money)
	exports["ms-gameplay"]:msGiveMoney(player, money)
	exports["ms-gameplay"]:msGiveExp(player, exp)
end
addEvent("giveKurierReward", true)
addEventHandler("giveKurierReward", getRootElement(), giveWorkReward)

function startJobHandler(gracz)
	takeAllWeapons(gracz)
	kurier_vehicle[gracz] = createVehicle(456, -64.14,-1110.63,1.08, 0, 0, 68.60)
	setElementDimension(gracz, dimension)
	setElementDimension(kurier_vehicle[gracz], dimension)
	setElementData(kurier_vehicle[gracz], 'vehicle:mileage', math.random(1000, 10000))
	setElementData(kurier_vehicle[gracz], 'vehicle:fuel', 35)
	setElementData(kurier_vehicle[gracz], "vehicle:job", "job_kurier")
	warpPedIntoVehicle(gracz, kurier_vehicle[gracz])
	triggerClientEvent('startJobKurier2', gracz, kurier_vehicle[gracz])
end
addEventHandler("startJobKurier", getRootElement(), startJobHandler)


function attachKurierObjects()
	local x,y,z = getElementPosition(source)
	skrzynka[source] = createObject(2912, x,y,z)
	setElementDimension(skrzynka[source], dimension)
	pudelko = exports.bone_attach:attachElementToBone(skrzynka[source],source,11,-0.15,0.00,0.10,-92.00,-5.00,5.00)
	setPedAnimation(source,"CARRY","crry_prtial",0,true,true,false,true)
	toggleControl(source,"sprint", false) 
	toggleControl(source,"jump", false) 
	toggleControl(source,"crouch", false)
	toggleControl(source,"fire", false) 
	toggleControl(source,"walk", false) 
	setControlState(source,"walk", true)
	setObjectScale(skrzynka[source], 0.6)
end
addEventHandler("attachKurierObjects", getRootElement(), attachKurierObjects)


function removeKurierObjects()
	if isElement(skrzynka[source]) then destroyElement(skrzynka[source]) end
	setPedAnimation(source,"ped","facanger",-1,false,true,true,false)
	toggleControl(source,"sprint", true) 
	toggleControl(source,"jump", true) 
	toggleControl(source,"crouch", true)
	toggleControl(source,"fire", true) 
	toggleControl(source,"walk", true) 
	setControlState(source,"walk", false)
end
addEventHandler("removeKurierObjects", getRootElement(), removeKurierObjects)

function removeWorkVehicle()
	destroyElement(kurier_vehicle[source])
end
addEventHandler("removeKurierVehicle", getRootElement(), removeWorkVehicle)


function quitPlayer ( quitType )
	if isElement(kurier_vehicle[source]) then
		destroyElement(kurier_vehicle[source])
	end
	
	if isElement(skrzynka[source]) then 
		destroyElement(skrzynka[source]) 
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )


