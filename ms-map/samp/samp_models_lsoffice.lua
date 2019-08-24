rootElement = getRootElement()
function loadobj(resource)
    if resource ~= getThisResource() then return end
	txd997 = engineLoadTXD('LSOffice1Floors.txd')
	engineImportTXD(txd997, 3781)
	col997 = engineLoadCOL('LSOffice1Floors.col')
	dff997 = engineLoadDFF('LSOffice1Floors.dff', 0)
	engineReplaceCOL(col997, 3781)
	engineReplaceModel(dff997, 3781)
	engineReplaceCOL(col997, 3781)
	txd998 = engineLoadTXD('LSOffice1.txd')
	engineImportTXD(txd998, 4587)
	col998 = engineLoadCOL('LSOffice1.col')
	dff998 = engineLoadDFF('LSOffice1.dff', 0)
	engineReplaceCOL(col998, 4587)
	engineReplaceModel(dff998, 4587)
	engineReplaceCOL(col998, 4587)
	txd999 = engineLoadTXD('LSOffice1.txd')
	engineImportTXD(txd999, 4605)
	col999 = engineLoadCOL('LSOffice1Glass.col')
	dff999 = engineLoadDFF('LSOffice1Glass.dff', 0)
	engineReplaceCOL(col999, 4605)
	engineReplaceModel(dff999, 4605)
	engineReplaceCOL(col999, 4605)
end
addEventHandler('onClientResourceStart', rootElement, loadobj)