extends Node2D

var start_year: int = 2020
var n_turns: int = 10
var start_money: int = 250
var money_per_turn: int = 250
var current_turn: int = 1 #player action always take place in the following year
var green_energy_import_factor: float = 1.5

var demand_availability = Vector2(0.45, 0.55)
var year_list = []

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer
signal energy_import_cost_updated
signal green_energy_import_on_updated

signal next_turn
signal end

var demand_summer: int = 15000:
	set(new_value):
		demand_summer = new_value;
		print("Summer demand updated : " + str(demand_summer))
		energy_demand_updated_summer.emit(new_value)
var demand_winter: int = 10000:
	set(new_value):
		demand_winter = new_value
		print("Winter demand updated : " + str(demand_winter))
		energy_demand_updated_winter.emit(new_value)
var supply_summer: int = 0:
	set(new_value):
		supply_summer = new_value
		print("Summer supply updated : " + str(supply_summer))
		energy_supply_updated_summer.emit(supply_summer)
var supply_winter: int = 0:
	set(new_value):
		supply_winter = new_value
		print("Summer supply updated : " + str(supply_winter))
		energy_supply_updated_winter.emit(supply_winter)
var energy_import_cost: int = 0:
	get:
		if not green_energy_import_on:
			return energy_import_cost
		else:
			return round(energy_import_cost * green_energy_import_factor)
	set(new_value):
		energy_import_cost = new_value
		energy_import_cost_updated.emit(energy_import_cost)
var green_energy_import_on := false:
	set(new_value):
		green_energy_import_on = new_value
		green_energy_import_on_updated.emit(green_energy_import_on)


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)
	
	for i in n_turns + 1:
		year_list.append(start_year + (i * 3))

func _update_supply():
	for power_plant in get_tree().get_nodes_in_group("PP"):
		supply_summer += power_plant.capacity * power_plant.availability.x
		supply_winter += power_plant.capacity * power_plant.availability.y
	
func _check_supply():
	if supply_summer >= demand_summer && supply_winter >= demand_winter:
		return true
	else:
		return false
	
func _on_request_finished(_result, _response_code, _headers, _body):
	_update_supply()
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
