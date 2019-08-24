--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: s.lua
	@desc: minieventy 
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
	
]]


local answer = false
local event_id = false
local challange_id = false

local MINIEVENT_MONEY = 1000
local MINIEVENT_EXP = 10

local scrabble_words = {
	"Robak",
	"Rodzina",
	"Apteczka",
	"Romans",
	"Ratownik",
	"Ropucha",
	"Rosiczka",
	"Roślina",
	"Rosja",
	"Zapach",
	"Smród",
	"Zając",
	"Papuga",
	"Dowód",
	"Policja",
	"Zwierzęta",
	"Kierowca",
	"Kaktus",
	"Włócznia",
	"Niebieski",
	"Pomarańczowy",
	"Czerwony",
	"Zielony",
	"Żółty",
	"Różowy",
	"Fioletowy",
	"Turkusowy",
	"Kuweta",
	"Księżniczka",
	"Samolot",
	"Helikopter",
	"Lotnisko",
	"Bagażnik",
	"Silnik",
	"Bateria",
	"Monitor",
	"Krajobraz",
	"Kolorystyka",
	"Murarz",
	"Nauczyciel",
	"Sprzątaczka",
	"Lekarz",
	"Pianista",
	"Kelner",
	"Mechanik",
	"Kucharz",
	"Listonosz",
	"Urzędnik",
	"Weterynarz",
	"Dentysta",
	"Informatyk",
	"Modelka",
	"Pisarz",
	"Sprzedawca",
	"Piosenkarz",
	"Fryzjer",
	"Pralka",
	"Zmywarka",
	"Odkurzacz",
	"Dywan",
	"Grzebień",
	"Kosmetyki",
	"Lustro",
	"Perfumy",
	"Prysznic",
	"Szampon",
	"Tapeta",
	"Umywalka",
	"Drukarka",
	"Fotel",
	"Grzejnik",
	"Kwiatki",
	"Poduszka",
	"Serwerka",
	"Sypialnia",
	"Szafa",
	"Wazon",
	"Czajnik",
	"Garnek",
	"Gofrownica",
	"Kieliszek",
	"Krzesło",
	"Kuchenka",
	"Łyżeczka",
	"Mikser",
	"Miseczka",
	"Patelnia",
	"Stolik",
	"Szklanka",
	"Talerz",
	"Termos",
	"Widelec",
	"Akwarium",
	"Atlas",
	"Kastea",
	"Maskotka",
	"Komputer", 
	"Zupa", 
	"Szafka", 
	"Lodówka",
	"Mikrofon",
	"Czapka",
	"Święta",
	"Monitor",
	"Kamera",
	"Multiplayer",
	"Schabowy",
	"Elektronika",
	"Telewizor",
	"Konsola",
	"Płyta",
	"Rzodkiewka",
	"Marchewka",
	"Folder",
	"Korniszon",
	"Gracz",
	"Windows",
	"Linux",
	"Przeglądarka",
	"Słuchawki",
	"Portfel",
	"Skarbonka",
	"Ksiądz",
	"Kościół",
	"Papież",
	"Pielgrzymka",
	"Muzyka",
	"Karaoke",
	"Śledź",
	"Obrazek",
	"Zdjęcie",
	"Dywan",
	"Chemia",
	"Biologia",
	"Historia",
	"Laptop",
	"Światło",
	"Lampka",
	"Sylwestra",
	"Mieszkanie",
	"Miasto",
	"Wioska",
	"Kilometry",
	"Mapa",
	"Łódź",
	"Pojazd",
	"Auto",
	"Prawo",
	"Kasyno",
	"Pieniądze",
	"Autobus",
	"Dworzec"	
}

