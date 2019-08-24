--
-- c_meme.lua
--

local fileList = {}
local isMemeForced = get("meme.ForcePlayer")

addEventHandler ("onPlayerJoin", getRootElement(), function()
	if isMemeForced=="true" then
		if getElementType ( source ) == "player" then
			local chosenImgId = math.random(1, #fileList)
			local chosenColor = tocolor ( ( math.random ( 150, 255 ) ), ( math.random ( 150, 255 ) ), ( math.random ( 150, 255 ) ), 255 )
			setElementData(source, 'memeHead', chosenImgId, true)
			setElementData(source, 'memeColor', chosenColor, true) 
		end
	end
end
)

addEventHandler("onResourceStart", getResourceRootElement( getThisResource()),function()
	if isMemeForced=="true" then
		local meta = xmlLoadFile("faces.xml")  
		local children = xmlNodeGetChildren(meta)
		for i,name in ipairs(children) do 
			fileList[i] = xmlNodeGetAttribute(name, "file")
		end
		for index,thisPed in ipairs(getElementsByType("player")) do
			if not getElementData(thisPed, 'memeHead') or not getElementData(thisPed, 'memeColor') then
				local chosenImgId = math.random(1, #fileList)
				local chosenColor = tocolor ( ( math.random ( 150, 255 ) ), ( math.random ( 150, 255 ) ), ( math.random ( 150, 255 ) ), 255 )
				setElementData(thisPed, 'memeHead', chosenImgId, true)
				setElementData(thisPed, 'memeColor', chosenColor, true) 
			end
		end
	end
end
)

function tocolor( r, g, b, a )
	a = tonumber( a ) or 255
	return tonumber( string.format( "0x%X%X%X%X", a, r, g, b ) )
end
