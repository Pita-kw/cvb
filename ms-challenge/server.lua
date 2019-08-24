local wzw = {
  -- 1 pozycja chekpointu: pozycja startowa
	["BMX"] = {
		marker={2932.01, -775.25, 10.90}, 
		checkpoints={{2933.43, -779.48, 10.90, 0, 0, -90}, {3161.54, -773.78, 104.38}, {3295.40, -776.06, 161.47}, {3530.93, -766.89, 115.27}}, 
		passTime=500, 
		passReward=1000, 
		vehicleID=481, 
		map="maps/bmx.map"
	},
	["Parkour"] = {
		marker={281.09, 2025.18, 79.41}, 
		checkpoints={{269.82, 2036.46, 79.40, 0, 0, 85}, {100.66, 2034.04, 86.59}, {67.28, 1998.86, 138.18}, {92.06, 2004.03, 182.34}, {34.06, 2237.88, 187.59}}, 
		passTime=360, 
		passReward=1000, 
		vehicleID=false, 
		map="maps/parkour.map"
	},
	["Drag 2"] = {
		marker={3076.59,2115.14,2.47}, 
		checkpoints={{3105.96,2124.99,2.47, 0,0,269.32}, {3290.33,2124.69,2.47}, {3566.32,2124.82,2.47}, {3868.39,2124.48,2.47}, {4240.39,2124.83,2.47}, {4605.29,2125.56,2.46}}, 
		passTime=30, 
		passReward=500, 
		vehicleID=411, 
		map="maps/drag2.map"
	},
	["Jump City"] = {
		marker={-2237.20,-3155.06,27.17},
		checkpoints={{-2224.8515625, -3146.5771484375, 26.745330810547, 0, 0, 183.4285736084}, {-2225.88671875, -3205.8466796875, 27.442363739014, 0, 0, 180.08792114258}, {-2126.701171875, -3289.98828125, 32.156147003174, 0, 0, 258.9450378418}, {-2052.734375, -3364.8505859375, 27.310024261475, 0, 0, 176.48352050781}, {-2264.5205078125, -3382.89453125, 39.86926651001, 0, 0, 93.318664550781}, {-2278.4345703125, -3319.724609375, 67.448432922363, 0, 0, 0.4835205078125}, {-2304.0634765625, -3222.78125, 64.993911743164, 0, 0, 0.57144165039062}, {-2305.1237792969, -3152.0268554688, 63.370414733887, 0, 0, 82.395965576172}, {-2533.09375, -3149.5283203125, 72.775039672852, 0, 0, 87.252746582031}, {-2896.9140625, -3158.1767578125, 66.791366577148, 0, 0, 95.9560546875}},
		passTime=180,
		passReward=1000,
		vehicleID=522,
		map="maps/jump_city.map"
	},
	
	["Kart 2"] = {
		marker={-2086.951171875, -117.1201171875, 35.3203125, 0, 0, 91.668579101562},
		checkpoints={
			{-2092.13671875, -121.3681640625, 34.603866577148, 0, 0, 181.05494689941},
			{-2072.20703125, -201.798828125, 34.641036987305, 0, 0, 204.79121398926},
			{-2069.451171875, -243.6650390625, 34.604972839355, 0, 0, 175.42858886719},
			{-2092.2138671875, -269.33203125, 34.604335784912, 0, 0, 136.0439453125},
			{-2029.0673828125, -273.8359375, 34.611274719238, 0, 0, 271.78021240234},
			{-2050.4638671875, -238.076171875, 34.604496002197, 0, 0, 7.7802124023438},
			{-2057.693359375, -181.830078125, 34.641235351562, 0, 0, 280.83517456055},
			{-2038.6884765625, -237.6513671875, 34.61107635498, 0, 0, 191.16482543945},
			{-2020.05078125, -225.19140625, 34.604423522949, 0, 0, 347.56042480469},
			{-2041.3828125, -166.8896484375, 34.641262054443, 0, 0, 87.340667724609},
			{-2074.74609375, -151.119140625, 34.603408813477, 0, 0, 273.18682861328},
			{-2078.6376953125, -120.69921875, 34.603618621826, 0, 0, 84.703308105469},
		},
		passTime=60,
		passReward=500,
		vehicleID=571,
		map="maps/kart.map"
	},

	["Akina"] = {
		marker={-2934.84, 484.64, 4.91, 0,0,0},
		checkpoints={
			{-2945.21, 479.08, 4.94, 1.57,10.01,88.21},
			{-3102.95, 438.98, 16.92},
			{-3105.16, 560.90, 27.55},
			{-3074.69, 659.24, 40.30},
			{-3179.39, 871.52, 60.56},
			{-3197.67, 769.09, 87.51},
			{-3270.92, 607.22, 112.34},
			{-3330.22, 550.72, 144.03},
			{-3148.09, 453.84, 168.90},
			{-3074.25, 358.03, 198.59},
			{-3398.25, 491.63, 216.20},
			{-3329.82, 349.38, 237.11},
			{-3339.17, 229.99, 248.28},
			{-3536.05, 469.28, 266.13},
			{-3608.35, 549.90, 277.24},
			{-3580.51, 712.35, 284.21},
			{-3475.23, 687.96, 291.91},
			{-3425.75, 694.51, 309.29},
			{-3314.02, 869.01, 320.79},
			{-3305.73, 929.04, 322.27},
		},
		passTime=210,
		passReward=5000,
		vehicleID=522,
		map="maps/akina.map"	
	},
	
	["Wspinaczka"] = {
		marker={-1614.62,-7564.20,3.61, 0, 0, 0},
		checkpoints={
			{-1612.15, -7566.96, 1.68, 0, 0, 0},
			{-1614.79,-7578.51,15.14},
			{-1605.67,-7561.87,60.93},
			{-1610.82,-7560.82,127.69},
			{-1601.43,-7568.71,286.92},
		},
		passTime=240, 
		passReward=1000, 
		vehicleID=false,
		map="maps/wspinaczka.map",
	},
 }

