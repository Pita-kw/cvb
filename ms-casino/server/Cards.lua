function giveCardReward(player, money)
	exports["ms-gameplay"]:msGiveMoney(player, money, true)
end
addEvent("giveCardReward", true)
addEventHandler("giveCardReward", getRootElement(), giveCardReward)

function takeCardMoney(player, money)
	exports["ms-gameplay"]:msTakeMoney(player, money)
end
addEvent("takeCardMoney", true)
addEventHandler("takeCardMoney", getRootElement(), takeCardMoney)