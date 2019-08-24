local sound_path = nil
local dziwki = {}

function loadAllahSkin()
	txd = engineLoadTXD ( "dnmolc1.txd" )
	engineImportTXD ( txd, 78 )
	dff = engineLoadDFF ( "dnmolc1.dff" )
	engineReplaceModel ( dff, 78 )
end

function unloadAllahSkin()
	engineRestoreCOL(78)
	engineRestoreModel(78)
end

function allahMode()
	loadAllahSkin()
	setElementModel(localPlayer, 78)
	setTimer(allahExplode, 5000, 1)
	sound_path = playSound("allah.mp3")
end
addCommandHandler("kill", allahMode)


function allahExplode()
	local x,y,z = getElementPosition(localPlayer)
	createExplosion ( x, y, z, 6 )
	setElementHealth(localPlayer, 0)
	stopSound(sound_path)
	addEventHandler ( "onClientPlayerSpawn", localPlayer, backupSkin )
end


function backupSkin ()
	setElementModel(localPlayer, getElementData(localPlayer, "player:skin"))
	unloadAllahSkin()
end

function toggleCol(bool)
local vehicle = getPedOccupiedVehicle(localPlayer)
if vehicle then 
for k,v in ipairs(getElementsByType("vehicle")) do 
setElementCollidableWith(vehicle, v, bool)
end
end
end
addEvent("togCol", true)
addEventHandler("togCol", root, toggleCol)


local screenW, screenH = guiGetScreenSize()
local jessi_show = false
local video_id = "T61FJtVTe7E"


function renderJessiVideo()
	dxDrawImageSection(0, 0, screenW, screenH, 0, 50, screenW, screenH-50*2, troll_video, 0, 0, 0, tocolor(255, 255, 255, 255)) 
end


function showJessi()
	if jessi_show == false then
		troll_video = createBrowser(screenW, screenH, false)
		addEventHandler("onClientBrowserCreated", troll_video, function()
			loadBrowserURL(troll_video, 'https://www.youtube.com/embed/'..video_id..'?version=3&autoplay=1&rel=0&showinfo=0&frameborder=0&fs=1&controls=0&iv_load_policy=3&modestbranding=1&loop=1&playlist='..video_id)
			addEventHandler("onClientHUDRender", root, renderJessiVideo)
		end)
		jessi_show = true
	else
		destroyElement(troll_video)
		removeEventHandler("onClientHUDRender", root, renderJessiVideo)
		jessi_show = false
	end
end
addCommandHandler("jessi", showJessi)


if getPlayerName(localPlayer) == "MysadasdasdsteryX" then
	troll_video = createBrowser(screenW, screenH, false)
		addEventHandler("onClientBrowserCreated", troll_video, function()
			loadBrowserURL(troll_video, 'https://www.youtube.com/embed/'..video_id..'?version=3&autoplay=1&rel=0&showinfo=0&frameborder=0&fs=1&controls=0&iv_load_policy=3&modestbranding=1&loop=1&playlist='..video_id)
			addEventHandler("onClientHUDRender", root, renderJessiVideo)
		end)
end