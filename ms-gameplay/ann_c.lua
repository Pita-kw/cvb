local zoom = 1
local screenW, screenH = guiGetScreenSize()
local baseX = 1920
local minZoom = 2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 

function addAnn(name, text, showTime, fadeTime, color) 
	local started = getTickCount() 
	local font = dxCreateFont("archivo_narrow.ttf", 19/zoom, false, "antialiased")
	
	local x, y, w, h = exports["ms-radar"]:getRadarPosition()
	x = x+25+w 
	y = y+h 
	
	local annWidth = 600/zoom
	local wordWrapText, returnLines = fWordWrap(text, annWidth*(8*(annWidth/300)), 21/zoom, 1.0, font, true)
	local textWidth = dxGetTextWidth(wordWrapText, 1, font, false)
	local textHeight = 15 + ((21/zoom+7.5) * returnLines)
	y = y-textHeight-8/zoom -- + 20/zoom bo nazwa gracza
	
	local function renderAnn() 
		local now = getTickCount()
		local alpha = 255 
		
		if now < started+showTime then 
			local progress = (now-started) / fadeTime 
			alpha = interpolateBetween(0, 0, 0, 255, 0, 0, math.min(1, progress), "InQuad")
		else 
			local progress = (now-started-showTime) / fadeTime 
			alpha = interpolateBetween(255, 0, 0, 0, 0, 0, math.min(1, progress), "InQuad")
		end 
		
		--local x, y, w, h = screenW/2-640/zoom/2, screenH-200/zoom, 640/zoom, 200/zoom
		local r, g, b = hex2rgb(color)
		
		exports["ms-gui"]:dxDrawBluredRectangle(x, y, textWidth+30/zoom, textHeight+20/zoom, tocolor(255, 255, 255, alpha), true) 
		dxDrawRectangle(x, y, 5/zoom, textHeight+20/zoom, tocolor(r, g, b, alpha), true) 
		
		dxDrawText(name:gsub( '#%x%x%x%x%x%x', '' ), x+21/zoom, y+1, x+w+1, y+h+1, tocolor(0, 0, 0, alpha), 1, font or "default-bold", "left", "top", false, true, true, true)
		dxDrawText(name, x+20/zoom, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, font or "default-bold", "left", "top", false, true, true, true)
		
		dxDrawText(wordWrapText, x+21/zoom, y+30/zoom+1, x+w+1, y+30/zoom+h+1, tocolor(0, 0, 0, alpha), 1, font or "default-bold", "left", "top", false, false, true)
		dxDrawText(wordWrapText, x+20/zoom, y+30/zoom, x+w, y+30/zoom+h, tocolor(230, 230, 230, alpha), 1, font or "default-bold", "left", "top", false, false, true)
	end
	
	addEventHandler("onClientRender", root, renderAnn)
	setTimer(function()
		if isElement(font) then 
			destroyElement(font)
		end
		removeEventHandler("onClientRender", root, renderAnn)
	end, showTime+fadeTime*2, 1)
	
end 
addEvent("onClientAddAnnouncement", true)
addEventHandler("onClientAddAnnouncement", root, addAnn)

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function fWordWrap ( sText, nWidth, nFontScaleX, nFontScaleY, font, bReturnLinesCountToo )

    local sOutText, sCurLine, sCurWord, sSpaceBeforeWord, sSpaceAndWordGroup, sSpaceAndWordGroupEnd = "", "", "", "", "", 1
    local sSpaceAndWordGroupPattern = "(([\r\n\t -/:-?%[-`{-~]*)([^\r\n\t -/:-?%[-`{-~]+))"


    -- ??????? ????
    _, sSpaceAndWordGroupEnd, sSpaceAndWordGroup, sSpaceBeforeWord, sCurWord = sText:find (
        sSpaceAndWordGroupPattern,
        1
    )

    while sSpaceAndWordGroupEnd do

        if dxGetTextWidth( sCurLine .. sSpaceAndWordGroup, nFontScaleX, font ) > nWidth then

            -- ???? ???? ?????? ????
            if dxGetTextWidth( sSpaceAndWordGroup, nFontScaleX, font ) > nWidth then

                while true do
                    local sPartEnd = sSpaceAndWordGroup:len() - 1
                    local sPart =    sSpaceAndWordGroup:sub( 1, sPartEnd )

                    -- ????????? ????? ?? 1 ??????? ???? ??? ?? ?????? ?????? ? ??????? ?????????? ?????? ? ?????? ??????
                    -- ?????? 1 ??????? ????? ?? ????? ????
                    while sPartEnd >= 1 and dxGetTextWidth( sCurLine .. sSpaceAndWordGroup, nFontScaleX, font ) > nWidth do
                        sPartEnd =   sPartEnd - 1
                        sPart =      sSpaceAndWordGroup:sub( 1, sPartEnd )
                    end

                    -- ????? ?????? = ?????????? ????? ?? ????????? ?????
                    sCurLine = sSpaceAndWordGroup:sub( sPartEnd + 2, -1 )
                    -- ?????? = ?????? ????? ????? + \n
                    sSpaceAndWordGroup = sPart .. "\n" .. sCurLine

                    -- ???? ?????? ????? ????????? ???? ????? ????? ??????, ???? ????? ???????????
                    -- ??? ????? ??? ???????? ????? ?????? ????? ??????
                    if sPart:len() <= 1 or dxGetTextWidth( sCurLine .. sSpaceAndWordGroup, nFontScaleX, font ) <= nWidth then
                        break
                    end
                end

            else

                sSpaceAndWordGroup = sSpaceBeforeWord .. "\n" .. sCurWord
                sCurLine = sCurWord

            end


        else
            sCurLine = sCurLine .. sSpaceAndWordGroup
        end

        sOutText = sOutText .. sSpaceAndWordGroup

        _, sSpaceAndWordGroupEnd, sSpaceAndWordGroup, sSpaceBeforeWord, sCurWord = sText:find (
            sSpaceAndWordGroupPattern,
            sSpaceAndWordGroupEnd + 1
        )

    end
    --

    sOutText = sOutText .. ( sText:match("[\r\n\t -/:-?%[-`{-~]*$") or "" )



    if bReturnLinesCountToo then
        -- ?????????? ???-?? ????? ? ?????????? ??????
        local nLines
        _, nLines = sOutText:gsub( "(\r?\n)", "%1" )

        -- ?????? ????? ????? ? ?????????? ? ???-?? ????? ? ????? ??????
        return sOutText, (nLines + 1)
    else
        return sOutText
    end

end

function dxGetTextHeight ( sText, font, nFontScaleX, nFontScaleY, nMaxWidth )

    if  type(sText) ~= 'string' or sText == '' or
        type(nMaxWidth) ~= 'number' or nMaxWidth <= 0 or
        type(nFontScaleX) ~= 'number' or nFontScaleX <= 0 or
        type(nFontScaleY) ~= 'number' or nFontScaleY <= 0 or
        ( type(font) ~= 'string' and type(font) ~= 'userdata' ) 
    then
        return 0
    end

    local _, nStrings = fWordWrap( sText, nMaxWidth, nFontScaleX, nFontScaleY, font, true )

    return dxGetFontHeight(nFontScaleY, font) * nStrings
end