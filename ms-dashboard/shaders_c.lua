function enableDynamicSky()
	local state = getElementData(localPlayer, "player:shader_sky") or false
	triggerEvent("switchDynamicSky", root, not state)
	setElementData(localPlayer, "player:shader_sky", not state)
end

function enableDOF()
	local state = getElementData(localPlayer, "player:shader_dof") or false
	triggerEvent("switchDoF", root, not state)
	setElementData(localPlayer, "player:shader_dof", not state)
end

function enablePalette()
	local state = getElementData(localPlayer, "player:shader_palette") or false
	triggerEvent("switchPalette", root, not state)
	setElementData(localPlayer, "player:shader_palette", not state)
end

function enableCarpaint()
	local state = getElementData(localPlayer, "player:shader_carpaint") or false
	triggerEvent("switchCarPaintReflectLite", root, not state)
	setElementData(localPlayer, "player:shader_carpaint", not state)
end

function enableWater()
	local state = getElementData(localPlayer, "player:shader_water") or false
	triggerEvent("switchWaterShine", root, not state)
	setElementData(localPlayer, "player:shader_water", not state)
end

function enableDetail()
	local state = getElementData(localPlayer, "player:shader_detail") or false
	triggerEvent("onClientSwitchDetail", root, not state)
	setElementData(localPlayer, "player:shader_detail", not state)
end

function enableRoadshine()
	local state = getElementData(localPlayer, "player:shader_roadshine") or false
	triggerEvent("switchRoadshine3", root, not state)
	setElementData(localPlayer, "player:shader_roadshine", not state)
end

function enableSnow()
	if getElementData(localPlayer, "player:shader_detail") or getElementData(localPlayer, "player:shader_roadshine") then 
		triggerEvent("onClientAddNotification", localPlayer, "Ten shader jest niekompatybilny z przebłyskami dróg i detalami tekstur.", "warning")
	end 
	
	local state = getElementData(localPlayer, "player:shader_snow") or false
	state = not state
	exports.shader_snow:setShaderEnabled(state)
	setElementData(localPlayer, "player:shader_snow", state)
end

function loadPlayerShaders(data)
	data = fromJSON(data)
	local sky = data[1] 
	local dof = data[2] 
	local palette = data[3] 
	local carpaint = data[4] 
	local water = data[5] 
	local detail = data[6] 
	local roadshine = data[7]
	local snow = data[8]
	if sky then enableDynamicSky() end 
	if dof then enableDOF() end 
	if palette then enablePalette() end 
	if carpaint then enableCarpaint() end 
	if water then enableWater() end 
	if detail then enableDetail() end
	if roadshine then enableRoadshine() end
	if snow then enableSnow() end
end
addEvent("onPlayerLoadShaders", true)
addEventHandler("onPlayerLoadShaders", root, loadPlayerShaders)