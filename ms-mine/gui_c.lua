--[[
	@project: multiserver
	@author: l0nger <l0nger.programmer@gmail.com>
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
	dxDrawImage(self.sx/2-(bg_x/self.zoom)/2, self.sy/2-(bg_y/self.zoom)/2, bg_x/self.zoom, bg_y/self.zoom, self.bg)
	
	local cx,cy=getCursorPosition()
	if not cx or not cy then return end
	cx,cy=cx*self.sx, cy*self.sy
	
	for i,v in pairs(self.button) do
		if self.gui_renderMode==v.type_rendering then
			if v.btn=='blue' then
				if v.hover==true then
					dxDrawImage(v.x, v.y, v.w, v.h, self.btn_bluehv)
				else
					dxDrawImage(v.x, v.y, v.w, v.h, self.btn_blue)
				end
			elseif v.btn=='red' then
				if v.hover==true then
					dxDrawImage(v.x, v.y, v.w, v.h, self.btn_redhv)
				else
					dxDrawImage(v.x, v.y, v.w, v.h, self.btn_red)
				end
			end
			dxDrawText(v.txt, v.x+self.button_margin, v.y+self.button_margin,
				v.x+v.w-self.button_margin, v.y+v.h-self.button_margin,
				tocolor(255, 255, 255, 255), 0.47, self.font1, 'center', 'center', true, false, false, false)
		end
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
	self.gui_render=bool
	if bool==true then
		showCursor(true)
	else
		showCursor(false)
	end
end

function CEGUI:onClickedButton(button)
	if button=='start' then
		startMineJob(localPlayer)
		self:setEnable(false)
	elseif button=='cancel' then
		self:setEnable(false)
	end
end

function CEGUI:constructor(name1, name2)
	self.gui_render=false
	
	local sx,sy=guiGetScreenSize()
	self.ratio=(sx/sy)
	self.sx, self.sy=sx, sy
	
	self.zoom=1.1
	self.zoomTable={
		[1]={640, 480, 1.9},
		[2]={800, 600, 1.7},
		[3]={1024, 768, 1.5},
		--[1]={640, 480},
	}
	for i,v in pairs(self.zoomTable) do
		if v[1]==sx and v[2]==sy then
			self.zoom=v[3]
		end
	end
	
	-- textures
	self.bg=dxCreateTexture('i/bg.png', 'dxt5', false, 'wrap')
	self.btn_blue=dxCreateTexture('i/btn_b.png', 'dxt5', false, 'wrap')
	self.btn_bluehv=dxCreateTexture('i/btn_bh.png', 'dxt5', false, 'wrap')
	self.btn_red=dxCreateTexture('i/btn_r.png', 'dxt5', false, 'wrap')
	self.btn_redhv=dxCreateTexture('i/btn_rh.png', 'dxt5', false, 'wrap')
	--
	
	self.button_margin=5
	self.button={
		--(self.sx/2-(509/self.zoom)/2)+259/self.zoom, y=self.sy/2-(-300/self.zoom)/2, w=219/self.zoom, h=86/self.zoom
		['start']={x=(self.sx/2-(509/self.zoom)/2)+289/self.zoom, y=self.sy/2-(-300/self.zoom)/2, w=169/self.zoom, h=86/self.zoom, txt=tostring(name1), call=tostring(name1), btn='blue', active=true, visible=true, hover=false, lu_clicked=getTickCount()},
		['cancel']={x=(self.sx/2-(509/self.zoom)/2)+52/self.zoom, y=self.sy/2-(-300/self.zoom)/2, w=169/self.zoom, h=86/self.zoom, txt=tostring(name2), call=tostring(name2), btn='red', active=true, visible=true, hover=false, lu_clicked=getTickCount()},
	}
	self.font1=dxCreateFont('f/archivo_narrow.ttf', 24)
	
	self.renderFunc=function() self:render() end
	addEventHandler('onClientRender', root, self.renderFunc)
end
GUIClass=CEGUI:new('Pracuj', 'Anuluj')


fileDelete("gui_c.lua")