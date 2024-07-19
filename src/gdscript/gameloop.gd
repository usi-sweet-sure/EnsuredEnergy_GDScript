extends Node2D

var start_year: int = 2022
var n_turns: int = 10
var start_money: int = 250
var money_per_turn: int = 250
var current_turn: int = 1 #player action always take place in the following year
var green_energy_import_factor: float = 1.5

var demand_availability = Vector2(0.45, 0.55)
var year_list = []
var all_power_plants
var ups_list = {
	"186": 0,
	"151": 0,
	"162": 0,
	"163": 0,
	"189": 0,
	"192": 0,
	"170": 0,
	"171": 0,
	"246": 0
	}

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer
signal energy_import_cost_updated
signal green_energy_import_on_updated
signal imported_energy_amount_updated

signal next_turn
signal end

var demand_summer: int = 1000:
	set(new_value):
		demand_summer = new_value;
		#print("Summer demand updated : " + str(demand_summer))
		energy_demand_updated_summer.emit(new_value)
var demand_winter: int = 1200:
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
var imported_energy_amount: int = 0:
	set(new_value):
		imported_energy_amount = new_value
		#print("Imported amount : ", imported_energy_amount)
		imported_energy_amount_updated.emit(imported_energy_amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	all_power_plants = get_tree().get_nodes_in_group("PP")
	for i in n_turns + 1:
		year_list.append(start_year + (i * 3))
		
	next_turn.connect(_send_prm_ups)

func _update_supply():
	all_power_plants = get_tree().get_nodes_in_group("PP")
	var summer = 0
	var winter = 0
	var total_production_costs = 0
	for power_plant in all_power_plants:
		if power_plant.is_alive:
			summer += power_plant.capacity * power_plant.availability.x
			winter += power_plant.capacity * power_plant.availability.y
			total_production_costs += power_plant.production_cost
	supply_summer = summer
	supply_winter = winter
	#print(total_production_costs)
	
	
func _check_supply():
	return (supply_summer >= demand_summer && 
	supply_winter + imported_energy_amount >= demand_winter)
	

func _send_prm_ups():
	for i in ups_list:
		Context1.prm_id = i
		Context1.yr = Gameloop.year_list[Gameloop.current_turn-1]
		Context1.tj = ups_list[i]
		Context1.prm_ups()
		await Context1.http1.request_completed
		 

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
