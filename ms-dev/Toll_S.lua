function VehicleTempSearchID()
local i = 1
	for i,veh in ipairs(getElementsByType("vehicle") ) do
		if getElementData(veh,"temp") then
			i = i+1
		end
	end
	return i
end

function VehicleTempSerachFromID(id)
	for i,veh in ipairs(getElementsByType("vehicle") ) do
		if getElementData(veh,"temp:id") == tonumber(id) or getElementData(veh,"temp") == id then
			return veh
		end
	end
	return false
end


function GetTempVehicles(Gracz,CommandName,ID)
	if getElementData(Gracz,"player:devmode") == true then	
		outputChatBox("#FFFFFF Aktualnie znajduje się na mapie "..VehicleTempSearchID().." stworzonych pojazdów tymczasowych.",Gracz,255,255,255,true)
	end
end
addCommandHandler("tempvehs", GetTempVehicles)

function RemoveTempVehicle(Gracz,CommandName,ID)
if getElementData(Gracz,"player:devmode") == true then	
	if ID then
		local veh = VehicleTempSerachFromID(ID)
		if veh then
			outputChatBox("#FFFFFF Usunołeś pojazd tymczasowy "..getVehicleNameFromModel( getElementModel(veh) ).." ID "..ID,Gracz,255,255,255,true)
			destroyElement( veh )
		else
			outputChatBox("#FFFFFF Nie znaleziono pojazdu o ID "..ID,Gracz,255,255,255,true)
			end
		end
	end
end
addCommandHandler("removetempveh", RemoveTempVehicle)


function CreateTempVehicle(Gracz,CommandName, ...)
	if getElementData(Gracz,"player:devmode") == true then		
for i,veh in ipairs(getElementsByType("vehicle") ) do
	if getElementData(veh,"temp") == getPlayerName(Gracz) then
		destroyElement( veh )
	end
end
	
	for i=400,611 do
			local string = string.lower( table.concat({...}, " ") )
			local name_veh = getVehicleNameFromModel( i ):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_veh:find(string, 1, true) or string == i then
            	local x,y,z = getElementPosition( Gracz )
            	local _,_,Rz = getElementRotation(Gracz,"ZYX")
            	vehicle = createVehicle(i,x,y,z+2)
            	if vehicle then
            		warpPedIntoVehicle( Gracz, vehicle, 0 )
            		setElementRotation(vehicle,0,0,Rz)
            		 setElementData(vehicle,"temp",getPlayerName(Gracz))
            		 setElementFrozen(vehicle,true)
           				setTimer(function(x,y,z)
           				local id = VehicleTempSearchID()	
						setElementFrozen(vehicle,false)
						setElementPosition(vehicle,x,y,z+1)
						setElementData(vehicle,"temp:id",id)
						outputChatBox("#FFFFFF Stworzyłeś pojazd tymczasowy "..getVehicleNameFromModel( getElementModel(vehicle) ).." ID "..id,Gracz,255,255,255,true)
						end,1000,1,x,y,z)
				return true
				end
			end
        end
	end
end
addCommandHandler("tempveh", CreateTempVehicle)


function ChatDeveloper(Gracz,CommandName, ...)
if hasObjectPermissionTo ( Gracz, "function.Developer", true )  then 
		if getElementData(Gracz,"player:devmode") == true then	
		local message = table.concat({...}, " ")
		local name = getPlayerName(Gracz):gsub("_"," ")
		for i,v in ipairs(getElementsByType("player")) do
			if getElementData(v,"player:devmode") == true then
				outputChatBox("[Czat techników] #0059FF"..name .. ": #FFFFFF" .. message, v, 255, 0, 0,true)
				end
			end
		end
	end
end
addCommandHandler("cd", ChatDeveloper)

function setDataElement(Gracz,CommandName,Data,Value)
setElementData(Gracz,Data, tonumber(Value) )
outputChatBox("Set Data "..Data.." = "..Value)
end
addCommandHandler( "setData", setDataElement )


function CommandToggleDevelpoer(Gracz)
local accountname = getAccountName (getPlayerAccount(Gracz))
if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then 
	if getElementData(Gracz,"player:devmode") == false then
		setElementData(Gracz,"player:devmode",true)
		triggerClientEvent ( Gracz, "Developer:Mode", Gracz, true )
		outputChatBox("#FFFFFF Włączono tryb developerski.",Gracz,255,255,255,true)
		else		
		triggerClientEvent ( Gracz, "Developer:Mode", Gracz, false )	
		outputChatBox("#FFFFFF Wyłączono tryb developerski.",Gracz,255,255,255,true)
		setElementData(Gracz,"player:devmode",false)
		end
	end
end
addCommandHandler("devmode", CommandToggleDevelpoer)


function CommandTravelDeveloper(Gracz)
local accountname = getAccountName (getPlayerAccount(Gracz))
if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then 
		if getElementData(Gracz,"player:devmode") == true then
			triggerClientEvent(Gracz, "onFastTravel", Gracz)
		end
	end
end
addCommandHandler("tp", CommandTravelDeveloper)


function Getpostion(Gracz,CommandName,toggle)
local accountname = getAccountName (getPlayerAccount(Gracz))
if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then 
local theVehicle = getPedOccupiedVehicle ( Gracz )
if not(theVehicle) then
local x, y, z = getElementPosition(Gracz)
local _,_,rotation = getElementRotation(Gracz)
local dimension = getElementDimension(Gracz)
local interior = getElementInterior(Gracz)	

