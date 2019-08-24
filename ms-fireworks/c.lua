local function mathSin(s)
	return math.max(0.5, math.sin(s))*1.5
end 

function CFireworks()
	local object = {};
	
	object.rockets = {};
	object.newYearTimestamp = 1483228800;
	
	function object:formatDate(d) -- Konwersja sekundy -> dni, godziny, minuty, sekundy
		h = math.floor(d / 3600);
		m = math.floor(d % 3600 / 60);
		s = math.floor(d % 3600 % 60);
		if #tostring(h) < 2 then
			h = "0"..tostring(h);
		elseif #tostring(m) < 2 then
			m = "0"..tostring(m);
		elseif #tostring(s) < 2 then
			s = "0"..tostring(s);
		end
		return h, m, s;
	end
	
	function object:newYearText()
		if not getElementData(localPlayer, "player:spawned") then return end 
		
		local realTimestamp = getRealTime().timestamp;
		local txt = ""
		if (self.newYearTimestamp-realTimestamp) <= 0 then
			txt = "Szczęśliwego nowego roku życzy multiserver.pl!\n/fajerwerki";
		else
			local h, m, s = self:formatDate(self.newYearTimestamp - realTimestamp);
			txt = "Do nowego roku pozostało: "..tostring(h).." h "..tostring(m).." min "..tostring(s).." s\n/fajerwerki";
		end
		
		local x, y, w, h = exports["ms-attractions"]:getInterfacePosition()
        dxDrawBorderedText(txt, x, y-50, x+w, h, tocolor(52, 180, 219, 255), 1, "default-bold", "right", "top", false, false, true, false, false);
	end
	addEventHandler("onClientHUDRender", root, function() object:newYearText(); end);
	
	function object:addRocket(obj)
		local x,y,z = getElementPosition(obj);
		local snd = playSound3D("sounds/launch.mp3", x, y, z, false);
		setSoundMaxDistance(snd, 100);
		setSoundVolume(snd, 1);	
	end
	addEvent("firework:onRocketShot", true);
	addEventHandler("firework:onRocketShot", root, function(a) object:addRocket(a); end);
	
	function object:rocketBoom(obj)
		if obj then
			local x,y,z = getElementPosition(obj);
			local snd = playSound3D("sounds/explode"..tostring(math.random(1,2))..".mp3", x, y, z, false);
			setSoundVolume(snd, 1.0);
			setSoundMaxDistance(snd, 200);
		end
	end
	addEvent("firework:onRocketBoom", true);
	addEventHandler("firework:onRocketBoom", root, function(a) object:rocketBoom(a); end);
	
	function object:fountain(obj)
		if obj then
			local x,y,z = getElementPosition(obj);
			local snd = playSound3D("sounds/fountain.mp3", x, y, z, false);
			setSoundVolume(snd, 1.0);
			setSoundMaxDistance(snd, 100);
		end
	end
	addEvent("firework:onFountain", true);
	addEventHandler("firework:onFountain", root, function(a) object:fountain(a); end);
	
	return object;
end
CFireworks();

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,postGUI) 
    for oX = -1, 1 do -- Border size is 1 
        for oY = -1, 1 do -- Border size is 1 
                dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak,postGUI) 
        end 
    end 
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI) 
end 