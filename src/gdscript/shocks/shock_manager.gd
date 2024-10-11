extends Node

signal shock_resolved
signal toggle_shock_buttons
signal shock_button_entered
signal shock_button_exited

var shocks: Array[Shock] = []
var shocks_full : Array[Shock] = []

var household_demand: float
var industry_demand: float
var service_demand: float
var transport_demand: float
var agriculture_demand: float
var shock_buttons_hovered: Array[Shock] = []


func _ready():
	shock_button_entered.connect(_on_shock_button_entered)
	shock_button_exited.connect(_on_shock_button_exited)
	
	var cold_spell = Shock.new("SHOCK_COLD_SPELL_TITLE", "SHOCK_COLD_SPELL_TEXT", "cold.png")
	cold_spell.add_effect(func(): increase_demand(false))
	cold_spell.add_requirements("SHOCK_COLD_SPELL_REQUIREMENT_MET",
			[func(): return Gameloop.supply_winter + Gameloop.imported_energy_amount >= Gameloop.demand_winter + 5],
			[func(): PolicyManager.personal_support += 0.05, func(): MoneyManager.players_own_money_amount += 50]
		)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_1", func(): PolicyManager.personal_support -= 0.1)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_2", func(): print("gaz upgrade")) # E. Implement
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_3", func(): MoneyManager.players_own_money_amount -= 50)
	
	var heat_wave: = Shock.new("SHOCK_HEAT_WAVE_TITLE", "SHOCK_HEAT_WAVE_TEXT", "hot.png")
	heat_wave.add_effect(func(): increase_demand(false))
	heat_wave.add_requirements("SHOCK_HEAT_WAVE_REQUIREMENT_MET",
			[func():  return Gameloop.supply_summer >= Gameloop.demand_summer + 5],
			[func(): PolicyManager.personal_support += 0.05, func(): MoneyManager.players_own_money_amount += 50]
		)
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_1", func(): PolicyManager.personal_support -= 0.1)
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_2", func(): print("gaz upgrade")) # E. Implement
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_3", func(): MoneyManager.players_own_money_amount -= 50)
	
	var glaciers_melting = Shock.new("SHOCK_GLACIERS_MELTING_TITLE", "SHOCK_GLACIERS_MELTING_TEXT", "ice.png")
	glaciers_melting.add_effect(func(): print("decreasing hydraulic water supply")) # E. Implement
	
	var severe_weather = Shock.new("SHOCK_SEVERE_WEATHER_TITLE", "SHOCK_SEVERE_WEATHER_TEXT", "weather.png")
	severe_weather.add_effect(func(): _severe_wether_send_parameters_to_model()) # E. Implement
	
	var inc_raw_cost_10 = Shock.new("SHOCK_INC_RAW_COST_10_TITLE", "SHOCK_INC_RAW_COST_10_TEXT", "money.png")
	inc_raw_cost_10.add_effect(func(): MoneyManager.production_costs_modifier += 0.1)
	
	var inc_raw_cost_20 = Shock.new("SHOCK_INC_RAW_COST_20_TITLE", "SHOCK_INC_RAW_COST_20_TEXT", "money.png")
	inc_raw_cost_20.add_effect(func(): MoneyManager.production_costs_modifier += 0.2)
	
	var dec_raw_cost_20 = Shock.new("SHOCK_DEC_RAW_COST_20_TITLE", "SHOCK_DEC_RAW_COST_20_TEXT", "receive.png")
	dec_raw_cost_20.add_effect(func(): MoneyManager.production_costs_modifier -= 0.2)
	
	var mass_immigration = Shock.new("SHOCK_MASS_IMMIGRATION_TITLE", "SHOCK_MASS_IMMIGRATION_TEXT", "people.png")
	mass_immigration.add_effect(func(): increase_demand(true))
	
	var renewable_support = Shock.new("SHOCK_RENEWABLE_SUPPORT_TITLE", "SHOCK_RENEWABLE_SUPPORT_TEXT", "flower.png")
	renewable_support.add_effect(func(): PolicyManager.personal_support += 0.1)
	
	
	var no_shock = Shock.new("SHOCK_NO_SHOCK_TITLE", "SHOCK_NO_SHOCK_TEXT", "sunrise.png", false)

	shocks = [cold_spell, heat_wave, glaciers_melting, no_shock, severe_weather, renewable_support]
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
		random_shock.turn_picked = Gameloop.current_turn
		Gameloop.most_recent_shock = random_shock
		
		# Graph button is enable on turn 2, but on a new turn the shock window
		# hides the middle of the screen. So we trigger the apparition of the
		# graph button when the player clicks on the "continue" button of the
		# shock window (which hides the shock window).
		# But if the shock is the "no_shock", no frame is shown, so we trigger
		# the apparition of the graph button directly
		if Gameloop.current_turn == 2 and not random_shock.show_shock_window:
			Gameloop.enable_graphs_button.emit()


func apply_shock():
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply()


func apply_reaction(reaction_index: int):
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply_reaction(reaction_index)
		
		var requirements_met_text = ""
		
		if Gameloop.most_recent_shock.met_requirements_conditions_when_picked:
			requirements_met_text = Gameloop.most_recent_shock.requirements_met_text_key


func _reintroduce_nuclear():
	for pp in get_tree().get_nodes_in_group("Powerplants"):
		if pp.is_nuclear():
			pp.metrics.life_span_in_turns = 11
			pp.metrics.can_activate = true
			pp.activate(false)
			pp.metrics_updated.emit(pp.metrics)
			

# Do nothing, nuclears will shut down as planned
func _leave_nuclear():
	pass
	
# sorry for the ugly code
func increase_demand(longterm: bool):
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	Context.send_shock_parameters(Context.res_id, 1, year)
	

	
	
func _severe_wether_send_parameters_to_model():
	await Context.parameters_sent_to_model
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	Context.send_parameters_to_model(Context.res_id, year, 471, -0.1)
	await Context.parameters_sent_to_model
	Context.send_parameters_to_model(Context.res_id, year, 472, -0.1)
	await Context.parameters_sent_to_model
	year = Gameloop.year_list[Gameloop.current_turn]
	Context.send_parameters_to_model(Context.res_id, year, 471, 0.1)
	await Context.parameters_sent_to_model
	Context.send_parameters_to_model(Context.res_id, year, 472, 0.1)


func _on_shock_button_entered(shock: Shock):
	shock_buttons_hovered.push_back(shock)


func _on_shock_button_exited(shock: Shock):
	var index = 0
	
	await get_tree().create_timer(0.4).timeout
	
	for button in shock_buttons_hovered:
		if button.title_key == shock.title_key:
			shock_buttons_hovered.remove_at(index)
			break
		index += 1
		
	if shock_buttons_hovered.size() == 0:
		toggle_shock_buttons.emit(false)