if not toggle or toggle == false then
x,y,z = string.format("%.2f",x),string.format("%.2f",y),string.format("%.2f",z)
rotation = string.format("%.1f",x)
end

outputConsole("Pozycja: " .. x .. ", " .. y .. ", " .. z, Gracz)
outputConsole("Rotacja: " .. rotation, Gracz)
outputConsole("Dimension: " .. dimension, Gracz)
outputConsole("Interior: " .. interior, Gracz)
outputChatBox("[Admin/getposition] Pobrano dane do konsoli ( F8 )",Gracz,255,255,255)
elseif theVehicle then
		local x, y, z = getElementPosition(theVehicle)
		local _,_,rotation = getElementRotation(theVehicle)
		local dimension = getElementDimension(theVehicle)
		local interior = getElementInterior(theVehicle)

if not toggle or toggle == false then
x,y,z = string.format("%.2f",x),string.format("%.2f",y),string.format("%.2f",z)
rotation = string.format("%.1f",x)
end

		local ID = getElementModel ( theVehicle )
		local Model = getVehicleName ( theVehicle )
		outputConsole("Pozycja: " .. x .. ", " .. y .. ", " .. z, Gracz)
		outputConsole("Rotacja: " .. rotation, Gracz)
		outputConsole("Dimension: " .. dimension, Gracz)
		outputConsole("Interior: " .. interior, Gracz)
		outputConsole("ID Modelu: " .. ID, Gracz)		
		outputConsole("Nazwa Modelu: " .. Model, Gracz)	
		outputChatBox("[Admin/getposition] Pobrano dane do konsoli ( F8 )",Gracz,255,255,255)	
		end
	end
end
addCommandHandler("getpos", Getpostion)
addCommandHandler("gp", Getpostion)

function SetPos(Gracz,cmd,x,y,z,int,dim)
accountname = getAccountName (getPlayerAccount(Gracz))
   if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then 
	local dim = dim or 0
	local int = int or 0
		if x and y and z then
			setElementPosition(Gracz,x,y,z)
		end
	end
end
addCommandHandler("setpos",SetPos)


function DevelopercheckModules(Gracz)
	local modules = getLoadedModules()
	accountname = getAccountName (getPlayerAccount(Gracz))
   if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then 
	if #modules == 0 then
		return outputChatBox("Nie zaladowana zadnych modlów!",Gracz,150,0,0)
	end
	for k,v in ipairs(modules) do
	        outputConsole( v,Gracz )
	end
	outputServerLog("Zaladowano: " .. #modules)
end
end
addCommandHandler("gm", DevelopercheckModules)
addCommandHandler("getmodules", DevelopercheckModules)

function DeveloperModulesInfo ( Gracz )
accountname = getAccountName (getPlayerAccount(Gracz))
   if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then
    local modules = getLoadedModules()
    if #modules == 0 then
        return outputChatBox ( "Nie zaladowano zadnego modułu!", Gracz,150,0,0 ) 
    end
 
    for k, v in ipairs ( modules ) do
        local moduleInfo = getModuleInfo ( v )
        outputConsole ( moduleInfo.name .. "(" .. v .. ") version " .. moduleInfo.version .. ", autor: " .. moduleInfo.author, Gracz )
    end
end
end
addCommandHandler ( "cm", DeveloperModulesInfo )
addCommandHandler ( "checkmodules", DeveloperModulesInfo )

function DeveloperBansReload(Gracz)
accountname = getAccountName (getPlayerAccount(Gracz))
   if ( reloadBans() ) and isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) )  then
      outputChatBox("Przeladowano liste banów.",Gracz,255, 194, 14)
   else
      outputChatBox("Blad przeladowywania listy banów.",player,150,0,0)
   end
end
addCommandHandler("reloadban",DeveloperBansReload)
addCommandHandler("rban",DeveloperBansReload)


function DeveloperPrintACL( Gracz )
accountname = getAccountName (getPlayerAccount(Gracz))
    local allACLs = aclList()
    if #allACLs == 0 then
        return outputConsole ( "Nie znalezino Listy ACL!", Gracz,150,0,0 )
    elseif isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) ) then
        outputConsole ( "Lista ACL:", Gracz )
        for key, singleACL in ipairs ( allACLs ) do
            local ACLName = aclGetName ( singleACL )
            outputConsole ( "- " .. tostring ( ACLName ),Gracz )
        end
	outputChatBox("Lista ACL zostala wyswietlona w konsoli (F8)",Gracz, 255, 194, 14)
   end
end
addCommandHandler ( "listacls",DeveloperPrintACL)
addCommandHandler ( "la",DeveloperPrintACL)

function DeveloperStatusNet(Gracz)
accountname = getAccountName (getPlayerAccount(Gracz))
if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) ) then
	for index, value in pairs(getNetworkStats()) do
		outputConsole(" ")	
		outputConsole(index..":")		
		outputConsole(value)
	end
end	
		outputConsole("Zakończono pobieranie pakietów sieci")
	outputChatBox("Stan sieci został wyświetlony w konsoli (F8)",Gracz, 255, 194, 14)
end
addCommandHandler("getnet", DeveloperStatusNet)