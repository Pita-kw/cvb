--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com>
	@filename: music_s.lua
	@desc: lista piosenek, funkcje
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]


addEvent("playAttractionMusic", true)
addEvent("stopAttractionMusic", true)

music = {
	["race"] = {
		{2}, -- losowe id
		{"Europe", "The Final Countdown", "http://multiserver.pl/audio/race/etfc.mp3"},
		{"Genetikk", "Wünsch dir was", "http://multiserver.pl/audio/race/gwdw.mp3"},
		{"Dimenstion", "Move Faster", "http://multiserver.pl/audio/race/dmf.mp3"},
		{"Louis Berry", "25 Reasons", "http://multiserver.pl/audio/race/lb25r.mp3"},
		{"The Wyld", "Odyssey", "http://multiserver.pl/audio/race/two.mp3"},
		{"Riff Raff", "Kokayne", "http://multiserver.pl/audio/race/rrk.mp3"},
		{"Zeds Dead", "Blink", "http://multiserver.pl/audio/race/zdb.mp3"},
		{"Cartridge", "The Chase", "http://multiserver.pl/audio/race/ctc.mp3"},
		{"Paul Linford and Chris Vrenna", "The Mann", "http://multiserver.pl/audio/race/plac.mp3"},
		{"Celldweller", "Shapeshifter ft. Styles Of Beyond", "http://multiserver.pl/audio/race/css.mp3"},
		{"Rock", "I'm rock", "http://multiserver.pl/audio/race/rir.mp3"},
		{"Burnout Revenge", "Apocalyptica", "http://multiserver.pl/audio/race/brsa.mp3"},
		{"Capone", "I Need Speed", "http://multiserver.pl/audio/race/cins.mp3"},
		{"Chingy", "I do", "http://multiserver.pl/audio/race/ido.mp3"},
		{"X-Zibit", "LAX", "http://multiserver.pl/audio/race/xzl.mp3"},
		{"Rise Against", "Give It All", "http://multiserver.pl/audio/race/ragi.mp3"},
		{"Skindred", "Nobody", "http://multiserver.pl/audio/race/sdn.mp3"},
		{"Skrillex & Rick Ross", "Purple Lamborghini", "http://multiserver.pl/audio/race/srr.mp3"},
	},
	
	["war"] = {
		{2}, -- losowe id
		{"Cod", "Boneyard Fly By", "http://multiserver.pl/audio/war/cod_mw2.mp3"},
		{"Cod", "Burning Heliride", "http://multiserver.pl/audio/war/cod_bh.mp3"},
		{"Cod", "End Credits", "http://multiserver.pl/audio/war/cod_ec.mp3"},
		{"Cod", "Going Loud", "http://multiserver.pl/audio/war/cod_gl.mp3"},
		{"Cod", "Cliffhanger Escape", "http://multiserver.pl/audio/war/cod_ce.mp3"}	
	},
	
	["derby"] = {
		{2}, -- losowe id 
		{"The Chelsea Smiles", "Nowhere Ride", "http://multiserver.pl/audio/derby/tcsnr.mp3"},
		{"Alkaline Trio", "Fall Victim", "http://multiserver.pl/audio/derby/atfv.mp3"},
		{"Alkaline Trio", "Mercy Me", "http://multiserver.pl/audio/derby/atmm.mp3"},
		{"Nickelback", "Believe It of Not", "http://multiserver.pl/audio/derby/nbion.mp3"},
		{"Zebrahead", "Lobotomy For Dummies", "http://multiserver.pl/audio/derby/lbfd.mp3"},
		{"Rise Against", "Give It All", "http://multiserver.pl/audio/derby/ragia.mp3"},
		{"Fall Out Boy", "7 Minutes In Heaven", "http://multiserver.pl/audio/derby/fob7.mp3"},
		{"Nickelback", "Flat On The Floor", "http://multiserver.pl/audio/derby/nfo.mp3"},
		{"Rob Zombie", "Feel So Numb", "http://multiserver.pl/audio/derby/rzfs.mp3"},
		{"Rob Zombie", "Demon Speeding", "http://multiserver.pl/audio/derby/rzds.mp3"},
		{"Fall Out Boy", "Snitches and Talkers", "http://multiserver.pl/audio/derby/fobsa.mp3"},
		{"The Vines", "Don't Listen To The Radio", "http://multiserver.pl/audio/derby/tvdl.mp3"},
		{"AudioSlave", "Man or Animal", "http://multiserver.pl/audio/derby/amoa.mp3"},
		{"Mötley Crüe", "Dr. Feelgood", "http://multiserver.pl/audio/derby/mcdf.mp3"}
	},
	
	["fun"] = {
		{2}, -- losowe id
		{"Kevin MacLeod", "Jaunty Gumption", "http://multiserver.pl/audio/fun/kmjg.mp3"},
		{"YouTube", "Cartoon Hoedown", "http://multiserver.pl/audio/fun/ych.mp3"},
		{"Kevin MacLeod", "Quirky Dog", "http://multiserver.pl/audio/fun/kmqd.mp3"},
		{"Kevin MacLeod", "Hidden Agenda", "http://multiserver.pl/audio/fun/kmha.mp3"},
		{"Kevin MacLeod", "Fenster's Explanation", "http://multiserver.pl/audio/fun/kmfe.mp3"},
		{"Kevin MacLeod", "Scheming Weasel", "http://multiserver.pl/audio/fun/kmsw.mp3"},
		{"Kevin MacLeod", "Run Amok", "http://multiserver.pl/audio/fun/kmra.mp3"},
		{"Kevin MacLeod", "Fluffing a Duck", "http://multiserver.pl/audio/fun/kmfad.mp3"},
		{"Kevin MacLeod", "Sneaky Snitch", "http://multiserver.pl/audio/fun/kmss.mp3"},
		{"Kevin MacLeod", "The Builder", "http://multiserver.pl/audio/fun/kmtb.mp3"},
		{"Kevin MacLeod", "Brightly Fancy", "http://multiserver.pl/audio/fun/kmbf.mp3"},
		{"Coffe Stains", "Riot", "http://multiserver.pl/audio/fun/csr.mp3"},
		{"Kevin MacLeod", "Gaslamp Funworks", "http://multiserver.pl/audio/fun/kmgf.mp3"},
		{"Kevin MacLeod", " Monkeys Spinning Monkeys", "http://multiserver.pl/audio/fun/kmmsm.mp3"},
		{"Afric Simone", "Ramaya", "http://multiserver.pl/audio/fun/asr.mp3"}
	},
}


