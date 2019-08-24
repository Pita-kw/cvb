local lists = {} 
local activeList = false 


local LIST_DATA_OFFSETX = 10
local LIST_DATA_OFFSETY = 5
local LIST_TITLE_OFFSET = 7.5

function createList(bgX, bgY, bgW, bgH, color, font, fontSize, scrollWidth, scrollColor)
	if bgX and bgY and bgW and bgH and color and font and fontSize then 
		table.insert(lists, {x=math.floor(bgX), y=math.floor(bgY), w=math.floor(bgW), h=math.floor(bgH), font=font, fontSize=fontSize, color=color, columns={}, items={}, renderTarget=false,
								  scroll=createScroll(bgX+bgW-scrollWidth, bgY, scrollWidth, bgH, color, bgY, bgH, scrollColor or {51, 102, 255, 255}), scrollWidth=scrollWidth, scrollColor=scrollColor or {51, 102, 255, 255}, selectedIndex=false, selectedItems={}})
		return #lists
	else 
		return false 
	end
end 

function reloadListRT(list)
	local listData = lists[list]
	if listData then 
		local descHeight = math.floor(dxGetFontHeight(listData.fontSize-0.1, listData.font)+LIST_TITLE_OFFSET)
		local offset = math.floor((dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY))
		local contentSize = descHeight*2 + math.floor(dxGetFontHeight(listData.fontSize+0.03, listData.font)+LIST_DATA_OFFSETY) * (math.floor(#listData.items / #listData.columns)) 
		
		if isElement(listData.renderTarget) then 
			destroyElement(listData.renderTarget)
		end
		
		listData.renderTarget = dxCreateRenderTarget(listData.w, math.max(listData.h, contentSize), true)
		
		setScrollWindowSize(listData.scroll, listData.h)
		setScrollContentSize(listData.scroll, math.max(listData.h, contentSize))
	end
end 

function addListColumn(list, name, width)
	local listData = lists[list]
	if listData and name and width then 
		local offset = 0 
		if #listData.columns > 0 then 
			for k, v in ipairs(listData.columns) do 
				offset = offset + (v.width * listData.w)
			end 
			
			--offset = listData.columns[math.max(1, #listData.columns-1)].width * listData.w
		end 
		
		table.insert(listData.columns, {name=name, width=width, offsetX=math.floor(offset)})
	end
end 

function addListItem(list, columnName, itemName)
	local listData = lists[list]
	if listData and itemName then 
		table.insert(listData.items, {name=itemName, columnName=columnName, color={240, 240, 240}})
		
		local descHeight = math.floor(dxGetFontHeight(listData.fontSize-0.1, listData.font)+LIST_TITLE_OFFSET)
		local offset = math.floor((dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY))
		local contentSize = descHeight*2 + math.floor(dxGetFontHeight(listData.fontSize+0.03, listData.font)+LIST_DATA_OFFSETY) * (math.floor(#listData.items / #listData.columns)) 
		
		setScrollWindowSize(listData.scroll, listData.h)
		setScrollContentSize(listData.scroll, math.max(listData.h, contentSize))
		
		return #listData.items
	end
end

function getSelectedListIndexPosition(list)
	local listData = lists[list]
	if listData then 
		local index = listData.selectedIndex
		if index then 
			local descHeight = dxGetFontHeight(listData.fontSize-0.1, listData.font)+LIST_TITLE_OFFSET
			local offsetY = descHeight + (dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY)*(index-1)
			local x, y = listData.x+LIST_DATA_OFFSETX, listData.y+offsetY-2
			
			return x, y
		else 
			return false
		end
	end
	
	return false
end

function getSelectedListItemsCount(list)
	local listData = lists[list]
	if listData then 
		return math.floor(#listData.selectedItems / #listData.columns)
	end 
	
	return 0
end 

function getSelectedListItemsIndex(list)
	local listData = lists[list]
	if listData then 
		local items = {}
		local columnName = listData.columns[1].name

		for k, itemIndex in ipairs(listData.selectedItems) do
			local itemData = listData.items[itemIndex]
			itemIndex = math.ceil(itemIndex / #listData.columns) 
			if itemData.columnName == columnName then 
				table.insert(items, itemIndex)
			end
		end
		
		return items
	end
	
	return false
end

function setListItemColor(list, item, r, g, b)
	local listData = lists[list] 
	if listData and item then 
		listData.items[item].color = {r, g, b}
		return true
	end
	return false
end 

function setListActive(list, bool)
	if lists[list] then 
		if bool == true then
			activeList = list
		else 
			activeList = false 
		end
	end
end 

function clearList(list)
	local listData = lists[list]
	if listData then 
		listData.items = {}
		resetScroll(listData.scroll)
		reloadListRT(list)
	end
end 

function renderList(list)
	local listData = lists[list]
	if listData then 
		local descHeight = math.floor(dxGetFontHeight(listData.fontSize-0.1, listData.font)+LIST_TITLE_OFFSET)
		dxDrawRectangle(listData.x, listData.y, listData.w, listData.h, listData.color, true)
		
		-- kreska pod kolumnami 
		dxDrawRectangle(listData.x+2, listData.y+descHeight-LIST_TITLE_OFFSET/1.5, listData.w-listData.scrollWidth-7, 1,  tocolor(150, 150, 150, 150), true)
		
		--listData.highlighted = false 
		
		renderScroll(listData.scroll)
		
		if isElement(listData.renderTarget) then
			local rtW, rtH = dxGetMaterialSize(listData.renderTarget)
			local scrollY = getScrollProgress(listData.scroll) * (math.max(1, rtH-listData.h+LIST_TITLE_OFFSET))
			
			dxSetRenderTarget(listData.renderTarget, true)
			dxSetBlendMode("modulate_add")
			for index, columnData in pairs(listData.columns) do 
				local columnName = columnData.name
				local index = 0
				for itemIndex, itemData in ipairs(listData.items) do 
					if itemData.columnName == columnName then 
						index = index+1
						
						if listData.scroll then 
							local offsetY = math.floor((dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY)*(index-1))
					
							local x, y, w, h = columnData.offsetX, (offsetY-LIST_DATA_OFFSETY/2)+1, listData.w-listData.scrollWidth-5, dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY-1
							local isSelected = false
							for k, selectedItem in ipairs(listData.selectedItems) do
								if selectedItem == itemIndex then 
									isSelected = k
								end
							end
							
							local itemR, itemG, itemB = itemData.color[1], itemData.color[2], itemData.color[3]
							
							if isSelected then 
								listData.selectedIndex = index
							
								if itemData.columnName == listData.columns[1].name then 
									dxDrawRectangle(x, y, w, h, tocolor(listData.scrollColor[1], listData.scrollColor[2], listData.scrollColor[3], listData.scrollColor[4]))
								end 
									
								if type(itemData.name) == "table" then 
									if itemData.name.img then 
										local size = math.floor(dxGetFontHeight(listData.fontSize, listData.font))
										dxDrawImage(columnData.offsetX+LIST_DATA_OFFSETX, offsetY, size, size, itemData.name.img,  0, 0, 0, tocolor(itemR, itemG, itemB, 255))
										if itemData.name.text then 
											dxDrawText(itemData.name.text, columnData.offsetX+LIST_DATA_OFFSETX+size+5, offsetY, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(itemR, itemG, itemB, 255), listData.fontSize, listData.font, "left", "top", false, false)
										end
									end 
								else
									dxDrawText(itemData.name, columnData.offsetX+LIST_DATA_OFFSETX, offsetY, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(itemR, itemG, itemB, 230), listData.fontSize, listData.font, "left", "top", false, false)
								end
							elseif isCursorOnElement(listData.x+x, listData.y+y+descHeight-scrollY, w, h) and isCursorOnElement(listData.x, listData.y+descHeight, listData.w, listData.h-descHeight) then 
								if itemData.columnName == listData.columns[1].name then 
									dxDrawRectangle(x, y, w, h, tocolor(150, 150, 150, 150))
									
									local items = {}
									local nextItemInColumn = itemIndex-1
									local startItem = itemIndex-1
									repeat 
										nextItemInColumn = nextItemInColumn+1
										table.insert(items, nextItemInColumn)
									until listData.items[nextItemInColumn] == nil or nextItemInColumn == startItem+#listData.columns
												
									listData.highlighted = {items, index}
								end 			
									
								if type(itemData.name) == "table" then 
									if itemData.name.img then 
										local size = math.floor(dxGetFontHeight(listData.fontSize, listData.font))
										dxDrawImage(columnData.offsetX+LIST_DATA_OFFSETX, offsetY, size, size, itemData.name.img,  0, 0, 0, tocolor(itemR, itemG, itemB, 255))
										if itemData.name.text then 
											dxDrawText(itemData.name.text, columnData.offsetX+LIST_DATA_OFFSETX+size+5, offsetY, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(itemR, itemG, itemB, 255), listData.fontSize, listData.font, "left", "top", false, false)
										end
									end 
								else 
									dxDrawText(itemData.name, columnData.offsetX+LIST_DATA_OFFSETX, offsetY, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(itemR, itemG, itemB, 255), listData.fontSize, listData.font, "left", "top", false, false)
								end
							else 
								if type(itemData.name) == "table" then 
									if itemData.name.img then 
										local size = math.floor(dxGetFontHeight(listData.fontSize, listData.font))
										dxDrawImage(columnData.offsetX+LIST_DATA_OFFSETX, offsetY, size, size, itemData.name.img,  0, 0, 0, tocolor(itemR, itemG, itemB, 255))
										if itemData.name.text then 
											dxDrawText(itemData.name.text, columnData.offsetX+LIST_DATA_OFFSETX+size+5, offsetY, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(itemR, itemG, itemB, 255), listData.fontSize, listData.font, "left", "top", false, false)
										end
									end 
								else 
									dxDrawText(itemData.name, columnData.offsetX+LIST_DATA_OFFSETX, offsetY, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(itemR, itemG, itemB, 255), listData.fontSize, listData.font, "left", "top", false, false)
								end
							end
						end 
					end
				end
			end
			dxSetBlendMode("blend")
			dxSetRenderTarget()
			
			dxDrawImageSection(listData.x, listData.y+descHeight, listData.w, listData.h-descHeight, 0, scrollY, listData.w, listData.h-descHeight, listData.renderTarget, 0, 0, 0, tocolor(255,255,255,255), true)
		end
		
		if #listData.items == 0 then 
			dxDrawText("Brak danych", listData.x, listData.y, listData.x+listData.w, listData.y+listData.h, tocolor(150, 150, 150, 150), listData.fontSize, listData.font, "center", "center", false, false, true)
		end 
		
		for index, columnData in pairs(listData.columns) do 
			dxDrawText(columnData.name, listData.x+columnData.offsetX+LIST_DATA_OFFSETX, listData.y+2, columnData.offsetX-LIST_DATA_OFFSETY, listData.h, tocolor(200, 200, 200, 200), listData.fontSize-0.1, listData.font, "left", "top", false, false, true)
		end 
		
		if #listData.selectedItems == 0 then 
			listData.selectedIndex = false
		end
	end
end

function keyList(key, state)
	if key == "mouse1" and state and lists[activeList] then 
		local listData = lists[activeList]
		if listData.highlighted then 
			listData.selectedItems = {}
			
			local index = listData.highlighted[2]
			for k, itemIndex in ipairs(listData.highlighted[1]) do 
				local descHeight = dxGetFontHeight(listData.fontSize-0.1, listData.font)+LIST_TITLE_OFFSET
				local offsetY = descHeight + (dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY)*(index-1)
				local x, y, w, h = listData.x, listData.y+offsetY-LIST_DATA_OFFSETY/2, listData.w-listData.scrollWidth-5, dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY
				local rtW, rtH = dxGetMaterialSize(listData.renderTarget)
				local scrollY = getScrollProgress(listData.scroll) * (math.max(1, rtH-listData.h+LIST_TITLE_OFFSET))
				if isCursorOnElement(x, y-scrollY, w, h) and isCursorOnElement(listData.x, listData.y+descHeight, listData.w, listData.h-descHeight) then
					table.insert(listData.selectedItems, itemIndex)
				end
			end
			
			return
		end
		
		if listData then 
			local itemsToRemove = {} 

			for k,v in ipairs(listData.selectedItems) do 
				-- policzenie indeksu do sprawdzenia pozycji
				local index = 0 
				local columnName = listData.columns[1].name
				for itemIndex, itemData in ipairs(listData.items) do 
					if itemData.columnName == columnName then 
						if listData.scroll then 
							if index >= listData.currentRow and index <= listData.maxRows then
								index = index+1
							end
						else 
							index = index+1
						end
					end
						
					local descHeight = dxGetFontHeight(listData.fontSize-0.1, listData.font)+LIST_TITLE_OFFSET
					local offsetY = descHeight + (dxGetFontHeight(listData.fontSize, listData.font)+LIST_DATA_OFFSETY)*(index-1)
					local x, y, w, h = listData.x, listData.y+offsetY, listData.w-listData.scrollWidth-5, dxGetFontHeight(listData.fontSize, listData.font)
					if not isCursorOnElement(x, y, w, h) then 
						listData.selectedItems = {}
					end
				end
			end
		end
	elseif key == "mouse_wheel_down" and lists[activeList] then 
		moveScroll(lists[activeList].scroll, "down", 10)
	elseif key == "mouse_wheel_up" and lists[activeList] then 
		moveScroll(lists[activeList].scroll, "up", 10)
	elseif key == "arrow_u" and lists[activeList] and state then
	elseif key == "arrow_d" and lists[activeList] and state then 
	end
end 
addEventHandler("onClientKey", root, keyList, false, "low-5")

function destroyList(list)
	if lists[list] then 
		destroyScroll(lists[list].scroll)
		if isElement(lists[list].renderTarget) then 
			destroyElement(lists[list].renderTarget)
		end 
		
		if list == activeList then 
			activeList = false
		end
		
		lists[list] = false
	end
end
