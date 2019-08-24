--------------------------------
-- Switch effect on or off
--------------------------------
function switchBloom( blOn )
	outputDebugString( "switchBloom: " .. tostring(blOn) )
	if blOn then
		enableBloom()
	else
		disableBloom()
	end
end

addEvent( "switchBloom", true )
addEventHandler( "switchBloom", resourceRoot, switchBloom )
