-- lista jest też używana w dashboardzie :P
-- ["Nazwa osiągnięcia"] = {obrazek, exp, kasa, opis}
gAchievements =
{
	["Pierwsza krew"] = {"i/icons/pierwsza_krew.png", 5, 500, "Zostań uderzony przez jakiegoś gracza"},  -- OK
	["Pierwszy zgon"] = {"i/icons/pierwszy_zgon.png", 5, 500, "Zostań zabity przez jakiegoś gracza"}, -- OK
	["Bez pracy nie ma kołaczy"] = {"i/icons/pierwsza_praca.png", 5, 500, "Podejmij się jednej z prac"}, -- OK
	["Zabójca I"] = {"i/icons/zabojca_1.png", 10, 1000, "Zabij łacznie 100 graczy"}, -- OK 
	["Zabójca II"] = {"i/icons/zabojca_2.png", 50, 5000, "Zabij łącznie 500 graczy"}, -- OK
	["Zabójca III"] = {"i/icons/zabojca_3.png", 100, 10000, "Zabij łacznie 1000 graczy"}, -- OK
	["Zboczeniec"] = {"i/icons/zboczeniec.png", 5, 500, "Udobruchaj Barabasza"}, -- Animacji ni ma :/
	["Moje pierwsze auto"] = {"i/icons/pierwszy_pojazd.png", 10, 1000, "Kup jakiś pojazd"}, -- OK
	["Mój pierwszy dom"] = {"i/icons/pierwszy_dom.png", 10, 1000, "Kup dom"}, -- OK
	["Szpan musi być"] = {"i/icons/szpan.png", 5, 500, "Stuninguj swój pojazd"}, -- OK
	["Architekt"] = {"i/icons/architekt.png", 5, 500, "Kup mebel do mieszkania"}, -- OK
	["Pedancik"] = {"i/icons/pedancik.png", 5, 500, "Umyj swój pojazd"}, -- OK
	["Ćpun"] = {"i/icons/cpun.png", 5, 500, "Zażyj jeden z narkotyków"}, -- NI ma systemu narkotyków ale jak bedzi to si doda ino roz!
	["Alkoholik"] = {"i/icons/alkoholik.png", 5,  500, "Napij się alkoholu"}, -- Tego też nimo :/
	["Pracoholik I"] = {"i/icons/pracoholik_1.png", 25, 2500, "Wykonaj 50 razy jakąś pracę"}, -- OK
	["Pracoholik II"] = {"i/icons/pracoholik_2.png", 50, 5000,  "Wykonaj 100 razy jakąś pracę"}, -- OK
	["Pracoholik III"] = {"i/icons/pracoholik_3.png", 100, 10000, "Wykonaj 250 razy jakąś pracę"}, -- OK
	["Biznesman I"] = {"i/icons/biznesman_1.png", 10, 1000, "Zgromadź na koncie bankowym $100000"}, -- OK
	["Biznesman II"] = {"i/icons/biznesman_2.png", 25, 2500, "Zgromadź na koncie bakowym $250000"}, -- OK
	["Biznesman III"] = {"i/icons/biznesman_3.png", 50, 5000, "Zgromadź na koncie bankowym $500000"}, -- OK
	["Milioner"] = {"i/icons/milioner.png", 100, 10000, "Zgromadź na koncie bankowym $1000000"}, --- OK
	["Mistrz Onede"] = {"i/icons/mistrz_areny.png", 100, 10000, "Zabij 1000 graczy na Onede"}, -- OK
	["Mistrz Sniper"] = {"i/icons/mistrz_areny.png", 100, 10000, "Zabij 1000 graczy na Sniper"}, -- OK
	["Mistrz Bazooka"] = {"i/icons/mistrz_areny.png", 100, 10000, "Zabij 1000 graczy na Bazooka"}, -- OK
	["Mistrz Minigun"] = {"i/icons/mistrz_areny.png", 100, 10000, "Zabij 1000 graczy na Minigun"}, -- OK
	["Mistrz Dust"] = {"i/icons/mistrz_areny.png", 100, 10000, "Zabij 1000 graczy na Dust"}, -- OK
	["Samobójca"] = {"i/icons/samobojca.png", 25, 2500, "Zgiń 100 razy"}, -- OK
	["Nocny gracz"] = {"i/icons/samobojca.png", 50, 5000, "Graj na serwerze pomiędzy 3-5 rano na serwerze"} ,-- OK
	["Snajper"] = {"i/icons/samobojca.png", 25, 2500, "Zabij gracza ze snajperki w odległości co najmniej 25m"}, -- OK
	["Ninja"] = {"i/icons/samobojca.png", 25, 2500, "Zabij gracza podcinając mu gardło"}, -- OK
	["Farciarz"] = {"i/icons/samobojca.png", 25, 2500, "Zabij mając mniej niż 5 HP"} ,-- OK
	["Zombie Killer"] = {"i/icons/samobojca.png", 50, 5000, "Zabij 500 zombie"} -- OK
}

function getAchievementTable()
	return gAchievements
end
