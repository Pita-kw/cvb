local models = {
	[300] = {"models/handlarka.txd", "models/handlarka.dff"},
	[301] = {"models/mysliwy.txd", "models/mysliwy.dff"},
	[302] = {"models/straznik.txd", "models/straznik.dff"},
	[303] = {"models/zona.txd", "models/zona.dff"},
	[304] = {"models/triss.txd", "models/triss.dff"},
	[305] = {"models/kon.txd", "models/kon.dff"},
	[484] = {"models/lodz.txd", "models/lodz.dff"},
}

function replaceModels()
	for id, data in pairs(models) do
		engineImportTXD(engineLoadTXD(data[1]), id)
		engineReplaceModel(engineLoadDFF(data[2]), id)
	end
end 
addEventHandler("onClientResourceStart", resourceRoot, replaceModels)