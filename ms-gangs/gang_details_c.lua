local screenW, screenH = guiGetScreenSize() 
local zoom = 1 
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, (baseX+150)/screenW)
end 

local gangData = false
local options = {
	"Informacje",
	"Statystyki",
	"Członkowie",
	"Zarządzanie",
	"Opuść gang",
}
local memberOptions = {
	"Mianuj liderem",
	"Awansuj",
	"Degraduj",
	"Wyrzuć z gangu",
}
local isLeader = false 
local isMember = false
local hoveredOption = {1, 1}
local selectedOption = 1
local selectedOptionName = ""
local selectedManagmentOption = false 
local selectedManagmentMember = false
local selectedManagmentButton =  false

local hoveredManagmentOption = false 
local hoveredManagmentMember = false 
local hoveredManagmentButton = false
local hoveredManagmentRank = false 

local currentScroll = false 

GANG_DETAILS_SHOWING = false 
local blur = false 
local font = false

local MAX_VISIBLE_ROWS = 9
local selectedRow = 1
local visibleRows = MAX_VISIBLE_ROWS

local bgPos = {x=(screenW/2)-(850/zoom/2), y=(screenH/2)-(530/zoom/2), w=850/zoom, h=530/zoom}

local bgRow = {x=bgPos.x+bgPos.w*0.36, w=bgPos.w*0.5, h=45/zoom}
local bgRowLine = {x=bgRow.x, w=5/zoom, h=bgRow.h}

local gangOptions = {
	{bgPos.x+330/zoom, bgPos.y+100/zoom, 100/zoom, 100/zoom, "i/manage_team.png"},
	{bgPos.x+480/zoom, bgPos.y+100/zoom, 100/zoom, 100/zoom, "i/manage_advert.png"},
	{bgPos.x+630/zoom, bgPos.y+100/zoom, 100/zoom, 100/zoom, "i/manage_gang.png"},
	{bgPos.x+330/zoom, bgPos.y+300/zoom, 100/zoom, 100/zoom, "i/manage_color.png"},
	{bgPos.x+480/zoom, bgPos.y+300/zoom, 100/zoom, 100/zoom, "i/manage_ranks.png"},
	{bgPos.x+630/zoom, bgPos.y+300/zoom, 100/zoom, 100/zoom, "i/manage_logo.png"},
}

function showGangDetails(data)
	gangData = data
	gangData.image = false 
	gangData.color = fromJSON(gangData.color)
	gangData.leaders = fromJSON(gangData.leaders)
	gangData.members = fromJSON(gangData.members)
	gangData.ranks = fromJSON(gangData.ranks)
	gangData.leaderString = ""
	isLeader = false 
	isMember = false 
	
	for k,v in ipairs(gangData.leaders) do 
		if v == getElementData(localPlayer, "player:uid") then 
			isLeader = true 
		end
		
		if #gangData.leaderString == 0 then 
			gangData.leaderString = tostring(gangData.leadersNames[k])
		else 
			gangData.leaderString = gangData.leaderString..", "..tostring(gangData.leadersNames[k])
		end
	end 
	
	for k,v in ipairs(gangData.members) do 
		if v.uid == getElementData(localPlayer, "player:uid") then 
			isMember = true 
		end
	end

	selectedOption = 1
	selectedOptionName = ""
	
	if not font then 
		font = dxCreateFont("archivo_narrow.ttf", 24/zoom, false, "antialiased")
	end 
	
	addEventHandler("onClientRender", root, renderGangDetails)
	addEventHandler("onClientClick", root, clickGangDetails)
	bindKey("mouse_wheel_down","both",scrollMembers)
	bindKey("mouse_wheel_up","both",scrollMembers)
	showCursor(true)
	GANG_DETAILS_SHOWING = true 
	
	guiSetInputMode("no_binds")
end

