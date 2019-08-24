--[[
	##########################################################################
	##                                                                      ##
	## Project: 'MT-RPG' - Resoruce for MTA: San Andreas PROJECT X          ##
	##                      Developer: Noneatme                             ##
	##           License: See LICENSE in the top level directory            ##
	##                                                                      ##
	##########################################################################
]]


local cFunc = {}
local cSetting = {}


-- FUNCTIONS --

cSetting["enabled"] = false


local aesx, aesy = 1600, 900
local sx, sy = guiGetScreenSize()

cSetting["start_thema"] = 1
cSetting["stop_thema"] = 10


cSetting["hilfethemen"] = {
	[0] = {"-", "Please select a topic from the left gridlist.\n\nUse your mouse wheel, to scroll up/down."},
	[1] = {"About", "MTA Slender is made by Noneatme.\nThis gamemode is free & downloadable. If you paid for it, you might got fooled.\nYou are allowed to share, modify and use it.\n\nThe Skin is made by SkylerMilligan.\n\nYour task is to find 8 Pages in your local area.\nThere is also a 'slenderman' in your area.\nBe carefull - with every page you found, the slenderman is more dangerous."},
	[2] = {"Controls", "\nWASD - Move\nLShift - Sprint\nLeft mouse button - enable/disable your flashlight\nF9 - Helpmenue"},
	[3] = {"Version", "The latest version:\n\n1.2:\n- Added a stammia display\n- Added a slender warning that will glow, if slendy is looking at you\n- Added the helpmenu\n- Recoded the sprint-script"},
	[4] = {"Bugs", "\nThey are a few bugs maybe. If you found some/one, please mail them to\nNoneatme@hotmail.de or use the forums and write a PM.\n\nSome bugs:\n- Slendy is stucked in the floor (LOL)\n- Stuck on Spawn(? I think it's MTA fault)\n- Some pages are stucked in a wall\n- You can leave the area"},
}

cSetting["buttons"] = {}
cSetting["buttons_hover"] = {}
cSetting["selected_thema"] = 0

-- GUIEditor.edit[1] = guiCreateEdit(515, 662, 145, 17, "Search...", false)
-- EVENT HANDLER --

