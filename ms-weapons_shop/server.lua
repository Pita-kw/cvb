addEvent("giveWeaponFromShop", true)

function giveWeaponFromShop(player, id, ammo, cost)
	giveWeapon(player, id, ammo, true)
	
	if cost then
		exports["ms-gameplay"]:msTakeMoney(player, cost)
	end
end
addEventHandler("giveWeaponFromShop", getRootElement(), giveWeaponFromShop)

