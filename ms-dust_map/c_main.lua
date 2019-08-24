--
-- c_main.lua
--

local mapTable = {defPos = {99.09668, 2490.682, 206.0773}, defInter = 1, dim = 999,
				shader = {}, texture = {}, light = {}, object = {}, model = { txd = {}, col = {}, dff = {}}}

local replaceData = {
	{model_file="Dust2_01", coll_file="Dust2_01", txd_file="Dust2", model=4838, lod=700, is_alpha=false},
	{model_file="Dust2_02", coll_file="Dust2_02", txd_file="Dust2", model=4832, lod=700, is_alpha=false},
	{model_file="Dust2_03", coll_file="Dust2_03", txd_file="Dust2", model=4833, lod=700, is_alpha=false},
	{model_file="Dust2_04", coll_file="Dust2_04", txd_file="Dust2", model=4835, lod=700, is_alpha=false},
	{model_file="Dust2_05", coll_file="Dust2_05", txd_file="Dust2", model=4826, lod=700, is_alpha=false},
	{model_file="Dust2_06", coll_file="Dust2_06", txd_file="Dust2", model=4824, lod=700, is_alpha=false},
	{model_file="Dust2_07", coll_file="Dust2_07", txd_file="Dust2", model=4638, lod=700, is_alpha=false},
	{model_file="Dust2_08", coll_file="Dust2_08", txd_file="Dust2", model=4609, lod=700, is_alpha=false},
	{model_file="Dust2_09", coll_file="Dust2_09", txd_file="Dust2", model=4269, lod=700, is_alpha=false}
				}

-- + offsets to standard position
local objectData = {
	{mid=4838, name="Dust2_01", pos={17.28, 13.878, 2.593}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4832, name="Dust2_02", pos={-36.288, 37.152, 1.081}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4833, name="Dust2_03", pos={-42.55,  -7.128,  5.616}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4835, name="Dust2_04", pos={-1.512, 8.64, 3.456}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4826, name="Dust2_05", pos={32.616, 25.056, 2.16}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4824, name="Dust2_06", pos={22.464, 60.48, 3.024}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4638, name="Dust2_07", pos={-18.403, 65.902, 3.294}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4609, name="Dust2_08", pos={-50.4, 71.712,  5.181}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod=false, isSmap=true},
	{mid=4269, name="Dust2_09", pos={-2.504, 31.63, 4.752}, rot={0,0,0}, size=1, ap=255, col=true, dsid=false, isLowLod =false, isSmap=true}
				}

-- no offsets to standard position
local lightData = {
	{lType="point", pos={131.5, 2492.3999, 203.60001}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={112.3, 2559, 204.39999}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={75.7, 2535.8999, 205.10001}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={70.6, 2524.2, 209.39999}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={118, 2505.2, 206.10001}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={112.1, 2504.5, 208}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={46, 2523, 208}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={74, 2532, 205}, dir=nil, radius=7, color={255,255,255}},
	{lType="point", pos={108, 2559, 204}, dir=nil, radius=7, color={255,255,255}},
	
	{lType="dark", pos={134, 2488.8, 200.89999}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={106.6, 2554.3, 202.60001}, dir=nil, radius=6, color=nil},
	{lType="dark", pos={104.6, 2546.6001, 202.60001}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={112.9, 2553.3, 202.60001}, dir=nil, radius=7, color=nil},
	{lType="dark", pos={112.6, 2547.3, 202.60001}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={138.39999, 2486.5, 200.89999}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={113.7, 2504.2, 206.10001}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={85.8, 2489.3999, 208.89999}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={76.8, 2535.6001, 203.10001}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={68.8, 2530.1001, 203.10001}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={55, 2522, 208}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={75 ,2526, 205}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={65.7, 2528.2, 207}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={47.6, 2529.1001, 207}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={45.4, 2533.6001, 207}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={56.6, 2534.5, 207}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={58.8, 2527.7, 207}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={106.6, 2559.5, 202.7}, dir=nil, radius=10, color=nil},
	{lType="dark", pos={75.8, 2504.8, 206.2}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={140.60001, 2490.8, 201.3}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={118, 2558.3999, 202.60001}, dir=nil, radius=9, color=nil},
	{lType="dark", pos={77.1, 2529.2, 203.10001}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={54.7, 2528.8999, 207}, dir=nil, radius=13, color=nil},
	{lType="dark", pos={100, 2545, 204}, dir=nil, radius=9, color=nil},
	{lType="dark", pos={120, 2507, 208}, dir=nil, radius=9, color=nil},
	{lType="dark", pos={101, 2555, 204}, dir=nil, radius=9, color=nil},
	{lType="dark", pos={98, 2553, 204}, dir=nil, radius=9, color=nil}
}

----------------------------------------------------------------------------------------
-- loading/unloading map objects
----------------------------------------------------------------------------------------
function load_map()
	for n,obj in ipairs(objectData) do
		mapTable.object[n] = createObject(obj.mid, obj.pos[1] + mapTable.defPos[1], obj.pos[2] + mapTable.defPos[2], obj.pos[3] + mapTable.defPos[3], obj.rot[1], obj.rot[2], obj.rot[3], obj.isLowLod)
		if not obj.isLowLod then setElementCollisionsEnabled(mapTable.object[n], obj.col) end
		if obj.dsid then
			setElementDoubleSided(mapTable.object[n], true)
		end
		setElementInterior(mapTable.object[n], mapTable.defInter)
		setElementDimension(mapTable.object[n], mapTable.dim)
		setObjectScale(mapTable.object[n], obj.size)
	end
end

