local data = {}

function showEntranceCreationWindow()
    if isElement(entrance_creation_wnd) then return end
	data = {}
	if getElementData(localPlayer, "player:rank") ~= 4 then return end 
	
	entrance_creation_wnd = guiCreateWindow(0.72, 0.23, 0.26, 0.68, "Stwórz wejście (kontrola kursora PPM) ", true)
    guiWindowSetSizable(entrance_creation_wnd, false)
	showCursor(true)
	guiSetInputMode("no_binds_when_editing")
    entrance_creation_name_lbl = guiCreateLabel(0.06, 0.06, 0.11, 0.03, "Nazwa:", true, entrance_creation_wnd)
    entrance_creation_name_edit = guiCreateEdit(0.22, 0.05, 0.75, 0.06, "", true, entrance_creation_wnd)
    entrance_creation_description_lbl = guiCreateLabel(0.06, 0.13, 0.11, 0.03, "Opis:", true, entrance_creation_wnd)
    entrance_creation_desc_edit = guiCreateMemo(0.21, 0.13, 0.75, 0.13, "", true, entrance_creation_wnd)
    entrance_creation_fraction_label = guiCreateLabel(0.06, 0.28, 0.11, 0.03, "Frakcja:", true, entrance_creation_wnd)
    entrance_creation_pickup_lbl = guiCreateLabel(0.06, 0.36, 0.17, 0.03, "Pickupid:", true, entrance_creation_wnd)
    entrance_creation_pickupid_edit = guiCreateEdit(0.22, 0.34, 0.23, 0.06, "1239", true, entrance_creation_wnd)
    entrance_creation_fraction_edit = guiCreateEdit(0.22, 0.27, 0.23, 0.06, "opcjonalne", true, entrance_creation_wnd)
    entrance_creation_enter_lbl = guiCreateLabel(0.06, 0.42, 0.76, 0.03, "X, Y, Z Wejścia: 0, 0, 0", true, entrance_creation_wnd)
    entrance_creation_enter_button = guiCreateButton(0.16, 0.45, 0.74, 0.10, "Pobierz dane wejścia", true, entrance_creation_wnd)
    entrance_creation_exit_lbl = guiCreateLabel(0.07, 0.56, 0.76, 0.03, "X, Y, Z Wyjścia: 0, 0, 0", true, entrance_creation_wnd)
    entrance_creation_exit_btn = guiCreateButton(0.16, 0.59, 0.74, 0.10, "Pobierz dane wyjścia", true, entrance_creation_wnd)
    entrance_creation_image_lbl = guiCreateLabel(0.06, 0.73, 0.23, 0.03, "URL Obrazka:", true, entrance_creation_wnd)
    entrance_creation_image_edit = guiCreateEdit(0.32, 0.72, 0.62, 0.06, "", true, entrance_creation_wnd)
    entrance_creation_music_lbl = guiCreateLabel(0.06, 0.80, 0.23, 0.03, "URL Muzyki:", true, entrance_creation_wnd)
    entrance_creation_music_edit = guiCreateEdit(0.32, 0.79, 0.62, 0.06, "opcjonalne", true, entrance_creation_wnd)
    entrance_creation_musicvolume_lbl = guiCreateLabel(0.06, 0.86, 0.26, 0.03, "Głośność muzyki:", true, entrance_creation_wnd)
    entrance_creation_musicvolume_edit = guiCreateEdit(0.32, 0.85, 0.215, 0.06, "0-1", true, entrance_creation_wnd)
	entrance_creation_blip_lbl = guiCreateLabel(0.66, 0.86, 0.26, 0.03, "Blip:", true, entrance_creation_wnd)
    entrance_creation_blip_edit = guiCreateEdit(0.72, 0.85, 0.15, 0.06, "41", true, entrance_creation_wnd)
    entrance_creation_create_button = guiCreateButton(22, 478, 156, 29, "Stwórz", false, entrance_creation_wnd)
    entrance_creation_close_btn = guiCreateButton(184, 478, 156, 28, "Zamknij", false, entrance_creation_wnd)
    entrance_creation_showgui_checkbox = guiCreateCheckBox(0.48, 0.31, 0.05, 0.04, "", true, true, entrance_creation_wnd)
    entrance_creation_guiinfo_lbl = guiCreateLabel(0.54, 0.32, 0.43, 0.04, "Pokazuj GUI z informacjami", true, entrance_creation_wnd)
end

addEventHandler("onClientGUIClick", root,
	function()
		if source == entrance_creation_enter_button then
			local x,y,z = getElementPosition(localPlayer)
			data["pk_pos"] = toJSON({x, y, z})
			data["pki"] = getElementInterior(localPlayer)
			data["pkv"] = getElementDimension(localPlayer)
			guiSetText(entrance_creation_enter_lbl, "X, Y, Z Wejścia: "..tostring(math.floor(x))..", "..tostring(math.floor(y))..", "..tostring(math.floor(z)))
		elseif source == entrance_creation_exit_btn then
			local x,y,z = getElementPosition(localPlayer)
			data["pk_tel"] = toJSON({x, y, z})
			data["teli"] = getElementInterior(localPlayer)
			data["telv"] = getElementDimension(localPlayer)
			guiSetText(entrance_creation_exit_lbl, "X, Y, Z Wyjścia: "..tostring(math.floor(x))..", "..tostring(math.floor(y))..", "..tostring(math.floor(z)))
		elseif source == entrance_creation_create_button then
			local name = guiGetText(entrance_creation_name_edit)
			local desc = guiGetText(entrance_creation_desc_edit)
			local fraction = guiGetText(entrance_creation_fraction_edit)
			local image = guiGetText(entrance_creation_image_edit)
			local music = guiGetText(entrance_creation_music_edit)
			local musicvolume = guiGetText(entrance_creation_musicvolume_edit)
			local showgui = guiCheckBoxGetSelected(entrance_creation_showgui_checkbox) == true
			local pickup = guiGetText(entrance_creation_pickupid_edit)
			local blip = guiGetText(entrance_creation_blip_edit)
			if #name < 1 and #desc < 1 and #image < 1 or #pickup < 1 or data["pk_pos"] == nil or data["pk_tel"] == nil or #blip < 1 then
				outputChatBox("* Uzupełnij obowiązkowe dane!", 255, 0, 0)
				return
			end

			data["blip"] = blip
			data["pickupid"] = pickup
			data["showgui"] = showgui
			data["music_volume"] = musicvolume
			data["music"] = music
			data["image"] = image
			data["faction"] = fraction
			data["opis"] = desc
			data["name"] = name

			triggerServerEvent("onPlayerCreateNewEntrance", localPlayer, data)
			destroyElement(entrance_creation_wnd)
			showCursor(false)
            guiSetInputMode("allow_binds")
		elseif source == entrance_creation_close_btn then
			destroyElement(entrance_creation_wnd)
			showCursor(false)
            guiSetInputMode("allow_binds")
		end
	end
)

addEventHandler("onClientKey", root,
	function(key, press)
		if isElement(entrance_creation_wnd) then
			if guiGetVisible(entrance_creation_wnd) then
				if key == "mouse2" and press then
					showCursor(not isCursorShowing())
				end
			end
		end
	end
)
addCommandHandler("ecreate", showEntranceCreationWindow)

fileDelete("entrance_creation_c.lua")
