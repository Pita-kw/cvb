function replaceModel()
	engineImportTXD(engineLoadTXD("dodo.txd"), 505)
	engineReplaceModel(engineLoadDFF("dodo.dff"), 505)
end 
addEventHandler("onClientResourceStart", resourceRoot, replaceModel)

function checkCheat()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then 
		setWorldSpecialPropertyEnabled("aircars",  getElementModel(vehicle) == 505)
		setWorldSpecialPropertyEnabled("hovercars",  getElementModel(vehicle) == 505)
	else 
		setWorldSpecialPropertyEnabled("aircars", false)
		setWorldSpecialPropertyEnabled("hovercars", false)
	end
end 
setTimer(checkCheat, 100, 0)

addEventHandler("onClientVehicleStartEnter",root,function(player,seat,door)
	if seat ~= 0 and getElementModel(source) == 505 then cancelEvent() end 
end)