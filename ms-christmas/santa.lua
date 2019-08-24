local santas = {
	{ -2349.50,-1632.41,489.03, 266, "ped", "SEAT_idle"},
	{-2322.82,-1597.74,485.32, 179, "DANCING", "DAN_left_A"}
}


function loadSanta()
	engineImportTXD(engineLoadTXD("santa.txd"), 239)
	engineReplaceModel(engineLoadDFF("santa.dff"), 239)
	
	for k,v in ipairs(santas) do
		local santa = createPed(239, v[1], v[2], v[3], v[4])
		setPedAnimation(santa, v[5], v[6], 1, true, false, true, true)
		setElementFrozen(santa, true)
		setElementData(santa, "ped:anims", {v[5], v[6]})
		addEventHandler("onClientPedDamage", santa, onSantaDamage)
	end
end 
addEventHandler("onClientResourceStart", resourceRoot, loadSanta)

function onSantaDamage(attacker, weapon, bodypart, loss, anim, anim_lib)
	local anims = getElementData(source, "ped:anims")
	setPedAnimation(source, anims[1], anims[2], 1, true, false, true, true)
	cancelEvent()
end