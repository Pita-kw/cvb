local mysql = exports["ms-database"]
gangData = {} 
local gangLogosCache = {} 

function loadGangs()
	gangData = {} 
	
	local result = mysql:getRows("SELECT * FROM ms_gangs")
	table.sort(result, function(a, b) return a.name < b.name end)
	
	gangData = result
	for k,v in ipairs(gangData) do 
		v.membersNames = {}
		for _, member in ipairs(fromJSON(v.members)) do 
			local result = mysql:getRows("SELECT login FROM ms_accounts WHERE id=?", member.uid)
			local login = "nil" 
			if result and result[1] then 
				login = result[1].login
			end 
			
			table.insert(v.membersNames, login)
		end
		
		v.leadersNames = {} 
		for _, leader in ipairs(fromJSON(v.leaders)) do 
			local result = mysql:getRows("SELECT login FROM ms_accounts WHERE id=?", leader)
			local login = "nil" 
			if result and result[1] then 
				login = result[1].login
			end 
			
			table.insert(v.leadersNames, login)
		end
		
		v.owner = fromJSON(v.owner)
		fetchRemote(v.logo, 1, downloadGangLogo, "", false, nil, v.id, v.logo)
	end
	
	for k, v in ipairs(getElementsByType("player")) do 
		loadPlayerGang(v)
	end
	
	setTimer(saveGangs, 60000*15, 0)
end
addEventHandler("onResourceStart", resourceRoot, loadGangs)

function saveGangs()
	for k, v in ipairs(gangData) do
		mysql:query("UPDATE ms_gangs SET name=?, leaders=?, members=?, ann=?, website=?, tag=?, color=?, exp=?, totalexp=?, level=?, kills=?, deaths=?, won_wars=?, lost_wars=?, ranks=?, logo=? WHERE id=?", v.name, v.leaders, v.members, v.ann,
		v.website, v.tag, v.color, v.exp, v.totalexp, v.level, v.kills, v.deaths, v.won_wars, v.lost_wars, v.ranks, v.logo, v.id)
	end
end 
addEventHandler("onResourceStop", resourceRoot, saveGangs)

function createDefaultGang(name, owner, ownerName)
	if name and owner then
		mysql:query("INSERT INTO ms_gangs(id, name, owner, createDate, leaders, members, ann, website, tag, color, exp, kills, deaths, won_wars, lost_wars, ranks, logo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
							nil, name, toJSON({uid=owner, name=ownerName}), nil, toJSON({owner}), toJSON({{uid=owner, rank=0}}), "Mój super gang", "brak", "--", toJSON({52, 152, 219, 255}), 0, 0, 0, 0, 0, toJSON({}), "http://i.imgur.com/9hLdRov.png")
		loadGangs()
		return true
	end
	return false
end
 
function loadPlayerGang(plr)
	local uid = getElementData(plr, "player:uid")
	
	for k, v in ipairs(gangData) do 
		local members = fromJSON(v.members) 
		for _, player in ipairs(members) do 
			if player.uid == uid then 
				local isLeader = false 
				for _, leader in ipairs(fromJSON(v.leaders)) do 
					if leader == uid then 
						isLeader = true
						break
					end
				end 
				
				local rankName = fromJSON(v.ranks)[player.rank] or "brak rangi"
				setElementData(plr, "player:gang", {id=v.id, name=v.name, rank=rankName, color=fromJSON(v.color), tag=v.tag, leader=isLeader})
				return
			end
		end
	end
	
	setElementData(plr, "player:gang", false)
end 

function getGangIndexFromID(id)
	for k,v in ipairs(gangData) do 
		if v.id == id then 
			return k
		end
	end
	
	return k
end 

function downloadGangLogo(responseData, errno, client, gangID, url)
	if errno == 0 then 
		gangLogosCache[url] = responseData
		if client then 
			triggerClientEvent(client, "onClientReceiveGangLogo", client, gangID, responseData)
		end
	end
end 

