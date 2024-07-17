extends Node2D

var start_year: int = 2020
var n_turns: int = 10
var start_money: int = 250
var money_per_turn: int = 250
var current_turn: int = 1 #player action always take place in the following year
var green_energy_import_factor: float = 1.5
var debt_percentage_on_borrowed_money: int = 20

var demand_availability = Vector2(0.45, 0.55)
var year_list = []

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer
signal green_energy_import_on_updated
signal imported_energy_amount_updated
signal borrowed_money_amount_updated
signal available_money_amount_updated

signal next_turn
signal end

var demand_summer: int = 2000:
	set(new_value):
		demand_summer = new_value;
		#print("Summer demand updated : " + str(demand_summer))
		energy_demand_updated_summer.emit(new_value)
var demand_winter: int = 2200:
	set(new_value):
		demand_winter = new_value
		#print("Winter demand updated : " + str(demand_winter))
		energy_demand_updated_winter.emit(new_value)
var supply_summer: int = 0:
	set(new_value):
		supply_summer = new_value
		#print("Summer supply updated : " + str(supply_summer))
		energy_supply_updated_summer.emit(supply_summer)
var supply_winter: int = 0:
	set(new_value):
		supply_winter = new_value
		#print("Summer supply updated : " + str(supply_winter))
		#print("Winter supply updated : " + str(supply_winter))
		energy_supply_updated_winter.emit(supply_winter)
var energy_import_cost: int = 0:
	get:
		if not green_energy_import_on:
			return floor(imported_energy_amount * 0.01)
		else:
			return round(floor(imported_energy_amount * 0.01) * green_energy_import_factor)
var green_energy_import_on := false:
	set(new_value):
		green_energy_import_on = new_value
		green_energy_import_on_updated.emit(green_energy_import_on)
var imported_energy_amount: int = 0:
	set(new_value):
		imported_energy_amount = new_value
		print("Imported amount : ", imported_energy_amount)
		imported_energy_amount_updated.emit(imported_energy_amount)
var borrowed_money_amount: int = 0:
	set(new_value):
		borrowed_money_amount = new_value
		borrowed_money_amount_updated.emit(borrowed_money_amount)
		available_money_amount_updated.emit(available_money_amount)
var available_money_amount: int = 0:
	get:
		return borrowed_money_amount # E. add other money resources as we add them
		

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in n_turns + 1:
		year_list.append(start_year + (i * 3))

func _update_supply():
	var summer = 0
	var winter = 0
	var total_production_costs = 0
	for power_plant in get_tree().get_nodes_in_group("PP"):
		if power_plant.is_alive:
			summer += power_plant.capacity * power_plant.availability.x
			winter += power_plant.capacity * power_plant.availability.y
			total_production_costs += power_plant.production_cost
	supply_summer = summer
	supply_winter = winter
	print(total_production_costs)
	
	
func _check_supply():
	if supply_summer >= demand_summer && supply_winter >= demand_winter:
		return true
	else:
		return false


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
