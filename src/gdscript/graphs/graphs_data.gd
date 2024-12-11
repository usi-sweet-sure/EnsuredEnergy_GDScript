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
	Gameloop.next_turn.connect(_refresh_data)
	
	_refresh_data()

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
		
		
# This is used at _ready and on a new turn. Some data don't change when a new turn
# starts, but we want to to draw a point for that turn right away
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
	
	
func _on_co2_emissions_updated(value):
	data["co2_emissions"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = value	


func _on_personnal_support_updated(value):
	data["personal_support"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = value * 100	
