vehicle = nil

function changeVehicleColor(vehicle)
	if vehicle then
		setVehicleColor(vehicle, math.random(1,255),math.random(1,255),math.random(1,255),math.random(1,255),math.random(1,255),math.random(1,255))
		setVehicleHeadLightColor(vehicle, math.random(1,255), math.random(1,255), math.random(1,255))
	end
end

function vehicleRainbow(player, cmd)
	vehicle = getPedOccupiedVehicle(player)
	
	if isTimer(vehicle_timer) then
		killTimer(vehicle_timer)
		return
	end
	
	if vehicle then
		vehicle_timer = setTimer(changeVehicleColor, 1000, 0, vehicle)
	else
		outputChatBox("Musisz być w pojeździe!")
	end
end
addCommandHandler("vr", vehicleRainbow)

function pozdrawiam(player, cmd)
	if getElementData(player, "player:rank") < 3 then return end 
	triggerClientEvent(root, "onClientAddNotification", root, "Devan zostaje zbanowany przez Virelox do 1/12/2137 za cheaty", {type="error", custom="image", x=0, y=0, w=64, h=64, image=":ms-test/oski.jpg"}, 15000)
end 
addCommandHandler("pozdrawiam", pozdrawiam)

