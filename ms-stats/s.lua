--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: dodawania, zapis, wczyt statystyk
]]


local mysql = exports["ms-database"]

local playerStatData = {
	"player:kills",
	"player:deaths",
	"onede:kills",
	"sniper:kills",
	"bazooka:kills",
	"minigun:kills",
	"dust:kills",
	"player:did_jobs",
	"player:zombie_kills",
	"player:ctf_wins",
	"player:derby_wins",
	"player:race_wins",
	"player:hide_wins",
	"player:us_wins",
	"player:tdm_wins",
	"player:bk_wins",
	"player:wh_wins",
	"player:solo_wins",
	"player:hitman_cost",
	"job_points:air",
	"job_points:truck",
}


function addPlayerStat(player, name, amount)
	if isElement(player) and name and amount then
		for k,v in ipairs(playerStatData) do
			if tostring(name) == tostring(v) then
				local stat_amount = getElementData(player, name) or 0
				local stat_add = stat_amount + amount
				setElementData(player, name, stat_add)
				--outputChatBox("Aktualizacja daty ".. name .." u gracza ".. getPlayerName(player) .." Obecna ilość: ".. stat_add .."")
				checkPlayerToAchievement(player, name, stat_add)
			end
		end
	end
end
addEvent("addPlayerStats", true)
addEventHandler("addPlayerStats", getRootElement(), addPlayerStat)


function checkPlayerToAchievement(player, name, amount)
	if isElement(player) and name and amount then
		if name == "player:kills" then
			if amount == 1000 then
				exports["ms-achievements"]:addAchievement(player, "Zabójca III")
			elseif amount == 500 then
				exports["ms-achievements"]:addAchievement(player, "Zabójca II")
			elseif amount == 100 then
				exports["ms-achievements"]:addAchievement(player, "Zabójca I")
			end
		end
		
		if name == "player:deaths" then
			if amount == 100 then
				exports["ms-achievements"]:addAchievement(player, "Samobójca")
			end
		end
		
		if name == "onede:kills" and amount == 1000 then exports["ms-achievements"]:addAchievement(player, "Mistrz Onede") end
		if name == "sniper:kills" and amount == 1000 then exports["ms-achievements"]:addAchievement(player, "Mistrz Sniper") end
		if name == "bazooka:kills" and amount == 1000 then exports["ms-achievements"]:addAchievement(player, "Mistrz Bazooka") end
		if name == "minigun:kills" and amount == 1000 then exports["ms-achievements"]:addAchievement(player, "Mistrz Minigun") end
		if name == "dust:kills" and amount == 1000 then exports["ms-achievements"]:addAchievement(player, "Mistrz Dust") end
		
		if name == "player:did_jobs" then
			exports["ms-achievements"]:addAchievement(player, "Bez pracy nie ma kołaczy")
			if amount == 250 then
				exports["ms-achievements"]:addAchievement(player, "Pracoholik III")
			elseif amount == 100 then
				exports["ms-achievements"]:addAchievement(player, "Pracoholik II")
			elseif amount == 50 then
				exports["ms-achievements"]:addAchievement(player, "Pracoholik I")
			end
		end
		
		if name == "player:zombie_kills" then
			if math.floor(amount/10) == amount/10 then
				if getElementData(player, "player:premium") then
					triggerClientEvent(player, 'onClientAddNotification', player, 'Za zabite zombie otrzymujesz 8 exp oraz 650$', 'info')
					exports["ms-gameplay"]:msGiveMoney(player, 650)
					exports["ms-gameplay"]:msGiveExp(player, 8)
				else
					triggerClientEvent(player, 'onClientAddNotification', player, 'Za zabite zombie otrzymujesz 5 exp oraz 500$', 'info')
					exports["ms-gameplay"]:msGiveMoney(player, 500)
					exports["ms-gameplay"]:msGiveExp(player, 5)
				end
			end
			
			if amount == 500 then
				exports["ms-achievements"]:addAchievement(player, "Zombie Killer")
			end
		end
		
		
	end
end

