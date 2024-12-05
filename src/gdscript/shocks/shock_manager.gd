extends Node

signal shock_resolved
signal shock_effects_applied
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
var to_do_on_next_turn: Array[Callable] = []


func _ready():
	shock_button_entered.connect(_on_shock_button_entered)
	shock_button_exited.connect(_on_shock_button_exited)
	
	var cold_spell = Shock.new("SHOCK_COLD_SPELL_TITLE", "SHOCK_COLD_SPELL_TEXT", "res://assets/textures/shocks/cold_spell.png")
	cold_spell.add_effect(func(): increase_demand(false))
	cold_spell.add_requirements("SHOCK_COLD_SPELL_REQUIREMENT_MET",
			[func(): return Gameloop.supply_winter + Gameloop.imported_energy_amount >= Gameloop.demand_winter + 5],
			[func(): PolicyManager.personal_support += 0.05, func(): MoneyManager.players_own_money_amount += 50]
		)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_1", func(): PolicyManager.personal_support -= 0.1)
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_2", func(): pass) # E. Implement gaz upgrade
	cold_spell.add_player_reaction("SHOCK_COLD_SPELL_PLAYER_REACTION_3", func(): MoneyManager.players_own_money_amount -= 50)
	
	var heat_wave: = Shock.new("SHOCK_HEAT_WAVE_TITLE", "SHOCK_HEAT_WAVE_TEXT", "res://assets/textures/shocks/heat_wave.png")
	heat_wave.add_effect(func(): increase_demand(false))
	heat_wave.add_requirements("SHOCK_HEAT_WAVE_REQUIREMENT_MET",
			[func():  return Gameloop.supply_summer >= Gameloop.demand_summer + ((Gameloop.demand_summer / 100.0) * 5.00)],
			[func(): PolicyManager.personal_support += 0.05, func(): MoneyManager.players_own_money_amount += 50]
		)
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_1", func(): PolicyManager.personal_support -= 0.1)
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_2", func(): pass) # E. Implement gaz upgrade
	heat_wave.add_player_reaction("SHOCK_HEAT_WAVE_PLAYER_REACTION_3", func(): MoneyManager.players_own_money_amount -= 50)
	
	var glaciers_melting_shock = Shock.new("SHOCK_GLACIERS_MELTING_TITLE", "SHOCK_GLACIERS_MELTING_TEXT", "res://assets/textures/shocks/glacier_melting.png")
	glaciers_melting_shock.add_effect(func(): glaciers_melting())
	
	var severe_weather = Shock.new("SHOCK_SEVERE_WEATHER_TITLE", "SHOCK_SEVERE_WEATHER_TEXT",
		"res://assets/textures/shocks/severe_weather.png",
		true,
		[
			{"type": PowerplantsManager.EngineTypeIds.SOLAR, "text_key": "SHOCK_SEVERE_WEATHER_EFFECT_SOLAR"},
			{"type": PowerplantsManager.EngineTypeIds.WIND, "text_key": "SHOCK_SEVERE_WEATHER_EFFECT_WIND"}
		])
		
	severe_weather.add_effect(func(): _severe_wether_send_parameters_to_model())
	
	var inc_raw_cost_10 = Shock.new("SHOCK_INC_RAW_COST_10_TITLE", "SHOCK_INC_RAW_COST_10_TEXT", "")
	inc_raw_cost_10.add_effect(func(): update_prod_cost_modifier(0.1))
	
	var inc_raw_cost_20 = Shock.new("SHOCK_INC_RAW_COST_20_TITLE", "SHOCK_INC_RAW_COST_20_TEXT", "")
	inc_raw_cost_20.add_effect(func(): update_prod_cost_modifier(0.2))
	
	var dec_raw_cost_20 = Shock.new("SHOCK_DEC_RAW_COST_20_TITLE", "SHOCK_DEC_RAW_COST_20_TEXT", "")
	dec_raw_cost_20.add_effect(func(): update_prod_cost_modifier(-0.2))
	
	var mass_immigration = Shock.new("SHOCK_MASS_IMMIGRATION_TITLE", "SHOCK_MASS_IMMIGRATION_TEXT", "")
	mass_immigration.add_effect(func(): increase_demand(true))
	
	var renewable_support = Shock.new("SHOCK_RENEWABLE_SUPPORT_TITLE", "SHOCK_RENEWABLE_SUPPORT_TEXT", "res://assets/textures/shocks/renewable_support.png")
	renewable_support.add_effect(func(): update_personal_support(0.1))
	
	
	var no_shock_shock = Shock.new("SHOCK_NO_SHOCK_TITLE", "SHOCK_NO_SHOCK_TEXT", "", false)
	no_shock_shock.add_effect(func(): no_shock())
	
	shocks = [cold_spell, heat_wave, glaciers_melting_shock, no_shock_shock, severe_weather, renewable_support]
	shocks_full = shocks.duplicate()
	shocks.shuffle()
	
	Gameloop.next_turn.connect(_on_next_turn)
	Gameloop.player_can_start_playing_new_turn.connect(_on_player_can_start_playing_new_turn)
	
	
