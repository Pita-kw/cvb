local mysql = exports["ms-database"]

local sm_take = false
local sm_give = false
local card_take = false
local card_give = false
local text = false

addEvent("updateCasinoStats", true)

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function loadCasinoStats()
	local casino_stats = mysql:getRows("SELECT * FROM `ms_casino-stats`")

	sm_give = casino_stats[1]["sm_give"]
	sm_take = casino_stats[1]["sm_take"]
	card_give = casino_stats[1]["card_give"]
	card_take = casino_stats[1]["card_take"]
	
	text = createElement("3dtext")
	setElementPosition(text, 2025.83,1679.19,998.55+1)
	setElementInterior(text, 1)
	setElementDimension(text, 0)
	setElementData(text, "text", "Trwa ładowanie statystyk.")
end
addEventHandler ( "onResourceStart", resourceRoot, loadCasinoStats )

function updateCasinoText()
	local casino_money_give = sm_give + card_give
	setElementData(text, "text", "Kasyno rozdało już #00FF00".. comma_value(tostring(casino_money_give)) .."$!")
end
setTimer(updateCasinoText, 1000, 0)


function saveCasinoStats()
	mysql:query("UPDATE `ms_casino-stats` SET `sm_give`=?, `sm_take`=?, `card_give`=?, `card_take`=?", sm_give, sm_take, card_give, card_take)
end
setTimer(saveCasinoStats, 60000*5, 0)
addEventHandler ( "onResourceStop", resourceRoot, saveCasinoStats )

function updateCasinoStats(platform, type, count)
	if platform and type and count then
		if platform == "sm" and type == "give" then
			sm_give = sm_give + count
			return true
		end
		
		if platform == "sm" and type == "take" then
			sm_take = sm_take + count
			return true
		end
		
		if platform == "card" and type == "give" then
			card_give = card_give + count
			return true
		end
		
		if platform == "card" and type == "take" then
			card_take = card_take + count
			return true
		end
	else
		return false
	end
end
addEventHandler("updateCasinoStats", getRootElement(), updateCasinoStats)

function outputCasinoStats(player, cmd)
	if getElementData(player, "player:rank") ~= 3 then return end
	outputChatBox("Slot Machine dał: ".. comma_value(tostring(sm_give)) .."$", player)
	outputChatBox("Slot Machine zabrał: ".. comma_value(tostring(sm_take)) .."$", player)
	outputChatBox("Babka dała: ".. comma_value(tostring(card_give)) .."$", player)
	outputChatBox("Babka zabrała: ".. comma_value(tostring(card_take)) .."$", player)
	outputChatBox("Bilans: "..comma_value(tostring((sm_give+card_give)-(sm_take+card_take))).."$", player)
end
addCommandHandler("casinostats", outputCasinoStats)