cFunc["render_helpmenue"] = function()
	if(cSetting["enabled"] == true) then
		showCursor(true)
		dxDrawRectangle(511/aesx*sx, 300/aesy*sy, 601/aesx*sx, 17/aesy*sy, tocolor(47, 255, 0, 128), true, false)
		dxDrawText("Help & Informations - MTA Slender", 511/aesx*sx, 298/aesy*sy, 1114/aesx*sx, 318/aesy*sy, tocolor(0, 0, 0, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
		dxDrawRectangle(511/aesx*sx, 317/aesy*sy, 601/aesx*sx, 369/aesy*sy, tocolor(0, 0, 0, 127), true, false)
		dxDrawLine(668/aesx*sx, 320/aesy*sy, 668/aesx*sx, 679/aesy*sy, tocolor(58, 255, 5, 174), 1/(aesx+aesy)*(sx+sy), true)
		dxDrawText("Select a Topic to view\nthe help!(You can scroll)", 513/aesx*sx, 318/aesy*sy, 665/aesx*sx, 349/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
		dxDrawLine(516/aesx*sx, 351/aesy*sy, 663/aesx*sx, 351/aesy*sy, tocolor(58, 255, 5, 174), 1/(aesx+aesy)*(sx+sy), true)
	--	dxDrawText("First Title", 515/aesx*sx, 356/aesy*sy, 663/aesx*sx, 378/aesy*sy, tocolor(5, 254, 239, 174), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
		dxDrawText(cSetting["hilfethemen"][cSetting["selected_thema"]][1], 672/aesx*sx, 319/aesy*sy, 1109/aesx*sx, 353/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "pricedown", "center", "center", false, false, true, false, false)
		dxDrawText(cSetting["hilfethemen"][cSetting["selected_thema"]][2], 675/aesx*sx, 355/aesy*sy, 1103/aesx*sx, 681/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "left", "top", false, false, true, false, false)
	-- DRAW BUTTONS --
		local increment = 60/aesy*sy
		local add = 20/aesy*sy
		for i = cSetting["start_thema"], 9+cSetting["start_thema"], 1 do
			if(cSetting["hilfethemen"][i]) and(cSetting["hilfethemen"][i][1] ~= "-") then
				local r, g, b = 0, 0, 0
				if(cSetting["buttons_hover"][i]) then
					if(cSetting["buttons_hover"][i] == true) then
						r, g, b = 25, 25, 25
					end
				end
				dxDrawRectangle(513/aesx*sx, (364/aesy*sy)+(add/2)-(10/aesy*sy), 153/aesx*sx, 24/aesy*sy, tocolor(r, g, b, 150), true)
				dxDrawText(cSetting["hilfethemen"][i][1], 515/aesx*sx, (356/aesy*sy)+add, 663/aesx*sx, 378/aesy*sy, tocolor(5, 254, 239, 174), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
				add = add+increment
			end
		end
	end
end

cSetting["destroy_all_buttons"] = function()
	for index, knopf in pairs(cSetting["buttons"]) do
		if(isElement(knopf)) then
			destroyElement(knopf)
		end
	end
	cSetting["buttons"] = {}
end

cFunc["refresh_buttons"] = function()
	cSetting["destroy_all_buttons"]()
	local increment = 60/aesy*sy
	local add = 20/aesy*sy
	for i = cSetting["start_thema"], 9+cSetting["start_thema"], 1 do
		if(cSetting["hilfethemen"][i]) and(cSetting["hilfethemen"][i][1] ~= "-") then
			cSetting["buttons"][i] = guiCreateButton(513/aesx*sx, (364/aesy*sy)+(add/2)-(10/aesy*sy), 153/aesx*sx, 24/aesy*sy, i, false)
			add = add+increment
			cSetting["buttons_hover"][i] = false
			guiSetAlpha(cSetting["buttons"][i], 0)
			
			-- EVENT HANDLER --
			addEventHandler("onClientMouseEnter", cSetting["buttons"][i], function()
				cSetting["buttons_hover"][i] = true
				playSoundFrontEnd(42)
			end, false)
			
			addEventHandler("onClientMouseLeave", cSetting["buttons"][i], function()
				cSetting["buttons_hover"][i] = false
			end, false)
			
			addEventHandler("onClientGUIClick", cSetting["buttons"][i], function()
				cSetting["buttons_hover"][i] = true
				cSetting["selected_thema"] = i
				playSoundFrontEnd(41)
			end, false)
		end
	end
	
	cSetting["buttons"]["edit"] = guiCreateEdit(515/aesx*sx, 662/aesy*sy, 145/aesx*sx, 17/aesy*sy, "Hello I'm an useless Editbox", false)
end

cFunc["move_up"] = function()
	if(cSetting["start_thema"] < #cSetting["hilfethemen"]) then
		cSetting["start_thema"] = cSetting["start_thema"]+1
	else
		cSetting["start_thema"] = #cSetting["hilfethemen"]+1
	end
	cFunc["refresh_buttons"]()
end

cFunc["move_down"] = function()
	if(cSetting["start_thema"] > 2) then
		cSetting["start_thema"] = cSetting["start_thema"]-1
	else
		cSetting["start_thema"] = 1
	end
	cFunc["refresh_buttons"]()
end

cFunc["bind_keys"] = function()
	bindKey("mouse_wheel_up", "down", cFunc["move_down"])
	bindKey("mouse_wheel_down", "down", cFunc["move_up"])
	cFunc["refresh_buttons"]()
end

cFunc["unbind_keys"] = function()
	unbindKey("mouse_wheel_up", "down", cFunc["move_down"])
	unbindKey("mouse_wheel_down", "down", cFunc["move_up"])
end


cFunc["enable_helpmenu"] = function()
	if(cSetting["enabled"] == false) then
		showCursor(true)
		cSetting["enabled"] = true
		addEventHandler("onClientRender", getRootElement(), cFunc["render_helpmenue"])
		cFunc["bind_keys"]()
	end
end

cFunc["disable_helpmenu"] = function()
	if(cSetting["enabled"] == true) then
		cSetting["enabled"] = false
		removeEventHandler("onClientRender", getRootElement(), cFunc["render_helpmenue"])
		cFunc["unbind_keys"]()
		showCursor(false)
	end
end
cFunc["toggle_helpmenue"] = function()
		if(cSetting["enabled"] == true) then
			cFunc["disable_helpmenu"]()
			cSetting["destroy_all_buttons"]()
		else
			cFunc["enable_helpmenu"]()
		end
end

bindKey("F9", "down", cFunc["toggle_helpmenue"])