local quiz_questions = {
	{question = "W jakiej wodzie ryby nie pływają?",  answer="gotowanej"},
	{question = "Który miesiąc ma 28 dni?",  answer="każdy"},
	{question = "Co to jest: nie pali się, a trzeba gasić?",  answer="pragnienie"},
	{question = "Kto siedzi tyłem do ministra?",  answer="kierowca"},
	{question = "Które koło najmniej się zużywa na zakrętach?",  answer="zapasowe"},
	{question = "Napisz jak wygląda król z bykiem?",  answer="krul"},
	{question = "Co rośnie do góry korzeniem?",  answer="ząb"},
	{question = "W pokoju stoi lampa naftowa i świeca. Co najpierw zapalisz?",  answer="zapałkę"},
	{question = "Jakich kamieni jest w morzu najwięcej?",  answer="mokrych"},
	{question = "Jak ma na imie Brzysiek?",  answer="krzysztof"},
	{question = "Jak ma na imie Virelox?",  answer="oskar"},
	{question = "Jak się nazywa serwer na którym obecnie grasz?",  answer="multiserver"},
	{question = "W którym roku rozpoczęła się pierwsza wojna światowa?", answer="1914"},
	{question = "W którym roku rozpoczęła się druga wojna światowa?", answer="1939"},
	{question = "Jaki wzór chemiczny ma wapń?", answer="ca"},
	{question = "Jaki wzór chemiczny ma cyna?", answer="sn"},
	{question = "Jaki wzór chemiczny ma wodór?", answer="h"},
	{question = "Jaki wzór chemiczny ma platyna?", answer="pt"},
	{question = "Jaki wzór chemiczny ma srebro?", answer="ag"},
	{question = "O której godzinie zmarł papież Jan Paweł II?", answer="21:37"},
	{question = "Kto jako pierwszy zdradził gang z Grove street?",  answer="Ryder"},
	{question = "Kto jako pierwszy zdradził gang z Grove street?",  answer="Ryder"},
	
	-- Proxiak (28)
	
	{question = "Najpopularniejszy napój w San Andreas?",  answer="Sprunk"},
	{question = "Imię czarnoskórego policjanta aresztującego CJ'a na początku gry?",  answer="Frank"},
	{question = "Jak pseudonim nosi brat CJ'a?",  answer="Sweet"},
	{question = "Jaki skrót ma policja która jezdzi po Los Santos?",  answer="LSPD"},
	{question = "Kto zabił matkę CJ'a?",  answer="Ballasi"},
	{question = "Największy szczyt świata?",  answer="Mount Everest"},
	{question = "Kto polował na trzy świnki?",  answer="Wilk"},
	{question = "Pierwszy koronowany król Polski?",  answer="Bolesław Chrobry"},
	{question = "Mówi się rękami czy ręcami?",  answer="Mówi się ustami"},
	{question = "Ile złotówek jest w tuzinie?",  answer="12"},
	{question = "Jaki wzór ma Bor?",  answer="B"},
	{question = "Jaki wzór ma Hel?",  answer="He"},
	{question = "Jaki wzór ma Potas?",  answer="K"},
	{question = "Jaki wzór ma Lit?",  answer="Li"},
	{question = "Jaki wzór ma Chrom?",  answer="Cr"},
	{question = "Jaki wzór ma Złoto?",  answer="Au"},
	{question = "Jaki wzór ma Miedź?",  answer="Cu"},
	{question = "Jaki wzór ma Selen?",  answer="Se"},
	{question = "Jaki wzór ma Siarka?",  answer="S"},
	{question = "Jaki wzór ma Argon?",  answer="Ar"},
	{question = "Jaki wzór ma Gal?",  answer="Ga"},
	{question = "Jaki wzór ma Krzem?",  answer="Si"},
	{question = "Jaki wzór ma Rad?",  answer="Ra"},
	{question = "Jaki wzór ma Tellur?",  answer="Te"},
	{question = "Jaki wzór ma Jod?",  answer="I"},
	{question = "Jaki wzór ma Rod?",  answer="Rh"},
	{question = "Jaki wzór ma Magnez?",  answer="Mg"},
	{question = "Jaki wzór ma Azot?",  answer="N"},
	{question = "Jaki wzór ma Fluor?",  answer="F"},
	
	
	-- Izza (20)
	

	{question = "Jaka jest stolica Argentyny?", answer="Buenos Aires"},
	{question = "Gdzie odbyły się letnie Igrzyska Olimpijskie w 1912 roku?", answer="Sztokholm"},
	{question = "Gdzie odbyły się letnie Igrzysk Olimpijskie w 1904 roku?", answer="Saint Louis"},
	{question = "Jaka jest najdłuższa rzeka na świecie?", answer="Amazonka"},
	{question = "Kto został prezydentem USA w 1809 roku?", answer="James Madison"},
	{question = "Kto uznawany jest za króla popu?", answer="Michael Jackson"},
	{question = "Jak nazywał się pierwszy pies w kosmosie?", answer="Łajka"},
	{question = "W którym roku Polska dołączyła do Unii Europejskiej?", answer="2004"},
	{question = "Jaka jest stolica Czech?", answer="Praga"},
	{question = "Jaki kraj wygrał Mistrzostwa Europy Piłki Nożnej w 2000 roku?", answer="Francja"},
	{question = "Jaka jest najdłuższa rzeka w Polsce?", answer="Wisła"},
	{question = "Jaki kraj wygrał Mundial w 1982 roku?", answer="Włochy"},
	{question = "Kto założył firmę Microsoft?", answer="Bill Gates"},
	{question = "Jaka jest stolica Danii?", answer="Kopenhaga"},
	{question = "Gdzie odbyły się Zimowe Igrzyska Olimpijskie w 1988 roku?", answer="Calgary"},
	{question = "Jeden z założycieli Platformy Obywatelskiej?", answer="Andrzej Olechowski"},
	{question = "Kto został prezydentem Polski w 1964 roku?", answer="Edward Ochab"},
	{question = "Kto w Polsce dostał Nagrodę Nobla w dziedzinie literatury?", answer="Henryk Sienkiewicz"},
	{question = "Ile mierzy największy szczyt Tatr?", answer="2499m"},
	{question = "Jak nazywa się największy wodospad świata?", answer="Salto Angel"},
	
	-- MysteryX (14)
	
	{question = "Ile w przybliżeniu waży litr chłodnej wody?", answer="Kilogram"},
	{question = "Co jest jednostką masy?", answer="Gram"},
	{question = "Którą planetą od Słońca jest Ziemia?", answer="Trzecią"},
	{question = "Czym jest achromatopsja?", answer="Wadą wzroku"},
	{question = "W którym roku rozegrano pierwsze mistrzostwa świata w piłce nożnej?", answer="1930"},
	{question = "Gdzie znajduje się punkt G w ciele mężczyzny?", answer="W prostacie"},
	{question = "Jak brzmi prawdziwe imię i nazwisko Iron Man'a?", answer="Tony Stark"},
	{question = "W którym roku doszło do katastrofy smoleńskiej?", answer="2010"},
	{question = "Co znaczy po polsku lunatic?", answer="Wariat"},
	{question = "W którym roku Mieszko I przyjął chrześcijaństwo?", answer="966"},
	{question = "Jak ma na imię Sweet?", answer="Brian"},
	{question = "Z jakiego kraju pochodził Hitler?", answer="Austrii"},
	{question = "Jakiego pochodzenia jest oficer Pulaski?", answer="Polskiego"},
	{question = "Co znaczy po polsku novel?", answer="Powieść"},
	{question = "Jakiego koloru jest czerwony maluch?", answer="Czerwonego"}
}

