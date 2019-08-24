local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local guiEnabled = false 
local titleText = "null"
local descText = "null"

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	end
end
addEventHandler("onClientPreRender",root,camRender)
 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	return true
end

local intro_sound = false
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local zoom = 1
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

function mainScene()
	intro_sound = playSound("http://multiserver.pl/audio/intro.mp3")

	font = dxCreateFont(":ms-hud/f/archivo_narrow.ttf", 25/zoom, false, "antialiased")
	guiEnabled = true
	
	exports["ms-hud"]:showHUD(false)
	exports["ms-radar"]:showRadar(false)
	
	toggleAllControls(false)
	
	smoothMoveCamera(-2322.56,-1672.91,496.23, -2322.97,-1613.31,485.3, -2323.01,-1624.65,485.26, -2322.97,-1613.31,485.3, 10000)
	setTimer(scene1, 15000, 1)
	titleText = "Witaj"
	descText = "Dziękujemy że postanowiłeś wpaść do nas na mikołajki. Postaramy się abyś spędził ten czas mile i przyjemnie. Przygotowaliśmy Dla Was sporo atrakcji. Zapraszamy!"
end
addEvent("startChristmasIntro", true)
addEventHandler("startChristmasIntro", localPlayer, mainScene)

function scene1()
	smoothMoveCamera(-2323.01,-1624.65,485.26, -2322.97,-1613.31,485.3, -2342.30,-1633.25,489.57, -2350.23,-1632.47,489.03, 10000)
	setTimer(scene2, 15000, 1)
	titleText = "Mikołaj"
	descText = "Mikołaj już do nas przybył i przygotowuje dla Was prezenty które będziecie mogli odebrać gdy już będą gotowe. Zasłużyliście na prezent? To się okaże :)"
end

function scene2()
	smoothMoveCamera(-2342.30,-1633.25,489.57, -2350.23,-1632.47,489.03, -2344.30,-1616.17,489.03, -2344.02,-1622.36,489.03, 10000)
	setTimer(scene3, 15000, 1)
	titleText = "Pomoc dla mikołaja"
	descText = "Mikołaj potrzebuje Waszej pomocy! Pomóż mu rozwieść prezenty do innych mieszkańców San Andreas!"
end

function scene3()
	smoothMoveCamera(-2344.30,-1616.17,489.03, -2344.02,-1622.36,489.03, -2322.79,-1605.27,485.36, -2322.67,-1597.04,485.32, 10000)
	setTimer(scene4, 15000, 1)
	titleText = "Dyskoteka"
	descText = "Przygotowaliśmy dla Was również dyskotekę na której będziecie mogli się świetnie bawić!"
end

function scene4()
	smoothMoveCamera(-2322.79,-1605.27,485.36, -2322.67,-1597.04,485.32, -2323.37,-1614.19,508.06, -2323.39,-1613.83,485.36, 10000)
	setTimer(endScene, 15000, 1)
	titleText = "Zaczynamy!"
	descText = "Już za chwilę zaczynamy, prosimy abyś zachowywał się przyzwoicie i czekał na dalsze polecenia administracji."
end

function endScene()
	guiEnabled = false 
	if isElement(font) then destroyElement(font) font = nil end
	setCameraTarget(localPlayer)
	
	exports["ms-hud"]:showHUD(true)
	exports["ms-radar"]:showRadar(true)
	
	toggleAllControls(true)
	stopSound(intro_sound)
	destroyElement(intro_sound)
	setPedAnimation(localPlayer,"ped","facanger",-1,false,true,true,false)
end
addEventHandler("onClientResourceStop", resourceRoot, endScene)

function renderGUI()
	if guiEnabled then 
		local x, y, w, h = 0, 0, screenW, 200/zoom
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(230, 230, 230, 255))
		dxDrawRectangle(x, y+h, w, 5/zoom, tocolor(51, 102, 255, 255), true)
		
		local x, y, w, h = 0, screenH-200/zoom, screenW, 200/zoom
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, w, h, tocolor(230, 230, 230, 255))
		dxDrawRectangle(x, y, w, 5/zoom, tocolor(51, 102, 255, 255), true)
		dxDrawText(titleText, x+1, y+15/zoom+1, w+x+1, h, tocolor(0, 0, 0, 255), 1, font, "center", "top", false, false, true)
		dxDrawText(titleText, x, y+15/zoom, w+x, h, tocolor(51, 102, 255, 255), 1, font, "center", "top", false, false, true)
		
		local x, y, w, h = screenW/2-1280/zoom/2, screenH-140/zoom, 1280/zoom, 200/zoom
		dxDrawText(descText, x+1, y+1, w+x+1, h, tocolor(0, 0, 0, 255), 0.75, font, "center", "top", false, true, true)
		dxDrawText(descText, x, y, w+x, h, tocolor(255, 255, 255, 255), 0.75, font, "center", "top", false, true, true)
	end
end 
addEventHandler("onClientRender", root, renderGUI)
