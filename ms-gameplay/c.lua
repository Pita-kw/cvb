function weaponSyncClient (aw)
    player = aw
    for slot=1,12 do
        local weap = getPedWeapon(aw,slot)
        local ammo = getPedTotalAmmo(aw,slot)
        local clip = (getPedAmmoInClip(aw,slot) or 0)
        if (weap > 0 and ((ammo > 1 and slot == 8) or ammo > 0)) then
            triggerServerEvent("weaponSync", root, player, slot, weap, ammo, clip)
        end
    end
end
addEvent("onExitWeaponSync",true )
addEventHandler("onExitWeaponSync",localPlayer, weaponSyncClient)

local forceTime = false
function updateTime()
	if getElementData(localPlayer, "player:job") == "christmas" then return end 
	if forceTime then 
		setTime(forceTime.x, forceTime.y)
		return
	end 
	
	local h, m = getRealTime().hour, getRealTime().minute
	setTime(h, m)
end 
addEventHandler("onClientPreRender", root, updateTime)

function przebiegTest()
	local x,y,z = getElementPosition(localPlayer)
	local g_pos = getGroundPosition(x,y,z)
	local distance = getDistanceBetweenPoints3D(x,y,z,x,y,g_pos)
	
	if distance > 2 then 
		outputChatBox("Pojazdu nie ma przy ziemi")
	else
		outputChatBox("Pojazd jest przy ziemi")
	end
end
addCommandHandler("przebiegtest", przebiegTest)

addCommandHandler("dzien", function()
	forceTime = Vector2(12, 0)
	triggerEvent("onClientAddNotification", localPlayer, "Czas przestawiony na dzień. By przywrócić realny czas: /realtime", "info")
end)

addCommandHandler("noc", function()
	forceTime = Vector2(23, 0)
	triggerEvent("onClientAddNotification", localPlayer, "Czas przestawiony na noc. By przywrócić realny czas: /realtime", "info")
end)

addCommandHandler("realtime", function()
	forceTime = false 
	triggerEvent("onClientAddNotification", localPlayer, "Czas przestawiony na realny.", "info")
end)

function onClientCreateTrayNotification(text, type, sound)
	if createTrayNotification then 
		createTrayNotification (text, type, sound)
	end
end 
addEvent("onClientCreateTrayNotification", true)
addEventHandler("onClientCreateTrayNotification", root, onClientCreateTrayNotification)

function updateVehicleCollisions()
	for k,v in ipairs(getElementsByType("vehicle")) do 
		if getElementData(v, "vehicle:job") then 
			for _, nextVehicle in ipairs(getElementsByType("vehicle")) do 
				if getElementData(nextVehicle, "vehicle:job") then 
					if getElementData(v, "vehicle:job") == getElementData(nextVehicle, "vehicle:job") then 
						setElementCollidableWith(v, nextVehicle, false)
					end 
				end 
			end 
		end 
	end 
end 
setTimer(updateVehicleCollisions, 200, 0)
