--[[
	@project: multiserver
	@author: virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: strona klineta pracy spedycji lądowej
]]

local speed_limit = 140

local positions = {
	{2791.4499511719,-2418.2299804688,14.218999862671},
	{-1876.75,-201.54800415039,17.392499923706},
	{2190.9699707031,913.80603027344,10.362299919128},
	{2112.25,935.77197265625,10.362099647522},
	{1902.7399902344,992.59301757812,10.362000465393},
	{2017.1999511719,1167.1500244141,10.360199928284},
	{1936,-1776.7800292969,13.039299964905},
	{2143.080078125,1392.7099609375,10.354700088501},
	{2167.75,1669.2900390625,10.362400054932},
	{482.68301391602,-1518.8599853516,19.854200363159},
	{1347.1899414062,1277.2099609375,10.362299919128},
	{1003,-940.63299560547,41.818199157715},
	{1603.7199707031,1346.6800537109,10.380599975586},
	{1603.1700439453,1623.7399902344,10.362400054932},
	{1701.2199707031,1755.7199707031,10.318699836731},
	{1630.2399902344,1831.5899658203,10.362700462341},
	{1610.0300292969,2201,10.362400054932},
	{1695.4300537109,2186.6499023438,10.362199783325},
	{1709.6700439453,2334.3999023438,10.362000465393},
	{1874.4000244141,2267.0100097656,10.323599815369},
	{-2465.1398925781,786.71502685547,34.777000427246},
	{1985.8699951172,2439.9499511719,10.362000465393},
	{1362.2399902344,-1280.9599609375,13.10120010376},
	{2445.2700195312,2756.1298828125,10.213899612427},
	{-2314.2299804688,-147.27200317383,34.926498413086},
	{2907.1101074219,2408.580078125,10.347299575806},
	{-2109.4499511719,204.32400512695,34.865898132324},
	{1949.0500488281,-2124.8999023438,13.202899932861},
	{2803.4599609375,1964.0999755859,10.285900115967},
	{2773.1999511719,1418.3699951172,9.2844104766846},
	{-1865.7099609375,854.25500488281,34.619800567627},
	{-1647.4499511719,1218.8699951172,6.7155599594116},
	{2416.8798828125,-1232.2700195312,24.019100189209},
	{-1866.9200439453,1410.1999511719,6.7928099632263},
	{659.23699951172,-566.85699462891,15.995300292969},
	{-2528.3100585938,1223.6999511719,37.032398223877},
	{1369.3299560547,700.69201660156,10.362400054932},
	{1482.8000488281,993.78198242188,10.362299919128},
	{249.98199462891,-66.573196411133,1.1603699922562},
	{2266.2600097656,-84.128898620605,26.17799949646},
	{989.72900390625,1711.7399902344,10.368700027466},
	{1028.0200195312,2128.2600097656,10.362400054932},
	{-2726.4699707031,-311.46798706055,6.6433100700378},
	{1383.4899902344,454.70999145508,20.504199981689},
	{1522.8100585938,2773.4899902344,10.213899612427},
	{-2522.1599121094,231.51600646973,10.704600334167},
	{-1837.9200439453,136.05099487305,14.722100257874},
	{422.09600830078,2505.9599609375,16.02619934082},
	{-1427.3800048828,-294.55999755859,13.60389995575},
	{-1965.0400390625,-2439.75,30.282499313354},
	{-2522.1201171875,-612.56201171875,132.16600036621},
	{304.6130065918,1931.3199462891,17.182399749756},
	{-44.205101013184,2327.75,23.431299209595},
	{-1906.5699462891,-782.26501464844,31.627700805664},
	{-510.33801269531,2592.9699707031,52.956100463867},
	{1232.7399902344,-1828.9499511719,13.064399719238},
	{-1422.9000244141,-1470.2800292969,101.24500274658},
	{-897.48602294922,2002.9599609375,60.456100463867},
	{-1191.8499755859,1823.2700195312,41.250701904297},
	{-1174.3000488281,-1115.2099609375,127.87000274658},
	{-803.37200927734,1617.2600097656,26.602699279785},
	{-828.58502197266,1435.7700195312,13.308799743652},
	{-1104.9899902344,-1620.9499511719,75.970497131348},
	{-319.2619934082,1735.8199462891,42.229598999023},
	{-75.525398254395,-1587.9200439453,2.2754299640656},
	{-2265.0200195312,533.77398681641,34.62260055542},
	{-281.10501098633,-2184.4499511719,28.356300354004},
	{15.658200263977,-2648.4799804688,40.042701721191},
	{-294.99798583984,1520.5600585938,74.901100158691},
	{-2464.8100585938,2239.3898925781,4.3946399688721},
	{2390.9599609375,-1977.6300048828,13.120400428772},
	{-293.10101318359,1054.2199707031,19.133699417114},
	{-1930.7900390625,2384.080078125,49.097099304199},
	{-1809.5799560547,2047.7399902344,8.6763401031494},
	{605.53900146484,1201.2700195312,11.258500099182},
	{-1291.6700439453,2713.2399902344,49.666599273682},
	{2032.1400146484,-1416.7700195312,16.651100158691},
	{-2794.6101074219,779.84002685547,49.689300537109},
	{667.083984375,-1277.1500244141,13.119199752808}
}