local gangRequests = {}
function acceptGangRequest(player)
	if gangRequests[player] then
		local isInGang = getElementData(player, "player:gang") 
		if isInGang then 
			triggerClientEvent(player, "onClientAddNotification", player, "Jesteś już w jakimś gangu!", "error")
			return
		end 
		
		local gangIndex = getGangIndexFromID(gangRequests[player].id)
		local gang = gangData[gangIndex]
		local members = fromJSON(gang.members)
		local membersNames = gang.membersNames
		table.insert(members, {uid=getElementData(player, "player:uid"), rank=0})
		table.insert(membersNames, getPlayerName(player))
		
		gangData[gangIndex].members = toJSON(members) 
		gangData[gangIndex].membersNames = membersNames
		
		triggerClientEvent(player, "onClientAddNotification", player, "Przyjąłeś zaproszenie do gangu "..gang.name..".", "success", 15000)
		if isElement(gangRequests[player].requester) then 
			triggerClientEvent(gangRequests[player].requester, "onClientAddNotification", gangRequests[player].requester, getPlayerName(player).." przyjął zaproszenie do twojego gangu.", "success", 15000)
		end
		
		gangRequests[player] = nil
		
		loadPlayerGang(player)
	else 
		triggerClientEvent(player, "onClientAddNotification", player, "Nie masz żadnych zaproszeń do gangów.", "error")
	end
end 
addCommandHandler("akceptujgang", acceptGangRequest)

function sendGangAcceptRequest(requester, player, gangID)
	if gangRequests[player] then 
		triggerClientEvent(requester, "onClientAddNotification", requester, "Ten gracz ma oczekujące zaproszenie do innego gangu.", "error")
		return
	end 
	
	local isInGang = getElementData(player, "player:gang") 
	if isInGang then 
		triggerClientEvent(requester, "onClientAddNotification", requester, "Ten gracz jest już w jakimś gangu!", "error")
		return
	end
	
	local gangIndex = getGangIndexFromID(gangID)
	local gangName = gangData[gangIndex].name 
	
	gangRequests[player] = {id=gangID, requester=requester}
	triggerClientEvent(player, "onClientAddNotification", player, getPlayerName(requester).." wysłał/a tobie zaproszenie do gangu "..gangName..". Masz 60 sekund na zaakceptowanie go komendą /akceptujgang.", "success", 20000)
	triggerClientEvent(requester, "onClientAddNotification", requester, "Zaprosiłeś gracza "..getPlayerName(player).." do swojego gangu.", "success")
	
	setTimer(function(player)
		if isElement(player) then 
			gangRequests[player] = nil
		end
	end, 60000, 1, player)
end 

addEvent("onPlayerRequestGangLogo", true)
addEventHandler("onPlayerRequestGangLogo", root, function(gangID, url)
	if not url and gangID then 
		local gangIndex = getGangIndexFromID(gangID)
		if gangData[gangIndex] then
			url = gangData[gangIndex].logo
		else 
			url = ""
		end
	end 
	
	local cached = gangLogosCache[url]
	if cached then 
		triggerClientEvent(client, "onClientReceiveGangLogo", client, gangID, cached)
	else 
		if #url > 0 then 
			fetchRemote(url, 1, downloadGangLogo, "", false, client, gangID, url)
		end
	end
end) 

addEvent("onPlayerResetGangLogo", true)
addEventHandler("onPlayerResetGangLogo", root, function(gangID)
	local gangIndex = getGangIndexFromID(gangID)
	if #gangData[gangIndex].logo > 0 then
		gangData[gangIndex].logo = ""
	end
end)

addEvent("onPlayerRequestGangData", true)
addEventHandler("onPlayerRequestGangData", root, 
	function()
		triggerClientEvent(client, "onClientReceiveGangData", client, gangData)
	end 
)

