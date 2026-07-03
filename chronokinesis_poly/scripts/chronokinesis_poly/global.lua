local world = require('openmw.world')
local core = require('openmw.core')
local types = require('openmw.types')
local async = require('openmw.async')
local player = world.players[1]
local Timeset = false
local function clamp(a,b,c)
	if a<b then a = b end
	if a>c then a = c end
	return a
end

local function initvars(InitData)
	Timeset = false
	world.setSimulationTimeScale(1)
end
return {
	engineHandlers = {
		onInit = initVars,
		onUpdate = function (_)
			local active = types.Actor.activeEffects(player):getEffect("chronokinesis_poly").magnitude

			if active > 0 then
				if not Timeset then
					for bleh = 1,10 do
						async:newUnsavableSimulationTimer(bleh*0.08, function()
							world.setSimulationTimeScale(1-clamp((active*0.005)*(bleh/10),0,0.5))
						end)
					end
					Timeset = true
				else
					world.setSimulationTimeScale(1-clamp((active*0.005),0,0.5))
				end
			elseif Timeset then
				Timeset = false
				world.setSimulationTimeScale(1)
			end
		end
	}
}