local start_positions = {
	{2229.99,-2218.57,14.64, 0.44,-0.00,314.82}, -- los santos
	{2793.29,914.49,11.84, 0.45,-0.00,92.40}, -- las venturas
	{-2127.64,-85.17,36.42, 0.43,0.00,359.84} -- san fierro
}

local product_names = {
	-- nazwa, wymagana ilość punktów, mnożnik
	{"Gruz", 0, 0},
	{"Cement", 20, 1},
	{"Węgiel", 40, 1.045},
	{"Drewno", 60, 1.090},
	{"Prasa", 80, 1.135},
	{"Woda", 100, 1.180},
	{"Mleko", 120, 1.225},
	{"Alkohol", 140, 1.270},
	{"Benzyna", 160, 1.315},
	{"Mąka", 180, 1.360},
	{"Owoce", 200, 1.405},
	{"Warzywa", 220, 1.450},
	{"Ryby", 240, 1.495},
	{"Mięso", 260, 1.540},
	{"Słodycze", 280, 1.585},
	{"Ubrania", 300, 1.630},
	{"Zabawki", 320, 1.675},
	{"Elektronika", 340, 1.720},
	{"Amunicja", 360, 1.765},
	{"Broń", 380, 1.810},
	{"Biżuteria", 400, 1.855},
}

local los_santos_positions = {}
local las_veturas_positions = {}
local san_fierro_positions = {}

local ls_ped = false
local lv_ped = false
local sf_ped = false

local ls_pickup = false
local lv_pickup = false
local sf_pickup = false

local city_pickup = false

local truck_window = false

local list_product_id = false
local list_track_id = false

local track_id = false
local product_id = false

local truck_vehicle = false
local truck_trailer = false
local truck_checpoint = false
local truck_mapicon = false

local screenW, screenH = guiGetScreenSize()
local baseX = 2048
local zoom = 1.0
local minZoom = 2
local window_type = false

if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgPos = {x=screenW/2-(800/zoom)/2, y=screenH/2-(500/zoom)/2, w=800/zoom, h=500/zoom}	
local bgPosHUD

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