function generateMusicID()
	music["race"][1][1] = math.random(2, #music["race"])
	music["war"][1][1] = math.random(2, #music["war"])
	music["derby"][1][1] = math.random(2, #music["derby"])
	music["fun"][1][1] = math.random(2, #music["fun"])
end
generateMusicID()
setTimer(generateMusicID,60000,0)

function playAttractionMusic(player, category, song_name)
	if player and song_name and music[category] then
		for k,v in ipairs(music[category]) do
			if song_name == v[2] then
				triggerClientEvent(player, "playMusic", player, v[3], category)
				triggerClientEvent(player, "onClientAddNotification", player, "Wykonawca: "..v[1] .."\nTytuł: "..v[2] .."", "info")
				--outputChatBox("Gracz ".. getPlayerName(player) .." słucha piosenki "..v[2] .." ")
			end
		end		
	else
		song_id = music[category][1][1]
		triggerClientEvent(player, "onClientAddNotification", player, "Wykonawca: ".. music[category][song_id][1] .."\nTytuł: ".. music[category][song_id][2] .."", "info")
		triggerClientEvent(player, "playMusic", player, music[category][song_id][3], category)
		--outputChatBox("Gracz ".. getPlayerName(player) .." słucha piosenki ".. music[category][song_id][2] .." ")
	end
end
addEventHandler("playAttractionMusic", root, playAttractionMusic)

function stopAttractionMusic(player)
	triggerClientEvent(player, "stopMusic", player)
end
addEventHandler("stopAttractionMusic", root, stopAttractionMusic)
