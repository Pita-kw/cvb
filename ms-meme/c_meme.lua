--
-- c_meme.lua
--

------------------------------------------------------------------------------------------------------------
-- Settings
------------------------------------------------------------------------------------------------------------
local toggleKey = "F4"
local toggleCmd = "meme"

local zEnable = true
local fogEnable = true
local orderPriority = "+5"
local sizeInVehicle = {1.1, 1.1}
local sizeOnFoot = {0.35, 0.35}
local distanceBias = -0.18


local memeTable = {gui = {}, func = {}, face = {fileList = {}, name = nil, color = nil, isSet = false}, 
					render = {shader = nil, texture = {}}, isResourceLoaded = false, isGuiVisible = false}
local scx, scy = guiGetScreenSize()

------------------------------------------------------------------------------------------------------------
-- Menu
------------------------------------------------------------------------------------------------------------
function memeTable.func.createGuiBox()
	local windowWidth, windowHeight = 432, 272
	local left = scx / 10 
	local top = scy / 10
	memeTable.gui.root = guiCreateWindow(left, top, windowWidth, windowHeight, "Meme v2.0", false)
	guiWindowSetSizable(memeTable.gui.root, false)

	memeTable.gui.label = guiCreateLabel(10, 20, 411, 21, "Meme - by Ren712", false, memeTable.gui.root)
	guiLabelSetHorizontalAlign(memeTable.gui.label, "center", false)
	guiLabelSetVerticalAlign(memeTable.gui.label, "center")
	
    memeTable.gui.name = guiCreateLabel(220, 195, 201, 21, "No face chosen.", false, memeTable.gui.root)
	guiLabelSetHorizontalAlign(memeTable.gui.name, "center", false)
	guiLabelSetVerticalAlign(memeTable.gui.name, "center")
	
	memeTable.gui.faceList = guiCreateGridList(10, 46, 201, 211, false, memeTable.gui.root)				
	if memeTable.func.faceList then
		addEventHandler("onClientGUIClick", memeTable.gui.faceList, memeTable.func.faceList, false)
	end
	
	guiSetText(memeTable.gui.name, "No face chosen.")

	memeTable.gui.toggleColor = guiCreateButton(220, 215, 101, 21, "Color", false, memeTable.gui.root)
	if memeTable.func.toggleColor then
		addEventHandler("onClientGUIClick", memeTable.gui.toggleColor, memeTable.func.toggleColor, false)
	end
	
	memeTable.gui.apply = guiCreateButton(220, 235, 101, 21, "Apply", false, memeTable.gui.root)
	if memeTable.func.apply then
		addEventHandler("onClientGUIClick", memeTable.gui.apply, memeTable.func.apply, false)
	end
	
	memeTable.gui.close = guiCreateButton(320, 235, 101, 21, "Close", false, memeTable.gui.root)
	if memeTable.func.close then
		addEventHandler("onClientGUIClick", memeTable.gui.close, memeTable.func.close, false)
	end
	
	memeTable.gui.clear = guiCreateButton(320, 215, 101, 21, "Clear", false, memeTable.gui.root)
	if memeTable.func.clear then
		addEventHandler("onClientGUIClick", memeTable.gui.clear, memeTable.func.clear, false)
	end
end

function memeTable.func.toggleMeme()
	if memeTable.isGuiVisible then 
		colorPicker.closeSelect()
		showCursor(false)
		memeTable.isGuiVisible = false
		guiSetVisible(memeTable.gui.root, false)
		return 
	else
		showCursor(true)
		memeTable.isGuiVisible = true
		guiSetVisible(memeTable.gui.root, true)
	end
end

------------------------------------------------------------------------------------------------------------
-- Menu buttons
------------------------------------------------------------------------------------------------------------
function memeTable.func.faceList()
	local chosenListItem = guiGridListGetSelectedItem (memeTable.gui.faceList)
	local chosenListText = guiGridListGetItemText (memeTable.gui.faceList, chosenListItem, 1)
	if chosenListText == "" then 
		local chosenID = getElementData(localPlayer, 'memeHead')
		local chosenColor = getElementData(localPlayer, 'memeColor')
		if not chosenName or not chosenColor then 
			return false
		end
		memeTable.face.name = memeTable.face.fileList[chosenID]
		memeTable.face.id = chosenID
		memeTable.face.color = chosenColor 
		guiSetText(memeTable.gui.name, memeTable.face.name)
		guiGridListSetSelectedItem(memeTable.gui.faceList, tonumber(memeTable.face.id) - 1 ,  1)
	else
		local chosenColor = getElementData(localPlayer, 'memeColor')
		memeTable.face.name = memeTable.face.fileList[chosenListItem + 1]
		memeTable.face.id = chosenListItem + 1
		memeTable.face.color = chosenColor or tocolor(255, 255, 255, 255)
		memeTable.face.isSet = false
		guiSetText (memeTable.gui.name, memeTable.face.name)
	end
