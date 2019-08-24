--[[
	MultiServer 
	Zasób: ms-map/objects_c.lua
	Opis: Streamer obiektów SA-MP
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]
DEBUG = false

local sampObjects = {} -- [model] = {x, y, z, rx, ry, rz, objectElement}
local sampMaterials = {} -- [sampID (custom object id] = {textureName, textureColor}

-- definicje modeli 
-- [oryginalne id modelu z samp] = {model, tekstura, kolizja} 
local sampModels = {
	[18820] = {"Tube50mGlassPlus1.dff", "MatTextures.txd", "Tube50mGlassPlus1.col"},
	[19703] = {"WSRocky1.dff", "WSSections.txd", "WSRocky1.col"},
	[19070] = {"WSDown1.dff", "WSSections.txd", "WSDown1.col"},
	[19005] = {"RampT4.dff", "MatRamps.txd", "RampT4.col"},
	[18777] = {"TunnelSpiral1.dff", "TunnelSections.txd", "TunnelSpiral1.col"},
	[18826] = {"Tube50mGlass180Bend.dff", "MatTextures.txd", "Tube50mGlass180Bend.col"},
	[18809] = {"Tube50mGlass1.dff", "MatTextures.txd", "Tube50mGlass1.col"},
	[18827] = {"Tube100m2.dff", "MatTextures.txd", "Tube100m2.col"},
	[18841] = {"RB50mBend180Tube.dff", "MickyTextures.txd", "RB50mBend180Tube.col"},
	[18836] = {"RBHalfpipe.dff", "MickyTextures.txd", "RBHalfpipe.col"},
	[18772] = {"TunnelSection1.dff", "TunnelSections.txd", "TunnelSection1.col"},
	[18800] = {"MRoadHelix1.dff", "MRoadHelix1.txd", "MRoadHelix1.col"},
	[18753] = {"Base125mx125m1.dff", "BaseSections.txd", "Base125mx125m1.col"},
	[18818] = {"Tube50mGlassT1.dff", "MatTextures.txd", "Tube50mGlassT1.col"},
	[18835] = {"RBFunnel.dff", "MickyTextures.txd", "RBFunnel.col"},
	[18843] = {"GlassSphere1.dff", "MatTextures.txd", "GlassSphere1.col"},
	[18790] = {"MRoadBend180Deg1.dff", "cs_ebridge.txd", "MRoadBend180Deg1.col"},
	[18789] = {"MRoad150m.dff", "cs_ebridge.txd", "MRoad150m.col"},
	[19280] = {"CarRoofLight1.dff", "MatLights.txd", "CarRoofLight1.col"},
	[18853] = {"Tube100m45Bend1.dff", "MatTextures.txd", "Tube100m45Bend1.col"},
	[18784] = {"FunBoxRamp1.dff", "MatRamps.txd", "FunBoxRamp1.col"},
	[18825] = {"Tube50m180Bend1.dff", "MatTextures.txd", "Tube50m180Bend1.col"},
	[18852] = {"Tube100m1.dff", "MatTextures.txd", "Tube100m1.col"},
	[18824] = {"Tube50mGlass90Bend1.dff", "MatTextures.txd", "Tube50mGlass90Bend1.col"},
	[18842] = {"RB50mTube.dff", "MickyTextures.txd", "RB50mTube.col"},
	[18837] = {"RB25mBend90Tube.dff", "MickyTextures.txd", "RB25mBend90Tube.col"},
	[18801] = {"MRoadLoop1.dff", "cs_ebridge.txd", "MRoadLoop1.col"},
	[18649] = {"GreenNeonTube1.dff", "MatTextures.txd", "GreenNeonTube1.col"},
	[18653] = {"DiscoLightRed.dff", "Carter_block.txd", "DiscoLightRed.col"},
	[18646] = {"PoliceLight1.dff", "MatColours.txd", "PoliceLight1.col"},
	[18648] = {"BlueNeonTube1.dff", "MatTextures.txd", "BlueNeonTube1.col"},
	[18654] = {"DiscoLightGreen.dff", "Carter_block.txd", "DiscoLightGreen.col"},
	[19071] = {"WSStraight1.dff", "WSSections.txd", "WSStraight1.col"},
	[19072] = {"WSBend45Deg1.dff", "WSSections.txd", "WSBend45Deg1.col"},
	[19428] = {"wall068.dff", "all_walls.txd", "wall068.col"},
	[19447] = {"wall087.dff", "all_walls.txd", "wall087.col"},
	[19129] = {"DanceFloor2.dff", "DanceFloors.txd", "DanceFloor2.col"},
	[18655] = {"DiscoLightBlue.dff", "Carter_block.txd", "DiscoLightBlue.col"},
	[19124] = {"BollardLight4.dff", "metal.txd", "BollardLight4.col"},
	[19126] = {"BollardLight6.dff", "metal.txd", "BollardLight6.col"},
	[19425] = {"speed_bump01.dff", "speed_bumps.txd", "speed_bump01.col"},
	[19309] = {"taxi02.dff", "taxi02.txd", "taxi02.col"},
	[19318] = {"flyingv01.dff", "flyingv01.txd", "flyingv01.col"},
	[19319] = {"warlock01.dff", "warlock01.txd", "warlock01.col"},
	[19339] = {"coffin01.dff", "coffin01.txd", "coffin01.col"},
	[18883] = {"HugeBowl2.dff", "HugeBowls.txd", "HugeBowl2.col"},
	[18876] = {"BigGreenGloop1.dff", "gloopX.txd", "BigGreenGloop1.col"},
	[18754] = {"Base250mx250m1.dff", "BaseSections.txd", "Base250mx250m1.col"},
	[18806] = {"MBridge150m4.dff", "cs_ebridge.txd", "MBridge150m4.col"},
	[18988] = {"Tube25mCutEnd1.dff", "MatTextures.txd", "Tube25mCutEnd1.col"},
	[18854] = {"Tube100m90Bend1.dff", "MatTextures.txd", "Tube100m90Bend1.col"},
	[18999] = {"Tube200mBendy1.dff", "MatTextures.txd", "Tube200mBendy1.col"},
	[18855] = {"Tube100m180Bend1.dff", "MatTextures.txd", "Tube100m180Bend1.col"},
	[18810] = {"Tube50mBulge1.dff", "MatTextures.txd", "Tube50mBulge1.col"},
	[18799] = {"MRoadB45T15DegR.dff", "cs_ebridge.txd", "MRoadB45T15DegR.col"},
	[18792] = {"MRoadTwist15DegL.dff", "cs_ebridge.txd", "MRoadTwist15DegL.col"},
	[18770] = {"SkyDivePlatform1b.dff", "SkyDivePlatforms.txd", "SkyDivePlatform1b.col"},
	[18779] = {"RampT2.dff", "MatRamps.txd", "RampT2.col"},
	[19449] = {"wall089.dff", "all_walls.txd", "wall089.col"},
	[19325] = {"lsmall_window01.dff", "lsmall_shops.txd", "lsmall_window01.col"},
	[19435] = {"wall075.dff", "all_walls.txd", "wall075.col"},
	[19454] = {"wall094.dff", "all_walls.txd", "wall094.col"},
	[19375] = {"wall023.dff", "all_walls.txd", "wall023.col"},
	[18780] = {"RampT3.dff", "MatRamps.txd", "RampT3.col"},
	[19130] = {"ArrowType1.dff", "MatArrows.txd", "ArrowType1.col"},
	[18771] = {"SpiralStair1.dff", "MatStairs.txd", "SpiralStair1.col"},
	[18768] = {"SkyDivePlatform1.dff", "SkyDivePlatforms.txd", "SkyDivePlatform1.col"},
	[18764] = {"Concrete5mx5mx5m.dff", "ConcreteBits.txd", "Concrete5mx5mx5m.col"},
	[18765] = {"Concrete10mx10mx5m.dff", "ConcreteBits.txd", "Concrete10mx10mx5m.col"},
	[18762] = {"Concrete1mx1mx5m.dff", "ConcreteBits.txd", "Concrete1mx1mx5m.col"},
	[18763] = {"Concrete3mx3mx5m.dff", "ConcreteBits.txd", "Concrete3mx3mx5m.col"},
	[18781] = {"MeshRampBig.dff", "MatRamps.txd", "MeshRampBig.col"},
	[18778] = {"RampT1.dff", "landjump.txd", "RampT1.col"},
	[18830] = {"RTexturebridge.dff", "MickyTextures.txd", "RTexturebridge.col"},
	[18850] = {"HeliPad1.dff", "sfe_copchop.txd", "HeliPad1.col"},
	[18859] = {"QuarterPipe1.dff", "glenpark7_lae.txd", "QuarterPipe1.col"},
	[18857] = {"Cage20mx20mx10m.dff", "MatTextures.txd", "Cage20mx20mx10m.col"},
	[18813] = {"Tube50mGlassFunnel1.dff", "MatTextures.txd", "Tube50mGlassFunnel1.col"},
	[18783] = {"FunBoxTop1.dff", "MatRamps.txd", "FunBoxTop1.col"},
	[18787] = {"FunBoxRamp4.dff", "MatRamps.txd", "FunBoxRamp4.col"},
	[18858] = {"FoamHoop1.dff", "MatRamps.txd", "FoamHoop1.col"},
	[18769] = {"SkyDivePlatform1a.dff", "SkyDivePlatforms.txd", "SkyDivePlatform1a.col"},
	[18647] = {"RedNeonTube1.dff", "MatTextures.txd", "RedNeonTube1.col"},
	[18750] = {"SAMPLogoBig.dff", "MatTextures.txd", "SAMPLogoBig.col"}, 
	[19313] = {"a51fensin.dff", "a51fencing.txd", "a51fensin.col"},
	[19278] = {"LiftPlatform1.dff", "SkyDivePlatforms.txd", "LiftPlatform1.col"},
	[19381] = {"wall029.dff", "all_walls.txd", "wall029.col"},
	[19127] = {"BollardLight7.dff", "metal.txd", "BollardLight7.col"},
	[18878] = {"FerrisBaseBit.dff", "FerrisWheel.txd", "FerrisBaseBit.col"},
	[18840] = {"RB50mBend90Tube.dff", "MickyTextures.txd", "RB50mBend90Tube.col"},
	[18839] = {"RB50mBend45Tube.dff", "MickyTextures.txd", "RB50mBend45Tube.col"},
	[18829] = {"RTexturetube.dff", "MickyTextures.txd", "RTexturetube.col"},
	[18834] = {"RT50mBend180Tube1.dff", "MickyTextures.txd", "RT50mBend180Tube1.col"},
	[18833] = {"RT50mBend45Tube1.dff", "MickyTextures.txd", "RT50mBend45Tube1.col"},
	[18981] = {"Concrete1mx25mx25m.dff", "ConcreteBits.txd", "Concrete1mx25mx25m.col"},
	[18816] = {"Tube50mFunnel4.dff", "MatTextures.txd", "Tube50mFunnel4.col"},
	[18811] = {"Tube50mGlassBulge1.dff", "MatTextures.txd", "Tube50mGlassBulge1.col"},
	[18851] = {"TubeToRoad1.dff", "MatTextures.txd", "TubeToRoad1.col"},
	[18985] = {"Tube100m6.dff", "MatTextures.txd", "Tube100m6.col"},
	[18986] = {"TubeToPipe1.dff", "MatTextures.txd", "TubeToPipe1.col"},
	[18984] = {"Tube100m5.dff", "MatTextures.txd", "Tube100m5.col"},
	[18815] = {"Tube50mFunnel3.dff", "MatTextures.txd", "Tube50mFunnel3.col"},
	[18983] = {"Tube100m4.dff", "MatTextures.txd", "Tube100m4.col"},
	[18989] = {"Tube25m45Bend1.dff", "MatTextures.txd", "Tube25m45Bend1.col"},
	[19000] = {"Tube200mBulge1.dff", "MatTextures.txd", "Tube200mBulge1.col"},
	[19002] = {"FireHoop1.dff", "MatRamps.txd", "FireHoop1.col"},
	[18982] = {"Tube100m3.dff", "MatTextures.txd", "Tube100m3.col"},
	[18822] = {"Tube50mGlass45Bend1.dff", "MatTextures.txd", "Tube50mGlass45Bend1.col"},
	[18844] = {"WaterUVAnimSphere1.dff", "MatTextures.txd", "WaterUVAnimSphere1.col"},
	[18766] = {"Concrete10mx1mx5m.dff", "ConcreteBits.txd", "Concrete10mx1mx5m.col"},
	[18820] = {"Tube50mGlassPlus1.dff", "MatTextures.txd", "Tube50mGlassPlus1.col"},
	[19336] = {"Hot_Air_Balloon05.dff", "balloon_texts.txd", "Hot_Air_Balloon05.col"},
	[19001] = {"VCWideLoop1.dff", "MatRamps.txd", "VCWideLoop1.col"},
	[19073] = {"WSRocky1.dff", "WSSections.txd", "WSRocky1.col"},
	[19379] = {"wall027.dff", "all_walls.txd", "wall027.col"},
	[19462] = {"wall102.dff", "all_walls.txd", "wall102.col"},
	[18761] = {"RaceFinishLine1.dff", "MatRacing.txd", "RaceFinishLine1.col"},
	[19012] = {"GlassesType7.dff", "MatGlasses.txd", "GlassesType7.col"},
	[18868] = {"MobilePhone4.dff", "MobilePhone4.txd", "MobilePhone4.col"},
	[18635] = {"GTASAHammer1.dff", "MatTextures.txd", "GTASAHammer1.col"},
	[18632] = {"FishingRod.dff", "FishingRod.txd", "FishingRod.col"},
	[19317] = {"bassguitar01.dff", "bassguitar01.txd", "bassguitar01.col"},
	[19422] = {"headphones02.dff", "headphones.txd", "headphones02.col"},
	[19352] = {"tophat01.dff", "classy.txd", "tophat01.col"},
	[19348] = {"cane01.dff", "classy.txd", "cane01.col"},
	[19466] = {"window001.dff", "lsmall_shops.txd", "window001.col"},
	[18751] = {"IslandBase1.dff", "MatTextures.txd", "IslandBase1.col"},
	[19452] = {"wall092.dff", "all_walls.txd", "wall092.col"},
	[18759] = {"DMCage1.dff", "DMCages.txd", "DMCage1.col"},
	[18690] = {"fire_car.dff", "MatTextures.txd", "fire_car.col"},
	[18728] = {"smoke_flare.dff", "MatTextures.txd", "smoke_flare.col"},
	[19450] = {"wall090.dff", "all_walls.txd", "wall090.col"},
	[19461] = {"wall101.dff", "all_walls.txd", "wall101.col"},
	[19373] = {"wall021.dff", "all_walls.txd", "wall021.col"},
	[19369] = {"wall017.dff", "all_walls.txd", "wall017.col"},
	[19358] = {"wall006.dff", "all_walls.txd", "wall006.col"},
	[19397] = {"wall045.dff", "all_walls.txd", "wall045.col"},
	[19388] = {"wall036.dff", "all_walls.txd", "wall036.col"},
	[19450] = {"wall090.dff", "all_walls.txd", "wall090.col"},
	[19464] = {"wall104.dff", "all_walls.txd", "wall104.col"},
	[19458] = {"wall017.dff", "all_walls.txd", "wall017.col"},
	[19439] = {"wall079.dff", "all_walls.txd", "wall079.col"},
	[19448] = {"wall088.dff", "all_walls.txd", "wall088.col"},
	[19430] = {"wall070.dff", "all_walls.txd", "wall070.col"},
	[19387] = {"wall035.dff", "all_walls.txd", "wall035.col"},
	[19403] = {"wall051.dff", "all_walls.txd", "wall051.col"},
	[19357] = {"wall005.dff", "all_walls.txd", "wall005.col"},
	[19174] = {"SAMPPicture3.dff", "SAMPPictures.txd", "SAMPPicture3.col"},
	[19370] = {"wall018.dff", "all_walls.txd", "wall018.col"},
	[19172] = {"SAMPPicture1.dff", "SAMPPictures.txd", "SAMPPicture1.col"},
	[19366] = {"wall014.dff", "all_walls.txd", "wall014.col"},
	[19468] = {"bucket01.dff", "bucket01.txd", "bucket01.col"},
	[19360] = {"wall008.dff", "all_walls.txd", "wall008.col"},
	[19433] = {"wall073.dff", "all_walls.txd", "wall073.col"},
	[19440] = {"wall080.dff", "all_walls.txd", "wall080.col"},
	[19165] = {"GTASAMap2.dff", "gtamap.txd", "GTASAMap2.col"},
	[19463] = {"wall103.dff", "all_walls.txd", "wall103.col"},
	[18786] = {"FunBoxRamp3.dff", "MatRamps.txd", "FunBoxRamp3.col"},
	[19176] = {"LSOffice1Door1.dff", "skyscrapelan2.txd", "LSOffice1Door1.col"},
	[19362] = {"wall010.dff", "all_walls.txd", "wall010.col"},
	[19377] = {"wall025.dff", "all_walls.txd", "wall025.col"},
	[19075] = {"Cage5mx5mx3mv2.dff", "MatTextures.txd", "Cage5mx5mx3mv2.col"},
	[19272] = {"DMCage3.dff", "DMCages.txd", "DMCage3.col"},
	[19355] = {"wall003.dff", "all_walls.txd", "wall003.col"},
	[19076] = {"XmasTree1.dff", "XmasTree1.txd", "XmasTree1.col"},
	[19057] = {"XmasBox4.dff", "XmasBoxes.txd", "XmasBox4.col"},
	[19056] = {"XmasBox3.dff", "XmasBoxes.txd", "XmasBox3.col"},
	[19055] = {"XmasBox2.dff", "XmasBoxes.txd", "XmasBox2.col"},
	[19065] = {"SantaHat2.dff", "SantaHats.txd", "SantaHat2.col"},
	[19058] = {"XmasBox5.dff", "XmasBoxes.txd", "XmasBox5.col"},
	[19123] = {"BollardLight3.dff", "metal.txd", "BollardLight3.col"},
	[19315] = {"deer01.dff", "deer01.txd", "deer01.col"},
	[19064] = {"SantaHat1.dff", "SantaHats.txd", "SantaHat1.col"},
	[19054] = {"XmasBox1.dff", "XmasBoxes.txd", "XmasBox1.col"},
	[19608] = {"WoodenStage1.dff", "WoodenStage1.txd", "WoodenStage1.col"},
	[19610] = {"Microphone1.dff", "Microphone1.txd", "Microphone1.col"},
	[19089] = {"Rope3.dff", "MatRopes.txd", "Rope3.col"},
	[19376] = {"wall024.dff", "all_walls.txd", "wall024.col"},
	[19356] = {"wall004.dff", "all_walls.txd", "wall004.col"},
	[19386] = {"wall034.dff", "all_walls.txd", "wall034.col"},
	[19429] = {"wall069.dff", "all_walls.txd", "wall069.col"},
	[19402] = {"wall050.dff", "all_walls.txd", "wall050.col"},
}


-- id do podmianek 
local allowedModels = {
	1776, 2218, 2219, 2221, 2703, 2768, 2769, 2804, 
	2814, 2858, 2866, 2880,	1899, 1909, 1910, 1912, 
	1913, 1914, 1923, 1924, 1925, 1926, 1927, 1928,
	1934, 1935, 1936, 1937, 1938, 1939, 1900, 1905,
	1906, 1907, 1908, 1915, 1916, 1917, 1918, 1919,
	1920, 1922, 3002, 3100, 3101, 3102, 3103, 3104, 
	3105, 3106, 3003, 2040, 3082, 3113, 3788, 3789, 
	3249, 7521, 8400, 8395, 8399, 8501, 8663, 9070, 
	9071, 9072, 9076, 14399, 14463, 14533, 14536, 
	14563, 14581, 14590, 14606, 14607, 14614, 14623, 
	14607, 14624, 14625, 14738, 14777, 14785, 9582, 
	10398, 10713, 13132, 
}

local requestedModels = {} 
local requestedMTAModels = {} 
local cachedTextures = {} 
local cachedModels = {} 
local cachedCols = {} 

local function swap(table)
	local temp = {} 
	for k, v in pairs(table) do 
		temp[v] = k 
	end
	
	return temp 
end 

-- wyszukuje wolny model 
function getFreeModel()
	local mtaRequestedModels = swap(requestedModels)
	for k,v in ipairs(allowedModels) do 
		if not mtaRequestedModels[v] then 
			return v 
		end
	end
	
	if DEBUG then outputChatBox("koniec wolnych modeli", 5) end
	return false
end 

-- przywraca model z GTA:SA
function unloadModel(model)
	local mtaModel = requestedModels[model] 
	if mtaModel then 
		local sameModelCount = 0 
		for k,v in ipairs(sampObjects) do 
			if v[11] and v[2] == model then
				sameModelCount = sameModelCount+1 
			end
		end 
		
		if sameModelCount > 1 then 
			return
		end 
		
		engineRestoreCOL(mtaModel)
		engineRestoreModel(mtaModel)
		requestedModels[model] = nil
	end
end 

-- podmienia na obiekt z SAMP 
-- zwraca podmienione id obiektu 
function replaceModel(sampModel)
	if requestedModels[sampModel] then return requestedModels[sampModel] end

	local freeModel = getFreeModel() 
	
	if not freeModel then
		return false
	end 
	
	requestedModels[sampModel] = freeModel
	
	local txdPath, dffPath, colPath
	local txdData, dffData, colData
	if sampModels[sampModel] then 
		txdPath, dffPath, colPath = sampModels[sampModel][2], sampModels[sampModel][1], sampModels[sampModel][3]
		txdData, dffData, colData = cachedTextures[txdPath], cachedModels[dffPath], cachedCols[colPath] 
	else 
		if DEBUG then outputChatBox("brak modelu "..tostring(sampModel), 5) end
	end 
	
	engineSetModelLODDistance(freeModel, 300)
	
	if colData then 
		engineReplaceCOL(colData, freeModel)
	end 
	
	if txdData then 
		engineImportTXD(txdData, freeModel)
	end 
	
	if dffData then 
		engineReplaceModel(dffData, freeModel, true)
	end 
	
	return freeModel
end 

-- wczytuje nowy obiekt 
function streamInObject(index)
	local data = sampObjects[index]
	if data and not data[11] then
		if (data[9] and data[9] ~= getElementDimension(localPlayer)) or (data[10] and data[10] ~= getElementInterior(localPlayer)) then return end 
		local freeModel = replaceModel(data[2])
		
		if not freeModel then return end 
		
		data[11] = createObject(freeModel, data[3], data[4], data[5], data[6], data[7], data[8])
		setElementData(data[11], "samp", true, false)
		setElementData(data[11], "samp:model", data[2], false)
		setElementDoubleSided(data[11], true)
		if data[9] then setElementDimension(data[11], data[9]) end 
		if data[10] then setElementInterior(data[11], data[10]) end 
		
		local sampID = data[1]
		streamInMaterial(sampID)
		
		sampObjects[index][11] = data[11]
	end
end 

-- wyładowywuje nowy obiekt
function streamOutObject(index)
	local data = sampObjects[index]
	if data and isElement(data[11]) then 
		unloadModel(data[2])
		
		local sampID = data[1]
		streamOutMaterial(sampID)
		
		destroyElement(data[11])
		
		sampObjects[index][11] = nil
	end
end 

-- funkcje przeznaczone do materiałów.
function streamInMaterial(object)
	if sampMaterials[object] and not sampMaterials[object].shader then
		sampMaterials[object].shader = dxCreateShader("materials/shader.fx")
		sampMaterials[object].texture = dxCreateTexture("materials/"..sampMaterials[object].material..".png")
		dxSetShaderValue(sampMaterials[object].shader, "Tex", sampMaterials[object].texture)
		--engineApplyShaderToWorldTexture(sampMaterials[object].shader, sampMaterials[object].replaceTexture, object)
		outputChatBox("CMON")
	end 
end 

function streamOutMaterial(object)
	if sampMaterials[object] and sampMaterials[object].shader then 
		--engineRemoveShaderFromWorldTexture (sampMaterials[object].shader, sampMaterials[object].replaceTexture, object)
		destroyElement(sampMaterials[object].shader)
		destroyElement(sampMaterials[object].texture)
		sampMaterials[object].shader = nil
		sampMaterials[object].texture = nil
	end
end 

-- aktualizacja wczytywania obiektów
function updateStreamer()
	local camX, camY, camZ = getCameraMatrix()
	
	Async:foreach(sampObjects, function(v, k) 
		local model = v[2]
		local x,y,z = v[3], v[4], v[5]
		local dist = getDistanceBetweenPoints3D(x, y, z, camX, camY, camZ)
		if dist <= 400 then 
			streamInObject(k)
		else
			streamOutObject(k)
		end
	end)
	
	-- niektóre obiekty GTA mają podmieniane teksturki. No kurwa.
	for object, data in pairs(sampMaterials) do
		if isElement(object) then
			local x, y, z = getElementPosition(object)
			local dist = getDistanceBetweenPoints3D(x, y, z, camX, camY, camZ)
			if dist <= 400 then 
				streamInMaterial(object)
			else
				streamOutMaterial(object)
			end
		end
	end
end 
setTimer(updateStreamer, 100, 0)

function preloadSAMPModels()
	Async:setPriority(1000, 50)
	engineSetAsynchronousLoading(true, true)
	
	for k,v in pairs(sampModels) do
		local txdData = engineLoadTXD("samp/"..v[2])
		cachedTextures[v[2]] = txdData
		
		if not txdData then 
			if DEBUG then outputChatBox("nie załadowano "..v[2], 1) end
		end  
		
		local dffData = engineLoadDFF("samp/"..v[1])
		cachedModels[v[1]] = dffData
		
		if not dffData then 
			if DEBUG then outputChatBox("nie załadowano "..v[1], 1) end
		end 
		
		local colData = engineLoadCOL("samp/"..v[3])
		cachedCols[v[3]] = colData
		
		if not colData then
			if DEBUG then outputChatBox("nie załadowano "..v[3], 1) end
		end 
	end
	
	if DEBUG then 
		addEventHandler("onClientClick", root, function(button, state, ax, ay, wx, wy, wz, clickedWorld)
			if isElement(clickedWorld) and getElementType(clickedWorld) == "object"  then 
				local x, y, z = getElementPosition(clickedWorld)
				local rx, ry, rz = getElementRotation(clickedWorld)
				outputChatBox("SAMP: "..tostring(getElementData(clickedWorld, "samp") and getElementData(clickedWorld, "samp:model") or "nie").." Model: "..tostring(getElementModel(clickedWorld)).." X: "..tostring(x).." Y: "..tostring(y).." Z: "..tostring(z).." RX: "..tostring(rx).." RY: "..tostring(ry).." RZ: "..tostring(rz), 5)
			end
		end)
	end 
	
	triggerServerEvent("onPlayerRequestSAMPObjects", localPlayer)
end 
addEventHandler("onClientResourceStart", resourceRoot, preloadSAMPModels)

function cancelSAMPObjectDamage(attacker)
	if not attacker then return end 
	
	if getElementType(attacker) == "object" and getElementData(attacker, "samp") then 
		cancelEvent()
	end
end 
addEventHandler("onClientVehicleDamage", root, cancelSAMPObjectDamage)

function onClientLoadSAMPObjects(objects, materials)
	if sampObjects then 
		for k,v in ipairs(sampObjects) do 
			streamOutObject(k)
		end
		
		sampObjects = {}
		sampMaterials = {}
	end 
	
	sampObjects = objects 
	sampMaterials = materials
end 
addEvent("onClientLoadSAMPObjects", true)
addEventHandler("onClientLoadSAMPObjects", root, onClientLoadSAMPObjects)