function airSpeditionWindowClick(key, press)
	if key == "mouse1" and press then
		if truck_window then	
			
			-- anulowanie pracy
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "info" then
				toggleTruckWindow(false)
				return
			end
			
			-- anulowanie wyboru towaru
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "choose_stuff" then
				toggleTruckWindow(false)
				exports["ms-gui"]:setListActive(truck_stuff, false)
				exports["ms-gui"]:destroyList(truck_stuff)
				return
			end
			
			-- anulowanie wyboru trasy
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "truck_road" then
				toggleTruckWindow(false)
				exports["ms-gui"]:setListActive(truck_road, false)
				exports["ms-gui"]:destroyList(truck_road)
				return
			end
			
			-- wybieranie trasy
			if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "choose_stuff" then
				if #list_product_id == 0 then
					triggerEvent("onClientAddNotification", localPlayer, "Nie wybrałeś towaru!", "error")
					return
				end
				
				local points = getElementData(localPlayer, "job_points:truck")
				
				if points < tonumber(product_names[list_product_id[1]][2]) then
					triggerEvent("onClientAddNotification", localPlayer, "Nie masz wystarczającej ilośći punktów!", "error")
					return
				end
				
				window_type = "truck_road"				
				truck_road = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+70/zoom, bgPos.w-30/zoom, bgPos.h-160/zoom, tocolor(20, 20, 20, 150), font2, 0.65, 20/zoom)
				exports["ms-gui"]:addListColumn(truck_road, "ID", 0.1)
				exports["ms-gui"]:addListColumn(truck_road, "Miasto", 0.3)
				exports["ms-gui"]:addListColumn(truck_road, "Dystans", 0.2)
				exports["ms-gui"]:addListColumn(truck_road, "Kasa", 0.2)
				exports["ms-gui"]:addListColumn(truck_road, "Exp", 0.2)
				
				local mnoznik = product_names[list_product_id[1]][3]
				
				if city_pickup == "LS" then
					for k,v in ipairs(los_santos_positions) do 
						exports["ms-gui"]:addListItem(truck_road, "ID", tostring(v[1]))
						exports["ms-gui"]:addListItem(truck_road, "Miasto", tostring(v[2]))
						exports["ms-gui"]:addListItem(truck_road, "Dystans", tostring(math.floor(v[3])))
						exports["ms-gui"]:addListItem(truck_road, "Kasa", tostring(getMoneyFromDistance(v[3], mnoznik)))
						exports["ms-gui"]:addListItem(truck_road, "Exp", tostring(getExpFromDistance(v[3], mnoznik)))
					end 				
				elseif city_pickup == "LV" then
					for k,v in ipairs(las_veturas_positions) do 
						exports["ms-gui"]:addListItem(truck_road, "ID", tostring(v[1]))
						exports["ms-gui"]:addListItem(truck_road, "Miasto", tostring(v[2]))
						exports["ms-gui"]:addListItem(truck_road, "Dystans", tostring(math.floor(v[3])))
						exports["ms-gui"]:addListItem(truck_road, "Kasa", tostring(getMoneyFromDistance(v[3], mnoznik)))
						exports["ms-gui"]:addListItem(truck_road, "Exp", tostring(getExpFromDistance(v[3], mnoznik)))
					end 				
				elseif city_pickup == "SF" then
					for k,v in ipairs(san_fierro_positions) do 
						exports["ms-gui"]:addListItem(truck_road, "ID", tostring(v[1]))
						exports["ms-gui"]:addListItem(truck_road, "Miasto", tostring(v[2]))
						exports["ms-gui"]:addListItem(truck_road, "Dystans", tostring(math.floor(v[3])))
						exports["ms-gui"]:addListItem(truck_road, "Kasa", tostring(getMoneyFromDistance(v[3], mnoznik)))
						exports["ms-gui"]:addListItem(truck_road, "Exp", tostring(getExpFromDistance(v[3], mnoznik)))
					end 		
				end
				exports["ms-gui"]:reloadListRT(truck_road)
				exports["ms-gui"]:setListActive(truck_road, true)
				return
			end
			
			local points = getElementData(localPlayer, "job_points:truck")
			
			-- wybieranie towaru
			if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "info" then
				window_type = "choose_stuff"
				truck_stuff = exports["ms-gui"]:createList(bgPos.x+15/zoom, bgPos.y+70/zoom, bgPos.w-30/zoom, bgPos.h-160/zoom, tocolor(20, 20, 20, 150), font2, 0.65, 20/zoom)
				exports["ms-gui"]:addListColumn(truck_stuff, "ID", 0.2)
				exports["ms-gui"]:addListColumn(truck_stuff, "Towar", 0.4)
				exports["ms-gui"]:addListColumn(truck_stuff, "Wymagane punkty", 0.3)
				
				for k,v in ipairs(product_names) do 
					if points < v[2] then
						local id = exports["ms-gui"]:addListItem(truck_stuff, "ID", tostring(k))
						local towar = exports["ms-gui"]:addListItem(truck_stuff, "Towar", tostring(v[1]))
						local punkty = exports["ms-gui"]:addListItem(truck_stuff, "Wymagane punkty", tostring(math.max(0, v[2])))
						exports["ms-gui"]:setListItemColor(truck_stuff, id, 100,100,100)
						exports["ms-gui"]:setListItemColor(truck_stuff, towar, 100,100,100)
						exports["ms-gui"]:setListItemColor(truck_stuff, punkty, 100,100,100)
					else	
						exports["ms-gui"]:addListItem(truck_stuff, "ID", tostring(k))
						exports["ms-gui"]:addListItem(truck_stuff, "Towar", tostring(v[1]))
						exports["ms-gui"]:addListItem(truck_stuff, "Wymagane punkty", tostring(math.max(0, v[2])))
					end
				end 
				
				exports["ms-gui"]:reloadListRT(truck_stuff)
				exports["ms-gui"]:setListActive(truck_stuff, true)
				return
			end
			
			-- rozpoczynanie pracy
			if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) and window_type == "truck_road" then
				if #list_track_id == 0 then
					triggerEvent("onClientAddNotification", localPlayer, "Wybierz trasę!", "error")
					return
				end

				local position = false
				
				track_id = list_track_id[1]
				product_id = list_product_id[1]
				
				toggleTruckWindow(false)
				exports["ms-gui"]:setListActive(truck_stuff, false)
				exports["ms-gui"]:destroyList(truck_stuff)
				exports["ms-gui"]:setListActive(truck_road, false)
				exports["ms-gui"]:destroyList(truck_road)
				
				if city_pickup == "LS" then
					position = {start_positions[1][1], start_positions[1][2], start_positions[1][3], start_positions[1][4], start_positions[1][5], start_positions[1][6]}
				elseif city_pickup == "LV" then
					position = {start_positions[2][1], start_positions[2][2], start_positions[2][3], start_positions[2][4], start_positions[2][5], start_positions[2][6]}
				elseif city_pickup == "SF" then
					position = {start_positions[3][1], start_positions[3][2], start_positions[3][3], start_positions[3][4], start_positions[3][5], start_positions[3][6]}
				end
				
				if position then
					triggerServerEvent("startTruckSpeditionServer", localPlayer, localPlayer, position)
				else
					triggerEvent("onClientAddNotification", localPlayer, "Błąd określenia pozycji! Zgłoś błąd administracji!", "error")
				end
				return
			end
		end
	end
