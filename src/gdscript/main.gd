extends Node2D

@export var start_year: int = 2022
@export var n_turns: int = 10
@export var start_money: int = 250
@export var money_per_turn: int = 250


signal energy_supply_updated_winter
signal energy_supply_updated_summer

var demand_summer: int = 200
var demand_winter: int = 210
var supply_summer: int = 0:
	set(value):
		energy_supply_updated_summer.emit(value)
var supply_winter: int = 0:
	set(value):
		energy_supply_updated_winter.emit(value)


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_supply()

func _update_supply():
	for power_plant in get_tree().get_nodes_in_group("PP"):
		supply_summer += power_plant.capacity * power_plant.availability.x
		supply_winter += power_plant.capacity * power_plant.availability.y
	print(supply_summer)
	
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
