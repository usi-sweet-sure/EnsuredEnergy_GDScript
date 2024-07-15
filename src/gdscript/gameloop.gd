extends Node2D

var start_year: int = 2020
var n_turns: int = 10
var start_money: int = 250
var money_per_turn: int = 250
var current_turn: int = 1 #player action always take place in the following year

var demand_availability = Vector2(0.45, 0.55)
var year_list = []

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer

signal next_turn

var demand_summer: int = 200:
	set(new_value):
		demand_summer = new_value;
		energy_demand_updated_summer.emit(new_value)
var demand_winter: int = 210:
	set(new_value):
		demand_winter = new_value
		energy_demand_updated_winter.emit(new_value)
var supply_summer: int = 0:
	set(new_value):
		supply_summer = new_value
		energy_supply_updated_summer.emit(new_value)
var supply_winter: int = 0:
	set(new_value):
		supply_winter = new_value
		energy_supply_updated_winter.emit(new_value)


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)
	
	for i in n_turns + 1:
		year_list.append(start_year + (i * 3))
	print(year_list)

func _update_supply():
	supply_summer = 0
	supply_winter = 0
	for power_plant in get_tree().get_nodes_in_group("PP"):
		supply_summer += power_plant.capacity * power_plant.availability.x
		supply_winter += power_plant.capacity * power_plant.availability.y
	print(supply_summer, " ", supply_winter)
	
func _check_supply():
	if supply_summer >= demand_summer && supply_winter >= demand_winter:
		return true
	else:
		return false
	
func _on_request_finished(result, response_code, headers, body):
	_update_supply()
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
