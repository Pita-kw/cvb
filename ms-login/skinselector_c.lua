--[[
	MultiServer 
	Zasób: ms-login/skinselector_c.lua
	Opis: Wybierałka skinów.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local screenW, screenH = guiGetScreenSize() 
local baseX = 2048
local zoom = 1 
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local currentSkin = 1
local currentSkinID = 0

local selectedCategory = 1

local maleSkins = {0, 1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 66, 67, 68, 70, 71, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 122, 123, 124, 125, 126, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 185, 186, 187, 188, 189, 200, 202, 203, 206, 209, 212, 217, 223, 230, 234, 239, 240, 241, 242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 312}
local femaleSkins = {9, 10, 11, 12, 13, 31, 40, 41, 54, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304}
local vipSkins = {204, 290, 252, 236, 235, 229, 228, 227, 222, 221, 220, 213, 210, 182, 183, 38, 39, 53, 139, 62, 167, 127, 121, 72, 311}

local categories = {
	"Mężczyźni",
	"Kobiety",
	"VIP",
}

local skinsByCategory =
{
	[1] = maleSkins,
	[2] = femaleSkins,
	[3] = vipSkins,
}

local skinUI 

function enableSkinSelector()

	local player_skin = getElementData(localPlayer, "player:skin") or 0
	currentSkinID = player_skin
	for k,v in ipairs(vipSkins) do 
		if currentSkinID == v and not getElementData(localPlayer, "player:premium") then 
			currentSkinID = 0
			break
		end
	end 
	
	setCameraMatrix(-1249.8873291016, 954.72631835938, 148.75909423828, -1250.839233398, 954.43884277344, 148.65328979492)
	fadeCamera(true, 1)
	addEventHandler("onClientRender", root, skinSelectorRender)
	addEventHandler("onClientKey", root, skinSelectorHandleKeys)
	
	skinBgPos = {x=screenW/2-(700/zoom)/2, y=screenH-120/zoom, w=700/zoom, h=80/zoom} 
	skinBgLinePos = {x=skinBgPos.x, y=skinBgPos.y+skinBgPos.h, w=skinBgPos.w, h=4/zoom} 
	
	skinBgCategory = {x=screenW-400/zoom, y=screenH/2-200/zoom/2, w=300/zoom, h=200/zoom}
	
	previewPed = createPed(player_skin, -1253.92, 953.48, 148.4, -60)
end

function createSelectEffect()
    fxAddDebris(-1253.92, 953.48, 148.4, math.random(0, 255), math.random(0, 255), math.random(0, 255), 255, 0.025, math.random(10, 20))
end 

function destroySkinSelector()
	if selectedCategory == 3 and not getElementData(localPlayer, "player:premium") then
		local skin = getElementModel(previewPed)
		triggerEvent('onClientAddNotification', localPlayer, 'Ten skin jest dla graczy z kontem premium!', 'error') 
		return
	end
	
	fadeLoginMusic()
	
	fadeCamera(false, 1)
	removeEventHandler("onClientKey", root, skinSelectorHandleKeys)
	setTimer(
		function()
			removeEventHandler("onClientRender", root, skinSelectorRender)
			setElementData(localPlayer, "player:skin", currentSkinID)
			showChat(true)
			destroyElement(previewPed)
			
			fadeCamera(true)
			triggerServerEvent("onPlayerEnterGame", localPlayer, localPlayer)
		end, 1000, 1)
end 
addEvent("onClientSelectSkin", true)
addEventHandler("onClientSelectSkin", root, destroySkinSelector)

function skinSelectorNext()
	local skins = skinsByCategory[selectedCategory]
	currentSkin = currentSkin+1
	if currentSkin > #skins then 
		currentSkin = 1
	end 
	currentSkinID = skins[currentSkin]
	
	createSelectEffect()
	setElementModel(previewPed, currentSkinID)
end

function skinSelectorPrev()
	local skins = skinsByCategory[selectedCategory]
	currentSkin = currentSkin-1
	if currentSkin < 1 then 
		currentSkin = #skins
	end 
	currentSkinID = skins[currentSkin]
	
	createSelectEffect()
	setElementModel(previewPed, currentSkinID)
end

function skinSelectorUp()
	currentSkin = 1 
	selectedCategory = selectedCategory-1 
	if selectedCategory < 1 then 
		selectedCategory = #categories
	end 
	
	currentSkinID = skinsByCategory[selectedCategory][currentSkin]
	createSelectEffect()
	setElementModel(previewPed, currentSkinID)
end 

function skinSelectorDown()
	currentSkin = 1 
	selectedCategory = selectedCategory+1 
	if selectedCategory > #categories then 
		selectedCategory = 1
	end 
	
	currentSkinID = skinsByCategory[selectedCategory][currentSkin]
	createSelectEffect()
	setElementModel(previewPed, currentSkinID)
end 

function skinSelectorRender() 
	exports["ms-gui"]:dxDrawBluredRectangle(skinBgPos.x, skinBgPos.y, skinBgPos.w, skinBgPos.h, tocolor(255, 255, 255, 255), true)
	dxDrawRectangle(skinBgLinePos.x, skinBgLinePos.y, skinBgLinePos.w, skinBgLinePos.h, tocolor(51, 102, 255, 255), true)
	
	dxDrawImage(skinBgPos.x+30/zoom, skinBgPos.y+skinBgPos.h/2-(51/zoom)/2, 100/zoom, 51/zoom, "img/keys.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	dxDrawImage(skinBgPos.x+290/zoom, skinBgPos.y+skinBgPos.h/2-(42/zoom)/2-1/zoom, 90/zoom, 42/zoom, "img/keys2.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	dxDrawImage(skinBgPos.x+515/zoom, skinBgPos.y+skinBgPos.h/2-(50/zoom)/2, 50/zoom, 50/zoom, "img/enter.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	
	dxDrawText("Przeglądaj", skinBgPos.x+150/zoom, skinBgPos.y, skinBgPos.w, skinBgPos.y+skinBgPos.h, tocolor(230, 230, 230, 230), 0.7, font or "default-bold", "left", "center", false, false, true)
	dxDrawText("Kategorie", skinBgPos.x+400/zoom, skinBgPos.y, skinBgPos.w, skinBgPos.y+skinBgPos.h, tocolor(230, 230, 230, 230), 0.7, font or "default-bold", "left", "center", false, false, true)
	dxDrawText("Wybierz", skinBgPos.x+585/zoom, skinBgPos.y, skinBgPos.w, skinBgPos.y+skinBgPos.h, tocolor(230, 230, 230, 230), 0.7, font or "default-bold", "left", "center", false, false, true)
	
	exports["ms-gui"]:dxDrawBluredRectangle(skinBgCategory.x, skinBgCategory.y, skinBgCategory.w, skinBgCategory.h, tocolor(255, 255, 255, 255), true)
	dxDrawText("Wybierz kategorię", skinBgCategory.x, skinBgCategory.y+20/zoom, skinBgCategory.x+skinBgCategory.w, skinBgCategory.h, tocolor(220, 220, 220, 220), 0.8, font, "center", "top", false, false, true, false, false)
	dxDrawRectangle(skinBgCategory.x, skinBgCategory.y + 35/zoom + (35*selectedCategory-1)/zoom, skinBgCategory.w, 32/zoom, tocolor(30, 30, 30, 140), true)
	dxDrawRectangle(skinBgCategory.x, skinBgCategory.y + 35/zoom + (35*selectedCategory-1)/zoom, 5/zoom, 32/zoom, tocolor(51, 102, 255, 255), true)
	for k,v in ipairs(categories) do 
		if k == 3 then 
			dxDrawText(v, skinBgCategory.x + 20/zoom, skinBgCategory.y + 35/zoom + (35*k-1)/zoom, skinBgCategory.w+skinBgCategory.x, skinBgCategory.h, tocolor(241, 196, 15, 220), 0.7, font, "left", "top", false, false, true, false, false)
		else 
			dxDrawText(v, skinBgCategory.x + 20/zoom, skinBgCategory.y + 35/zoom + (35*k-1)/zoom, skinBgCategory.w+skinBgCategory.x, skinBgCategory.h, tocolor(220, 220, 220, 220), 0.7, font, "left", "top", false, false, true, false, false)
		end
	end 
end 

function skinSelectorHandleKeys(key, press)
	if key == "arrow_l" and press then 
		skinSelectorPrev() 
	elseif key == "arrow_r" and press then 
		skinSelectorNext() 
	elseif key == "arrow_u" and press then 
		skinSelectorUp()
	elseif key == "arrow_d" and press then 
		skinSelectorDown()
	elseif key == "enter" and press then 
		destroySkinSelector()
	end
end