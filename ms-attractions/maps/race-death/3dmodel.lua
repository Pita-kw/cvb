local deathObjects = {} 

function loadResources()
	txd = engineLoadTXD ( "maps/race-death/Files/road.txd" )
	engineImportTXD ( txd, 16209 )
	dff = engineLoadDFF ( "maps/race-death/Files/road.dff", 16209 )
	engineReplaceModel ( dff, 16209 )
	col = engineLoadCOL ( "maps/race-death/Files/road.col" )
	engineReplaceCOL ( col, 16209 )

	
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
			table.insert(deathObjects, object)
		end
end 

function unloadResources()
	for k,v in ipairs(deathObjects) do 
		destroyElement(v)
	end
	
	engineRestoreModel(16209)
end
