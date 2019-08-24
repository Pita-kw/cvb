--[[
	@project: multiserver
	@author: Virelox <virelox@gmail.com> & brzysiu kuhwa
	@filename: col_s.lua
	@desc: strefy
	
	Całkowity zakaz rozpowszechniania, edycji i użytku bez zgody autora. 
]]


local colPoses={
	{type ="antydm", x=154.3837890625, y=-1951.7783203125, z=47.875, r=5.0, i=0, d=0}, -- jail
	{type="antydm", x=285.1015625, y=-2005.314453125, z=1.424722433090, r=30.0, i=0, d=0}, -- beachparty
	{type="antydm", x=109.5869140625, y=1048.4912109375, z=13.609375, r=30.0, i=0, d=0}, -- kino
	{type="antydm", x=2029.5072021484, y=1679.1351318359, z=998.55310058594, r=50.0, i=1, d=0}, -- kasyno
	{type="antydm", x=1698.7509765625, y=1645.0615234375, z=10.755279541016, r=20.0, i=0, d=0}, -- pilot
	{type="antydm", x=2385, y=-2100, z=14, r=100, i=0, d=0}, -- gielda
	{type="antydm", x=1937, y=-2496, z=13, r=20, i=0, d=0}, -- lslot
	{type="antydm", x=2131, y=-1144, z=24, r=30, i=0, d=0}, -- salon
}

for k, v in ipairs(colPoses) do 
	local el = createElement(v.type)
	setElementPosition(el, v.x, v.y, v.z)
	setElementData(el, "distance", v.r)
	setElementInterior(el, v.i)
	setElementDimension(el, v.d)
end

function getZonePos(player, cmd)
	local x,y,z = getElementPosition(player)
	local i = getElementInterior(player)
	local d = getElementDimension(player)
	
	outputChatBox('{type="antydm", x='.. x ..', y='.. y ..', z='.. z ..', r=20.0, i='.. i ..', d='.. d ..'}', player)
end
addCommandHandler("zonepos", getZonePos)