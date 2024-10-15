extends Node2D

var start_year: int = 2022
var total_number_of_turns: int = 10
var years_in_a_turn = 3

var demand_summer_list = []
var demand_winter_list = []
var year_list = []

var ups_list = {
	"170": 0, # SOLAR
	"171": 0, # WIND
	"186": 0, # GAS
	"189": 0, # WASTE
	"192": 0, # BIOMASS
	"175": 0, # BIOGAS
	"151": 0, # NUCLEAR
	"774": 0, # CARBON SEQ
	"163": 0, # HYDRO
	"162": 0, # RIVER
}

signal player_name_updated
signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer
signal imported_energy_amount_updated
signal land_use_updated
signal co2_emissions_updated
signal sequestrated_co2_updated(val: float)
signal most_recent_shock_updated
signal current_turn_updated
signal next_turn
signal show_ending_screen_requested
signal toggle_settings
signal toggle_graphs
signal toggle_credits
signal game_started
signal game_ended
signal game_quit_requested
signal enable_graphs_button
signal toggle_policies_window
signal hide_energy_bar_info_requested
signal testing_env_entered
# Emitted after the initial setup, like making the first request to the server.
# This indicates the player can now start playing and we can activate sounds or 
# other things that we couldn't activate before
signal player_can_start_playing_first_turn
signal available_money_message_requested(message: String, positiv: bool)
signal all_parameters_sent

# We need to send this signal because some translations 
# don't update automatically when changing the language at runtime,
# and only update when the tr() statement is called again.
# So we listen to this signal and call those statements again where needed.
# This signal is emitted in language_button.gd
signal locale_updated(locale: String)
signal player_can_start_playing_new_turn

var player_name: String = "":
	set(new_value):
		player_name = new_value
		player_name_updated.emit(player_name)
var demand_summer: float:
	set(new_value):
		demand_summer = new_value;
		energy_demand_updated_summer.emit(new_value)
var demand_winter: float:
	set(new_value):
		demand_winter = new_value
		energy_demand_updated_winter.emit(new_value)
var supply_summer: float:
	set(new_value):
		supply_summer = new_value
		energy_supply_updated_summer.emit(supply_summer)
var supply_winter: float:
	set(new_value):
		supply_winter = new_value
		energy_supply_updated_winter.emit(supply_winter)
var imported_energy_amount: float:
	set(new_value):
		imported_energy_amount = new_value
		imported_energy_amount_updated.emit(imported_energy_amount)
		MoneyManager.energy_import_cost_updated.emit(MoneyManager.energy_import_cost)
var land_use: float:
	set(new_value):
		land_use = new_value
		land_use_updated.emit(land_use)
var co2_emissions: float:
	set(new_value):
		co2_emissions = new_value
		co2_emissions_updated.emit(co2_emissions)
var most_recent_shock: Shock:
	set(new_value):
		most_recent_shock = new_value
		most_recent_shock_updated.emit(most_recent_shock)
var current_turn: int = 1:
	set(new_value):
		current_turn = new_value
		current_turn_updated.emit(current_turn)
var sequestrated_co2: float = 0.0:
	set(new_value):
		sequestrated_co2 = new_value
		sequestrated_co2_updated.emit(sequestrated_co2)
		co2_emissions_updated.emit(co2_emissions)
	
func _ready():
	Context.context_updated.connect(_on_first_request_finished)
	
	for i in total_number_of_turns + 1:
		year_list.append(start_year + (i * 3))
		
	next_turn.connect(_on_next_turn)
	#Context.http.request_completed.connect(_on_request_completed)
	
	# TODO get all the demands for each year for the graph (nice to have)
#func _on_request_completed(_result, _response_code, _headers, _body):
	#for year in year_list:
		#Context.get_context_from_model()
		#for i in Context.ctx:
			#if i["prm_id"] == "454":
				#Gameloop.demand_summer_list.append(float(i["tj"]) / 100)
			#if i["prm_id"] == "455":
				#Gameloop.demand_winter_list.append(float(i["tj"]) / 100)
		#await Context.http.request_completed

# Call this when play is pressed
func start_game():
	reset_all_values()
	game_started.emit()
	
	if player_name != "":
		if player_name == "new123":
			# This is our testing context
			testing_env_entered.emit()
			Context.res_id = 1
			Context.get_context_from_model(Context.res_id, 2022)
		else:
			Context.register_new_game_on_model(player_name) # New game in model
	else:
		# This should not happen
		printerr("A player name is needed")


func _check_supply():
	return supply_summer >= demand_summer and supply_winter + imported_energy_amount >= demand_winter


func _on_next_turn():
	print("next turn in gameloop")
	imported_energy_amount = 0
	MoneyManager.set_money_for_new_turn()
	ShockManager.pick_shock()
	ShockManager.apply_shock()