func pick_shock():
	# Nuclear reintro always happens in 2034, which is turn 5
	if Gameloop.current_turn == 5:
		var nuc_reintro_shock = Shock.new("SHOCK_NUC_REINTRO_TITLE", "SHOCK_NUC_REINTRO_TEXT", "res://assets/textures/shocks/nuclear_reintro_yes.png")
		nuc_reintro_shock.add_effect(func(): nuc_reintro())
		nuc_reintro_shock.add_player_reaction("SHOCK_NUC_REINTRO_PLAYER_REACTION_1", func(): _reintroduce_nuclear())
		nuc_reintro_shock.add_player_reaction("SHOCK_NUC_REINTRO_PLAYER_REACTION_2", func(): _leave_nuclear())
		Gameloop.most_recent_shock = nuc_reintro_shock
	else:
		# Picks a random shock
		if shocks.is_empty():
			shocks = shocks_full.duplicate()
			shocks.shuffle()
			
		var random_shock = shocks.pop_front()
		random_shock.turn_picked = Gameloop.current_turn
		Gameloop.most_recent_shock = random_shock
		
		# Graph button is enable on turn 2, but on a new turn the shock window
		# hides the middle of the screen. So we trigger the apparition of the
		# graph button when the player clicks on the "continue" button of the
		# shock window (which hides the shock window).
		# But if the shock is the "no_shock", no frame is shown, so we trigger
		# the apparition of the graph button directly.
		# We wait 2 sec for the clock animation to finish
		if Gameloop.current_turn == 2 and not random_shock.show_shock_window:
			get_tree().create_timer(2).timeout.connect(func(): Gameloop.enable_graphs_button.emit())
		

func apply_shock():
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply()


func apply_reaction(reaction_index: int):
	if Gameloop.most_recent_shock != null:
		Gameloop.most_recent_shock.apply_reaction(reaction_index)
		

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
	
	
func increase_demand(longterm: bool):
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	Context.send_shock_parameters(Context.res_id, 1, year)
	await Context.shocks_sent_to_model
	#Context.get_demand_from_context()
	
	if !longterm:
		year += 1 # TO CHECK!!
		Context.send_shock_parameters(Context.res_id, 2, year)
		await Context.shocks_sent_to_model
	
	
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)
	
	
func _severe_wether_send_parameters_to_model():
	# Update already built pps metrics
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")

	# Update already built pps metrics
	for powerplant: PpScene in powerplants:
		var metrics: PowerplantMetrics = powerplant.metrics
		if powerplant.is_solar() or powerplant.is_wind():
			powerplant.metrics_backup = metrics.copy()
			metrics.availability *= Vector2(0.5, 0.5)
			powerplant.metrics_updated.emit(metrics)
			
	# Update pps that will build this turn
	var pps_in_construction = get_tree().get_nodes_in_group("BbsInConstruction")
	
	for pp in pps_in_construction:
		# All builds buttons are instanciated at launch and are juste hidden,
		# so if no pp is in construction on that map emplacement,
		# the metrics are null
		if pp.metrics != null:
			# pp will build this turn
			if pp.metrics.construction_started_on_turn + pp.metrics.build_time_in_turns == Gameloop.current_turn:
				if pp.metrics.type == PowerplantsManager.EngineTypeIds.SOLAR or pp.metrics.type == PowerplantsManager.EngineTypeIds.WIND:
					pp.metrics.availability *= Vector2(0.5, 0.5)
			
	
	# Update base metrics for futur buildings, but not if they take time to build
	# since the changes will be reverted anyway on next turn
	PowerplantsManager.backup_metrics()
	for metrics: PowerplantMetrics in PowerplantsManager.powerplants_metrics:
		if metrics.type == PowerplantsManager.EngineTypeIds.SOLAR or metrics.type == PowerplantsManager.EngineTypeIds.WIND and metrics.build_time_in_turns == 0:
			metrics.availability *= Vector2(0.5, 0.5)
			
	PowerplantsManager.update_buildings_impact()
	
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	Context.send_parameters_to_model(Context.res_id, year, 471, -0.2)
	await Context.parameters_sent_to_model
	Context.send_parameters_to_model(Context.res_id, year, 472, -0.2)
	await Context.parameters_sent_to_model
	year += 1 # TO CHECK !!
	Context.send_parameters_to_model(Context.res_id, year, 471, 0.2)
	await Context.parameters_sent_to_model
	Context.send_parameters_to_model(Context.res_id, year, 472, 0.2)
	await Context.parameters_sent_to_model
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)


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


 # E. Implement
