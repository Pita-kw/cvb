function CFireworks()
	local object = {};
	
	function object:getPositionInfrontOfElement ( element , meters )
		if not element or not isElement ( element ) then
			return false
		end
		
		if not meters then
			meters = 0.7
		end
		local posX , posY , posZ = getElementPosition ( element )
		local _ , _ , rotation = getElementRotation ( element )
		posX = posX - math.sin ( math.rad ( rotation ) ) * meters
		posY = posY + math.cos ( math.rad ( rotation ) ) * meters
		return posX , posY , posZ, rotation	
	end
	
	function object:boomParticle(x,y,z,r,g,b,move)
		local object=createObject(327,x,y,z);
		setElementAlpha(object,0);
		local marker=createMarker(0,0,0,"corona",3,r,g,b,200);
		attachElements(marker,object);
		if move then
			moveObject(object,math.random(5000,10000)/2,x+math.random(-100,100),y+math.random(-100,100),z+math.random(-100,100),0,0,0,"OutQuad");
		else
			moveObject(object,math.random(1000,10000)/2,x+math.random(-30,30),y+math.random(-30,30),z+math.random(-30,30),0,0,0,"Linear");
		end
		setElementData(marker,"bParticle",object);
		setElementData(marker,"bMove", move);
	end
	
	setTimer(
		function()
			for k,v in ipairs(getElementsByType("marker"))do
				if(getElementData(v,"bParticle"))then
					local r,g,b,alpha=getMarkerColor(v)
					setElementAlpha(v,math.max(0,alpha-20))
					local bParticle=getElementData(v,"bParticle")
					local x,y,z=getElementPosition(bParticle)
					if getElementData(v, "bMove") then
						setElementPosition(bParticle,x,y,z-1.5)
					end
					if(alpha==0)then
						destroyElement(bParticle)
						destroyElement(v)
					end
				end
			end
		end
	,200,0);
	
	function object:rakieta(player, cmd, typ)
		if player and cmd then
			if getElementData(player, "rakieta") then triggerClientEvent(player, "onClientAddNotification", player, "Spróbuj ponownie za 4 sekundy", "error") return; end
			setElementData(player, "rakieta", true);
			setTimer(setElementData, 6000, 1, player, "rakieta", false);
			
			local x,y,z = getElementPosition(player);
			local object = createObject(1636, x+0.3, y, z-0.2, 90, 0, 0);
			setElementCollisionsEnabled(object, false);
			setTimer(
				function()
					local sparks = createObject(2046, x, y, z, 0, 0, 0);
					local smoke = createObject(2044, x, y, z, 0, 0, 0);
					attachElements(sparks, object);
					attachElements(smoke, object);
						
					local move = moveObject(object, 2500, x, y, z + math.random(30, 50), 0, 0, 0, "InQuad");
					triggerClientEvent(root, "firework:onRocketShot", root, object);
					setTimer(
						function()
							triggerClientEvent(root, "firework:onRocketBoom", root, object);
							x,y,z = getElementPosition(object);
								
							destroyElement(object);
							destroyElement(sparks);
							destroyElement(smoke);
								
							-- efekty
							local colorTable = {};
							colorTable.r, colorTable.g, colorTable.b = 0;
							
							local rand = math.random(1,9)
									if rand == 1 then
										colorTable.r, colorTable.g, colorTable.b = 244, 66, 66;
									elseif rand == 2 then
										colorTable.r, colorTable.g, colorTable.b = 244, 173, 66;
									elseif rand == 3 then
										colorTable.r, colorTable.g, colorTable.b = 255, 246, 0;
									elseif rand == 4 then
										colorTable.r, colorTable.g, colorTable.b = 0, 255, 0;
									elseif rand == 5 then
										colorTable.r, colorTable.g, colorTable.b = 118, 255, 0;
									elseif rand == 6 then
										colorTable.r, colorTable.g, colorTable.b = 0, 255, 225;
									elseif rand == 7 then
										colorTable.r, colorTable.g, colorTable.b = 0, 165, 255;
									elseif rand == 8 then
										colorTable.r, colorTable.g, colorTable.b = 187, 0, 255;
									elseif rand == 9 then
										colorTable.r, colorTable.g, colorTable.b = 255, 0, 203;
									end
								
							for i=0, math.random(8, 32) do
								self:boomParticle(x, y, z, colorTable.r, colorTable.g, colorTable.b, true);
							end
								
							setTimer(
								function()
									local rand = math.random(1,9)
									if rand == 1 then
										colorTable.r, colorTable.g, colorTable.b = 244, 66, 66;
									elseif rand == 2 then
										colorTable.r, colorTable.g, colorTable.b = 244, 173, 66;
									elseif rand == 3 then
										colorTable.r, colorTable.g, colorTable.b = 255, 246, 0;
									elseif rand == 4 then
										colorTable.r, colorTable.g, colorTable.b = 0, 255, 0;
									elseif rand == 5 then
										colorTable.r, colorTable.g, colorTable.b = 118, 255, 0;
									elseif rand == 6 then
										colorTable.r, colorTable.g, colorTable.b = 0, 255, 225;
									elseif rand == 7 then
										colorTable.r, colorTable.g, colorTable.b = 0, 165, 255;
									elseif rand == 8 then
										colorTable.r, colorTable.g, colorTable.b = 187, 0, 255;
									elseif rand == 9 then
										colorTable.r, colorTable.g, colorTable.b = 255, 0, 203;
									end
									
									for i=0, math.random(16, 32) do
										self:boomParticle(x, y, z, colorTable.r, colorTable.g, colorTable.b, false);
									end
								end, 900, 1);
									
						end, 2500, 1);
							
				end, 5000, 1);
			end
	end
	addCommandHandler("rakieta", function(a, b) object:rakieta(a, b); end);
	
	function object:fontanna(player, cmd)
		local x,y,z = getElementPosition(player);
		if getElementData(player, "fontanna") then triggerClientEvent(player, "onClientAddNotification", player, "Spróbuj ponownie za 4 sekundy", "error") return; end
		local obj = createObject(1328, x+0.5, y, z-1, 0, 0, 0);
		setElementData(player, "fontanna", true);
		setTimer(setElementData, 4000, 1, player, "fontanna", false);
		
		setTimer(
			function()
				local spark = createObject(2047, x+0.5, y, z-0.8, 0, 0, 0);
				local spark2 = createObject(2046, x+0.5, y, z-0.8, 0, 0, 0);
				local spark3 = createObject(2047, x+0.5, y, z-0.2, 0, 0, 0);
				setObjectScale(spark, 1.2);
				setObjectScale(spark2, 1.2);
				setObjectScale(spark3, 1.3);
				triggerClientEvent(root, "firework:onFountain", root, obj);
				local smoke;
				setTimer(function() smoke = createObject(2044, x, y, z, 0, 0, 0); end, 8800, 1); 
				setTimer(
					function()
						destroyElement(spark);
						destroyElement(spark2);
						destroyElement(spark3);
						setTimer(destroyElement, 2000, 1, smoke);
						setTimer(destroyElement, 3000, 1, obj);
					end, 9500, 1);
				
			end, 3000, 1);
	end
	addCommandHandler("fontanna", function(a, b) object:fontanna(a, b); end);
	
	function object:fajerwerkiHelp(player)
		triggerClientEvent(player, "onClientAddNotification", player, "Dostępne fajerwerki:\n/rakieta\n/fontanna", "info")
	end
	addCommandHandler("fajerwerki", function(a) object:fajerwerkiHelp(a); end);

	return object;
end
CFireworks();
for k,v in ipairs(getElementsByType("player")) do 
	setElementData(v, "rakieta", false)
end