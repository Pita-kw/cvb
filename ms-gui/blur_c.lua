
local scx, scy = guiGetScreenSize()

Settings = {}
Settings.disabled = false
Settings.var = {}
Settings.var.blur = 1
Settings.var.optim = 3 -- dzieli rozdzielczość w efekcie mniejsza ilosc pixeli do renderowania (nieco psuje jakosc)
Settings.screenRectangle = {}

local current 

function createShader()
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end
        myScreenSource = dxCreateScreenSource( scx/Settings.var.optim, scy/Settings.var.optim )
        blurHShader,tecName = dxCreateShader( "shaders/fxBlurH.fx" )
        blurVShader,tecName = dxCreateShader( "shaders/fxBlurV.fx" )
		blackwhiteShader = dxCreateShader ( "shaders/blackwhite.fx" )
		bAllValid = myScreenSource and blurHShader and blurVShader and blackwhiteShader
		if not bAllValid then
			outputChatBox( "Could not create some things. Please use debugscript 3" )
		end
		
		addEventHandler ("onClientRender", root, preRender)
end
addEventHandler("onClientResourceStart", resourceRoot, createShader)

addCommandHandler("blur", function()
	if Settings.disabled then 
		Settings.disabled = false
		triggerEvent("onClientAddNotification", localPlayer, "Blur włączony.", "info")
	else 
		Settings.disabled = true
		triggerEvent("onClientAddNotification", localPlayer, "Blur wyłączony.", "error")
	end
end)

 function dxDrawBluredRectangle (pos_x, pos_y, size_x, size_y, color)
	if bAllValid and not Settings.disabled then
		dxDrawImageSection  ( pos_x, pos_y, size_x, size_y, pos_x/Settings.var.optim, pos_y/Settings.var.optim, size_x/Settings.var.optim, size_y/Settings.var.optim, current, 0,0,0, color, true)
	else 
		dxDrawRectangle(pos_x, pos_y, size_x, size_y, tocolor(0, 0, 0, 150), true)
    end
end

function preRender ()
	if not Settings.var then
		return
	end

	if Settings.disabled then 
		return
	end 
	
	RTPool.frameStart()
	dxUpdateScreenSource( myScreenSource, true )
	current = myScreenSource
	current = applyGBlurH( current, Settings.var.blur )
	current = applyGBlurV( current, Settings.var.blur )
	current = applyBlackwhite(current)
	dxSetRenderTarget()
end
-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
function applyGBlurH( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

function applyGBlurV( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end

function applyBlackwhite( Src )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blackwhiteShader, "ScreenSource", Src )
	dxDrawImage( 0, 0, mx,my, blackwhiteShader )
	return newRT
end

-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end

--dxCreateBluredRectangle (0,0, x,y, 10)
