extends Node

var shocks: Array[Shock] = []
var shocks_full : Array[Shock] = []

func _ready():
	var cold_spell = Shock.new("SHOCK_COLD_SPELL_TITLE", "SHOCK_COLD_SPELL_TEXT", "cold.png")
	cold_spell.add_effect(func(): Gameloop.demand_winter += 5)
	cold_spell.add_requirements("SHOCK_COLD_SPELL_REQUIREMENT_MET",
			[func(): return Gameloop.supply_winter + Gameloop.imported_energy_amount >= Gameloop.demand_winter + 5],
			[func(): PolicyManager.personal_support += 0.05, func(): Gameloop.players_own_money_amount += 50]
		)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_1", func(): PolicyManager.personal_support -= 0.1)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_2", func(): print("gaz upgrade")) # E. Implement
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_3", func(): Gameloop.players_own_money_amount -= 50)
	
	var heat_wave: = Shock.new("SHOCK_HEAT_WAVE_TITLE", "SHOCK_HEAT_WAVE_TEXT", "hot.png")
	heat_wave.add_effect(func(): Gameloop.demand_summer += 5)
	heat_wave.add_requirements("SHOCK_HEAT_WAVE_REQUIREMENT_MET",
			[func():  return Gameloop.supply_summer >= Gameloop.demand_summer + 5],
			[func(): PolicyManager.personal_support += 0.05, func(): Gameloop.players_own_money_amount += 50]
		)
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_1", func(): PolicyManager.personal_support -= 0.1)
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_2", func(): print("gaz upgrade")) # E. Implement
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_3", func(): Gameloop.players_own_money_amount -= 50)
	
	var glaciers_melting = Shock.new("SHOCK_GLACIERS_MELTING_TITLE", "SHOCK_GLACIERS_MELTING_TEXT", "ice.png")
	glaciers_melting.add_effect(func(): print("decreasing hydraulic water supply")) # E. Implement
	
	var severe_weather = Shock.new("SHOCK_SEVERE_WEATHER_TITLE", "SHOCK_SEVERE_WEATHER_TEXT", "weather.png")
	severe_weather.add_effect(func(): print("decreasing wind and solar energy by 10%")) # E. Implement
	
	var inc_raw_cost_10 = Shock.new("SHOCK_INC_RAW_COST_10_TITLE", "SHOCK_INC_RAW_COST_10_TEXT", "money.png")
	inc_raw_cost_10.add_effect(func(): print("increasing production costs by 10%")) # E. Implement
	
	var inc_raw_cost_20 = Shock.new("SHOCK_INC_RAW_COST_20_TITLE", "SHOCK_INC_RAW_COST_20_TEXT", "money.png")
	inc_raw_cost_20.add_effect(func(): print("increasing production costs by 20%")) # E. Implement
	
	var dec_raw_cost_20 = Shock.new("SHOCK_DEC_RAW_COST_20_TITLE", "SHOCK_DEC_RAW_COST_20_TEXT", "receive.png")
	dec_raw_cost_20.add_effect(func(): print("decreasing production costs by 20%")) # E. Implement
	
	var mass_immigration = Shock.new("SHOCK_MASS_IMMIGRATION_TITLE", "SHOCK_MASS_IMMIGRATION_TEXT", "people.png")
	mass_immigration.add_effect(func(): Gameloop.demand_winter + 5)
	mass_immigration.add_effect(func(): Gameloop.demand_summer + 5)
	
	var renewable_support = Shock.new("SHOCK_RENEWABLE_SUPPORT_TITLE", "SHOCK_RENEWABLE_SUPPORT_TEXT", "flower.png")
	renewable_support.add_effect(func(): PolicyManager.personal_support += 0.1)
	
	var nuc_reintro = Shock.new("SHOCK_NUC_REINTRO_TITLE", "SHOCK_NUC_REINTRO_TEXT", "vote.png")
	nuc_reintro.add_player_reaction("SHOCK_NUC_REINTRO_PLAYER_REACTION_1", func(): print("Reintroduce nuclear power")) # E. Implement
	nuc_reintro.add_player_reaction("SHOCK_NUC_REINTRO_PLAYER_REACTION_2", func(): print("de-transition from nuclear power")) # E. Implement
	
	var no_shock = Shock.new("SHOCK_NO_SHOCK_TITLE", "SHOCK_NO_SHOCK_TEXT", "sunrise.png", false)

	shocks = [cold_spell, heat_wave, glaciers_melting, severe_weather, inc_raw_cost_10,
			inc_raw_cost_20, dec_raw_cost_20, no_shock, mass_immigration, renewable_support, nuc_reintro]
	shocks_full = shocks.duplicate()
	shocks.shuffle()
	
	
func pick_shock():
	if shocks.is_empty():
		shocks = shocks_full.duplicate()
		shocks.shuffle()
		
	var random_shock = shocks.pop_front()
	print("shock picked: ", random_shock.title_key)
	Gameloop.most_recent_shock = random_shock

func apply_shock():
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply()

func apply_reaction(reaction_index: int):
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply_reaction(reaction_index)
