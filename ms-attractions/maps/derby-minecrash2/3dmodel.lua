function loadResources()
	txd = engineLoadTXD ( "maps/derby-minecrash2/Files/road.txd" )
	engineImportTXD ( txd, 16209 )
	dff = engineLoadDFF ( "maps/derby-minecrash2/Files/road.dff", 16209 )
	engineReplaceModel ( dff, 16209 )
	col = engineLoadCOL ( "maps/derby-minecrash2/Files/road.col" )
	engineReplaceCOL ( col, 16209 )
end 

function unloadResources()
	engineRestoreModel(16209)
end
