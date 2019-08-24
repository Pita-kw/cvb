function loadResources()
	local txd = engineLoadTXD ( "maps/derby-minecrash/Files/road.txd" )
	engineImportTXD ( txd, 16209 )
	local dff = engineLoadDFF ( "maps/derby-minecrash/Files/road.dff", 16209 )
	engineReplaceModel ( dff, 16209 )
	local col = engineLoadCOL ( "maps/derby-minecrash/Files/road.col" )
	engineReplaceCOL ( col, 16209 )
end 

function unloadResources()
	engineRestoreModel(16209)
end

