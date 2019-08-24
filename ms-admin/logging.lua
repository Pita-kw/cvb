--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: logging.lua
	@desc: logowanie wszelkich działań
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]



local mysql=exports['ms-database']


function logAdd(itype, uid, text)
	if not itype then
		gameView_add('Błąd systemu logowania. Nie otrzymano typu logu.')
		return
	end
	
	if not uid then
		gameView_add('Błąd systemu logowania. Nie otrzymano UID gracza.' ..itype)
		return
	end
	
	if not text then
		gameView_add('Błąd systemu logowania. Nie otrzymano tekstu logu.' ..itype)
		return
	end
	
	mysql:query('INSERT INTO ms_logging (uid, type, txt) VALUES (?, ?, ?)', uid, itype, text)
	return true
end
outputServerLog('[ms-admin] Logowanie Rozpoczete')
gameView_add('Logowanie rozpoczete')