local sql = exports["ms-database"]

local VEHICLES = {}
local challengeResults = {}

local temporaryResult = {} -- BRZYSIEK BRZYSIEK DWA BANANKI HOWDG XD

local query = sql:getRows("SELECT * FROM ms_challenges") or {}

for k, v in pairs(wzw) do
  local marker = createMarker(v.marker[1], v.marker[2], v.marker[3]-0.9, "cylinder", 1.2, 128, 255, 50, 255)
  setElementData(marker, "marker:challenge", k)

  local blip = createBlipAttachedTo(marker, 0)
  setElementData(blip, "blipIcon", "time")
  
  local text = createElement("3dtext")
  setElementPosition(text, v.marker[1], v.marker[2], v.marker[3])
  setElementData(text, "text", "Próba czasowa: #3366FF"..tostring(k))
 end

addEventHandler("onResourceStart", resourceRoot, function()
  if query then
   for key, value in ipairs(query) do
    for track, trackData in pairs(wzw) do
      if value.track == track then
        if not challengeResults[track] then
          challengeResults[track] = {}
        end
        temporaryResult[track] = {}
        table.insert(challengeResults[track], {value.playerName, value.time, value.uid})
      end
    end
  end
  end
end)

addEventHandler("onMarkerHit", resourceRoot, function(el, md)
  if not md then return end
  if getElementType(el) == "player" and not isPedInVehicle(el) then
    local data = getElementData(source, "marker:challenge")
    if data ~= nil then
      setElementData(el, "actual:challenge", data)
      triggerClientEvent(el, "onDatabaseRequest", resourceRoot, challengeResults[data], temporaryResult[data])
    end
  end
end)

