local screenWidth, screenHeight = guiGetScreenSize()
 
local shader_cinema
local cinema_tex_name = "drvin_screen"

local window_size = {640, 360}
local gUVScale = {-0.2, 0.4}
local gUVPosition = {0.2, 0.1}
local gUVAnim = {0, 0}
local gUVRotAngle = math.rad( 0 )
local gColorMulti = {0.61, 0.61, 0.61, 1}
local gVertexColor = false
local fullscreen = true

function cinema (vid,currtime)
	local RenderTarget = dxCreateRenderTarget( window_size[1], window_size[2] )
	if getElementData(getLocalPlayer(), "cin:browser") then
		destroyElement(getElementData(getLocalPlayer(), "cin:browser"))
		webBrowser = createBrowser(window_size[1], window_size[2], false, false)
		setElementData(getLocalPlayer(),"cin:browser", webBrowser)
	else
		webBrowser = createBrowser(window_size[1], window_size[2], false, false)
		setElementData(getLocalPlayer(),"cin:browser", webBrowser)
	end
	addEventHandler("onClientBrowserCreated", webBrowser, 
		function()
			if fullscreen == true then
				loadBrowserURL(webBrowser, vid)
			else
				loadBrowserURL(webBrowser, vid)
			end
			addEventHandler ( "onClientRender", getRootElement(), 
			function ()
				dxSetRenderTarget( RenderTarget )
					if isBrowserLoading(webBrowser) then
						dxDrawImage(0, 0, window_size[1], window_size[2], "background.png")
					else
						dxDrawImage(0, 0, window_size[1], window_size[2], webBrowser)
					end
				dxSetRenderTarget()
				local px, py, pz = getElementPosition ( getLocalPlayer() )
				if getDistanceBetweenPoints3D ( px, py, pz, 110.86,1023,12.61 ) < 90 then
					local volume = 1 - getDistanceBetweenPoints3D ( px, py, pz, 110.86,1023,12.61 )/90
					setBrowserVolume (getElementData(getLocalPlayer(), "cin:browser"), volume)
				else
					setBrowserVolume (getElementData(getLocalPlayer(), "cin:browser"), 0)
				end
			end )
			shader_cinema, tec = dxCreateShader ( "UVMod.fx" )
			if not shader_cinema then
				outputConsole( "Błąd tworzenia shaderu" )
				destroyElement( texture )
				return
			elseif not RenderTarget then
				outputConsole( "Tekstura nie została załadowana" )
				destroyElement ( shader_cinema )
				tec = nil
				return
			else
				dxSetShaderValue ( shader_cinema, "gUVAnim", gUVAnim)
				dxSetShaderValue ( shader_cinema, "gUVScale", gUVScale)
				dxSetShaderValue ( shader_cinema, "gUVPosition", gUVPosition)
				dxSetShaderValue ( shader_cinema, "gUVRotAngle", gUVRotAngle)
				dxSetShaderValue ( shader_cinema, "gColorMulti", gColorMulti)
				dxSetShaderValue ( shader_cinema, "gVertexColor", gVertexColor)

				engineApplyShaderToWorldTexture ( shader_cinema, cinema_tex_name )	
				dxSetShaderValue ( shader_cinema, "CUSTOMTEX0", RenderTarget )
			end
		end
	)
end
addEvent( "onCinema", true )
addEventHandler( "onCinema", localPlayer, cinema )


local oppened = 0
function openBrowser()
	SearchWebBrowser = guiCreateBrowser(screenWidth/2 - 300, screenHeight/2 - 150 + 25, 600, 300, false, false, false)

	theBrowser = guiGetBrowser(SearchWebBrowser)
	addEventHandler("onClientBrowserCreated", theBrowser, 
		function()
			loadBrowserURL(theBrowser, "http://youtube.com/tv")
			addEventHandler("onClientRender", root, renderSearchPanel)
			showCursor(true)
			setBrowserProperty ( theBrowser, "mobile", 1 )
			oppened = 1
			guiSetInputMode("no_binds")
		end
	)
end
addEvent( "onOpenBrowser", true )
addEventHandler( "onOpenBrowser", localPlayer, openBrowser )

function accessCheck()
 	triggerServerEvent("checkACL", resourceRoot, getLocalPlayer())
end
addCommandHandler("cino",accessCheck)

function renderSearchPanel ()
	hou_cirwindow(screenWidth/2 - 350, screenHeight/2 - 200, 700, 400, tocolor(0,0,0,150))
	hou_cirbutton(screenWidth/2 - 300, screenHeight/2 - 150 - 40, 295, 50, tocolor(151,206,104,150), tocolor(151,206,104,150), tocolor(151,206,104,150), false, "Puść film")
	hou_cirbutton(screenWidth/2 - 300 + 305, screenHeight/2 - 150 - 40, 295, 50, tocolor(227,0,14,150), tocolor(227,0,14,150), tocolor(227,0,14,150), false, "Wyjdź")
end
 
function OnClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if button == "left" then
		if state == "up" then
			if oppened == 1 then
				if absoluteX > screenWidth/2 - 300 and absoluteX < screenWidth/2 - 300 + 295 and absoluteY > screenHeight/2 - 150 - 40 and absoluteY < screenHeight/2 - 150 - 40 + 50 then
					if string.find(tostring(getBrowserURL ( theBrowser )), "?v=") then
	  					triggerServerEvent ( "onStartVideo", resourceRoot, getBrowserURL ( theBrowser ))
						outputChatBox("Tworzenie obrazu", 255,255,255,true)
					else
						outputChatBox("Film nie został znaleziony", 255,255,255,true)
					end
				elseif absoluteX > screenWidth/2 - 300 + 305 and absoluteX < screenWidth/2 - 300 + 305 + 295 and absoluteY > screenHeight/2 - 150 - 40 and absoluteY < screenHeight/2 - 150 - 40 + 50 then
					removeEventHandler("onClientRender", root, renderSearchPanel)
					destroyElement(SearchWebBrowser)
					oppened = 0
					showCursor(false)
					guiSetInputMode("allow_binds")
				end
			end
		end
	end
end
addEventHandler ( "onClientClick", getRootElement(), OnClick )

function setCinemaURL(cmd, arg1)
	if getElementData(localPlayer, "player:rank") < 1 then return end
	triggerServerEvent ( "onStartVideo", resourceRoot, "https://www.youtube.com/tv#/watch/video/control?v=".. arg1 .."&resume")
end
addCommandHandler("cinourl", setCinemaURL)