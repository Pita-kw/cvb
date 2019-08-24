local ring = false
local ring2 = false
local colshape_ring = false
local colshape_ring2 = false
local ring_player = false
local ring2_player = false
local fight = false
local seciure_col = false
local seciure_timer= false

function createRings(destroy)
	if destroy then
		destroyElement(ring)
		destroyElement(ring2)
		destroyElement(colshape_ring)
		destroyElement(colshape_ring2)
	else
		ring = createMarker(2138.58,990.60,1038.87-1, "cylinder", 1, 255, 0, 0, 255)
		colshape_ring = createColSphere(2138.58,990.60,1038.87, 1)
		addEventHandler ( "onColShapeHit", colshape_ring, 
			function(hit, dim)
				if getElementType(hit) ~= "player" then return end
				ring_player = hit
				setElementModel(hit, 80)
			end
		)
		addEventHandler ( "onColShapeLeave", colshape_ring, 
			function(hit, dim)
				if getElementType(hit) ~= "player" then return end
				--ring_player = false
				setElementModel(hit, getElementData(hit, "player:skin"))
			end
		)
		ring2 = createMarker(2142.72,994.80,1038.87-1, "cylinder", 1, 255, 0, 0, 255)
		colshape_ring2 = createColSphere(2142.72,994.80,1038.87, 1)
		addEventHandler ( "onColShapeHit", colshape_ring2, 
			function(hit, dim)
				if getElementType(hit) ~= "player" then return end
				ring2_player = hit
				setElementModel(hit, 80)
			end
		)
		addEventHandler ( "onColShapeLeave", colshape_ring2, 
			function(hit, dim)
				if getElementType(hit) ~= "player" then return end
				--ring2_player = false
				setElementModel(hit, getElementData(hit, "player:skin"))
			end
		)
	end
end
addEventHandler("onResourceStart", resourceRoot, 
	function()
		createRings(false)
	end
)


function checkPlayersInRings()	
	if ring_player and ring2_player and not fight then
		createRings(true)
		triggerClientEvent(ring_player, "onClientShowCountdown", ring_player)
		triggerClientEvent(ring2_player, "onClientShowCountdown", ring2_player)
		triggerClientEvent(root, "sendFightingPlayers", ring_player, ring_player, ring2_player)
		setElementFrozen(ring_player, true)
		setElementFrozen(ring2_player, true)
		setElementHealth(ring_player, 50)
		setElementHealth(ring2_player, 50)
		takeAllWeapons(ring_player)
		takeAllWeapons(ring2_player)
		setElementPosition(ring_player, 2138.58,990.60,1038.87)
		setElementPosition(ring2_player, 2142.72,994.80,1038.87)
		setTimer(fightStart, 5000, 1)
		fight = true
	end
end
setTimer(checkPlayersInRings, 1000, 0)

function fightStop(hit, dim)
	if hit == ring_player then
		triggerClientEvent(ring2_player, "onClientAddNotification", ring2_player, "Wygrałeś walkę!", "success")
		setElementModel(ring2_player, getElementData(ring2_player, "player:skin"))
		setElementModel(ring_player, getElementData(ring_player, "player:skin"))
		triggerEvent("giveLevelWeapons", ring2_player, ring2_player)
		triggerEvent("giveLevelWeapons", ring_player, ring2_player)
		triggerClientEvent(ring_player, "onClientAddNotification", ring_player, "Przegrałes walkę!", "error")	
	end
	
	if hit == ring2_player then
		triggerClientEvent(ring_player, "onClientAddNotification", ring_player, "Wygrałeś walkę!", "success")
		setElementModel(ring2_player, getElementData(ring2_player, "player:skin"))
		setElementModel(ring_player, getElementData(ring_player, "player:skin"))
		triggerEvent("giveLevelWeapons", ring2_player, ring2_player)
		triggerEvent("giveLevelWeapons", ring_player, ring2_player)
		triggerClientEvent(ring2_player, "onClientAddNotification", ring2_player, "Przegrałeś walkę!", "error")	
	end
	
	ring_player = false
	ring2_player = false
	fight = false
	createRings(false)
	killTimer(seciure_timer)
end

function fightStart()
	setElementFrozen(ring_player, false)
	setElementFrozen(ring2_player, false)
	triggerClientEvent(ring_player, "onClientAddNotification", ring_player, "Walcz!", "info")
	triggerClientEvent(ring2_player, "onClientAddNotification", ring2_player, "Walcz!", "info")
	seciure_col = createColSphere(2140.55,992.67,1038.87, 5)
	seciure_timer = setTimer(getPlayersOnRing, 1000, 0)
	addEventHandler("onColShapeLeave", seciure_col, fightStop)
end


function onPlayerDeadOnRing()
	if fight then
		outputDebugString("Walka jest")
		if source == ring_player or ring2_player then
			outputDebugString("Gracze znalezieni")
			if source == ring_player then
				triggerClientEvent(ring2_player, "onClientAddNotification", ring2_player, "Wygrałeś walkę!", "success")
				setElementModel(ring2_player, getElementData(ring2_player, "player:skin"))
				triggerEvent("giveLevelWeapons", ring2_player, ring2_player)
				triggerClientEvent(ring_player, "onClientAddNotification", ring_player, "Przegrałes walkę!", "error")
			end
			
			if source == ring2_player then
				triggerClientEvent(ring_player, "onClientAddNotification", ring_player, "Wygrałeś walkę!", "success")
				triggerEvent("giveLevelWeapons", ring_player, ring_player)
				setElementModel(ring2_player, getElementData(ring_player, "player:skin"))
				triggerClientEvent(ring2_player, "onClientAddNotification", ring2_player, "Przegrałeś walkę!", "error")
			end
	
	
			ring_player = false
			ring2_player = false
			fight = false
			createRings(false)
			killTimer(seciure_timer)
		end
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerDeadOnRing )


function getPlayersOnRing()
	if fight then
		local players = getElementsWithinColShape(seciure_col, "player")
		
		for k,v in ipairs(players) do
			if v ~= ring_player and v ~= ring2_player then
				setElementPosition(v, 2140.55,986.32,1037.96)
				triggerClientEvent(v, "onClientAddNotification", v, "Nie przeszkadzaj!", "error")
			end
		end
	end
end


