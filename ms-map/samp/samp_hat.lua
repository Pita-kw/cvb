rootElement = getRootElement()
function loadobj(resource)
    if resource ~= getThisResource() then return end
		
	txd107 = engineLoadTXD('firehats.txd')
	engineImportTXD(txd107, 3908)
	col107 = engineLoadCOL('fire_hat01.col')
	dff107 = engineLoadDFF('fire_hat01.dff', 0)
	engineReplaceCOL(col107, 3908)
	engineReplaceModel(dff107, 3908)
	engineReplaceCOL(col107, 3908) 
	
	txd108 = engineLoadTXD('firehats.txd')
	engineImportTXD(txd108, 3907)
	col108 = engineLoadCOL('fire_hat02.col')
	dff108 = engineLoadDFF('fire_hat02.dff', 0)
	engineReplaceCOL(col108, 3907)
	engineReplaceModel(dff108, 3907)
	engineReplaceCOL(col108, 3907) 

	
	
end
addEventHandler('onClientResourceStart', rootElement, loadobj)