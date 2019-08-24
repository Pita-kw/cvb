-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Interaction_System = {};
Interaction_System.__index = Interaction_System;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Interaction_System:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Interaction_System:Render()
	local x, y, z = getElementPosition(localPlayer)
	local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
	
	if(int ~= getElementInterior(self.col)) then
		setElementInterior(self.col, int)
	end
	if(dim ~= getElementDimension(self.col)) then
		setElementDimension(self.col, dim)
	end
	
	setElementPosition(self.col, x, y, z);
end

-- ///////////////////////////////
-- ///// HitCol		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Interaction_System:HitCol(hitElement)
	if(isPedInVehicle(localPlayer) == false) then
		local lastdis = math.huge;
		for index, ele in pairs(getElementsWithinColShape(self.col)) do
			if(self.allowedInteraction[getElementType(ele)] == true) and (getElementData(ele, "SLOTMACHINE:LEVER")) then
				local x, y, z = getElementPosition(localPlayer)
				local x2, y2, z2 = getElementPosition(ele)
				if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < lastdis) then
					lastdis = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
					hitElement = ele
				end
			end
		end
	
		if(isElement(hitElement)) then
			self.interactElement = hitElement;
		end
	end
end

-- ///////////////////////////////
-- ///// LeaveCol	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Interaction_System:LeaveCol(hitElement)
	self.interactElement = nil;
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Interaction_System:Toggle()
	if(isElement(self.interactElement)) then
		if(getElementData(self.interactElement, "SLOTMACHINE:LEVER") == true) then
			triggerServerEvent("onSlotmachineStartPlayer", self.interactElement, localPlayer)
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Interaction_System:Constructor(...)
	self.renderFunc = function() self:Render() end;
	self.colHitFunc = function(...) self:HitCol(...) end;
	self.colLeaveFunc = function(...) self:LeaveCol(...) end;
	self.toggleFunc = function(...) self:Toggle() end;
	
	self.allowedInteraction = {
		["object"] = true,
		["vehicle"] = true,
	}
	
	self.interactElement = nil;
	
	-- Instanzen 
	self.col = createColSphere(0, 0, 0, 2);

	addEventHandler("onClientRender", getRootElement(), self.renderFunc)
	addEventHandler("onClientColShapeHit", self.col, self.colHitFunc)
	addEventHandler("onClientColShapeLeave", self.col, self.colLeaveFunc)
	
	bindKey("h", "down", self.toggleFunc)
	
	outputDebugString("[CALLING] Interaction_System: Constructor");
end

-- EVENT HANDLER --


local interaction_system = Interaction_System:New()
