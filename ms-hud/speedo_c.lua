local zoom = 1
odometerPosX, odometerPosY = 0, 0

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
	if not theElement then return end 
	
	assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

defaultOdometerSettings = {
	["font"] = "default",
	["scale"] = 1.5,
	["style"] = "analog",
	["positionFrom"] = "center",
	["digitPadding"] = 1.55,
	["spaceBetweenDigits"]= 0,
	["backgroundPaddingVertical"] = 7,
	["backgroundPaddingHorizontal"] = 3,

	-- Colors
	["fontColorRed"] = 200,
	["fontColorGreen"] = 200,
	["fontColorBlue"] = 200,
	["fontColorAlpha"] = 205,

	["fontColor2Red"] = 255,
	["fontColor2Green"] = 255,
	["fontColor2Blue"] = 255,
	["fontColor2Alpha"] = 205,

	-- Odometer
	["tripEnabled"] = true,
	["tripTop"] = 0.81,
	["tripLeft"] = 0.87,
	["tripNumberOfDigits"] = 6


}
local s = function(setting,settingType)
	return defaultOdometerSettings[setting]
end

fonts = {"default","default-bold","clear","arial","sans","pricedown","bankgothic","diploma","beckett"}
styles = {"analog","digital"}
local digitTypeNormal = 0
local digitTypeTripHundred = 1

local timerIntervall = 100
function initiateOdometer()
	screenWidth, screenHeight = guiGetScreenSize()
	setTimer(calculateDistance,timerIntervall,0)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),initiateOdometer)

-------------
-- Drawing --
-------------

--[[
-- This draws both odometers if the player is in a vehicle.
-- This function is called from the speedometer script's onClientRender handler.
-- ]]
function drawOdometer()
	if not isPedInVehicle(localPlayer) then return end
	prepareDrawOdometer("trip")
end

--[[
-- Draw a single digit
--
-- @param   int    x: The x coordinate
-- @param   int    y: The y coordinate
-- @param   float  number: Which number to draw, if in between two digits
-- 				this will be a floating point number
-- @param   int    numberType: If it is the hunderd-meter digit of the trip
-- 				counter or not
-- @param   float  padding: The horizontal distance to the left or right border
-- ]]
function drawOdometerDigit(x,y,number,numberType,padding)
	local bottomNumber = math.ceil(number)
	if bottomNumber > 9 then bottomNumber = 0 end
	local topNumber = math.floor(number)
	
	local state = number - topNumber
	
	local topBottom = (y+fontHeight - fontHeight * state)
	local bottomTop = (y+fontHeight - fontHeight * state)
	
	local fontColor = tocolor(
				s("fontColorRed"),
				s("fontColorGreen"),
				s("fontColorBlue"),
				s("fontColorAlpha"))
	if numberType == digitTypeTripHundred then
		fontColor = tocolor(
				s("fontColor2Red"),
				s("fontColor2Green"),
				s("fontColor2Blue"),
				s("fontColor2Alpha"))
	end
	local fontScale =  s("scale")/zoom
	
	dxDrawText( tostring(topNumber), x, y+4/zoom, x+textWidth*padding, topBottom, fontColor,fontScale,s("font"),"center","bottom",true,false,false)
	dxDrawText( tostring(bottomNumber), x, bottomTop, x+textWidth*padding, y+fontHeight, fontColor,fontScale,s("font"),"center","top",true,false,false)
end

