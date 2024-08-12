extends Node

# Stores all the data needed for the graphs.
# This is a dictionnary of the form
# data = {
#	 "name" = {
#		 "2022" = 100.0,
#		 "2023" = 140.0,
#		 ...
#		 },
#	 "name" = {
#		 "2022" = 200.0,
#		 "2023" = 350.0,
#		 ...
#		 },
# }
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
	
func get_data_set(key_name: String):
	_add_new_data_set(key_name)
	return data[key_name]


func _on_building_cost_updated(cost):
	data["building"][Gameloop.start_year + (Gameloop.current_turn - 1) * Gameloop.years_in_a_turn] = cost


func _add_new_data_set(key_name: String):
	if not data.has(key_name):
		data[key_name] = {}