function renderGangDetails()
	currentScroll = false 
	
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(240, 240, 240, 255), true)
	dxDrawRectangle(bgPos.x, bgPos.y, bgPos.w*0.28, bgPos.h, tocolor(30, 30, 30, 150), true)
	
	if not gangData.image then 
		if GANG_LOGO_CACHE[gangData.id] then 
			gangData.image = dxCreateTexture(GANG_LOGO_CACHE[gangData.id])
		else 
			exports["ms-gui"]:renderLoading(bgPos.x+10/zoom, bgPos.y+10/zoom, 210/zoom, 210/zoom)
		end
	elseif gangData.image and isElement(gangData.image) then 
		dxDrawImage(bgPos.x+15/zoom, bgPos.y+10/zoom, 210/zoom, 210/zoom, gangData.image, 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end 
	
	local opt = {
		"Informacje",
		"Statystyki",
		"Członkowie",
		"Zarządzanie",
		"Opuść gang",
	}
	if not isLeader then if #opt > 4 then table.remove(opt, 4) end end
	if not isMember then if #opt > 3 then table.remove(opt, #opt) end end 
	
	for k,v in ipairs(opt) do 
		local offsetY = 258/zoom + (k-1)*(55/zoom)
		dxDrawRectangle(bgPos.x, bgPos.y+offsetY, bgPos.w*0.28, 50/zoom, tocolor(30, 30, 30, 150), true)
		dxDrawText(v, bgPos.x, bgPos.y+offsetY, bgPos.x+bgPos.w*0.28, bgPos.y+offsetY+50/zoom, tocolor(200, 200, 200, 220), 0.7, font, "center", "center", false, false, true)
		
		local highlight = false
		if isCursorOnElement(bgPos.x, bgPos.y+offsetY, bgPos.w*0.28, 50/zoom) then 
			highlight = true 
			hoveredOption = {k, v}
		end
		
		if selectedOption == k then 
			highlight = true
		end
		
		if highlight then
			dxDrawRectangle(bgPos.x, bgPos.y+offsetY, 5/zoom, 50/zoom, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 255), true)
		end
	end 

	if selectedOption == 1 then 
		dxDrawText(gangData.name, bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
		dxDrawText("Data założenia: "..gangData.createDate.."\nZałożyciel: "..gangData.owner.name.."\nLiderzy: "..gangData.leaderString.."\nIlość członków: "..tostring(#gangData.members).."\nSojusze: "..gangData.website, bgPos.x+(bgPos.w*0.28), bgPos.y+170/zoom, bgPos.x+bgPos.w, 0, tocolor(200, 200, 200, 200), 0.7, font, "center", "top", false, true, true)
		
		dxDrawRectangle(bgPos.x+bgPos.w*0.28, bgPos.y+bgPos.h-bgPos.h*0.2, bgPos.w*0.72, bgPos.h*0.2, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 75), true)
		dxDrawText(gangData.ann, bgPos.x+bgPos.w*0.28, bgPos.y+bgPos.h-bgPos.h*0.2, bgPos.x+bgPos.w, bgPos.y+bgPos.h, tocolor(230, 230, 230, 230), 0.675, font, "center", "center", true, true, true)
	elseif selectedOption == 2 then
		dxDrawText("Statystyki", bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
		local ratio = "brak danych"
		if gangData.kills > 0 and gangData.deaths > 0 then 
			ratio = round(gangData.kills/gangData.deaths, 2)
		end
		
		dxDrawText("Level: "..tostring(gangData.level).."\nEXP: "..tostring(gangData.totalexp).."\nZabicia: "..tostring(gangData.kills).."\nŚmierci: "..tostring(gangData.deaths).."\nRatio: "..tostring(ratio).."\nWygrane wojny gangów: "..tostring(gangData.won_wars).."\nPrzegrane wojny gangów: "..tostring(gangData.lost_wars), bgPos.x+(bgPos.w*0.28), bgPos.y+170/zoom, bgPos.x+bgPos.w, 0, tocolor(200, 200, 200, 200), 0.7, font, "center", "top", false, true, true)
	elseif selectedOption == 3 then
		-- lista członków
		exports["ms-gui"]:renderList(list)
	elseif selectedOption == 4 then
		if not selectedManagmentOption then 
			dxDrawText("Ekipa", bgPos.x+330/zoom, bgPos.y+210/zoom, bgPos.x+430/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			dxDrawText("Ogłoszenie", bgPos.x+480/zoom, bgPos.y+210/zoom, bgPos.x+580/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			dxDrawText("Informacje", bgPos.x+630/zoom, bgPos.y+210/zoom, bgPos.x+730/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			dxDrawText("Kolor", bgPos.x+330/zoom, bgPos.y+410/zoom, bgPos.x+430/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			dxDrawText("Rangi", bgPos.x+480/zoom, bgPos.y+410/zoom, bgPos.x+580/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			dxDrawText("Logo", bgPos.x+630/zoom, bgPos.y+410/zoom, bgPos.x+730/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			--dxDrawText("SprayTag", bgPos.x+700/zoom, bgPos.y+410/zoom, bgPos.x+800/zoom, 0, tocolor(200, 200, 200, 200), 0.8, font, "center", "top", false, false, true)
			
			for i,v in pairs(gangOptions) do
				if isCursorOnElement(v[1],v[2],v[3],v[4]) then
					dxDrawImage(v[1], v[2], v[3], v[4], v[5], 0, 0, 0, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 255), true)
					hoveredManagmentOption = i
				else 
					dxDrawImage(v[1], v[2], v[3], v[4], v[5], 0, 0, 0, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 200), true)
				end
			end
		else
			if selectedManagmentOption == 1 then -- członkowie
				if selectedManagmentMember and gangData.members[selectedManagmentMember] then 
					dxDrawText(gangData.membersNames[selectedManagmentMember], bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
					local isMemberLeader = "nie" 
					for k,v in ipairs(gangData.leaders) do 
						if v == gangData.members[selectedManagmentMember].uid then 
							isMemberLeader = "tak"
						end
					end 
					
					local rank = gangData.members[selectedManagmentMember].rank
					for k,v in ipairs(gangData.ranks) do 
						if k == rank then 
							rank = v
						end
					end 
					
					if rank == gangData.members[selectedManagmentMember].rank then 
						rank = "brak"
					end
					
					dxDrawText("Lider: "..tostring(isMemberLeader).."\nRanga: "..rank, bgPos.x+(bgPos.w*0.28), bgPos.y+170/zoom, bgPos.x+bgPos.w, 0, tocolor(200, 200, 200, 200), 0.7, font, "center", "top", false, true, true)
					
					for k,v in ipairs(memberOptions) do 
						local offsetY = (k-1)*(60/zoom)
						local x, y, w, h = bgPos.x+(bgPos.w*0.28)/2+bgPos.w/2-200/zoom/2, offsetY+bgPos.y+260/zoom, 200/zoom, 50/zoom
						if isCursorOnElement(x, y, w, h) then 
							dxDrawRectangle(x, y, w, h, tocolor(40, 40, 40, 200), true)
							dxDrawText(v, x, y, x+w, y+h, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 230), 0.7, font, "center", "center", false, true, true)
							hoveredManagmentButton = k
						else 
							dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30, 150), true)
							dxDrawText(v, x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
						end
					end
				else
					exports["ms-gui"]:renderList(list)
				
					dxDrawRectangle(bgRow.x, bgPos.y+450/zoom, bgRow.w, 50/zoom, tocolor(30, 30, 30, 150), true)
					dxDrawRectangle(bgRow.x+bgRow.w*(1-0.225), bgPos.y+450/zoom, bgRow.w*0.225, 50/zoom, tocolor(100, 100, 100, 100), true)
					if isCursorOnElement(bgRow.x+bgRow.w*(1-0.225), bgPos.y+450/zoom, bgRow.w*0.225, 50/zoom) then 
						dxDrawText("Dodaj", bgRow.x+bgRow.w*(1-0.225), bgPos.y+450/zoom, bgRow.x+bgRow.w, bgPos.y+450/zoom+50/zoom,  tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 210), 0.7, font, "center", "center", false, true, true)
					else 
						dxDrawText("Dodaj", bgRow.x+bgRow.w*(1-0.225), bgPos.y+450/zoom, bgRow.x+bgRow.w, bgPos.y+450/zoom+50/zoom,  tocolor(210, 210, 210, 210), 0.7, font, "center", "center", false, true, true)
					end
					
					if memberEdit then 
						exports["ms-gui"]:renderEditBox(memberEdit)
					end
					
					local selected = exports["ms-gui"]:getSelectedListItemsIndex(list)
					if #selected > 0 then 
						selectedManagmentMember = selected[1]
					end
				end
			elseif selectedManagmentOption == 2 then -- ogloszenie
				dxDrawRectangle(bgPos.x+250/zoom, bgPos.y+180/zoom, 580/zoom, 60/zoom, tocolor(10, 10, 10, 100), true)
				
				if advertismentEdit then 
					exports["ms-gui"]:renderEditBox(advertismentEdit)
				end
					
				dxDrawText("Treść ogłoszenia gangu", bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
				if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom) then 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 150), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+270/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+270/zoom+60/zoom, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 230), 0.7, font, "center", "center", false, true, true)
				else 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 100), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+270/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+270/zoom+60/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				end
			elseif selectedManagmentOption == 3 then -- informacje
				dxDrawText("Informacje gangu", bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
				
				dxDrawText("Nazwa gangu", bgPos.x+(bgPos.w*0.28)+70/zoom, bgPos.y+210/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
				dxDrawRectangle(bgRow.x+150/zoom, bgPos.y+200/zoom, 330/zoom, 50/zoom, tocolor(30, 30, 30, 150), true)
				exports["ms-gui"]:renderEditBox(nameEdit)
				
				dxDrawText("Sojusze", bgPos.x+(bgPos.w*0.28)+70/zoom, bgPos.y+280/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
				dxDrawRectangle(bgRow.x+150/zoom, bgPos.y+270/zoom, 330/zoom, 50/zoom, tocolor(30, 30, 30, 150), true)
				exports["ms-gui"]:renderEditBox(urlEdit)
				
				dxDrawText("Tag gangu", bgPos.x+(bgPos.w*0.28)+70/zoom, bgPos.y+350/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 0.7, font, "left", "top", false, true, true)
				dxDrawRectangle(bgRow.x+150/zoom, bgPos.y+340/zoom, 330/zoom, 50/zoom, tocolor(30, 30, 30, 150), true)
				exports["ms-gui"]:renderEditBox(tagEdit)
				
				if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+430/zoom, 200/zoom, 60/zoom) then 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+430/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 150), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+430/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+430/zoom+60/zoom, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 230), 0.7, font, "center", "center", false, true, true)
				else 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+430/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 100), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+430/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+430/zoom+60/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				end
			elseif selectedManagmentOption == 4 then -- kolor
				dxDrawText("Kolor gangu", bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 230), 1, font, "center", "top", false, true, true)
				
				local x, y, w, h = bgPos.x+250/zoom, bgPos.y+180/zoom, 160/zoom, 60/zoom
				dxDrawRectangle(x, y, w*0.3, h, tocolor(200, 10, 10, 150), true)
				dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, 100), true)
				dxDrawText("R", x, y, x+w*0.3, y+h, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				exports["ms-gui"]:renderEditBox(rEdit)
				
				local x, y, w, h = bgPos.x+470/zoom, bgPos.y+180/zoom, 160/zoom, 60/zoom
				dxDrawRectangle(x, y, w*0.3, h, tocolor(10, 200, 10, 150), true)
				dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, 100), true)
				dxDrawText("G", x, y, x+w*0.3, y+h, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				exports["ms-gui"]:renderEditBox(gEdit)
				
				local x, y, w, h = bgPos.x+680/zoom, bgPos.y+180/zoom, 160/zoom, 60/zoom
				dxDrawRectangle(x, y, w*0.3, h, tocolor(10, 10, 200, 150), true)
				dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, 100), true)
				dxDrawText("B", x, y, x+w*0.3, y+h, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				exports["ms-gui"]:renderEditBox(bEdit)
				
				if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom) then 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 150), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+270/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+270/zoom+60/zoom, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 230), 0.7, font, "center", "center", false, true, true)
				else 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 100), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+270/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+270/zoom+60/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				end
				
				dxDrawText("Kolor RGB możesz wybrać na stronie:\ncolorschemer.com/online.html", bgPos.x+(bgPos.w*0.28), bgPos.y+350/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 0.75, font, "center", "top", false, true, true)
			elseif selectedManagmentOption == 5 then -- rangi 
				if #gangData.ranks > MAX_VISIBLE_ROWS then
					currentScroll = #gangData.ranks
					
					local scrollH = bgPos.h - 240/zoom
					dxDrawRectangle(bgPos.x + bgPos.w - 90/zoom, bgPos.y + 60/zoom, 20/zoom, scrollH, tocolor(30, 30, 30, 150), true)
					
					local scrollPos = 45/zoom
					if currentScroll > MAX_VISIBLE_ROWS then 
						scrollPos = (((selectedRow-1)/(currentScroll-MAX_VISIBLE_ROWS)) * (scrollH-40/zoom)) + 45/zoom
					end 
					
					dxDrawRectangle(bgPos.x + bgPos.w - 90/zoom, scrollPos + bgPos.y + 13/zoom, 20/zoom, 40/zoom, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 255), true)
				end
			
				local n = 0
				for k,v in ipairs(gangData.ranks) do 
					if k >= selectedRow and k <= visibleRows then 
						n = n+1
						local offsetY = 60/zoom + (n-1)*(3/zoom+bgRow.h)
						dxDrawRectangle(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h, tocolor(30, 30, 30, 100), true)
						dxDrawText(v, bgRow.x + 35/zoom, offsetY + bgPos.y, bgRow.w+bgRow.x, offsetY+bgPos.y+bgRow.h, tocolor(210, 210, 210, 210), 0.7, font, "left", "center", false, true, true)
						
						if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h) then 
							dxDrawRectangle(bgRowLine.x, bgPos.y+offsetY, bgRowLine.w, bgRowLine.h, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 255), true)
							hoveredManagmentRank = {k, n}
						end
						
						local x, y, w, h = bgRow.x + bgRow.w*0.8, bgPos.y+offsetY, bgRow.w*0.2, bgRow.h
						if isCursorOnElement(x, y, w, h) then 
							dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 100), true)
						else 
							dxDrawRectangle(x, y, w, h, tocolor(231, 76, 60, 50), true)
						end
						dxDrawText("Usuń", x, y, x+w, y+h, tocolor(210, 210, 210, 210), 0.6, font, "center", "center", false, true, true)
					end
				end
				
				dxDrawRectangle(bgRow.x, bgPos.y+390/zoom, bgRow.w, 50/zoom, tocolor(30, 30, 30, 150), true)
				dxDrawRectangle(bgRow.x+bgRow.w*(1-0.225), bgPos.y+390/zoom, bgRow.w*0.225, 50/zoom, tocolor(100, 100, 100, 100), true)
				if isCursorOnElement(bgRow.x+bgRow.w*(1-0.225), bgPos.y+390/zoom, bgRow.w*0.225, 50/zoom) then 
					dxDrawText("Dodaj", bgRow.x+bgRow.w*(1-0.225), bgPos.y+390/zoom, bgRow.x+bgRow.w, bgPos.y+390/zoom+50/zoom,  tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 210), 0.7, font, "center", "center", false, true, true)
				else 
					dxDrawText("Dodaj", bgRow.x+bgRow.w*(1-0.225), bgPos.y+390/zoom, bgRow.x+bgRow.w, bgPos.y+390/zoom+50/zoom,  tocolor(210, 210, 210, 210), 0.7, font, "center", "center", false, true, true)
				end
				
				if rankEdit then 
					exports["ms-gui"]:renderEditBox(rankEdit)
				end
				
				dxDrawText("Każda edycja rang resetuje rangi wszystkim członkom!", bgRow.x, bgPos.y+415/zoom, bgRow.x+bgRow.w, bgPos.y+490/zoom+50/zoom,  tocolor(210, 210, 210, 210), 0.6, font, "center", "center", false, true, true)
			elseif selectedManagmentOption == 6 then -- logo
				dxDrawText("Logo gangu", bgPos.x+(bgPos.w*0.28), bgPos.y+120/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 1, font, "center", "top", false, true, true)
				
				local x, y, w, h = bgPos.x+250/zoom, bgPos.y+180/zoom, 580/zoom, 60/zoom
				dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, 100), true)
				local text = guiGetText(logoEdit)
				if #text > 60 then 
					text = text:sub(#text-60)
				end
				dxDrawText(text, x+10/zoom, y, x+w-10/zoom, y+h, tocolor(230, 230, 230, 230), 0.6, font, "left", "center", false, false, true)
				if #text == 0 then 
					dxDrawText("Wklej tutaj link do logo gangu", x+10/zoom, y, x+w-10/zoom, y+h, tocolor(150, 150, 150, 230), 0.6, font, "left", "center", false, false, true)
				end 
				if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom) then 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 150), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+270/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+270/zoom+60/zoom, tocolor(gangData.color[1], gangData.color[2], gangData.color[3], 230), 0.7, font, "center", "center", false, true, true)
				else 
					dxDrawRectangle(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom, tocolor(30, 30, 30, 100), true)
					dxDrawText("Akceptuj", bgPos.x+440/zoom, bgPos.y+270/zoom, bgPos.x+440/zoom+200/zoom, bgPos.y+270/zoom+60/zoom, tocolor(230, 230, 230, 230), 0.7, font, "center", "center", false, true, true)
				end
				
				dxDrawText("Obrazki o rozdzielczości większej niż 600x600 nie będą wczytywane. Jeśli logo długo się wczytuje, spróbuj wyjść do menu wyboru gangów.", bgPos.x+(bgPos.w*0.28), bgPos.y+350/zoom, bgPos.x+bgPos.w, 0, tocolor(230, 230, 230, 230), 0.75, font, "center", "top", false, true, true)
			end
		end
	end 
	
	if isCursorOnElement(bgPos.x+bgPos.w-40/zoom, bgPos.y, 40/zoom, 40/zoom) then 
		dxDrawRectangle(bgPos.x+bgPos.w-40/zoom, bgPos.y, 40/zoom, 40/zoom, tocolor(50, 50, 50, 150), true)
		if getKeyState("mouse1") then 
			destroyGangDetails(true)
			return
		end
	end 
	
	dxDrawText("X", bgPos.x+bgPos.w-26/zoom, bgPos.y+10/zoom, 0, 0, tocolor(200, 200, 200, 250), 0.6, font, "left", "top", false, false, true)
