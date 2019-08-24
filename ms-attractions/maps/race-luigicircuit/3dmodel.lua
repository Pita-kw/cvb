local marioObjects = {} 
function loadResources()
    local txd = engineLoadTXD('maps/race-luigicircuit/Files/luigi1.txd',true)
    engineImportTXD(txd, 16207)
 
    local dff = engineLoadDFF('maps/race-luigicircuit/Files/luigi1.dff', 0)
    engineReplaceModel(dff, 16208)
 
	local col = engineLoadCOL('maps/race-luigicircuit/Files/luigi1.col')
	engineReplaceCOL(col, 16208)
	engineSetModelLODDistance(16208, 0)
        
    local dff = engineLoadDFF('maps/race-luigicircuit/Files/luigi2.dff', 0)
    engineReplaceModel(dff, 16207)
 
	local col = engineLoadCOL('maps/race-luigicircuit/Files/luigi2.col')
	engineReplaceCOL(col, 16207)
	engineSetModelLODDistance(16207, 0)

	txd = engineLoadTXD ( "maps/race-luigicircuit/Files/kart.txd" )	engineImportTXD ( txd, 571 )

	dff = engineLoadDFF ( "maps/race-luigicircuit/Files/kart.dff", 0 )   engineReplaceModel ( dff, 571 )
	
	local objects = getElementsByType ( "object", resourceRoot ) 
	for theKey,object in ipairs(objects) do 
		local id = getElementModel(object)
		local x,y,z = getElementPosition(object)
		local rx,ry,rz = getElementRotation(object)
		local scale = getObjectScale(object)
		objLowLOD = createObject ( id, x,y,z,rx,ry,rz,true )
		setObjectScale(objLowLOD, scale)
		setLowLODElement ( object, objLowLOD )
		engineSetModelLODDistance ( id, 3000 )
		setElementStreamable ( object , false)
		table.insert(marioObjects, object)
	end

end 

function unloadResources()
	engineRestoreModel(16208)
	engineRestoreCOL(16208)
	engineRestoreModel(16207)
	engineRestoreCOL(16207)
	engineRestoreModel(571)
end