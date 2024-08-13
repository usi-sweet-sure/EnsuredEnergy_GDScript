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
	Gameloop.building_costs_updated.connect(_on_building_cost_updated)
	_add_new_data_set("summer_demand")
	_add_new_data_set("winter_demand")
	_add_new_data_set("building")
	
	for i in Gameloop.total_number_of_turns + 1:
		data["summer_demand"][Gameloop.start_year + (Gameloop.years_in_a_turn * i)] = Gameloop.demand_summer + (5 * i)
	for i in Gameloop.total_number_of_turns + 1:
		data["winter_demand"][Gameloop.start_year + (Gameloop.years_in_a_turn * i)] = Gameloop.demand_summer + (10 * i)
	
	_on_building_cost_updated(0)
	

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
		
		
func _on_building_cost_updated(cost):
	data["building"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = cost
