extends Node2D

var start_year: int = 2022
var total_number_of_turns: int = 10
var years_in_a_turn = 3
var start_money: float = 700.0
var money_per_turn: float = 350.0
var debt_percentage_on_borrowed_money: float = 20.0

var demand_summer_list = []
var demand_winter_list = []
var year_list = []
var all_power_plants

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
}

signal player_name_updated

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer
signal imported_energy_amount_updated
signal borrowed_money_amount_updated
signal players_own_money_amount_updated
signal available_money_amount_updated
signal land_use_updated
signal co2_emissions_updated
signal most_recent_shock_updated
signal current_turn_updated
signal show_tutorial
signal powerplants_production_costs_updated
signal energy_import_cost_updated
signal building_costs_updated

signal next_turn
signal show_ending_screen_requested

signal toggle_settings
signal toggle_graphs
signal game_started
signal game_ended
signal game_quit_requested
signal enable_graphs_button
signal toggle_policies_window
signal tutorial_ended

signal hide_energy_bar_info_requested

# We need to send this signal because some translations 
# don't update automatically when changing the language at runtime,
# and only update when the tr() statement is called again.
# So we listen to this signal and call those statements again where needed.
# This signal is emitted in language_button.gd
signal locale_updated


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
var energy_import_cost: float:
	get:
		return imported_energy_amount * 2
var imported_energy_amount: float:
	set(new_value):
		imported_energy_amount = new_value
		imported_energy_amount_updated.emit(imported_energy_amount)
		energy_import_cost_updated.emit(energy_import_cost)
var borrowed_money_amount: float:
	set(new_value):
		borrowed_money_amount = new_value
		borrowed_money_amount_updated.emit(borrowed_money_amount)
		available_money_amount_updated.emit(available_money_amount)
var players_own_money_amount: float:
	set(new_value):
		players_own_money_amount = new_value
		players_own_money_amount_updated.emit(players_own_money_amount)
		available_money_amount_updated.emit(available_money_amount)
# This is a compute of all the money sources, minus costs. Do not set it
var available_money_amount: float:
	get:
		return players_own_money_amount + borrowed_money_amount - building_costs - powerplants_production_costs
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
var powerplants_production_costs: float:
	get:
		return powerplants_production_costs * production_costs_modifier
	set(new_value):
		powerplants_production_costs = new_value
		powerplants_production_costs_updated.emit(powerplants_production_costs)
		available_money_amount_updated.emit(available_money_amount)
var production_costs_modifier: float: # Shocks can affect this
	set(new_value):
		production_costs_modifier = new_value
		powerplants_production_costs_updated.emit(powerplants_production_costs)
		available_money_amount_updated.emit(available_money_amount)
var building_costs: float: # Costs of building and upgrading buildings
	set(new_value):
		building_costs = new_value
		building_costs_updated.emit(building_costs)
		available_money_amount_updated.emit(available_money_amount)
	
	
func _ready():	
	players_own_money_amount = start_money
	all_power_plants = get_tree().get_nodes_in_group("PP")
	for i in total_number_of_turns + 1:
		year_list.append(start_year + (i * 3))
		
	next_turn.connect(_on_next_turn)
	#Context1.http1.request_completed.connect(_on_request_completed)
	
	# TODO get all the demands for each year for the graph (nice to have)
#func _on_request_completed(_result, _response_code, _headers, _body):
	#for year in year_list:
		#Context1.yr = str(year)
		#Context1.get_ctx()
		#for i in Context1.ctx1:
			#if i["prm_id"] == "454":
				#Gameloop.demand_summer_list.append(float(i["tj"]) / 100)
			#if i["prm_id"] == "455":
				#Gameloop.demand_winter_list.append(float(i["tj"]) / 100)
		#await Context1.http1.request_completed

# Call this when play is pressed or the game is restarted
func start_game():
	reset_all_values()
	game_started.emit()
	
	if player_name != "":
		Context1.res_ins() # New game in model
	else:
		printerr("A player name is needed")
			
			
# Update everything that buildings affects like supply, emissions, land_use, etc.
func _update_buildings_impact():
	all_power_plants = get_tree().get_nodes_in_group("PP")
	var summer = 0
	var winter = 0
	var total_production_costs = 0
	var total_emissions = 0
	var total_land_use = 0
	for power_plant in all_power_plants:
		if power_plant.is_alive:
			summer += power_plant.capacity * power_plant.availability.x
			winter += power_plant.capacity * power_plant.availability.y
			total_production_costs += power_plant.production_cost
			total_emissions += power_plant.pollution
			total_land_use += power_plant.land_use
	supply_summer = summer
	supply_winter = winter
	powerplants_production_costs = total_production_costs
	co2_emissions = total_emissions
	land_use = total_land_use
	

func _check_supply():
	return supply_summer >= demand_summer and supply_winter + imported_energy_amount >= demand_winter


func _on_next_turn():
	Context1.yr = Gameloop.year_list[Gameloop.current_turn]
	_send_prm_ups()
	imported_energy_amount = 0
	set_money_for_new_turn()
	ShockManager.pick_shock()
	ShockManager.apply_shock()
	Context1.get_model_demand() #S. Not sure where to put this and the line doesnt update
	

func _send_prm_ups():
	for i in ups_list:
		if ups_list[i] != 0:
			Context1.prm_id = i
			Context1.yr = Gameloop.year_list[Gameloop.current_turn - 1]
			Context1.tj = ups_list[i]
			Context1.prm_ups()
			await Context1.http1.request_completed
			ups_list[i] = 0
		 

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			toggle_settings.emit()
			
			
func can_go_to_next_turn():
	return _check_supply()
	

func can_spend_the_money(money_to_spend: float):
	return money_to_spend <= available_money_amount

# Returns the money the player would have available on next turn
func get_money_for_next_turn() -> float:
	var income = players_own_money_amount + money_per_turn + borrowed_money_amount
	var outcome = borrowed_money_amount * (1.0 + (debt_percentage_on_borrowed_money / 100.0)) + energy_import_cost + building_costs + powerplants_production_costs
	
	return income - outcome
	
	
func set_money_for_new_turn():
	var income = players_own_money_amount + money_per_turn + borrowed_money_amount
	var outcome = borrowed_money_amount * (1.0 + (debt_percentage_on_borrowed_money / 100.0)) + building_costs + energy_import_cost
	players_own_money_amount = income - outcome
	borrowed_money_amount = 0
	building_costs = 0


func reset_all_values():
	demand_summer = 0
	demand_winter = 0
	supply_summer = 0
	supply_winter = 0
	imported_energy_amount = 0
	borrowed_money_amount = 0
	players_own_money_amount = start_money
	land_use = 0
	co2_emissions = 0
	most_recent_shock = null
	current_turn = 1
	powerplants_production_costs = 0
	production_costs_modifier = 1
	building_costs = 0
	Context1.yr = 2022
