function onStart()
	files = {}
	fileSizes = {}
		
	getFilesToDownload()
end
addEventHandler("onResourceStart", resourceRoot, onStart)
	
function getFilesToDownload(self)
	local xml = xmlLoadFile ("meta.xml")
	if xml == false then
		return
	end
		
	local node
	local index = 0
	local _next = function()
		node = xmlFindChild (xml, "file", index)
		index = index + 1
		return node
	end
		
	files = {} 
	fileSizes = {} 
		
	local num = 0
	while _next() do
		local path = xmlNodeGetAttribute (node, "src")
		local isClient = xmlNodeGetAttribute (node, "type")
		local download = xmlNodeGetAttribute (node, "download")
		if isClient == "client" and download == "false" then 
			local file = fileOpen(path, true)
			local size = fileGetSize(file)/1024^2
			fileClose(file)
			table.insert(files, path)
					
			fileSizes[path] = size 
				
			num = num + 1
		end 
	end
end

addEvent("onPlayerRequestCustomDownloadData", true)
addEventHandler("onPlayerRequestCustomDownloadData", root, function()
	triggerClientEvent(client, "onClientGetCustomDownloadData", client, files, fileSizes)
end)
