GANG_LOGO_CACHE = {} 

local screenW, screenH = guiGetScreenSize() 
local zoom = 1 
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+400)/screenW)
end 

local gangData = false
local loadTimer = false
local showing = false 
local font = false 
local scroll = false 

-- scroll
local MAX_VISIBLE_ROWS = 6
local selectedRow = 1
local visibleRows = MAX_VISIBLE_ROWS

local bgPos = {x=(screenW/2)-(1100/zoom/2), y=(screenH/2)-(550/zoom/2), w=1100/zoom, h=530/zoom}
local bgRow = {x=bgPos.x+30/zoom, w=500/zoom, h=142/zoom}

function showGangList()
	if GANG_DETAILS_SHOWING then return end 
	if showing then 
		destroyGangList()
		return
	end
	
	if not font then 
		font = dxCreateFont("archivo_narrow.ttf", 24/zoom, false, "antialiased")
	end 

	loadTimer = setTimer(function() 
		triggerServerEvent("onPlayerRequestGangData", localPlayer)
	end, 200, 1) 
	
	selectedRow = 1
	visibleRows = MAX_VISIBLE_ROWS
	
	addEventHandler("onClientRender", root, renderGangList)
	addEventHandler("onClientKey", root, scrollGangList)
	showCursor(true)
	showing = true 
end 
addCommandHandler("gangs", showGangList)

function scrollGangList(key, press)
	if key == "mouse_wheel_up" and gangData then 
		exports["ms-gui"]:moveScroll(scroll, "up", 40)
	elseif key == "mouse_wheel_down" and gangData then 
		exports["ms-gui"]:moveScroll(scroll, "down", 40)
	end
end 