end

function memeTable.func.toggleColor(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	colorPicker.openSelect()
end

function closedColorPicker (chR, chG, chB, chA)
	memeTable.face.color = tocolor(chR, chG, chB, chA)
end

local getLastTick = getTickCount()
function memeTable.func.apply(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	if (getTickCount() - getLastTick < 500) then 
		outputChatBox("Meme: Don't spam the apply button.")
		return 
	end
	if not memeTable.face.name or not memeTable.face.color or not memeTable.face.id then 
		return 
	end
	setElementData(localPlayer, 'memeHead', memeTable.face.id, true)
	setElementData(localPlayer, 'memeColor', memeTable.face.color, true)  
	memeTable.face.isSet = true
	getLastTick = getTickCount()
end

function memeTable.func.close(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	colorPicker.closeSelect()
	showCursor(false)
	guiSetVisible(memeTable.gui.root, false)
	memeTable.isGuiVisible = nil
end

function memeTable.func.clear(button, state, absoluteX, absoluteY)
	if (button ~= "left") or (state ~= "up") then
		return
	end
	if getElementData(localPlayer, 'memeHead') then 
		memeTable.face.id = nil
		memeTable.face.name = nil
		memeTable.face.color = nil	
		setElementData(localPlayer, 'memeHead', memeTable.face.id, true)
		setElementData(localPlayer, 'memeColor', memeTable.face.color, true)
		memeTable.face.isSet = true	
		guiSetText(memeTable.gui.name, "No face chosen.")
	end	
end

------------------------------------------------------------------------------------------------------------
-- Drawing
------------------------------------------------------------------------------------------------------------
addEventHandler("onClientHUDRender", getRootElement(), function()  
	if not memeTable.isGuiVisible or not memeTable.isResourceLoaded or not memeTable.face.name then 
		return 
	end
	local posX, posY = guiGetPosition ( memeTable.gui.root, false )
	dxDrawImage ((posX + 244), (posY + 45), 145, 145, "heads/"..memeTable.face.name, 0, 0, 0, memeTable.face.color, true )
end
)

addEventHandler("onClientHUDRender", getRootElement(), function()
	local camX, camY, camZ = getCameraMatrix()
	dxSetShaderValue(memeTable.render.shader,"sCameraPosition", camX, camY, camZ)
	dxSetShaderValue(memeTable.render.shader,"sFlipTexture", false)
	for index,thisPed in ipairs(getElementsByType("player", getRootElement(), true)) do	
		if isElementStreamedIn(thisPed) then
			local hx,hy,hz = getPedBonePosition(thisPed,8)            
			local dist = getDistanceBetweenPoints3D(camX, camY, camZ, hx, hy, hz)
			if (dist < 60 ) then
				local pedElData = getElementData(thisPed, 'memeHead')
				if pedElData then
					drawFace(thisPed, pedElData, isPedInVehicle(thisPed), camX, camY, camZ)
				end
			end
		end
	end
end, true, "high"..orderPriority )

function drawFace(thisPed, textureID, isInVeh, camX, camY, camZ)
	local posX,posY,posZ = getPedBonePosition(thisPed, 8) 
	local hx2,hy2,hz2 = getPedBonePosition(thisPed, 5)
	local hx3,hy3,hz3 = getPedBonePosition(thisPed, 6)
	dxSetShaderValue(memeTable.render.shader,"sTexture", memeTable.render.texture[textureID])
	dxSetShaderValue(memeTable.render.shader,"sElementPosition",posX, posY, posZ + 0.06)
	dxSetShaderValue(memeTable.render.shader,"sDistanceBias", distanceBias)
	dxSetShaderValue(memeTable.render.shader,"sPoint1Position", hx2, hy2, hz2)
	dxSetShaderValue(memeTable.render.shader,"sPoint2Position", hx3, hy3, hz3)
	if isInVeh then
		if isLineOfSightClear (camX, camY, camZ, posX, posY, posZ, true, false, false, true, true) then
			dxSetShaderValue(memeTable.render.shader,"sDepthMul", 0.00625)
			dxSetShaderValue(memeTable.render.shader,"sElementSize", sizeInVehicle)
			local textureColor = getElementData(thisPed,"memeColor")	
			dxDrawImage(0, 0, scx, scy, memeTable.render.shader, 0, 0, 0, textureColor)
		end
	else
		dxSetShaderValue(memeTable.render.shader,"sDepthMul", 1)
		dxSetShaderValue(memeTable.render.shader,"sElementSize", sizeOnFoot)
		local textureColor = getElementData(thisPed,"memeColor")	
		dxDrawImage(0, 0, scx, scy, memeTable.render.shader, 0, 0, 0, textureColor)
	end
end

------------------------------------------------------------------------------------------------------------
-- OnClientResourceStart / OnClientResourceStop
------------------------------------------------------------------------------------------------------------
addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	outputChatBox ("Write /"..toggleCmd.." or hit "..toggleKey.." to use Ren712's meme resource!", 255, 255, 0, true)
	memeTable.render.shader = dxCreateShader("fx/image4D.fx")
	if not memeTable.render.shader then
		outputChatBox("Meme: Cold not start shader.",255, 0, 0, true)
		return 
	end
	dxSetShaderValue(memeTable.render.shader,"sScrRes", scx, scy)
	dxSetShaderValue(memeTable.render.shader,"sZEnable", zEnable)
	dxSetShaderValue(memeTable.render.shader,"sFogEnable", fogEnable)
	if not memeTable.render.shader then
		return
	end
	memeTable.func.createGuiBox()
	guiSetVisible (memeTable.gui.root, false)
	local faceColumn = guiGridListAddColumn ( memeTable.gui.faceList,"Choose your face",0.85)
	local meta = xmlLoadFile( "faces.xml" )  
	local children = xmlNodeGetChildren(meta)   
	for i,name in ipairs(children) do 
		memeTable.face.fileList[i] = xmlNodeGetAttribute(name, "file") 
		local faceName = xmlNodeGetAttribute(name, "name")
		local faceRow = guiGridListAddRow(memeTable.gui.faceList)
		memeTable.render.texture[i] = dxCreateTexture("heads/"..memeTable.face.fileList[i], "dxt3", true, "clamp")
		if not memeTable.render.texture[i] then
			outputChatBox("Meme: Could not load textures")
			return
		end
		guiGridListSetItemText(memeTable.gui.faceList, faceRow, faceColumn, faceName, false, false )
	end
	xmlUnloadFile(meta)

	memeTable.face.id = getElementData(localPlayer, 'memeHead')
	memeTable.face.color = getElementData(localPlayer, 'memeColor')
	if memeTable.face.id and memeTable.face.color then
		memeTable.face.name = memeTable.face.fileList[memeTable.face.id]
		guiSetText(memeTable.gui.name, memeTable.face.name)
		guiGridListSetSelectedItem(memeTable.gui.faceList, tonumber(memeTable.face.id) - 1 ,  1)
	else
		guiGridListSetSelectedItem(memeTable.gui.faceList, 0, 1)
		memeTable.face.name = memeTable.face.fileList[1]
		guiSetText(memeTable.gui.name, memeTable.face.name)
		memeTable.face.id = 1
		memeTable.face.color = tocolor(255, 255, 255, 255)
	end
	bindKey(toggleKey, "down", memeTable.func.toggleMeme)
	addCommandHandler(toggleCmd, memeTable.func.toggleMeme)
	memeTable.func.faceList()
	memeTable.face.isSet = true
	memeTable.isResourceLoaded = true
end
)

addEventHandler("onClientResourceStop", getResourceRootElement( getThisResource()), function()
	for i,name in ipairs(memeTable.render.texture) do
		if memeTable.render.texture[i] then
			destroyElement(memeTable.render.texture[i])
			memeTable.render.texture[i] = nil
		end
	end
	if memeTable.render.shader then
		destroyElement(memeTable.render.shader)
		memeTable.render.shader = nil
	end
end
)