func glaciers_melting():
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)


func update_prod_cost_modifier(val: float):
	MoneyManager.production_costs_modifier += val
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)
	

func update_personal_support(val: float):
	PolicyManager.personal_support += val
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)


func no_shock():
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)


func nuc_reintro():
	ShockManager.shock_effects_applied.emit(Gameloop.most_recent_shock)


# Some shocks modify the state of the game for one turn only. This can be
# used to revert them
func _on_next_turn():
	for callable in to_do_on_next_turn:
		callable.call()
	
	to_do_on_next_turn = []
	

func _revert_severe_weather():
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")
	
	# Revert base metrics for futur buildings
	PowerplantsManager.rollback_metrics()
	
	# Revert already built pps metrics
	for powerplant: PpScene in powerplants:
		if powerplant.is_solar() or powerplant.is_wind():
			
			# We will be rolling back the metrics, but want to keep changes made
			# by the user
			var current_upgrade = powerplant.metrics.current_upgrade
			var active = powerplant.metrics.active
			var built_on_turn = powerplant.metrics.built_on_turn
			var production_costs = powerplant.metrics.production_costs
			var land_use = powerplant.metrics.land_use
			var emissions = powerplant.metrics.emissions
			
			if powerplant.metrics_backup == null:
				# The pp was built during the shock, and has no backup. We can read
				# the base metrics instead
				powerplant.metrics = PowerplantsManager.powerplants_metrics[powerplant.metrics.type].copy()
			else:
				powerplant.metrics = powerplant.metrics_backup.copy()
				powerplant.metrics_backup = null
			
			powerplant.metrics.current_upgrade = current_upgrade
			powerplant.metrics.active = active
			powerplant.metrics.built_on_turn = built_on_turn
			powerplant.metrics.production_costs = production_costs
			powerplant.metrics.land_use = land_use
			powerplant.metrics.emissions = emissions
			
			# Severe weather changed availability. If the pp was upgraded, we have
			# to upgrade it accordingly
			var base_metrics = PowerplantsManager.powerplants_metrics[powerplant.metrics.type]
			powerplant.metrics.availability.y = base_metrics.availability.y + (base_metrics.availability.y * powerplant.metrics.upgrade_factor_for_winter_supply * current_upgrade)
			powerplant.metrics.availability.x = base_metrics.availability.x + (base_metrics.availability.x * powerplant.metrics.upgrade_factor_for_summer_supply * current_upgrade)
			powerplant.metrics_updated.emit(powerplant.metrics)
			
			
			PowerplantsManager.update_buildings_impact()
		
		
func _on_player_can_start_playing_new_turn():
	if Gameloop.most_recent_shock.title_key == "SHOCK_SEVERE_WEATHER_TITLE":
		to_do_on_next_turn.push_back(_revert_severe_weather)
	
