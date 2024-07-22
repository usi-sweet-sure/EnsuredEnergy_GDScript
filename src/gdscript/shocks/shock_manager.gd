extends Node

var shocks: Array[Shock] = []

func _ready():
	var cold_spell = Shock.new("SHOCK_COLD_SPELL_TITLE", "SHOCK_COLD_SPELL_TEXT", "cold.png")
	cold_spell.add_effect(func(): Gameloop.demand_winter += 5)
	cold_spell.add_requirements("SHOCK_COLD_SPELL_REQUIREMENT_MET",
			[func(): return Gameloop.supply_winter + Gameloop.imported_energy_amount >= Gameloop.demand_winter + 5],
			[func(): print("Support + 5"), func(): Gameloop.players_own_money += 50] # E. implement
		)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_1", func(): print("Support -10")) # E. Implement
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_2", func(): print("gaz upgrade")) # E. Implement
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_3", func(): Gameloop.players_own_money_amount -= 50)
	
	var	heat_wave: = Shock.new("SHOCK_HEAT_WAVE_TITLE", "SHOCK_HEAT_WAVE_TEXT", "hot.png")
	var glaciers_melting = Shock.new("SHOCK_GLACIERS_MELTING_TITLE", "SHOCK_GLACIERS_MELTING_TEXT", "ice.png")
	var severe_weather = Shock.new("SHOCK_SEVERE_WEATHER_TITLE", "SHOCK_SEVERE_WEATHER_TEXT", "weathe.pngr")
	var inc_raw_cost_10 = Shock.new("SHOCK_INC_RAW_COST_10_TITLE", "SHOCK_INC_RAW_COST_10_TEXT", "money.png")
	var inc_raw_cost_20 = Shock.new("SHOCK_INC_RAW_COST_20_TITLE", "SHOCK_INC_RAW_COST_20_TEXT", "money.png")
	var dec_raw_cost_20 = Shock.new("SHOCK_DEC_RAW_COST_20_TITLE", "SHOCK_DEC_RAW_COST_20_TEXT", "receive.png")
	var no_shock = Shock.new("SHOCK_NO_SHOCK_TITLE", "SHOCK_NO_SHOCK_TEXT", "sunrise.png", false)
	var mass_immigration = Shock.new("SHOCK_MASS_IMMIGRATION_TITLE", "SHOCK_MASS_IMMIGRATION_TEXT", "people.png")
	var renewable_support = Shock.new("SHOCK_RENEWABLE_SUPPORT_TITLE", "SHOCK_RENEWABLE_SUPPORTL_TEXT", "flower.png")
	var nuc_reintro = Shock.new("SHOCK_NUC_REINTRO_TITLE", "SHOCK_NUC_REINTRO_TEXT", "vote.png")

	shocks = [cold_spell, heat_wave, glaciers_melting, severe_weather, inc_raw_cost_10,
			inc_raw_cost_20, dec_raw_cost_20, no_shock, mass_immigration, renewable_support, nuc_reintro]
	
	
func pick_shock():
	#var new_shock = shocks[randi() % shocks.size()]
	var new_shock = shocks[0]
	print("shock picked: ", new_shock.title_key)
	Gameloop.most_recent_shock = new_shock

func apply_shock():
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply()

func apply_reaction(reaction_index: int):
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply_reaction(reaction_index)