end
addEventHandler("onClientKey", getRootElement(), airSpeditionWindowClick, true, "high+2")

function renderTruckSpeditionHUD()
	local vehicle_health = math.floor(getElementHealth(getPedOccupiedVehicle(localPlayer))/10)
	local x,y,z = getElementPosition(localPlayer)
	
	local hud_target_position =false
	local hud_target_city = false
	
	if city_pickup == "LS" then
		hud_target_position = los_santos_positions[track_id][4]
		hud_target_city = los_santos_positions[track_id][2]
	elseif city_pickup == "LV" then
		hud_target_position = las_veturas_positions[track_id][4]
		hud_target_city = las_veturas_positions[track_id][2]
	elseif city_pickup == "SF" then
		hud_target_position = san_fierro_positions[track_id][4]
		hud_target_city = san_fierro_positions[track_id][2]
	end
	
	local hud_distance = math.floor(getDistanceBetweenPoints2D(hud_target_position[1], hud_target_position[2], x, y))
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPosHUD.x, bgPosHUD.y, bgPosHUD.w, bgPosHUD.h, tocolor(170, 170, 170, 255), false)
	dxDrawRectangle(bgPosHUD.x, bgPosHUD.y, bgPosHUD.w-400/hudZoom, bgPosHUD.h, tocolor(30, 30, 30, 100), true) 
	dxDrawRectangle(bgPosHUD.x+400/hudZoom, bgPosHUD.y, bgPosHUD.w-400/hudZoom, bgPosHUD.h, tocolor(30, 30, 30, 100), true) 
	dxDrawText("Towar: ".. product_names[product_id][1] .."", bgPosHUD.x, bgPosHUD.y+30/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.6, font2, "center", "top", false, true, true)
	dxDrawText("Miasto ".. hud_target_city .."", bgPosHUD.x, bgPosHUD.y+60/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.6, font2, "center", "top", false, true, true)
	dxDrawText(hud_distance, bgPosHUD.x-390/hudZoom, bgPosHUD.y+30/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	dxDrawText("".. vehicle_health .."%", bgPosHUD.x+395/hudZoom, bgPosHUD.y+30/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
	dxDrawText("Stan", bgPosHUD.x+395/hudZoom, bgPosHUD.y+65/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.5, font2, "center", "top", false, true, true)
	dxDrawText("Dystans", bgPosHUD.x-390/hudZoom, bgPosHUD.y+65/hudZoom, bgPosHUD.x+bgPosHUD.w, bgPosHUD.x+bgPosHUD.y, tocolor(230, 230, 230, 230), 0.5, font2, "center", "top", false, true, true)
end


function toggleTruckSpeditionHUD(toggle)
	if toggle == true then
		addEventHandler("onClientRender", getRootElement(), renderTruckSpeditionHUD)
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
	else
		removeEventHandler("onClientRender", getRootElement(), renderTruckSpeditionHUD)
		if font then destroyElement(font) end
		if font2 then destroyElement(font2) end
	end
end

function renderTruckWindow(type)
	if window_type == false then return end
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w, 60/zoom, tocolor(0, 0, 0, 100), true) 
	
	if window_type == "info" then
		dxDrawText("Spedycja", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
		dxDrawText("Dostarcz towar do wybranej bazy. Podczas jazdy zachowaj szczególną ostrożność aby nie uszkodzić towaru. Jeżeli uszkodzisz towar zlecenie zostanie przerwane. Wraz z ilością wykonanych spedycji odblokują ci się nowe towary dzięki którym twoje wynagrodzenie za pracę będzie wyższe.", bgPos.x+30/zoom, bgPos.y+90/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "left", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 50), true) 
		end
		
		dxDrawText("Dalej", bgPos.x+260/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
		end
		
		dxDrawText("Anuluj", bgPos.x+510/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	end
	
	if window_type == "choose_stuff" then
		list_product_id = exports["ms-gui"]:getSelectedListItemsIndex(truck_stuff)
		dxDrawText("Wybierz towar", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
		local points = getElementData(localPlayer, "job_points:truck")
		dxDrawText("(".. points .." punktów)", bgPos.x+355, bgPos.y+12/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.6, font2, "center", "top", false, true, true)
		exports["ms-gui"]:renderList(truck_stuff)
		
		if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 50), true) 
		end
		
		dxDrawText("Dalej", bgPos.x+260/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
		end
		
		dxDrawText("Anuluj", bgPos.x+510/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	end
	
	if window_type == "truck_road" then
		list_track_id = exports["ms-gui"]:getSelectedListItemsIndex(truck_road)
		dxDrawText("Wybierz trasę", bgPos.x, bgPos.y+10/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font2, "center", "top", false, true, true)
		exports["ms-gui"]:renderList(truck_road)
		if isCursorOnElement(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+180/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(30, 255, 30, 50), true) 
		end
		
		dxDrawText("Dalej", bgPos.x+260/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
		
		if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom) then
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 100), true) 
		else
			dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+420/zoom, 200/zoom, 50/zoom, tocolor(255, 30, 30, 50), true) 
		end
		
		dxDrawText("Anuluj", bgPos.x+510/zoom, bgPos.y+430/zoom, bgPos.x+bgPos.w, bgPos.x+bgPos.y, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
	end
end

function toggleTruckWindow(toggle)
	if toggle == true then
		addEventHandler("onClientRender", getRootElement(), renderTruckWindow)
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "antialiased") or "default-bold"
		font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "antialiased") or "default-bold"
		truck_window = true
		showCursor(true)
		window_type = "info"
		guiSetInputMode("no_binds")
	else
		removeEventHandler("onClientRender", getRootElement(), renderTruckWindow)
		if font then destroyElement(font) end
		if font2 then destroyElement(font2) end
		air_spedition_window_toggle = false
		truck_window = false
		window_type = false
		showCursor(false)
		guiSetInputMode("allow_binds")
	end