addEvent("onPlayerQuitGang", true)
addEventHandler("onPlayerQuitGang", root, function(id)
	local gangIndex = getGangIndexFromID(id)
	local gang = gangData[gangIndex]
	if getElementData(client, "player:uid") == gang.owner.uid then 
		triggerClientEvent(client, "onClientAddNotification", client, "Jesteś założycielem gangu - nie możesz go opuścić.", "error")
		return
	end 
	
	local members = fromJSON(gang.members)
	local membersNames = gang.membersNames
	for k,v in ipairs(members) do 
		if v.uid == getElementData(client, "player:uid") then 
			table.remove(members, k)
			table.remove(membersNames, k)
		end
	end
	
	local leaders = fromJSON(gang.leaders)
	local leadersNames = gang.leadersNames
	for k,v in ipairs(leaders) do 
		if v == getElementData(client, "player:uid") then 
			table.remove(leaders, k)
			table.remove(leadersNames, k)
		end
	end
	
	gangData[gangIndex].members = toJSON(members) 
	gangData[gangIndex].membersNames = membersNames
	gangData[gangIndex].leaders = toJSON(leaders)
	gangData[gangIndex].leadersNames = leadersNames
	
	loadPlayerGang(client)
	triggerClientEvent(client, "onClientAddNotification", client, "Opuściłeś gang "..tostring(gang.name)..".", "success")
end)

addEvent("onLeaderAddMember", true)
addEventHandler("onLeaderAddMember", root, function(id, targetPlayer)
	targetPlayer = getPlayerFromName(targetPlayer)
	if targetPlayer then 
		sendGangAcceptRequest(client, targetPlayer, id)
	end
end)

addEvent("onLeaderUpdateMemberGang", true)
addEventHandler("onLeaderUpdateMemberGang", root, function(id, uid, name, rank, leader)
	local gangIndex = getGangIndexFromID(id)
	local gang = gangData[gangIndex]
	local members = fromJSON(gang.members)
	
	for k,v in ipairs(members) do 
		if v.uid == uid then 
			v.rank = rank
		end
	end
	
	local leaders = fromJSON(gang.leaders)
	local leadersNames = gang.leadersNames
	if type(leader) == "boolean" then -- jak nie jest podane to nie zmieniamy nic z tym 
		if leader then 
			table.insert(leaders, uid)
			table.insert(leadersNames, name)
		else 
			for k,v in ipairs(leaders) do 
				if v == uid then 
					table.remove(leaders, k)
					table.remove(leadersNames, k)
				end
			end
		end
	end 
	
	gangData[gangIndex].members = toJSON(members) 
	gangData[gangIndex].leaders = toJSON(leaders)
	gangData[gangIndex].leadersNames = leadersNames
	
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:uid") == uid then 
			loadPlayerGang(v)
			break
		end
	end 
	
	triggerClientEvent(client, "onClientAddNotification", client, "Zaktualizowałeś członka gangu.", "success")
end)

addEvent("onLeaderRemoveFromGang", true)
addEventHandler("onLeaderRemoveFromGang", root, function(id, uid, name)
	local gangIndex = getGangIndexFromID(id)
	local gang = gangData[gangIndex]
	if gang.owner.uid == uid then 
		triggerClientEvent(client, "onClientAddNotification", client, "Nie możesz wyrzucić założyciela gangu.", "error")
		return
	end 
	
	local members = fromJSON(gang.members)
	local membersNames = gang.membersNames
	for k,v in ipairs(members) do 
		if v.uid == uid then
			table.remove(members, k)
			table.remove(membersNames, k)
		end
	end
	
	local leaders = fromJSON(gang.leaders)
	local leadersNames = gang.leadersNames
	for k,v in ipairs(leaders) do 
		if v == uid then 
			table.remove(leaders, k)
			table.remove(leadersNames, k)
		end
	end
	
	gangData[gangIndex].members = toJSON(members) 
	gangData[gangIndex].membersNames = membersNames
	gangData[gangIndex].leaders = toJSON(leaders)
	gangData[gangIndex].leadersNames = leadersNames
	
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:uid") == uid then 
			loadPlayerGang(v)
			triggerClientEvent(v, "onClientAddNotification", v, "Zostałeś wydalony z gangu przez "..getPlayerName(client)..".", "warning", 15000)
			break
		end
	end 
	
	triggerClientEvent(client, "onClientAddNotification", client, "Usunąłeś gracza "..tostring(name).. " z gangu.", "success")
end)

