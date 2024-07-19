extends Node

var shocks = {
	"cold_spell": {
		"name_key": "SHOCK_COLD_SPELL_NAME",
		"img": "cold",
	},
	"heat_wave": {
		"name_key": "SHOCK_HEAT_WAVE_NAME",
		"img": "hot",
	},
	"glaciers_melting": {
		"name_key": "SHOCK_GLACIERS_MELTING_NAME",
		"img": "ice",
	},
	"severe_weather": {
		"name_key": "SHOCK_SEVERE_WEATHER_NAME",
		"img": "weather",
	},
	"inc_raw_cost_10": {
		"name_key": "SHOCK_INC_RAW_COST_10_NAME",
		"img": "money",
	},
	"inc_raw_cost_20": {
		"name_key": "SHOCK_INC_RAW_COST_20_NAME",
		"img": "money",
	},
	"dec_raw_cost_20": {
		"name_key": "SHOCK_DEC_RAW_COST_20_NAME",
		"img": "receive",
	},
	"no_shock": {
		"name_key": "SHOCK_NO_SHOCK_NAME",
		"img": "sunrise",
	},
	"mass_immigration": {
		"name_key": "SHOCK_MASS_IMMIGRATION_NAME",
		"img": "people",
	},
	"renewable_support": {
		"name_key": "SHOCK_RENEWABLE_SUPPORT_NAME",
		"img": "cold",
	},
	"nuc_reintro": {
		"name_key": "SHOCK_NUC_REINTRO_NAME",
		"img": "vote",
	}
}

func draw_random_shock():
	return shocks.values()[randi() % shocks.size()]
