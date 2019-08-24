--[[
	@project: fullgaming
	@author: l0nger <l0nger.programmer@gmail.com>
	@filename: remove_shadows.lua
	@desc: usuwanie cieni, z pedow, pojazdow, lamp itd.
]]

local cFunc={}
local cSetting={}

Remove_Shadows={}
Remove_Shadows.__index=Remove_Shadows

function Remove_Shadows:new(...)
	local obj=setmetatable({}, {__index=self})
	if obj.constructor then
		obj:constructor(...)
	end
	return obj
end

function Remove_Shadows:constructor(...)
	self.shader=dxCreateShader('fx/swap.fx')
	
	self.shad_ped_texture=dxCreateTexture('i/shad_ped.png', 'dxt3', false, 'wrap')
	dxSetShaderValue(self.shader, 'TEXTURA', self.shad_ped_texture)
	engineApplyShaderToWorldTexture(self.shader, 'shad_ped') -- cienie pedow
	engineApplyShaderToWorldTexture(self.shader, 'shad_car') -- cienie pojazdow
	engineApplyShaderToWorldTexture(self.shader, 'lamp_shad_64') -- cienie lamp
	engineApplyShaderToWorldTexture(self.shader, 'shad_exp') -- cienie swiatla lamp
	
	outputDebugString('[calling] Remove_Shadows: constructor')
end
Remove_Shadows:new()