--[[
-- Calculates the single digits and draws them, as well
-- as the background.
--
-- @param   string   odometerType: Whether its the trip or total-odometer
-- ]]
function prepareDrawOdometer(odometerType)
	local number = 0
	local numberOfDigits = 0
	local left = 0
	local top = 0
	if odometerType == "trip" then
		if not s("tripEnabled") then
			return false
		end
		number = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:mileage") or 0) / 1000
		left = s("tripLeft")
		top = s("tripTop")
		numberOfDigits = s("tripNumberOfDigits")
	end

	local style = s("style")

	-- settings
	local digitPadding = s("digitPadding")
	local spaceBetweenDigits = s("spaceBetweenDigits")

	local fontScale = s("scale")/zoom

	if style == "analog" then	
	-- get font properties
		fontHeight = dxGetFontHeight(fontScale,s("font"))
		textWidth = dxGetTextWidth("0",fontScale,s("font"))
	else
		fontHeight = dxGetFontHeight(fontScale,s("font"))
		fontWidth = dxGetTextWidth(string.rep("0",numberOfDigits),s("font"))
	end

	-- calculate stuff from properties and settings
	local digitWidth = textWidth * digitPadding
	--local spaceBetweenDigitsAbsolute = digitWidth * (spaceBetweenDigits)
	local spaceBetweenDigitsAbsolute = 0.1

	
	local backgroundPaddingHorizontal = s("backgroundPaddingHorizontal")
	local backgroundPaddingVertical = s("backgroundPaddingVertical")
	local backgroundWidth = numberOfDigits * (digitWidth + spaceBetweenDigitsAbsolute) + backgroundPaddingHorizontal*2 - spaceBetweenDigitsAbsolute
	
	local posX = odometerPosX
	local posY = odometerPosY
	
	if s("style") == "analog" then

		if odometerType == "total" then
			numberOfDigits = numberOfDigits + 1
		end
	
		-- Calculate single digits
		for i = 1, numberOfDigits, 1 do
		
			local numberToDraw = number % (10^i)
			if i > 1 then
				numberToDraw = numberToDraw / (10^(i - 1))
				if numberToDraw % 1 < tonumber("0."..string.rep("9",i - 1)) then
					numberToDraw = math.floor(numberToDraw)
				else
					numberToDraw = math.floor(numberToDraw) + (numberToDraw * 10^(i-1)) % 1
				end
			end
			local digitType = digitTypeNormal
			if i == 1 and odometerType == "trip" then
				digitType = digitTypeTripHundred
			end
			if odometerType == "trip" or i > 1 then
				-- Draw single digit
				drawOdometerDigit(posX + backgroundPaddingHorizontal + (numberOfDigits - i)*(digitWidth + (spaceBetweenDigitsAbsolute)),posY + backgroundPaddingVertical,numberToDraw,digitType,digitPadding)
			end
			--[[
			if odometerType == "trip" then
				drawDigit(posX + backgroundPaddingLeftRight + (numberOfDigits - i)*(digitWidth + (spaceBetweenDigitsAbsolute)),posY,numberToDraw,digitType,digitPadding)
			elseif i > 1 then
				drawDigit(posX + backgroundPaddingLeftRight + (numberOfDigits - i)*(digitWidth + (spaceBetweenDigitsAbsolute)),posY,numberToDraw,digitType,digitPadding)
			end]]
		end

	else
		dxDrawText(tostring(round(number)),posX,posY)
	end
	
end

local prevX, prevY, prevZ = 0
local maxDistance = 1000 / (1000 / timerIntervall)
function calculateDistance()
	local vehicle = getVehicleFromPlayer(getLocalPlayer())
	if not isPedInVehicle(localPlayer) then return end
	if localPlayer ~= getVehicleController(getPedOccupiedVehicle(localPlayer)) then return end 
	
	
	-- sprawdzanie czy pojazd jedzie po teksturach (nie naliczamy przebiegu podczas lotu)
	
	
	

	if isLocalPlayerDead or not vehicle or isElementFrozen(vehicle) or not isControlEnabled("forwards") then
		return
	end

	local x,y,z = getElementPosition(vehicle)
	if prevX ~= 0 then
		local distanceSinceLast = ((x-prevX)^2 + (y-prevY)^2 + (z-prevZ)^2)^(0.5)

		if distanceSinceLast < maxDistance and distance < 2 then
			setElementData(vehicle, "vehicle:mileage", (getElementData(vehicle, "vehicle:mileage") or 0) + distanceSinceLast)
		end
	end
	prevX = x
	prevY = y
	prevZ = z
end

function getVehicleFromPlayer(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then 
		if getVehicleController(vehicle) == player then 
			return vehicle
		end
	end 
	
	return false
end

-- licznik 
local sw, sh = guiGetScreenSize()
local baseX = 1680
local minZoom = 2
if sw < baseX then
	zoom = math.min(minZoom, baseX/sw)
end 

local speedoW, speedoH = 320/zoom, 320/zoom
speedoPosX, speedoPosY = math.floor(sw-speedoW-40/zoom), math.floor(sh-speedoH-40/zoom)
odometerPosX, odometerPosY = math.floor(speedoPosX+105/zoom), math.floor(speedoPosY+210/zoom)

function renderSpeedo()	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle or settingsOn then 
		local lights = getVehicleOverrideLights (vehicle)
		local state = "day"
		if lights == 2 then 
			state = "night"
		end 
		
		dxSetBlendMode("modulate_add")
		dxDrawImage(speedoPosX, speedoPosY, speedoW, speedoH, "speedo/"..tostring(state).."_back.png", 0, 0, 0, tocolor(255, 255, 255, 230))
		
		local spd = getElementSpeed(vehicle, "km/h") or 0 
		local rot = spd*1.02
		dxDrawImage(speedoPosX, speedoPosY, speedoW, speedoH, "speedo/indicator_"..tostring(state)..".png", rot)
		
		dxDrawImage(odometerPosX-108/zoom, odometerPosY-208/zoom, speedoW, speedoH, "speedo/mileage.png", 0, 0, 0, tocolor(255, 255, 255, 230))
		dxSetBlendMode("blend")
		
		drawOdometer()
	end
end
addEventHandler("onClientRender", root, renderSpeedo)
