screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1.0
local minZoom = 1.8
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

function sortByType(tbl, whatToSort)
	local temp = {}
	for k,v in ipairs(tbl) do
		if whatToSort == v["type"] then
			table.insert(temp, v)
		end 
	end

	table.sort(temp, function(a, b) return a["price"] < b["price"] end)
	return temp
end

class "CFurnitureShop"
{
	__init__ = function(self, data)
		self.show = false

		self.furniture = data 
		self.pictures = sortByType(self.furniture, "picture")
		self.armchairs = sortByType(self.furniture, "armchair")
		self.sofas = sortByType(self.furniture, "sofa")
		self.chairs = sortByType(self.furniture, "chair")
		self.benches = sortByType(self.furniture, "bench")
		self.desks = sortByType(self.furniture, "desk")
		self.beds = sortByType(self.furniture, "bed")
		self.wardrobes = sortByType(self.furniture, "wardrobe")
		self.plants = sortByType(self.furniture, "plant")
		self.toilet = sortByType(self.furniture, "toilet")
		self.electronic = sortByType(self.furniture, "electronic")
		self.lamps = sortByType(self.furniture, "lights")
		
		self.categories = {"OBRAZY", "FOTELE", "KANAPY", "KRZESŁA", "ŁAWY", "BIURKA", "ŁÓŻKA", "SZAFY", "ROŚLINY", "ŁAZIENKA", "ELEKTRONIKA", "LAMPY"}
		self.tableByCategory =
		{
			[1] = self.pictures,
			[2] = self.armchairs,
			[3] = self.sofas,
			[4] = self.chairs,
			[5] = self.benches,
			[6] = self.desks, 
			[7] = self.beds,
			[8] = self.wardrobes,
			[9] = self.plants,
			[10] = self.toilet,
			[11] = self.electronic,
			[12] = self.lamps
		}
		self.friendlyNames = 
		{
			"obraz",
			"fotel",
			"kanapa",
			"krzesło",
			"ława",
			"biurko",
			"łóżko",
			"szafa",
			"roślina",
			"toaleta",
			"elektronika",
			"lampa"
		}
		
		self.selectedCategory = 1
		self.selectedFurniture = 0
		self.selectedFurnitureIndex = 1
		
		font = dxCreateFont("archivo_narrow.ttf", 22/zoom)
		
		self.startInterior = getElementInterior(localPlayer)
		
		self.object = createObject(self.pictures[1]["model"], 1393.26, -16.71, 1000.7)
		setElementInterior(self.object, 1)
		setElementDimension(self.object, getElementDimension(self.object))
		setElementInterior(localPlayer, 1)
		setElementFrozen(localPlayer, true)
		setElementDoubleSided(self.object, true)
		setObjectScale(self.object, 0.4)
		setOcclusionsEnabled(false)
		setSkyGradient(0, 0, 0, 0, 0, 0, 0)
		setCameraMatrix(1395.2434082031, -15.975099563599, 1001.2, 1394.3311767578, -16.384677886963, 1001.2)
		setNearClipDistance(0.1)
		
		self.rotTick = getTickCount()+10 
		
		self.bgCategory = {x=screenW - 400/zoom, y=screenH/1.9-431/zoom/2, w=360/zoom, h=500/zoom}
		
		self.bgDescription = {} 
		self.bgDescriptionLine = {} 
		
		self.statsCategory = {x=(screenW/2)-400/zoom/2, y=50/zoom, w=400/zoom, h=90/zoom}
		self.statsCategoryLine = {x=self.statsCategory.x, y=self.statsCategory.h+43/zoom, w=self.statsCategory.w, h=4/zoom} 
		
		self.blurCategory = exports["ms-blur"]:createBlurBox(self.bgCategory.x, self.bgCategory.y, self.bgCategory.w, self.bgCategory.h, 255, 255, 255, 255, false)
		self.blurStats = exports["ms-blur"]:createBlurBox(self.statsCategory.x, self.statsCategory.y, self.statsCategory.w, self.statsCategory.h, 255, 255, 255, 255, false)
		self.blurInfo = exports["ms-blur"]:createBlurBox(screenW-self.statsCategory.w-50/zoom, self.statsCategory.y, self.statsCategory.w, self.statsCategory.h, 255, 255, 255, 255, false)
		
		setElementData(localPlayer, "player:inFurnitureShop", true)
		
		self.renderFunc = function() self:onRender() end
		self.keysFunc = function(a, b) self:handleKeys(a, b) end
		addEventHandler("onClientRender", root, self.renderFunc)
		addEventHandler("onClientKey", root, self.keysFunc)
		
