local screenW, screenH = guiGetScreenSize()
local baseX = 2048
local zoom = 1.0
local minZoom = 2


if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-(400/zoom)/2, y=screenH/2-(400/zoom)/2, w=400/zoom, h=400/zoom}	
local cardPos = {x=screenW/2-300/zoom/2, y=screenH/2-400/zoom/2, w=276/zoom, h=358/zoom}

local cash_window = false
local card_window = false
local money = false
local allow_choose = false
local card_sound = false

local card_images = {
	{"neutral"},
	{"neutral"},
	{"neutral"}
}



function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function getWinFromCard()
	local number = math.random(1, 100)
	
	if number > 30 then 
		return false
	else
		return true
	end
end

function renderCards()
	dxDrawText("Wybierz kartę", cardPos.x-200/zoom, cardPos.y-99/zoom, screenW/zoom, screenH/zoom, tocolor(0, 0, 0, 255), 1, card_font, "center", "top", false, true, true)
	dxDrawText("Wybierz kartę", cardPos.x-200/zoom, cardPos.y-100/zoom, screenW/zoom, screenH/zoom, tocolor(255, 255, 255, 255), 1, card_font, "center", "top", false, true, true)

	if isCursorOnElement(cardPos.x-350/zoom, cardPos.y, cardPos.w, cardPos.h) then
		dxDrawImage(cardPos.x-350/zoom, cardPos.y, cardPos.w, cardPos.h, "files/images/".. card_images[1][1] ..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
	else
		dxDrawImage(cardPos.x-350/zoom, cardPos.y, cardPos.w, cardPos.h, "files/images/".. card_images[1][1] ..".png", 0, 0, 0, tocolor(255, 255, 255, 200))
	end
	
	if isCursorOnElement(cardPos.x, cardPos.y, cardPos.w, cardPos.h) then
		dxDrawImage(cardPos.x, cardPos.y, cardPos.w, cardPos.h, "files/images/".. card_images[2][1] ..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
	else
		dxDrawImage(cardPos.x, cardPos.y, cardPos.w, cardPos.h, "files/images/".. card_images[2][1] ..".png",  0, 0, 0, tocolor(255, 255, 255, 200))
	end

	if isCursorOnElement(cardPos.x+350/zoom, cardPos.y, cardPos.w, cardPos.h) then
		dxDrawImage(cardPos.x+350/zoom, cardPos.y, cardPos.w, cardPos.h, "files/images/".. card_images[3][1] ..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
	else
		dxDrawImage(cardPos.x+350/zoom, cardPos.y, cardPos.w, cardPos.h, "files/images/".. card_images[3][1] ..".png",  0, 0, 0, tocolor(255, 255, 255, 200))
	end
end

function renderCashWindow()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(170, 170, 170, 255), false)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h-350/zoom, tocolor(30, 30, 30, 100), true) 
	dxDrawText("Ile chcesz postawić?", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	dxDrawText("Chcesz podjąć pewne ryzyko? Postaw tyle ile jesteś w stanie. Możesz przegrać całą postawioną kasę lub wygrać ją podwójnie.", bgPos.x+50/zoom, bgPos.y+100/zoom, bgPos.x+bgPos.w-50/zoom, bgPos.x+bgPos.y-50/zoom, tocolor(230, 230, 230, 230), 0.5, font2, "center", "top", false, true, true)
	dxDrawRectangle(bgPos.x+20/zoom, bgPos.y+250/zoom, bgPos.w-40/zoom, 50/zoom, tocolor(30, 30, 30, 100), true) 
	if isCursorOnElement(bgPos.x+20/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom) then
		dxDrawRectangle(bgPos.x+20/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom, tocolor(30, 255, 30, 100), true) 
	else
		dxDrawRectangle(bgPos.x+20/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom, tocolor(30, 255, 30, 50), true) 
	end
	
	if isCursorOnElement(bgPos.x+230/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom) then
		dxDrawRectangle(bgPos.x+230/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
	else
		dxDrawRectangle(bgPos.x+230/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
	end
	dxDrawText("POSTAW", bgPos.x-210/zoom, bgPos.y+330/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true)
	dxDrawText("ANULUJ", bgPos.x+210/zoom, bgPos.y+330/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "center", "top", false, true, true)
	exports["ms-gui"]:renderEditBox(cash_edit)
end

function onCardPickupHit(hit, dim)
	if hit ~= localPlayer then return end
	toggleCashWindow(true)
end

function cardSystemLoad()
	local card_ped = createPed(172, 2025.83,1679.19,998.55, 86.19)
	setElementInterior(card_ped, 1)
	addEventHandler('onClientPedDamage', card_ped, cancelEvent)
	setElementFrozen(card_ped, true)
	local card_pikcup = createPickup(2023.66,1679.11,998.55-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
	setElementInterior(card_pikcup, 1)
	addEventHandler('onClientPickupHit', card_pikcup, onCardPickupHit)
end
addEventHandler("onClientResourceStart", resourceRoot, cardSystemLoad)


function toggleCashWindow(toggle)
	if toggle == true then
		addEventHandler("onClientRender", getRootElement(), renderCashWindow)
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
		cash_edit = exports["ms-gui"]:createEditBox("", bgPos.x+40/zoom, bgPos.y+250/zoom, bgPos.w-40/zoom, 50/zoom, tocolor(230, 230, 230, 230), font2, 0.6)
		exports["ms-gui"]:setEditBoxHelperText(cash_edit, "Wprowdź kwotę")
		showCursor(true)
		guiSetInputMode("no_binds")
		cash_window = true
	else
		removeEventHandler("onClientRender", getRootElement(), renderCashWindow)
		if font then destroyElement(font) end
		if font2 then destroyElement(font2) end
		exports["ms-gui"]:destroyEditBox(cash_edit)
		showCursor(false)
		guiSetInputMode("allow_binds")
		cash_window = false
	end
end

function toggleCards(toggle)
	if toggle == true then
		showCursor(true)
		guiSetInputMode("no_binds")
		card_window = true
		card_font = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
		addEventHandler("onClientRender", getRootElement(), renderCards)
	else
		showCursor(false)
		guiSetInputMode("allow_binds")
		card_window = false
		destroyElement(card_font)
		removeEventHandler("onClientRender", getRootElement(), renderCards)
	end
end


function airSpeditionWindowClick(button, state)
	if button == "left" and state == "up" then 
		if cash_window then
			if isCursorOnElement(bgPos.x+20/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom) then
				local edit_text = exports["ms-gui"]:getEditBoxText(cash_edit)
				local player_money = getElementData(localPlayer, "player:money")
				
				
				if #edit_text == 0 then
					triggerEvent("onClientAddNotification", localPlayer, "Wpisz kwotę!", "error", 5000)
					return
				end
				
				if not tonumber(edit_text) then
					triggerEvent("onClientAddNotification", localPlayer, "Wpisana wartość nie jest liczbą!", "error", 5000)
					return
				end
				
				if tonumber(edit_text) < 100 then
					triggerEvent("onClientAddNotification", localPlayer, "Minimalna kwota wynosi 100$!", "warning", 5000)
					return
				end
				
				if tonumber(edit_text) > 500000 then
					triggerEvent("onClientAddNotification", localPlayer, "Maksymalna kwota jaką możesz postawić to 500,000$!", "warning", 5000)
					return
				end
				
				if tonumber(edit_text) > player_money then
					triggerEvent("onClientAddNotification", localPlayer, "Nie masz tyle pieniędzy!", "error", 5000)
					return
				end
				
				triggerServerEvent("takeCardMoney", localPlayer, localPlayer, math.floor(tonumber(edit_text)))
				
				cash_window = false
				money = math.floor(edit_text)
				allow_choose = true
				toggleCashWindow(false)
				toggleCards(true)
				return
			end
			
			if isCursorOnElement(bgPos.x+230/zoom, bgPos.y+320/zoom, bgPos.w-250/zoom, 50/zoom) then
				toggleCashWindow(false)
				return
			end
		end
		
		if card_window and allow_choose then
			if isCursorOnElement(cardPos.x-350/zoom, cardPos.y, cardPos.w, cardPos.h) then
				onPlayerSelectedCard(1)
				allow_choose = false
				return
			end
			
			if isCursorOnElement(cardPos.x, cardPos.y, cardPos.w, cardPos.h) then
				onPlayerSelectedCard(2)
				allow_choose = false
				return
			end

			if isCursorOnElement(cardPos.x+350/zoom, cardPos.y, cardPos.w, cardPos.h) then
				onPlayerSelectedCard(3)
				allow_choose = false
				return
			end
			
			return
		end
	end
end
addEventHandler("onClientClick", getRootElement(), airSpeditionWindowClick)


function onPlayerSelectedCard(id)
	local win = getWinFromCard()
	
	if win then
		local reward = money + money
		triggerEvent("onClientAddNotification", localPlayer, "Wygrałeś ".. tostring(reward) .."$!", "success", 7500, false)
		card_images[id][1] = "win"
		triggerServerEvent("giveCardReward", localPlayer, localPlayer, reward)
		card_sound = playSound("files/sounds/win.mp3")
		setSoundVolume(card_sound, 0.5)
		triggerServerEvent("updateCasinoStats", localPlayer, "card", "give", tonumber(math.floor(reward)))				
	else
		triggerEvent("onClientAddNotification", localPlayer, "Przegrałeś ".. tostring(money) .."$.", "error", 7500, false)
		card_images[id][1] = "lose"
		card_sound = playSound("files/sounds/lose.wav")
		setSoundVolume(card_sound, 0.5)
		triggerServerEvent("updateCasinoStats", localPlayer, "card", "take", tonumber(math.floor(money)))
	end
	
	money = false

	
	setTimer ( function()
		toggleCards(false)
		toggleCashWindow(true)
		
		for k,v in ipairs(card_images) do
			v[1] = "neutral"
		end
	end, 5000, 1 )
end

if getPlayerName(localPlayer) == "Virelox" then
	showCursor(false)
	guiSetInputMode("allow_binds")
end