addEvent("onLeaderChangeAnn", true)
addEventHandler("onLeaderChangeAnn", root, function(id, ann)
	local gangIndex = getGangIndexFromID(id)
	gangData[gangIndex].ann = ann 
	
	triggerClientEvent(client, "onClientAddNotification", client, "Zmieniłeś ogłoszenie gangu.", "success")
end)

addEvent("onLeaderDeleteRank", true)
addEventHandler("onLeaderDeleteRank", root, function(id, rankName)
	local gangIndex = getGangIndexFromID(id)
	local gang = gangData[gangIndex]
	local ranks = fromJSON(gang.ranks)
	for k,v in ipairs(ranks) do 
		if v == rankName then 
			table.remove(ranks, k)
		end
	end
	
	gangData[gangIndex].ranks = toJSON(ranks)
	
	resetGangRanks(id)
	triggerClientEvent(client, "onClientAddNotification", client, "Usunąłeś rangę "..rankName..".", "success")
end)

addEvent("onLeaderCreateRank", true)
addEventHandler("onLeaderCreateRank", root, function(id, rankName)
	local gangIndex = getGangIndexFromID(id)
	local gang = gangData[gangIndex]
	local ranks = fromJSON(gang.ranks)
	table.insert(ranks, rankName)
	
	gangData[gangIndex].ranks = toJSON(ranks)
	
	resetGangRanks(id)
	triggerClientEvent(client, "onClientAddNotification", client, "Dodałeś rangę "..rankName..".", "success")
end)

addEvent("onLeaderChangeLogo", true)
addEventHandler("onLeaderChangeLogo", root, function(id, logo)
	local gangIndex = getGangIndexFromID(id)
	
	gangData[gangIndex].logo = logo 
	
	fetchRemote(logo, 1, downloadGangLogo, "", false, client, id, logo)
	-- updateujmy tagi po zmianie loga
	setTimer(function(id)
		refreshGangTags(id)
	end, 3000, 1, id)
	
	triggerClientEvent(client, "onClientAddNotification", client, "Zmieniłeś logo swojego gangu.", "success")
end)

addEvent("onLeaderChangeInformation", true)
addEventHandler("onLeaderChangeInformation", root, function(id, name, site, tag)
	local gangIndex = getGangIndexFromID(id)
	
	gangData[gangIndex].name = name 
	gangData[gangIndex].website = site 
	gangData[gangIndex].tag = tag 
	
	for k, v in ipairs(getElementsByType("player")) do 
		local gang = getElementData(v, "player:gang")
		if gang then 
			if gang.id == id then 
				gang.name = name 
				gang.tag = tag 
				setElementData(v, "player:gang", gang)
			end
		end
	end 
	
	triggerClientEvent(client, "onClientAddNotification", client, "Zaktualizowałeś informacje o swoim gangu.", "success")
end)

addEvent("onLeaderChangeColor", true)
addEventHandler("onLeaderChangeColor", root, function(id, r, g, b)
	local gangIndex = getGangIndexFromID(id)
	
	local color = toJSON({r, g, b})
	gangData[gangIndex].color = color 
	
	for k, v in ipairs(getElementsByType("player")) do 
		local gang = getElementData(v, "player:gang")
		if gang then 
			if gang.id == id then 
				gang.color = {r, g, b}
				setElementData(v, "player:gang", gang)
			end
		end
	end 
	
	triggerClientEvent(client, "onClientAddNotification", client, "Zaktualizowałeś kolor swojego gangu.", "success")
end)

function resetGangRanks(gangID)
	local gangIndex = getGangIndexFromID(gangID)
	local tbl = fromJSON(gangData[gangIndex].members)
	for k,v in ipairs (tbl) do 
		v.rank = 0
	end
	
	for k, v in ipairs(getElementsByType("player")) do 
		local gang = getElementData(v, "player:gang")
		if gang then 
			if gang.id == gangID then 
				gang.rank = "brak rangi"
				setElementData(v, "player:gang", gang)
			end
		end
	end 
end 