		triggerEvent("onClientShowRadar", localPlayer, false)
	end,

	destroy = function(self)
		setElementData(localPlayer, "player:inFurnitureShop", false)
		fadeCamera(false, 0.5)
		setTimer(
		function()
			toggleAllControls(true)
			fadeCamera(true, 0.5)
			showCursor(false)
			removeEventHandler("onClientKey", root, self.keysFunc)
			removeEventHandler("onClientRender", root, self.renderFunc)
			if isElement(font) then destroyElement(font) end 
			setCameraTarget(localPlayer, localPlayer)
			if isElement(self.object) then destroyElement(self.object) end
			if self.blurCategory then 
				exports["ms-blur"]:destroyBlurBox(self.blurCategory)
			end
			if self.blurStats then 
				exports["ms-blur"]:destroyBlurBox(self.blurStats)
			end
			if self.blur then 
				exports["ms-blur"]:destroyBlurBox(self.blurInfo)
			end
			setTimer(setElementFrozen, 100, 1, localPlayer, false)
			setElementInterior(localPlayer, self.startInterior)
			setOcclusionsEnabled(true)
			resetSkyGradient()
			furniture = false
			
			triggerEvent("onClientShowRadar", localPlayer, true)
		end, 500, 1)
	end,

	handleKeys = function(self, key, press)
		if key == "escape" and press then
			self:destroy()
			cancelEvent()
		elseif key == "arrow_u" and press then
			self.selectedCategory = self.selectedCategory-1
			if self.selectedCategory < 1 then self.selectedCategory = 12 end

			self.selectedFurnitureIndex = 1
		elseif key == "arrow_d" and press then
			self.selectedCategory = self.selectedCategory+1
			if self.selectedCategory > 12 then self.selectedCategory = 1 end

			self.selectedFurnitureIndex = 1
		elseif key == "arrow_l" and press then
			self.selectedFurnitureIndex = self.selectedFurnitureIndex-1
			if self.selectedFurnitureIndex < 1 then
				self.selectedFurnitureIndex = #self.tableByCategory[self.selectedCategory]
			end
		elseif key == "arrow_r" and press then
			self.selectedFurnitureIndex = self.selectedFurnitureIndex+1
			if self.selectedFurnitureIndex > #self.tableByCategory[self.selectedCategory] then
				self.selectedFurnitureIndex = 1
			end
		elseif key == "enter" and press then
			local money = getElementData(localPlayer, "player:money") or 0
			if money < self.tableByCategory[self.selectedCategory][self.selectedFurnitureIndex]["price"] then
				triggerEvent("onClientAddNotification", localPlayer, "Masz za mało pieniędzy by kupić ten mebel!", "error")
				return
			end
			
			triggerServerEvent("onPlayerBuyFurniture", localPlayer, self.selectedFurniture, self.tableByCategory[self.selectedCategory][self.selectedFurnitureIndex]["price"], self.friendlyNames[self.selectedCategory])
		end
	end,

	onRender = function(self)
		self.selectedFurniture = self.tableByCategory[self.selectedCategory][self.selectedFurnitureIndex]["model"]
		
		local now = getTickCount()
		if now >= self.rotTick then 
			local _, _, rotZ = getElementRotation(self.object)
			rotZ = rotZ+1 
			if rotZ >= 360 then rotZ = 0 end 
			setElementRotation(self.object, 0, 0, rotZ)
			self.rotTick = getTickCount()+10
		end 
		
		if self.selectedCategory == 1 then 
			setElementPosition(self.object, 1393.46, -16.81, 1001.2)
		elseif self.selectedCategory == 7 then 
			setElementRotation(self.object, 0, 0, 140)
			setElementPosition(self.object, 1393.66, -16.31, 1000.7)
		elseif self.selectedCategory == 9 then 
			setElementPosition(self.object, 1393.46, -16.81, 1001)
		elseif self.selectedCategory == 12 then 
			setElementPosition(self.object, 1393.46, -16.81, 1001)
		else 
			setElementPosition(self.object, 1393.46, -16.81, 1000.8)
		end 
		
		setElementModel(self.object, self.selectedFurniture)
		setElementStreamable(self.object, false)
		
