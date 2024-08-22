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
	severe_weather.add_effect(func(): _severe_wether_prm_ups()) # E. Implement
	
	var inc_raw_cost_10 = Shock.new("SHOCK_INC_RAW_COST_10_TITLE", "SHOCK_INC_RAW_COST_10_TEXT", "money.png")
	inc_raw_cost_10.add_effect(func(): Gameloop.production_costs_modifier += 0.1)
	
	var inc_raw_cost_20 = Shock.new("SHOCK_INC_RAW_COST_20_TITLE", "SHOCK_INC_RAW_COST_20_TEXT", "money.png")
	inc_raw_cost_20.add_effect(func(): Gameloop.production_costs_modifier += 0.2)
	
	var dec_raw_cost_20 = Shock.new("SHOCK_DEC_RAW_COST_20_TITLE", "SHOCK_DEC_RAW_COST_20_TEXT", "receive.png")
	dec_raw_cost_20.add_effect(func(): Gameloop.production_costs_modifier -= 0.2)
	
	var mass_immigration = Shock.new("SHOCK_MASS_IMMIGRATION_TITLE", "SHOCK_MASS_IMMIGRATION_TEXT", "people.png")
	mass_immigration.add_effect(func(): Gameloop.demand_winter + 5)
	mass_immigration.add_effect(func(): Gameloop.demand_summer + 5)
	
	var renewable_support = Shock.new("SHOCK_RENEWABLE_SUPPORT_TITLE", "SHOCK_RENEWABLE_SUPPORT_TEXT", "flower.png")
	renewable_support.add_effect(func(): PolicyManager.personal_support += 0.1)
	
	
	var no_shock = Shock.new("SHOCK_NO_SHOCK_TITLE", "SHOCK_NO_SHOCK_TEXT", "sunrise.png", false)

	shocks = [cold_spell, heat_wave, glaciers_melting, severe_weather, no_shock, mass_immigration, renewable_support]
	shocks_full = shocks.duplicate()
	shocks.shuffle()
	
	
func pick_shock():
	# Nuclear reintro always happens in 2034, which is turn 5
	if Gameloop.current_turn == 5:
		var nuc_reintro = Shock.new("SHOCK_NUC_REINTRO_TITLE", "SHOCK_NUC_REINTRO_TEXT", "vote.png")
		nuc_reintro.add_player_reaction("SHOCK_NUC_REINTRO_PLAYER_REACTION_1", func(): _reintroduce_nuclear()) # E. Implement
		nuc_reintro.add_player_reaction("SHOCK_NUC_REINTRO_PLAYER_REACTION_2", func(): _leave_nuclear()) # E. Implement
		print("shock picked: ", nuc_reintro.title_key)
		Gameloop.most_recent_shock = nuc_reintro
	else:
		# Picks a random shock
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


func _reintroduce_nuclear():
	for pp in get_tree().get_nodes_in_group("PP"):
		if pp.is_nuclear():
			pp.life_span = 11
			pp.get_node("BuildInfo/ColorRect/LifeSpan").hide()
			pp._enable()

# Do nothing, nuclears will shut down as planned
func _leave_nuclear():
	pass
	
func _severe_wether_prm_ups():
		Context1.prm_id = 471 #solar availability
		Context1.yr = Gameloop.year_list[Gameloop.current_turn-1]
		Context1.tj = -0.1
		Context1.prm_ups()
		await Context1.http1.request_completed
		Context1.prm_id = 472 #solar availability
		Context1.yr = Gameloop.year_list[Gameloop.current_turn-1]
		Context1.tj = -0.1
		Context1.prm_ups()
		await Context1.http1.request_completed
		Context1.prm_id = 471 #solar availability
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		Context1.tj = 0.1
		Context1.prm_ups()
		await Context1.http1.request_completed
		Context1.prm_id = 472 #solar availability
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		Context1.tj = 0.1
		Context1.prm_ups()
		await Context1.http1.request_completed
