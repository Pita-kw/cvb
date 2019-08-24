local interiorObjects = {}
function createInteriorObjects(data, id)
	if type(data) == "table" then
		for k,v in ipairs(data) do 
			local model = v[1]
			local x,y,z = v[2], v[3], v[4]
			local rx,ry,rz = v[5], v[6], v[7]
			local obj = createObject(model,x,y,z,rx,ry,rz)
			setElementDimension(obj, id)
			setElementInterior(obj, 200)
			table.insert(interiorObjects, obj)
		end 
	end
end 
addEvent("onCreateInteriorObjects", true)
addEventHandler("onCreateInteriorObjects", root, createInteriorObjects)

function deleteInteriorObjects()
	for k,v in ipairs(interiorObjects) do 
		destroyElement(v)
	end 
	interiorObjects = {} 
end 
addEvent("onDeleteInteriorObjects", true)
addEventHandler("onDeleteInteriorObjects", root, deleteInteriorObjects)