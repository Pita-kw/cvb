-- ###############################
-- ## Name: CSkins.lua			##
-- ## Author: Noneatme			##
-- ## Version: 1.0				##
-- ## Lizenz: Freie Benutzung	##
-- ###############################


local cFunc = {}
local cSetting = {}
local loaded = false

cSetting["skins"] = {
	105,
	107,
	108,
	111,
	126,
	127,
	128,
	13,
	152,
	162,
	167,
	188,
	192,
	195,
	206,
	209,
	212,
	22,
	229,
	230,
	258,
	264,
	274,
	277,
	280,
	287,
	56,
	67,
	68,
	69,
	70,
	84,
	92,
	97
}

-- FUNCTIONS --


cFunc["load_skins"] = function()
	for index, id in pairs(cSetting["skins"]) do
		if(fileExists("files/skins/"..id..".txd")) then
			local txd = engineLoadTXD("files/skins/"..id..".txd")
			engineImportTXD(txd, id)
		end
	end
end

cFunc["unload_skins"] = function()
	for index, id in pairs(cSetting["skins"]) do
			engineRestoreModel(id)
	end
end

-- EVENT HANDLERS --

function checkZombieSkins()
	local dimension = getElementDimension(localPlayer)
	 if dimension == 666 and loaded == false then
		cFunc["load_skins"]()
		loaded = true
	elseif dimension ~= 666 and loaded == true then
		cFunc["unload_skins"]()
	   loaded = false
	end
end
setTimer(checkZombieSkins, 1000, 0)
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), cFunc["unload_skins"])