func _send_parameters_to_model(turn: int):
	print("===================================================================")
	for map_emplacement in get_tree().get_nodes_in_group("map_emplacements"):
		var history: MapEmplacementHistory = map_emplacement.history
		var history_for_this_turn: MapEmplacementTurnHistory = history.get_history_for_turn(turn)
		var what_happened: MapEmplacementHistory.PossibleActions = history.get_history_meaning(turn)

		match what_happened:
			MapEmplacementHistory.PossibleActions.NOTHING_HAPPENED:
				pass
			MapEmplacementHistory.PossibleActions.PP_BUILT:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_built
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				
				Gameloop.ups_list[plant_up_id] += metrics.cnv_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " built: ", metrics.cnv_capacity )
			MapEmplacementHistory.PossibleActions.PP_CONSTRUCTION_STARTED:
				pass
			MapEmplacementHistory.PossibleActions.PP_ACTIVATED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_activated
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				# Si la pp a été contruite, upgrade, puis éteinte, et réactivée
				# plus tard, on veut ajouter les upgrades
				var upgrades_capacity = metrics.current_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				
				Gameloop.ups_list[plant_up_id] += metrics.cnv_capacity + upgrades_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " activated: ", metrics.cnv_capacity + upgrades_capacity)
			MapEmplacementHistory.PossibleActions.PP_DEACTIVATED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_deactivated
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				var upgrades_capacity = metrics.current_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				
				Gameloop.ups_list[plant_up_id] -= metrics.cnv_capacity + upgrades_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " deactivated: ", metrics.cnv_capacity + upgrades_capacity)
			MapEmplacementHistory.PossibleActions.PP_UPGRADED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_upgraded
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				
				Gameloop.ups_list[plant_up_id] += history_for_this_turn.pp_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " upgraded: ", history_for_this_turn.pp_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity)
			MapEmplacementHistory.PossibleActions.PP_DOWNGRADED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_downgraded
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				
				Gameloop.ups_list[plant_up_id] += history_for_this_turn.pp_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " downgraded: ", history_for_this_turn.pp_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity)
			MapEmplacementHistory.PossibleActions.PP_BUILT_AND_UPGRADED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_upgraded
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				var upgrade_capacity = history_for_this_turn.pp_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				
				Gameloop.ups_list[plant_up_id] += metrics.cnv_capacity + upgrade_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " built_and_upgraded: ", metrics.cnv_capacity + upgrade_capacity)
			MapEmplacementHistory.PossibleActions.PP_ACTIVATED_AND_UPGRADED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_upgraded
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				var upgrade_capacity = metrics.current_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				
				Gameloop.ups_list[plant_up_id] += metrics.cnv_capacity + upgrade_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " activated_and_upgraded: ", metrics.cnv_capacity + upgrade_capacity)
			MapEmplacementHistory.PossibleActions.PP_ACTIVATED_AND_DOWNGRADED:
				var metrics: PowerplantMetrics = history_for_this_turn.metrics_when_downgraded
				var plant_up_id = PowerplantsManager.powerplants_ups_id[metrics.type]
				var upgrade_capacity = metrics.current_upgrade * metrics.upgrade_factor_for_winter_supply * metrics.cnv_capacity
				print("current upgrade:", metrics.current_upgrade)
				
				Gameloop.ups_list[plant_up_id] += metrics.cnv_capacity + upgrade_capacity
				print(PowerplantsManager.EngineTypeIds.keys()[metrics.type], " activated_and_downgraded: ", metrics.cnv_capacity + upgrade_capacity)
				
				
	print("sending next turn parameters")
	var j = 0
	for i in ups_list:
		if ups_list[i] != 0:
			print("\tsending ", PowerplantsManager.EngineTypeIds.keys()[j])
			Context.send_parameters_to_model(Context.res_id, 
					Gameloop.year_list[Gameloop.current_turn - 1], int(i),
					ups_list[i])
			print("\twaiting for ", PowerplantsManager.EngineTypeIds.keys()[j])
			await Context.parameters_sent_to_model
			print("\tdone_waiting for ", PowerplantsManager.EngineTypeIds.keys()[j])
			ups_list[i] = 0
		j += 1
	print("all sent")
	print("===================================================================")
	all_parameters_sent.emit()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			toggle_settings.emit()
			
			
func can_go_to_next_turn():
	return _check_supply()


func reset_all_values():
	demand_summer = 0
	demand_winter = 0
	supply_summer = 0
	supply_winter = 0
	imported_energy_amount = 0
	MoneyManager.borrowed_money_amount = 0
	MoneyManager.players_own_money_amount = MoneyManager.start_money
	land_use = 0
	co2_emissions = 0
	most_recent_shock = null
	current_turn = 1
	MoneyManager.powerplants_production_costs = 0
	MoneyManager.carbon_sequestration_production_costs = 0
	MoneyManager.production_costs_modifier = 1
	MoneyManager.building_costs = 0


func _on_first_request_finished(_context):
	TutorialManager.tutorial_started.emit()
	Context.context_updated.disconnect(_on_first_request_finished)
	
