function loadResources()
	txd = engineLoadTXD ( "maps/derby-shukaku/Files/road.txd" )
	engineImportTXD ( txd, 16209 )
	dff = engineLoadDFF ( "maps/derby-shukaku/Files/road.dff", 16209 )
	engineReplaceModel ( dff, 16209 )
	col = engineLoadCOL ( "maps/derby-shukaku/Files/road.col" )
	engineReplaceCOL ( col, 16209 )
end

function unloadResources()
	engineRestoreModel(16209)
end

