--[[
	@project: multiserver
	@author: Brzysiek <brzysiekdev@gmail.com>
	@filename: report_c.lua
	@desc: raporty
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local requests = {}

local GUIEditor = {
    gridlist = {},
    window = {},
    button = {}
}

function getPlayerID(player)
	player = getPlayerFromName(player)
	if player then 
		return getElementData(player, "player:id")
	else 
		return -1 
	end 
end 

function showRequestsWindow(data)
	if isElement(GUIEditor.window[1]) then return end 
	
	showCursor(true)
	requests = data
	
	GUIEditor.window[1] = guiCreateWindow(0.23, 0.29, 0.56, 0.43, "Raporty - "..tostring(#requests), true)
    guiWindowSetSizable(GUIEditor.window[1], false)

    GUIEditor.gridlist[1] = guiCreateGridList(0.01, 0.09, 0.97, 0.63, true, GUIEditor.window[1])
    guiGridListAddColumn(GUIEditor.gridlist[1], "Zgłaszający", 0.2)
    guiGridListAddColumn(GUIEditor.gridlist[1], "Oskarżony", 0.2)
    guiGridListAddColumn(GUIEditor.gridlist[1], "Powód", 0.4)
    guiGridListAddColumn(GUIEditor.gridlist[1], "Data", 0.15)
    guiGridListAddColumn(GUIEditor.gridlist[1], "Rozpatrujący", 0.2)
	for k,v in pairs(requests) do 
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, "["..tostring(getPlayerID(v["player"])).."] "..v["player"], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, "["..tostring(getPlayerID(v["target"])).."] "..v["target"], false, false) 
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, v["reason"], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 4, v["timestamp"], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 5, v["used"], false, false)
	end 
	
    GUIEditor.button[1] = guiCreateButton(0.01, 0.74, 0.26, 0.11, "Przyjmij", true, GUIEditor.window[1])
    GUIEditor.button[2] = guiCreateButton(0.72, 0.74, 0.26, 0.11, "Usuń", true, GUIEditor.window[1])
    --GUIEditor.button[3] = guiCreateButton(0.37, 0.74, 0.26, 0.11, "Spec", true, GUIEditor.window[1])
	GUIEditor.button[4] = guiCreateButton(0.01, 0.88, 0.97, 0.09, "Zamknij", true, GUIEditor.window[1])
end
addEvent("onShowReportsWindow", true)
addEventHandler("onShowReportsWindow", root, showRequestsWindow)

addEventHandler("onClientGUIClick", root, 
	function()
		if source == GUIEditor.button[1] then 
			local selectedItem = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if selectedItem ~= -1 then 
				local used = guiGridListGetItemText (GUIEditor.gridlist[1], selectedItem, 5)
				if used == "brak" then 
					guiGridListSetItemText(GUIEditor.gridlist[1], selectedItem, 5, getPlayerName(localPlayer), false, false)
					triggerServerEvent("onPlayerAcceptReport", localPlayer, requests[selectedItem+1]["id"], requests[selectedItem+1]["player"], selectedItem)
					triggerEvent("onClientAddNotification", localPlayer, "Akceptowałeś raport gracza "..tostring(requests[selectedItem+1]["player"]), "info")
				else 
					triggerEvent("onClientAddNotification", localPlayer, "Ktoś inny rozpatruje ten raport", "error")
				end 
			end 
			
		elseif source == GUIEditor.button[2] then 
			local selectedItem = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if selectedItem ~= -1 then 
				guiGridListRemoveRow(GUIEditor.gridlist[1], selectedItem)
				triggerServerEvent("onPlayerDeleteReport", localPlayer, requests[selectedItem+1]["id"], requests[selectedItem+1]["player"])
				triggerEvent("onClientAddNotification", localPlayer, "Usunąłeś raport gracza "..tostring(requests[selectedItem+1]["player"]))
				table.remove(requests, selectedItem+1)
			end 
		elseif source == GUIEditor.button[3] then 
			
		elseif source == GUIEditor.button[4] then 
			destroyRequestsWindow()
		end 
	end 
)

function onClientSetUsingReport(index, using) 
	if isElement(GUIEditor.gridlist[1]) then 
		guiGridListSetItemText(GUIEditor.gridlist[1], index, 5, using, false, false)
	end 
end 
addEvent("onClientSetUsingReport", true)
addEventHandler("onClientSetUsingReport", root, onClientSetUsingReport)

function destroyRequestsWindow()
	if isElement(GUIEditor.window[1]) then 
		destroyElement(GUIEditor.window[1])
		showCursor(false)
	end 
end