function updatePlayerStat(player)
	if isElement(player) then
		if getElementData(player, "player:spawned") then
			local kills = getElementData(player, "player:kills") or 0
			local deaths = getElementData(player, "player:deaths") or 0
			local onede_kills = getElementData(player, "onede:kills") or 0
			local sniper_kills = getElementData(player, "sniper:kills") or 0
			local bazooka_kills = getElementData(player, "bazooka:kills") or 0
			local minigun_kills = getElementData(player, "minigun:kills") or 0
			local dust_kills = getElementData(player, "dust:kills") or 0
			local arens_data = toJSON({onede_kills, sniper_kills, bazooka_kills, minigun_kills, dust_kills})
			local did_jobs = getElementData(player, "player:did_jobs") or 0
			local zombie_kills = getElementData(player, "player:zombie_kills") or 0
			local weapons_skills = toJSON({})
			local ctf_wins = getElementData(player, "player:ctf_wins") or 0
			local derby_wins = getElementData(player, "player:derby_wins") or 0
			local race_wins = getElementData(player, "player:race_wins") or 0
			local hide_wins = getElementData(player, "player:hide_wins") or 0
			local us_wins = getElementData(player, "player:us_wins") or 0
			local tdm_wins = getElementData(player, "player:tdm_wins") or 0
			local bk_wins = getElementData(player, "player:bk_wins") or 0
			local wh_wins = getElementData(player, "player:wh_wins") or 0
			local solo_wins = getElementData(player, "player:solo_wins") or 0 
			local hitman_cost = getElementData(player, "player:hitman_cost") or 0
			local truck_points = getElementData(player, "job_points:truck") or 0
			local air_points = getElementData(player, "job_points:air") or 0
			local job_points_data = toJSON({truck_points, air_points}) 
			
			local events_stats = toJSON({ctf_wins, derby_wins, race_wins, hide_wins, us_wins, tdm_wins, bk_wins, wh_wins})
			
			mysql:query("UPDATE `ms_players` SET `kills`=?, `deaths`=?, `arens`=?, `did_jobs`=?, `zombie_kills`=?, `weapons_stats`=?, `events_stats`=?, `solo_wins`=?, `hitman`=?, `job_points`=? WHERE `accountid`=?", 
			kills, deaths, arens_data, did_jobs, zombie_kills, weapons_skills, events_stats, solo_wins, hitman_cost, job_points_data, getElementData(player, "player:uid"))
		end
	end
end

function updatePlayersStats()
	local players = getElementsByType("player")
	for k,v in ipairs(players) do
		if isElement(v) and getElementData(v, "player:spawned") then
			updatePlayerStat(v)
		end
	end
end

function loadPlayerStat(player)
	if isElement(player) then
		local player_uid = getElementData(player, "player:uid")
		local player_account = mysql:getRows("SELECT * FROM `ms_players` WHERE `accountid`=?", player_uid)
		
		if #player_account > 0 then
			local data = player_account[1]
			local arens = fromJSON(data["arens"])
			local weapons_skills = fromJSON(data["weapons_stats"]) or fromJSON('[ { "73": 0, "77": 0, "70": 0, "74": 0, "78": 0, "71": 0, "75": 0, "79": 0, "72": 0, "76": 0, "69": 0 } ]')
			local events = fromJSON(data["events_stats"])
			local job_points = fromJSON(data["job_points"])

			local temp = {} 
			for k, v in pairs(weapons_skills) do -- JSON coś pierdoli ???
				k = tonumber(k)
				v = tonumber(v)
				temp[k] = v
			end
			weapons_skills = temp 
			
			setElementData(player, "player:weapons_stats", weapons_skills)
			
			for k,v in pairs(weapons_skills) do
				setPedStat(player, k, v)
			end			
			
			setElementData(player, "player:kills", data["kills"])
			setElementData(player,"player:deaths", data["deaths"])
			setElementData(player,"onede:kills", arens[1])
			setElementData(player,"sniper:kills", arens[2])
			setElementData(player,"bazooka:kills", arens[3])
			setElementData(player,"minigun:kills", arens[4])
			setElementData(player, "dust:kills", arens[5])
			setElementData(player, "player:did_jobs", data["did_jobs"])
			setElementData(player, "player:zombie_kills", data["zombie_kills"])
			setElementData(player, "player:ctf_wins", events[1])
			setElementData(player, "player:derby_wins", events[2])
			setElementData(player, "player:race_wins", events[3])
			setElementData(player, "player:hide_wins", events[4])
			setElementData(player, "player:us_wins", events[5])
			setElementData(player, "player:tdm_wins", events[6])
			setElementData(player, "player:bk_wins", events[7])
			setElementData(player, "player:wh_wins", events[8])
			setElementData(player, "player:solo_wins", data["solo_wins"])
			setElementData(player, "player:hitman_cost", data["hitman"])
			setElementData(player, "job_points:truck", job_points[1])
			setElementData(player, "job_points:air", job_points[2])
		end
	end	
end


function onPlayerWasted(totalAmmo, killer)
	if killer then
		addPlayerStat(killer, "player:kills", 1)
		if getElementData(killer, "player:arena") then
			addPlayerStat(killer, "".. getElementData(killer, "player:arena") ..":kills", 1)
		end
	end
	
	if getElementData(source, "actual:challenge") then return end
	
	addPlayerStat(source, "player:deaths", 1)
end
addEventHandler("onPlayerWasted", root, onPlayerWasted)


function quitPlayer ()
	updatePlayerStat(source)
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )

function onStart()
	setTimer(function() 
		for k,v in ipairs(getElementsByType("player")) do 
			loadPlayerStat(v)
		end
	end, 1000, 1)
	
	setTimer ( updatePlayersStats, 60*10*1000, 0)
end 
addEventHandler("onResourceStart", resourceRoot, onStart)
addEventHandler("onResourceStop", resourceRoot, updatePlayersStats)