addEvent("onChallengeStart", true)
addEventHandler("onChallengeStart", root, function(track)
  if wzw[track] then
	local objects = {} 
	if wzw[track].map then 
		local xml = xmlLoadFile(wzw[track].map)
	
		local i = 0
		local child = true 
		repeat 
			child = xmlFindChild(xml, "object", i)
			if child then 
				local model, x,y,z,rx,ry,rz = xmlNodeGetAttribute(child, "model"), xmlNodeGetAttribute(child, "posX"), xmlNodeGetAttribute(child, "posY"), xmlNodeGetAttribute(child, "posZ"), xmlNodeGetAttribute(child, "rotX"), xmlNodeGetAttribute(child, "rotY"), xmlNodeGetAttribute(child, "rotZ")
				table.insert(objects, {model, x, y, z, rx, ry, rz})
			end 
			i = i+1
		until child == false 
		
		xmlUnloadFile(xml)
	end 
	
	setElementFrozen(client, true)
	
	setElementData(client, "player:status", "Próba czasowa: "..tostring(track))
	setElementData(client, "block:player_teleport", true) 
	setElementData(client, "block:vehicle_spawn", true)

	fadeCamera(client, false)
	setTimer(setElementDimension, 1000, 1, client, getElementData(client, "player:id"))
	setTimer(triggerClientEvent, 1000, 1, client, "onTimeChallengeStart", resourceRoot, wzw[track].checkpoints, objects, wzw[track].passTime*1000)
	
	setTimer(function(client, track) 
		local rx, ry, rz = wzw[track].checkpoints[1][4], wzw[track].checkpoints[1][5], wzw[track].checkpoints[1][6]
		if wzw[track].vehicleID then 
			VEHICLES[client] = createVehicle(wzw[track].vehicleID, wzw[track].checkpoints[1][1], wzw[track].checkpoints[1][2], wzw[track].checkpoints[1][3]+0.2, rx or 0, ry or 0, rz or 180)
			addEventHandler("onVehicleStartExit", VEHICLES[client], function(player)
				if isElementFrozen(source) then 
					cancelEvent()
				end
			end)
			
			setElementFrozen(VEHICLES[client], true)
			setElementData(VEHICLES[client], "challenge:vehicle", true)
			setElementDimension(VEHICLES[client], getElementData(client, "player:id"))
			warpPedIntoVehicle(client, VEHICLES[client])
		else 
			setElementPosition(client, wzw[track].checkpoints[1][1], wzw[track].checkpoints[1][2], wzw[track].checkpoints[1][3]+0.2)
			setElementRotation(client,rx or 0, ry or 0, rz or 180)
			setElementData(client, "challenge:ped", true)
		end 	
		
		fadeCamera(client, true)
	end, 2000, 1, client, track)
	
    triggerClientEvent(client, "onClientAddNotification", client, "Rozpocząłeś próbę czasową na torze: "..tostring(track)..". Powodzenia!", "info")
  else
    triggerClientEvent(client, "onClientAddNotification", client, "Wystąpił błąd podczas przystąpienia do próby czasowej.", "error")
  end
end)

