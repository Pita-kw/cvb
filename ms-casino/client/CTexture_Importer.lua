-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Texture_Importer = {};
Texture_Importer.__index = Texture_Importer;

addEvent("onSlotmachinesGet", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Texture_Importer:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ImportSlotmachine	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function import(slotMachines)
	local shader = dxCreateShader("files/shaders/texture.fx");
	dxSetShaderValue(shader, "Tex", dxCreateTexture("files/textures/slot5_ind_2.jpg"));
	engineApplyShaderToWorldTexture(shader, "slot5_ind");

	--[[for index, slotmachine in pairs(slotMachines) do
		local shader = dxCreateShader("files/shaders/texture.fx");
		dxSetShaderValue(shader, "Tex", dxCreateTexture("files/textures/slot5_ind_"..math.random(1, self.textures)..".jpg"));
		
		engineApplyShaderToWorldTexture(shader, "slot5_ind", slotmachine);
	end]]
end
addEventHandler("onClientResourceStart", resourceRoot, import)

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Texture_Importer:Constructor(...)
	--self.importFunc = function(...) self:ImportSlotmachine(...) end;

	self.textures = 3;				-- Define the max custom textures of the slot machine (file in the meta.xml)

	--addEventHandler("onClientResourceStart", resourceRoot, function() self:ImportSlotmachine() end)
	
	outputDebugString("[CALLING] Texture_Importer: Constructor");
end

-- EVENT HANDLER --


