--[[
	MultiServer 
	Zasób: ms-login/gui_c.lua
	Opis: Skrypt obsługujący interfejs panelu logowania.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local informations = [[18.02.2017 
Dodano /slender
]]

local loginVideo = "3A6IJfBG2cc"
local xmlEncryption = "cipskoszmataiostreruchanie"

local screenW, screenH = guiGetScreenSize()

local baseX = 1920
local zoom = 1 
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 
font = dxCreateFont("img/archivo_narrow.ttf", 25/zoom, false, "antialiased")

local loginRemember = false 
local loginBrowser, browserLoaded = false, false

function loadLoginPanel()
	if getElementData(localPlayer, "player:spawned") then return end 
	
	local playerLogin, playerPass = checkLoginXML()
	loginRemember = #playerLogin > 0 
 
	loginBrowser = createBrowser(screenW, screenH, false, true)
	
	if loginBrowser then 
		addEventHandler("onClientBrowserCreated", loginBrowser, function()
			loadBrowserURL(loginBrowser, 'https://www.youtube.com/embed/'..loginVideo..'?version=3&autoplay=1&rel=0&showinfo=0&frameborder=0&fs=1&controls=0&iv_load_policy=3&modestbranding=1&loop=1&playlist='..loginVideo)
			addEventHandler("onClientBrowserDocumentReady", loginBrowser, function()
				setTimer(function()
					browserLoaded = true
					startLogoTick = getTickCount()
					
					loginMusic = playSound("music.mp3", true)
					setSoundVolume(loginMusic, 0.8)
					setTimer(function()
						loginInput = exports["ms-gui"]:createEditBox(playerLogin, loginBgPos.x+30/zoom, loginBgPos.y+80/zoom, loginBgPos.w-(30/zoom)*2, 60/zoom, tocolor(230, 230, 230, 230), font, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(loginInput, "Wprowadź login")
						exports["ms-gui"]:setEditBoxMaxLength(loginInput, 25)
						passInput = exports["ms-gui"]:createEditBox(playerPass, loginBgPos.x+30/zoom, loginBgPos.y+170/zoom, loginBgPos.w-(30/zoom)*2, 60/zoom, tocolor(230, 230, 230, 230), font, 0.6)
						exports["ms-gui"]:setEditBoxHelperText(passInput, "Wprowadź hasło")
						exports["ms-gui"]:setEditBoxMaxLength(passInput, 25)
						exports["ms-gui"]:setEditBoxMasked(passInput, true)
					end, 5000, 1)
					
				end, 1000, 1)
			end)
		end)
	else 
		browserLoaded = "can't load"
		startLogoTick = getTickCount()
					
		loginMusic = playSound("music.mp3", true)
		setSoundVolume(loginMusic, 0.8)
		
		setTimer(function()
			loginInput = exports["ms-gui"]:createEditBox(playerLogin, loginBgPos.x+30/zoom, loginBgPos.y+80/zoom, loginBgPos.w-(30/zoom)*2, 60/zoom, tocolor(230, 230, 230, 230), font, 0.6)
			exports["ms-gui"]:setEditBoxHelperText(loginInput, "Wprowadź login")
			exports["ms-gui"]:setEditBoxMaxLength(loginInput, 25)
			passInput = exports["ms-gui"]:createEditBox(playerPass, loginBgPos.x+30/zoom, loginBgPos.y+170/zoom, loginBgPos.w-(30/zoom)*2, 60/zoom, tocolor(230, 230, 230, 230), font, 0.6)
			exports["ms-gui"]:setEditBoxHelperText(passInput, "Wprowadź hasło")
			exports["ms-gui"]:setEditBoxMaxLength(passInput, 25)
			exports["ms-gui"]:setEditBoxMasked(passInput, true)
		end, 5000, 1)
	end 
	
	-- grafika 
	loginBgPos = {x=screenW/2-(380/zoom+550/zoom)/2, y=screenH/1.9-431/zoom/2, w=380/zoom, h=431/zoom}
	infoBgPos = {x=loginBgPos.x+loginBgPos.w+15/zoom, y=screenH/1.9-431/zoom/2, w=550/zoom, h=431/zoom}
	
	allAlpha = 0
	
	fadeCamera(true)
	
	showCursor(true)
	showChat(false)
	addEventHandler("onClientHUDRender", root, onRenderLoginPanel)
	addEventHandler("onClientKey", root, onClientKey)
	guiSetInputMode("no_binds")
end

function checkLoginXML()
	local xml = xmlLoadFile("login.xml")
	if not xml then 
		return "", ""
	end
	
	local child = xmlFindChild(xml, "data", 0)
	local login = xmlNodeGetAttribute(child, "login")
	local pass = xmlNodeGetAttribute(child, "pass")
	if #login == 0 or #pass == 0 then 
		xmlUnloadFile(xml)
		return "", ""
	end 
	
	pass = teaDecode(pass, xmlEncryption)
	
	xmlUnloadFile(xml)
	
	return login, pass
end 

function saveLoginXML(name, pass)
	local xml = xmlLoadFile("login.xml")
	if not xml then 
		xml = xmlCreateFile("login.xml", "login")
	end
	
	local child = xmlFindChild(xml, "data", 0)
	if not child then 
		child = xmlCreateChild(xml, "data")
	end 
	
	pass = teaEncode(pass, xmlEncryption) 
	
	xmlNodeSetAttribute(child, "login", name)
	xmlNodeSetAttribute(child, "pass", pass)
	
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
end

function showRegistration() 
	if registrationEnabled then return end 
	setTimer(function()
		local x, y, w, h = infoBgPos.x+10/zoom, infoBgPos.y+80/zoom, loginBgPos.w-(30/zoom)*2, 60/zoom
		x = x+infoBgPos.w/2-w/2
		
		registerLoginInput = exports["ms-gui"]:createEditBox( "", x, y, w, h, tocolor(230, 230, 230, 230), font, 0.6)
		exports["ms-gui"]:setEditBoxHelperText(registerLoginInput, "Login")
		exports["ms-gui"]:setEditBoxMaxLength(registerLoginInput, 25)
		
		y = y+90/zoom
		registerPasswordInput = exports["ms-gui"]:createEditBox( "", x, y, w, h, tocolor(230, 230, 230, 230), font, 0.6)
		exports["ms-gui"]:setEditBoxHelperText(registerPasswordInput, "Hasło")
		exports["ms-gui"]:setEditBoxMasked(registerPasswordInput, true)
		exports["ms-gui"]:setEditBoxMaxLength(registerPasswordInput, 50)
		
		y = y+90/zoom
		registerEmailInput = exports["ms-gui"]:createEditBox( "", x, y, w, h, tocolor(230, 230, 230, 230), font, 0.55)
		exports["ms-gui"]:setEditBoxHelperText(registerEmailInput, "E-mail")
	end, 500, 1)
	
	startRegTick = getTickCount() 
	registrationEnabled = true 
end 


function fadeLoginPanel() 
	startFadeTick = getTickCount()
	fadeLogin = true 
	setTimer(fadeCamera, 500, 1, false)
	setTimer(enableSkinSelector, 1000, 1)
	
	exports["ms-gui"]:destroyEditBox(loginInput)
	exports["ms-gui"]:destroyEditBox(passInput)
	exports["ms-gui"]:destroyEditBox(registerLoginInput)
	exports["ms-gui"]:destroyEditBox(registerPasswordInput)
	exports["ms-gui"]:destroyEditBox(registerEmailInput)
end 


function fadeLoginMusic()
	if isElement(loginMusic) then
		local vol = getSoundVolume(loginMusic)
		vol = vol-0.05
		if vol <= 0 then 
			destroyElement(loginMusic)
		else
			setSoundVolume(loginMusic, vol)
			setTimer(fadeLoginMusic, 100, 1)
		end
	end
end 

function destroyLoginPanel()
	destroyElement(loginBrowser)
	showCursor(false)
	removeEventHandler("onClientHUDRender", root, onRenderLoginPanel)
	removeEventHandler("onClientKey", root, onClientKey)
	guiSetInputMode("allow_binds")
end 

_mathMax = math.max
function onRenderLoginPanel()
	local now = getTickCount()
	
	local progress = 0
	if startLogoTick then 
		progress =  (now-startLogoTick) / 2000 
	end 
	
	local logoAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, _mathMax(0, progress), "InOutQuad")
	
	local logoProgress = 0 
	if logoAlpha == 255 then 
		if not startLogoTick2 then 
			startLogoTick2 = getTickCount()
		end 
		
		local progress = (now-startLogoTick2) / 2000
		logoProgress = interpolateBetween(0, 0, 0, 1, 0, 0, _mathMax(0, progress), "InOutQuad")
		
		if progress >= 1 then 
			if not startLoginTick then 
				startLoginTick = now 
			end 

			progress = (now-startLoginTick) / 1000 
			if not fadeLogin then 
				allAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, _mathMax(0, progress), "InOutQuad")
			end
		end
	end 

	if browserLoaded == "can't load" then 
		dxDrawImage(0, 0, screenW, screenH, "img/bg.jpg")
	elseif browserLoaded == true and logoAlpha > 50 then 
		setBrowserVolume(loginBrowser, 0)
		
		if startLoginTick and now > startLoginTick+1000 then
			dxDrawImageSection(0, 0, screenW, screenH, 0, 50, screenW, screenH-50*2, loginBrowser, 0, 0, 0, tocolor(255, 255, 255, allAlpha)) 
		else 
			dxDrawImageSection(0, 0, screenW, screenH, 0, 50, screenW, screenH-50*2, loginBrowser, 0, 0, 0, tocolor(255, 255, 255, 255)) 
		end
	else 
		dxDrawRectangle(0, 0, screenW, screenH, tocolor(0, 0, 0, 255))
	end
	
	-- login
	local x, y, w, h = loginBgPos.x, screenH/2-200/zoom/2, 600/zoom, 200/zoom 
	x = x+(loginBgPos.w+infoBgPos.w+15/zoom)/2-w/2
	y = y - (400/zoom)*logoProgress
	
	if startLoginTick and now > startLoginTick+1000 then 
		dxDrawImage(x, y, w, h, "img/logo.png", 0, 0, 0, tocolor(255, 255, 255, allAlpha), true)
	else
		dxDrawImage(x, y, w, h, "img/logo.png", 0, 0, 0, tocolor(255, 255, 255, logoAlpha), true)
	end 
	
	dxDrawRectangle(loginBgPos.x, loginBgPos.y, loginBgPos.w, loginBgPos.h, tocolor(10, 10, 10, _mathMax(0, allAlpha-155)))
	exports["ms-gui"]:dxDrawBluredRectangle(loginBgPos.x, loginBgPos.y, loginBgPos.w, loginBgPos.h, tocolor(200, 200, 200, _mathMax(0, allAlpha)))
	dxDrawRectangle(loginBgPos.x, loginBgPos.y, loginBgPos.w, loginBgPos.h*0.1, tocolor(10, 10, 10, _mathMax(0, allAlpha-50)), true)
	dxDrawText("Logowanie", loginBgPos.x, loginBgPos.y, loginBgPos.x+loginBgPos.w, loginBgPos.y+loginBgPos.h*0.1, tocolor(255, 255, 255, _mathMax(0, allAlpha-25)), 0.65, font or "default-bold", "center", "center", false, false, true)
	
	dxDrawRectangle(loginBgPos.x+20/zoom, loginBgPos.y+80/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom, tocolor(10, 10, 10, _mathMax(0, allAlpha-50)), true)
	
	dxDrawRectangle(loginBgPos.x+20/zoom, loginBgPos.y+170/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom, tocolor(10, 10, 10, _mathMax(0, allAlpha-50)), true)
	
	local x, y, w, h = loginBgPos.x+20/zoom, loginBgPos.y+250/zoom, 32/zoom, 32/zoom
	if isCursorOnElement(x, y, w, h) or loginRemember then 
		dxDrawRectangle(x, y, w, h, tocolor(60, 60, 60, _mathMax(0, allAlpha-50)), true)
		if loginRemember then 
			dxDrawRectangle(x+5/zoom, y+5/zoom, w-10/zoom, h-10/zoom, tocolor(0, 102, 204, _mathMax(0, allAlpha-50)), true)
		else 
			dxDrawRectangle(x+5/zoom, y+5/zoom, w-10/zoom, h-10/zoom, tocolor(0, 102, 204, _mathMax(0, allAlpha-220)), true)
		end
	else 
		dxDrawRectangle(x, y, w, h, tocolor(60, 60, 60, _mathMax(0, allAlpha-25)), true)
	end 
	dxDrawText("Zapamiętaj mnie", x+45/zoom, y, x+w, y+h, tocolor(255, 255, 255, allAlpha), 0.6, font, "left", "center", false, false, true)
	
	local x, y, w, h = loginBgPos.x+20/zoom, loginBgPos.y+loginBgPos.h-80/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom
	if isCursorOnElement(x, y, w, h) then 
		dxDrawRectangle(x, y, w, h, tocolor(0, 102, 204, _mathMax(0, allAlpha-100)), true)
	else 
		dxDrawRectangle(x, y, w, h, tocolor(0, 102, 204, _mathMax(0, allAlpha-150)), true)
	end 
	dxDrawText("Zaloguj się", x, y, x+w, y+h, tocolor(255, 255, 255, allAlpha), 0.7, font, "center", "center", false, false, true)
	
	-- box 
	dxDrawRectangle(infoBgPos.x, infoBgPos.y, infoBgPos.w, infoBgPos.h, tocolor(10, 10, 10, _mathMax(0, allAlpha-155)))
	exports["ms-gui"]:dxDrawBluredRectangle(infoBgPos.x, infoBgPos.y, infoBgPos.w, infoBgPos.h, tocolor(200, 200, 200, _mathMax(0, allAlpha)))
	dxDrawRectangle(infoBgPos.x, infoBgPos.y, infoBgPos.w, infoBgPos.h*0.1, tocolor(10, 10, 10, _mathMax(0, allAlpha-50)), true)
	dxDrawText("Informacje", infoBgPos.x, infoBgPos.y, infoBgPos.x+infoBgPos.w, infoBgPos.y+infoBgPos.h*0.1, tocolor(255, 255, 255, _mathMax(0, allAlpha-25)), 0.65, font or "default-bold", "center", "center", false, false, true)
	
	local x, y, w, h = infoBgPos.x, infoBgPos.y+infoBgPos.h-80/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom
	x = x+infoBgPos.w/2-w/2
	
	if isCursorOnElement(x, y, w, h) then 
		dxDrawRectangle(x, y, w, h, tocolor(0, 102, 204, _mathMax(0, allAlpha-100)), true)
	else 
		dxDrawRectangle(x, y, w, h, tocolor(0, 102, 204, _mathMax(0, allAlpha-150)), true)
	end 
	dxDrawText("Rejestracja", x, y, x+w, y+h, tocolor(255, 255, 255, allAlpha), 0.7, font, "center", "center", false, false, true)
	
	local infoAlpha = _mathMax(0, allAlpha-25)
	if registrationEnabled then 
		local progress = (now-startRegTick) / (startRegTick+500 - startRegTick)
		local alpha = interpolateBetween(infoAlpha, 0, 0, 0, 0, 0, _mathMax(0, progress), "InQuad")
		infoAlpha = alpha 
	end 
	
	dxDrawText(informations, infoBgPos.x+50/zoom, infoBgPos.y+60/zoom, infoBgPos.x+infoBgPos.w-50/zoom, infoBgPos.y+infoBgPos.h, tocolor(255, 255, 255, infoAlpha), 0.6, font, "center", "top", false, true, true)
		
	local now = getTickCount() 
	if fadeLogin then 
		local progress = (now-startFadeTick) / 2500
		local alpha = interpolateBetween(allAlpha, 0, 0, 0, 0, 0, _mathMax(0, progress), "InQuad")
		allAlpha = alpha	
		
		if progress > 0.7 then 
			destroyLoginPanel()
		end
	end 
	
	if registrationEnabled then 
		local progress = (now-startRegTick) / 750
		regAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, _mathMax(0, progress), "InQuad")
		if progress > 1 then 
			regAlpha = allAlpha 
		end 
		
		local x, y, w, h = infoBgPos.x, infoBgPos.y+80/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom
		x = x+infoBgPos.w/2-w/2
		
		dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, _mathMax(0, regAlpha-50)), true)
		
		y = y+90/zoom
		dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, _mathMax(0, regAlpha-50)), true)
		
		y = y+90/zoom
		dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, _mathMax(0, regAlpha-50)), true)
	end 
	
	exports["ms-gui"]:renderEditBox(loginInput)
	exports["ms-gui"]:renderEditBox(passInput)
	exports["ms-gui"]:renderEditBox(registerLoginInput)
	exports["ms-gui"]:renderEditBox(registerPasswordInput)
	exports["ms-gui"]:renderEditBox(registerEmailInput)
