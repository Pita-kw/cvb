local p = Vector3(-2934.09,472.43,4.91)
local loaded = false 

function loadModels()
	if loaded then return end 
	loaded = true 
	
	txd = engineLoadTXD ( "akina.txd" )
	engineImportTXD ( txd, 2617 )
	engineImportTXD ( txd, 2572 )
	engineImportTXD ( txd, 2571 )
	engineImportTXD ( txd, 2357 )
	engineImportTXD ( txd, 2290 )
	col = engineLoadCOL ( "akina1.col" )
	col1 = engineLoadCOL ( "akina2.col" )
	col2 = engineLoadCOL ( "akina3.col" )
	col3 = engineLoadCOL ( "akina4.col" )
	col4 = engineLoadCOL ( "akina5.col" )
	dff = engineLoadDFF ( "akina1.dff", 0 )
	dff1 = engineLoadDFF ( "akina2.dff", 0 )
	dff2 = engineLoadDFF ( "akina3.dff", 0 )
	dff3 = engineLoadDFF ( "akina4.dff", 0 )
	dff4 = engineLoadDFF ( "akina5.dff", 0 )
	engineReplaceCOL ( col, 2617 )
	engineReplaceCOL ( col1, 2572 )
	engineReplaceCOL ( col2, 2571 )
	engineReplaceCOL ( col3, 2357 )
	engineReplaceCOL ( col4, 2290 )
	engineReplaceModel ( dff, 2617 )
	engineReplaceModel ( dff1, 2572 )
	engineReplaceModel ( dff2, 2571 )
	engineReplaceModel ( dff3, 2357 )
	engineReplaceModel ( dff4, 2290 )
	engineSetModelLODDistance(2617, 2000)
	engineSetModelLODDistance(2572, 2000)
	engineSetModelLODDistance(2571, 2000)
	engineSetModelLODDistance(2357, 2000)
	engineSetModelLODDistance(2290, 2000)
end

function unloadModels()
	if not loaded then return end 
	loaded = false 
	
	engineRestoreCOL(2617)
	engineRestoreCOL(2572)
	engineRestoreCOL(2571)
	engineRestoreCOL(2357)
	engineRestoreCOL(2290)
	engineRestoreModel(2617)
	engineRestoreModel(2572)
	engineRestoreModel(2571)
	engineRestoreModel(2357)
	engineRestoreModel(2290)
	destroyElement(dff)
	destroyElement(dff1)
	destroyElement(dff2)
	destroyElement(dff3)
	destroyElement(dff4)
	destroyElement(col)
	destroyElement(col1)
	destroyElement(col2)
	destroyElement(col3)
	destroyElement(col4)
	destroyElement(txd)
end

function checkPos()
	local x, y, z =getElementPosition(localPlayer)
	if getDistanceBetweenPoints2D(x, y, p.x, p.y) > 1000 then 
		unloadModels()
	else 
		loadModels()
	end
end 
setTimer(checkPos, 1000, 0)