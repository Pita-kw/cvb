function loadResources()
        local txd = engineLoadTXD('maps/race-f1/Files/3dmodel.txd',true)
        engineImportTXD(txd, 16209)
        engineImportTXD(txd1, 16208)
 
        local dff = engineLoadDFF('maps/race-f1/Files/3dmodel.dff', 0)
        engineReplaceModel(dff, 16209)
 
        local col = engineLoadCOL('maps/race-f1/Files/3dmodel.col')
        engineReplaceCOL(col, 16209)
        engineSetModelLODDistance(16209, 0)

        local dff = engineLoadDFF('maps/race-f1/Files/3dmodel1.dff', 0)
        engineReplaceModel(dff, 16208)
 
        local col = engineLoadCOL('maps/race-f1/Files/3dmodel1.col')
        engineReplaceCOL(col, 16208)
        engineSetModelLODDistance(16208, 0)

		txd = engineLoadTXD ( "maps/race-f1/Files/cmodel.txd" )	engineImportTXD ( txd, 496 )

		dff = engineLoadDFF ( "maps/race-f1/Files/cmodel.dff", 0 )   engineReplaceModel ( dff, 496 )
end

function unloadResources() 
	engineRestoreModel(16209)
	engineRestoreModel(16208)
	
	engineRestoreModel(496)
end