extends Node

# Stores all the data needed for the graphs.
# This is a dictionnary of the form
# data = {
#	 "name" = {
#		 2022 = 100.0,
#		 2023 = 140.0,
#		 ...
#		 },
#	 "name" = {
#		 2022 = 200.0,
#		 2023 = 350.0,
#		 ...
#		 },
# }
# This is tightly linked to the fact we know x-axis will always display years.
# If this changes, adapt the data accordingly.
# It's only needed that "get_data_set" returns a dictionnary of the form
# {
#		"points" = {
#			x: float = y: float,
#			x = y,
#			...
#		},
#		"unit" = "CHF"
# }
# "graphs_window.gd" takes care of everything, so x and y have to be the real
# values you want to display, nothing else to do appart from setting axis values
# in "graphs_window.gd" context that matches the scale of the values you want to display.
var data = {}
# This is a dictionnary of the form
# units = {
#	 "name" = "unit",
#	 "name" = "unit",
# }
var units = {}
var turn_to_register_data_in = 0
# This is used to stop listenening to events when we don't want to overwrite data,
# typically on a new turn when imported energy is set back to zero, it will erase
# what the player imported during the turn that is ending
var listening = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_new_data_set("summer_demand", " TJ")
	_add_new_data_set("winter_demand", " TJ")
	_add_new_data_set("building_costs", "M CHF")
	_add_new_data_set("production_costs", "M CHF")
	_add_new_data_set("import_costs", "M CHF")
	_add_new_data_set("borrowed_money", "M CHF")
	_add_new_data_set("available_money", "M CHF")
	_add_new_data_set("winter_energy_supply", " TJ")
	_add_new_data_set("summer_energy_supply", " TJ")
	_add_new_data_set("winter_energy_import", " TJ")
	_add_new_data_set("land_use", " Km2")
	_add_new_data_set("co2_emissions", "M CO2/t")
	_add_new_data_set("personal_support", " %")
	
	MoneyManager.building_costs_updated.connect(_on_building_cost_updated)
	MoneyManager.total_production_costs_updated.connect(_on_production_cost_updated)
	MoneyManager.energy_import_cost_updated.connect(_on_import_cost_updated)
	MoneyManager.borrowed_money_amount_updated.connect(_on_borrowed_money_updated)
	MoneyManager.available_money_amount_updated.connect(_on_available_money_updated)
	Gameloop.energy_supply_updated_winter.connect(_on_winter_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_summer_energy_supply_updated)
	Gameloop.imported_energy_amount_updated.connect(_on_winter_energy_import_updated)
	Gameloop.land_use_updated.connect(_on_land_use_updated)
	Gameloop.energy_demand_updated_summer.connect(_on_summer_energy_demand_updated)
	Gameloop.energy_demand_updated_winter.connect(_on_winter_energy_demand_updated)
	Gameloop.co2_emissions_updated.connect(_on_co2_emissions_updated)
	PolicyManager.personal_support_updated.connect(_on_personnal_support_updated)
	
	Gameloop.next_turn_button_pressed.connect(_on_next_turn_button_pressed)
	Gameloop.player_can_start_playing_new_turn.connect(_set_new_turn_data)
	Gameloop.player_can_start_playing_first_turn.connect(_on_player_can_start_playing_first_turn)
	

# Must return a dictionnary of the form
#	{
#		x: float = y: float,
#		x = y,
#		...
#	}
func get_data_set(key_name: String) -> Dictionary:
	_add_new_data_set(key_name, "") # Initializes empty data if needed
	return {
		"points" = data[key_name],
		"unit" = units[key_name]
	}


func _add_new_data_set(key_name: String, unit: String):
	if not data.has(key_name):
		data[key_name] = {}
		
	if not units.has(key_name):
		units[key_name] = unit
		
		
# This is used on a new turn. Some data don't change when a new turn
# starts, but we want to to draw a point for that turn right away
func _set_new_turn_data():
	turn_to_register_data_in = Gameloop.current_turn
	listening = true
	_refresh_data()


# The initial state of 2022 is registered in the data,
# now every changes made by the player are registered for the year of the next turn
func _on_player_can_start_playing_first_turn():
	# Set 2022 initial state that can't be changed
	turn_to_register_data_in = 0
	listening = true
	_refresh_data()
	
	# Set initial 2025 state, that can be changed by the player during first turn
	# (changes during the first turn are made for the span 2022-2025, and the point
	# moving is on 2025 on the graph)
	turn_to_register_data_in = Gameloop.current_turn
	_refresh_data()
	

func _on_building_cost_updated(cost):
	if listening:
		data["building_costs"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = cost


func _on_production_cost_updated(cost):
	if listening:
		data["production_costs"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = cost


func _on_import_cost_updated(cost):
	if listening:
		data["import_costs"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = cost


func _on_borrowed_money_updated(money):
	if listening:
		data["borrowed_money"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = money


func _on_available_money_updated(money):
	if listening:
		data["available_money"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = money


func _on_winter_energy_supply_updated(energy: float):
	if listening:
		data["winter_energy_supply"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = energy
	

func _on_summer_energy_supply_updated(energy: float):
	if listening:
		data["summer_energy_supply"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = energy
	
	
func _on_winter_energy_import_updated(energy):
	print("turn: ", turn_to_register_data_in, ", energy: ", energy)
	print(data["winter_energy_import"])
	if listening:
		data["winter_energy_import"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = energy


func _on_land_use_updated(land_use):
	if listening:
		data["land_use"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = land_use


func _on_summer_energy_demand_updated(value):
	if listening:
		data["summer_demand"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = value
	
	
func _on_winter_energy_demand_updated(value):
	if listening:
		data["winter_demand"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = value
	
	
func _on_co2_emissions_updated(value):
	if listening:
		data["co2_emissions"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = value	


func _on_personnal_support_updated(value):
	if listening:
		data["personal_support"][Gameloop.start_year + (turn_to_register_data_in) * Gameloop.years_in_a_turn] = value * 100	


func _refresh_data():
	_on_building_cost_updated(MoneyManager.building_costs)
	_on_production_cost_updated(MoneyManager.total_production_costs)
	_on_import_cost_updated(MoneyManager.energy_import_cost)
	_on_borrowed_money_updated(MoneyManager.borrowed_money_amount)
	_on_available_money_updated(MoneyManager.available_money_amount)
	_on_winter_energy_supply_updated(Gameloop.supply_winter)
	_on_summer_energy_supply_updated(Gameloop.supply_summer)
	_on_winter_energy_import_updated(Gameloop.imported_energy_amount)
	_on_land_use_updated(Gameloop.land_use)
	_on_summer_energy_demand_updated(Gameloop.demand_summer)
	_on_winter_energy_demand_updated(Gameloop.demand_winter)
	_on_co2_emissions_updated(Gameloop.co2_emissions)
	_on_personnal_support_updated(PolicyManager.personal_support)


# Avoid listening to changes that we don't want to when the next turn is set
func _on_next_turn_button_pressed():
	listening = false
