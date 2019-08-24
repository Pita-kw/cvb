addEventHandler("onClientPreRender", root, function()
	local peds = getElementsByType("ped")
	for k, v in ipairs(peds) do 
		local isHorse = getElementData(v, "isHorse") 
		if isHorse then 
			local _, _, rz = getElementRotation(v)
			setElementRotation(v, -90, 0, rz)
		end
	end
end)

addEventHandler("onClientPedDamage", root, function()
	if getElementData(source, "sredniowiecze") then cancelEvent() end
end)