local challanges = {
	{mission = "Kucnij!", time = 5, money = 1000, exp = 5},
	{mission = "Wejdź do wody!", time = 60, money = 2000, exp = 10},
	{mission = "Zabij jednego z graczy!", time = 30, money = 2000, exp = 10},
	{mission = "Ukradnij Greenwood'a z Groove Street i dostarcz do punktu.", time=90, money = 3000, exp = 15},
}


function prepareScrabbleString(string)
	local index = 1
	local string_table = {}
	
	for k=1, #string do 
		local a = utf8.sub(string, index, index)
		table.insert(string_table, a)
		index = index + 1
	end
	
	
	local size, random = #string_table, math.random
	
	for i = size, 2, -1 do
			local j = random( 1, i );
			string_table[i], string_table[j] = string_table[j], string_table[i];
	end
	
	local prepared_string = table.concat(string_table)
	return prepared_string
end


function getRandomString(length)
	length = length or 1
	local array = {}
	
	for i = 1, length do
		array[i] = string.char(math.random(97, 122))
   end
   
    local string = table.concat(array)
    return string
end

function checkPlayersActions()
	if challange_id == 1 then
		triggerClientEvent(root, "checkPlayerCrouch", root)
	end
	
	if challange_id == 2 then
		for k,v in ipairs(getElementsByType("player")) do
			if isElementInWater(v) then
				giveRewardForChallange(v, 2)
				break
			end
		end
	end
end


function checkPlayerKills(ammo, attacker, weapon, bodypart)
	if attacker and challange_id == 3 then
		giveRewardForChallange(attacker, 3)
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), checkPlayerKills )




