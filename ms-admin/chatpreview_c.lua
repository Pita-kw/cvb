screenW, screenH = guiGetScreenSize()
local sx,sy = (screenW/1680), (screenH/1050)
local previews = {} 
local toggle = true 
function onInsertPreview(preview) 
	local _, textlength = string.gsub(preview, "[^\128-\193]", "")
	local l = 1 
	if textlength > 80 then l = 2 end
		
	local msgTable
	if l > 1 then 
		local a, b = string.find(preview, " ", 80)
		local mainString, subString = ""
		if a and b then 
			mainString = string.sub(preview, 1, a)
			subString = string.sub(preview, b, string.len(preview))
		else
			mainString = string.sub(preview, 1, 80)
			subString = string.sub(preview, 80, string.len(preview))
		end
		table.insert(previews, mainString)
		table.insert(previews, "..."..subString)
		return 
	end 
	
	table.insert(previews, preview)
end 
addEvent("onInsertPreview", true)
addEventHandler("onInsertPreview", root, onInsertPreview)

function drawPreviews()
	if #previews > 15 then 
		table.remove(previews, 1)
	end 
	
	if getElementData(localPlayer, "player:rank") < 0 then return end 
	if not toggle then return end 
	
	for k,v in ipairs(previews) do 
		local offset = 18
		dxDrawText(v, 26*sx, (282 + offset*(k-1))*sy, 576*sx, 234*sy, tocolor(0, 0, 0, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
		dxDrawText(v, 25*sx, (281 + offset*(k-1))*sy, 575*sx, 233*sy, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
	end 
end 
addEventHandler("onClientRender", root, drawPreviews)

function achat()
	toggle = not toggle
end 
addCommandHandler("achat", achat)
