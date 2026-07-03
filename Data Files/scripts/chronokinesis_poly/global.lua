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
				local nx = math.min(active / 100, 1)
				local timescale = 1 - 0.5 * (nx * nx)
				world.setSimulationTimeScale(timescale)
				if not Timeset then
					Timeset = true
				end
			elseif Timeset then
				Timeset = false
				world.setSimulationTimeScale(1)
			end
		end
	}
}
