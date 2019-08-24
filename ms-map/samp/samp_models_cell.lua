rootElement = getRootElement()
function loadobj(resource)
    if resource ~= getThisResource() then return end
	
	txd001 = engineLoadTXD('pd_jail_door01.txd')
	engineImportTXD(txd001, 8081)
	col001 = engineLoadCOL('pd_jail_door01.col')
	dff001 = engineLoadDFF('pd_jail_door01.dff', 0)
	engineReplaceCOL(col001, 8081)
	engineReplaceModel(dff001, 8081)
	engineReplaceCOL(col001, 8081)
	
	txd002 = engineLoadTXD('pd_jail_door02.txd')
	engineImportTXD(txd002, 8082)
	col002 = engineLoadCOL('pd_jail_door02.col')
	dff002 = engineLoadDFF('pd_jail_door02.dff', 0)
	engineReplaceCOL(col002, 8082)
	engineReplaceModel(dff002, 8082)
	engineReplaceCOL(col002, 8082)
	
	txd003 = engineLoadTXD('pd_jail_door_top01.txd')
	engineImportTXD(txd003, 8083)
	col003 = engineLoadCOL('pd_jail_door_top01.col')
	dff003 = engineLoadDFF('pd_jail_door_top01.dff', 0)
	engineReplaceCOL(col003, 8083)
	engineReplaceModel(dff003, 8083)
	engineReplaceCOL(col003, 8083)
	
	txd004 = engineLoadTXD('speed_bumps.txd')
	engineImportTXD(txd004, 8084)
	col004 = engineLoadCOL('vehicle_barrier01.col')
	dff004 = engineLoadDFF('vehicle_barrier01.dff', 0)
	engineReplaceCOL(col004, 8084)
	engineReplaceModel(dff004, 8084)
	engineReplaceCOL(col004, 8084)
	
end
addEventHandler('onClientResourceStart', rootElement, loadobj)