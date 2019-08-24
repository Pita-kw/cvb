local shader = dxCreateShader( "fx/texture.fx" )

addEventHandler( "onClientResourceStart", resourceRoot, function()
	engineApplyShaderToWorldTexture( shader, "vehiclegrunge*" )
end)