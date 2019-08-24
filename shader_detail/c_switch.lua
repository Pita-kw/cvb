--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "onClientSwitchDetail", root, true )
--
--	To switch off:
--			triggerEvent( "onClientSwitchDetail", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

-----------------
-- Switch effect on or off
--------------------------------
function handleOnClientSwitchDetail( bOn )
	if bOn then
		enableDetail()
		if getElementData(localPlayer, "player:shader_roadshine") then 
			triggerEvent("onClientAddNotification", localPlayer, "Ten shader nie jest kompatybilny z przebłyskami dróg.", "warning")
		end
	else
		disableDetail()
	end
end

addEvent( "onClientSwitchDetail", true )
addEventHandler( "onClientSwitchDetail", resourceRoot, handleOnClientSwitchDetail )
