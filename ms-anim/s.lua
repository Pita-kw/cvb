local mysql = exports["ms-database"]
local anims = {}
local pee_objects = {}
local dick_objects = {}

function loadAnimations()
	local query = mysql:getRows("SELECT * FROM `ms_anim`")
	for k,v in ipairs(query) do
		local cmdName = v["anim_command"]
		local animLib = v["anim_lib"]
		local animName = v["anim_name"]
		local loop = v["anim_opt1"] == 1
		local lockx, locky = v["anim_opt2"], v["anim_opt3"]
		local updatePos = false
		if lockx == 1 or locky == 1 then
			updatePos = true
		end

		local freeze = v["anim_opt4"]
		freeze = freeze == 1

		local time = v["anim_opt5"]
		if time == 0 then time = -1 end

		addCommandHandler(cmdName,
			function(player, cmd)
				if getElementData(player, "player:job") then return end 
				if getElementData(player, "player:paralyzed") then return end 
				if getElementData(player, "player:cuffs") then return end 
				if getElementData(player, "player:bw") and getElementData(player, "player:bw") > 0 then return end
				if getPedOccupiedVehicle(player) then triggerClientEvent(player, "onClientAddNotification", player, "Najpierw wyjdź z pojazdu.", "error") return end
				if getElementData(player, "player:arena") then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz używać animacji na arenach.", "error") return end
				if getPlayerTeam(player) then triggerClientEvent(player, "onClientAddNotification", player, "Nie możesz używać animacji podczas zabaw.", "error") return end 
				
				if getElementData(player, "player:pee") then
					destroyElement(pee_objects[player])
					destroyElement(dick_objects[player])
					triggerClientEvent(root, "stopPeeSound", player, player)
					setElementData(player, "player:pee", false)
				end
				
				if cmdName == "sikaj" then
					local x,y,z = getElementPosition(player)
					local x2, y2, z2 = getElementRotation(player)
					local int = getElementInterior(player)
					local dim = getElementDimension(player)
					setPedAnimation(player, animLib, animName, time, loop, updatePos, true, freeze)
					setElementData(player, "player:pee", true)
					pee_objects[player] = createObject(2052, x, y, z, x2, y2, z2)
					attachElements(pee_objects[player], player, 0.05, 0.30, -0.1)
					setElementInterior(pee_objects[player], int)
					setElementDimension(pee_objects[player], dim)
					dick_objects[player] = createObject(322, x, y, z)
					attachElements(dick_objects[player], player, 0.07, 0.15, 0.02, 0, 120, 90)
					setElementInterior(dick_objects[player], int)
					setElementDimension(dick_objects[player], dim)
					triggerClientEvent(root, "playPeeSound", player, player, x, y, z, dim, int)
				end
				setPedAnimation(player, animLib, animName, time, loop, updatePos, true, freeze)
				setElementData(player, "player:anim", true)
				triggerClientEvent(player, "onClientAddNotification", player, "By zatrzymać animację kliknij prawy przycisk myszy.", "info")
			end
		)

		table.insert(anims, cmdName)
	end
end
addEventHandler("onResourceStart", resourceRoot, loadAnimations)

function animInfo(player, cmd)
	local animString = ""
	local animCount = 0

	for k,v in ipairs(anims) do
		local anim = "/"..v
		animString = animString..""..anim.." "
		animCount = animCount + 1
		if animCount == 10 or animCount == 20 or animCount == 30 or animCount == 40 or animCount == 50 or animCount == 60 or animCount == 70 or animCount == 80 or animCount == 90 or animCount == 100 or k == #anims then
			outputConsole(animString, player)
			animCount = 0
			animString = ""
		end
	end

	triggerClientEvent(player, "onClientAddNotification", player, "Lista dostępnych animacji została wyświetlona w konsoli (klawisz F8 lub ~)", "info")
end
addCommandHandler("anims", animInfo)
addCommandHandler("anim", animInfo)
addCommandHandler("animacje", animInfo)

function resetAnimation(player, key, keyState)
	if keyState == "down" and getElementData(player, "player:anim") then
		setPedAnimation(player,"ped","facanger",-1,false,true,true,false)
		setElementData(player, "player:anim", false)
		if getElementData(player, "player:pee") then
			destroyElement(pee_objects[player])
			destroyElement(dick_objects[player])
			triggerClientEvent(root, "stopPeeSound", player, player)
			setElementData(player, "player:pee", false)
		end
	end
end
addEventHandler("onPlayerJoin", root, function() bindKey(source, "mouse2", "down", resetAnimation) end)
for k,v in ipairs(getElementsByType("player")) do
	bindKey(v, "mouse2", "down", resetAnimation)
end


addCommandHandler("sex1",function(plr,cmd)
    if (isPedInVehicle(plr)) then
        return
    end
	setElementData(plr, "player:anim", true)
   setPedAnimation ( plr, "sex", "sex_1_cum_p", -1, true, false )
end)

addCommandHandler("sex2",function(plr,cmd)
    if (isPedInVehicle(plr)) then
        return
    end
	setElementData(plr, "player:anim", true)
    setPedAnimation ( plr, "sex", "sex_1_cum_w", -1, true, false )
end)