extends Node

var shocks = {
	"cold_spell": {
		"name_key": "SHOCK_COLD_SPELL_NAME",
		"text_key": "SHOCK_COLD_SPELL_TEXT",
		"img": "cold",
		"reactions": {
			0: {
				"text_key" : "SHOCK_COLD_SPELL_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -10,
				}
			},
			1: {
				"text_key" : "SHOCK_COLD_SPELL_REACTION_2_TEXT",
				"effect": {
					"field": "gas_upgrade",
					"value": 2,
				}
			},
			2: {
				"text_key" : "SHOCK_COLD_SPELL_REACTION_3_TEXT",
				"effect" : {
					"field": "money",
					"value": -50
				}
			}
		},
		"reward": {
			"text_key": "SHOCK_COLD_SPELL_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 5,
				},
				1: {
					"field": "money",
					"value": 50
				}
			}
		}
	},
	"heat_wave": {
		"name_key": "SHOCK_HEAT_WAVE_NAME",
		"text_key": "SHOCK_HEAT_WAVE_TEXT",
		"img": "hot",
		"reactions": {
			0: {
				"text_key" : "SHOCK_HEAT_WAVE_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -15,
				}
			},
			1: {
				"text_key" : "SHOCK_HEAT_WAVE_REACTION_2_TEXT",
				"effect": {
					"field": "gas_upgrade",
					"value": 2,
				}
			},
			2: {
				"text_key" : "SHOCK_HEAT_WAVE_REACTION_3_TEXT",
				"effect" : {
					"field": "money",
					"value": -50
				}
			}
		},
		"reward": {
			"text_key": "SHOCK_HEAT_WAVE_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 5,
				},
				1: {
					"field": "money",
					"value": 50
				}
			}
		}
	},
	"glaciers_melting": {
		"name_key": "SHOCK_GLACIERS_MELTING_NAME",
		"text_key": "SHOCK_GLACIERS_MELTING_TEXT",
		"img": "ice",
		"reactions": {
			0: {
				"text_key" : "SHOCK_GLACIERS_MELTING_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": 0,
				}
			},
		},
		"reward": {
			"text_key": "SHOCK_GLACIERS_MELTING_REWARD_TEXT",
			"effects": {
				0: {
					"field": "money",
					"value": 0,
				},
				1: {
					"field": "env",
					"value": 0
				}
			}
		}
	},
	"severe_weather": {
		"name_key": "SHOCK_SEVERE_WEATHER_NAME",
		"text_key": "SHOCK_SEVERE_WEATHER_TEXT",
		"img": "weather",
		"reactions": {
			0: {
				"text_key" : "SHOCK_SEVERE_WEATHER_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -50,
				}
			},
		},
		"reward": {
			"text_key": "SHOCK_SEVERE_WEATHER_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 0,
				},
				1: {
					"field": "money",
					"value": 0
				}
			}
		}
	},
	"inc_raw_cost_10": {
		"name_key": "SHOCK_INC_RAW_COST_10_NAME",
		"text_key": "SHOCK_INC_RAW_COST_10_TEXT",
		"img": "money",
		"reactions": {
			0: {
				"text_key" : "SHOCK_INC_RAW_COST_10_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -50,
				}
			},
		},
		"reward": {
			"text_key": "SHOCK_INC_RAW_COST_10_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 0,
				},
				1: {
					"field": "money",
					"value": -20
				}
			}
		}
	},
	"inc_raw_cost_20": {
		"name_key": "SHOCK_INC_RAW_COST_20_NAME",
		"text_key": "SHOCK_INC_RAW_COST_20_TEXT",
		"img": "money",
		"reactions": {
			0: {
				"text_key" : "SHOCK_INC_RAW_COST_20_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -50,
				}
			},
		},
		"reward": {
			"text_key": "SHOCK_INC_RAW_COST_20_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 0,
				},
				1: {
					"field": "money",
					"value": -50
				}
			}
		}
	},
	"dec_raw_cost_20": {
		"name_key": "SHOCK_DEC_RAW_COST_20_NAME",
		"text_key": "SHOCK_DEC_RAW_COST_20_TEXT",
		"img": "receive",
		"reactions": {
			0: {
				"text_key" : "SHOCK_DEC_RAW_COST_20_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -50,
				}
			},
		},
		"reward": {
			"text_key": "SHOCK_DEC_RAW_COST_20_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 0,
				},
				1: {
					"field": "money",
					"value": 20
				}
			}
		}
	},
	"no_shock": {
		"name_key": "SHOCK_NO_SHOCK_NAME",
		"text_key": "SHOCK_NO_SHOCK_TEXT",
		"img": "sunrise",
		"reactions": {
			0: {
				"text_key" : "SHOCK_NO_SHOCK_REACTION_1_TEXT",
				"effect": {
					"field": "support",
					"value": -50,
				}
			},
		},
		"reward": {
			"text_key": "SHOCK_NO_SHOCK_REWARD_TEXT",
			"effects": {
				0: {
					"field": "support",
					"value": 0,
				},
				1: {
					"field": "money",
					"value": 0
				}
			}
		}
	},
	"mass_immigration": {},
	"nuc_accident": {},
	"renewables_support": {},
	"nuc_reintro": {}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
