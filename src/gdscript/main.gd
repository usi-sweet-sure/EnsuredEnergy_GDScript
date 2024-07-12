extends Node2D

@export var start_year: int = 2022
@export var n_turns: int = 10
@export var start_money: int = 250
@export var money_per_turn: int = 250

var demand_availability = Vector2(0.45, 0.55)
var year_list = []

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer

var demand_summer: int = 200:
	set(value):
		energy_demand_updated_summer.emit(value)
var demand_winter: int = 210:
	set(value):
		energy_demand_updated_winter.emit(value)
var supply_summer: int = 0:
	set(value):
		energy_supply_updated_summer.emit(value)
var supply_winter: int = 0:
	set(value):
		energy_supply_updated_winter.emit(value)


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
	print(supply_summer)
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
