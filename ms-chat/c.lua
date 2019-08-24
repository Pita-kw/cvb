local VOICECHAT_DISTANCE = 22.5
local VOICECHAT_MINDISTANCE = 10
local VOICECHAT_PAN = false

function math.lerp(from,alpha,to)
    return from + (to-from) * alpha
end

function math.unlerp(from,pos,to)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end

function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.unlerpclamped(from,pos,to)
	return math.clamp(0,math.unlerp(from,pos,to),1)
end

function updateVoiceChat()
	local x,y,z = getElementPosition(localPlayer)
	for k,v in ipairs(getElementsByType("player")) do
		local x2, y2, z2 = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

		local volume
		if dist <= 2 then
			volume = 1
		elseif dist >= VOICECHAT_DISTANCE then
			volume = 0
		else
			--volume = 0.4+ math.exp( -(dist - VOICECHAT_MINDISTANCE) )
			volume = 1
		end
		
		setSoundVolume(v, volume)

		if VOICECHAT_PAN then
			x, y, z, lookx, looky, lookz = getCameraMatrix()
			dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

			local sharpness = math.unlerpclamped(VOICECHAT_MINDISTANCE, dist, VOICECHAT_MINDISTANCE*2)
			local limit = math.lerp(0.35, sharpness, 1.0)

			local vecLook = Vector3(lookx, looky, lookz) - Vector3(x, y, z)
			local vecSound = Vector3(x2, y2, z2) - Vector3(x, y, z)
			vecLook.z = 0
			vecSound.z = 0
			vecLook:getNormalized()
			vecSound:getNormalized()
			vecLook = vecLook:cross(vecSound)

			local pan = math.clamp(-limit, -vecLook.z, limit)
			outputChatBox(pan)
			setSoundPan(v, pan)
		end
	end
end
addEventHandler("onClientPreRender", root, updateVoiceChat)

-- ikony mowienia
voicePlayers = {}

---
addEventHandler ( "onClientPlayerVoiceStart", root,
	function()
		voicePlayers[source] = true
	end
)

addEventHandler ( "onClientPlayerVoiceStop", root,
	function()
		voicePlayers[source] = nil
	end
)

addEventHandler ( "onClientPlayerQuit", root,
	function()
		voicePlayers[source] = nil
	end
)

local g_screenX,g_screenY = guiGetScreenSize()
local BONE_ID = 8
local WORLD_OFFSET = 0.4
local ICON_PATH = "images/voice.png"
local ICON_WIDTH = 0.35*g_screenX
local iconHalfWidth = ICON_WIDTH/2
local ICON_DIMENSIONS = 32
local ICON_LINE = 20
local ICON_TEXT_SHADOW = tocolor ( 0, 0, 0, 255 )

--Draw the voice image
addEventHandler ( "onClientRender", root,
	function()
		local index = 0
		for player in pairs(voicePlayers) do
			local x,y,z = getElementPosition(localPlayer)
			local x2, y2, z2 = getElementPosition(player)
			local dist = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
			if dist <= VOICECHAT_DISTANCE then
				local color = tocolor(255, 255, 255, 255)
				dxDrawVoiceLabel ( player, index, color )
				index = index + 1
			end
		end
	end
)

function dxDrawVoiceLabel ( player, index, color )
	local x, y, w, h = exports["ms-attractions"]:getInterfacePosition()
	local zoom = exports["ms-attractions"]:getInterfaceZoom()
	
	local icon = ICON_DIMENSIONS / zoom
	local textWidth = dxGetTextWidth(getPlayerName(player), 2/zoom)+icon
	local px, py = x-textWidth-25/zoom, y + (icon+4) * index

	dxDrawImage ( px, py, icon, icon, ICON_PATH, 0, 0, 0, color, false )

	px = px + icon + 5

	-- shadows
	dxDrawText ( getPlayerName ( player ), px + 1, py + 1, px, py, ICON_TEXT_SHADOW, 2/zoom)
	-- text
	dxDrawText ( getPlayerName ( player ), px, py, px, py, color, 2/zoom)
end