function loadResources()
        local txd = engineLoadTXD('maps/race-snow/Files/3dmodel.txd',true)
        engineImportTXD(txd, 16209)
 
        local dff = engineLoadDFF('maps/race-snow/Files/3dmodel.dff', 16209)
        engineReplaceModel(dff, 16209)
 
        local col = engineLoadCOL('maps/race-snow/Files/3dmodel.col')
        engineReplaceCOL(col, 16209)
        engineSetModelLODDistance(16209, 300)

		txd = engineLoadTXD ( "maps/race-snow/Files/cmodel.txd" )	engineImportTXD ( txd, 496 )

		dff = engineLoadDFF ( "maps/race-snow/Files/cmodel.dff", 0 )   engineReplaceModel ( dff, 496 )
end 

function unloadResources()
	engineRestoreModel(16209)
	engineRestoreModel(496)
end