function prepareMiniEvent()
	if event_id then return end -- Sprawdzamy czy nie nie ma czasem już mini zabawy.
	if #getElementsByType("player") < 4 then return end -- Odpalamy zabawe jeżeli jest 5 graczy.
	
	local random_event = math.random(1, 5)
	
	
	if random_event == 1 then -- przepisz kod
		answer = getRandomString(12)
		event_id = 1
		event_timer = setTimer(endMiniEvent, 30000, 1, 1)
		triggerClientEvent(root, "showMiniEventHUD", root, true, "Przepisz kod", answer, "quiz", false, 30000)
	end
	
	if random_event == 2 then -- scrabble
		local text_id = math.random(1, #scrabble_words)
		answer = scrabble_words[text_id]
		show_text = prepareScrabbleString(scrabble_words[text_id])
		event_id = 2
		event_timer = setTimer(endMiniEvent, 30000, 1, 2)
		triggerClientEvent(root, "showMiniEventHUD", root, true, "Ułóż słowo", show_text, "quiz", false, 30000)
	end
	
	if random_event == 3 then -- matematyka
		local number_a = math.random(1,50)
		local number_b = math.random(1,50)
		
		local math_type = math.random(1, 3)
		
		
		event_id = 3 
		event_timer = setTimer(endMiniEvent, 30000, 1, 3)
		
		if math_type == 1 then
			triggerClientEvent(root, "showMiniEventHUD", root, true, "Rozwiąż równanie", "".. number_a .." + ".. number_b .."", "quiz", false, 30000)
			answer = tostring(number_a + number_b)
		end
		
		if math_type == 2 then
			triggerClientEvent(root, "showMiniEventHUD", root, true, "Rozwiąż równanie", "".. number_a .." - ".. number_b .."", "quiz", false, 30000)
			answer = tostring(number_a - number_b)
		end
		
		if math_type == 3 then
			answer = tostring(number_a * number_b)
			triggerClientEvent(root, "showMiniEventHUD", root, true, "Rozwiąż równanie", "".. number_a .." * ".. number_b .."", "quiz", false, 30000)
		end
		
	end
	
	
	if random_event == 4 then
		local random_qestion = math.random(1, #quiz_questions)
		triggerClientEvent(root, "showMiniEventHUD", root, true, "Quiz", quiz_questions[random_qestion].question, "quiz", false, 30000)
		answer = quiz_questions[random_qestion].answer
		event_id = 4
		event_timer = setTimer(endMiniEvent, 30000, 1, 4)
	end
	
	if random_event == 5 then
		local random_challange = math.random(1, #challanges)
	
		if random_challange == 1 then
			challange_id = 1
			event_check_timer = setTimer(checkPlayersActions, 100, 0)
		end
		
		if random_challange == 2 then
			challange_id = 2
			event_check_timer = setTimer(checkPlayersActions, 100, 0)
		end
		
		if random_challange == 3 then
			challange_id = 3
		end
		
		if random_challange == 4 then
			challange_id = 4
			event_vehicle = createVehicle(492, 2484.22,-1667.03,13.34)
			setElementData(event_vehicle, "vehicle:challange", true)
			vehicle_target = createBlip(2484.22,-1667.03,13.34, 41)
			setElementData(vehicle_target, 'blipIcon', 'vehicle_shop')
			setElementData(vehicle_target, 'exclusiveBlip', true)
			setVehicleDamageProof(event_vehicle, true)
			marker_vehicle = createMarker( 2484.22,-1667.03,13.34, "arrow", 1, 255, 0, 0, 255)
			event_checkpoint = createMarker(2009.77,-1031.53,24.76, "checkpoint", 4, 255, 0, 0, 255)
			attachElements(marker_vehicle, event_vehicle, 0, 0, 2)
			attachElements(vehicle_target, event_vehicle)
			event_target=createBlip(2009.77,-1031.53,24.76, 41)
			setElementData(event_target, 'blipIcon', 'mission_target')
			setElementData(event_target, 'exclusiveBlip', true)
			
			addEventHandler ( "onVehicleEnter", event_vehicle, 
				function() 
					setTimer ( function()
						setVehicleDamageProof(event_vehicle, true)
					end, 1000, 1 )
				end
			)
			
			addEventHandler( "onMarkerHit", event_checkpoint, 
				function(hit, dim) 
					if hit then
						if hit and getElementType(hit) == "player" then
							local vehicle = getPedOccupiedVehicle(hit)
							
							if vehicle == event_vehicle then
								giveRewardForChallange(hit, 4)
								destroyElement(event_vehicle)
								destroyElement(marker_vehicle)
								destroyElement(event_checkpoint)
								destroyElement(vehicle_target)
								destroyElement(event_target)
							end
						end
					end
				end
			)
		end
	
		event_id = 5
		event_timer = setTimer(endMiniEvent, challanges[random_challange].time*1000, 1)
		triggerClientEvent(root, "showMiniEventHUD", root, true, "Wyzwanie", challanges[random_challange].mission, "quiz", false, challanges[random_challange].time*1000)
	end
end
setTimer(prepareMiniEvent, 5*60000, 0)


function endMiniEvent(id)
	if event_id == 5 then
		outputDebugString("Trwa zakończenie eventu")
		
		if challange_id == 1 or challange_id == 2 then
			killTimer(event_check_timer)
		end

		
		if challange_id == 4 then
			destroyElement(event_vehicle)
			destroyElement(marker_vehicle)
			destroyElement(event_checkpoint)
			destroyElement(vehicle_target)
			destroyElement(event_target)
			outputDebugString("Usuwanie danych")
		end
		
		triggerClientEvent(root, "showMiniEventHUD", root, true, "Nikt nie wykonał wyzwania.", "Kolejna zabawa za 5 minut", "bad_answer", 10000)
		triggerClientEvent(root, "playMiniEventSound", root, "wrong")
		challange_id = false
		
	else
		triggerClientEvent(root, "showMiniEventHUD", root, true, "Nikt nie podał poprawnej odpowiedzi!", "Kolejna zabawa za 5 minut", "bad_answer", 10000)
		triggerClientEvent(root, "playMiniEventSound", root, "wrong")
	end
	
	event_id = false
	answer = false
end

function checkAnswer(message)
	if event_id and event_id < 5 then
		if string.lower(message) == string.lower(answer) then
			triggerClientEvent(root, "showMiniEventHUD", root, true, "Poprawna odpowiedź!", "".. getPlayerName(source) .." podał poprawną odpowiedź!", "good_answer", 10000, false, source)
			triggerClientEvent(root, "playMiniEventSound", root, "good")
			answer = false
			event_id = false
			killTimer(event_timer)
			exports["ms-gameplay"]:msGiveMoney(source, MINIEVENT_MONEY)
			exports["ms-gameplay"]:msGiveExp(source, MINIEVENT_EXP)
			if getElementData(source, "player:premium") then
				triggerClientEvent(source, "onClientAddNotification", source, "Podałeś prawidłową odpowiedź! W nagrodę otrzymujesz 1300$ oraz 13 exp.", "success")
			else
				triggerClientEvent(source, "onClientAddNotification", source, "Podałeś prawidłową odpowiedź! W nagrodę otrzymujesz 1000$ oraz 10 exp.", "success")
			end
		end
	end
end
addEventHandler( "onPlayerChat", getRootElement(), checkAnswer )


function giveRewardForChallange(player, id)	

	exports["ms-gameplay"]:msGiveMoney(player, challanges[id].money)
	exports["ms-gameplay"]:msGiveExp(player, challanges[id].exp)
	
	triggerClientEvent(root, "showMiniEventHUD", root, true, "Wyzwanie ukończone!", "".. getPlayerName(player) .." jako pierwszy ukończył wyzwanie!", "good_answer", 10000, false, player)
	triggerClientEvent(root, "playMiniEventSound", root, "good")
	
	if getElementData(player, "player:premium") then
		triggerClientEvent(player, "onClientAddNotification", player, "Wykonałeś wyzwanie jako pierwszy! W nagrodę otrzymujesz ".. tostring(math.floor(challanges[challange_id].money + challanges[challange_id].money * 0.3)) .." oraz ".. tostring(math.floor(challanges[challange_id].exp + challanges[challange_id].exp * 0.3)) ..".", "success")
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Wykonałeś wyzwanie jako pierwszy! W nagrodę otrzymujesz ".. tostring(challanges[challange_id].money) .." oraz ".. tostring(challanges[challange_id].exp) .." exp.", "success")
	end
	
	if isTimer(event_timer) then killTimer(event_timer) end
	if isTimer(event_check_timer) then killTimer(event_check_timer) end
	
	event_id = false
	challange_id = false
end
addEvent("giveRewardForChallange", true)
addEventHandler("giveRewardForChallange", getRootElement(), giveRewardForChallange)