end

function clickGangDetails(key, state) 
	if key == "left" and state == "up" then 
		if hoveredOption then 
			local offsetY = 258/zoom + (hoveredOption[1]-1)*(55/zoom)
			if isCursorOnElement(bgPos.x, bgPos.y+offsetY, bgPos.w*0.28, 50/zoom) then 
				selectedOption = hoveredOption[1]
				selectedOptionName = hoveredOption[2]
				selectedManagmentOption = false 
				selectedManagmentMember = false
				if rankEdit then 
					exports["ms-gui"]:destroyEditBox(rankEdit)
					rankEdit = nil
				end
				if memberEdit then 
					exports["ms-gui"]:destroyEditBox(memberEdit)
					memberEdit = nil
				end
				if advertismentEdit then 
					exports["ms-gui"]:destroyEditBox(advertismentEdit)
					advertismentEdit = nil 
				end
				if list then
					exports["ms-gui"]:setListActive(list, false)
					exports["ms-gui"]:destroyList(list)
					list = nil
				end
				if logoEdit then 
					destroyElement(logoEdit)
					logoEdit = nil
				end
				if nameEdit then 
					exports["ms-gui"]:destroyEditBox(nameEdit)
					nameEdit = nil
				end
				if urlEdit then 
					exports["ms-gui"]:destroyEditBox(urlEdit)
					urlEdit = nil
				end
				if tagEdit then 
					exports["ms-gui"]:destroyEditBox(tagEdit)
					tagEdit = nil
				end
				if rEdit then 
					exports["ms-gui"]:destroyEditBox(rEdit)
					rEdit = nil
				end
				if gEdit then 
					exports["ms-gui"]:destroyEditBox(gEdit)
					gEdit = nil
				end
				if bEdit then 
					exports["ms-gui"]:destroyEditBox(bEdit)
					bEdit = nil
				end
			end
		end 
		
		if selectedOption then 
			local offsetY = 258/zoom + (selectedOption-1)*(55/zoom)
			if isCursorOnElement(bgPos.x, bgPos.y+offsetY, bgPos.w*0.28, 50/zoom) then 
				if selectedOptionName == "Członkowie" then 
					list = exports["ms-gui"]:createList(bgPos.x+250/zoom, bgPos.y+30/zoom, 560/zoom, bgPos.h-60/zoom, tocolor(30, 30, 30, 150), font, 0.7, 20/zoom, {gangData.color[1], gangData.color[2], gangData.color[3], 255})
					exports["ms-gui"]:addListColumn(list, "Członek", 0.55)
					exports["ms-gui"]:addListColumn(list, "Ranga", 0.45)
					for k,v in ipairs(gangData.members) do 
						local rank = v.rank
						for i, rnk in ipairs(gangData.ranks) do 
							if i == rank then 
								rank = rnk
							end
						end 
								
						if rank == v.rank then 
							rank = "brak"
						end
						
						exports["ms-gui"]:addListItem(list, "Członek", gangData.membersNames[k])
						exports["ms-gui"]:addListItem(list, "Ranga", rank)
					end
					exports["ms-gui"]:reloadListRT(list)
					exports["ms-gui"]:setListActive(list, true)
				elseif selectedOptionName == "Opuść gang" then 
					triggerServerEvent("onPlayerQuitGang", localPlayer, gangData.id)
					destroyGangDetails()
				end
			end
		end
		
		if selectedOptionName ~= "Zarządzanie" then return end 
		
		if hoveredManagmentOption then 
			if isCursorOnElement(gangOptions[hoveredManagmentOption][1],gangOptions[hoveredManagmentOption][2], gangOptions[hoveredManagmentOption][3], gangOptions[hoveredManagmentOption][4]) then 
				selectedManagmentOption = hoveredManagmentOption
				if selectedManagmentOption == 1 then -- członkowie 
					list = exports["ms-gui"]:createList(bgPos.x+250/zoom, bgPos.y+30/zoom, 560/zoom, bgPos.h-115/zoom, tocolor(30, 30, 30, 150), font, 0.7, 20/zoom, {gangData.color[1], gangData.color[2], gangData.color[3], 255})
					exports["ms-gui"]:addListColumn(list, "Członek", 0.55)
					exports["ms-gui"]:addListColumn(list, "Ranga", 0.45)
					for k,v in ipairs(gangData.members) do 
						local rank = v.rank
						for i, rnk in ipairs(gangData.ranks) do 
							if i == rank then 
								rank = rnk
							end
						end 
								
						if rank == v.rank then 
							rank = "brak"
						end
						
						exports["ms-gui"]:addListItem(list, "Członek", gangData.membersNames[k])
						exports["ms-gui"]:addListItem(list, "Ranga", rank)
					end
					exports["ms-gui"]:reloadListRT(list)
					exports["ms-gui"]:setListActive(list, true)
					
					memberEdit = exports["ms-gui"]:createEditBox("", bgRow.x, bgPos.y+450/zoom, bgRow.w, 50/zoom, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxHelperText(memberEdit, "Wprowadź gracza do dodania")
					exports["ms-gui"]:setEditBoxMaxLength(memberEdit, 22)
				elseif selectedManagmentOption == 2 then -- ogłoszenie 
					advertismentEdit = exports["ms-gui"]:createEditBox(gangData.ann, bgPos.x+260/zoom, bgPos.y+180/zoom, 550/zoom, 60/zoom, tocolor(220, 220, 220, 220), font, 0.6)
					exports["ms-gui"]:setEditBoxHelperText(advertismentEdit, "Wprowadź ogłoszenie twojego gangu")
					exports["ms-gui"]:setEditBoxMaxLength(advertismentEdit, 70)
					exports["ms-gui"]:setEditBoxASCIIMode(advertismentEdit, false)
				elseif selectedManagmentOption == 3 then -- informacje
					nameEdit = exports["ms-gui"]:createEditBox(gangData.name, bgRow.x+165/zoom, bgPos.y+200/zoom, 310/zoom, 50/zoom, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxHelperText(nameEdit, "Nazwa twojego gangu")
					exports["ms-gui"]:setEditBoxMaxLength(nameEdit, 40)
					exports["ms-gui"]:setEditBoxASCIIMode(nameEdit, false)
					urlEdit = exports["ms-gui"]:createEditBox(gangData.website, bgRow.x+165/zoom, bgPos.y+270/zoom, 310/zoom, 50/zoom, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxHelperText(urlEdit, "Strona internetowa twojego gangu")
					tagEdit = exports["ms-gui"]:createEditBox(gangData.tag, bgRow.x+165/zoom, bgPos.y+340/zoom, 310/zoom, 50/zoom, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxHelperText(tagEdit, "Tag twojego gangu")
					exports["ms-gui"]:setEditBoxMaxLength(tagEdit, 3)
				elseif selectedManagmentOption == 4 then -- kolor
					local x, y, w, h = bgPos.x+250/zoom, bgPos.y+180/zoom, 160/zoom, 60/zoom
					rEdit = exports["ms-gui"]:createEditBox(tostring(gangData.color[1]), x+w*0.35, y, w*0.65, h, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxMaxLength(rEdit, 3)
					
					local x, y, w, h = bgPos.x+470/zoom, bgPos.y+180/zoom, 160/zoom, 60/zoom
					gEdit = exports["ms-gui"]:createEditBox(tostring(gangData.color[2]), x+w*0.35, y, w*0.65, h, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxMaxLength(gEdit, 3)
					
					local x, y, w, h = bgPos.x+680/zoom, bgPos.y+180/zoom, 160/zoom, 60/zoom
					bEdit = exports["ms-gui"]:createEditBox(tostring(gangData.color[3]), x+w*0.35, y, w*0.65, h, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxMaxLength(bEdit, 3)
				elseif selectedManagmentOption == 5 then -- rangi 
					MAX_VISIBLE_ROWS = 6
					selectedRow = 1
					visibleRows = MAX_VISIBLE_ROWS
					
					rankEdit = exports["ms-gui"]:createEditBox("", bgRow.x+5/zoom, bgPos.y+390/zoom, bgRow.w*(1-0.225), 50/zoom, tocolor(220, 220, 220, 220), font, 0.7)
					exports["ms-gui"]:setEditBoxHelperText(rankEdit, "Wprowadź nową rangę")
					exports["ms-gui"]:setEditBoxMaxLength(rankEdit, 25)
				elseif selectedManagmentOption == 6 then -- logo
					logoEdit = guiCreateEdit(bgPos.x+260/zoom, bgPos.y+180/zoom, 550/zoom, 60/zoom, gangData.logo, false)
				else
					MAX_VISIBLE_ROWS = 9
					selectedRow = 1
					visibleRows = MAX_VISIBLE_ROWS
				end
			end
		end
		
		if hoveredManagmentMember then 
			local offsetY = 60/zoom + (hoveredManagmentMember[2]-1)*(3/zoom+bgRow.h)
			if isCursorOnElement(bgRow.x, bgPos.y+offsetY, bgRow.w, bgRow.h) then 
				selectedManagmentMember = hoveredManagmentMember
			end
		end
		
		if selectedManagmentOption == 1 then 
			if isCursorOnElement(bgRow.x+bgRow.w*(1-0.225), bgPos.y+450/zoom, bgRow.w*0.225, 50/zoom) then 
				local text = exports["ms-gui"]:getEditBoxText(memberEdit)
				for k,v in ipairs(getElementsByType("player")) do 
					local name = getPlayerName(v) 
					if text == name then 
						local uid = getElementData(v, "player:uid") 
						if uid and getElementData(v, "player:spawned") then 
							for _, member in ipairs(gangData.members) do 
								if member.uid == uid then 
									triggerEvent("onClientAddNotification", localPlayer, "Ten gracz jest już w twoim gangu!", "error")
									return 
								end
							end 
							
							if getElementData(v, "player:gang") then 
								triggerEvent("onClientAddNotification", localPlayer, "Ten gracz jest już w innym gangu!", "error")
								return
							end
							
							triggerServerEvent("onLeaderAddMember", localPlayer, gangData.id, name)
							return
						end
					end
				end
				
				triggerEvent("onClientAddNotification", localPlayer, "Nie znaleziono takiego gracza.", "error")
				return
			end 
			
			if selectedManagmentMember then 
				if hoveredManagmentButton then 
					local offsetY = (hoveredManagmentButton-1)*(60/zoom)
					local x, y, w, h = bgPos.x+(bgPos.w*0.28)/2+bgPos.w/2-200/zoom/2, offsetY+bgPos.y+260/zoom, 200/zoom, 50/zoom
					if isCursorOnElement(x, y, w, h) then 
						if hoveredManagmentButton == 1 then -- lider
							local leader = true
							for k,v in ipairs(gangData.leaders) do 
								if v == gangData.members[selectedManagmentMember].uid then 
									leader = false
								end
							end 
							
							triggerServerEvent("onLeaderUpdateMemberGang", localPlayer, gangData.id, gangData.members[selectedManagmentMember].uid, gangData.membersNames[selectedManagmentMember], gangData.members[selectedManagmentMember].rank, leader)
						
							local leaders = gangData.leaders
							local leadersNames = gangData.leadersNames
							if leader then 
								table.insert(leaders, gangData.members[selectedManagmentMember].uid)
								table.insert(leadersNames, gangData.membersNames[selectedManagmentMember])
							else 
								for k,v in ipairs(leaders) do 
									if v == gangData.members[selectedManagmentMember].uid then 
										table.remove(leaders, k)
										table.remove(leadersNames, k)
									end
								end
							end
							
							gangData.leaders = leaders
							gangData.leadersNames = leadersNames
						elseif hoveredManagmentButton == 2 then -- ranga wyżej
							local rank = gangData.members[selectedManagmentMember].rank 
							rank = rank+1 
							
							local found = false 
							for k,v in ipairs(gangData.ranks) do 
								if rank == k then 
									found = true 
								end
							end
							
							if found then 
								gangData.members[selectedManagmentMember].rank = rank 
								triggerServerEvent("onLeaderUpdateMemberGang", localPlayer, gangData.id, gangData.members[selectedManagmentMember].uid, gangData.membersNames[selectedManagmentMember], rank)
							else
								triggerEvent("onClientAddNotification", localPlayer, "Nie ma już żadnych wyższych rang.", "warning")
							end
						elseif hoveredManagmentButton == 3 then  -- ranga niżej
							local rank = gangData.members[selectedManagmentMember].rank 
							rank = rank-1 
							
							local found = false 
							for k,v in ipairs(gangData.ranks) do 
								if rank == k then 
									found = true 
								end
							end
							
							if found then 
								gangData.members[selectedManagmentMember].rank = rank 
								triggerServerEvent("onLeaderUpdateMemberGang", localPlayer, gangData.id, gangData.members[selectedManagmentMember].uid, gangData.membersNames[selectedManagmentMember], rank)
							else
								triggerEvent("onClientAddNotification", localPlayer, "Nie ma już żadnych niższych rang.", "warning")
							end
						elseif hoveredManagmentButton == 4 then 
							if gangData.members[selectedManagmentMember].uid == getElementData(localPlayer, "player:uid") then 
								triggerEvent("onClientAddNotification", localPlayer, "Nie możesz wyrzucić siebie.", "error")
								return
							end 
							
							if gangData.members[selectedManagmentMember].uid == gangData.owner.uid then 
								triggerEvent("onClientAddNotification", localPlayer, "Nie możesz wyrzucić założyciela gangu.", "error")
								return
							end 
							
							triggerServerEvent("onLeaderRemoveFromGang", localPlayer, gangData.id, gangData.members[selectedManagmentMember].uid, gangData.membersNames[selectedManagmentMember])
							table.remove(gangData.members, selectedManagmentMember)
							table.remove(gangData.membersNames, selectedManagmentMember)
														
							selectedManagmentOption = false
							selectedManagmentMember = false
							selectedOption = 4 
						end
					end
				end
			end
		elseif selectedManagmentOption == 2 then -- ogłoszenie 
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom) then 
				local text = exports["ms-gui"]:getEditBoxText(advertismentEdit)
				if #text < 5 then 
					triggerEvent("onClientAddNotification", localPlayer, "Treść ogłoszenia musi mieć więcej niż 5 znaków.", "error")
					return 
				end 
				
				triggerServerEvent("onLeaderChangeAnn", localPlayer, gangData.id, text)
				gangData.ann = text
				
				selectedManagmentOption = false 
				selectedOption = 4
			end
		elseif selectedManagmentOption == 3 then -- informacje
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+430/zoom, 200/zoom, 60/zoom) then 
				local name = exports["ms-gui"]:getEditBoxText(nameEdit)
				local site = exports["ms-gui"]:getEditBoxText(urlEdit)
				local tag = exports["ms-gui"]:getEditBoxText(tagEdit)
				if #name < 3 then 
					triggerEvent("onClientAddNotification", localPlayer, "Nazwa gangu musi mieć conajmniej 3 znaki.", "error")
					return
				end
				
				if #tag < 1 then 
					triggerEvent("onClientAddNotification", localPlayer, "Wypełnij pole z tagiem.", "error")
					return
				end
				
				triggerServerEvent("onLeaderChangeInformation", localPlayer, gangData.id, name, site, tag)
				
				selectedManagmentOption = false 
				selectedOption = 4
			end
		elseif selectedManagmentOption == 4 then 
			local r, g, b = exports["ms-gui"]:getEditBoxText(rEdit), exports["ms-gui"]:getEditBoxText(gEdit), exports["ms-gui"]:getEditBoxText(bEdit) 
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom) then 
				if tonumber(r) and tonumber(g) and tonumber(b) then 
					gangData.color = {tonumber(r), tonumber(g), tonumber(b)}
					triggerServerEvent("onLeaderChangeColor", localPlayer, gangData.id, gangData.color[1], gangData.color[2], gangData.color[3])
					
					selectedManagmentOption = false 
					selectedOption = 4
				else 
					triggerEvent("onClientAddNotification", localPlayer, "Wprowadzono nieprawidłowy kolor.", "error")
				end
			end
		elseif selectedManagmentOption == 5 then -- rangi 
			if isCursorOnElement(bgRow.x+bgRow.w*(1-0.225), bgPos.y+390/zoom, bgRow.w*0.225, 50/zoom) then 
				local rankName = exports["ms-gui"]:getEditBoxText(rankEdit)
				if #rankName < 3 then 
					triggerEvent("onClientAddNotification", localPlayer, "Nazwa rangi musi mieć conajmniej 3 znaki.", "error")
					return
				end 
				
				for k,v in ipairs(gangData.ranks) do 
					if v == rankName then
						triggerEvent("onClientAddNotification", localPlayer, "Nie możesz powielać rang.", "error")
						return 
					end
				end 
				
				table.insert(gangData.ranks, rankName)
				resetGangRanks()
				triggerServerEvent("onLeaderCreateRank", localPlayer, gangData.id, rankName)
			end 
			
			if hoveredManagmentRank then 
				local offsetY = 60/zoom + (hoveredManagmentRank[2]-1)*(3/zoom+bgRow.h)
				local x, y, w, h = bgRow.x + bgRow.w*0.8, bgPos.y+offsetY, bgRow.w*0.2, bgRow.h
				if isCursorOnElement(x, y, w, h) then 
					triggerServerEvent("onLeaderDeleteRank", localPlayer, gangData.id, gangData.ranks[hoveredManagmentRank[1]])
					resetGangRanks()
					table.remove(gangData.ranks, hoveredManagmentRank[1])
					
					MAX_VISIBLE_ROWS = 6
					selectedRow = 1
					visibleRows = MAX_VISIBLE_ROWS
				end
			end
		elseif selectedManagmentOption == 6 then 
			if isCursorOnElement(bgPos.x+440/zoom, bgPos.y+270/zoom, 200/zoom, 60/zoom) then 
				local text = guiGetText(logoEdit)
				if text:find(".png") or text:find(".jpg") or text:find(".jpeg") then
					GANG_LOGO_CACHE[gangData.id] = nil
					if isElement(gangData.image) then destroyElement(gangData.image) end
					gangData.image = nil 
					
					triggerServerEvent("onLeaderChangeLogo", localPlayer, gangData.id, text)
					
					selectedManagmentOption = false 
					selectedOption = 4
				else 
					triggerEvent("onClientAddNotification", localPlayer, "Wprowadzono nieprawidłowy URL.", "error")
				end
			end
		end
	end
end 

function resetGangRanks()
	for k,v in ipairs(gangData.members) do 
		v.rank = 0
	end
end 

function scrollMembers(key)
	if not GANG_DETAILS_SHOWING then return end 
	if not currentScroll then return end 
	
	if key == "mouse_wheel_down" then
		if visibleRows >= currentScroll then return end
		selectedRow = selectedRow+1
		visibleRows = visibleRows+1
	else
		if selectedRow == 1 then return end
		selectedRow = selectedRow-1
		visibleRows = visibleRows-1
	end
end

function destroyGangDetails(back)
	if rankEdit then 
		exports["ms-gui"]:destroyEditBox(rankEdit)
		rankEdit = nil
	end
	if memberEdit then 
		exports["ms-gui"]:destroyEditBox(memberEdit)
		memberEdit = nil
	end
	if advertismentEdit then 
		exports["ms-gui"]:destroyEditBox(advertismentEdit)
		advertismentEdit = nil 
	end
	if list then
		exports["ms-gui"]:setListActive(list, false)
		exports["ms-gui"]:destroyList(list)
		list = nil
	end
	if logoEdit then 
		destroyElement(logoEdit)
		logoEdit = nil
	end
	if nameEdit then 
		exports["ms-gui"]:destroyEditBox(nameEdit)
		nameEdit = nil
	end
	if urlEdit then 
		exports["ms-gui"]:destroyEditBox(urlEdit)
		urlEdit = nil
	end
	if tagEdit then 
		exports["ms-gui"]:destroyEditBox(tagEdit)
		tagEdit = nil
	end
	if rEdit then 
		exports["ms-gui"]:destroyEditBox(rEdit)
		rEdit = nil
	end
	if gEdit then 
		exports["ms-gui"]:destroyEditBox(gEdit)
		gEdit = nil
	end
	if bEdit then 
		exports["ms-gui"]:destroyEditBox(bEdit)
		bEdit = nil
	end
	removeEventHandler("onClientRender", root, renderGangDetails)
	removeEventHandler("onClientClick", root, clickGangDetails)
	unbindKey("mouse_wheel_down","both",scrollMembers)
	unbindKey("mouse_wheel_up","both",scrollMembers)
	showCursor(false)
	GANG_DETAILS_SHOWING = false
	if font then 
		destroyElement(font)
		font = false
	end
	if gangData then 
		if isElement(gangData.image) then 
			destroyElement(gangData.image)
		end
	end 
	isLeader = false 
	isMember = false
	gangData = false 
	
	if back then 
		showGangList()
	end
	
	guiSetInputMode("allow_binds")
end