end 

function onClientKey(key, press)
	if key == "mouse1" then 
		if press then 
		else 
			if fadeLogin then return end 
			if startLoginTick and getTickCount() < startLoginTick+1000 then return end 
			
			local x, y, w, h = loginBgPos.x+20/zoom, loginBgPos.y+loginBgPos.h-80/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom
			if isCursorOnElement(x, y, w, h) then 
				local name, password = exports["ms-gui"]:getEditBoxText(loginInput), exports["ms-gui"]:getEditBoxText(passInput)
				if #name < 3 then 
					triggerEvent("onClientAddNotification", localPlayer, "Login musi mieć conajmniej 3 znaki.", "error")
					return 
				end 
				
				if #password < 5 then 
					triggerEvent("onClientAddNotification", localPlayer, "Hasło musi mieć conajmniej 5 znaków.", "error")
					return 
				end 
				
				if loginRemember then 
					saveLoginXML(name, password)
				end 
				
				triggerServerEvent("onPlayerEnterAccount", localPlayer, name, password)
			end 
			
			local x, y, w, h = infoBgPos.x, infoBgPos.y+infoBgPos.h-80/zoom, loginBgPos.w-(20/zoom)*2, 60/zoom
			x = x+infoBgPos.w/2-w/2
			if isCursorOnElement(x, y, w, h) and not registrationEnabled then 
				showRegistration()
			elseif isCursorOnElement(x, y, w, h) and registrationEnabled then 
				local name, password, email = exports["ms-gui"]:getEditBoxText(registerLoginInput), exports["ms-gui"]:getEditBoxText(registerPasswordInput), exports["ms-gui"]:getEditBoxText(registerEmailInput)
				if #name < 3 then 
					triggerEvent("onClientAddNotification", localPlayer, "Login musi mieć conajmniej 3 znaki.", "error")
					return 
				end 
				
				if isColor(name) then 
					triggerEvent("onClientAddNotification", localPlayer, "Kolorowe nicki są zabronione.", "error")
					return 
				end 
				
				if #password < 5 then 
					triggerEvent("onClientAddNotification", localPlayer, "Hasło musi mieć conajmniej 5 znaków.", "error")
					return 
				end 
				
				if not email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") then  
					triggerEvent("onClientAddNotification", localPlayer, "To nie jest prawidłowy e-mail.", "error")
					return 
				end
				
				triggerServerEvent("onPlayerCreateAccount", localPlayer, name, password, email)
			end
			
			if isCursorOnElement(loginBgPos.x+20/zoom, loginBgPos.y+250/zoom, 32/zoom, 32/zoom) then 
				loginRemember = not loginRemember
			end
		end
	elseif key == "enter" and press then 
		if fadeLogin then return end 
		
		local name, password = exports["ms-gui"]:getEditBoxText(loginInput), exports["ms-gui"]:getEditBoxText(passInput)
		if #name < 3 then 
			triggerEvent("onClientAddNotification", localPlayer, "Login musi mieć conajmniej 3 znaki.", "error")
			return 
		end 
				
		if #password < 5 then 
			triggerEvent("onClientAddNotification", localPlayer, "Hasło musi mieć conajmniej 5 znaków.", "error")
			return 
		end 
				
		triggerServerEvent("onPlayerEnterAccount", localPlayer, name, password)
	end
end 

function onClientResourceStart()
	triggerEvent("fadeLoginSound", localPlayer)
	setElementData(localPlayer, "player:downloaded", true)
	setTimer(loadLoginPanel, 1000, 1)
end 
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart) 

function onClientLoginSuccess()
	fadeLoginPanel()
end 
addEvent("onClientLoginSuccess", true)
addEventHandler("onClientLoginSuccess", root, onClientLoginSuccess)

function onClientRegisterSuccess()
	fadeLoginPanel()
end 
addEvent("onClientRegisterSuccess", true)
addEventHandler("onClientRegisterSuccess", root, onClientRegisterSuccess)

