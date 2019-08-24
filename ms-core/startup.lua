--[[
	MultiServer 
	Zasób: ms-core/startup.lua
	Opis: Włącza wszystkie serwerowe zasoby.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local project = "MultiServer"
local version = "1.1"

local resourceList = {
	-- dodatkowe zasoby
	"dynamic_lighting",
	"bone_attach",
	"shader_carpaint",
	"shader_detail",
	"shader_dof",
	"shader_dynamic_sky",
	"shader_flashlight",
	"shader_palette",
	"shader_roadshine",
	"shader_water",
	"shader_bloom",
	"shader_snow",
	
	-- obiekty
	"ms-akina_map",
	
	-- tryb gry
	"ms-database",
	"ms-auth",
	"ms-stats",
	"ms-gui",
	"ms-blur",
	"ms-gui",
	"ms-hud",
	"ms-login",
	"ms-download",
	"ms-achievements",
	"ms-vehicles",
	"ms-vehicle_uzywane",
	"ms-dashboard",
	"ms-admin",
	"ms-arens",
	"ms-attractions",
	"ms-avatars",
	"ms-blur",
	"ms-boombox",
	"ms-brak_cieni",
	"ms-challenge",
	"ms-chat",
	"ms-dev",
	"ms-discoball",
	"ms-dust_map",
	"ms-entrances",
	"ms-felgi",
	"ms-gameplay",
	"ms-gangs",
	"ms-help",
	"ms-houses",
	"ms-hydraulik",
	"ms-kanaly",
	"ms-killmessages",
	"ms-klift",
	"ms-map",
	"ms-mine",
	"ms-minecraft",
	"ms-music",
	"ms-nametags",
	"ms-notifications",
	"ms-object_editor",
	"ms-piano",
	"ms-pizzajob",
	"ms-radar",
	"ms-radio",
	"ms-scoreboard",
	"ms-teleports",
	"ms-tuneshop",
	"ms-vehicle_shop",
	"ms-vehicles_spawn",
	"ms-wejscie-kanaly",
	"ms-zombie",
	"ms-zombie_map",
	"ms-zones",
	"ms-3dtext",
	"ms-skin_replaces",
	"ms-drift",
	"ms-top",
	"ms-hitman",
	"ms-air_spedition",
	"ms-casino",
	"ms-truck",
	"ms-statues",
	"ms-firstperson",
	"ms-zlomowisko",
	"ms-weapons_shop"
}

local unloadedResources = 0 
function init()
	outputServerLog("")
	outputServerLog("*********************")
	outputServerLog(project)
	outputServerLog("Wersja "..tostring(version))
	outputServerLog("Autorzy: Brzysiek <brzysiekdev@gmail.com> & Virelox <virelox@gmail.com>")
	outputServerLog("*********************")
	outputServerLog("")
	
	for k,v in ipairs(getElementsByType("player")) do 
		setElementData(v, "player:spawned", false)
	end 
	
	outputServerLog("-- Wczytywanie zasobow serwera")
	for k,v in ipairs(resourceList) do
		local curResource = getResourceFromName(v) 
		local check
		if curResource then 
			if getResourceState(curResource) == "running" then
				check = restartResource(curResource)
			else
				check = startResource(curResource)
			end
		else
			check = false
		end
		
		if check == false then
			if curResource == false then
				outputServerLog("*- Zasob "..v.." nie zostal wczytany, bo taki zasob nie istnieje.")
				unloadedResources = unloadedResources+1
			else
				outputServerLog("*- Zasob "..v.." nie zostal wczytany. ("..getResourceLoadFailureReason(curResource)..")")
			end
		end
	end 
	
	if unloadedResources > 0 then 
		outputServerLog("*- Zasoby zostaly zaladowane ("..tostring(unloadedResources).." niepomyslnie)")
	else
		outputServerLog("-- Zasoby zostaly zaladowane pomyslnie")
	end
	
	setFPSLimit(60)
	setGameType("Freeroam")
	setMapName("San Andreas")
	setElementData(root, "project", project)
	setElementData(root, "version", version)
	
	outputServerLog("-- Tryb gry "..project.." zostal uruchomiony.")
	return true
end
addEventHandler("onResourceStart", resourceRoot, init)

function stop()
	outputServerLog("-- Wylaczanie trybu "..tostring(project))
	
	for k,v in ipairs(resourceList) do 
		local curResource = getResourceFromName(v) 
		if curResource then 
			if getResourceState(curResource) == "running" then
				stopResource(curResource)
			end
		end
	end
	
	outputServerLog("-- Wylaczono pomyslnie.")
end
addEventHandler("onResourceStop", resourceRoot, stop)
