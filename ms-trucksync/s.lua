function attached(theTruck)
  if getVehicleOccupant(theTruck) then
    setElementSyncer(source, getVehicleOccupant(theTruck))
	setElementData(theTruck, "trailer", source)
  end
end
addEventHandler("onTrailerAttach", root, attached)

function detached(theTruck)
    local x, y, z = getElementPosition(source)
    local rx, ry, rz = getElementRotation(source)
    setElementPosition(source, x, y, z)
    setElementRotation(source, rx, ry, rz)
	setElementSyncer(source, true)
	setElementData(theTruck, "trailer", false)
end
addEventHandler("onTrailerDetach", root, detached)
