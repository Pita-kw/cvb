local screenW, screenH = guiGetScreenSize() 
local zoom = 1.0
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

addEvent("onClientInitCustomDownload", true)
addEvent("onClientFinishCustomDownload", true)
addEvent("onClientGetCustomDownloadData", true)

gFiles, gSizes = {}, {}

function onStart(self)	
	addEventHandler("onClientGetCustomDownloadData", root, function(f, s)
		gFiles = f 
		gSizes = s
	end)
	
	addEventHandler("onClientInitCustomDownload", root, function(type, finishElementData) 
		if currentDownloading and #currentDownloading > 0 then 
			triggerEvent("onClientAddNotification", localPlayer, "Pobierasz już jakąś paczkę plików.", "error")
			return 
		end 
		
		
		initDownload(type, finishElementData) 
		triggerEvent("onClientAddNotification", localPlayer, "Zaczekaj aż paczka się pobierze / załaduje.", "info")
	end)
	
	setTimer(triggerServerEvent, 3000, 1, "onPlayerRequestCustomDownloadData", localPlayer)
	
	addEventHandler("onClientFileDownloadComplete", resourceRoot, function(file, success) onDownloadFile(file, success) end)
	
	setElementData(localPlayer, "player:ghostisland_downloaded", false)
	setElementData(localPlayer, "player:china_downloaded", false)
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)

function initDownload(type, finishElementData)
	downloadedFiles = {}
	downloadQueue = {}
	downloadFilesSize = 0 
	downloadedFilesSize = 0
	currentDownloading = ""
	infoText = "Sprawdzanie plików" 
	downloadEndData = finishElementData
	
	font = dxCreateFont("archivo_narrow.ttf", 16/zoom, false, "antialiased") or "default-bold"
	addEventHandler("onClientRender", root, renderDownload)
	
	for k,v in ipairs(gFiles) do
		local pass = true
				
		if type then 
			pass = string.find(v, type)
		end 
		
		if pass then
			if fileExists(v) then 
				downloadedFiles[v] = true
			end 
			
			local size = gSizes[v]
			downloadFilesSize = downloadFilesSize+size 
			table.insert(downloadQueue, v)
		end
	end 
	
	if #downloadQueue > 0 then
		currentDownloading = downloadQueue[1]
		setTimer(startDownload, 1000, 1)
	else 
		endDownload()
	end 
end
	
function startDownload()
	local path, file, _ = string.match(currentDownloading, "(.-)([^\\/]-%.?([^%.\\/]*))$")
	if downloadedFiles[currentDownloading] then 
		infoText = "Ładowanie danych: "..file.." ("..tostring(round(downloadedFilesSize, 2)).." MB / "..tostring(round(downloadFilesSize, 2)).."MB)"
	else
		infoText = "Pobieranie danych: "..file.." ("..tostring(round(downloadedFilesSize, 2)).." MB / "..tostring(round(downloadFilesSize, 2)).."MB)"
	end
	
	downloadFile(currentDownloading)
end
	
function endDownload()
	if isElement(font) then destroyElement(font) end
	removeEventHandler("onClientRender", root, renderDownload)
	triggerEvent("onClientFinishCustomDownload", resourceRoot)
	setElementData(localPlayer, downloadEndData, true)
	
	downloadQueue = {}
	downloadFilesSize = 0 
	downloadedFilesSize = 0
	currentDownloading = ""
	infoText = "" 
	downloadEndData = false 
	
	triggerEvent("onClientAddNotification", localPlayer, "Paczka załadowana pomyślnie! Możesz się teleportować.", "success")
end
	
function onDownloadFile(file, success)
	if source == resourceRoot then 
		if success then 
			table.remove(downloadQueue, 1)
				
			downloadedFilesSize = downloadedFilesSize+gSizes[file]
			if #downloadQueue > 0 then 
				currentDownloading = downloadQueue[1]
				setTimer(startDownload, 50, 1)
			else 
				endDownload()
			end
		else 
			startDownload()
		end
	end
end

function renderDownload()
	local text = infoText
	local height = dxGetFontHeight(1, font)
	local width = dxGetTextWidth(text, 1, font)
	
	local x, y, w, h = screenW/2-width/2-height/2, screenH-50/zoom, width, height
	exports["ms-gui"]:renderLoading(x, y, h, h)
	
	x = x + h*0.8
	
	dxDrawText(text, x+1, y+1, x+w+1, y+h+1, tocolor(0, 0, 0, 255), 0.9, font, "center", "center")
	dxDrawText(text, x, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.9, font, "center", "center")
end 

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end