local fullx,fully = guiGetScreenSize()
function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	
	local mx,my = getCursorPosition ()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function isColor(color)
	if color == nil or type(color) ~= 'string' then
        return false
    end
	
	if color:match('#%x%x%x%x%x%x') then 
		return true 
	end 
end