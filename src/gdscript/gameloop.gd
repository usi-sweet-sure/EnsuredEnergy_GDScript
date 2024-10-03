extends Node2D

var start_year: int = 2022
var total_number_of_turns: int = 10
var years_in_a_turn = 3

var demand_summer_list = []
var demand_winter_list = []
var year_list = []

var ups_list = {
	"186": 0, # GAS
	"151": 0, # NUCLEAR
	"162": 0, # RIVER
	"163": 0, # HYDRO
	"189": 0, # WASTE
	"192": 0, # BIOMASS
	"170": 0, # SOLAR
	"171": 0, # WIND
	"175": 0, # BIOGAS
	"774": 0, # CARBON SEQ
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
signal game_started
signal game_ended
signal game_quit_requested
signal enable_graphs_button
signal toggle_policies_window
signal hide_energy_bar_info_requested
signal testing_env_entered
signal first_model_request_ended()

# We need to send this signal because some translations 
# don't update automatically when changing the language at runtime,
# and only update when the tr() statement is called again.
# So we listen to this signal and call those statements again where needed.
# This signal is emitted in language_button.gd
signal locale_updated(locale: String)


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
	Context.http.request_completed.connect(_on_first_request_finished)
	
	for i in total_number_of_turns + 1:
		year_list.append(start_year + (i * 3))
		
	next_turn.connect(_on_next_turn)
	#Context.http.request_completed.connect(_on_request_completed)
	
	# TODO get all the demands for each year for the graph (nice to have)
#func _on_request_completed(_result, _response_code, _headers, _body):
	#for year in year_list:
		#Context.yr = str(year)
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
			Context.yr = 2022
			Context.prm_id = 186
			Context.tj = 8000
			Context.get_context_from_model()
		else:
			Context.register_new_game_on_model() # New game in model
	else:
		# This should not happen
		printerr("A player name is needed")


func _check_supply():
	return supply_summer >= demand_summer and supply_winter + imported_energy_amount >= demand_winter


func _on_next_turn():
	Context.yr = Gameloop.year_list[Gameloop.current_turn]
	#_send_send_parameters_to_model()
	imported_energy_amount = 0
	MoneyManager.set_money_for_new_turn()
	ShockManager.pick_shock()
	ShockManager.apply_shock()
	#Context.get_demand_from_model() #S. Not sure where to put this and the line doesnt update
	

func _send_send_parameters_to_model():
	for i in ups_list:
		if ups_list[i] != 0:
			Context.prm_id = i
			Context.yr = Gameloop.year_list[Gameloop.current_turn - 1]
			Context.tj = ups_list[i]
			Context.send_parameters_to_model()
			await Context.http.request_completed
			ups_list[i] = 0
		 

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
	Context.yr = 2022


func _on_first_request_finished(_result, _response_code, _headers, _body):
	TutorialManager.tutorial_started.emit()
	first_model_request_ended.emit()
	Context.http.request_completed.disconnect(_on_first_request_finished)
