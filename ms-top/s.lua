TOP_REFRESH_MINUTES = 60
TOP_MAX_VIEWABLE = 50 

topData = {} 

function resetTopData()
	topData = {
		["Wygrane w Uważaj, Spadasz!"] = {},
		["Wygrane w Berka"] = {},
		["Wygrane w Race"] = {},
		["Wygrane w Derby"] = {},
		["Wygrane w Wojnach Hunterów"] = {},
		["Wygrane w TDM"] = {},
		["Wygrane w CTF"] = {},
		["Fragi na Dust"] = {},
		["Fragi na Onede"] = {},
		["Fragi na Bazooka"] = {},
		["Fragi na Minigun"] = {},
		["Fragi na Sniper"] = {},
		["EXP"] = {},
		["Kasa"] = {},
		["Zabicia"] = {},
		["Śmierci"] = {},
		["Wykonanych prac"] = {},
		["Zabitych zombie"] = {},
		["Wygranych solo"] = {},
		["Przegrany czas"] = {},
		["Najlepszy drift"] = {},
		["Największy przebieg"] = {},
	} 
end 

function getTopData()
	resetTopData() 
	local query = exports["ms-database"]:getRows("SELECT * FROM ms_players")
	local accs = exports["ms-database"]:getRows("SELECT * FROM ms_accounts")
	local vehs = exports["ms-database"]:getRows("SELECT * FROM ms_vehicles")
	
	local function uidToName(uid)
		for k,v in ipairs(accs) do 
			if uid == v.id then 
				return v.login
			end
		end
		
		return "???"
	end 
	
	-- eventy 
	local us, br, rc, db, wh, td, ct, hd = {}, {}, {}, {}, {}, {}, {}, {}
	for k, v in ipairs(query) do 
		-- local events_stats = toJSON({ctf_wins, derby_wins, race_wins, hide_wins, us_wins, tdm_wins, bk_wins, wh_wins})
		local stats = fromJSON(v.events_stats)
		local playerName = v.playerName or uidToName(v.accountid)
		v.playerName = playerName 
		
		table.insert(ct, {name=playerName, uid=v.accountid, value=stats[1]})
		table.insert(db, {name=playerName, uid=v.accountid, value=stats[2]})
		table.insert(rc, {name=playerName, uid=v.accountid, value=stats[3]})
		table.insert(hd, {name=playerName, uid=v.accountid, value=stats[4]})
		table.insert(us, {name=playerName, uid=v.accountid, value=stats[5]})
		table.insert(td, {name=playerName, uid=v.accountid, value=stats[6]})
		table.insert(br, {name=playerName, uid=v.accountid, value=stats[7]})
		table.insert(wh, {name=playerName, uid=v.accountid, value=stats[8]})
	end

	topData["Wygrane w Uważaj, Spadasz!"] = us
	topData["Wygrane w Berka"] = br
	topData["Wygrane w Race"] = rc
	topData["Wygrane w Derby"] = db
	topData["Wygrane w Wojnach Hunterów"] = wh
	topData["Wygrane w TDM"] = td
	topData["Wygrane w CTF"] = ct
		
	-- areny 
	local du, on, ba, mi, sn = {}, {}, {}, {}, {}
	for k,v in ipairs(query) do 
		-- local arens_data = toJSON({onede_kills, sniper_kills, bazooka_kills, minigun_kills, dust_kills})
		local stats = fromJSON(v.arens)
		local playerName = v.playerName
		table.insert(on, {name=playerName, uid=v.accountid, value=stats[1]})
		table.insert(sn, {name=playerName, uid=v.accountid, value=stats[2]})
		table.insert(ba, {name=playerName, uid=v.accountid, value=stats[3]})
		table.insert(mi, {name=playerName, uid=v.accountid, value=stats[4]})
		table.insert(du, {name=playerName, uid=v.accountid, value=stats[5]})
	end 
	topData["Fragi na Dust"] = du
	topData["Fragi na Onede"] = on
	topData["Fragi na Bazooka"] = ba
	topData["Fragi na Minigun"] = mi
	topData["Fragi na Sniper"] = sn
	
	-- inne 
	-- zapisanie przebiegów do tablicy 
	local mileageOwners = {} -- [uid gracza] = przebieg
	for k, v in ipairs(vehs) do 
		if not mileageOwners[v.owner] then 
			mileageOwners[v.owner] = v.mileage 
		else 
			mileageOwners[v.owner] = mileageOwners[v.owner] + v.mileage
		end
	end 
	
	local exp, cash, kills, deaths, works, zombie, solo, playtime, statues, drift, mileage = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
	for k,v in ipairs(query) do 
		local playerName = v.playerName
		table.insert(exp, {name=playerName, uid=v.accountid, value=v.totalexp})
		table.insert(cash, {name=playerName, uid=v.accountid, value=v.money})
		table.insert(kills, {name=playerName, uid=v.accountid, value=v.kills})
		table.insert(deaths, {name=playerName, uid=v.accountid, value=v.deaths})
		table.insert(works, {name=playerName, uid=v.accountid, value=v.did_jobs})
		table.insert(zombie, {name=playerName, uid=v.accountid, value=v.zombie_kills})
		table.insert(solo, {name=playerName, uid=v.accountid, value=v.solo_wins})
		table.insert(playtime, {name=playerName, uid=v.accountid, value=v.playtime})
		table.insert(drift, {name=playerName, uid=v.accountid, value=v.bestDrift})
		table.insert(mileage, {name=playerName, uid=v.accountid, value=mileageOwners[v.accountid] or 0})
	end
	topData["EXP"] = exp
	topData["Kasa"] = cash
	topData["Zabicia"] = kills
	topData["Śmierci"] = deaths
	topData["Wykonanych prac"] = works
	topData["Zabitych zombie"] = zombie
	topData["Wygranych solo"] = solo
	topData["Przegrany czas"] = playtime
	topData["Najlepszy drift"] = drift
	topData["Największy przebieg"] = mileage 
	
	-- sortowanie
	for k, v in pairs(topData) do 
		if #v > 0 then
			-- jak coś się w bazie zjebało
			for index, value in pairs(v) do 
				topData[k][index].value = value.value or 0
			end
			
		
			table.sort(v, function(a, b) return a.value > b.value end)
		end
	end 
	
	for k,v in pairs(topData) do 
		for index, value in ipairs(v) do 
			if index > TOP_MAX_VIEWABLE or value.value == 0 then 
				topData[k][index] = nil
			end
		end
	end
	
	setElementData(resourceRoot, "top:last_refresh", getRealTime().timestamp)
end
addEventHandler("onResourceStart", resourceRoot, getTopData) 
setTimer(getTopData, 60000*TOP_REFRESH_MINUTES, 0)

function onPlayerRequestTopData()
	triggerClientEvent(client, "onClientGetTopData", client, topData)
end 
addEvent("onPlayerRequestTopData", true)
addEventHandler("onPlayerRequestTopData", root, onPlayerRequestTopData)