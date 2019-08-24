--[[
	MultiServer 
	Zasób: ms-vehicle_shop/c.lua
	Opis: Sklep z pojazdami. Pozostałość z MS RPG.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local bgWindow = {x=screenW/2-500/zoom/2, y=screenH/2-200/zoom/2, w=500/zoom, h=200/zoom}

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

function onWindowConfirmClick(button, state)
	if button == "left" and state == "up" then 
		local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
		x = x+bgWindow.w/2-w/2-100/zoom
		if isCursorOnElement(x, y, w, h) then
			triggerServerEvent("onPlayerBuyVehicle", localPlayer, vehicleShop.selectedVehicle, vehicleShop.tableByCategory[vehicleShop.selectedCategory][vehicleShop.selectedVehicleIndex]["price"])
			toggleConfirmWindow(false)
			vehicleShop:destroy()
			return
		end
		
		local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
		x = x+bgWindow.w/2-w/2+100/zoom
		if isCursorOnElement(x, y, w, h) then
			toggleConfirmWindow(false)
			return
		end
	end
end

function toggleConfirmWindow(toggle)
	if toggle == true then
		if confirm_window then return end 
		addEventHandler("onClientRender", getRootElement(), renderToggleWindow)
		addEventHandler("onClientClick", getRootElement(), onWindowConfirmClick)
		window_font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 28/zoom, false, "cleartype") or "default-bold"
		window_font2 = dxCreateFont(":ms-dashboard/fonts/archivo_narrow.ttf", 28/zoom, false, "cleartype") or "default-bold"
		showCursor(true)
		guiSetInputMode("no_binds")
		confirm_window = true
	else
		removeEventHandler("onClientRender", getRootElement(), renderToggleWindow)
		removeEventHandler("onClientClick", getRootElement(), onWindowConfirmClick)
		if window_font then destroyElement(window_font) end
		if window_font2 then destroyElement(window_font2) end
		exports["ms-gui"]:destroyEditBox(cash_edit)
		showCursor(false)
		guiSetInputMode("allow_binds")
		confirm_window = false
	end
end

function renderToggleWindow()
	exports["ms-gui"]:dxDrawBluredRectangle(bgWindow.x, bgWindow.y, bgWindow.w, bgWindow.h, tocolor(170, 170, 170, 255), false)
	dxDrawRectangle(bgWindow.x, bgWindow.y, bgWindow.w, bgWindow.h-150/zoom, tocolor(30, 30, 30, 100), true) 
	dxDrawText("Potwierdzenie", bgWindow.x, bgWindow.y+10/zoom, bgWindow.x+bgWindow.w, bgWindow.x+bgWindow.y, tocolor(230, 230, 230, 230), 0.6, window_font2, "center", "top", false, true, true)
	dxDrawText("Czy chcesz kupić "..tostring(getVehicleName(vehicleShop.previewVehicle) or "...").." za "..tostring(comma_value(vehicleShop.tableByCategory[vehicleShop.selectedCategory][vehicleShop.selectedVehicleIndex]["price"])).."$?", bgWindow.x+45/zoom, bgWindow.y+70/zoom, bgWindow.x+bgWindow.w-50/zoom, bgWindow.x+bgWindow.y-50/zoom, tocolor(230, 230, 230, 230), 0.5, window_font2, "center", "top", false, true, true)
	local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
	x = x+bgWindow.w/2-w/2-100/zoom
	if isCursorOnElement(x, y, w, h) then
		dxDrawRectangle(x, y, w, h, tocolor(30, 255, 30, 100), true) 
	else
		dxDrawRectangle(x, y, w, h, tocolor(30, 255, 30, 50), true) 
	end
	dxDrawText("KUP", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.7, window_font, "center", "center", false, true, true)
	
	local x, y, w, h = bgWindow.x, bgWindow.y+bgWindow.h-75/zoom, 120/zoom, 50/zoom
	x = x+bgWindow.w/2-w/2+100/zoom
	if isCursorOnElement(x, y, w, h) then
		dxDrawRectangle(x, y, w, h, tocolor(255, 30, 30, 100), true) 
	else
		dxDrawRectangle(x, y, w, h, tocolor(255, 30, 30, 50), true) 
	end
	
	dxDrawText("ANULUJ", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.7, window_font, "center", "center", false, true, true)
end

function sortByType(tbl, whatToSort)
	local temp = {}
	for k,v in ipairs(tbl) do
		if v["type"] == whatToSort then
			table.insert(temp, v)
		end
	end

	table.sort(temp, function(a, b) return a["price"] < b["price"] end)
	return temp
end

function getDriveType(type)
	if type == "rwd" then
		return "Tylny napęd"
	elseif type == "fwd" then
		return "Przedni napęd"
	elseif type == "awd" then
		return "4x4"
	end
end

class "CVehicleShop"
{
	__init__ = function(self, vehicles, playerVehicles)
		self.show = false
		self.showWindow = false
		self.playerVehicles = playerVehicles or {} 
		
		self.vehicles = vehicles
		self.sportVehicles = sortByType(self.vehicles, "sport")
		self.casualVehicles = sortByType(self.vehicles, "casual")
		self.motorbikes = sortByType(self.vehicles, "motor")
		self.bikes = sortByType(self.vehicles, "bike")
		self.categories = {"POJAZDY SPORTOWE", "POJAZDY ZWYKŁE", "MOTORY", "ROWERY"}
		self.tableByCategory =
		{
			[1] = self.sportVehicles,
			[2] = self.casualVehicles,
			[3] = self.motorbikes,
			[4] = self.bikes
		}

		self.selectedCategory = 1
		self.selectedVehicle = 0
		self.selectedVehicleIndex = 1
		
		font = dxCreateFont(":ms-dashboard/fonts/BebasNeue.otf", 30/zoom)
		
		setElementData(localPlayer, "block:player_teleport", true)
		
		self.previewVehicle = createVehicle(411, 2121.01,-1136.02,25.2)
		setElementDimension(self.previewVehicle, 1)
		setTimer(setVehicleColor, 200, 1, self.previewVehicle, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255) -- bug: nie ustawia koloru od razu po stworzeniu
		setElementRotation(self.previewVehicle, 0, 0, 270)

		self.renderFunc = function() self:onRender() end
		self.keysFunc = function(a, b) self:handleKeys(a, b) end
		addEventHandler("onClientRender", root, self.renderFunc)
		addEventHandler("onClientKey", root, self.keysFunc)

		triggerEvent("onClientShowHUD", localPlayer, false)
		
		setCameraMatrix(2129.7021484375, -1131.2730712891, 25.88279914856, 2128.8640136719, -1131.8024902344, 25.751926422119)
	end,

	destroy = function(self)
		removeEventHandler("onClientKey", root, self.keysFunc)
		fadeCamera(false, 0.5)
		setTimer(
		function()
			vehicleShop = false
			toggleAllControls(true)
			fadeCamera(true, 0.5)
			showCursor(false)
			removeEventHandler("onClientRender", root, self.renderFunc)
			triggerEvent("onClientShowHUD", localPlayer, true)
			if font then 
				destroyElement(font)
			end 
			if self.blurCategory then 
				exports["ms-blur"]:destroyBlurBox(self.blurCategory)
			end
			if self.blurStats then 
				exports["ms-blur"]:destroyBlurBox(self.blurStats)
			end
			setCameraTarget(localPlayer, localPlayer)
			setElementDimension(localPlayer, 0)
			destroyElement(self.previewVehicle)
			setElementData(localPlayer, "block:player_teleport", false)
		end, 500, 1)
	end,

	handleKeys = function(self, key, press)
		if press and key ~= "mouse1" then 
			if confirm_window then
				toggleConfirmWindow(false)
			end
		end 
		
		if key == "escape" and press then
			self:destroy()
			cancelEvent()
		elseif key == "arrow_u" and press then
			self.selectedCategory = self.selectedCategory-1
			if self.selectedCategory < 1 then self.selectedCategory = 4 end

			self.selectedVehicleIndex = 1
			setElementFrozen(self.previewVehicle, true)
			setElementPosition(self.previewVehicle, 2121.01,-1136.02,25.2)
			setTimer(setElementFrozen, 50, 1, self.previewVehicle, false)
		elseif key == "arrow_d" and press then
			self.selectedCategory = self.selectedCategory+1
			if self.selectedCategory > 4 then self.selectedCategory = 1 end

			self.selectedVehicleIndex = 1
			setElementFrozen(self.previewVehicle, true)
			setElementPosition(self.previewVehicle, 2121.01,-1136.02,25.2)
			setTimer(setElementFrozen, 50, 1, self.previewVehicle, false)
		elseif key == "arrow_l" and press then
			self.selectedVehicleIndex = self.selectedVehicleIndex-1
			if self.selectedVehicleIndex < 1 then
				self.selectedVehicleIndex = #self.tableByCategory[self.selectedCategory]
			end
			setElementFrozen(self.previewVehicle, true)
			setElementPosition(self.previewVehicle, 2121.01,-1136.02,25.2)
			setTimer(setElementFrozen, 50, 1, self.previewVehicle, false)
		elseif key == "arrow_r" and press then
			self.selectedVehicleIndex = self.selectedVehicleIndex+1
			if self.selectedVehicleIndex > #self.tableByCategory[self.selectedCategory] then
				self.selectedVehicleIndex = 1
			end
			setElementFrozen(self.previewVehicle, true)
			setElementPosition(self.previewVehicle, 2121.01,-1136.02,25.2)
			setTimer(setElementFrozen, 50, 1, self.previewVehicle, false)
		elseif key == "enter" and press then
			local money = getElementData(localPlayer, "player:money")
			if money < self.tableByCategory[self.selectedCategory][self.selectedVehicleIndex]["price"] then
				triggerEvent("onClientAddNotification", localPlayer, "Masz za mało pieniędzy by kupić ten pojazd!", "error", 3000)
				return
			end

			local level = getElementData(localPlayer, "player:level") or 1
			if level < 5 then 
				triggerEvent("onClientAddNotification", localPlayer, "Musisz mieć conajmniej 5 level by kupić pojazd!", "error", 3000)
				return
			end 
			
			if #self.playerVehicles > 5 then 
				triggerEvent("onClientAddNotification", localPlayer, "Możesz posiadać maksymalnie 5 prywatnych pojazdów.", "error")
				return
			end 
			
			toggleConfirmWindow(true)
			--self:destroy()
		end
	end,

	onRender = function(self)
		self.selectedVehicle = self.tableByCategory[self.selectedCategory][self.selectedVehicleIndex]["model"]
		if self.previewVehicle then
			setElementModel(self.previewVehicle, self.selectedVehicle)
			self.previewVehicleHandling = getVehicleHandling(self.previewVehicle)
		end

		local x, y, w, h = screenW-350/zoom, screenH/2, 300/zoom, dxGetFontHeight(0.85, font)+5/zoom
		for k, v in ipairs(self.categories) do
			y = y+h
			
			exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255))
			if self.selectedCategory == k then 
				dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 200), true)
			end
			dxDrawText(v, x+20/zoom, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.7, font, "left", "center", false, false, true)
		end
		
		local name = getVehicleNameFromModel(self.selectedVehicle)
		local price = "$"..tostring(comma_value(self.tableByCategory[self.selectedCategory][self.selectedVehicleIndex]["price"]))
			
		local w = dxGetTextWidth(name, 0.8, font)+dxGetTextWidth(price, 0.8, font)+60/zoom
		local x, y, h = screenW-w-50/zoom, screenH-200/zoom, 75/zoom
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255), true)
		
		dxDrawText(tostring(name), x+20/zoom, y, w, y+h, tocolor(255, 255, 255, 255), 0.8, font, "left", "center", false, false, true, false, false)
		dxDrawText(price, x+w-dxGetTextWidth(price, 0.8, font)-20/zoom, y, w, y+h, tocolor(51, 102, 255, 220), 0.8, font, "left", "center", false, false, true, false, false)
		
		local x, y, w, h = screenW-500/zoom, 50/zoom, 450/zoom, 110/zoom
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(200, 200, 200, 255), true)
		dxDrawText("#3366FFSTRZAŁKI #FFFFFF- wybór pojazdu/kategorii \n#3366FFENTER #FFFFFF- kupno pojazdu\n#3366FFESC#FFFFFF - wyjście", x, y+15/zoom, x+w, y+h, tocolor(255, 255, 255, 255), 0.6, font, "center", "top", false, false, true, true, false)
		
		--dxDrawText(, self.statsCategory.x, self.statsCategory.y+5/zoom, self.statsCategory.w+self.statsCategory.x, self.statsCategory.h, tocolor(220, 220, 220, 220), 1, font, "center", "top", false, false, true, false, false)
		--dxDrawText("$"..tostring(comma_value(self.tableByCategory[self.selectedCategory][self.selectedVehicleIndex]["price"])), self.statsCategory.x, self.statsCategory.y+45/zoom, self.statsCategory.x+self.statsCategory.w, self.statsCategory.h, tocolor(46, 204, 113, 220), 0.9, font, "center", "top", false, false, true, false, false)
		
		--dxDrawText("10", self.statsCategory.x+485/zoom, self.statsCategory.y+29/zoom, self.statsCategory.w+self.statsCategory.x-200/zoom, self.statsCategory.h, tocolor(220, 220, 220, 220), 0.9, font, "center", "top", false, false, true, false, false)
		
		--dxDrawImage(self.statsCategory.x+310/zoom, self.statsCategory.y+16/zoom, 64/zoom, 64/zoom, ":ms-scoreboard/img/circle.png", 0, 0, 0, tocolor(51, 102, 255, 255), true)
		
		--[[
		dxDrawImage(503*sx, (-2)*sy, 360*sx, 167*sy, ":ms-vehicle_shop/i/info_back.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(1044*sx, 195*sy, 295*sx, 246*sy, ":ms-vehicle_shop/i/category_back.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText("Wybierz kategorię", 1079*sx, 212*sy, 1327*sx, 257*sy, tocolor(255, 255, 255, 255), 1.00, font0, "left", "top", false, false, false, false, false)
        dxDrawRectangle(1058*sx, (259+38*(self.selectedCategory-1))*sy, 268*sx, 35*sy, tocolor(18, 117, 240, 105), false)
		for k,v in ipairs(self.categories) do
			dxDrawText(v, 1087*sx, (265+38*(k-1))*sy, 1303*sx, 311*sy, tocolor(255, 255, 255, 255), 1.00, font1, "center", "top", false, false, true, false, false)
		end

        dxDrawText(getVehicleNameFromModel(self.selectedVehicle), 530*sx, 21*sy, 843*sx, 57*sy, tocolor(18, 117, 240, 255), 1.00, font2, "center", "top", false, false, false, false, false)
        dxDrawText("Maksymalna prędkość: "..tostring(self.previewVehicleHandling["maxVelocity"]).." km/h\nNapęd: "..getDriveType(self.previewVehicleHandling["driveType"]), 529*sx, 59*sy, 842*sx, 83*sy, tocolor(255, 255, 255, 255), 1.00, font3, "left", "top", false, false, false, false, false)
        dxDrawText("$"..tostring(self.tableByCategory[self.selectedCategory][self.selectedVehicleIndex]["price"]), 616*sx, 113*sy, 759*sx, 144*sy, tocolor(255, 255, 255, 255), 1.00, font4, "center", "top", false, false, false, false, false)

        dxDrawImage(463*sx, 584*sy, 441*sx, 120*sy, ":ms-interact/i/tut_box.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText("STRZAŁKI - wybór pojazdu/kategorii \nENTER - kupno pojazdu\nESC - wyjście", 458*sx, 605*sy, 908*sx, 694*sy, tocolor(255, 255, 255, 255), 1.00, font1, "center", "top", false, false, true, false, false)
		--]]
	end,
}

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

function dxDrawCircle( posX, posY, radius, width, angleAmount, startAngle, stopAngle, color, postGUI )
	if ( type( posX ) ~= "number" ) or ( type( posY ) ~= "number" ) then
		return false
	end
 
	local function clamp( val, lower, upper )
		if ( lower > upper ) then lower, upper = upper, lower end
		return math.max( lower, math.min( upper, val ) )
	end
 
	radius = type( radius ) == "number" and radius or 50
	width = type( width ) == "number" and width or 5
	angleAmount = type( angleAmount ) == "number" and angleAmount or 1
	startAngle = clamp( type( startAngle ) == "number" and startAngle or 0, 0, 360 )
	stopAngle = clamp( type( stopAngle ) == "number" and stopAngle or 360, 0, 360 )
	color = color or tocolor( 255, 255, 255, 200 )
	postGUI = type( postGUI ) == "boolean" and postGUI or false
 
	if ( stopAngle < startAngle ) then
		local tempAngle = stopAngle
		stopAngle = startAngle
		startAngle = tempAngle
	end
 
	for i = startAngle, stopAngle, angleAmount do
		local startX = math.cos( math.rad( i ) ) * ( radius - width )
		local startY = math.sin( math.rad( i ) ) * ( radius - width )
		local endX = math.cos( math.rad( i ) ) * ( radius + width )
		local endY = math.sin( math.rad( i ) ) * ( radius + width )
 
		dxDrawLine( startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI )
	end
 
	return true
end

function onPlayerEnterVehicleShop(vehicles)
	if vehicleShop then return end 
	setElementDimension(localPlayer, 1)
	vehicleShop = CVehicleShop(vehicles)
end
addEvent("onPlayerEnterVehicleShop", true)
addEventHandler("onPlayerEnterVehicleShop", root, onPlayerEnterVehicleShop)

function onStop()
	setCameraTarget(localPlayer, localPlayer)
	if getElementDimension(localPlayer) == 1 then
		setElementDimension(localPlayer, 0)
		toggleAllControls(true)
	end
end
addEventHandler("onClientResourceStop", resourceRoot, onStop)