addEvent("onChallengeDoneRequest", true)
addEventHandler("onChallengeDoneRequest", resourceRoot, function(diff)
  if tonumber(diff) then
    local playername = getPlayerName(client)
	local uid = getElementData(client, "player:uid")
    local data = getElementData(client, "actual:challenge")
	
	triggerClientEvent(client, "onClientChallengeDone", client)
	setElementDimension(client, 0)
	
	local saved = false -- czy zapisano do bazy pobity istniejacy juz rekord
	local exists = false -- jesli gracz juz ma jakis rekord w bazie 
	
	local challenges = challengeResults[data] or {}
	for k,v in ipairs(challenges) do 
		if v[3] == uid then 
			exists = true 
			
			if diff < v[2] then 
				local model = -1 
				if VEHICLES[client] then 
					model = getElementModel(VEHICLES[client])
				end
				sql:query("UPDATE ms_challenges SET playerName=?, vehicle=?, time=? WHERE uid=? AND track=?", playername, model, diff, uid, data)
				challengeResults[data][k][1] = playername 
				challengeResults[data][k][2] = diff 
				challengeResults[data][k][3] = uid
				saved = true 
				break
			end
		end
	end 
	
	if not saved and not exists then 
		local model = -1 
		if VEHICLES[client] then 
			model = getElementModel(VEHICLES[client])
		end
		sql:query("INSERT INTO ms_challenges (playerName, uid, track, vehicle, time) VALUES (?, ?, ?, ?, ?)", playername, uid, data, model, diff)
		
		if not challengeResults[data] then
			challengeResults[data] = {}
		end 
		
		local money = wzw[data].passReward 
		local exp = math.floor(money / 100)
		exports["ms-gameplay"]:msGiveMoney(client, money)
		exports["ms-gameplay"]:msGiveExp(client, exp)
		triggerClientEvent(client, "onClientAddNotification", client, "Udało ci się zdążyć w wyznaczonym czasie! Otrzymujesz $"..tostring(money).." oraz "..tostring(exp).." EXP.", "info", 8000)
		table.insert(challengeResults[data], {playername, diff, uid}) 
	end 
	
	if not temporaryResult[data] then 
		temporaryResult[data] = {}
	end 
    table.insert(temporaryResult[data], 1, {playername, diff, uid})
	
	if VEHICLES[client] then
      destroyElement(VEHICLES[client])
      VEHICLES[client] = nil
      setElementData(client, "actual:challenge", false)
    else 
		setElementData(client, "challenge:ped", false)
	end

  end
end)


addEventHandler("onVehicleExit", resourceRoot, function(plr, seat)
  if seat == 0 then
	local cng = getElementData(plr, "actual:challenge")
    if cng ~= false then
      if VEHICLES[plr] then
        destroyElement(VEHICLES[plr])
        VEHICLES[plr] = false
        setElementData(plr, "actual:challenge", false)
        setElementDimension(plr, 0)
        triggerClientEvent(plr, "onClientChallengeDone", plr)
        triggerClientEvent(plr, "onClientAddNotification", plr, "Nie ukończyłeś próby czasowej.", "error")
		
		setElementPosition(plr, wzw[cng].checkpoints[1][1], wzw[cng].checkpoints[1][2], wzw[cng].checkpoints[1][3])
      end
    end
  end
end)

addEventHandler("onPlayerQuit", root, function()
  if VEHICLES[source] then
    destroyElement(VEHICLES[source])
    VEHICLES[source] = false
  end
end)

addEventHandler("onPlayerWasted", root, function()
    if getElementData(source, "actual:challenge") then 
		triggerClientEvent(source, "onClientChallengeDone", source)
		if VEHICLES[source] then
			destroyElement(VEHICLES[source])
			VEHICLES[source] = false
		end
	end
end)

addEvent("onChallengeFail", true)
addEventHandler("onChallengeFail", root, function() 
	local cng = getElementData(source, "actual:challenge") 
	if cng ~= false then 
		if VEHICLES[source] then 
			destroyElement(VEHICLES[source])
			VEHICLES[source] = false
		end 
		
		setElementData(source, "actual:challenge", false)
		setElementDimension(source, 0)
		triggerClientEvent(source, "onClientAddNotification", source, "Próba czasowa zakończona niepowodzeniem.", "error")
			
		setElementPosition(source, wzw[cng].checkpoints[1][1], wzw[cng].checkpoints[1][2], wzw[cng].checkpoints[1][3])
	end
end)


function showPosition(player, cmd)
	local x,y,z = getElementPosition(player)
	local rot_x, rot_y, rot_z = getElementRotation(player)
	outputChatBox("{".. x ..", ".. y ..", ".. z ..", ".. rot_x ..", ".. rot_y ..", ".. rot_z .."},")
end
addCommandHandler("cpos", showPosition)