local peds = {
	-- name, id, x, y, z, rotz, isHorse
	--{"Handlarka", 308, 1984.72,-4526.73,13.39, 128},
	{"Koń Oskar", 305, 1984.72,-4526.73,13.39, 128, true},
	{"Kowal", 300, 1961.37,-4510.94,13.39, 346},
	{"Handlarka", 303, 1954.99,-4483.47,14.24, 180},
	{"Gosposia", 304, 1944.99,-4539.47,14.30, 25},
	{"Strażnik", 302, 1964.99,-4485.56,13.39, 171}
}

for k, v in ipairs(peds) do
	local ped = createPed(v[2], v[3], v[4], v[5], v[6], false)
	setElementFrozen(ped, true)
	setElementData(ped, "isHorse", v[7] or false)
	setElementData(ped, "sredniowiecze", true)
	
	local text = createElement("3dtext")
	setElementPosition(text, v[3], v[4], v[5]+1)
	setElementData(text, "text", v[1])
end