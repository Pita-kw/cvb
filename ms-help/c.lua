--[[
	MultiServer 
	Zasób: ms-help/c.lua
	Opis: Panel pomocy.
	Autor: Brzysiek <brzysiekdev@gmail.com>
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]

local HELP_CATEGORIES = 
{
	"Regulamin",
	"Systemy",
	"Komendy",
	"Diamenty",
	"Premium",
	"Klawiszologia",
	"Autorzy",
}

local prace = [[
#3366FFPrace

#FFFFFFNa naszym serwerze są dostepne róznego rodzaju prace, 
dzięki którym możesz dorobić pieniądze. 
Zarabianie na pracach jest całkowicie opcjonalne.
Prace są oznaczone ikonka dolara pod klawiszem F11.

Udostępnione prace:
Górnik - zbierz dostepne minerały w kopalni (/gornik)
Ogrodnik - pielęgnuj trawę (/ogrodnik)
Pilot - przetransportuj ludzi drogą powietrzną (/pilot)
Kierowca cięzarówki - dowieź towar w określone miejsce 
(/spedycja-ls, /spedycja-lv, /spedycja-sf)
]]

local pojazdy = [[ 
#3366FFPojazdy

#FFFFFFNa naszym serwerze możesz zespawnować sobie pojazd klikając klawisz F2.
Od 5 levela oferujemy kupno prywatnych pojazdów. 
Salon samochodowy znajduje się pod klawiszem F11 oznaczony ikoną pojazdu.
Posiadając prywatny pojazd możemy go dowolnie modernizować w 
tuning shopie (oznaczony ikoną auta z kluczem), oraz sprzedać go na giełdzie.
Pojazdy publicznie nie posiadają takiej mozliwości.
]]

local wyzwania = [[
#3366FFWyzwania

#FFFFFFStworzyliśmy system wyzwań, który polega na pobijaniu rekordów czasowych.
Sa to między innymi: trasy wyscigowe, parkour oraz wszelkie tory przeszkód.
Za ukończenie wyzwania gracz otrzymuje jednorazowe wynagrodzenie. 
Wyzwania są oznaczone stoperem pod klawiszem F11.
]]

local areny = [[
#3366FFAreny

#FFFFFFDysponujemy szerokim wyborem aren o tematyce DM.
Areny rózią się nie tylko bronią czy miejscem, lecz każda ma inną funkcjonalność. 
Kazda jest unikalna na swój sposób. Posiadamy areny:
/onede - Jeden strzał zabija.
/dust - Mamy do dyspozycji zestaw malego rozbójnika na mapie de_dust z CS 1.6.
/sniper - Strzał w glowe zabija natychmiastowo.
/bazooka - Zabij gracza za pomocą RPG.
/minigun - Zabij przeciwnika Minigunem.

Listę aren znajdziesz również pod klawiszem F5.
]]

local domki = [[ 
#3366FFDomki

#FFFFFFPosiadamy nietuzinkowy system domków, który oferuje 
projektowanie go od podstaw wedlug wlasnego gustu. 
Niektóre domy na sprzedaż są nieumeblowane.
Możemy zakupić dodatkowe dowolne meble do naszego domku za pomocą klawisza F6. 
Po zakupie wyposażenia możemy go dowolnie ustawić pod klawiszem F7. 
Istnieje również opcja zameldowania innych graczy 
w celu wspólnego zamieszkania, bądź wynajęcia mieszkania. 
Aby zakupić dom nalezy posiadać 10 level.
]]

local regulamin = [[
#FFFFFF
Poniższy regulamin jest oparty na zasadach netykiety i dobrego wychowania.
Powinieneś instynktownie wyczuwać, co jest dozwolone, a co nie. 
Ponad tymi suchymi regułami stoi zdrowy rozsądek, dlatego też nieznajomość 
regulaminu lub słowa, nie widziałem punktu, który tego zabrania, nie stanowi 
żadnego wytłumaczenia.

1.Nie nadużywamy wulgaryzmów.
2. Nie wyzywamy innych graczy oraz nie prowokujemy do kłótni.
3. Nie spamujemy ani nie floodujemy.
5. Nie oszukujemy graczy ani nie używamy wspomagaczy.
6. Słuchamy się administracji.
7. Nie używamy błędów serwera lecz zgłaszamy administracji.
8. Używamy systemów serwera zgodnie z ich przeznaczeniem.
]]

local eventy = [[
#3366FFEventy#FFFFFF

Zapisy na eventy są dostępne w prawym dolnym rogu ekranu.

- Carball (/cb) - piłka nożna pojazdami podobna do gry Rocket League
- Berek (/br) - nie daj sie złapać przed berkiem
- Capture The Flag (/ctf) - zdobądź więcej flag
- Debry (/db) - zepchnij innych graczy pojazdem
- Chowany (/ch) - nie pozwól się znaleźć szukającemu
- Race (/rc) - ścigaj się z innymi róznymi pojazdami
- Team Deathmatch (/tdm) - zdobądz więcej zabójstw niz drużyna przeciwna
- Uwazaj, spadasz! (/us) - uważaj na spadające platformy
]]

local klawiszologia = [[
#3366FFBindy
#FFFFFFF1 - Dashboard
F2 - Spawner pojazdów
F3 - Panel teleportów
F4 - Panel audio
F5 - Panel aren
F11 - Mapa
1 (W pojeździe) - Obrócenie pojazdu na koła.
2 (W pojeździe) - Naprawa pojazdu
SHIFT (W pojeździe) - Interakcja pojazdu
X - Przyklejasz się do pojazdu
[ oraz ]  - Podwyższenie/Zaniżenie podwozia pojazdu.
K - Przytrzymaj by zobaczyć domki na mapie
]]

local diamenty = [[
#3366FFCo to są diamenty?
#FFFFFFDiamenty są wirtualną walutą na naszym serwerze przez którą można
kupić pewne usługi, a zarazem wesprzeć nasz serwer. Jeżeli chcesz się dowiedzieć 
co obecnie można kupić za dimenty, przejdź do sklepu który znajduje się pod klawiszem F1.

#3366FFJak je doładować?
#FFFFFF1.Wejdź na naszą stronę www.multiserver.pl.
2.Kliknij w menu zakładkę "Doładuj diamenty".
3. Postępuj zgodnie z instrukcją zawartą na ekranie.

#faff00Aby poznać możliwości konta Premium przejdź na następną stronę.
]]

local vip = [[
#faff00Jakie możliwości posiada konto premium?#ffffff

- Darmowa naprawa pojazdów.
- Darmowe uleczanie się.
- Dostęp do skinów premium.
- Pisanie ogłoszeń na ekranie (/ann)
- Większe zarobki exp oraz pieniedzy o 30%
- Ikonka gwiazdki nad nickiem.
- Wyróżniony kolor nicku na czacie.
- Darmowe bronie pod /bronie
- Dostęp do czatu premium ($ tekst)


#faff00Zakupić konto premium możesz w panelu gracza który dostępny
jest pod klawiszem F1.  Kupując konto premium wspierasz serwer.

#ffffffZa wszelkie wsparcie Serdecznie Dziękujemy.
]]

local komendy = [[
#3366FFKomendy 

#FFFFFF/pw, /pm, /w - prywatna wiadomość
/skin <id skina> - zmień skin 
/wyzwij <id gracza> - wyzwij gracza
/sesja - sprawdzasz aktualny czas sesji na serwerze.
/hitman <id gracza> <cena> - wystawiasz zlecenie za zabicie gracza.
/hitman-list - pokazuje aktualną listę zleceń.
/gangs - Lista gangów
/raport <id gracza> <powód> - reportujesz gracza.
/idzdo <id gracza> - Wysyłasz prośbę o teleport.
/wypisz - Wypisujesz się z eventu.
/ae - Wychodzisz z areny.
]]

local komendy2 = [[
#3366FFKomendy #FFFFFF

/endwork - Kończysz bieżące zlecenie.
/tpac <id gracza> - Akceptujesz prośbę o teleport
/przelej - Przelewasz pieniądze graczowi.
/fix - Naprawiasz pojazd.
/flip - Obracasz pojazd.
/spawn - Spawnujesz się (W przypadku problemów)
/bronie - Otwierasz sklep z broniami
/endwork - Kończysz obecną pracę
/dystans <id gracza> - pokazuje dystans między tobą a wybranym graczem.
/kolor - Zmiana koloru nicku na czacie
/hp - Odnawiasz życie za 500$
/ar - Kupujesz kamizelkę za 2500$
]]

local autorzy = [[
#3366FFZałożyciele 
#FFFFFFVirelox, Brzysiek

#3366FFSkrypty 
#FFFFFFTryb gry: Brzysiek, Virelox
Dodatkowe zasoby: Jurandovsky, Ren712, Noneatme, Devan_LT

#3366FFGrafika
#FFFFFFVirelox

#3366FFObiekty 
#FFFFFFTimek & L4nceR
]]

local autorzy2 = [[
#3366FFPodziękowania
#FFFFFFAteX, Puzzel, Bestiality, Lisa_, ProxiaK, Tomcio, Wicek, Xiadz, oraz
dla wszystkich graczy za to, że jesteście z nami.
]]

local HELP_CONTENT = 
{
	["Regulamin"] = {title="Regulamin serwera", 
								   pages={regulamin}},
	["Systemy"] = {title="Systemy",
						   pages={pojazdy, domki, areny, wyzwania, prace, eventy}},
	["Komendy"] =  {title="Komendy",
						   pages={komendy, komendy2}},
	["Diamenty"] = {title="Diamenty",
							pages={diamenty}},
	["Klawiszologia"] = {title="Klawiszologia",
								  pages={klawiszologia,}},
	["Autorzy"] = {title="Autorzy serwera",
						 pages={autorzy, autorzy2}},
	["Premium"] = {title="Premium",
						 pages={vip}},
}	   

local selectedTab = 1
local hoveredTab = 1

local selectedPage = 1 

local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 1.8
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

local showHelp = false
local bgPos = {x=(screenW/2)-(900/zoom/2), y=(screenH/2)-(600/zoom/2), w=900/zoom, h=528/zoom}

function clickHelpPanel(key, press)
	if key == "mouse1" then 
		if press then 
			if hoveredTab then 
				local offsetY = (75/zoom)*(hoveredTab-1)
				if isCursorOnElement(bgPos.x, bgPos.y+offsetY, bgPos.w * 0.2, 75/zoom) then 
					selectedTab = hoveredTab
					selectedPage = 1
				end
			end
			
			local title = HELP_CATEGORIES[selectedTab]
			if #HELP_CONTENT[title].pages > 1 and selectedPage > 1 then 
				local x, y, w, h = bgPos.x + bgPos.w/2 - 20/zoom, bgPos.y+bgPos.h-60/zoom, 40/zoom, 40/zoom
				if isCursorOnElement(x, y, w, h) then 
					selectedPage = selectedPage-1
				end
			end
			
			if #HELP_CONTENT[title].pages > 1 and selectedPage >= 1 and selectedPage < #HELP_CONTENT[title].pages then 
				local x, y, w, h = bgPos.x + bgPos.w/2 + 155/zoom, bgPos.y+bgPos.h-60/zoom, 40/zoom, 40/zoom
				if isCursorOnElement(x, y, w, h) then 
					selectedPage = selectedPage+1
				end
			end
			
		end
	end
end 

function renderHelpPanel()
	exports["ms-gui"]:dxDrawBluredRectangle(bgPos.x, bgPos.y, bgPos.w, bgPos.h, tocolor(220, 220, 220, 255))
	
	for k,v in ipairs(HELP_CATEGORIES) do 
		local offsetY = (75/zoom)*(k-1)
		
		local highlight = false
		local rectangleHighlight = false 
		
		if isCursorOnElement(bgPos.x, bgPos.y+offsetY, bgPos.w * 0.2, 75/zoom) then 
			rectangleHighlight  = true 
			hoveredTab = k 
		end 
		
		if selectedTab == k then 
			highlight = true 
			rectangleHighlight = true 
		end
		
		if rectangleHighlight then 
			dxDrawRectangle(bgPos.x, bgPos.y+offsetY, bgPos.w * 0.2, 75/zoom, tocolor(30, 30, 30, 200), true)
		else 
			dxDrawRectangle(bgPos.x, bgPos.y+offsetY, bgPos.w * 0.2, 75/zoom, tocolor(10, 10, 10, 150), true)
		end
		
		if highlight then 
			dxDrawRectangle(bgPos.x, bgPos.y+offsetY, 5/zoom, 75/zoom, tocolor(51, 102, 255, 255), true)
		end
		
		dxDrawText(v, bgPos.x, bgPos.y+offsetY, bgPos.x + bgPos.w * 0.2, bgPos.y+offsetY+75/zoom, tocolor(200, 200, 200, 200), 0.7, font, "center", "center", false, false, true, false, false)
	end
	
	local title = HELP_CATEGORIES[selectedTab]
	dxDrawText(HELP_CONTENT[title].title, bgPos.x+bgPos.w*0.225-9/zoom, bgPos.y+31/zoom, bgPos.x + bgPos.w - 19/zoom, bgPos.y+1/zoom, tocolor(0, 0, 0, 230), 0.9, font, "center", "top", false, false, true, false, false)
	dxDrawText(HELP_CONTENT[title].title, bgPos.x+bgPos.w*0.225-10/zoom, bgPos.y+30/zoom, bgPos.x + bgPos.w - 20/zoom, bgPos.y, tocolor(230, 230, 230, 230), 0.9, font, "center", "top", false, false, true, false, false)
	
	dxDrawText(HELP_CONTENT[title].pages[selectedPage]:gsub( '#%x%x%x%x%x%x', '' ), bgPos.x+bgPos.w*0.225-9/zoom, bgPos.y+81/zoom, bgPos.x + bgPos.w - 19/zoom, bgPos.y+1/zoom, tocolor(0, 0, 0, 200), 0.65, font, "center", "top", false, false, true, true, false)
	dxDrawText(HELP_CONTENT[title].pages[selectedPage], bgPos.x+bgPos.w*0.225-10/zoom, bgPos.y+80/zoom, bgPos.x + bgPos.w - 20/zoom, bgPos.y, tocolor(210, 210, 210, 200), 0.65, font, "center", "top", false, false, true, true, false)
	
	if #HELP_CONTENT[title].pages > 1 then 
		if selectedPage > 1 then 
			local x, y, w, h = bgPos.x + bgPos.w/2 - 17/zoom, bgPos.y+bgPos.h-60/zoom, 40/zoom, 40/zoom
			if isCursorOnElement(x, y, w, h) then 
				dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 200), true)
				dxDrawText("<", x, y, x+w, y+h, tocolor(230, 230, 230, 250), 0.9, font, "center", "center", false, false, true, false, false)
			else 
				dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 250), true)
				dxDrawText("<", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.9, font, "center", "center", false, false, true, false, false)
			end
		else 
			local x, y, w, h = bgPos.x + bgPos.w/2 - 17/zoom, bgPos.y+bgPos.h-60/zoom, 40/zoom, 40/zoom
			dxDrawRectangle(x, y, w, h, tocolor(70, 70, 70, 200), true)
			dxDrawText("<", x, y, x+w, y+h, tocolor(230, 230, 230, 250), 0.9, font, "center", "center", false, false, true, false, false)
		end
		
		if #HELP_CONTENT[title].pages > 1 and selectedPage >= 1 and selectedPage < #HELP_CONTENT[title].pages then 
			local x, y, w, h = bgPos.x + bgPos.w/2 + 155/zoom, bgPos.y+bgPos.h-60/zoom, 40/zoom, 40/zoom
			if isCursorOnElement(x, y, w, h) then 
				dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 200), true)
				dxDrawText(">", x, y, x+w, y+h, tocolor(230, 230, 230, 250), 0.9, font, "center", "center", false, false, true, false, false)
			else 
				dxDrawRectangle(x, y, w, h, tocolor(51, 102, 255, 250), true)
				dxDrawText(">", x, y, x+w, y+h, tocolor(230, 230, 230, 230), 0.9, font, "center", "center", false, false, true, false, false)
			end
		else 
			local x, y, w, h = bgPos.x + bgPos.w/2 + 155/zoom, bgPos.y+bgPos.h-60/zoom, 40/zoom, 40/zoom
			dxDrawRectangle(x, y, w, h, tocolor(70, 70, 70, 200), true)
			dxDrawText(">", x, y, x+w, y+h, tocolor(230, 230, 230, 250), 0.9, font, "center", "center", false, false, true, false, false)
		end 
	end 
	
	
	if #HELP_CONTENT[title].pages > 1 then 
		local text = "Strona "..tostring(selectedPage).." z "..tostring(#HELP_CONTENT[title].pages)
		local width = dxGetTextWidth(text, 0.6, font)
		dxDrawRectangle(bgPos.x+bgPos.w*0.15+bgPos.w/2-width-20/zoom, bgPos.y+bgPos.h-60/zoom, width+40/zoom, 40/zoom, tocolor(20, 20, 20, 150), true)
		dxDrawText(text, bgPos.x+bgPos.w*0.225-10/zoom, bgPos.y+bgPos.h-53/zoom, bgPos.x + bgPos.w - 20/zoom, bgPos.y, tocolor(190, 190, 190, 190), 0.6, font, "center", "top", false, false, true, false, false)
	end
end 

function toggleHelpPanel()
	showHelp = not showHelp
	if showHelp then 
		font = dxCreateFont("archivo_narrow.ttf", 23/zoom, false, "antialiased") or "default-bold"
		addEventHandler("onClientRender", root, renderHelpPanel)
		addEventHandler("onClientKey", root, clickHelpPanel)
		showCursor(true)
		
		selectedTab = 1
		selectedPage = 1
	else 
		if isElement(font) then 
			destroyElement(font)
		end
		removeEventHandler("onClientRender", root, renderHelpPanel)
		removeEventHandler("onClientKey", root, clickHelpPanel)
		showCursor(false)
	end
end 
bindKey("f9", "down", toggleHelpPanel)

function onClientResourceStop()
	if showHelp then 
		toggleHelpPanel()
	end
end 
addEventHandler("onClientResourceStop", resourceRoot, onClientResourceStop)

function isCursorOnElement(x,y,w,h)
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end