--[[
	@project: multiserver
	@author: l0nger <l0nger.programmer@gmail.com> & virelox <virelox@gmail.com>
	@filename: gui_c.lua
	@desc: rysowanie elementow gui
]]

local cFunc={}
local cSetting={}

CEGUI={}
CEGUI.__index=CEGUI

function CEGUI:new(...)
	local obj=setmetatable({}, {__index=self})
	if obj.constructor then
		obj:constructor(...)
	end
	return obj
end

function CEGUI:render()
	if not self.gui_render then return end
	
	local bg_x, bg_y=512, 512
	exports["ms-gui"]:dxDrawBluredRectangle(self.sx/2-(bg_x/self.zoom)/2, self.sy/2-(bg_y/self.zoom)/2, bg_x/self.zoom, bg_y/self.zoom, tocolor(200, 200, 200, 255), true)

	dxDrawRectangle(self.sx/2-(512/self.zoom)/2, (self.sy/2-(512/self.zoom)/2)+512/self.zoom, 512/self.zoom, 5/self.zoom, tocolor(0, 102, 204, 155), true)
	
	dxDrawImage(self.sx/2-(bg_x/self.zoom)/2, self.sy/2-((bg_y+30)/self.zoom)/2, bg_x/self.zoom, bg_y/self.zoom, self.bg, 0, 0, 0, tocolor(255,255,255,255), true)
	local cx,cy=getCursorPosition()
	if not cx or not cy then return end
	cx,cy=cx*self.sx, cy*self.sy
	
	for i,v in pairs(self.button) do
		if self.gui_renderMode==v.type_rendering then
			if v.btn=='blue' then
				if v.hover==true then
					dxDrawRectangle(v.x, v.y, v.w, v.h,  tocolor(194, 194, 194, 50), true)
				else
					dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(194, 194, 194, 30), true)
				end
			elseif v.btn=='red' then
				if v.hover==true then
					dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(250, 30, 30, 150), true)
				else
					dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(240, 30, 30, 100), true)
				end
			end
			dxDrawText(v.txt, v.x+self.button_margin, v.y+self.button_margin,
				v.x+v.w-self.button_margin, v.y+v.h-self.button_margin,
				tocolor(255, 255, 255, 255), 0.53, self.font1, 'center', 'center', true, false, true, false)
		end
		dxDrawRectangle(self.sx/2-(512/self.zoom)/2, self.sy/2-(512/self.zoom)/2, 512/self.zoom, 50/self.zoom, tocolor(30, 30, 30, 50), true)
		dxDrawText(self.texts[1].txt, self.sx/2-(512/self.zoom)/2, self.sy/2-(1420/self.zoom)/2, 512/self.zoom+self.sx/2-(512/self.zoom)/2, 512/self.zoom+self.sy/2-(512/self.zoom)/2, 
			tocolor(255, 255, 255, 155), 0.65, self.font1, 'center', 'center', true, false, true, false)
			
			dxDrawText(self.texts[2].txt, self.texts[2].x, self.texts[2].y,
				self.texts[2].x+self.texts[2].w-100/self.zoom, self.texts[2].y+self.texts[2].h, 
				tocolor(200, 200, 200, 255), 0.53, self.font1, 'left', 'bottom', false, true, true, false)
	end
	self:performChecks(getKeyState('mouse1'), getKeyState('mouse2'), cx, cy)
end

function CEGUI:performChecks(mouse1, mouse2, cx, cy)
	for i,v in pairs(self.button) do
		local inside=(cx >= v.x and cx <= v.x+v.w and cy >= v.y and cy <= v.y+v.h)
		if inside then
			v.hover=true
			if mouse1 and not self.leftMouseActive then
				if getTickCount()-v.lu_clicked<700 then
				else
					v.lu_clicked=getTickCount()
					if i=='start' then
						self:onClickedButton(i)
					elseif i=='cancel' then
						self:onClickedButton(i)
					end
					-- self:onClickedButton(v.call)
				end
			end
		else
			v.hover=false
		end
	end
end

function CEGUI:getRenderGUI()
	return self.gui_render
end

function CEGUI:setEnable(bool)
	showCursor(bool)
	self.gui_render=bool
end

function CEGUI:onClickedButton(button)
	if button=='start' then
		triggerServerEvent("onPlayerStartChristmasWork", localPlayer)
		self:setEnable(false)
	elseif button=='cancel' then
		self:setEnable(false)
	end
end

function CEGUI:constructor(name1, name2, name3, name4)
	self.gui_render=false
	
	local sx,sy=guiGetScreenSize()
	self.ratio=(sx/sy)
	self.sx, self.sy=sx, sy
	
	self.zoom=1
	self.baseX = 1920
	self.minZoom = 2
	if self.sx < self.baseX then
		self.zoom = math.min(self.minZoom, self.baseX/sx)
	end 
	--
	
	self.button_margin=5
	self.button={
		--(self.sx/2-(509/self.zoom)/2)+259/self.zoom, y=self.sy/2-(-300/self.zoom)/2, w=219/self.zoom, h=86/self.zoom
		['start']={x=(self.sx/2-(509/self.zoom)/2)+289/self.zoom, y=self.sy/2-(-350/self.zoom)/2, w=159/self.zoom, h=45/self.zoom, txt=tostring(name1), call=tostring(name1), btn='blue', active=true, visible=true, hover=false, lu_clicked=getTickCount()},
		['cancel']={x=(self.sx/2-(509/self.zoom)/2)+52/self.zoom, y=self.sy/2-(-350/self.zoom)/2, w=159/self.zoom, h=45/self.zoom, txt=tostring(name2), call=tostring(name2), btn='red', active=true, visible=true, hover=false, lu_clicked=getTickCount()},
	}
	
	self.texts={
		{x=(self.sx/2-(360/self.zoom)/2)+52/self.zoom, y=self.sy/2-(500/self.zoom)/2, w=300/self.zoom, h=50/self.zoom, txt=tostring(name3)},
		{x=(self.sx/2-(520/self.zoom)/2)+52/self.zoom, y=self.sy/2-(800/self.zoom)/2, w=512/self.zoom, h=512/self.zoom, txt=tostring(name4)}
	}
	self.font1=dxCreateFont('f/archivo_narrow.ttf', 24/self.zoom)
	self.bg=dxCreateTexture('i/bg.png', 'dxt5', false, 'wrap')
	self.renderFunc=function() self:render() end
	addEventHandler('onClientRender', root, self.renderFunc)
end
GUIClass=CEGUI:new('Pracuj', 'Anuluj', 'Rozrzucanie prezentów', 'Wciel się w św. Mikołaja i rozrzuć jak najwięcej prezentów po całym San Andreas. Wykorzystasz do tego latające sanie.\n\n\nZarobek za każdy prezent: $100 i 1EXP')

fileDelete("gui_c.lua")