function unload_map()
	for n,obj in ipairs(objectData) do
		destroyElement(mapTable.object[n])
		mapTable.object[n] = nil
	end
end

----------------------------------------------------------------------------------------
-- loading/restoring custom objects
----------------------------------------------------------------------------------------
function load_models()
	mapTable.model.txd = {}
	mapTable.model.col = {}
	mapTable.model.dff = {}
	--outputDebugString('Loading models...')
	for n,mdl in ipairs(replaceData) do
		object_load(mdl,n)
		if mdl.model_file then
			--outputDebugString('Loading '..mdl.model_file..' for model ID: '..mdl.model)	
		end
	end
	--outputDebugString('Loading done')
end
addEvent("loadDustModels", true)
addEventHandler("loadDustModels", getRootElement(), load_models)


function unload_models()
	--outputDebugString('Restoring models')
	for n,mdl in ipairs(replaceData) do 
		if mapTable.model.dff[n] then
			--outputDebugString('Unloading '..mdl.model_file..' from model ID: '..mdl.model)
			engineRestoreModel ( mdl.model )
			destroyElement( mapTable.model.dff[n])
			mapTable.model.dff[n] = nil
		end
		if mapTable.model.col[n] then
			engineRestoreCOL ( mdl.model )
			destroyElement( mapTable.model.col[n])
			mapTable.model.col[n] = nil
		end
		if mapTable.model.txd[n] then
			destroyElement( mapTable.model.txd[n])
			mapTable.model.txd[n] = nil
		end
	end
	--outputDebugString('Restoring done')
end
addEvent("unloadDustModels", true)
addEventHandler("unloadDustModels", getRootElement(), unload_models)


function object_load(mdl,n)
	if mdl.txd_file then
		mapTable.model.txd[n] = engineLoadTXD ( "txd/"..mdl.txd_file..".txd")
		engineImportTXD ( mapTable.model.txd[n], mdl.model )
	end
	if mdl.coll_file then
		mapTable.model.col[n] = engineLoadCOL( "col/"..mdl.coll_file..".col" )
		engineReplaceCOL( mapTable.model.col[n], mdl.model )
	end
	if mdl.model_file then
		mapTable.model.dff[n] = engineLoadDFF ( "dff/"..mdl.model_file..".dff", 0 )
		engineReplaceModel ( mapTable.model.dff[n], mdl.model, mdl.is_alpha )
	end
	engineSetModelLODDistance ( mdl.model, mdl.lod )
end

----------------------------------------------------------------------------------------
-- shader management for the map resource
----------------------------------------------------------------------------------------
function load_shaders()
	local isValid = true
	for n,obj in ipairs(objectData) do
		if objectData[n].isSmap then
			--outputDebugString('creating shader for: '..objectData[n].name)
			mapTable.shader[n] = dxCreateShader("fx/dust2Smap.fx",4,0,false,"world,object")
			local tempString = "smap/Dust2_0"..n.."CompleteMap.tga"
			--outputDebugString('loading texture: '..tempString)
			mapTable.texture[n] = dxCreateTexture(tempString,"argb")
			isValid = isValid and mapTable.texture[n] and mapTable.shader[n]
			if isValid then
				dxSetShaderValue(mapTable.shader[n],"gTexture",mapTable.texture[n])
				engineApplyShaderToWorldTexture(mapTable.shader[n],"*",mapTable.object[n])
			else
				outputChatBox('de_dust2 lightmap failed to load!',255,0,0)
				unload_shaders()
				return false
			end
		end
	end
end

function unload_shaders()
	for n,obj in ipairs(objectData) do
		if isElement(mapTable.shader[n]) then
			--outputDebugString('removing shader from: '..objectData[n].name)
			engineRemoveShaderFromWorldTexture(mapTable.shader[n],"*",mapTable.object[n])
			destroyElement(mapTable.shader[n])
			mapTable.shader[n] = nil
		end
		if isElement(mapTable.texture[n]) then
			local tempString = "smap/Dust2_0"..n.."CompleteMap.tga"
			--outputDebugString('destroying texture: '..tempString)
			destroyElement(mapTable.texture[n])
			mapTable.texture[n] = nil
		end
	end
end

----------------------------------------------------------------------------------------
-- non shadered lighting management (MTA 1.5 lights)
----------------------------------------------------------------------------------------
function load_lights()
	for n,lit in ipairs(lightData) do
		if lit.lType =="point" then
			mapTable.light[n] = createLight(0, lit.pos[1], lit.pos[2], lit.pos[3], lit.radius, lit.color[1], lit.color[2], lit.color[3])
		end
		if lit.lType =="spot" then
			mapTable.light[n] = createLight(1, lit.pos[1], lit.pos[2], lit.pos[3], lit.radius, lit.color[1], lit.color[2], lit.color[3], lit.pos[1] + lit.dir[1], lit.pos[2] + lit.dir[2], lit.pos[3] + lit.dir[3])
		end
		if lit.lType =="dark" then
			mapTable.light[n] = createLight(2, lit.pos[1], lit.pos[2], lit.pos[3], lit.radius)
		end
	end
end

function unload_lights()
	for n,lit in ipairs(lightData) do
		if isElement(mapTable.light[n]) then
			destroyElement(mapTable.light[n])
			mapTable.light[n] = nil
		end
	end
end

----------------------------------------------------------------------------------------
-- start/stop
----------------------------------------------------------------------------------------
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()), function()
	--load_models()
	load_map()
	--load_shaders()
	load_lights()
end
)

addEventHandler("onClientResourceStop",getResourceRootElement(getThisResource()), function() 
	unload_models() 
	unload_map()
	unload_shaders()
	unload_lights()
end
)