		--[[
		--dxDrawRectangle(0, 0, screenW, screenH, tocolor(0, 92, 153, 255))
		--dxDrawText("ID: "..tostring(self.selectedFurniture), 530*sx, 21*sy, 843*sx, 57*sy, tocolor(18, 117, 240, 255), 0.8, font, "center", "top", false, false, false, false, false)
        --dxDrawText("$"..tostring(self.tableByCategory[self.selectedCategory][self.selectedFurnitureIndex]["price"]), 616*sx, 113*sy, 759*sx, 144*sy, tocolor(255, 255, 255, 255), 0.7, font, "center", "top", false, false, false, false, false)
		
		dxDrawImage(503*sx, (-2)*sy, 360*sx, 167*sy, ":ms-vehicle_shop/i/info_back.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(1044*sx, 195*sy, 295*sx, 545*sy, ":ms-vehicle_shop/i/category_back.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText("Wybierz kategorię", 1079*sx, 212*sy, 1303*sx, 311*sy, tocolor(255, 255, 255, 255), 1.00, font, "left", "top", false, false, false, false, false)
        dxDrawRectangle(1058*sx, (259+38*(self.selectedCategory-1))*sy, 268*sx, 35*sy, tocolor(18, 117, 240, 105), false)
		for k,v in ipairs(self.categories) do
			dxDrawText(v, 1087*sx, (265+38*(k-1))*sy, 1303*sx, 311*sy, tocolor(255, 255, 255, 255), 0.8, font, "center", "top", false, false, true, false, false)
		end


        dxDrawImage(463*sx, 634*sy, 441*sx, 120*sy, ":ms-interact/i/tut_box.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText("STRZAŁKI - wybór mebla/kategorii\nENTER - kupno mebla\nESC - wyjście", 458*sx, 659*sy, 908*sx, 694*sy, tocolor(255, 255, 255, 255), 0.7, font, "center", "top", false, false, true, false, false) 
		--]]
		
		dxDrawRectangle(self.bgCategory.x, self.bgCategory.y, self.bgCategory.w, self.bgCategory.h, tocolor(30, 30, 30, 140), true)
		dxDrawText("Wybierz kategorię", self.bgCategory.x, self.bgCategory.y+20/zoom, self.bgCategory.w+self.bgCategory.x, self.bgCategory.h, tocolor(220, 220, 220, 220), 0.8, font, "center", "top", false, false, true, false, false)
		dxDrawRectangle(self.bgCategory.x, self.bgCategory.y + 35/zoom + (35*self.selectedCategory-1)/zoom, self.bgCategory.w, 32/zoom, tocolor(30, 30, 30, 140), true)
		dxDrawRectangle(self.bgCategory.x, self.bgCategory.y + 35/zoom + (35*self.selectedCategory-1)/zoom, 5/zoom, 32/zoom, tocolor(51, 102, 255, 255), true)
		for k,v in ipairs(self.categories) do 
			dxDrawText(v, self.bgCategory.x + 20/zoom, self.bgCategory.y + 35/zoom + (35*k-1)/zoom, self.bgCategory.w+self.bgCategory.x, self.bgCategory.h, tocolor(220, 220, 220, 220), 0.7, font, "left", "top", false, false, true, false, false)
		end 
		
		dxDrawRectangle(self.statsCategory.x, self.statsCategory.y, self.statsCategory.w, self.statsCategory.h, tocolor(30, 30, 30, 140), true)
		dxDrawRectangle(self.statsCategoryLine.x, self.statsCategoryLine.y, self.statsCategoryLine.w, self.statsCategoryLine.h, tocolor(51, 102, 255, 255), true)
		
		dxDrawText("ID "..tostring(self.selectedFurniture), self.statsCategory.x, self.statsCategory.y+5/zoom, self.statsCategory.w+self.statsCategory.x, self.statsCategory.h, tocolor(220, 220, 220, 220), 0.8, font, "center", "top", false, false, true, false, false)
		dxDrawText("$"..tostring(self.tableByCategory[self.selectedCategory][self.selectedFurnitureIndex]["price"]), self.statsCategory.x, self.statsCategory.y+40/zoom, self.statsCategory.w+self.statsCategory.x, self.statsCategory.h, tocolor(200, 200, 200, 200), 0.7, font, "center", "top", false, false, true, false, false)
	end,
}

function onPlayerEnterFurnitureShop(data)
	if getElementData(localPlayer, "player:inFurnitureMenu") == true then return end
	if furniture then 
		furniture:destroy()
		return
	end
	if not data then return end 
	furniture = CFurnitureShop(data)
end
addEvent("onPlayerEnterFurnitureShop", true)
addEventHandler("onPlayerEnterFurnitureShop", root, onPlayerEnterFurnitureShop)

function onStop()
	setCameraTarget(localPlayer, localPlayer)
	setElementData(localPlayer, "player:inFurnitureShop", false)
end
addEventHandler("onClientResourceStop", resourceRoot, onStop)

fileDelete("furnitureshop_c.lua")
