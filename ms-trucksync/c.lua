addEventHandler("onClientElementStreamIn", getRootElement(), function()
  if getElementType(source) == "vehicle" and (getElementModel(source) == 403 or getElementModel(source) == 514 or getElementModel(source) == 515) then
    local tr = getElementData(source, "trailer")
    if tr and  isElement(tr) then
	  local x, y, z = getElementPosition(source)
	  local rx, ry, rz = getElementRotation(source)
	  detachTrailerFromVehicle(source, tr)
	  
	  setElementPosition(source, x, y, z)
	  setElementPosition(source, rx, ry, rz)
      attachTrailerToVehicle(source, tr)
    end
  end
end)
