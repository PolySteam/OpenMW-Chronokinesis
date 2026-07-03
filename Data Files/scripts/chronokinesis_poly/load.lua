local content = require('openmw.content')

content.magicEffects.records.chronokinesis_poly = {
	template = content.magicEffects.records.detectenchantment,
	name = "Chronokinesis",
	description	= "Difficult and albeit dangerous spell allowing you to manipulate perceived time.",
	hitStatic = "vfx_mysticismarea",
	baseCost = 10,
	allowsSpellmaking = true,
	allowsEnchanting = true,
	hasMagnitude = true,
	hasDuration = true,
}

content.spells.records.chronokinesis_poly_natural = {
	name = "Magnus' True Perception",
	type = content.spells.TYPE.Spell,
	cost = 500,
	isAutocalc = true,
	effects = {
		{
			id = 'chronokinesis_poly',
			range = content.RANGE.Self,
			area = 0,
			duration = 5,
			magnitudeMin = 100,
			magnitudeMax = 100,
		},
	},
}

content.spells.records.chronokinesis_poly_premade = {
	name = "Kagrenac's Chronokinetic Muse",
	type = content.spells.TYPE.Spell,
	cost = 100,
	isAutocalc = true,
	effects = {
		{
			id = 'chronokinesis_poly',
			range = content.RANGE.Self,
			area = 0,
			duration = 10,
			magnitudeMin = 50,
			magnitudeMax = 50,
		},
	},
}

