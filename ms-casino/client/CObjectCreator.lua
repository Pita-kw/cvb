-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings


cFunc["create_objects"] = function()
	local ti = Texture_Importer:New();
	
	triggerServerEvent("onClientSlotmachinesGet", getLocalPlayer())
end


-- EVENT HANDLER --
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), cFunc["create_objects"]);