function renderGangList()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawText("Lista gangów", bgPos.x, bgPos.y + 10/zoom, bgPos.w+bgPos.x, bgPos.h, tocolor(230, 230, 230, 230), 0.85, font, "center", "top", false, true, true)
	
	if not gangData then 
		exports["ms-gui"]:renderLoading((bgPos.x+bgPos.w/2)-((150/zoom))/2, bgPos.y+100/zoom, 150/zoom, 150/zoom)
		dxDrawText("Ładowanie...", bgPos.x, bgPos.y+10/zoom, bgPos.w+bgPos.x, bgPos.y+bgPos.h, tocolor(230, 230, 230, 230), 0.85, font, "center", "center", false, true, true)
	else 
		if #gangData == 0 then 
			dxDrawText("Brak dostępnych gangów", bgPos.x, bgPos.y, bgPos.w+bgPos.x, bgPos.y+bgPos.h, tocolor(230, 230, 230, 230), 0.85, font, "center", "center", false, true, true)
		else 
			exports["ms-gui"]:renderScroll(scroll)

			--dxDrawRectangle(bgPos.x + bgPos.w - 50/zoom, scrollPos + bgPos.y + 13/zoom, 30/zoom, scrollHeight, tocolor(51, 102, 255, 255), true)
			local scrollProgress = exports["ms-gui"]:getScrollProgress(scroll)
			local selectedRow = math.ceil(scrollProgress * #gangData) - MAX_VISIBLE_ROWS/2
			local visibleRows = math.max(MAX_VISIBLE_ROWS, selectedRow+MAX_VISIBLE_ROWS-1)

			if selectedRow > #gangData-MAX_VISIBLE_ROWS+1 then
				selectedRow = #gangData-MAX_VISIBLE_ROWS+1
			end
			
			local n = 0 
			for k,v in ipairs(gangData) do 
				if k >= selectedRow and k <= visibleRows then 
					n = n+1 
					
					local row = 1 
					if n % 2 ~= 0 then 
						row = 0
					end 
					
					local column = math.ceil(n/2)
					
					local offsetX = row*(bgRow.w+(10/zoom))
					local offsetY = 57/zoom + (column-1)*(3/zoom+bgRow.h)
					
					if isCursorOnElement(bgRow.x+offsetX, bgPos.y+offsetY, bgRow.w, bgRow.h) then 
						dxDrawRectangle(bgRow.x+offsetX, bgPos.y+offsetY, bgRow.w, bgRow.h, tocolor(10, 10, 10, 100), true)
						if getKeyState("mouse1") then 
							destroyGangList()
							showGangDetails(v)
							return
						end
					else 
						dxDrawRectangle(bgRow.x+offsetX, bgPos.y+offsetY, bgRow.w, bgRow.h, tocolor(30, 30, 30, 100), true)
					end 
					
					dxDrawText(v.name, bgRow.x+offsetX+140/zoom, bgPos.y+offsetY+15/zoom, 0, 0, tocolor(230, 230, 230, 230), 0.8, font, "left", "top", false, true, true)
					dxDrawText("Poziom: "..tostring(v.level).."\nEXP: "..tostring(v.totalexp).."\nIlość członków: "..tostring(#fromJSON(v.members)), bgRow.x+offsetX+140/zoom, bgPos.y+offsetY+55/zoom, 0, 0, tocolor(200, 200, 200, 200), 0.6, font, "left", "top", false, true, true)
					if v.image and isElement(v.image) then 
						dxDrawImage(bgRow.x+offsetX+10/zoom, bgPos.y+offsetY+10/zoom, 120/zoom, 120/zoom, v.image, 0, 0, 0, tocolor(255, 255, 255, 255), true)
					elseif not v.image then 
						if not GANG_LOGO_CACHE[v.id] then 
							triggerServerEvent("onPlayerRequestGangLogo", localPlayer, v.id, v.logo)
							v.image = true -- trigger poszedl
						else 
							v.image = dxCreateTexture(GANG_LOGO_CACHE[v.id])
						end 
					else 
						exports["ms-gui"]:renderLoading(bgRow.x+offsetX+10/zoom, bgPos.y+offsetY+10/zoom, 120/zoom, 120/zoom)
					end
				end
			end
		end
	end
	
	if isCursorOnElement(bgPos.x+bgPos.w-40/zoom, bgPos.y, 40/zoom, 40/zoom) then 
		dxDrawRectangle(bgPos.x+bgPos.w-40/zoom, bgPos.y, 40/zoom, 40/zoom, tocolor(100, 100, 100, 150), true)
		if getKeyState("mouse1") then 
			destroyGangList()
			return
		end
	end 
	dxDrawText("X", bgPos.x+bgPos.w-26/zoom, bgPos.y+10/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
end 

function destroyGangList()
	removeEventHandler("onClientRender", root, renderGangList)
	removeEventHandler("onClientKey", root, scrollGangList)
	showCursor(false)
	showing = false
	if font then 
		destroyElement(font)
		font = false
	end
	if isTimer(loadTimer) then 
		killTimer(loadTimer)
	end 
	if gangData then 
		for k,v in ipairs(gangData) do 
			if isElement(v.image) then 
				destroyElement(v.image)
			end
		end
	end 
	exports["ms-gui"]:destroyScroll(scroll)
	gangData = false 
end

addEvent("onClientReceiveGangLogo", true)
addEventHandler("onClientReceiveGangLogo", root, 
	function(gangID, logo)
		if #logo > 0 then
			local img = dxCreateTexture(logo)
			if img then 
				local w, h = dxGetMaterialSize(img)
				if w > 600 or h > 600 then 
					destroyElement(img)
					img = nil
								
					triggerServerEvent("onPlayerResetGangLogo", localPlayer, gangID)
					return
				end
			end
		
			GANG_LOGO_CACHE[gangID] = logo 
			
			if gangData then 
				for k,v in ipairs(gangData) do 
					if v.id == gangID then
						if isElement(v.image) then 
							destroyElement(v.image)
							v.image = nil 
						end 
						
						v.image = img 
						break
					end
				end
			else 
				if img then 
					destroyElement(img)
				end
			end
		end
	end 
)

addEvent("onClientReceiveGangData", true)
addEventHandler("onClientReceiveGangData", root, 
	function(data)
		gangData = data
		
		local contentSize = 0
		for k,v in ipairs(gangData) do 
			local row = 1 
			if k % 2 ~= 0 then 
				row = 0
			end 
					
			local column = math.ceil(k/2)
					
			local offsetX = row*(bgRow.w+(10/zoom))
			local offsetY = 57/zoom + (column-1)*(3/zoom+bgRow.h)
			contentSize = offsetY
		end
		
		local scrollH = bgPos.h - 100/zoom
		scroll = exports["ms-gui"]:createScroll(bgPos.x + bgPos.w - 50/zoom, bgPos.y + 60/zoom, 30/zoom, scrollH, tocolor(20, 20, 20, 150), scrollH, math.max(scrollH, contentSize))
	end 
)