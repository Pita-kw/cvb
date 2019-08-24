--[[
	MultiServer 
	Zasób: ms-database/database_s.lua
	Opis: Obsługa połączenia i zapytań do bazy danych.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local MYSQL_LOGIN = "login"
local MYSQL_PASSWORD = "haslo"
local MYSQL_NAME = "nazwabazy"
local MYSQL_HOST = "localhost"
local MYSQL_SOCKET = "/var/run/mysqld/mysqld.sock"
local MYSQL_PORT = "3306"
local CHARSET = "utf8"
local connection = false
local connected = false 

function connectToDatabase()
	connection = dbConnect("mysql", "dbname="..MYSQL_NAME..";host="..MYSQL_HOST..";port="..MYSQL_PORT..";charset="..CHARSET..";unix_socket="..MYSQL_SOCKET, MYSQL_LOGIN, MYSQL_PASSWORD)
	if connection then 
		outputDebugString("Połączono z bazą danych MySQL pomyślnie.", 3)
		connected = true
	else 
		outputDebugString("Nie można połączyć się z bazą danych MySQL! Następna próba za 10 sekund.", 1)
		setTimer(connectToDatabase, 10000, 1)
	end 
end 
addEventHandler("onResourceStart", resourceRoot, connectToDatabase)

-- zwraca to samo co dbPoll 
function getRows(...)
	if connected then 
		local query = dbQuery(connection, ...)
		local result = dbPoll(query, -1)
		if not result then 
			outputDebugString("Błąd w zapytaniu: "..select(1, ...), 1)
			return false
		end 
		return result, rows, last_insert_id
	else 
		return false 
	end
end 

function getSingleRow(...)
	if connected then
		local query = dbQuery(connection, ...)
		if not query then return nil end
		local rows=dbPoll(query, -1)
		if not rows then 
			outputDebugString("Błąd w zapytaniu: "..select(1, ...), 1)
			return false
		end 
		return rows[1]
	end
end

-- zwraca id ostatniego wpisu w bazie
function query(...)
	if connected then 
		local query = dbQuery(connection, ...)
		local result, rows, last_insert_id = dbPoll(query, -1)
		if not result then 
			outputDebugString("Błąd w zapytaniu: "..select(1, ...), 1)
			return false
		end 
		
		return last_insert_id
	else 
		return false
	end
end