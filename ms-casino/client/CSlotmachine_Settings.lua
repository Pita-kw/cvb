-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Slotmachine_Settings = {};
Slotmachine_Settings.__index = Slotmachine_Settings;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Slotmachine_Settings:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PlaySlotSound		//////
-- ///// Returns: sound		//////
-- ///////////////////////////////

function Slotmachine_Settings:PlaySlotSound(x, y, z, dateifpad, int, dim)
	local s = playSound3D("files/sounds/"..dateifpad..".mp3", x, y, z)
	setSoundMaxDistance(s, 40)
	
	if(int) then
		setElementInterior(s, int)
	end
	if(dim) then
		setElementDimension(s, dim)
	end
	return s;
end

-- ///////////////////////////////
-- ///// WinText	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine_Settings:WinText(text)
	self.text = text;

	self.enabled = true;
	if(isTimer(self.waitTimer)) then
		killTimer(self.waitTimer);
	end
	
	self.waitTimer = setTimer(function() self.enabled = false end, 5000, 1)
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine_Settings:Render()
	if(self.enabled == true) then
		local sx, sy = guiGetScreenSize()
		local aesx, aesy = 1600, 900
		dxDrawText(self.text, 370/aesx*sx, 73/aesy*sy, 1226/aesx*sx, 257/aesy*sy, tocolor(255, 255, 255, 255), 3, "default-bold", "center", "center", false, false, true, true, false)
	end
end

-- ///////////////////////////////
-- ///// JackPot	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine_Settings:JackPot(x, y, z, times)
	setTimer(function(x, y, z, times)
		for i = 1, 5, 1 do
			fxAddSparks(x, y, z, 0, 0, 2, 5, times, 0, 0, 0, false, 0.5, 5)
		end
	end, 300, x, y, z, times)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine_Settings:Constructor(...)
	addEvent("onSlotmachineSoundPlay", true)
	addEvent("onSlotmachineWintext", true)
	addEvent("onSlotmachineJackpot", true)
	
	self.slotmachine_sound = function(...) self:PlaySlotSound(...) end;
	self.wintext_func = function(...) self:WinText(...) end;
	self.renderTextFunc = function() self:Render() end
	self.jackpot_func = function(...) self:JackPot(...) end;
	
	self.text = "";
	self.enabled = false;
	
	addEventHandler("onSlotmachineSoundPlay", getLocalPlayer(), self.slotmachine_sound)
	addEventHandler("onSlotmachineWintext", getLocalPlayer(), self.wintext_func)
	addEventHandler("onSlotmachineJackpot", getLocalPlayer(), self.jackpot_func)
	
	addEventHandler("onClientRender", getRootElement(), self.renderTextFunc);
	

	outputDebugString("[CALLING] Slotmachine_Settings: Constructor");
end

-- EVENT HANDLER --

Slotmachine_Settings:New()


addCommandHandler("getslotpos", function()
	local x, y, z = getElementPosition(localPlayer)
	z = z+getElementDistanceFromCentreOfMassToBaseOfModel(localPlayer)-0.6
	outputChatBox(x..", "..y..", "..z)
end)
