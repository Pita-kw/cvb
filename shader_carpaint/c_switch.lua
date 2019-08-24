--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchCarPaintReflectLite", root, true )
--
--	To switch off:
--			triggerEvent( "switchCarPaintReflectLite", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- Switch effect on or off
--------------------------------
function switchCarPaintReflectLite( cprlOn )
	outputDebugString( "switchCarPaintReflectLite: " .. tostring(cprlOn) )
	if cprlOn then
		startCarPaintReflectLite()
	else
		stopCarPaintReflectLite()
	end
end

addEvent( "switchCarPaintReflectLite", true )
addEventHandler( "switchCarPaintReflectLite", resourceRoot, switchCarPaintReflectLite )
