local x, y, z = 383.3990, -2746.9300, 6.8575
local loadDistance = 500
local objects = {}
local models = {
	[9305] = {txd="china/tenchuh.txd", dff="china/tenchuh.dff", col="china/tenchuh.col"},
	[3048] = {txd="china/tenchuh.txd", dff="china/tenchuh2.dff", col="china/tenchuh2.col"},
	[3522] = {txd="china/tenchumuro.txd", dff="china/tenchuh3.dff", col="china/tenchuh3.col"},
	[7955] = {txd="china/tenchuh.txd", dff="china/tenchuh4.dff", col="china/tenchuh4.col"},
	[6006] = {txd="china/tenchumuro.txd", dff="china/tenchuh5.dff", col="china/tenchuh5.col"},
}
local dimension = 0 
local interior = 0 

local function createCustomObject(...)
	local obj = createObject(...)
	setElementDimension(obj, dimension)
	setElementInterior(obj, interior)
	table.insert(objects, obj)
end 

createCustomObject ( 3522, 385.4994, -2752.7303, 6.8215 ) -- tenchuh3
createCustomObject ( 9305, 383.3990, -2746.9300, 6.8575 ) -- tenchuh
createCustomObject ( 3048, 383.3990, -2746.9300, 6.8575 ) -- tenchuh2
createCustomObject ( 7955, 383.3990, -2746.9300, 6.8575 ) -- tenchuh4
createCustomObject ( 6006, 332.3990, -2746.3300, 6.8575 ) -- reszta tenchuh5
createCustomObject ( 6006, 332.3990, -2752.8400, 6.8575 )
createCustomObject ( 6006, 332.3990, -2759.6600, 6.8575 )
createCustomObject ( 6006, 325.3451, -2760.0085, 6.8575 )
createCustomObject ( 6006, 325.3450, -2753.1000, 6.8575 )
createCustomObject ( 6006, 325.3450, -2746.4400, 6.8575 )
createCustomObject ( 6006, 325.3450, -2724.5300, 6.8575 )
createCustomObject ( 6006, 324.9450, -2717.6300, 6.8575 )
createCustomObject ( 6006, 325.3450, -2730.7400, 6.8575 )
createCustomObject ( 6006, 332.3990, -2730.4000, 6.8575 )
createCustomObject ( 6006, 332.3990, -2724.4700, 6.8575 )
createCustomObject ( 6006, 332.3990, -2717.2300, 6.8575 )

local function loadModels()
	for id, data in pairs(models) do 
		if data.col then 
			engineReplaceCOL(engineLoadCOL(data.col), id)
		end 
		
		if data.txd then 
			engineImportTXD(engineLoadTXD(data.txd), id)
		end 
		
		if data.dff then 
			engineReplaceModel(engineLoadDFF(data.dff), id)
			engineSetModelLODDistance(id, 300)
		end
	end
end 

local function unloadModels()
	for id, data in pairs(models) do 
		if data.col then 
			engineRestoreCOL(id)
		end 
		
		if data.dff then 
			engineRestoreModel(id)
		end
	end
end 

-- muza z metin 2 XDD
addEventHandler("onClientFinishCustomDownload", resourceRoot, function()
	local sound = playSound3D("china/music.mp3", 377.28,-2755.78,7.86, true)
	setSoundVolume(sound, 0.7)
	setSoundMaxDistance(sound, 150)
end)

local loaded = false
function updateChinaMap()
	local cx, cy, cz = getCameraMatrix()
	local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
	
	local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
	if int ~= interior or dim ~= dimension then dist = 9999 end 

	if dist > loadDistance then 
		if loaded then 
			unloadModels()
			loaded = false
		end
	else 
		if not loaded then 
			loadModels()
			loaded = true
		end
	end
end