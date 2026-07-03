local ambient = require('openmw.ambient')
local async = require('openmw.async')
local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require('openmw.util')
local util = require('openmw.util')
local ui = require('openmw.ui')
local postprocessing = require('openmw.postprocessing')
local shader = postprocessing.load('chronokinesis_poly')
local shaderon = false
local shaderdone = true



local function clamp(a,b,c)
	if a<b then a = b end
	if a>c then a = c end
	return a
end


local function initvars(InitData)
	shader:disable()
	shaderdone = true
	shaderon = false
	ambient.stopSoundFile('sound/Fx/heart')
	ambient.stopSoundFile('sound/Fx/heart2')
end
return {
	engineHandlers = {
		onInit = initVars,
		onUpdate = function (_)
	

			local chronokinesis_magnitude = types.Actor.activeEffects(self):getEffect("chronokinesis_poly").magnitude
			local dkm = types.Actor.activeEffects(self):getEffect("detectkey").magnitude
			local dam = types.Actor.activeEffects(self):getEffect("detectanimal").magnitude
			local dem = types.Actor.activeEffects(self):getEffect("detectenchantment").magnitude
			local dsum = dkm+dam+dem
			if dsum >= 300 then
				local foundspell = false
				for _, spell in pairs(types.Actor.spells(self)) do
					if spell.id == "chronokinesis_poly_natural" then
						foundspell = true
						return
					end
				end
				if not foundspell then
					ambient.playSoundFile('sound/Fx/envrn/bell5.wav',{pitch=1.2,volume=1})
					async:newUnsavableSimulationTimer(1, function()
							ambient.playSoundFile('sound/Fx/envrn/bell3.wav',{pitch=1.5,volume=1})
					end)
					async:newUnsavableSimulationTimer(2, function()
							ambient.playSoundFile('sound/Fx/envrn/bell4.wav',{pitch=2,volume=1})
					end)
					async:newUnsavableSimulationTimer(2, function()
						types.Actor.activeSpells(self):add{
							caster = self.object,
							id = "chronokinesis_poly_natural",
							effects = {0},
							stackable = false,
							ignoreResistances  = true,
							ignoreSpellAbsorption = true,
							ignoreReflect = true,
							name = "Magnus' True Perception",
						}
					end)
					ui.showMessage("Through your sheer force of will, you have achieved awareness of 'Magnus' True Perception'")
					types.Actor.spells(self):add("chronokinesis_poly_natural")
				end
			end
			if chronokinesis_magnitude > 0 then
				if not shaderon and shaderdone then
					shaderon = true
					shader:enable()
					ambient.playSoundFile('sound/Fx/magic/OLD/Mysticism Cast.wav',{pitch=1.3,volume=0.5})
					ambient.playSoundFile("sound/Fx//heart.wav",{pitch=1,volume=1.5,loop=true})
					ambient.playSoundFile("sound/Fx//heart2.wav",{pitch=0.8,volume=1,loop=true})
					shader:setFloat('strength', 0)
					shaderdone = false
					for buh = 1,30 do
						async:newUnsavableSimulationTimer(buh*0.02, function()
							shader:setFloat('flipper', math.sin(core.getRealTime()*80))
							shader:setFloat('strength', buh/30*0.65)
							if buh == 30 then
								shaderdone = true
							end
						end)
						
					end
				end
				local nx = math.min(chronokinesis_magnitude / 100, 1)
				local timescale = 1 - 0.5 * (nx * nx)
				if shaderdone then
					shader:setFloat('flipper', math.sin(core.getRealTime()*80))
					shader:setFloat('timescale',timescale)
					shader:setFloat('strength', 0.65+clamp(math.sin(core.getRealTime()*0.645),-1,1)*0.05)
				end
			else
				if shaderon then
					shaderon = false
					shaderdone = false
					for buh = 1,30 do
						async:newUnsavableSimulationTimer(buh*0.025, function()
							shader:setFloat('flipper', math.sin(core.getRealTime()*80))
							shader:setFloat('strength', clamp(0.65+clamp(math.sin(core.getRealTime()*0.645),-1,1)*0.05-buh/30,0,1))
						end)
					end
					async:newUnsavableSimulationTimer(1.5, function()
						shader:setFloat('strength', 0)
						shader:disable()
						shaderdone = true
					end)
					ambient.stopSoundFile('sound/Fx/heart.wav')
					ambient.stopSoundFile('sound/Fx/heart2.wav')
					ambient.playSoundFile('sound/Fx/magic/OLD/cast.wav',{pitch=0.8,volume=1})
				end
			end
		end
	}
}
