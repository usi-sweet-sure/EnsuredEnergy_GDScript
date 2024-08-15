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
# In any case, graphs_window.gd doesn't know the form of the data, it is only
# needed that "get_data_set" returns a dictionnary of the form
#	{
#		x: float = y: float,
#		x = y,
#		...
#	}
# "graphs_window.gd" takes care of everything, so x and y have to be the real
# values you want to display, nothing else to do appart from setting axis values
# in "graphs_window.gd" context that goes with the values you want to display.
var data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	_add_new_data_set("summer_demand")
	_add_new_data_set("winter_demand")
	_add_new_data_set("building_costs")
	_add_new_data_set("production_costs")
	_add_new_data_set("import_costs")
	_add_new_data_set("borrowed_money")
	_add_new_data_set("available_money")
	_add_new_data_set("winter_energy_supply")
	_add_new_data_set("summer_energy_supply")
	_add_new_data_set("winter_energy_import")
	_add_new_data_set("land_use")
	
	Gameloop.building_costs_updated.connect(_on_building_cost_updated)
	Gameloop.powerplants_production_costs_updated.connect(_on_production_cost_updated)
	Gameloop.energy_import_cost_updated.connect(_on_import_cost_updated)
	Gameloop.borrowed_money_amount_updated.connect(_on_borrowed_money_updated)
	Gameloop.available_money_amount_updated.connect(_on_available_money_updated)
	Gameloop.energy_supply_updated_winter.connect(_on_winter_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_summer_energy_supply_updated)
	Gameloop.imported_energy_amount_updated.connect(_on_winter_energy_import_updated)
	Gameloop.land_use_updated.connect(_on_land_use_updated)
	Gameloop.energy_demand_updated_summer.connect(_on_summer_energy_demand_updated)
	Gameloop.energy_demand_updated_winter.connect(_on_winter_energy_demand_updated)
	Gameloop.next_turn.connect(_refresh_data)
	
	_refresh_data()

# Must return a dictionnary of the form
#	{
#		x: float = y: float,
#		x = y,
#		...
#	}
func get_data_set(key_name: String):
	_add_new_data_set(key_name) # Initializes empty data if needed 
	return data[key_name]


func _add_new_data_set(key_name: String):
	if not data.has(key_name):
		data[key_name] = {}
		
		
# This is used at _ready and on a new turn, since some data don't change when a new
# starts, but we want to to draw a point for that turn anyway
func _refresh_data():
	_on_building_cost_updated(Gameloop.building_costs)
	_on_production_cost_updated(Gameloop.powerplants_production_costs)
	_on_import_cost_updated(Gameloop.powerplants_production_costs)
	_on_borrowed_money_updated(Gameloop.borrowed_money_amount)
	_on_available_money_updated(Gameloop.available_money_amount)
	_on_winter_energy_supply_updated(Gameloop.supply_winter)
	_on_summer_energy_supply_updated(Gameloop.supply_summer)
	_on_winter_energy_import_updated(Gameloop.imported_energy_amount)
	_on_land_use_updated(Gameloop.land_use)
	_on_summer_energy_demand_updated(Gameloop.demand_summer)
	_on_winter_energy_demand_updated(Gameloop.demand_winter)

func _on_building_cost_updated(cost):
	data["building_costs"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = cost


func _on_production_cost_updated(cost):
	data["production_costs"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = cost


func _on_import_cost_updated(cost):
	data["import_costs"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = cost


func _on_borrowed_money_updated(money):
	data["borrowed_money"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = money


func _on_available_money_updated(money):
	data["available_money"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = money


func _on_winter_energy_supply_updated(energy: float):
	data["winter_energy_supply"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = energy
	

func _on_summer_energy_supply_updated(energy: float):
	data["summer_energy_supply"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = energy
	
	
func _on_winter_energy_import_updated(energy):
	data["winter_energy_import"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = energy


func _on_land_use_updated(land_use):
	data["land_use"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = land_use


func _on_summer_energy_demand_updated(value):
	data["summer_demand"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = value
	
func _on_winter_energy_demand_updated(value):
	data["winter_demand"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = value	
