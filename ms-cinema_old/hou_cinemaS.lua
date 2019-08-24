function startVideo(videoID)
	setElementData(root,"cin:startTime", getTickCount())
	setElementData(root,"cin:vid", videoID)
	local players = getElementsByType ( "player" ) -- get a table of all the players in the server
	for theKey,thePlayer in ipairs(players) do -- use a generic for loop to step through each player
   		triggerClientEvent ( thePlayer, "onCinema", thePlayer, getElementData(root,"cin:vid"),getTickCount() - getElementData(root,"cin:startTime"))
	end
end
addEvent( "onStartVideo", true )
addEventHandler( "onStartVideo", resourceRoot, startVideo )

function startVideoJoin()
    triggerClientEvent ( source, "onCinema", source, getElementData(root,"cin:vid"),getTickCount() - getElementData(root,"cin:startTime"))
end
addEventHandler ( "onPlayerJoin", getRootElement(), startVideoJoin)



function checkAccess(thePlayer)
 	if getElementData(thePlayer, "player:rank") < 1 then
		triggerClientEvent(thePlayer, "onClientAddNotification", player, "Brak uprawnień", "error")
		return
	end
  	triggerClientEvent ( thePlayer, "onOpenBrowser", thePlayer)
end
addEvent( "checkACL", true )
addEventHandler( "checkACL", resourceRoot, checkAccess )