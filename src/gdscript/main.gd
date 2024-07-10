extends Node2D

@export var start_year: int = 2022
@export var n_turns: int = 10
@export var start_money: int = 250
@export var money_per_turn: int = 250


var demand_summer: int = 200
var demand_winter: int = 210
var supply_summer: int = 0
var supply_winter: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)

func _update_supply():
	for power_plant in get_tree().get_nodes_in_group("PP"):
		supply_summer += power_plant.capacity * power_plant.availability.x
		supply_winter += power_plant.capacity * power_plant.availability.y
	
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
