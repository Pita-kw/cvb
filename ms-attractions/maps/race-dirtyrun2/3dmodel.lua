local dirtyRunObjects = {} 

function loadResources()
        local txd = engineLoadTXD('maps/race-dirtyrun2/Files/3dmodel.txd',true)
        engineImportTXD(txd, 16209)
        engineImportTXD(txd1, 16208)
        engineImportTXD(txd2, 16207)
 
        local dff = engineLoadDFF('maps/race-dirtyrun2/Files/3dmodel.dff', 0)
        engineReplaceModel(dff, 16209)
 
        local col = engineLoadCOL('maps/race-dirtyrun2/Files/3dmodel.col')
        engineReplaceCOL(col, 16209)
        engineSetModelLODDistance(16209, 0)

        local dff = engineLoadDFF('maps/race-dirtyrun2/Files/3dmodel1.dff', 0)
        engineReplaceModel(dff, 16208)
 
        local col = engineLoadCOL('maps/race-dirtyrun2/Files/3dmodel1.col')
        engineReplaceCOL(col, 16208)
        engineSetModelLODDistance(16208, 0)
        
        local dff = engineLoadDFF('maps/race-dirtyrun2/Files/3dmodel2.dff', 0)
        engineReplaceModel(dff, 16207)
 
        local col = engineLoadCOL('maps/race-dirtyrun2/Files/3dmodel2.col')
        engineReplaceCOL(col, 16207)
        engineSetModelLODDistance(16207, 0)

		txd = engineLoadTXD ( "maps/race-dirtyrun2/Files/cmodel.txd" )	engineImportTXD ( txd, 496 )

		dff = engineLoadDFF ( "maps/race-dirtyrun2/Files/cmodel.dff", 0 )   engineReplaceModel ( dff, 496 )
		
		local objects = getElementsByType ( "object", resourceRoot ) 
		for theKey,object in ipairs(objects) do 
			local id = getElementModel(object)
			local x,y,z = getElementPosition(object)
			local rx,ry,rz = getElementRotation(object)
			local scale = getObjectScale(object)
			objLowLOD = createObject ( id, x,y,z,rx,ry,rz,true )
			setElementDimension(objLowLOD, 69)
			setObjectScale(objLowLOD, scale)
			setLowLODElement ( object, objLowLOD )
			engineSetModelLODDistance ( id, 3000 )
			setElementStreamable(object, false)
			table.insert(dirtyRunObjects, object)
		end
end

function unloadResources()
	for k,v in ipairs(dirtyRunObjects) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end
	
	engineRestoreModel(16209)
	engineRestoreModel(16208)
	engineRestoreModel(16207)
	engineRestoreModel(496)
end