end

function truckPickupHit(player, dim)
	if player ~= localPlayer then return end
	if source == ls_pickup then 
		toggleTruckWindow(true)
		city_pickup = "LS"
	elseif source == lv_pickup then
		toggleTruckWindow(true)
		city_pickup = "LV"
	elseif source == sf_pickup then
		toggleTruckWindow(true)
		city_pickup = "SF"
	end
end

function onTruckLoad()
	ls_ped = createPed(292, 2226.88,-2209.54,13.55, 131.78) 
	lv_ped = createPed(292, 2855.51,945.34,10.75,178.53)
	sf_ped = createPed(292, -2135.55,-82.04,35.32, 177)
	local blip_ls = createBlipAttachedTo(ls_ped, 52)
	local blip_lv = createBlipAttachedTo(lv_ped, 52)
	local blip_sf = createBlipAttachedTo(sf_ped, 52)
	setElementData(blip_ls, 'blipIcon', 'job')
	setElementData(blip_lv, 'blipIcon', 'job')
	setElementData(blip_sf, 'blipIcon', 'job')
	
	setElementFrozen(ls_ped, true)
	setElementFrozen(lv_ped, true)
	setElementFrozen(sf_ped, true)
	addEventHandler('onClientPedDamage', ls_ped, cancelEvent)
	addEventHandler('onClientPedDamage', lv_ped, cancelEvent)
	addEventHandler('onClientPedDamage', sf_ped, cancelEvent)
	
	
	ls_pickup = createPickup(2226.30,-2210.16,13.55-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
	lv_pickup = createPickup(2855.51,944.63,10.75-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
	sf_pickup = createPickup(-2135.56,-82.75,35.32-0.5,3, 1274, 2, 255, 0, 0, 255, 0, 1337)
	
	
	addEventHandler("onClientPickupHit", ls_pickup, truckPickupHit)
	addEventHandler("onClientPickupHit", lv_pickup, truckPickupHit)
	addEventHandler("onClientPickupHit", sf_pickup, truckPickupHit)

	local positions_count = 0	
	for k,v in ipairs(positions) do
		local city_name = getZoneName(v[1], v[2], v[3])
		local ls_distance = getDistanceBetweenPoints2D(start_positions[1][1], start_positions[1][2], v[1], v[2])
		local lv_distance = getDistanceBetweenPoints2D(start_positions[2][1], start_positions[2][2], v[1], v[2])
		local sf_distance = getDistanceBetweenPoints2D(start_positions[3][1], start_positions[3][2], v[1], v[2])
		local ls = {k, city_name, ls_distance, {v[1], v[2], v[3]}}
		local lv = {k, city_name, lv_distance, {v[1], v[2], v[3]}}
		local sf = {k, city_name, sf_distance, {v[1], v[2], v[3]}}
		table.insert(los_santos_positions, ls)
		table.insert(las_veturas_positions, lv)
		table.insert(san_fierro_positions, sf)
		positions_count = k
	end
	
	-- układanie kolejności według dystansu
	
	table.sort(los_santos_positions, function(x, y)
		return x[3] < y[3]
	end)
	
	table.sort(las_veturas_positions, function(x, y)
		return x[3] < y[3]
	end)
	
	table.sort(san_fierro_positions, function(x, y)
		return x[3] < y[3]
	end)
	
	-- ponowne ustawianie id po sortowaniu
		
	for k,v in ipairs(los_santos_positions) do
		v[1] = k
	end
	
	for k,v in ipairs(las_veturas_positions) do
		v[1] = k
	end
	
	for k,v in ipairs(san_fierro_positions) do
		v[1] = k
	end
	hudZoom = exports["ms-hud"]:getInterfaceZoom()
	bgPosHUD = {x=screenW-(560/hudZoom), y=50/hudZoom+220/hudZoom, w=535/hudZoom, h=120/hudZoom}
	
	outputDebugString("[ms-truck] Wczytano ".. positions_count .." pozycji")
end
addEventHandler( "onClientResourceStart", resourceRoot, onTruckLoad)

function getMoneyFromDistance(distance, multiplier)
	return tostring(math.max(math.floor((distance + (distance * multiplier-1))/1.2)))
end

function getExpFromDistance(distance, multiplier)
	return tostring(math.max(math.floor((distance/100 + distance/100 * multiplier-1)/2.5)))
end


function truckSpeditionStart(player, vehicle, trailer)
	truck_vehicle = vehicle
	truck_trailer = trailer
	
	
	if city_pickup == "LS" then
		target_position = los_santos_positions[track_id][4]
	elseif city_pickup == "LV" then
		target_position = las_veturas_positions[track_id][4]
	elseif city_pickup == "SF" then
		target_position = san_fierro_positions[track_id][4]
	end
	
	truck_checpoint = createMarker(target_position[1], target_position[2], target_position[3], "checkpoint", 8, 255, 0, 0, 255)
	truck_mapicon = createBlip(target_position[1], target_position[2], target_position[3], 41)
	

	setElementData(truck_mapicon, 'blipIcon', 'mission_target')
	setElementData(truck_mapicon, 'exclusiveBlip', true)
	setElementData(localPlayer, 'player:job', 'truck_spedition')
	setElementData(localPlayer, "player:status", "Praca: Spedycja lądowa")
	setElementDimension(truck_mapicon, 1011)
	setElementDimension(truck_checpoint, 1011)
	addEventHandler ( "onClientMarkerHit", truck_checpoint, truckSpeditionTrackEnd)
	toggleTruckSpeditionHUD(true)
	
	addEventHandler("onClientVehicleExit", truck_vehicle,
   function(thePlayer, seat)
		truckSpeditionJobEnd(true)
   end
	)
end
addEvent("truckSpeditionStart", true)
addEventHandler("truckSpeditionStart", getRootElement(), truckSpeditionStart)

function truckSpeditionTrackEnd(hit, dim)
	if hit ~= localPlayer then return end
	
	local vehicle_hit = getPedOccupiedVehicle(hit)
	
	
	if hit and vehicle_hit == truck_vehicle then
		truckSpeditionJobEnd(false)
	else
		triggerEvent("onClientAddNotification", localPlayer, "Wjedź tutaj ciężarówką!", "error")
	end
end


function truckSpeditionJobEnd(failed)	
	if not failed then
		local distance_info = false
		local multiplier_info = product_names[product_id][3]
		
		if city_pickup == "LS" then
			distance_info = los_santos_positions[track_id][3]
		elseif city_pickup == "LV" then
			distance_info = las_veturas_positions[track_id][3]
		elseif city_pickup == "SF" then
			distance_info = san_fierro_positions[track_id][3]
		end	
	
		local money = getMoneyFromDistance(distance_info, multiplier_info)
		local exp = getExpFromDistance(distance_info, multiplier_info)
		
		if distance_info > 1500 then
			triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "player:did_jobs", 1)
			triggerServerEvent("addPlayerStats", localPlayer, localPlayer, "job_points:truck", 1)
		else
			triggerEvent("onClientAddNotification", localPlayer, "Nie otrzymałeś punktu z powodu zbyt krótkiej trasy aby otrzymać punkt pokonaj trasę co najmniej 1500 m.", "warning")
		end
		
		if not failed then
			if getElementData(localPlayer, "player:premium") then 
				triggerEvent("onClientAddNotification", localPlayer, "Dowiozłeś towar! Otrzymujesz ".. math.floor(money + money * 0.3) .."$ oraz ".. math.floor(exp + exp * 0.3) .." exp", "success")
			else
				triggerEvent("onClientAddNotification", localPlayer, "Dowiozłeś towar! Otrzymujesz ".. money .. "$ oraz ".. exp .. " exp", "success")
			end
		end
		triggerServerEvent("giveRewardForTruckSpedition", localPlayer, localPlayer, math.floor(money), math.floor(exp))
	end
	
	destroyElement(truck_mapicon)
	destroyElement(truck_checpoint)
	
	track_id = nil
	product_id = nil
	truck_vehicle = nil
	truck_checpoint = nil
	truck_mapicon = nil
	
	triggerServerEvent("deleteTruckVehicle", localPlayer, localPlayer)
	triggerServerEvent("changeTruckWorld", localPlayer, localPlayer, 0)
	setElementData(localPlayer, "player:job", nil)
	setElementData(localPlayer, "player:status", "W grze")
	toggleTruckSpeditionHUD(false)
	
	if failed then
		triggerEvent("onClientAddNotification", localPlayer, "Zlecenie nie zostało wykonane poprawnie! Prawdopodobnie uszkodziłeś pojazd lub go opuściłeś.", "warning")
	end
end
addEvent("endTruckJob", true)
addEventHandler("endTruckJob", getRootElement(), truckSpeditionJobEnd)

addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), 
	function()
		if getElementData(source, 'player:job') == 'truck_spedition' then
			truckSpeditionJobEnd(true)
		end
	end
)

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
   if source == truck_vehicle and not attacker then
		local vehicle_health = getElementHealth(source)/10

		if vehicle_health < 80 then
			truckSpeditionJobEnd(true)
		end
   end
end
addEventHandler("onClientVehicleDamage", getRootElement(), handleVehicleDamage)

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function truckSpeedLimit()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if vehicle and getElementModel(vehicle) == 455 then
		if getElementSpeed(vehicle, "km/h") > speed_limit then
			local vx, vy, vz = getElementVelocity(vehicle)
			setElementVelocity(vehicle, vx*0.99, vy*0.99, vz)
		end
	end
end


addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() and getElementModel(source) == 455 then
            speed_timer = setTimer(truckSpeedLimit, 100, 0)
        end
    end
)

addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
       if thePlayer == getLocalPlayer() and getElementModel(source) == 455 then
            killTimer(speed_timer)
        end
    end
)