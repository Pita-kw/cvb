function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end 

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end