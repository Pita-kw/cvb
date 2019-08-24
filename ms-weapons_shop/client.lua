local weapons_table = {
	-- nazwa, id, cena, ammo
	{"Colt 45", 22, 500, 250},
	{"Pistolet z tłumikiem", 23, 600, 250},
	{"Deagle", 24, 700, 100},
	{"Strzelba", 25, 1000, 100},
	{"Obrzyn", 26, 1200, 100},
	{"Strzelba bojowa", 27, 1300, 100},
	{"Uzi", 28, 1000, 500},
	{"MP5", 29, 1200, 500},
	{"Tec-9", 32, 1200, 500},
	{"AK-47", 30, 1300, 500},
	{"M4",  31, 1400, 500},
	{"Rifle", 33,  800, 100},
	{"Karabin snajperski", 34, 1500, 100},
	{"Spray", 41, 250, 10000},
	{"Dildo", 10, 100, 1}
}


local screenW, screenH = guiGetScreenSize()
local baseX = 2048
local zoom = 1.0
local minZoom = 2
local window_type = false

if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-(800/zoom)/2, y=screenH/2-(500/zoom)/2, w=800/zoom, h=500/zoom}	


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

function renderWeaponsList()
	if weapons_window == false then return end
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 60/zoom, tocolor(0, 0, 0, 100), true) 
	
	dxDrawText("Wybierz broń", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	
	if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
		dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 100), true) 
	else
		dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 50), true) 
	end
	
	dxDrawText("Kup", bgPos.x+260/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	
	if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
		dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
	else
		dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
	end
	
	dxDrawText("Anuluj", bgPos.x+510/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	
	exports["ms-gui"]:renderList(weapons_list)
end



function toggleWeaponsList(toggle)
	if toggle == true then
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
		weapons_window = true
		
		weapons_list = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+70/zoom, bgPos.w-30/zoom, bgPos.h-160/zoom, tocolor(20, 20, 20, 150), font2, 0.65, 20/zoom)
		exports["ms-gui"]:addListColumn(weapons_list, "Nazwa broni", 0.4)
		exports["ms-gui"]:addListColumn(weapons_list, "Cena", 0.3)
		exports["ms-gui"]:addListColumn(weapons_list, "Amunicja", 0.3)
		
		if getElementData(localPlayer, "player:premium") then
			for k,v in ipairs(weapons_table) do 
				exports["ms-gui"]:addListItem(weapons_list, "Nazwa broni", tostring(v[1]))
				local list_cost = exports["ms-gui"]:addListItem(weapons_list, "Cena", tostring("0$"))
				exports["ms-gui"]:addListItem(weapons_list, "Amunicja", tostring(v[4]))
				exports["ms-gui"]:setListItemColor(weapons_list, list_cost, 255, 242, 0)
			end
		else
			for k,v in ipairs(weapons_table) do 
				exports["ms-gui"]:addListItem(weapons_list, "Nazwa broni", tostring(v[1]))
				local list_cost = exports["ms-gui"]:addListItem(weapons_list, "Cena", tostring("".. v[3] .."$"))
				exports["ms-gui"]:addListItem(weapons_list, "Amunicja", tostring(v[4]))
				exports["ms-gui"]:setListItemColor(weapons_list, list_cost, 30, 255, 30)
			end		
		end
		
		exports["ms-gui"]:reloadListRT(weapons_list)
		exports["ms-gui"]:setListActive(weapons_list, true)
		
		showCursor(true)
		guiSetInputMode("no_binds")
		addEventHandler("onClientRender", getRootElement(), renderWeaponsList)
	else
		removeEventHandler("onClientRender", getRootElement(), renderWeaponsList)
		if font then destroyElement(font) end
		if font2 then destroyElement(font2) end
		weapons_window = false
		exports["ms-gui"]:setListActive(weapons_list, false)
		exports["ms-gui"]:destroyList(weapons_list)
		showCursor(false)
		guiSetInputMode("allow_binds")
	end
end

function airSpeditionWindowClick(key, press)
	if key == "mouse1" and press then
		if weapons_window then	
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
				toggleWeaponsList(false)
			end
			
			if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
				local weapon_index = exports["ms-gui"]:getSelectedListItemsIndex(weapons_list)
				
				if #weapon_index == 0 then
					triggerEvent("onClientAddNotification", localPlayer, "Nie wybrałeś broni!", "error")
					return
				end
				
				local ammo = weapons_table[weapon_index[1]][4]
				local cost = weapons_table[weapon_index[1]][3]
				local weapon_id = weapons_table[weapon_index[1]][2]
				local player_money = getElementData(localPlayer, "player:money")
				
				if player_money < cost then
					triggerEvent("onClientAddNotification", localPlayer, "Nie stać cię na tę broń!", "error")
					return
				end
				
				if getElementData(localPlayer, "player:premium") then
					triggerEvent("onClientAddNotification", localPlayer, "Otrzymałeś broń ".. weapons_table[weapon_index[1]][1] .." za darmo dzięki posiadaniu konta premium.", "success")
					triggerServerEvent("giveWeaponFromShop", localPlayer, localPlayer, weapon_id, ammo, false)
				else
					triggerEvent("onClientAddNotification", localPlayer, "Zakupiłeś broń ".. weapons_table[weapon_index[1]][1] .." za ".. cost .."$", "success")
					triggerServerEvent("giveWeaponFromShop", localPlayer, localPlayer, weapon_id, ammo, cost)
				end
			end
		end
	end
end
addEventHandler("onClientKey", getRootElement(), airSpeditionWindowClick, true, "high+2")

addCommandHandler("bronie", 
	function()
		if getPlayerTeam(localPlayer) then triggerEvent("onClientAddNotification", localPlayer, "Nie możesz teraz kupić broni!", "error") return end
		if getElementData(localPlayer, "player:job") then triggerEvent("onClientAddNotification", localPlayer, "Nie możesz teraz kupić broni!", "error") return end
		if getElementData(localPlayer, "player:arena") then triggerEvent("onClientAddNotification", localPlayer, "Nie możesz teraz kupić broni!", "error") return end
		
		if weapons_window then
			toggleWeaponsList(false)
		else
			toggleWeaponsList(true)
		end
	end
)